--[[
    TITANIC_AUTO.lua  v2.4.1
    Titanic placeId=294790062
    Ship survival helper: waits for the save event (StartSaving), then auto
    steers the helm, flashes the Morse lamp, and closes boiler flaps
    Rayfield UI, English only, credit: made by valexcryzer
]]

local GENV = getgenv()
if type(GENV.__TIT_AUTO_STOP) == "function" then
    pcall(GENV.__TIT_AUTO_STOP)
    GENV.__TIT_AUTO_STOP = nil
end
if type(GENV.__BB_ESP_STOP) == "function" then
    pcall(GENV.__BB_ESP_STOP)
    GENV.__BB_ESP_STOP = nil
end
if type(GENV.__TLF_ESP_STOP) == "function" then
    pcall(GENV.__TLF_ESP_STOP)
    GENV.__TLF_ESP_STOP = nil
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer

local stopFlag = false
local startedAt = os.clock()
local warpAndSteerLeft = nil

local Config = {
    OnlyDuringEvent = true, -- block all actions unless StartSaving is true
    FullAuto = true, -- master: when event opens, run everything (runner + bell) automatically
    SteerLeftAfterCaptain = true, -- user rule: after captain order, warp to wheel & steer left
    ArmOnEvent = false,
    RunOnEvent = false, -- event runner: physically travel & press every station
    RunHopSize = 30,
    AutoWheel = false,
    WheelInterval = 0.25,
    AutoLamp = false,
    LampInterval = 0.45,
    AutoFlaps = false,
    FlapInterval = 2.5,
    FlapBlinkBack = true,
    AutoBell = false,
    BellInterval = 2.0,
    BellRings = 3,
    AutoCaptain = false,
    CaptainInterval = 2.0,
    AutoWhistle = false,
}

local RAYFIELD_URLS = {
    "https://sirius.menu/rayfield",
    "https://raw.githubusercontent.com/jensonhirst/Rayfield/main/source",
}

local function FetchSource(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and type(res) == "string" and #res > 100 then return res end
    ok, res = pcall(function() return request({ Url = url, Method = "GET" }) end)
    if ok and type(res) == "table" then
        local b = res.Body or res.body
        if type(b) == "string" and #b > 100 then return b end
    end
    return nil
end

local function CleanupOldUI()
    pcall(function()
        local hui = gethui and gethui() or game:GetService("CoreGui")
        for _, c in ipairs(hui:GetChildren()) do
            if c.Name == "Rayfield" or c.Name:find("^Rayfield%-") then
                pcall(function() c:Destroy() end)
            end
        end
    end)
end

local function GetRayfieldMain()
    local ok, hui = pcall(function()
        return (gethui and gethui()) or game:GetService("CoreGui")
    end)
    if not ok or not hui then return nil end
    for _, c in ipairs(hui:GetChildren()) do
        if c:IsA("ScreenGui") and c.Name == "Rayfield" then
            local m = c:FindFirstChild("Main")
            if m then return m end
        end
    end
    return nil
end

local function SnapWindowToBottom()
    pcall(function()
        local main = GetRayfieldMain()
        if not main then return end
        local h = main.AbsoluteSize.Y
        if h < 10 then h = 475 end
        main.Position = UDim2.new(0.5, 0, 1, -(h / 2 + 16))
    end)
end

local Rayfield
do
    CleanupOldUI()
    getgenv().__RAYFIELD = nil
    for _ = 1, 3 do
        for _, url in ipairs(RAYFIELD_URLS) do
            local src = FetchSource(url)
            if src then
                local okL, lib = pcall(function() return loadstring(src)() end)
                if okL and type(lib) == "table" and lib.CreateWindow then
                    getgenv().__RAYFIELD = lib
                    Rayfield = lib
                    break
                end
            end
        end
        if Rayfield then break end
        task.wait(0.4)
    end
    if not Rayfield then
        warn("[TIT] Rayfield failed to load.")
        return
    end
end

local statusPara = nil

local notifyFn = function(title, msg, dur)
    pcall(function()
        Rayfield:Notify({
            Title = title,
            Content = tostring(msg),
            Duration = dur or 4,
            Image = 4483362458,
        })
    end)
end

local stats = {
    fires = 0,
    fails = 0,
    lastFire = "-",
    blocked = 0,
    lastBlockedAt = 0,
    eventOpen = false,
    flapsClosed = 0,
    flapsFail = 0,
}

local GameplayFolder = nil
pcall(function()
    GameplayFolder = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("Gameplay")
end)

local function fireRemote(nodeName, ...)
    if not GameplayFolder then return false end
    local node = GameplayFolder:FindFirstChild(nodeName)
    if not node then return false end
    local args = { ... }
    local ok = pcall(function()
        node:FireServer(table.unpack(args))
    end)
    if ok then stats.fires = stats.fires + 1 else stats.fails = stats.fails + 1 end
    return ok
end

-- deeper remote paths like "Gui.TelegraphOrderRetrieve" (RemoteEvents.Gui.X)
local RemoteRoot = nil
pcall(function() RemoteRoot = ReplicatedStorage:WaitForChild("RemoteEvents") end)
local function fireRemotePath(pathStr, ...)
    if not RemoteRoot then return false end
    local node = RemoteRoot
    for part in string.gmatch(tostring(pathStr), "[^.]+") do
        node = node and node:FindFirstChild(part)
    end
    if not node then return false end
    local args = { ... }
    local ok = pcall(function()
        node:FireServer(table.unpack(args))
    end)
    if ok then stats.fires = stats.fires + 1 else stats.fails = stats.fails + 1 end
    return ok
end

local lastWheel = 0
local lastLamp = 0
local lastFlap = 0
local lastBell = 0
local bellRingsUsed = 0
local flapStamp = {} -- per-damper press cooldown: prevents toggle ping-pong on replication lag
local lastCaptain = 0
local lastWhistle = 0

local eventOpen = false
local eventCheckAt = 0

local wheelToggle = 0
local lampPhase = 0
local lampSide = "Port"
local flapIdx = 0
local wheelNum = 1
local steerRight = false -- adaptive: left default; flipped when the server marker sits on a Right wheel
local noclipConn = nil

local heartbeatConn = RunService.Heartbeat:Connect(function()
    if stopFlag then return end
    local now = os.clock()

    -- refresh event state (max every 0.2 s)
    if now - eventCheckAt > 0.2 then
        eventCheckAt = now
        pcall(function()
            local ssts = ReplicatedStorage:FindFirstChild("SaveTheShipValues")
            local ss = ssts and ssts:FindFirstChild("StartSaving")
            eventOpen = ss and ss.Value or false
        end)
        stats.eventOpen = eventOpen
    end

    local allow = (not Config.OnlyDuringEvent) or eventOpen
    local anyActive = Config.AutoWheel or Config.AutoLamp or Config.AutoFlaps
        or Config.AutoBell or Config.AutoCaptain or Config.AutoWhistle
    if not allow and anyActive then
        if now - (stats.lastBlockedAt or 0) > 0.5 then
            stats.blocked = (stats.blocked or 0) + 1
            stats.lastBlockedAt = now
        end
        return
    end

    -- steering: fires left (default) or right when the wheel marker says so, wheel 1/2 alternate
    if allow and Config.AutoWheel and (now - lastWheel >= (Config.WheelInterval or 0.25)) then
        lastWheel = now
        wheelToggle = wheelToggle + 1
        if wheelToggle % 2 == 0 then wheelNum = (wheelNum == 1) and 2 or 1 end
        fireRemotePath("Gameplay.WheelSteerEvent", steerRight, wheelNum)
        stats.lastFire = "wheel " .. (steerRight and "R" or "L") .. wheelNum
    end

    -- morse lamp signal: pulse on/off, swap side every 6 pulses
    if Config.AutoLamp and (now - lastLamp >= (Config.LampInterval or 0.45)) then
        lastLamp = now
        lampPhase = lampPhase + 1
        local on = (lampPhase % 2 == 1)
        fireRemote("MorseLampSwitch", on, lampSide)
        if lampPhase % 6 == 0 then
            lampSide = (lampSide == "Port") and "Starboard" or "Port"
        end
        stats.lastFire = "lamp"
    end

    -- boiler dampers: close every flap that is currently OPEN
    -- Prompt:Trigger() does not exist -> use fireproximityprompt / InputHold sequence
    -- server only accepts prompts within MaxActivationDistance -> blink into range first
    if Config.AutoFlaps and (now - lastFlap >= (Config.FlapInterval or 2.5)) then
        lastFlap = now
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local ssm = Workspace:FindFirstChild("ServerShipMovement")
        local boilers = ssm and ssm:FindFirstChild("Boilers")
        if hrp and boilers then
            local homeCFrame = hrp.CFrame
            local closed = 0
            local skipped = 0
            for _, boiler in ipairs(boilers:GetChildren()) do
                if string.sub(boiler.Name, 1, 6) == "Boiler" then
                    for _, flap in ipairs(boiler:GetChildren()) do
                        if string.find(flap.Name, "Flap", 1, true) then
                            local stampKey = boiler.Name .. "/" .. flap.Name
                            local cooled = (not flapStamp[stampKey])
                                or ((os.clock() - flapStamp[stampKey]) > 1.6)
                            local bv = flap:FindFirstChild("FlapOpen")
                            local pp = flap:FindFirstChildWhichIsA("ProximityPrompt")
                            if cooled and pp and pp.Enabled and bv and bv.Value then
                                local part = pp.Parent
                                if part then
                                    local dist = (part.Position - hrp.Position).Magnitude
                                    if dist > (pp.MaxActivationDistance or 12) then
                                        pcall(function()
                                            hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                                        end)
                                        task.wait(0.05)
                                    end
                                    local ok = false
                                    if type(fireproximityprompt) == "function" then
                                        ok = pcall(function() fireproximityprompt(pp) end)
                                    end
                                    if not ok then
                                        ok = pcall(function()
                                            pp:InputHoldBegin()
                                            task.wait(math.max(pp.HoldDuration, 0.02))
                                            pp:InputHoldEnd()
                                        end)
                                    end
                                    flapStamp[stampKey] = os.clock()
                                    if ok then
                                        -- settle: wait for server to flip FlapOpen (max 0.4 s)
                                        local accepted = false
                                        local t0 = os.clock()
                                        while (os.clock() - t0) < 0.4 do
                                            task.wait(0.08)
                                            local okb, v = pcall(function() return bv.Value end)
                                            if okb and v == false then
                                                accepted = true
                                                break
                                            end
                                        end
                                        if accepted then closed = closed + 1 else skipped = skipped + 1 end
                                    else
                                        skipped = skipped + 1
                                    end
                                    task.wait(0.06)
                                end
                            end
                        end
                    end
                end
            end
            if Config.FlapBlinkBack then
                pcall(function() hrp.CFrame = homeCFrame end)
            end
            stats.flapsClosed = (stats.flapsClosed or 0) + closed
            stats.flapsFail = (stats.flapsFail or 0) + skipped
            if closed + skipped > 0 then
                stats.lastFire = "dampers " .. closed .. "/" .. (closed + skipped)
            end
        end
    end

    -- bell: auto-press ProximityPrompt on BellPart directly (NO remote, registers in-game milestone)
    if Config.AutoBell and bellRingsUsed < (Config.BellRings or 3)
        and (now - lastBell >= (Config.BellInterval or 2.0)) then
        lastBell = now
        bellRingsUsed = bellRingsUsed + 1
        local pressed = false
        pcall(function()
            local ssm = Workspace:FindFirstChild("ServerShipMovement")
            local bell = ssm and ssm:FindFirstChild("CrowsNestBell")
            local bellPart = bell and bell:FindFirstChild("BellPart")
            local pp = bellPart and bellPart:FindFirstChildWhichIsA("ProximityPrompt")
            if not pp then pp = bell and bell:FindFirstChildWhichIsA("ProximityPrompt", true) end
            if pp and pp.Enabled then
                local hrp = getHRP()
                local bpos = posOf(pp.Parent)
                if hrp and bpos and (bpos - hrp.Position).Magnitude > (pp.MaxActivationDistance or 7) then
                    runnerWarp(bpos + Vector3.new(0, 2.5, 0))
                    task.wait(0.05)
                end
                if type(fireproximityprompt) == "function" then
                    fireproximityprompt(pp)
                    pressed = true
                else
                    pp:InputHoldBegin()
                    task.wait(math.max(pp.HoldDuration, 0.02))
                    pp:InputHoldEnd()
                    pressed = true
                end
            end
        end)
        stats.lastFire = "bell prompt " .. (pressed and "OK" or "FAIL") .. " (" .. bellRingsUsed .. "/" .. (Config.BellRings or 3) .. ")"
    end

    -- captain telegraph
    if Config.AutoCaptain and (now - lastCaptain >= (Config.CaptainInterval or 2.0)) then
        lastCaptain = now
        fireRemote("CaptainOrdersEvent", LP, nil)
        stats.lastFire = "captain"
    end

    -- whistle lever
    if Config.AutoWhistle and (now - lastWhistle >= 2.0) then
        lastWhistle = now
        fireRemote("WhistleLever")
    end
end)

-- ============ EVENT RUNNER: physically travel to every station and press ============
local function getHRP()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function posOf(node)
    if not node then return nil end
    if node:IsA("BasePart") then return node.Position end
    local p = node:FindFirstChildWhichIsA("BasePart", true)
    if p then return p.Position end
    local ok2, piv = pcall(function() return node:GetPivot().Position end)
    if ok2 then return piv end
    return nil
end

-- warp straight to a target position (instant CFrame, tiny settle delay)
local function runnerWarp(targetPos)
    local hrp = getHRP()
    if not hrp or not targetPos then return end
    pcall(function() hrp.CFrame = CFrame.new(targetPos.X, targetPos.Y + 3, targetPos.Z) end)
    task.wait(0.06)
end

-- ============ TARGET-SPECIFIC YELLOW / GREEN MARKER SCAN ============
-- Scans ONLY the exact interactive stations (16 objects) instead of entire ship tree.
-- Zero lag, zero freeze, instant detection.
local function isGreenColor(c)
    return c and (c.G > 0.45) and (c.R < 0.4) and (c.B < 0.4)
end

local function isYellowColor(c)
    return c and (c.R > 0.65) and (c.G > 0.55) and (c.B < 0.55)
end

local seenGreen = {} -- stationName -> timestamp

local function checkMarkerOnInstance(obj)
    if not obj then return nil end
    local res = nil
    for _, child in ipairs(obj:GetChildren()) do
        if child:IsA("Highlight") and child.Enabled then
            if isGreenColor(child.FillColor) or isGreenColor(child.OutlineColor) then return "green" end
            if isYellowColor(child.FillColor) or isYellowColor(child.OutlineColor) then res = "yellow" end
            if not res then res = "yellow" end
        elseif child:IsA("SelectionBox") and child.Visible then
            if isGreenColor(child.Color3) then return "green" end
            if isYellowColor(child.Color3) then res = "yellow" end
            if not res then res = "yellow" end
        elseif child:IsA("BillboardGui") and child.Enabled then
            return "yellow"
        end
    end
    return res
end

local function getStationMarker(station)
    if not station then return nil end
    local m = checkMarkerOnInstance(station)
    if m then return m end
    for _, handleName in ipairs({ "TelegraphHandle", "BellPart", "ProximityPrompt", "HandleController", "ShovelMain" }) do
        local h = station:FindFirstChild(handleName)
        if h then
            m = checkMarkerOnInstance(h)
            if m then return m end
        end
    end
    -- Check all descendants (e.g. flaps, subparts)
    for _, d in ipairs(station:GetDescendants()) do
        m = checkMarkerOnInstance(d)
        if m then return m end
    end
    -- Check if any Highlight or SelectionBox in Workspace has Adornee set to station or its descendants
    for _, child in ipairs(Workspace:GetChildren()) do
        if child:IsA("Highlight") and child.Enabled and child.Adornee then
            if child.Adornee == station or child.Adornee:IsDescendantOf(station) then
                if isGreenColor(child.FillColor) or isGreenColor(child.OutlineColor) then return "green" end
                return "yellow"
            end
        elseif child:IsA("SelectionBox") and child.Visible and child.Adornee then
            if child.Adornee == station or child.Adornee:IsDescendantOf(station) then
                if isGreenColor(child.Color3) then return "green" end
                return "yellow"
            end
        end
    end
    return nil
end

local function isStationGreen(node)
    if not node then return false end
    local nm = node.Name
    -- Boilers: if any flap is still physically open, this boiler is NOT completed
    if string.sub(nm, 1, 6) == "Boiler" then
        for _, flap in ipairs(node:GetChildren()) do
            local fo = flap:FindFirstChild("FlapOpen")
            local pp = flap:FindFirstChildWhichIsA("ProximityPrompt")
            if fo and fo.Value == true and pp and pp.Enabled then
                return false
            end
        end
    end
    if seenGreen[nm] and (os.clock() - seenGreen[nm] < 6) then
        return true
    end
    local m = getStationMarker(node)
    if m == "green" then
        seenGreen[nm] = os.clock()
        return true
    end
    return false
end

local function getOrderOfSaving()
    local oos = nil
    pcall(function()
        local rep = game:GetService("ReplicatedStorage")
        local stsv = rep:FindFirstChild("SaveTheShipValues")
        local v = stsv and stsv:FindFirstChild("OrderOfSaving")
        if v then oos = v.Value end
    end)
    return oos
end

local function scanMarkers()
    local found = {
        telegraph = nil,
        phones = {},
        boiler = nil,
        bell = false,
        teleNode = nil,
        boilerNode = nil,
        phoneNodes = {},
        wheelSide = nil,
        wheelNode = nil,
        greenNodes = {},
    }

    local oos = getOrderOfSaving()
    local ssm = Workspace:FindFirstChild("ServerShipMovement")
    local bow = Workspace:FindFirstChild("Titanic") and Workspace.Titanic:FindFirstChild("Bow")
    local si = bow and bow:FindFirstChild("ScriptImportance")
    local cm = si and si:FindFirstChild("ConstraintMachinery")

    -- 1) Crow's Nest Bell (Step 0):
    if oos == nil or oos == 0 then
        local bellObj = (ssm and ssm:FindFirstChild("CrowsNestBell")) or (cm and cm:FindFirstChild("CrowsNestBell"))
        local bellPart = bellObj and bellObj:FindFirstChild("BellPart")
        local bellM = getStationMarker(bellObj) or getStationMarker(bellPart)
        if bellM == "green" then
            found.greenNodes["Bell"] = true
            seenGreen["Bell"] = os.clock()
        elseif bellM == "yellow" or oos == 0 then
            if not (seenGreen["Bell"] and (os.clock() - seenGreen["Bell"] < 6)) then
                found.bell = true
            end
        end
    end

    -- 2) Telephones (Step 1):
    if (oos == nil or oos == 1) and ssm then
        for _, pName in ipairs({ "Telephone1", "Telephone2" }) do
            local ph = ssm:FindFirstChild(pName)
            if ph then
                local pm = getStationMarker(ph)
                if pm == "green" then
                    found.greenNodes[pName] = true
                    seenGreen[pName] = os.clock()
                elseif pm == "yellow" or (oos == 1 and not (seenGreen[pName] and (os.clock() - seenGreen[pName] < 6))) then
                    found.phones[pName] = true
                    found.phoneNodes[pName] = ph
                end
            end
        end
    end

    -- 3) Steering Wheels (Step 2):
    if (oos == nil or oos == 2) and ssm then
        for _, wName in ipairs({ "LeftWheel2", "LeftWheel1" }) do
            local w = ssm:FindFirstChild(wName)
            if w then
                local wm = getStationMarker(w)
                if wm == "green" then
                    found.greenNodes[wName] = true
                    seenGreen[wName] = os.clock()
                elseif wm == "yellow" and not found.wheelSide then
                    if not (seenGreen[wName] and (os.clock() - seenGreen[wName] < 6)) then
                        found.wheelSide = "Left"
                        found.wheelNode = w
                    end
                end
            end
        end
        for _, wName in ipairs({ "RightWheel2", "RightWheel1" }) do
            local w = ssm:FindFirstChild(wName)
            if w then
                local wm = getStationMarker(w)
                if wm == "green" then
                    found.greenNodes[wName] = true
                    seenGreen[wName] = os.clock()
                elseif wm == "yellow" and not found.wheelSide then
                    if not (seenGreen[wName] and (os.clock() - seenGreen[wName] < 6)) then
                        found.wheelSide = "Right"
                        found.wheelNode = w
                    end
                end
            end
        end
        if oos == 2 and not found.wheelSide then
            local lw = ssm:FindFirstChild("LeftWheel2") or ssm:FindFirstChild("LeftWheel1")
            if lw and not (seenGreen[lw.Name] and (os.clock() - seenGreen[lw.Name] < 6)) then
                found.wheelSide = "Left"
                found.wheelNode = lw
            end
        end
    end

    -- 4) Telegraphs (Step 3):
    if (oos == nil or oos == 3) and cm then
        local tgs = cm:FindFirstChild("Telegraphs")
        if tgs then
            for i = 1, 5 do
                local tg = tgs:FindFirstChild("Telegraph" .. i)
                if tg then
                    local tm = getStationMarker(tg)
                    local tgName = "Telegraph" .. i
                    if tm == "green" then
                        found.greenNodes[tgName] = true
                        seenGreen[tgName] = os.clock()
                    elseif tm == "yellow" and not found.telegraph then
                        if not (seenGreen[tgName] and (os.clock() - seenGreen[tgName] < 6)) then
                            found.telegraph = i
                            found.teleNode = tg
                        end
                    end
                end
            end
            if oos == 3 and not found.telegraph then
                for i = 1, 5 do
                    local tg = tgs:FindFirstChild("Telegraph" .. i)
                    local tgName = "Telegraph" .. i
                    if tg and not (seenGreen[tgName] and (os.clock() - seenGreen[tgName] < 6)) then
                        found.telegraph = i
                        found.teleNode = tg
                        break
                    end
                end
            end
        end
    end

    -- 5) Boilers (Step 4 only!):
    if (oos == nil or oos >= 4) and ssm then
        local boilers = ssm:FindFirstChild("Boilers")
        if boilers then
            for _, letter in ipairs({ "A", "B", "C", "D" }) do
                local bName = "Boiler" .. letter
                local b = boilers:FindFirstChild(bName)
                if b then
                    local bm = getStationMarker(b)
                    if bm == "green" then
                        found.greenNodes[bName] = true
                        seenGreen[bName] = os.clock()
                    elseif bm == "yellow" and not found.boiler then
                        if not (seenGreen[bName] and (os.clock() - seenGreen[bName] < 6)) then
                            found.boiler = bName
                            found.boilerNode = b
                        end
                    end
                end
            end
            -- If no boiler has a yellow marker, check which boiler has an open flap:
            if not found.boiler then
                for _, letter in ipairs({ "A", "B", "C", "D" }) do
                    local bName = "Boiler" .. letter
                    local b = boilers:FindFirstChild(bName)
                    if b and not (seenGreen[bName] and (os.clock() - seenGreen[bName] < 6)) then
                        for _, flap in ipairs(b:GetChildren()) do
                            local fo = flap:FindFirstChild("FlapOpen")
                            local pp = flap:FindFirstChildWhichIsA("ProximityPrompt")
                            if fo and fo.Value == true and pp and pp.Enabled then
                                local stampKey = bName .. "/" .. flap.Name
                                if not (seenGreen[stampKey] and (os.clock() - seenGreen[stampKey] < 6)) then
                                    found.boiler = bName
                                    found.boilerNode = b
                                    break
                                end
                            end
                        end
                        if found.boiler then break end
                    end
                end
            end
        end
    end

    return found
end

-- read the Save event instruction text (server states the task in plain english)
local function readGameProgress()
    local txt = ""
    pcall(function()
        local pgui = LP:FindFirstChild("PlayerGui")
        local ggui = pgui and pgui:FindFirstChild("GameGui")
        local gpb = ggui and ggui:FindFirstChild("GameProgress")
        txt = (gpb and tostring(gpb.Text)) or ""
    end)
    return txt
end

-- direction + level exactly as the server text says (Ahead or Astern, Full/Half/...)
local function parseTelegraphOrder()
    local txt = string.lower(readGameProgress())
    local dir = false -- false = ASTERN (arg2=false), true = AHEAD (arg2=true)
    if string.find(txt, "astern", 1, true) then
        dir = false
    elseif string.find(txt, "ahead", 1, true) then
        dir = true
    end
    local level = 1 -- default STOP: round-proven, the event only advances after the marked telegraph hits STOP
    if string.find(txt, "full", 1, true) then
        level = 6
    elseif string.find(txt, "half", 1, true) then
        level = 5
    elseif string.find(txt, "dead slow", 1, true) then
        level = 3
    elseif string.find(txt, "slow", 1, true) then
        level = 4
    end
    return dir, level
end

-- press the REAL telegraph GUI (faithful TelegraphsLocal flow):
-- runtime billboards are clones named "TelegraphGui1..5" (GuiStorage.TelegraphGui clones,
-- Adornee = TelegraphN.HandleController, shown when camera is within ~15 studs).
-- A real player clicks TelegraphBinaryChoice.Ahead|Astern (opens the matching dial),
-- then clicks a level button in TelegraphMenuAhead|Astern which sends the order.
local function pressTelegraphButton(idx, dirAhead, level)
    local menuNames = {
        [1] = "Stop", [2] = "StandBy", [3] = "DeadSlow",
        [4] = "Slow", [5] = "Half", [6] = "Full",
    }
    local stepped = false
    pcall(function()
        -- locate the runtime billboard for this exact telegraph index
        local bill = nil
        local want = "TelegraphGui" .. idx
        local function findIn(root)
            if not root then return end
            for _, b in ipairs(root:GetDescendants()) do
                if b.Name == want and b:IsA("BillboardGui") then
                    bill = b
                    return
                end
            end
        end
        findIn(Workspace)
        if not bill then findIn(LP:FindFirstChild("PlayerGui")) end
        -- fallback: template (signal-invoke executors only)
        if not bill then
            local gs = ReplicatedStorage:FindFirstChild("GuiStorage")
            bill = gs and gs:FindFirstChild("TelegraphGui")
        end
        if not bill then return end

        local vim = nil
        pcall(function() vim = game:GetService("VirtualInputManager") end)
        local function vimClick(btn)
            if not (vim and btn) then return false end
            local ap, as
            pcall(function()
                ap = btn.AbsolutePosition
                as = btn.AbsoluteSize
            end)
            if not ap or not as or (as.X <= 0) or (as.Y <= 0) then return false end
            local cx = math.floor(ap.X + as.X / 2)
            local cy = math.floor(ap.Y + as.Y / 2) + 36 -- topbar inset offset
            if cx < 0 or cy < 36 then return false end
            pcall(function()
                vim:SendMouseButtonEvent(cx, cy, 0, true, game, 0)
                task.wait(0.06)
                vim:SendMouseButtonEvent(cx, cy, 0, false, game, 0)
            end)
            task.wait(0.15)
            return true
        end

        -- step 1: open the correct dial like a real player does
        local choice = bill:FindFirstChild("TelegraphBinaryChoice")
        if choice then
            choice.Visible = true
            local dial = choice:FindFirstChild(dirAhead and "Ahead" or "Astern")
            local oppDial = choice:FindFirstChild(dirAhead and "Astern" or "Ahead")
            if dial then
                if not vimClick(dial) then
                    -- VIM failed -> emulate the same state change the dial causes
                    dial.Visible = true
                end
            end
            if oppDial then oppDial.Visible = false end
            -- show ONLY the matching menu (same result as the dial click)
            local menu = bill:FindFirstChild(dirAhead and "TelegraphMenuAhead"
                or "TelegraphMenuAstern")
            local other = bill:FindFirstChild(dirAhead and "TelegraphMenuAstern"
                or "TelegraphMenuAhead")
            if menu then menu.Visible = true end
            if other then other.Visible = false end
        end
        task.wait(0.35) -- dial -> menu switch tween (0.3s)

        -- step 2: click the requested level inside the revealed menu
        local menu2 = bill:FindFirstChild(dirAhead and "TelegraphMenuAhead"
            or "TelegraphMenuAstern")
        local frame2 = menu2 and menu2:FindFirstChild("Frame")
        local btn = frame2 and frame2:FindFirstChild(menuNames[level] or "Stop")
        if not btn then return end
        if vimClick(btn) then
            stepped = true
        else
            -- no VIM -> signal invoke fallback
            if type(getconnections) == "function" then
                for _, c in ipairs(getconnections(btn.Activated)) do
                    pcall(function() c:Function() end)
                    stepped = true
                end
            elseif type(firesignal) == "function" then
                pcall(function() firesignal(btn.Activated) end)
                stepped = true
            end
        end
    end)
    return stepped
end

-- append runner observations into the persistent spy log (if installed)
local function spyNote(s)
    pcall(function()
        local ls = getgenv().__TIT_SAVELOG
        if type(ls) == "table" then
            ls[#ls + 1] = "[" .. os.date("%H:%M:%S") .. "] RUN " .. s
            if #ls > 400 then table.remove(ls, 1) end
        end
    end)
end

-- steer the ship via the real steering remote (InteractivityLocal fires WheelSteerEvent
-- with (dirArg, wheelNum); false = LEFT, true = RIGHT; the game rate-limits at 0.1s)
local function remoteSteer(dirLeft, wheelNum, presses)
    local fired = 0
    pcall(function()
        local re = ReplicatedStorage:FindFirstChild("RemoteEvents")
        local gp = re and re:FindFirstChild("Gameplay")
        local r = gp and gp:FindFirstChild("WheelSteerEvent")
        if not r then return end
        local dirArg = not dirLeft -- dirLeft=true -> false (LEFT); dirLeft=false -> true (RIGHT)
        for _ = 1, presses do
            pcall(function() r:FireServer(dirArg, wheelNum) end)
            fired = fired + 1
            task.wait(0.11) -- just above the game's 0.1s rate gate
        end
    end)
    return fired
end

warpAndSteerLeft = function(pressCount)
    pressCount = pressCount or 8
    pcall(function()
        local ssm = Workspace:FindFirstChild("ServerShipMovement")
        local w1 = ssm and ssm:FindFirstChild("LeftWheel1")
        local w2 = ssm and ssm:FindFirstChild("LeftWheel2")
        -- Prioritize LeftWheel2 (inside bridge wheelhouse next to Captain/Phones) or marked wheel
        local wheel = nil
        if w2 and w2:FindFirstChildWhichIsA("SelectionBox") and w2.SelectionBox.Visible then
            wheel = w2
        elseif w1 and w1:FindFirstChildWhichIsA("SelectionBox") and w1.SelectionBox.Visible then
            wheel = w1
        else
            wheel = w2 or w1
        end
        if wheel and isStationGreen(wheel) then
            spyNote("Left wheel " .. wheel.Name .. " is GREEN - skip warp")
            return
        end
        if wheel then
            local wpos = posOf(wheel)
            local hrp = getHRP()
            if hrp and wpos then
                -- Direct warp right in front of the wheel handle
                hrp.CFrame = CFrame.new(wpos.X, wpos.Y + 1.2, wpos.Z)
                task.wait(0.06)
            end
            local pp = wheel:FindFirstChildWhichIsA("ProximityPrompt", true)
            if pp and pp.Enabled then
                for _ = 1, math.min(pressCount, 6) do
                    if isStationGreen(wheel) then break end
                    if type(fireproximityprompt) == "function" then
                        pcall(function() fireproximityprompt(pp) end)
                    else
                        pcall(function()
                            pp:InputHoldBegin()
                            task.wait(0.02)
                            pp:InputHoldEnd()
                        end)
                    end
                    task.wait(0.05)
                end
            end
            local num = tonumber(string.match(wheel.Name, "%d+")) or 2
            local fired = remoteSteer(true, num, pressCount)
            stats.lastFire = "warp + steer LEFT (" .. wheel.Name .. ") x" .. fired
            spyNote("Warped to " .. wheel.Name .. " & steered LEFT x" .. fired)
            notifyFn("Roblox Titanic", "Warped to " .. wheel.Name .. " & Steered LEFT!", 3)
        end
    end)
end

local runBusy = false
task.spawn(function()
    while not stopFlag do
        task.wait(0.02) -- instant 1:1 event-gate poll
        if not Config.RunOnEvent or runBusy then continue end
        local evOpen = false
        local sv = false
        pcall(function()
            local ssts = ReplicatedStorage:FindFirstChild("SaveTheShipValues")
            if ssts then
                local ss = ssts:FindFirstChild("StartSaving")
                local sr = ssts:FindFirstChild("SavedRound")
                evOpen = ss and ss.Value or false
                sv = sr and sr.Value or false
            end
        end)
        if not (evOpen and not sv) then continue end

        runBusy = true
        stats.runPhase = "starting"
        local hrp = getHRP()
        local home = hrp and hrp.CFrame
        local bellDone = false
        local teleDone = false
        local teleFallback = false
        local guard = 0
        local lastMarkSig = ""
        local textWheelDir = nil
        local steerLeftDone = false
        repeat
            guard = guard + 1
            if guard > 120 then break end
            hrp = getHRP()
            if not hrp then break end

            -- locate stations fresh every cycle
            local phone1 = nil
            local phone2 = nil
            local bellPrompt = nil
            pcall(function()
                local ssm = Workspace:FindFirstChild("ServerShipMovement")
                if not ssm then return end
                phone1 = ssm:FindFirstChild("Telephone1")
                phone2 = ssm:FindFirstChild("Telephone2")
                local bell = ssm:FindFirstChild("CrowsNestBell")
                local bellPart = bell and bell:FindFirstChild("BellPart")
                bellPrompt = bellPart and bellPart:FindFirstChildWhichIsA("ProximityPrompt")
            end)

            -- yellow-marker scan: which telegraph/phone/boiler is marked this cycle
            local markers = scanMarkers()
            stats.markPhone1 = markers.phones["Telephone1"] or false
            stats.markPhone2 = markers.phones["Telephone2"] or false
            stats.markBoiler = markers.boiler
            stats.markWheel = markers.wheelSide
            if markers.telegraph then stats.teleChosen = markers.telegraph end
            if markers.wheelSide then steerRight = (markers.wheelSide == "Right") end

            -- evidence trail: log the marker scan into the spy log whenever it changes
            pcall(function()
                local markSig = "wheel=" .. tostring(markers.wheelSide)
                    .. " tg=" .. tostring(markers.telegraph)
                    .. " boiler=" .. tostring(markers.boiler)
                    .. " bell=" .. tostring(markers.bell)
                    .. " ph1=" .. tostring(stats.markPhone1) .. " ph2=" .. tostring(stats.markPhone2)
                    .. " prog='" .. string.sub(readGameProgress(), 1, 44) .. "'"
                if markSig ~= lastMarkSig then
                    lastMarkSig = markSig
                    spyNote("MARK " .. markSig)
                end
            end)

            local done = false -- declared early so the wait-marker continue cannot skip it
            -- STRICT: no server marker at all -> do nothing this cycle
            local anyMark = markers.bell
                or (markers.telegraph ~= nil)
                or stats.markPhone1 or stats.markPhone2
                or (markers.boiler ~= nil)
                or (markers.wheelSide ~= nil)
            if not anyMark then
                stats.runPhase = "wait-marker"
                task.wait(0.02) -- instant 1:1 re-scan: jump the instant a yellow marker lands
                continue
            end

            -- 1) crow's nest bell x3 - marker-gated; runner owns rings (shares counter with AutoBell)
            local ringsLeft = (Config.BellRings or 3) - bellRingsUsed
            if (not bellDone) and markers.bell and bellPrompt and ringsLeft > 0 and not isStationGreen(bellPrompt.Parent) then
                local bpos = posOf(bellPrompt.Parent)
                if bpos and not isStationGreen(bellPrompt.Parent) then
                    stats.runPhase = "bell"
                    runnerWarp(bpos + Vector3.new(0, 2.5, 0))
                    local rings = 0
                    for _ = 1, math.min(ringsLeft, 3) do
                        if isStationGreen(bellPrompt.Parent) then break end
                        local okP = false
                        if type(fireproximityprompt) == "function" then
                            okP = pcall(function() fireproximityprompt(bellPrompt) end)
                        end
                        if not okP then
                            okP = pcall(function()
                                bellPrompt:InputHoldBegin()
                                task.wait(0.02)
                                bellPrompt:InputHoldEnd()
                            end)
                        end
                        if okP then rings = rings + 1 end
                        task.wait(0.06) -- rapid triple-tap
                    end
                    bellRingsUsed = math.min(bellRingsUsed + rings, Config.BellRings or 3)
                    stats.lastFire = "bell prompt x" .. rings
                    if rings > 0 then bellDone = true end
                end
            end

            -- 2) phones: ONLY the YELLOW-MARKED telephone (strict: none marked = skip phase)
            if stats.markPhone1 or stats.markPhone2 then
                stats.runPhase = "phones"
                local phoneList = {}
                if stats.markPhone1 and phone1 and not isStationGreen(phone1) and not markers.greenNodes[phone1.Name] then phoneList[#phoneList + 1] = phone1 end
                if stats.markPhone2 and phone2 and not isStationGreen(phone2) and not markers.greenNodes[phone2.Name] then phoneList[#phoneList + 1] = phone2 end
                local pressed = 0
            for _, ph in ipairs(phoneList) do
                local pp = ph and ph:FindFirstChildWhichIsA("ProximityPrompt")
                local ppos = pp and posOf(pp.Parent)
                if pp and ppos and not isStationGreen(ph) and not isStationGreen(pp.Parent) then
                    runnerWarp(ppos + Vector3.new(0, 2, 0))
                    local okP = false
                    if type(fireproximityprompt) == "function" then
                        okP = pcall(function() fireproximityprompt(pp) end)
                    end
                    if not okP then
                        okP = pcall(function()
                            pp:InputHoldBegin()
                            task.wait(0.03)
                            pp:InputHoldEnd()
                        end)
                    end
                    if okP then pressed = pressed + 1 end
                    task.wait(0.05)
                end
                stats.phone = (stats.phone or 0) + pressed
            end
            end

            -- wheel: warp to the MARKED wheel and press its prompt to turn that way
            if markers.wheelSide and markers.wheelNode and not isStationGreen(markers.wheelNode) and not markers.greenNodes[markers.wheelNode.Name] then
                stats.runPhase = "wheel"
                local wpos = posOf(markers.wheelNode)
                if not wpos then
                    pcall(function()
                        local ppw = markers.wheelNode:FindFirstChildWhichIsA("ProximityPrompt")
                        wpos = ppw and posOf(ppw.Parent)
                    end)
                end
                if wpos and not isStationGreen(markers.wheelNode) then
                    runnerWarp(wpos + Vector3.new(0, 2.5, 0))
                    steerRight = (markers.wheelSide == "Right")
                    local ppOfWheel = markers.wheelNode:FindFirstChildWhichIsA("ProximityPrompt")
                    if ppOfWheel then
                        local hits = 0
                        for _ = 1, 6 do
                            local okP = false
                            if type(fireproximityprompt) == "function" then
                                okP = pcall(function() fireproximityprompt(ppOfWheel) end)
                            end
                            if not okP then
                                okP = pcall(function()
                                    ppOfWheel:InputHoldBegin()
                                    task.wait(0.02)
                                    ppOfWheel:InputHoldEnd()
                                end)
                            end
                            if okP then hits = hits + 1 end
                            task.wait(0.06)
                        end
                        stats.lastFire = "wheel prompt " .. markers.wheelSide .. " x" .. hits
                        local wNum = tonumber(string.match(markers.wheelNode.Name, "%d+")) or 2
                        remoteSteer(not steerRight, wNum, 4)
                    end
                end
            end

            -- 3) telegraph: ONLY the marked telegraph; ALWAYS warp to its station first,
            --    then send the direction/level the server text asked for (Ahead OR Astern)
            --    Gui.TelegraphOrderRetrieve (arg2=false = ASTERN, true = AHEAD)
            if markers.telegraph and not isStationGreen(markers.teleNode) and not markers.greenNodes["Telegraph" .. markers.telegraph] then
                stats.runPhase = "telegraph"
                local chosen = markers.telegraph
                stats.teleChosen = chosen
                if not teleDone then
                    -- 1:1 instant warp to the marked telegraph
                    local tpos = nil
                    if markers.teleNode then
                        tpos = posOf(markers.teleNode)
                        if not tpos then
                            pcall(function()
                                local h = markers.teleNode:FindFirstChild("TelegraphHandle")
                                tpos = h and posOf(h)
                            end)
                        end
                    end
                    if tpos and not isStationGreen(markers.teleNode) then
                        runnerWarp(tpos + Vector3.new(0, 2.5, 0))
                    else
                        stats.lastFire = "warp tg" .. chosen .. " pos failed"
                    end
                    -- always answer STOP: round-proven acceptance gate (do not trust "Full ahead" text)
                    local dirArg = parseTelegraphOrder()
                    local level = 1
                    stats.teleLast = (dirArg and "AHEAD" or "ASTERN") .. tostring(level) .. "(Stop)"
                    -- user-approved remote method: warp first (stay in range), then fire the order
                    local okT = false
                    pcall(function()
                        local re = ReplicatedStorage:FindFirstChild("RemoteEvents")
                        local guichpath = re and re:FindFirstChild("Gui")
                        local r = guichpath and guichpath:FindFirstChild("TelegraphOrderRetrieve")
                        if r then
                            r:FireServer(chosen, dirArg, level, true)
                            okT = true
                            spyNote("telegraph remote tg" .. chosen .. " dir=" .. tostring(dirArg)
                                .. " lv=" .. level)
                        end
                    end)
                    if not okT then
                        -- fallback: real clicks (dial -> Stop menu) if the remote path failed
                        okT = pressTelegraphButton(chosen, dirArg, level)
                    end
                    if okT then
                        stats.lastFire = "telegraph GUI tg" .. chosen .. " " .. stats.teleLast
                    else
                        stats.lastFire = "telegraph GUI failed tg" .. chosen
                    end
                    task.wait(0.06)
                    local moving = true
                    pcall(function()
                        local tf = Workspace:FindFirstChild("TitanicFolder")
                        local tset = tf and tf:FindFirstChild("TelegraphSettings")
                        local m = tset and tset:FindFirstChild("MovingTelegraph" .. chosen)
                        moving = (m and m.Value) or false
                    end)
                    if moving or okT then
                        teleDone = true
                    end
                end
            end

            -- 4) dampers: ONLY the marked boiler (strict: none marked = skip phase)
            stats.runPhase = "dampers"
            if markers.boiler and not isStationGreen(markers.boilerNode) and not markers.greenNodes[markers.boiler] then
            pcall(function()
                local ssm = Workspace:FindFirstChild("ServerShipMovement")
                local boilers = ssm and ssm:FindFirstChild("Boilers")
                if not boilers then return end
                for _, boiler in ipairs(boilers:GetChildren()) do
                    if string.sub(boiler.Name, 1, 6) == "Boiler"
                        and ((not markers.boiler) or (boiler.Name == markers.boiler))
                        and not isStationGreen(boiler) and not markers.greenNodes[boiler.Name] then
                        for _, flap in ipairs(boiler:GetChildren()) do
                            if string.find(flap.Name, "Flap", 1, true) then
                                local stampKey = boiler.Name .. "/" .. flap.Name
                                local cooled = (not flapStamp[stampKey])
                                    or ((os.clock() - flapStamp[stampKey]) > 0.5)
                                local bv = flap:FindFirstChild("FlapOpen")
                                local pp = flap:FindFirstChildWhichIsA("ProximityPrompt")
                                if cooled and pp and pp.Enabled and bv and bv.Value and not isStationGreen(flap) then
                                    local fpos = posOf(pp.Parent)
                                    if fpos and not isStationGreen(boiler) then
                                        runnerWarp(fpos)
                                        task.wait(0.04)
                                        local okP = false
                                        if type(fireproximityprompt) == "function" then
                                            okP = pcall(function() fireproximityprompt(pp) end)
                                        else
                                            okP = pcall(function()
                                                pp:InputHoldBegin()
                                                task.wait(0.02)
                                                pp:InputHoldEnd()
                                            end)
                                        end
                                        flapStamp[stampKey] = os.clock()
                                        if okP then
                                            -- settle: wait until server flips FlapOpen (max 0.8 s)
                                            local accepted = false
                                            local t0 = os.clock()
                                            while (os.clock() - t0) < 0.8 do
                                                task.wait(0.04)
                                                local okb, v = pcall(function() return bv.Value end)
                                                if okb and v == false then
                                                    accepted = true
                                                    break
                                                end
                                            end
                                            if accepted then
                                                stats.flapsClosed = (stats.flapsClosed or 0) + 1
                                                stats.lastFire = "damper " .. boiler.Name .. "/" .. flap.Name .. " closed"
                                                seenGreen[stampKey] = os.clock()
                                                spyNote("DAMPER CLOSED: " .. boiler.Name .. "/" .. flap.Name)
                                            else
                                                stats.flapsFail = (stats.flapsFail or 0) + 1
                                            end
                                        else
                                            stats.flapsFail = (stats.flapsFail or 0) + 1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            end

            -- count remaining open dampers for the status readout (respect marked boiler)
            do
                local left = 0
                pcall(function()
                    local ssm = Workspace:FindFirstChild("ServerShipMovement")
                    local boilers = ssm and ssm:FindFirstChild("Boilers")
                    if not boilers then return end
                    for _, boiler in ipairs(boilers:GetChildren()) do
                        if string.sub(boiler.Name, 1, 6) == "Boiler"
                            and ((not markers.boiler) or (boiler.Name == markers.boiler)) then
                            for _, flap in ipairs(boiler:GetChildren()) do
                                if string.find(flap.Name, "Flap", 1, true) then
                                    local bv = flap:FindFirstChild("FlapOpen")
                                    if bv and bv.Value then left = left + 1 end
                                end
                            end
                        end
                    end
                end)
                stats.dampersLeft = left
            end
            task.wait(0.15) -- fast cycle cadence: marker changes are caught next cycle almost instantly
            done = true
            pcall(function()
                local ssts = ReplicatedStorage:FindFirstChild("SaveTheShipValues")
                done = (ssts == nil)
                    or (not ssts:FindFirstChild("StartSaving").Value)
                    or (ssts:FindFirstChild("SavedRound").Value)
            end)
        until done or stopFlag

        if home and getHRP() then
            pcall(function() getHRP().CFrame = home end)
        end
        stats.runPhase = "idle"
        runBusy = false
    end
end)

-- event watcher: when StartSaving goes true, auto-arm the main actions; on end, stop them
task.spawn(function()
    local ssts = nil
    pcall(function()
        ssts = ReplicatedStorage:WaitForChild("SaveTheShipValues", 10)
    end)
    if not ssts then return end
    local startSaving = ssts:FindFirstChild("StartSaving")
    local savedRound = ssts:FindFirstChild("SavedRound")
    if not startSaving then return end
    local active = false
    while not stopFlag do
        task.wait(0.2)
        local ev = false
        local sv = false
        pcall(function() ev = startSaving.Value end)
        pcall(function() if savedRound then sv = savedRound.Value end end)
        if ev ~= active then
            active = ev
            if ev and Config.FullAuto then
                -- FULL AUTO: NO remote fires at all. runner does everything by warping
                -- and physically pressing (bell/phone/wheel prompts, telegraph GUI, dampers)
                Config.RunOnEvent = true
                Config.AutoWheel = false
                Config.AutoBell = false
                bellRingsUsed = 0
                pcall(function()
                    if uiToggles.runner then uiToggles.runner:Set(true) end
                    if uiToggles.wheel then uiToggles.wheel:Set(false) end
                    if uiToggles.bell then uiToggles.bell:Set(false) end
                end)
                notifyFn("Roblox Titanic", "FULL AUTO engaged - warping to all stations", 5)
            elseif ev and Config.ArmOnEvent then
                Config.AutoWheel = true
                Config.AutoLamp = true
                Config.AutoFlaps = true
                Config.AutoBell = true
                bellRingsUsed = 0
                pcall(function()
                    if uiToggles.wheel then uiToggles.wheel:Set(true) end
                    if uiToggles.lamp then uiToggles.lamp:Set(true) end
                    if uiToggles.flap then uiToggles.flap:Set(true) end
                    if uiToggles.bell then uiToggles.bell:Set(true) end
                end)
                notifyFn("Roblox Titanic", "Event started - actions enabled", 4)
            elseif not ev then
                Config.AutoWheel = false
                Config.AutoLamp = false
                Config.AutoFlaps = false
                Config.AutoBell = false
                if Config.FullAuto then
                    Config.RunOnEvent = false
                    pcall(function() if uiToggles.runner then uiToggles.runner:Set(false) end end)
                end
                pcall(function()
                    if uiToggles.wheel then uiToggles.wheel:Set(false) end
                    if uiToggles.lamp then uiToggles.lamp:Set(false) end
                    if uiToggles.flap then uiToggles.flap:Set(false) end
                    if uiToggles.bell then uiToggles.bell:Set(false) end
                end)
                if sv then
                    notifyFn("Roblox Titanic", "Round saved - auto off", 3)
                end
            end
        end
    end
end)

-- status + SaveTheShipValues readback
task.spawn(function()
    while not stopFlag do
        task.wait(0.5)
        local line = "- no SaveTheShipValues -"
        local slots = ""
        pcall(function()
            local ssts = ReplicatedStorage:FindFirstChild("SaveTheShipValues")
            if ssts then
                local parts = {}
                for _, k in ipairs({ "TimeGivenToSave", "TIMER_", "StartSaving", "SavedRound", "SavedInARow" }) do
                    local node = ssts:FindFirstChild(k)
                    if node then
                        parts[#parts + 1] = k .. "=" .. tostring(node.Value)
                    end
                end
                line = table.concat(parts, " | ")
                -- 5 task slots: count how many are already credited and to whom
                local cnt = 0
                local names = {}
                for i = 1, 5 do
                    local nv = ssts:FindFirstChild("NamePlayerSaved" .. i)
                    if nv and tostring(nv.Value) ~= "" then
                        cnt = cnt + 1
                        names[#names + 1] = tostring(nv.Value)
                    end
                end
                slots = "Slots: " .. cnt .. "/5"
                if cnt > 0 then
                    slots = slots .. " [" .. table.concat(names, ",") .. "]"
                end
            end
        end)
        local evState = (string.find(line, "StartSaving=true") and "EVENT OPEN")
            or "event closed"
        if statusPara then
            pcall(function()
                statusPara:Set({
                    Title = "Titanic Status [" .. evState .. "]",
                    Content = line .. " " .. (slots or "")
                        .. "\nFires: " .. stats.fires .. " Fails: " .. stats.fails
                        .. " Blocked: " .. tostring(stats.blocked or 0)
                        .. " Last: " .. stats.lastFire
                        .. " | Run: " .. tostring(stats.runPhase or "-")
                        .. " | Dampers left: " .. tostring(stats.dampersLeft or "-")
                        .. " | Ph: " .. tostring(stats.phone or 0)
                        .. " Tg: " .. tostring(stats.teleChosen or "-")
                            .. (stats.teleLast or "")
                        .. " Wr: " .. tostring(stats.markWheel or "-")
                        .. " | Uptime: " .. string.format("%.0fs", os.clock() - startedAt),
                })
            end)
        end
    end
end)

local Window = Rayfield:CreateWindow({
    Name = "Roblox Titanic",
    LoadingTitle = "Roblox Titanic",
    LoadingSubtitle = "made by valexcryzer",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
})

local Tab = Window:CreateTab("Main", 4483362458)

local uiToggles = {}

Tab:CreateSection("AUTO SAVE SHIP")
Tab:CreateToggle({ Name = "FULL AUTO", CurrentValue = true, Flag = "t_full",
    Callback = function(v) Config.FullAuto = v end })
Tab:CreateToggle({ Name = "Only During Event (block all actions otherwise)", CurrentValue = true, Flag = "t_only",
    Callback = function(v) Config.OnlyDuringEvent = v end })
uiToggles.wheel = Tab:CreateToggle({ Name = "Auto Wheel Steer (helm)", CurrentValue = false, Flag = "t_wheel",
    Callback = function(v) Config.AutoWheel = v end })
Tab:CreateSlider({ Name = "Wheel Interval", Range = { 0.1, 1.0 }, Increment = 0.05,
    Suffix = " s", CurrentValue = 0.25, Flag = "t_wheel_iv",
    Callback = function(v) Config.WheelInterval = v end })
uiToggles.lamp = Tab:CreateToggle({ Name = "Auto Morse Lamp (signal)", CurrentValue = false, Flag = "t_lamp",
    Callback = function(v) Config.AutoLamp = v end })
Tab:CreateSlider({ Name = "Lamp Interval", Range = { 0.2, 1.0 }, Increment = 0.05,
    Suffix = " s", CurrentValue = 0.45, Flag = "t_lamp_iv",
    Callback = function(v) Config.LampInterval = v end })
uiToggles.flap = Tab:CreateToggle({ Name = "Auto Boiler Flaps (prompt)", CurrentValue = false, Flag = "t_flap",
    Callback = function(v) Config.AutoFlaps = v end })
Tab:CreateSlider({ Name = "Flap Interval", Range = { 1.0, 6.0 }, Increment = 0.5,
    Suffix = " s", CurrentValue = 2.5, Flag = "t_flap_iv",
    Callback = function(v) Config.FlapInterval = v end })
Tab:CreateToggle({ Name = "Flap Blink Back to previous spot", CurrentValue = true, Flag = "t_flapbb",
    Callback = function(v) Config.FlapBlinkBack = v end })
Tab:CreateButton({ Name = "SCAN which dampers are still open",
    Callback = function()
        local names = {}
        pcall(function()
            local ssm = Workspace:FindFirstChild("ServerShipMovement")
            local boilers = ssm and ssm:FindFirstChild("Boilers")
            for _, boiler in ipairs((boilers and boilers:GetChildren()) or {}) do
                if string.sub(boiler.Name, 1, 6) == "Boiler" then
                    for _, flap in ipairs(boiler:GetChildren()) do
                        if string.find(flap.Name, "Flap", 1, true) then
                            local bv = flap:FindFirstChild("FlapOpen")
                            if bv and bv.Value then
                                names[#names + 1] = string.sub(boiler.Name, 7)
                                    .. "." .. string.sub(flap.Name, 5)
                            end
                        end
                    end
                end
            end
        end)
        if #names == 0 then
            notifyFn("Roblox Titanic", "All dampers shut", 4)
        else
            notifyFn("Roblox Titanic", "Open: " .. table.concat(names, " "), 6)
        end
        stats.lastFire = "scan dampers " .. #names
    end })
Tab:CreateButton({ Name = "SCAN server markers (yellow=active, green=done)",
    Callback = function()
        local m = scanMarkers()
        local bits = {}
        bits[#bits + 1] = "Bell: " .. (m.bell and "YES" or "-")
        bits[#bits + 1] = "Tg: " .. (m.telegraph or "-")
        bits[#bits + 1] = "Ph: " .. ((m.phones["Telephone1"] and "T1" or "")
            .. (m.phones["Telephone2"] and "T2" or ""))
        if m.phones["Telephone1"] == nil or not (m.phones["Telephone1"] or m.phones["Telephone2"]) then
            bits[#bits] = "Ph: -"
        end
        bits[#bits + 1] = "Boiler: " .. (m.boiler or "-")
        local greens = {}
        for k, _ in pairs(m.greenNodes or {}) do
            if type(k) == "string" then table.insert(greens, k) end
        end
        if #greens > 0 then
            bits[#bits + 1] = "Green: " .. table.concat(greens, ",")
        end
        notifyFn("Roblox Titanic", "Marks -> " .. table.concat(bits, " | "), 7)
        stats.lastFire = "scan marks"
    end })
uiToggles.bell = Tab:CreateToggle({ Name = "Auto Bell (limited rings, no spam)", CurrentValue = false, Flag = "t_bell",
    Callback = function(v)
        Config.AutoBell = v
        if v then bellRingsUsed = 0 end
    end })
Tab:CreateSlider({ Name = "Bell Rings per Event (anti-spam)", Range = { 1, 8 }, Increment = 1,
    Suffix = " rings", CurrentValue = 3, Flag = "t_bell_n",
    Callback = function(v) Config.BellRings = v end })
Tab:CreateSlider({ Name = "Bell Interval", Range = { 0.5, 5.0 }, Increment = 0.5,
    Suffix = " s", CurrentValue = 2.0, Flag = "t_bell_iv",
    Callback = function(v) Config.BellInterval = v end })
Tab:CreateToggle({ Name = "Auto Captain Orders", CurrentValue = false, Flag = "t_capt",
    Callback = function(v) Config.AutoCaptain = v end })
Tab:CreateToggle({ Name = "Auto Whistle", CurrentValue = false, Flag = "t_whistle",
    Callback = function(v) Config.AutoWhistle = v end })

statusPara = Tab:CreateParagraph({ Title = "Titanic Status", Content = "waiting..." })

-- ================= TAB 2: EXTRAS (auto farm + time & life mods) =================
local Tab2 = Window:CreateTab("Extras", 4483362458)

---------------- RAPID ADDPOINT (Points Engine) ----------------
Config.AddPointSpam = true
Config.AddPointInterval = 0.05
Config.AddPointBurst = 150
local farmPara = Tab2:CreateParagraph({ Title = "AddPoint", Content = "idle - toggle below" })
local pointFires = 0
local farmBase = nil
local guiF = nil

local function guiRemote(name)
    if not guiF then return nil end
    return guiF:FindFirstChild(name)
end
Config._farmResolved = false
local function farmRemotes()
    local re = ReplicatedStorage:FindFirstChild("RemoteEvents")
    local g = re and re:FindFirstChild("Gui")
    guiF = g
    Config._farmResolved = (g ~= nil)
end
farmRemotes()

local function pointsNow()
    local pv = LP:FindFirstChild("Points")
    return pv and pv.Value or -1
end
farmBase = pointsNow()

Tab2:CreateSection("AddPoint")
local addPointToggle, burstSlider, spacingSlider
local uiInitialized = false

addPointToggle = Tab2:CreateToggle({ Name = "RAPID ADDPOINT",
    CurrentValue = true, Flag = "x_addp",
    Callback = function(v)
        if uiInitialized then
            Config.AddPointSpam = v
            if v then farmBase = pointsNow() end
            notifyFn("AddPoint", v and "RAPID ADDPOINT ON" or "RAPID ADDPOINT OFF", 2)
            stats.lastFire = "addpoint " .. tostring(v)
        end
    end })
burstSlider = Tab2:CreateSlider({ Name = "Burst (1x - 300x)", Range = { 1, 300 }, Increment = 5,
    Suffix = "x", CurrentValue = 150, Flag = "x_addpburst",
    Callback = function(v)
        if uiInitialized then
            Config.AddPointBurst = v
        end
    end })
spacingSlider = Tab2:CreateSlider({ Name = "Spacing (s)", Range = { 0.02, 0.5 }, Increment = 0.01,
    Suffix = " s", CurrentValue = 0.05, Flag = "x_addpiv",
    Callback = function(v)
        if uiInitialized then
            Config.AddPointInterval = v
        end
    end })

task.defer(function()
    task.wait(0.2)
    Config.AddPointSpam = true
    Config.AddPointBurst = 150
    Config.AddPointInterval = 0.05
    farmBase = pointsNow()
    uiInitialized = true
    pcall(function()
        if addPointToggle and addPointToggle.Set then addPointToggle:Set(true) end
        if burstSlider and burstSlider.Set then burstSlider:Set(150) end
        if spacingSlider and spacingSlider.Set then spacingSlider:Set(0.05) end
    end)
    notifyFn("AddPoint", "RAPID ADDPOINT (150x) ACTIVE", 2)
end)

-- rapid addpoint loop
task.spawn(function()
    while not stopFlag do
        local iv = (tonumber(Config.AddPointInterval) or 0.05)
        task.wait(math.max(0.02, iv))
        if Config.AddPointSpam then
            pcall(function()
                local ap = guiRemote("AddPoint")
                if not ap then farmRemotes() ap = guiRemote("AddPoint") end
                if not ap then return end
                local burst = math.clamp(tonumber(Config.AddPointBurst) or 150, 1, 300)
                for _ = 1, burst do
                    ap:FireServer("thi&!44", false, false, false)
                end
                pointFires = pointFires + burst
                stats.lastFire = "addpoint x" .. tostring(burst)
            end)
        end
    end
end)

-- live readout
task.spawn(function()
    local lastPts = pointsNow()
    local lastT = os.clock()
    while not stopFlag do
        task.wait(0.5)
        pcall(function()
            local curPts = pointsNow()
            local now = os.clock()
            local dt = now - lastT
            local rate = 0
            if dt > 0 and curPts >= 0 and lastPts >= 0 then
                rate = math.floor((curPts - lastPts) / dt)
            end
            lastPts = curPts
            lastT = now

            local earn = farmBase and (curPts - farmBase) or 0
            local burst = Config.AddPointBurst or 150
            local lines = string.format("Points: %s (+%s/s)\nSession Earned: +%s (x%d Burst)",
                tostring(curPts), tostring(rate), tostring(earn), burst)
            if farmPara then
                farmPara:Set({ Title = "AddPoint Status", Content = lines })
            end
        end)
    end
end)

Tab2:CreateSection("Server Utilities")
Tab2:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        notifyFn("Server", "Rejoining server...", 3)
        local ts = game:GetService("TeleportService")
        local ok = pcall(function()
            ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end)
        if not ok then
            pcall(function() ts:Teleport(game.PlaceId, LP) end)
        end
    end
})

---------------- TIME OVERRIDE (client-side, the server keeps its own truth) ----------------
Config.TimeHoldOn = false
Config.TimeHold = 30
Tab2:CreateSection("TIME HOLD (visual - in-round timer display)")
Tab2:CreateSlider({ Name = "Timer value to hold", Range = { 1, 60 }, Increment = 1,
    Suffix = " s", CurrentValue = 30, Flag = "x_time",
    Callback = function(v) Config.TimeHold = v end })
Tab2:CreateToggle({ Name = "HOLD the in-round timer at value above",
    CurrentValue = false, Flag = "x_timeon",
    Callback = function(v)
        Config.TimeHoldOn = v
        stats.lastFire = "timehold " .. tostring(v)
        notifyFn("Time Hold", v and "Timer pinned on your screen"
            or "Timer released (standard)", 3)
    end })
task.spawn(function()
    while not stopFlag do
        task.wait(0.2)
        if Config.TimeHoldOn then
            pcall(function()
                local ssts = ReplicatedStorage:FindFirstChild("SaveTheShipValues")
                if ssts then
                    local tv = ssts:FindFirstChild("Timer")
                    local tg = ssts:FindFirstChild("TimeGivenToSave")
                    if tv then tv.Value = (Config.TimeHold or 30) end
                    if tg then tg.Value = (Config.TimeHold or 30) end
                end
            end)
        end
    end
end)

---------------- LIFE (client-side health god-mode) ----------------
Config.GodMode = false
Config.LifeMax = 10000
Tab2:CreateSection("LIFE (health god-mode)")
Tab2:CreateSlider({ Name = "Health cap while god mode", Range = { 100, 1000000 }, Increment = 100,
    Suffix = " hp", CurrentValue = 10000, Flag = "x_life",
    Callback = function(v) Config.LifeMax = v end })
Tab2:CreateToggle({ Name = "GOD MODE on (auto-refill health)",
    CurrentValue = false, Flag = "x_lifeon",
    Callback = function(v)
        Config.GodMode = v
        if v then
            pcall(function()
                local ch = LP.Character
                local h = ch and ch:FindFirstChildOfClass("Humanoid")
                if h then
                    h.MaxHealth = (Config.LifeMax or 10000)
                    h.Health = h.MaxHealth
                end
            end)
        else
            pcall(function()
                local ch = LP.Character
                local h = ch and ch:FindFirstChildOfClass("Humanoid")
                if h then
                    h.MaxHealth = 100
                    h.Health = math.min(h.Health, 100)
                end
            end)
        end
        stats.lastFire = "godmode " .. tostring(v)
        notifyFn("Life", v and "God mode ON - health refills"
            or "God mode OFF - standard health", 3)
    end })
task.spawn(function()
    while not stopFlag do
        task.wait(0.2)
        if Config.GodMode then
            pcall(function()
                local ch = LP.Character
                local h = ch and ch:FindFirstChildOfClass("Humanoid")
                if h then
                    if (h.MaxHealth or 0) < (Config.LifeMax or 10000) then
                        h.MaxHealth = (Config.LifeMax or 10000)
                    end
                    h.Health = h.MaxHealth
                end
            end)
        end
    end
end)

-- ============ SERVER-WIDE ANNOUNCEMENT (Marconi radio, everyone sees it) ============
-- cache every incoming broadcast so we can replay it locally without paying again
getgenv().__TIT_LASTWIDE = nil
pcall(function()
    local re = ReplicatedStorage:FindFirstChild("RemoteEvents")
    local guich = re and re:FindFirstChild("Gui")
    local rme = guich and guich:FindFirstChild("MarconiMessageToClient")
    if rme then
        rme.OnClientEvent:Connect(function(a1, a2, a3, a4)
            if a1 and a3 then
                getgenv().__TIT_LASTWIDE = {
                    text = tostring(a1),
                    name = tostring(a3.Name),
                    secs = math.min(tonumber(a4) or 10, 60),
                    kind = tonumber(a2) or 1,
                }
            end
        end)
    end
end)

-- open popup -> set text -> focus-release trick (game's own FocusLost handler sends)
local function sendAnnouncement(text)
    local pgui = LP:FindFirstChild("PlayerGui")
    local ggui = pgui and pgui:FindFirstChild("GameGui")
    local mrm = ggui and ggui:FindFirstChild("MarconiRoomMessage")
    if not mrm then return "no Marconi GUI" end
    local box = mrm:FindFirstChild("TypeNormal")
    local btn = mrm:FindFirstChild("ChatNormal")
    local vis = mrm:FindFirstChild("Visibility")
    if not box or not btn then return "missing message box" end
    if vis then vis.Value = true end
    task.wait(0.15)

    -- path 1: real focus trick -> game's own FocusLost handler sends the message
    local focusOK = false
    pcall(function()
        box:CaptureFocus()
        task.wait(0.25)
        box.Text = tostring(text)
        task.wait(0.15)
        box:ReleaseFocus()
        focusOK = true
    end)
    task.wait(1.0)
    local label = tostring(btn.Text or "")
    if focusOK and (label ~= "Chat") then
        return string.sub(label, 1, 60)
    end

    -- path 2: real mouse click on the Chat button via VirtualInputManager
    local vim = nil
    pcall(function() vim = game:GetService("VirtualInputManager") end)
    if vim then
        local ap = btn.AbsolutePosition
        local as = btn.AbsoluteSize
        local cx = math.floor(ap.X + as.X / 2)
        local cy = math.floor(ap.Y + as.Y / 2)
        pcall(function()
            vim:SendMouseButtonEvent(cx, cy, 0, true, game, 0)
            task.wait(0.06)
            vim:SendMouseButtonEvent(cx, cy, 0, false, game, 0)
        end)
        task.wait(1.0)
        label = tostring(btn.Text or "")
        if label == "Chat" then
            -- topbar inset offset variant
            pcall(function()
                vim:SendMouseButtonEvent(cx, cy + 36, 0, true, game, 0)
                task.wait(0.06)
                vim:SendMouseButtonEvent(cx, cy + 36, 0, false, game, 0)
            end)
            task.wait(1.0)
            label = tostring(btn.Text or "")
        end
    end

    if label == "Chat" then
        -- most reliable verdict: did our own broadcast come back?
        local wid = getgenv().__TIT_LASTWIDE
        if wid and wid.name == tostring(LP.Name) and wid.text == tostring(text) then
            return "SENT SUCCESS - everyone on the server saw it"
        end
        return "unclear - button still says Chat; check the big ServerWide label"
    elseif string.find(label, "Must wait", 1, true) then
        return "on cooldown (wait for the current message)"
    elseif string.find(label, "need more points", 1, true) then
        return "not enough points (announcement costs 500)"
    end
    return string.sub(label, 1, 60)
end

Tab2:CreateSection("SERVER-WIDE ANNOUNCEMENT (Marconi radio, costs 500 points)")
Tab2:CreateInput({
    Name = "Announcement text (everyone on the server sees it)",
    PlaceholderText = "made by valexcryzer",
    RemoveTextAfterFocusLost = false,
    Flag = "in_announce",
    Callback = function(v) Config.AnnounceText = v end,
})
Tab2:CreateButton({
    Name = "SEND ANNOUNCEMENT (opens radio popup + real click)",
    Callback = function()
        local text = tostring(Config.AnnounceText or "")
        if #text == 0 then
            notifyFn("Announcement", "Type the announcement text first", 4)
            return
        end
        notifyFn("Announcement", "Sending: " .. string.sub(text, 1, 40), 3)
        local result = sendAnnouncement(text)
        notifyFn("Announcement", "Result: " .. result, 6)
        stats.lastFire = "announce " .. result
    end,
})
Tab2:CreateButton({
    Name = "REPLAY last announcement (your screen only, free)",
    Callback = function()
        local last = getgenv().__TIT_LASTWIDE
        if not last then
            notifyFn("Announcement", "No announcement cached yet", 4)
            return
        end
        notifyFn("Announcement", "Replay [" .. last.name .. "]: " .. string.sub(last.text, 1, 30), 3)
        stats.lastFire = "replay wide"
        task.spawn(function()
            local pgui = LP:FindFirstChild("PlayerGui")
            local ggui = pgui and pgui:FindFirstChild("GameGui")
            local wide = ggui and ggui:FindFirstChild("ServerWideMessage")
            if not wide then return end
            wide.Visible = true
            for i = last.secs, 0, -1 do
                wide.Text = "(" .. i .. ") [" .. last.name .. "]: " .. last.text
                task.wait(1)
            end
            wide.Visible = false
            wide.Text = ""
        end)
    end,
})

Tab2:CreateSection("OLD EXTRAS TOOLS (kept for history)")

-- ================= TAB 3: TROLL =================
local TabTroll = Window:CreateTab("Troll", 4483362458)

---------------- MOVEMENT ----------------
Config.Noclip = false

TabTroll:CreateSection("Movement")
TabTroll:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "tr_noclip",
    Callback = function(v)
        Config.Noclip = v
        if not v and LP.Character then
            pcall(function()
                for _, part in ipairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end
        notifyFn("Troll", v and "Noclip ON (Walk through walls)" or "Noclip OFF", 2)
    end
})

noclipConn = RunService.Stepped:Connect(function()
    if stopFlag then
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        return
    end
    if Config.Noclip and LP.Character then
        pcall(function()
            for _, part in ipairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
    end
end)

---------------- SHIP TROLLING ----------------
Config.SpamAstern = false
Config.AsternDelay = 0.1
Config.SpamBell = false
Config.SpamBellDelay = 0.1

TabTroll:CreateSection("Ship Trolling")
TabTroll:CreateToggle({
    Name = "Spam Astern",
    CurrentValue = false,
    Flag = "tr_astern",
    Callback = function(v)
        Config.SpamAstern = v
        notifyFn("Troll", v and "Spam Astern ON (Full Astern bells ringing!)" or "Spam Astern OFF", 2)
    end
})
TabTroll:CreateSlider({
    Name = "Astern Interval (s)",
    Range = { 0.05, 1.0 },
    Increment = 0.05,
    Suffix = " s",
    CurrentValue = 0.1,
    Flag = "tr_astern_iv",
    Callback = function(v) Config.AsternDelay = v end
})

TabTroll:CreateToggle({
    Name = "Spam Bell",
    CurrentValue = false,
    Flag = "tr_bell",
    Callback = function(v)
        Config.SpamBell = v
        notifyFn("Troll", v and "Spam Bell ON (Loud ship bell ringing!)" or "Spam Bell OFF", 2)
    end
})
TabTroll:CreateSlider({
    Name = "Bell Interval (s)",
    Range = { 0.05, 1.0 },
    Increment = 0.05,
    Suffix = " s",
    CurrentValue = 0.1,
    Flag = "tr_bell_iv",
    Callback = function(v) Config.SpamBellDelay = v end
})

-- loop spam astern
task.spawn(function()
    while not stopFlag do
        local iv = tonumber(Config.AsternDelay) or 0.1
        task.wait(math.max(0.04, iv))
        if Config.SpamAstern then
            pcall(function()
                local r = ReplicatedStorage:FindFirstChild("RemoteEvents")
                local g = r and r:FindFirstChild("Gui")
                local tgr = g and g:FindFirstChild("TelegraphOrderRetrieve")
                if tgr then
                    for idx = 1, 5 do
                        tgr:FireServer(idx, false, 5, true)
                    end
                    stats.lastFire = "spam astern 1..5"
                end
            end)
        end
    end
end)

-- loop spam bell
task.spawn(function()
    while not stopFlag do
        local iv = tonumber(Config.SpamBellDelay) or 0.1
        task.wait(math.max(0.04, iv))
        if Config.SpamBell then
            pcall(function()
                local r = ReplicatedStorage:FindFirstChild("RemoteEvents")
                local gp = r and r:FindFirstChild("Gameplay")
                local bs = gp and gp:FindFirstChild("BellSound")
                if bs then
                    bs:FireServer()
                    stats.lastFire = "spam bell"
                end
            end)
        end
    end
end)

---------------- FLINGS ----------------
Config.TouchFling = false
local flingBusy = false

local function FlingTarget(targetPlr)
    if not targetPlr or targetPlr == LP or not targetPlr.Character then return false end
    local myChar = LP.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local tarChar = targetPlr.Character
    local tarHrp = tarChar and tarChar:FindFirstChild("HumanoidRootPart")
    local tarHum = tarChar and tarChar:FindFirstChildOfClass("Humanoid")
    if not myHrp or not tarHrp or not myHum or myHum.Health <= 0 then return false end
    if not tarHum or tarHum.Health <= 0 then return false end

    local oldPos = myHrp.CFrame
    myHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    myHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

    local startTime = os.clock()
    while (os.clock() - startTime < 0.75) and tarHrp and tarHrp.Parent and tarHum.Health > 0 and myHum.Health > 0 do
        RunService.Heartbeat:Wait()
        if not myHrp or not tarHrp then break end
        myHrp.CFrame = tarHrp.CFrame * CFrame.new(0, math.random(-0.5, 0.5), 0)
        myHrp.AssemblyAngularVelocity = Vector3.new(0, 100000, 0)
        myHrp.AssemblyLinearVelocity = Vector3.new(0, 50, 0)
    end

    task.wait(0.05)
    if myHrp then
        myHrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        myHrp.CFrame = oldPos
    end
    return true
end

TabTroll:CreateSection("Flings")
TabTroll:CreateToggle({
    Name = "Touch Fling",
    CurrentValue = false,
    Flag = "tr_touchfling",
    Callback = function(v)
        Config.TouchFling = v
        notifyFn("Flings", v and "Touch Fling ON (Bumping players launches them!)" or "Touch Fling OFF", 2)
    end
})

task.spawn(function()
    while not stopFlag do
        RunService.Heartbeat:Wait()
        if Config.TouchFling and not flingBusy then
            pcall(function()
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 100000, 0)
                end
            end)
        end
    end
end)

TabTroll:CreateButton({
    Name = "Fling Nearest Player",
    Callback = function()
        if flingBusy then
            notifyFn("Flings", "Fling already in progress", 2)
            return
        end
        local myChar = LP.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end

        local nearest = nil
        local minDist = math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - myHrp.Position).Magnitude
                if d < minDist then
                    minDist = d
                    nearest = p
                end
            end
        end

        if not nearest then
            notifyFn("Flings", "No nearby player found", 2)
            return
        end

        flingBusy = true
        notifyFn("Flings", "Flinging: " .. nearest.Name, 2)
        FlingTarget(nearest)
        flingBusy = false
    end
})

TabTroll:CreateButton({
    Name = "Fling All Players",
    Callback = function()
        if flingBusy then
            notifyFn("Flings", "Fling already in progress", 2)
            return
        end
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(list, p)
            end
        end
        if #list == 0 then
            notifyFn("Flings", "No players to fling", 2)
            return
        end
        flingBusy = true
        notifyFn("Flings", "Flinging " .. #list .. " players...", 2)
        task.spawn(function()
            for _, p in ipairs(list) do
                if not stopFlag then
                    FlingTarget(p)
                    task.wait(0.1)
                end
            end
            flingBusy = false
            notifyFn("Flings", "Fling All completed!", 2)
        end)
    end
})

---------------- CHARACTER SIZE / SCALE ----------------
Config.CharScale = 1

local function ApplyCharacterScale(scale)
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    scale = tonumber(scale) or 1
    if scale < 0.2 then scale = 0.2 end
    if scale > 20 then scale = 20 end

    -- 1. Resize all character parts & accessories using Roblox native OriginalSize
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            local os = p:FindFirstChild("OriginalSize")
            if os and os:IsA("Vector3Value") then
                pcall(function() p.Size = os.Value * scale end)
            end
        elseif p:IsA("Attachment") then
            local op = p:FindFirstChild("OriginalPosition")
            if op and op:IsA("Vector3Value") then
                pcall(function() p.Position = op.Value * scale end)
            end
        elseif p:IsA("SpecialMesh") then
            local os = p.Parent and p.Parent:FindFirstChild("OriginalSize")
            if os then
                pcall(function() p.Scale = Vector3.new(scale, scale, scale) end)
            end
        end
    end

    -- 2. Scale HipHeight so character stands on ground properly
    pcall(function()
        hum.HipHeight = 2.22 * scale
    end)

    -- 3. Set Humanoid Scale values as well
    for _, name in ipairs({ "BodyDepthScale", "BodyHeightScale", "BodyWidthScale", "HeadScale" }) do
        local v = hum:FindFirstChild(name)
        if v then pcall(function() v.Value = scale end) end
    end
end

TabTroll:CreateSection("Character Scaling (Giant / Mini)")
local scaleSlider = nil
scaleSlider = TabTroll:CreateSlider({
    Name = "Scale Multiplier",
    Range = { 0.5, 10 },
    Increment = 0.5,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "tr_scale",
    Callback = function(v)
        Config.CharScale = v
        ApplyCharacterScale(v)
    end
})

TabTroll:CreateButton({
    Name = "Reset Scale to 1x",
    Callback = function()
        Config.CharScale = 1
        if scaleSlider then
            pcall(function() scaleSlider:Set(1) end)
        else
            ApplyCharacterScale(1)
        end
        notifyFn("Character Scale", "Reset scale to normal (1x)", 2)
    end
})

TabTroll:CreateParagraph({
    Title = "FE Notice (Other Players)",
    Content = "Under Roblox FilteringEnabled (FE), mesh scale values modified by the client do not replicate to other screens (FE Security). Other players see your higher elevation & physics collisions, but limb meshes remain normal on their view."
})

LP.CharacterAdded:Connect(function(newChar)
    if Config.CharScale and Config.CharScale ~= 1 then
        task.wait(1)
        ApplyCharacterScale(Config.CharScale)
    end
end)

-- ================= TAB 4: CREDITS & INFO =================
local TabCredits = Window:CreateTab("Credits", 4483362458)

TabCredits:CreateSection("DEVELOPERS & CREDITS")
TabCredits:CreateParagraph({
    Title = "Script Authors",
    Content = "- Creator: MintraZERX\n- YouTube: Valexcryzer\n- Game: Roblox Titanic (PlaceId: " .. tostring(game.PlaceId) .. ")"
})

TabCredits:CreateButton({
    Name = "Copy YouTube: Valexcryzer",
    Callback = function()
        if type(setclipboard) == "function" then
            setclipboard("Valexcryzer")
            notifyFn("Credits", "Copied 'Valexcryzer' to clipboard!", 2)
        end
    end
})

TabCredits:CreateSection("LIVE GAME & SERVER STATS")
local infoGamePara = TabCredits:CreateParagraph({
    Title = "Game & Server Stats",
    Content = "Loading stats..."
})

local infoSavePara = TabCredits:CreateParagraph({
    Title = "Save The Ship Event Info",
    Content = "Loading save event info..."
})

TabCredits:CreateButton({
    Name = "Copy Server Job ID",
    Callback = function()
        if type(setclipboard) == "function" then
            setclipboard(tostring(game.JobId))
            notifyFn("Server Info", "Copied JobId: " .. string.sub(tostring(game.JobId), 1, 8) .. "... to clipboard!", 2)
        end
    end
})

-- Realtime Updater for Credits & Info Tab
local function fmtSec(sec)
    sec = math.floor(tonumber(sec) or 0)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    if h > 0 then
        return string.format("%dh %02dm %02ds", h, m, s)
    else
        return string.format("%02dm %02ds", m, s)
    end
end

local orderStepNames = {
    [0] = "Step 1: Bell (Crow's Nest)",
    [1] = "Step 2: Telephone (Wheelhouse)",
    [2] = "Step 3: Wheel Steer (Helm)",
    [3] = "Step 4: Telegraph (Ahead/Stop)",
    [4] = "Step 5: Damper Flaps (Boiler Room)",
    [5] = "Completed (Ship Saved)"
}

task.spawn(function()
    while not stopFlag do
        task.wait(1)
        pcall(function()
            if not infoGamePara or not infoSavePara then return end

            local rep = game:GetService("ReplicatedStorage")
            local stsv = rep:FindFirstChild("SaveTheShipValues")
            local lead = LP:FindFirstChild("leaderstats")

            -- 1. Times & Players
            local gameSec = workspace.DistributedGameTime or 0
            local survSec = lead and lead:FindFirstChild("Time") and lead.Time.Value or 0
            local lifeVal = lead and lead:FindFirstChild("Life") and lead.Life.Value or 0
            local pCount = #Players:GetPlayers() .. " / " .. tostring(Players.MaxPlayers)
            local progTxt = readGameProgress()
            if progTxt == "" then progTxt = "Normal Sailing" end

            infoGamePara:Set({
                Title = "Game & Server Stats",
                Content = "- Game Time: " .. fmtSec(gameSec)
                    .. "\n- Survival Time: " .. fmtSec(survSec) .. " (Life: " .. tostring(lifeVal) .. ")"
                    .. "\n- Players Online: " .. pCount
                    .. "\n- Ship Progress / Story: " .. progTxt
                    .. "\n- Server JobId: " .. tostring(game.JobId)
            })

            -- 2. Save The Ship details
            local saveTimer = stsv and stsv:FindFirstChild("Timer") and stsv.Timer.Value or 0
            local saveMax = stsv and stsv:FindFirstChild("TimeGivenToSave") and stsv.TimeGivenToSave.Value or 0
            local saveOrder = stsv and stsv:FindFirstChild("OrderOfSaving") and stsv.OrderOfSaving.Value or 0
            local saveStreak = stsv and stsv:FindFirstChild("SavedInARow") and stsv.SavedInARow.Value or 0
            local isSaving = stsv and stsv:FindFirstChild("StartSaving") and stsv.StartSaving.Value or false
            local isSaved = stsv and stsv:FindFirstChild("SavedRound") and stsv.SavedRound.Value or false

            local evStatus = "Waiting for Event (Idle)"
            if isSaving then
                evStatus = "EVENT ACTIVE"
            elseif isSaved then
                evStatus = "SHIP SAVED"
            end

            local stepName = orderStepNames[saveOrder] or ("Step " .. tostring(saveOrder))

            infoSavePara:Set({
                Title = "Save The Ship Event Info",
                Content = "- Event Status: " .. evStatus
                    .. "\n- Save Timer: " .. string.format("%.1fs", saveTimer) .. " / " .. string.format("%.0fs", saveMax)
                    .. "\n- Current Task: " .. stepName
                    .. "\n- Saved Rounds Streak: " .. tostring(saveStreak)
            })
        end)
    end
end)

task.spawn(function()
    task.wait(0.4)
    SnapWindowToBottom()
    local lastH = 0
    while not stopFlag do
        task.wait(0.25)
        pcall(function()
            local main = GetRayfieldMain()
            if main and main.Visible then
                local p = main.Position
                local h = main.AbsoluteSize.Y
                if math.abs(p.X.Scale - 0.5) < 0.001 and math.abs(p.Y.Scale - 0.5) < 0.001 then
                    SnapWindowToBottom()
                elseif h >= 10 and math.abs(h - lastH) > 4 then
                    SnapWindowToBottom()
                    lastH = h
                end
            end
        end)
    end
end)

local function CleanupAll()
    stopFlag = true
    if heartbeatConn then heartbeatConn:Disconnect() heartbeatConn = nil end
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
end

GENV.__TIT_AUTO_STOP = CleanupAll
GENV.__TIT_AUTO = {
    Version = "2.4.1",
    Config = Config,
    Stats = stats,
}

notifyFn("Roblox Titanic", "Loaded v2.4.1 - MintraZERX & Valexcryzer", 4)
