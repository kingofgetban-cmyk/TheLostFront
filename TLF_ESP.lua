--[[
    THE LOST FRONT - ESP SUITE
    made by valexcryzer

    New standalone file. Does not modify any other script in this project.

    Tab 1 "Players" : lines, bones, box, health, weapon, mag, distance, team
    Tab 2 "Drones"  : drone ESP, enemy/friendly side check, enemy drone alerts
    Tab 3 "Combat"  : aimbot (smooth/camera + wall check), triggerbot
    Tab 4 "Weapon"  : no recoil, no spread, rapid fire, always auto, bullet speed, zero gravity, walkspeed

    Exports (for other scripts / console):
      getgenv().__TLF_ESP.IsEnemyDrone(instance)
      getgenv().__TLF_ESP.GetDroneSide(instance)
      getgenv().__TLF_ESP.ScanDrones()
      getgenv().__TLF_ESP.GetTeam(player)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = workspace
local LP = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled and not (UserInputService.KeyboardEnabled and UserInputService.MouseEnabled)

local GENV = (getgenv and getgenv()) or _G
local DrawingLib = GENV.Drawing or rawget(_G, "Drawing")

-- Stop a previous instance of this script before rebuilding anything.
if type(GENV.__TLF_ESP_STOP) == "function" then
    pcall(GENV.__TLF_ESP_STOP)
    GENV.__TLF_ESP_STOP = nil
end

if not DrawingLib then
    pcall(function() warn("[TLF] Drawing API not available in this executor.") end)
    return
end

-- ============================================================
-- RAYFIELD LOADER
-- ============================================================

local RAYFIELD_URLS = {
    "https://sirius.menu/rayfield",
    "https://raw.githubusercontent.com/jensonhirst/Rayfield/main/source",
}

local function FetchSource(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and type(res) == "string" and #res > 100 then return res end
    ok, res = pcall(function() return request({ Url = url, Method = "GET" }) end)
    if ok and type(res) == "table" then
        local body = res.Body or res.body
        if type(body) == "string" and #body > 100 then return body end
    end
    return nil
end

local function CleanupOldUI()
    pcall(function()
        local hui = gethui and gethui() or game:GetService("CoreGui")
        for _, c in ipairs(hui:GetChildren()) do
            if c.Name == "Rayfield" or c.Name:find("^Rayfield%-") or c.Name == "TLF_ESP_Labels" then
                pcall(function() c:Destroy() end)
            end
        end
    end)
    pcall(function()
        for _, p in ipairs(Players:GetPlayers()) do
            local char = p.Character
            if char then
                for _, d in ipairs(char:GetDescendants()) do
                    if d:IsA("BillboardGui") and d.Name == "TLF_ESP_Info" then
                        pcall(function() d:Destroy() end)
                    elseif d:IsA("Highlight") and d.Name == "TLF_ESP_Glow" then
                        pcall(function() d:Destroy() end)
                    end
                end
            end
        end
    end)
end

local function LoadRayfield()
    local g = (getgenv and getgenv()) or _G
    if type(g.__RAYFIELD) == "table" and g.__RAYFIELD.CreateWindow then
        return g.__RAYFIELD
    end
    for attempt = 1, 3 do
        for _, url in ipairs(RAYFIELD_URLS) do
            local src = FetchSource(url)
            if src then
                local okL, lib = pcall(function() return loadstring(src)() end)
                if okL and type(lib) == "table" and lib.CreateWindow then
                    g.__RAYFIELD = lib
                    return lib
                end
            end
        end
        task.wait(0.4)
    end
    return nil
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
        local margin = 16
        main.Position = UDim2.new(0.5, 0, 1, -(h / 2 + margin))
    end)
end

CleanupOldUI()
GENV.__RAYFIELD = nil
local Rayfield = LoadRayfield()

if not Rayfield then
    pcall(function() warn("[TLF] Rayfield failed to load.") end)
    return
end

-- ============================================================
-- CONFIG
-- ============================================================

local Config = {
    Players = true,
    Lines = true,
    Box = true,
    Bones = true,
    Health = true,
    Weapon = true,
    Ammo = true,
    Distance = true,
    Team = true,
    TeamCheck = false,
    MaxDistance = 600,
    DroneEsp = true,
    DroneEnemyOnly = false,
    DroneAlerts = true,

    -- Weapon
    NoRecoil = false,
    NoSpread = false,
    RapidFire = false,
    FireCooldown = 0.05,
    AlwaysAuto = false,
    FastBullet = false,
    BulletSpeedVal = 5000,
    NoBulletDrop = false,
    AutoPickupAmmo = true,
    PickupRadius = 25,

    -- Settings
    ModDetector = true,
    ModAutoLeave = false,

    -- Combat
    AimEnabled = false,
    AimMethod = isMobile and "Camera (Direct)" or "Mouse (Smooth)",
    AimKey = "LeftAlt",
    AimAlways = false,
    AimPart = "Head",
    AimFov = 180,
    AimSmoothness = 35,
    AimMaxDistance = 500,
    AimTeamCheck = true,
    AimWallCheck = true,
    AimDrones = true,
    AimRightMouse = true,
    AimShowFov = true,
    MobileAimButton = isMobile,
    MobileAimToggle = false,
    MobileBtnSize = 65,

    -- Silent Aim & Prediction
    SilentAim = true,
    SilentAimFov = 800,
    SilentAimPart = "Head",
    SilentAimWallCheck = false,
    PredictionEnabled = true,

    TriggerBot = false,
    TriggerDistance = 150,
    TriggerDelay = 120,
}

local aimHeld = false
local rmbHeld = false
local mobileAimActive = false
local mobileGui = nil
local mobileAimBtn = nil

local function createMobileAimButton()
    if mobileGui then
        pcall(function() mobileGui:Destroy() end)
        mobileGui = nil
        mobileAimBtn = nil
    end

    if not Config.MobileAimButton then return end

    local parentGui = (type(gethui) == "function" and gethui())
        or (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui"))
        or (LP and LP:FindFirstChild("PlayerGui"))

    if not parentGui then return end

    local sg = Instance.new("ScreenGui")
    sg.Name = "TLF_MobileAimGui"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local btnSize = Config.MobileBtnSize or 65
    local btn = Instance.new("TextButton")
    btn.Name = "MobileAimButton"
    btn.Size = UDim2.new(0, btnSize, 0, btnSize)
    btn.Position = UDim2.new(0.85, -btnSize, 0.45, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.BackgroundTransparency = 0.2
    btn.Text = "AIM"
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.Active = true
    btn.Draggable = true
    btn.Parent = sg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(80, 255, 120)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    local function setVisual(active)
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(40, 160, 70)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            stroke.Color = Color3.fromRGB(120, 255, 160)
            stroke.Thickness = 3
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            stroke.Color = Color3.fromRGB(80, 255, 120)
            stroke.Thickness = 2
        end
    end

    if Config.MobileAimToggle then
        btn.MouseButton1Click:Connect(function()
            mobileAimActive = not mobileAimActive
            aimHeld = mobileAimActive
            setVisual(mobileAimActive)
        end)
    else
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                mobileAimActive = true
                aimHeld = true
                setVisual(true)
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                mobileAimActive = false
                aimHeld = false
                setVisual(false)
            end
        end)
    end

    mobileGui = sg
    mobileAimBtn = btn
    sg.Parent = parentGui
end
local lastAimTarget = nil
local combatStatusPara = nil
local shotHookReady = false
local shotHookError = ""
local shotDiag = { fires = 0, applied = 0, noTarget = 0, lastFireAt = 0 }
local replicateCaptureError = ""
local shotHookWrapped = nil
local aimFovCircle = nil
local aimBeganConn = nil
local aimEndedConn = nil
local aimKeyChangedConn = nil
local aimKeybindSettings = nil
local combatBound = false

-- ============================================================
-- HELPERS / TEAM / WEAPON / AMMO
-- ============================================================

local function notify(title, content, duration)
    pcall(function()
        Rayfield:Notify({
            Title = title,
            Content = content,
            Duration = duration or 4,
            Image = 4483362458,
        })
    end)
end

local function shortTeamName(raw)
    if not raw or raw == "" then return "?" end
    local l = tostring(raw):lower()
    if l:find("attack") then return "ATK" end
    if l:find("defend") then return "DEF" end
    if l:find("spec") then return "SPEC" end
    if l:find("red") then return "RED" end
    if l:find("blue") then return "BLUE" end
    if l:find("green") then return "GREEN" end
    return tostring(raw):upper():sub(1, 6)
end

local function teamColorOf(raw)
    local s = shortTeamName(raw)
    if s == "ATK" or s == "RED" then return Color3.fromRGB(255, 45, 45) end
    if s == "DEF" or s == "BLUE" then return Color3.fromRGB(45, 145, 255) end
    if s == "GREEN" then return Color3.fromRGB(50, 235, 95) end
    return Color3.fromRGB(255, 255, 255)
end

local function readTeamValue(v)
    if v == nil then return nil end
    if typeof(v) == "string" then
        if v ~= "" then return v end
        return nil
    end
    if typeof(v) == "Instance" then
        if v:IsA("StringValue") then
            if v.Value ~= "" then return v.Value end
        elseif v:IsA("ObjectValue") then
            if v.Value then return v.Value.Name end
        elseif v:IsA("Team") then
            return v.Name
        end
    end
    return nil
end

local teamKeys = { "Team", "team", "TeamName", "teamName", "Side", "side", "Faction", "faction", "Country", "country" }
local guiTeamMap = {}
local lastGuiTeamRefresh = 0

local function collectGuiTeam(gui)
    if not gui then return end
    for _, sideName in ipairs({ "attackers", "defenders" }) do
        local frame = gui:FindFirstChild(sideName, true)
        if frame then
            for _, d in ipairs(frame:GetDescendants()) do
                if d:IsA("TextLabel") then
                    local txt = d.Text
                    if txt and txt ~= "" and Players:FindFirstChild(txt) then
                        guiTeamMap[txt] = sideName
                    end
                end
            end
        end
    end
end

local function refreshGuiTeamMap()
    guiTeamMap = {}
    pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        if not pg then return end
        collectGuiTeam(pg:FindFirstChild("teams"))
        collectGuiTeam(pg:FindFirstChild("leaderboard"))
    end)
end

local function resolveTeam(p)
    if not p then return nil end
    local char = p.Character
    if char and char.Parent then
        local fn = char.Parent.Name
        if fn == "lIIooolll" then return "attackers" end
        if fn == "IIoooIIl" then return "defenders" end
    end
    local teamRoot = workspace:FindFirstChild("IIIIllllIIIllIIlIlI_IIllIlIIIllII_o")
    if teamRoot then
        local atk = teamRoot:FindFirstChild("lIIooolll")
        if atk and atk:FindFirstChild(p.Name) then return "attackers" end
        local def = teamRoot:FindFirstChild("IIoooIIl")
        if def and def:FindFirstChild(p.Name) then return "defenders" end
    end
    if p.Team then return p.Team.Name end
    local tc = p.TeamColor
    if tc then
        local okN, tcName = pcall(function() return tc.Name end)
        if okN and tcName and tcName ~= "White" then
            local n = tostring(tcName):lower()
            if n:find("red") then return "red" end
            if n:find("blue") then return "blue" end
            if n:find("green") then return "green" end
            return tostring(tcName)
        end
    end
    for _, k in ipairs(teamKeys) do
        local ok, v = pcall(function() return p:GetAttribute(k) end)
        if ok then
            local t = readTeamValue(v)
            if t then return t end
        end
        local c = p:FindFirstChild(k)
        if c then
            local t = readTeamValue(c)
            if t then return t end
        end
    end
    local active = ReplicatedStorage:FindFirstChild("active")
    local activePlayers = active and active:FindFirstChild("players")
    local pf = activePlayers and activePlayers:FindFirstChild(p.Name)
    if pf then
        for _, k in ipairs(teamKeys) do
            local ok, v = pcall(function() return pf:GetAttribute(k) end)
            if ok then
                local t = readTeamValue(v)
                if t then return t end
            end
            local c = pf:FindFirstChild(k)
            if c then
                local t = readTeamValue(c)
                if t then return t end
            end
        end
    end
    local char = p.Character
    if char then
        for _, k in ipairs(teamKeys) do
            local ok, v = pcall(function() return char:GetAttribute(k) end)
            if ok then
                local t = readTeamValue(v)
                if t then return t end
            end
            local c = char:FindFirstChild(k)
            if c then
                local t = readTeamValue(c)
                if t then return t end
            end
        end
    end
    return guiTeamMap[p.Name]
end

local function isEnemyPlayer(p)
    if not p or p == LP then return false end
    local teamRoot = workspace:FindFirstChild("IIIIllllIIIllIIlIlI_IIllIlIIIllII_o")
    local myFolder = nil
    local itsFolder = nil

    if LP.Character and LP.Character.Parent then
        myFolder = LP.Character.Parent.Name
    end
    if (not myFolder or (myFolder ~= "lIIooolll" and myFolder ~= "IIoooIIl")) and teamRoot then
        local atk = teamRoot:FindFirstChild("lIIooolll")
        if atk and atk:FindFirstChild(LP.Name) then myFolder = "lIIooolll" end
        local def = teamRoot:FindFirstChild("IIoooIIl")
        if def and def:FindFirstChild(LP.Name) then myFolder = "IIoooIIl" end
    end

    if p.Character and p.Character.Parent then
        itsFolder = p.Character.Parent.Name
    end
    if (not itsFolder or (itsFolder ~= "lIIooolll" and itsFolder ~= "IIoooIIl")) and teamRoot then
        local atk = teamRoot:FindFirstChild("lIIooolll")
        if atk and atk:FindFirstChild(p.Name) then itsFolder = "lIIooolll" end
        local def = teamRoot:FindFirstChild("IIoooIIl")
        if def and def:FindFirstChild(p.Name) then itsFolder = "IIoooIIl" end
    end

    if myFolder and itsFolder then
        if (myFolder == "lIIooolll" and itsFolder == "IIoooIIl") or (myFolder == "IIoooIIl" and itsFolder == "lIIooolll") then
            return true
        end
        if myFolder == itsFolder and (myFolder == "lIIooolll" or myFolder == "IIoooIIl") then
            return false
        end
    end

    if p.Team and LP.Team then
        return p.Team ~= LP.Team
    end

    local myTeam = resolveTeam(LP)
    local itsTeam = resolveTeam(p)
    if myTeam and itsTeam then
        local myShort = shortTeamName(myTeam)
        local itsShort = shortTeamName(itsTeam)
        if myShort ~= "?" and itsShort ~= "?" then
            return myShort ~= itsShort
        end
    end

    return false
end

local function isTeammatePlayer(p)
    if not p or p == LP then return true end
    return not isEnemyPlayer(p)
end

local WEAPON_NAMES = {
    ["makarov"] = "Makarov",
    ["ak-74m"] = "AK-74M",
    ["ak-74"] = "AK-74",
    ["akm"] = "AKM",
    ["ak-12"] = "AK-12",
    ["aks-74u"] = "AKS-74U",
    ["sks"] = "SKS",
    ["svd"] = "SVD",
    ["vss"] = "VSS",
    ["vssold"] = "VSS",
    ["asval"] = "AS VAL",
    ["pkm"] = "PKM",
    ["rpk"] = "RPK",
    ["rpd"] = "RPD",
    ["ks23"] = "KS-23",
    ["saiga12"] = "Saiga-12",
    ["m16a1"] = "M16A1",
    ["m1911"] = "M1911",
    ["skorpion"] = "Skorpion",
    ["gl06"] = "GL06",
    ["rpg-7"] = "RPG-7",
    ["rpg-22"] = "RPG-22",
    ["rgd-5"] = "RGD-5",
    ["f1"] = "F1",
    ["controller"] = "Controller",
    ["bandage"] = "Bandage",
    ["none"] = "Unarmed",
    ["fpv"] = "FPV Drone",
    ["hdm"] = "HDM",
}

local function prettyWeapon(name)
    if not name or name == "" then return "Unarmed" end
    return WEAPON_NAMES[name:lower()] or name
end

local function readAmmo(container)
    if not container then return nil end
    for _, d in ipairs(container:GetDescendants()) do
        if d:IsA("ValueBase") then
            local n = d.Name:lower()
            if n:find("ammo") or n:find("mag") or n:find("clip") or n:find("round") or n:find("bullet") then
                local v = d.Value
                if type(v) == "number" then return tostring(v) end
            end
        end
    end
    for _, k in ipairs({ "Ammo", "AmmoCount", "Mag", "Magazine", "Clip", "CurrentAmmo", "Rounds", "Bullets" }) do
        local ok, v = pcall(function() return container:GetAttribute(k) end)
        if ok and type(v) == "number" then return tostring(v) end
    end
    return nil
end

local GADGET_NAMES = { ["bandage"] = true, ["controller"] = true, ["none"] = true }

local function resolveWeaponAmmo(p)
    local weapon, ammo = nil, nil
    local active = ReplicatedStorage:FindFirstChild("active")
    local activePlayers = active and active:FindFirstChild("players")
    local pf = activePlayers and activePlayers:FindFirstChild(p.Name)
    if pf then
        local candidates = {}
        for _, c in ipairs(pf:GetChildren()) do
            if c:IsA("Model") or c:IsA("Folder") then
                candidates[#candidates + 1] = c
            end
        end
        local chosen = nil
        for _, c in ipairs(candidates) do
            local n = c.Name:lower()
            if not GADGET_NAMES[n] and n ~= "fpv" then
                chosen = c
                break
            end
        end
        if not chosen then
            for _, c in ipairs(candidates) do
                if c.Name:lower() == "fpv" then
                    chosen = c
                    break
                end
            end
        end
        if not chosen and candidates[1] then chosen = candidates[1] end
        if chosen then
            weapon = chosen.Name
            ammo = readAmmo(chosen)
        end
    end
    if not weapon then
        local char = p.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then
            weapon = tool.Name
            ammo = readAmmo(tool)
        end
    end
    return weapon, ammo
end

local dataCache = {}

local function getPlayerData(p)
    local c = dataCache[p]
    local now = os.clock()
    if not c or not c.t or (now - c.t) > 0.5 then
        c = c or {}
        c.t = now
        c.team = resolveTeam(p)
        c.weapon, c.ammo = resolveWeaponAmmo(p)
        dataCache[p] = c
    end
    return c
end

-- ============================================================
-- DRONE HELPERS
-- ============================================================

local droneData = {}
local dronePools = {}
local dronePilots = {}
local alertedDrones = {}
local alertedPilots = {}
local droneStatusText = "Scanning..."
local dronePara = nil

local function setDroneStatus(text)
    droneStatusText = text
    if dronePara then
        local ok = pcall(function() dronePara:Set({ Title = "Drone Status", Content = text }) end)
        if not ok then
            pcall(function() dronePara:Set(text) end)
        end
    end
end

local function updateDroneStatus()
    local total, enemies, friendlies, unknown = 0, 0, 0, 0
    for model, info in pairs(droneData) do
        if model.Parent then
            total = total + 1
            if info.side == "enemy" then enemies = enemies + 1
            elseif info.side == "friendly" then friendlies = friendlies + 1
            else unknown = unknown + 1 end
        end
    end
    local pEnemy, pFriendly = 0, 0
    for _, info in pairs(dronePilots) do
        if info.side == "enemy" then pEnemy = pEnemy + 1
        elseif info.side == "friendly" then pFriendly = pFriendly + 1 end
    end
    local text = "Drones: " .. total .. " | Enemy: " .. enemies .. " | Friendly: " .. friendlies
    if unknown > 0 then text = text .. " | Unknown: " .. unknown end
    text = text .. " | Pilots E:" .. pEnemy .. " F:" .. pFriendly
    setDroneStatus(text)
end

local droneOwnerKeys = { "Owner", "owner", "Player", "player", "PlayerName", "OwnerName", "Creator", "creator", "User", "Deployer", "Placer" }

local function playerFromValue(v)
    if v == nil then return nil end
    if type(v) == "string" then
        return Players:FindFirstChild(v)
    end
    if typeof(v) == "Instance" then
        if v:IsA("Player") then return v end
        if v:IsA("ObjectValue") and v.Value and v.Value:IsA("Player") then return v.Value end
    end
    return nil
end

local function resolveDroneOwner(model)
    if not model then return nil end
    for _, k in ipairs(droneOwnerKeys) do
        local ok, v = pcall(function() return model:GetAttribute(k) end)
        if ok then
            local p = playerFromValue(v)
            if p then return p end
        end
        local c = model:FindFirstChild(k)
        if c then
            local p = playerFromValue(c)
            if p then return p end
        end
    end
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("ObjectValue") and d.Value and d.Value:IsA("Player") then
            return d.Value
        elseif d:IsA("StringValue") then
            local p = Players:FindFirstChild(tostring(d.Value))
            if p then return p end
        end
        for _, k in ipairs(droneOwnerKeys) do
            local ok, v = pcall(function() return d:GetAttribute(k) end)
            if ok then
                local p = playerFromValue(v)
                if p then return p end
            end
        end
    end
    local anc = model
    while anc and anc ~= Workspace do
        local p = Players:FindFirstChild(anc.Name)
        if p then return p end
        anc = anc.Parent
    end
    local tool = model:FindFirstAncestorOfClass("Tool")
    if tool then
        local p = Players:GetPlayerFromCharacter(tool.Parent)
        if p then return p end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if #p.Name >= 4 and model.Name:lower():find(p.Name:lower(), 1, true) then
            return p
        end
    end
    return nil
end

local function resolveInstanceTeam(inst)
    if not inst then return nil end
    for _, k in ipairs({ "Team", "team", "Side", "side", "Faction", "faction" }) do
        local ok, v = pcall(function() return inst:GetAttribute(k) end)
        if ok then
            local t = readTeamValue(v)
            if t then return t end
        end
    end
    return nil
end

local function sideOfPlayer(owner)
    if not owner then return "unknown" end
    if owner == LP then return "friendly" end
    local myTeam = getPlayerData(LP).team
    local itsTeam = getPlayerData(owner).team
    if myTeam and itsTeam then
        local a, b = shortTeamName(myTeam), shortTeamName(itsTeam)
        if a ~= "?" and b ~= "?" then
            if a == b then return "friendly" end
            return "enemy"
        end
    end
    return "unknown"
end

local function droneSide(model)
    local owner = resolveDroneOwner(model)
    if owner then
        return sideOfPlayer(owner), owner
    end
    local t = resolveInstanceTeam(model)
    if t then
        local myTeam = getPlayerData(LP).team
        if myTeam then
            local a, b = shortTeamName(myTeam), shortTeamName(t)
            if a ~= "?" and b ~= "?" then
                if a == b then return "friendly", nil end
                return "enemy", nil
            end
        end
    end
    return "unknown", nil
end

local function scanDronesNow()
    local found = {}
    local seen = {}
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and not seen[obj] then
                local n = obj.Name:lower()
                local isDrone = n:find("drone") ~= nil or n == "fpv" or n == "uav" or n == "hdm"
                if not isDrone then
                    local okD = pcall(function()
                        if obj:GetAttribute("throttle") ~= nil and obj:GetAttribute("battery") ~= nil then
                            isDrone = true
                        end
                    end)
                    if not okD then isDrone = false end
                end
                if isDrone and (obj.PrimaryPart ~= nil or obj:FindFirstChildWhichIsA("BasePart") ~= nil) then
                    seen[obj] = true
                    found[#found + 1] = obj
                end
            end
        end
    end)
    pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        local dg = pg and pg:FindFirstChild("drone")
        local ov = dg and dg:FindFirstChild("droneInstance", true)
        if ov and ov.Value and ov.Value:IsA("Model") and not seen[ov.Value] then
            seen[ov.Value] = true
            found[#found + 1] = ov.Value
        end
    end)
    local newData = {}
    for _, model in ipairs(found) do
        local side, owner = droneSide(model)
        newData[model] = { side = side, owner = owner }
    end
    droneData = newData

    local pilots = {}
    pcall(function()
        local active = ReplicatedStorage:FindFirstChild("active")
        local activePlayers = active and active:FindFirstChild("players")
        if activePlayers then
            for _, pf in ipairs(activePlayers:GetChildren()) do
                local owner = Players:FindFirstChild(pf.Name)
                if owner then
                    local hasFpv = false
                    for _, c in ipairs(pf:GetChildren()) do
                        local n = c.Name:lower()
                        if n == "fpv" then
                            hasFpv = true
                            break
                        end
                        local okD = pcall(function()
                            if c:GetAttribute("throttle") ~= nil and c:GetAttribute("battery") ~= nil then
                                hasFpv = true
                            end
                        end)
                        if not okD then hasFpv = hasFpv end
                        if hasFpv then break end
                    end
                    if hasFpv then
                        pilots[pf.Name] = { side = sideOfPlayer(owner), player = owner }
                    end
                end
            end
        end
    end)
    dronePilots = pilots

    return found
end

-- ============================================================
-- UI
-- ============================================================

local UI_TITLE = "The Lost Front"
local UI_AUTHOR = "made by valexcryzer"

local Window = Rayfield:CreateWindow({
    Name = UI_TITLE,
    LoadingTitle = UI_TITLE,
    LoadingSubtitle = UI_AUTHOR,
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false,
})

task.spawn(function()
    task.wait(0.4)
    SnapWindowToBottom()
    local lastH = 0
    while true do
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

local PlayersTab = Window:CreateTab("Players", 4483362458)
local DronesTab = Window:CreateTab("Drones", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local WeaponTab = Window:CreateTab("Weapon", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

PlayersTab:CreateSection("PLAYER ESP")

PlayersTab:CreateToggle({
    Name = "ESP Enabled",
    CurrentValue = true,
    Flag = "tlf_esp_enabled",
    Callback = function(v) Config.Players = v end,
})

PlayersTab:CreateToggle({
    Name = "Lines",
    CurrentValue = true,
    Flag = "tlf_lines",
    Callback = function(v) Config.Lines = v end,
})

PlayersTab:CreateToggle({
    Name = "Bone Skeleton",
    CurrentValue = true,
    Flag = "tlf_bones",
    Callback = function(v) Config.Bones = v end,
})

PlayersTab:CreateToggle({
    Name = "Box",
    CurrentValue = true,
    Flag = "tlf_box",
    Callback = function(v) Config.Box = v end,
})

PlayersTab:CreateToggle({
    Name = "Health",
    CurrentValue = true,
    Flag = "tlf_health",
    Callback = function(v) Config.Health = v end,
})

PlayersTab:CreateToggle({
    Name = "Weapon",
    CurrentValue = true,
    Flag = "tlf_weapon",
    Callback = function(v) Config.Weapon = v end,
})

PlayersTab:CreateToggle({
    Name = "Magazine",
    CurrentValue = true,
    Flag = "tlf_ammo",
    Callback = function(v) Config.Ammo = v end,
})

PlayersTab:CreateLabel("Mag uses replicated values only; The Lost Front does not replicate other players' ammo.")

PlayersTab:CreateToggle({
    Name = "Distance",
    CurrentValue = true,
    Flag = "tlf_distance",
    Callback = function(v) Config.Distance = v end,
})

PlayersTab:CreateToggle({
    Name = "Team",
    CurrentValue = true,
    Flag = "tlf_team",
    Callback = function(v) Config.Team = v end,
})

PlayersTab:CreateSection("FILTERS")

PlayersTab:CreateToggle({
    Name = "Team Check (hide teammates)",
    CurrentValue = false,
    Flag = "tlf_teamcheck",
    Callback = function(v) Config.TeamCheck = v end,
})

PlayersTab:CreateSlider({
    Name = "Max Distance",
    Range = { 50, 2000 },
    Increment = 50,
    Suffix = " studs",
    CurrentValue = 600,
    Flag = "tlf_maxdist",
    Callback = function(v) Config.MaxDistance = v end,
})

local playerStatus = nil
do
    local ok, label = pcall(function() return PlayersTab:CreateLabel("Tracked: 0 | Enemies: 0") end)
    if ok then playerStatus = label end
end

DronesTab:CreateSection("DRONE RADAR")

DronesTab:CreateToggle({
    Name = "Drone ESP",
    CurrentValue = true,
    Flag = "tlf_drone_esp",
    Callback = function(v) Config.DroneEsp = v end,
})

DronesTab:CreateToggle({
    Name = "Enemy Drones Only",
    CurrentValue = false,
    Flag = "tlf_drone_enemyonly",
    Callback = function(v) Config.DroneEnemyOnly = v end,
})

DronesTab:CreateToggle({
    Name = "Enemy Drone Alerts",
    CurrentValue = true,
    Flag = "tlf_drone_alerts",
    Callback = function(v) Config.DroneAlerts = v end,
})

do
    local ok, para = pcall(function()
        return DronesTab:CreateParagraph({ Title = "Drone Status", Content = "Scanning..." })
    end)
    if ok then
        dronePara = para
    else
        local ok2, label = pcall(function() return DronesTab:CreateLabel("Scanning...") end)
        if ok2 then dronePara = label end
    end
end

DronesTab:CreateButton({
    Name = "Scan Drones Now",
    Callback = function()
        local found = scanDronesNow()
        local enemies, friendlies, unknown = 0, 0, 0
        for _, model in ipairs(found) do
            local info = droneData[model]
            local side = info and info.side or "unknown"
            if side == "enemy" then enemies = enemies + 1
            elseif side == "friendly" then friendlies = friendlies + 1
            else unknown = unknown + 1 end
        end
        notify("Drone Scan", #found .. " found | enemy: " .. enemies .. " | friendly: " .. friendlies .. " | unknown: " .. unknown, 5)
        updateDroneStatus()
    end,
})

DronesTab:CreateLabel("Side check: drone owner team vs your team")

CombatTab:CreateSection("SILENT AIM & PREDICTION")

CombatTab:CreateToggle({
    Name = "Silent Aim (กระสุนล็อกหัว ไม่ขยับกล้อง)",
    CurrentValue = true,
    Flag = "tlf_silent_aim",
    Callback = function(v)
        Config.SilentAim = v
    end,
})

CombatTab:CreateToggle({
    Name = "Bullet Prediction (คำนวณยิงดักหน้า)",
    CurrentValue = true,
    Flag = "tlf_prediction",
    Callback = function(v)
        Config.PredictionEnabled = v
    end,
})

CombatTab:CreateSlider({
    Name = "Silent Aim FOV",
    Range = { 50, 2000 },
    Increment = 25,
    Suffix = " px",
    CurrentValue = 800,
    Flag = "tlf_silent_fov",
    Callback = function(v)
        Config.SilentAimFov = v
    end,
})

CombatTab:CreateDropdown({
    Name = "Silent Aim Target Part",
    Options = { "Head", "Torso", "Nearest" },
    CurrentOption = { "Head" },
    MultipleOptions = false,
    Flag = "tlf_silent_part",
    Callback = function(option)
        local v = type(option) == "table" and option[1] or option
        Config.SilentAimPart = tostring(v or "Head")
    end,
})

CombatTab:CreateToggle({
    Name = "Silent Aim Wall Check (เช็กกำแพง)",
    CurrentValue = false,
    Flag = "tlf_silent_wallcheck",
    Callback = function(v)
        Config.SilentAimWallCheck = v
    end,
})

CombatTab:CreateSection("AIMBOT (CAMERA / MOUSE)")

CombatTab:CreateToggle({
    Name = "AimBot",
    CurrentValue = false,
    Flag = "tlf_aim_enabled",
    Callback = function(v)
        Config.AimEnabled = v
        if not v then aimHeld = false end
    end,
})

CombatTab:CreateDropdown({
    Name = "Aim Method",
    Options = { "Mouse (Smooth)", "Camera (Direct)" },
    CurrentOption = { "Mouse (Smooth)" },
    MultipleOptions = false,
    Flag = "tlf_aim_method",
    Callback = function(option)
        local v = type(option) == "table" and option[1] or option
        Config.AimMethod = tostring(v or "Mouse (Smooth)")
    end,
})

do
    local ok, obj = pcall(function()
        return CombatTab:CreateKeybind({
            Name = "Aim Key (hold)",
            CurrentKeybind = "LeftAlt",
            HoldToInteract = false,
            Flag = "tlf_aim_key",
            Callback = function() end,
        })
    end)
    if ok and obj and obj.CurrentKeybind then
        aimKeybindSettings = obj
        Config.AimKey = tostring(obj.CurrentKeybind or "LeftAlt")
        task.spawn(function()
            while aimKeybindSettings == obj do
                task.wait(0.25)
                local key = tostring(obj.CurrentKeybind or "")
                if key ~= "" and key ~= Config.AimKey then
                    Config.AimKey = key
                    aimHeld = false
                end
            end
        end)
    else
        CombatTab:CreateDropdown({
            Name = "Aim Key (hold)",
            Options = { "LeftAlt", "Q", "E", "T", "F", "C", "X", "Z", "Always" },
            CurrentOption = { "LeftAlt" },
            MultipleOptions = false,
            Flag = "tlf_aim_key_dd",
            Callback = function(option)
                local v = type(option) == "table" and option[1] or option
                Config.AimKey = tostring(v or "LeftAlt")
                aimHeld = false
            end,
        })
    end
end

CombatTab:CreateToggle({
    Name = "Always Aim (no key)",
    CurrentValue = false,
    Flag = "tlf_aim_always",
    Callback = function(v) Config.AimAlways = v end,
})

CombatTab:CreateToggle({
    Name = "Aim On Right Mouse",
    CurrentValue = true,
    Flag = "tlf_aim_rmb",
    Callback = function(v) Config.AimRightMouse = v end,
})

CombatTab:CreateDropdown({
    Name = "Target Part",
    Options = { "Head", "Torso", "Nearest" },
    CurrentOption = { "Head" },
    MultipleOptions = false,
    Flag = "tlf_aim_part",
    Callback = function(option)
        local v = type(option) == "table" and option[1] or option
        Config.AimPart = tostring(v or "Head")
    end,
})

CombatTab:CreateSlider({
    Name = "Aim FOV",
    Range = { 40, 800 },
    Increment = 10,
    Suffix = " px",
    CurrentValue = 180,
    Flag = "tlf_aim_fov",
    Callback = function(v) Config.AimFov = v end,
})

CombatTab:CreateToggle({
    Name = "Aim Show FOV Circle",
    CurrentValue = true,
    Flag = "tlf_aim_showfov",
    Callback = function(v) Config.AimShowFov = v end,
})

CombatTab:CreateSlider({
    Name = "Aim Smoothness",
    Range = { 0, 100 },
    Increment = 1,
    Suffix = "%",
    CurrentValue = 35,
    Flag = "tlf_aim_smooth",
    Callback = function(v) Config.AimSmoothness = v end,
})

CombatTab:CreateSlider({
    Name = "Aim Max Distance",
    Range = { 50, 1500 },
    Increment = 50,
    Suffix = " studs",
    CurrentValue = 500,
    Flag = "tlf_aim_maxdist",
    Callback = function(v) Config.AimMaxDistance = v end,
})

CombatTab:CreateToggle({
    Name = "Aim Team Check",
    CurrentValue = true,
    Flag = "tlf_aim_teamcheck",
    Callback = function(v) Config.AimTeamCheck = v end,
})

CombatTab:CreateToggle({
    Name = "Aim Wall Check (Visible Only)",
    CurrentValue = true,
    Flag = "tlf_aim_wallcheck",
    Callback = function(v) Config.AimWallCheck = v end,
})

CombatTab:CreateToggle({
    Name = "Aim Target Enemy Drones",
    CurrentValue = true,
    Flag = "tlf_aim_drones",
    Callback = function(v) Config.AimDrones = v end,
})

CombatTab:CreateSection("TRIGGER")

CombatTab:CreateToggle({
    Name = "Trigger Bot",
    CurrentValue = false,
    Flag = "tlf_trigger",
    Callback = function(v) Config.TriggerBot = v end,
})

CombatTab:CreateSlider({
    Name = "Trigger Distance",
    Range = { 10, 1000 },
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 150,
    Flag = "tlf_trigger_dist",
    Callback = function(v) Config.TriggerDistance = v end,
})

CombatTab:CreateSlider({
    Name = "Trigger Delay",
    Range = { 0, 500 },
    Increment = 10,
    Suffix = " ms",
    CurrentValue = 120,
    Flag = "tlf_trigger_delay",
    Callback = function(v) Config.TriggerDelay = v end,
})

CombatTab:CreateSection("MOBILE CONTROLS")

CombatTab:CreateToggle({
    Name = "Mobile Floating Aim Button",
    CurrentValue = isMobile,
    Flag = "tlf_mobile_btn",
    Callback = function(v)
        Config.MobileAimButton = v
        createMobileAimButton()
    end,
})

CombatTab:CreateToggle({
    Name = "Mobile Button: Tap to Toggle",
    CurrentValue = false,
    Flag = "tlf_mobile_toggle",
    Callback = function(v)
        Config.MobileAimToggle = v
        createMobileAimButton()
    end,
})

CombatTab:CreateSlider({
    Name = "Mobile Button Size",
    Range = { 45, 100 },
    Increment = 5,
    Suffix = " px",
    CurrentValue = 65,
    Flag = "tlf_mobile_size",
    Callback = function(v)
        Config.MobileBtnSize = v
        createMobileAimButton()
    end,
})

do
    local ok, para = pcall(function()
        return CombatTab:CreateParagraph({ Title = "Combat Status", Content = "Idle" })
    end)
    if ok then
        combatStatusPara = para
    else
        local ok2, label = pcall(function() return CombatTab:CreateLabel("Combat Status: Idle") end)
        if ok2 then combatStatusPara = label end
    end
end

-- ============================================================
-- WEAPON TAB & MODIFIER LOGIC
-- ============================================================

local cachedWeapons = {}
local originalWeaponStats = {}
local originalMakeSpread = nil
local originalCalculateDirection = nil
local originalRaycast = nil
local weaponStatusLabel = nil
local lastWeaponScan = 0

-- Forward declarations for Combat & Silent Aim
local findCombatTarget = nil
local getTargetPosition = nil
local getPredictedTargetPosition = nil

local function makeWritable(t)
    if type(t) == "table" then
        if table.isfrozen and table.isfrozen(t) and setreadonly then
            pcall(setreadonly, t, false)
        elseif setreadonly then
            pcall(setreadonly, t, false)
        end
    end
end

local function hookSpreadModule()
    local okM, shotMod = pcall(function()
        local mod = ReplicatedStorage:FindFirstChild("lIIIlllIIlIllIlllllIIllllIlllIlIlIIlIllIllllIIlIllIlllllIllI")
        return mod and require(mod) or nil
    end)
    if okM and type(shotMod) == "table" then
        -- 1. Hook makeSpread (Visual bullet direction)
        if type(shotMod.makeSpread) == "function" then
            if not originalMakeSpread then
                originalMakeSpread = shotMod.makeSpread
            end
            shotMod.makeSpread = function(min_s, max_s, origin, direction, ...)
                if Config.SilentAim and type(findCombatTarget) == "function" then
                    local cam = Workspace.CurrentCamera
                    local shootOrigin = (typeof(origin) == "Vector3" and origin) or (cam and cam.CFrame.Position)
                    local sTarget = findCombatTarget({
                        fov = Config.SilentAimFov or 800,
                        maxDistance = Config.AimMaxDistance or 1500,
                        players = true,
                        drones = Config.AimDrones,
                        teamCheck = Config.AimTeamCheck,
                        wallCheck = Config.SilentAimWallCheck,
                        part = Config.SilentAimPart or Config.AimPart or "Head",
                    })
                    if sTarget and shootOrigin then
                        local predPos = nil
                        if Config.PredictionEnabled and type(getPredictedTargetPosition) == "function" then
                            predPos = getPredictedTargetPosition(sTarget, shootOrigin)
                        end
                        if not predPos and sTarget.part then
                            predPos = sTarget.part.Position
                        end
                        if predPos then
                            return (predPos - shootOrigin).Unit
                        end
                    end
                end

                if Config.NoSpread and direction then
                    return direction
                end
                return originalMakeSpread(min_s, max_s, origin, direction, ...)
            end
        end

        -- 2. Hook calculateDirection
        if type(shotMod.calculateDirection) == "function" then
            if not originalCalculateDirection then
                originalCalculateDirection = shotMod.calculateDirection
            end
            shotMod.calculateDirection = function(origin, targetPos, ...)
                if Config.SilentAim and type(findCombatTarget) == "function" then
                    local cam = Workspace.CurrentCamera
                    local shootOrigin = (typeof(origin) == "Vector3" and origin) or (cam and cam.CFrame.Position)
                    local sTarget = findCombatTarget({
                        fov = Config.SilentAimFov or 800,
                        maxDistance = Config.AimMaxDistance or 1500,
                        players = true,
                        drones = Config.AimDrones,
                        teamCheck = Config.AimTeamCheck,
                        wallCheck = Config.SilentAimWallCheck,
                        part = Config.SilentAimPart or Config.AimPart or "Head",
                    })
                    if sTarget and shootOrigin then
                        local predPos = nil
                        if Config.PredictionEnabled and type(getPredictedTargetPosition) == "function" then
                            predPos = getPredictedTargetPosition(sTarget, shootOrigin)
                        end
                        if not predPos and sTarget.part then
                            predPos = sTarget.part.Position
                        end
                        if predPos then
                            return (predPos - shootOrigin).Unit
                        end
                    end
                end
                return originalCalculateDirection(origin, targetPos, ...)
            end
        end

        -- 3. Hook raycast (HIT REGISTRATION CORE - แดเมจจริงของกระสุน)
        if type(shotMod.raycast) == "function" then
            if not originalRaycast then
                originalRaycast = shotMod.raycast
            end
            shotMod.raycast = function(origin, direction, params, ...)
                if Config.SilentAim and type(findCombatTarget) == "function" and typeof(origin) == "Vector3" then
                    local sTarget = findCombatTarget({
                        fov = Config.SilentAimFov or 800,
                        maxDistance = Config.AimMaxDistance or 1500,
                        players = true,
                        drones = Config.AimDrones,
                        teamCheck = Config.AimTeamCheck,
                        wallCheck = Config.SilentAimWallCheck,
                        part = Config.SilentAimPart or Config.AimPart or "Head",
                    })
                    if sTarget then
                        local targetPart = sTarget.part
                        local targetPos = nil
                        if Config.PredictionEnabled and type(getPredictedTargetPosition) == "function" then
                            targetPos = getPredictedTargetPosition(sTarget, origin)
                        end
                        if not targetPos and targetPart then
                            targetPos = targetPart.Position
                        end
                        if targetPos then
                            local newDir = targetPos - origin
                            local aimRayDir = newDir.Unit * math.max(newDir.Magnitude + 15, (typeof(direction) == "Vector3" and direction.Magnitude) or 500)
                            return originalRaycast(origin, aimRayDir, params, ...)
                        end
                    end
                end
                return originalRaycast(origin, direction, params, ...)
            end
        end
    end
end

local function getEquippedWeapons()
    local char = LP.Character
    if not char then return {} end
    local list = {}
    for _, obj in ipairs(getgc(true)) do
        if type(obj) == "table" and rawget(obj, "character") == char and rawget(obj, "stats") ~= nil then
            table.insert(list, obj)
        end
    end
    return list
end

local function captureOriginalStats(weapon)
    if not weapon or not weapon.stats or originalWeaponStats[weapon] then return end
    originalWeaponStats[weapon] = {
        recoil_magnitude = weapon.stats.recoil_magnitude,
        recoil_roughness = weapon.stats.recoil_roughness,
        recoil_rotation = weapon.stats.recoil_rotation,
        recoil_recover_low = weapon.stats.recoil_recover_low,
        recoil_recover_high = weapon.stats.recoil_recover_high,
        kickback = weapon.stats.kickback,
        aimkickback = weapon.stats.aimkickback,
        bullet_speed = weapon.stats.bullet_speed,
        bullet_gravity = weapon.stats.bullet_gravity,
        bullet_distance = weapon.stats.bullet_distance,
        min_spread = weapon.stats.min_spread,
        max_spread = weapon.stats.max_spread,
        idle_walkspeed = weapon.stats.idle_walkspeed,
        aim_walkspeed = weapon.stats.aim_walkspeed,
        sprint_walkspeed = weapon.stats.sprint_walkspeed,
        cooldown = weapon.data and weapon.data.cooldown,
        fire_modes = weapon.fire_modes and table.clone(weapon.fire_modes),
        data_fire_modes = weapon.data and weapon.data.fireModes and table.clone(weapon.data.fireModes),
    }
end

local function applyWeaponMods(weapon)
    if not weapon or type(weapon) ~= "table" or not weapon.stats then return end
    captureOriginalStats(weapon)
    local orig = originalWeaponStats[weapon]
    if not orig then return end

    makeWritable(weapon.stats)
    if weapon.data then makeWritable(weapon.data) end
    if weapon.fire_modes then makeWritable(weapon.fire_modes) end

    -- Recoil
    if Config.NoRecoil then
        weapon.stats.recoil_magnitude = 0
        weapon.stats.recoil_roughness = 0
        weapon.stats.recoil_rotation = Vector3.new(0, 0, 0)
        weapon.stats.kickback = 0
        weapon.stats.aimkickback = 0
    else
        weapon.stats.recoil_magnitude = orig.recoil_magnitude
        weapon.stats.recoil_roughness = orig.recoil_roughness
        weapon.stats.recoil_rotation = orig.recoil_rotation
        weapon.stats.kickback = orig.kickback
        weapon.stats.aimkickback = orig.aimkickback
    end

    -- Spread
    if Config.NoSpread then
        if weapon.stats.min_spread ~= nil then weapon.stats.min_spread = 0 end
        if weapon.stats.max_spread ~= nil then weapon.stats.max_spread = 0 end
    else
        if orig.min_spread ~= nil then weapon.stats.min_spread = orig.min_spread end
        if orig.max_spread ~= nil then weapon.stats.max_spread = orig.max_spread end
    end

    -- Rapid Fire / Custom Cooldown
    if Config.RapidFire and weapon.data then
        weapon.data.cooldown = math.min(orig.cooldown or 0.1, Config.FireCooldown)
    elseif orig.cooldown and weapon.data then
        weapon.data.cooldown = orig.cooldown
    end

    -- Always Automatic
    if Config.AlwaysAuto then
        if weapon.fire_modes and not table.find(weapon.fire_modes, "automatic") then
            table.insert(weapon.fire_modes, 1, "automatic")
        end
        if weapon.data and weapon.data.fireModes and not table.find(weapon.data.fireModes, "automatic") then
            table.insert(weapon.data.fireModes, 1, "automatic")
        end
    else
        if orig.fire_modes and weapon.fire_modes then
            weapon.fire_modes = table.clone(orig.fire_modes)
        end
        if orig.data_fire_modes and weapon.data and weapon.data.fireModes then
            weapon.data.fireModes = table.clone(orig.data_fire_modes)
        end
    end

    -- Fast Bullet
    if Config.FastBullet then
        weapon.stats.bullet_speed = Config.BulletSpeedVal
    elseif orig.bullet_speed then
        weapon.stats.bullet_speed = orig.bullet_speed
    end

    -- No Bullet Drop
    if Config.NoBulletDrop then
        weapon.stats.bullet_gravity = Vector3.new(0, 0, 0)
    elseif orig.bullet_gravity then
        weapon.stats.bullet_gravity = orig.bullet_gravity
    end
end

local function applyAllWeaponMods()
    hookSpreadModule()
    for _, w in ipairs(cachedWeapons) do
        applyWeaponMods(w)
    end
end

local function resetAllWeaponStats()
    for weapon, orig in pairs(originalWeaponStats) do
        pcall(function()
            makeWritable(weapon.stats)
            if weapon.data then makeWritable(weapon.data) end
            if weapon.fire_modes then makeWritable(weapon.fire_modes) end

            weapon.stats.recoil_magnitude = orig.recoil_magnitude
            weapon.stats.recoil_roughness = orig.recoil_roughness
            weapon.stats.recoil_rotation = orig.recoil_rotation
            weapon.stats.recoil_recover_low = orig.recoil_recover_low
            weapon.stats.recoil_recover_high = orig.recoil_recover_high
            weapon.stats.kickback = orig.kickback
            weapon.stats.aimkickback = orig.aimkickback
            weapon.stats.bullet_speed = orig.bullet_speed
            weapon.stats.bullet_gravity = orig.bullet_gravity
            weapon.stats.bullet_distance = orig.bullet_distance
            if orig.min_spread ~= nil then weapon.stats.min_spread = orig.min_spread end
            if orig.max_spread ~= nil then weapon.stats.max_spread = orig.max_spread end
            weapon.stats.idle_walkspeed = orig.idle_walkspeed
            weapon.stats.aim_walkspeed = orig.aim_walkspeed
            weapon.stats.sprint_walkspeed = orig.sprint_walkspeed

            if orig.cooldown and weapon.data then
                weapon.data.cooldown = orig.cooldown
            end
            if orig.fire_modes and weapon.fire_modes then
                weapon.fire_modes = table.clone(orig.fire_modes)
            end
            if orig.data_fire_modes and weapon.data and weapon.data.fireModes then
                weapon.data.fireModes = table.clone(orig.data_fire_modes)
            end
        end)
    end
    originalWeaponStats = {}
    if weaponStatusLabel then
        pcall(function() weaponStatusLabel:Set("Weapon Status: All stats reset to factory") end)
    end
end

local function updateWeaponManager()
    local now = os.clock()
    if now - lastWeaponScan > 1.0 or #cachedWeapons == 0 then
        lastWeaponScan = now
        cachedWeapons = getEquippedWeapons()
    end
    hookSpreadModule()
    for _, w in ipairs(cachedWeapons) do
        applyWeaponMods(w)
    end

    if weaponStatusLabel and #cachedWeapons > 0 then
        local names = {}
        for _, w in ipairs(cachedWeapons) do
            local dName = (w.data and w.data.displayName) or w.name or "Weapon"
            table.insert(names, dName)
        end
        local modsActive = {}
        if Config.NoRecoil then table.insert(modsActive, "NoRecoil") end
        if Config.NoSpread then table.insert(modsActive, "NoSpread") end
        if Config.RapidFire then table.insert(modsActive, "RapidFire") end
        if Config.AlwaysAuto then table.insert(modsActive, "Auto") end
        if Config.FastBullet then table.insert(modsActive, "FastBullet") end
        if Config.NoBulletDrop then table.insert(modsActive, "NoDrop") end
        local activeStr = #modsActive > 0 and table.concat(modsActive, " | ") or "Stock"
        pcall(function()
            weaponStatusLabel:Set(string.format("Weapon: %s [%s]", table.concat(names, ", "), activeStr))
        end)
    end
end

WeaponTab:CreateSection("RECOIL & SPREAD")

WeaponTab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = false,
    Flag = "tlf_no_recoil",
    Callback = function(v)
        Config.NoRecoil = v
        applyAllWeaponMods()
    end,
})

WeaponTab:CreateToggle({
    Name = "No Spread (Laser Accuracy)",
    CurrentValue = false,
    Flag = "tlf_no_spread",
    Callback = function(v)
        Config.NoSpread = v
        applyAllWeaponMods()
    end,
})

WeaponTab:CreateSection("FIRE RATE & MODES")

WeaponTab:CreateToggle({
    Name = "Rapid Fire (Custom Cooldown)",
    CurrentValue = false,
    Flag = "tlf_rapid_fire",
    Callback = function(v)
        Config.RapidFire = v
        applyAllWeaponMods()
    end,
})

WeaponTab:CreateSlider({
    Name = "Fire Rate Cooldown",
    Range = { 0.01, 0.20 },
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.05,
    Flag = "tlf_fire_cooldown",
    Callback = function(v)
        Config.FireCooldown = v
        if Config.RapidFire then
            applyAllWeaponMods()
        end
    end,
})

WeaponTab:CreateToggle({
    Name = "Always Automatic Firemode",
    CurrentValue = false,
    Flag = "tlf_always_auto",
    Callback = function(v)
        Config.AlwaysAuto = v
        applyAllWeaponMods()
    end,
})

WeaponTab:CreateSection("BULLET PHYSICS")

WeaponTab:CreateToggle({
    Name = "Fast Bullet Speed",
    CurrentValue = false,
    Flag = "tlf_fast_bullet",
    Callback = function(v)
        Config.FastBullet = v
        applyAllWeaponMods()
    end,
})

WeaponTab:CreateSlider({
    Name = "Bullet Velocity",
    Range = { 1000, 10000 },
    Increment = 500,
    Suffix = " studs/s",
    CurrentValue = 5000,
    Flag = "tlf_bullet_speed",
    Callback = function(v)
        Config.BulletSpeedVal = v
        if Config.FastBullet then
            applyAllWeaponMods()
        end
    end,
})

WeaponTab:CreateToggle({
    Name = "No Bullet Drop (Zero Gravity)",
    CurrentValue = false,
    Flag = "tlf_no_bullet_drop",
    Callback = function(v)
        Config.NoBulletDrop = v
        applyAllWeaponMods()
    end,
})

WeaponTab:CreateSection("AMMO & PICKUP")

WeaponTab:CreateToggle({
    Name = "Auto Pickup Ammo (เดินใกล้เก็บกระสุนเอง)",
    CurrentValue = true,
    Flag = "tlf_auto_pickup_ammo",
    Callback = function(v)
        Config.AutoPickupAmmo = v
    end,
})

WeaponTab:CreateSlider({
    Name = "Pickup Radius",
    Range = { 5, 50 },
    Increment = 5,
    Suffix = " studs",
    CurrentValue = 25,
    Flag = "tlf_pickup_radius",
    Callback = function(v)
        Config.PickupRadius = v
    end,
})

local function RunAutoPickup()
    if not Config.AutoPickupAmmo then return end
    
    local net = ReplicatedStorage:FindFirstChild("network")
    local pickupFolder = net and net:FindFirstChild("pickup")
    local collectRemote = pickupFolder and pickupFolder:FindFirstChild("collect")
    if not collectRemote then return end
    
    local highlight = ReplicatedStorage:FindFirstChild("WeaponHighlight")
    if highlight and highlight.Adornee and highlight.Adornee.Parent then
        pcall(function()
            collectRemote:FireServer(highlight.Adornee)
        end)
    end
    
    local char = LP.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    if not root then return end
    local myPos = root.Position
    local maxDist = Config.PickupRadius or 25
    
    local checkFolders = {
        workspace:FindFirstChild("itemModels"),
        workspace:FindFirstChild("debris"),
        workspace:FindFirstChild("placeables"),
        workspace
    }
    
    for _, folder in ipairs(checkFolders) do
        if folder then
            for _, item in ipairs(folder:GetChildren()) do
                if item:IsA("Model") or item:IsA("BasePart") then
                    local itemPos = nil
                    if item:IsA("BasePart") then
                        itemPos = item.Position
                    elseif item.PrimaryPart then
                        itemPos = item.PrimaryPart.Position
                    else
                        local fPart = item:FindFirstChildWhichIsA("BasePart")
                        if fPart then itemPos = fPart.Position end
                    end
                    
                    if itemPos and (itemPos - myPos).Magnitude <= maxDist then
                        local n = string.lower(item.Name)
                        if n:find("ammo") or n:find("weapon") or n:find("drop") or n:find("crate") or n:find("box") or item:FindFirstChild("pickup") or item:FindFirstChild("Prompt") then
                            pcall(function()
                                collectRemote:FireServer(item)
                            end)
                        end
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        pcall(RunAutoPickup)
        task.wait(0.25)
    end
end)

WeaponTab:CreateSection("MANAGEMENT")

WeaponTab:CreateButton({
    Name = "Reset All Weapon Stats",
    Callback = function()
        resetAllWeaponStats()
        notify("Weapon", "All weapon stats reverted to factory defaults.", 3)
    end,
})

do
    local ok, label = pcall(function()
        return WeaponTab:CreateLabel("Weapon: Scanning...")
    end)
    if ok then weaponStatusLabel = label end
end

task.spawn(function()
    while true do
        pcall(updateWeaponManager)
        task.wait(0.5)
    end
end)

-- ============================================================
-- SETTINGS TAB & SERVER / MODERATOR DETECTOR
-- ============================================================

local detectedStaff = {}
local staffStatusLabel = nil
local serverInfoLabel = nil
local playerInfoLabel = nil

local function isPlayerStaff(p)
    if not p or not p.Parent then return false, nil end
    if p.UserId == game.CreatorId and game.CreatorType == Enum.CreatorType.User then
        return true, "Game Creator"
    end
    if game.CreatorType == Enum.CreatorType.Group and game.CreatorId > 0 then
        local okR, rank = pcall(function() return p:GetRankInGroup(game.CreatorId) end)
        if okR and rank and rank >= 100 then
            local okRole, roleName = pcall(function() return p:GetRoleInGroup(game.CreatorId) end)
            local rName = (okRole and roleName) or ("Rank " .. tostring(rank))
            local lowRole = string.lower(rName)
            if lowRole:find("mod") or lowRole:find("admin") or lowRole:find("dev")
                or lowRole:find("owner") or lowRole:find("staff") or lowRole:find("lead")
                or lowRole:find("manager") or rank >= 200 then
                return true, rName
            end
        end
    end
    local hasAttr = p:GetAttribute("IsAdmin") or p:GetAttribute("Admin") or p:GetAttribute("Moderator")
    if hasAttr then return true, "Admin Attribute" end
    return false, nil
end

local function checkStaffMember(p)
    if p == LP then return end
    local isStaff, role = isPlayerStaff(p)
    if isStaff and not detectedStaff[p] then
        detectedStaff[p] = role or "Staff"
        if Config.ModDetector then
            notify("⚠️ MODERATOR ALERT!", string.format("Staff detected: %s (%s)", p.Name, role), 12)
        end
        if Config.ModAutoLeave then
            notify("SECURITY", "Moderator in server! Leaving...", 3)
            task.wait(1)
            pcall(function()
                game:GetService("TeleportService"):Teleport(game.PlaceId)
            end)
        end
    end
end

local function updateStaffDetector()
    local staffList = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local isStaff, role = isPlayerStaff(p)
            if isStaff then
                table.insert(staffList, string.format("%s (%s)", p.Name, role))
                checkStaffMember(p)
            end
        end
    end
    if staffStatusLabel then
        pcall(function()
            if #staffList > 0 then
                staffStatusLabel:Set(string.format("⚠️ WARNING: %d Staff present! [%s]", #staffList, table.concat(staffList, ", ")))
            else
                staffStatusLabel:Set("Staff Status: 0 Staff in Server (Safe)")
            end
        end)
    end
end

local function updateServerInfo()
    if not serverInfoLabel then return end
    pcall(function()
        local placeId = game.PlaceId
        local jobId = game.JobId ~= "" and (string.sub(game.JobId, 1, 8) .. "...") or "Local / Studio"
        local pCount = #Players:GetPlayers()
        local maxP = Players.MaxPlayers
        local timeStr = "N/A"
        local lighting = game:GetService("Lighting")
        if lighting then
            timeStr = lighting.TimeOfDay or "N/A"
        end
        serverInfoLabel:Set(string.format("Place: %s | Server: %s | Time: %s | Players: %d/%d",
            tostring(placeId), jobId, timeStr, pCount, maxP))
    end)
end

local function updateLocalPlayerInfo()
    if not playerInfoLabel then return end
    pcall(function()
        local dName = LP.DisplayName
        local uName = LP.Name
        local uId = LP.UserId
        local age = LP.AccountAge
        playerInfoLabel:Set(string.format("Player: %s (@%s) | ID: %d | Age: %d days",
            dName, uName, uId, age))
    end)
end

SettingsTab:CreateSection("CREATOR & CREDITS")
SettingsTab:CreateLabel("Creator: valexcryzer")
SettingsTab:CreateLabel("Telegram: @MintraZERX")
SettingsTab:CreateLabel("Suite: The Lost Front v1.0.4")

SettingsTab:CreateButton({
    Name = "Copy Telegram (@MintraZERX)",
    Callback = function()
        if setclipboard then
            setclipboard("@MintraZERX")
            notify("Copied", "Telegram handle copied to clipboard!", 3)
        else
            notify("Credits", "Telegram: @MintraZERX", 4)
        end
    end,
})

SettingsTab:CreateSection("MAP & SERVER INFO")
serverInfoLabel = SettingsTab:CreateLabel("Loading Server Info...")
playerInfoLabel = SettingsTab:CreateLabel("Loading Player Info...")

SettingsTab:CreateButton({
    Name = "Copy Server JobId",
    Callback = function()
        if setclipboard and game.JobId ~= "" then
            setclipboard(game.JobId)
            notify("Server", "JobId copied to clipboard!", 3)
        else
            notify("Server", "JobId: " .. tostring(game.JobId), 4)
        end
    end,
})

SettingsTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        notify("Rejoin", "Rejoining server...", 3)
        task.wait(0.5)
        local TS = game:GetService("TeleportService")
        if game.JobId ~= "" then
            TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        else
            TS:Teleport(game.PlaceId, LP)
        end
    end,
})

SettingsTab:CreateSection("MODERATOR & STAFF DETECTOR")

SettingsTab:CreateToggle({
    Name = "Staff Detector Alerts",
    CurrentValue = true,
    Flag = "tlf_mod_detector",
    Callback = function(v)
        Config.ModDetector = v
    end,
})

SettingsTab:CreateToggle({
    Name = "Auto Leave on Staff Detect",
    CurrentValue = false,
    Flag = "tlf_mod_autoleave",
    Callback = function(v)
        Config.ModAutoLeave = v
    end,
})

staffStatusLabel = SettingsTab:CreateLabel("Staff Status: Checking...")

SettingsTab:CreateButton({
    Name = "Scan Staff Members Now",
    Callback = function()
        updateStaffDetector()
        notify("Staff Scan", "Staff check complete.", 3)
    end,
})

Players.PlayerAdded:Connect(function(p)
    task.wait(1)
    pcall(checkStaffMember, p)
    pcall(updateStaffDetector)
    pcall(updateServerInfo)
end)

task.spawn(function()
    while true do
        pcall(updateStaffDetector)
        pcall(updateServerInfo)
        pcall(updateLocalPlayerInfo)
        task.wait(3)
    end
end)

-- ============================================================
-- DRAWING
-- ============================================================

local R15_BONES = {
    { "Head", "UpperTorso" }, { "UpperTorso", "LowerTorso" },
    { "UpperTorso", "LeftUpperArm" }, { "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" },
    { "UpperTorso", "RightUpperArm" }, { "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" },
    { "LowerTorso", "LeftUpperLeg" }, { "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" },
    { "LowerTorso", "RightUpperLeg" }, { "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" },
}

local R6_BONES = {
    { "Head", "Torso" }, { "Torso", "Left Arm" }, { "Torso", "Right Arm" },
    { "Torso", "Left Leg" }, { "Torso", "Right Leg" },
}

local CAM = Workspace.CurrentCamera

local function project(pos)
    if not CAM then return nil end
    local sp = CAM:WorldToViewportPoint(pos)
    if sp.Z <= 0 then return nil end
    return Vector2.new(sp.X, sp.Y)
end

local function projectBounds(model)
    if not model then return nil end
    local ok, cf, size = pcall(function()
        local c, s = model:GetBoundingBox()
        return c, s
    end)
    if not ok or not cf or not size then return nil end
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    for sx = -1, 1, 2 do
        for sy = -1, 1, 2 do
            for sz = -1, 1, 2 do
                local world = (cf * CFrame.new(sx * size.X / 2, sy * size.Y / 2, sz * size.Z / 2)).Position
                local sp = project(world)
                if not sp then return nil end
                if sp.X < minX then minX = sp.X end
                if sp.Y < minY then minY = sp.Y end
                if sp.X > maxX then maxX = sp.X end
                if sp.Y > maxY then maxY = sp.Y end
            end
        end
    end
    return { minX = minX, minY = minY, maxX = maxX, maxY = maxY }
end

-- ============================================================
-- COMBAT
-- ============================================================

local function refreshCamera()
    CAM = Workspace.CurrentCamera
end

local function inLobby()
    local pg = LP:FindFirstChild("PlayerGui")
    local lobby = pg and pg:FindFirstChild("lobby")
    if lobby and lobby.Enabled then return true end
    local active = ReplicatedStorage:FindFirstChild("active")
    local players = active and active:FindFirstChild("players")
    if players and players:FindFirstChild(LP.Name) then return false end
    return lobby ~= nil and lobby.Enabled == true
end

local function localAlive()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return char ~= nil and hum ~= nil and hum.Health > 0
end

local function pickPart(container, names)
    if not container then return nil end
    for _, name in ipairs(names) do
        local p = container:FindFirstChild(name)
        if p and p:IsA("BasePart") then return p end
    end
    return nil
end

local function characterPart(char, preference, center)
    if not char then return nil end
    if preference == "Head" then
        return pickPart(char, { "Head" })
            or pickPart(char, { "UpperTorso", "Torso", "HumanoidRootPart" })
            or char:FindFirstChildWhichIsA("BasePart")
    elseif preference == "Torso" then
        return pickPart(char, { "UpperTorso", "Torso", "HumanoidRootPart" })
            or pickPart(char, { "Head" })
            or char:FindFirstChildWhichIsA("BasePart")
    end
    local best, bestDist
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
            local sp = project(d.Position)
            if sp and center then
                local dist = (sp - center).Magnitude
                if not bestDist or dist < bestDist then best, bestDist = d, dist end
            end
        end
    end
    return best
        or pickPart(char, { "HumanoidRootPart", "Torso", "UpperTorso" })
        or char:FindFirstChildWhichIsA("BasePart")
end

local function dronePart(model)
    if not model then return nil end
    if model:IsA("BasePart") then return model end
    local named = pickPart(model, {
        "hitbox", "Hitbox", "AimPoint", "HumanoidRootPart", "Core", "Body", "Engine", "Main", "Handle",
    })
    if named then return named end
    local primary = model.PrimaryPart
    if primary and primary:IsA("BasePart") then return primary end
    local best, bestSize
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then
            local size = d.Size.Magnitude
            if not bestSize or size > bestSize then best, bestSize = d, size end
        end
    end
    return best
end

local function isPartVisible(part, char)
    if not part then return false end
    refreshCamera()
    if not CAM then return false end

    local origin = CAM.CFrame.Position
    local targetPos = part.Position
    local dir = targetPos - origin
    local dist = dir.Magnitude
    if dist < 0.5 then return true end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local ignore = { CAM }
    if LP.Character then table.insert(ignore, LP.Character) end
    params.FilterDescendantsInstances = ignore
    params.IgnoreWater = true

    local result = workspace:Raycast(origin, dir, params)
    if not result then return true end
    if char and result.Instance:IsDescendantOf(char) then return true end
    if result.Instance.Transparency > 0.8 or not result.Instance.CanCollide then return true end
    return false
end

findCombatTarget = function(opts)
    refreshCamera()
    if not CAM then return nil end
    local center = Vector2.new(CAM.ViewportSize.X / 2, CAM.ViewportSize.Y / 2)
    local myTeam = shortTeamName(getPlayerData(LP).team)
    local best, bestScore

    local function consider(target)
        local sp = project(target.part.Position)
        if not sp then return end
        local screenDist = (sp - center).Magnitude
        if screenDist > opts.fov then return end
        local score = screenDist + target.distance * 0.02
        if not bestScore or score < bestScore then
            target.screen = sp
            target.screenDist = screenDist
            best, bestScore = target, score
        end
    end

    if opts.players then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local char = p.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and (char:FindFirstChild("HumanoidRootPart")
                    or char:FindFirstChild("Torso")
                    or char:FindFirstChild("UpperTorso"))
                if char and hum and root and hum.Health > 0 then
                    local dist = (CAM.CFrame.Position - root.Position).Magnitude
                    if dist <= opts.maxDistance then
                        local isEnemy = isEnemyPlayer(p)
                        local side = isEnemy and "enemy" or "friendly"
                        local allowed = (not opts.teamCheck) or isEnemy
                        if allowed then
                            local part = characterPart(char, opts.part, center)
                            if part then
                                if not opts.wallCheck or isPartVisible(part, char) then
                                    consider({
                                        kind = "player",
                                        player = p,
                                        character = char,
                                        humanoid = hum,
                                        part = part,
                                        distance = dist,
                                        side = side,
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if opts.drones then
        for model, info in pairs(droneData) do
            if model.Parent then
                local side = info.side or "unknown"
                if (not opts.teamCheck) or side == "enemy" then
                    local part = dronePart(model)
                    if part then
                        local dist = (CAM.CFrame.Position - part.Position).Magnitude
                        if dist <= opts.maxDistance then
                            if not opts.wallCheck or isPartVisible(part, model) then
                                consider({
                                    kind = "drone",
                                    model = model,
                                    part = part,
                                    distance = dist,
                                    side = side,
                                    owner = info.owner,
                                })
                            end
                        end
                    end
                end
            end
        end
    end

    return best
end

local function shouldAim()
    if not Config.AimEnabled then return false end
    if Config.AimAlways or Config.AimKey == "Always" then return true end
    return aimHeld or rmbHeld or mobileAimActive
end

local currentAimTarget = nil

getTargetPosition = function(target)
    if not target or not target.part or not target.part.Parent then return nil end
    if target.kind == "player" and target.character then
        local hrp = target.character:FindFirstChild("HumanoidRootPart")
        if hrp and target.part.Name == "Head" then
            -- Stabilize head position relative to HRP physics to eliminate animation/running head-bobbing
            return hrp.Position + Vector3.new(0, 1.45, 0)
        end
        if hrp and (target.part.Name:find("Torso") or target.part.Name == "HumanoidRootPart") then
            return hrp.Position + Vector3.new(0, 0.2, 0)
        end
    end
    return target.part.Position
end

getPredictedTargetPosition = function(target, origin, customSpeed)
    local rawPos = getTargetPosition(target)
    if not rawPos then return nil end
    
    if not Config.PredictionEnabled or not origin then
        return rawPos
    end
    
    local velocity = Vector3.zero
    if target.kind == "player" and target.character then
        local hrp = target.character:FindFirstChild("HumanoidRootPart")
        if hrp then
            velocity = hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.zero
        end
    elseif target.kind == "drone" and target.model then
        local pPart = target.model.PrimaryPart or target.part
        if pPart then
            velocity = pPart.AssemblyLinearVelocity or pPart.Velocity or Vector3.zero
        end
    end
    
    local dist = (rawPos - origin).Magnitude
    local bSpeed = customSpeed or Config.BulletSpeedVal or 2500
    if bSpeed <= 50 then bSpeed = 2500 end
    local timeToHit = dist / bSpeed
    
    -- Lead the moving target
    local predictedPos = rawPos + (velocity * timeToHit)
    
    -- Compensate bullet gravity drop if zero gravity is not active
    if not Config.NoBulletDrop and timeToHit > 0 then
        predictedPos = predictedPos + Vector3.new(0, 0.5 * 196.2 * (timeToHit ^ 2), 0)
    end
    
    return predictedPos
end

local function isTargetValid(target)
    if not target or not target.part or not target.part.Parent then return false end
    if target.kind == "player" then
        if not target.player or not target.player.Parent then return false end
        if not target.humanoid or target.humanoid.Health <= 0 then return false end
        if Config.AimTeamCheck and not isEnemyPlayer(target.player) then return false end
    elseif target.kind == "drone" then
        if not target.model or not target.model.Parent then return false end
        if Config.AimTeamCheck and target.side ~= "enemy" then return false end
    end
    if Config.AimWallCheck and not isPartVisible(target.part, target.character or target.model) then
        return false
    end
    local cam = Workspace.CurrentCamera
    if not cam then return false end
    local tp = getTargetPosition(target)
    if not tp then return false end
    local dist = (cam.CFrame.Position - tp).Magnitude
    if dist > Config.AimMaxDistance then return false end
    local sp, onScreen = cam:WorldToViewportPoint(tp)
    if not onScreen then return false end
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local screenDist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
    if screenDist > Config.AimFov * 1.6 then return false end
    return true
end

local function updateAim(dt)
    if not shouldAim() then
        currentAimTarget = nil
        lastAimTarget = nil
        return
    end
    if inLobby() or not localAlive() then
        currentAimTarget = nil
        lastAimTarget = nil
        return
    end
    if UserInputService:GetFocusedTextBox() then return end

    -- Target persistence / stickiness to avoid target-switching jitter
    local target = currentAimTarget
    if not isTargetValid(target) then
        target = findCombatTarget({
            fov = Config.AimFov,
            maxDistance = Config.AimMaxDistance,
            players = true,
            drones = Config.AimDrones,
            teamCheck = Config.AimTeamCheck,
            wallCheck = Config.AimWallCheck,
            part = Config.AimPart,
        })
        currentAimTarget = target
    end
    lastAimTarget = target
    if not target then return end

    local cam = Workspace.CurrentCamera
    if not cam then return end

    local targetPos = getPredictedTargetPosition(target, cam.CFrame.Position)
    if not targetPos then return end

    local useMouse = (not isMobile) and (Config.AimMethod == "Mouse" or Config.AimMethod == "Mouse (Smooth)") and type(mousemoverel) == "function"

    if useMouse then
        -- MOUSE METHOD: zero fighting with Roblox CameraModule, silky-smooth
        local sp, onScreen = cam:WorldToViewportPoint(targetPos)
        if onScreen then
            local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            local diffX = sp.X - center.X
            local diffY = sp.Y - center.Y

            -- Deadzone: if already centered within 1.5 pixels, do not apply movement to eliminate jitter
            if math.abs(diffX) > 1.5 or math.abs(diffY) > 1.5 then
                local smoothness = math.clamp(Config.AimSmoothness, 0, 100)
                local divisor = 1.0 + (smoothness / 100) * 18.0
                local timeScale = math.clamp(dt * 60, 0.5, 2.0)
                local moveX = (diffX / divisor) * timeScale
                local moveY = (diffY / divisor) * timeScale

                moveX = math.clamp(moveX, -120, 120)
                moveY = math.clamp(moveY, -120, 120)

                mousemoverel(moveX, moveY)
            end
        end
    else
        -- CAMERA METHOD: rotation-only CFrame lerp with angular deadzone
        local camPos = cam.CFrame.Position
        local delta = targetPos - camPos
        if delta.Magnitude < 0.1 then return end

        local desired = CFrame.lookAt(camPos, targetPos)
        local smoothness = math.clamp(Config.AimSmoothness, 0, 100)
        local angleDiff = math.acos(math.clamp(cam.CFrame.LookVector:Dot(desired.LookVector), -1, 1))

        -- Angular deadzone to avoid 60fps micro-shake when crosshair is already on target
        if angleDiff > 0.002 then
            local base = math.clamp(1 - smoothness / 100, 0.03, 1)
            local alpha = 1 - (1 - base) ^ (math.max(dt, 0.001) * 60)
            cam.CFrame = CFrame.new(camPos) * (cam.CFrame.Rotation:Lerp(desired.Rotation, alpha))
        end
    end
end

local function mouseOverMenu()
    local main = GetRayfieldMain()
    if not main or not main.Visible then return false end
    local mp = UserInputService:GetMouseLocation()
    local ap = main.AbsolutePosition
    local sz = main.AbsoluteSize
    return mp.X >= ap.X and mp.X <= ap.X + sz.X and mp.Y >= ap.Y and mp.Y <= ap.Y + sz.Y
end

local function fireWeapon()
    if UserInputService:GetFocusedTextBox() then return false end
    if mouseOverMenu() then return false end

    local clicked = false
    if type(mouse1click) == "function" then
        clicked = pcall(mouse1click)
    end
    if clicked then return true end

    return pcall(function()
        local vim = game:GetService("VirtualInputManager")
        local vp = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize)
            or Vector2.new(1280, 720)
        vim:SendMouseButtonEvent(vp.X / 2, vp.Y / 2, 0, true, game, 0)
        task.delay(0.03, function()
            pcall(function()
                vim:SendMouseButtonEvent(vp.X / 2, vp.Y / 2, 0, false, game, 0)
            end)
        end)
    end)
end

local lastTrigger = 0
local function updateTrigger()
    if not Config.TriggerBot then return end
    if inLobby() or not localAlive() then return end

    local now = os.clock()
    local delay = math.max(0, Config.TriggerDelay) / 1000
    if now - lastTrigger < delay then return end

    local target = lastAimTarget
    if not target then
        target = findCombatTarget({
            fov = 60,
            maxDistance = Config.TriggerDistance,
            players = true,
            drones = Config.AimDrones,
            teamCheck = Config.AimTeamCheck,
            part = Config.AimPart,
        })
    end
    if not target or target.distance > Config.TriggerDistance then return end
    if not target.screenDist or target.screenDist > 60 then return end

    lastTrigger = now
    fireWeapon()
end

local function ensureAimVisuals()
    if not DrawingLib then return end
    if not aimFovCircle then
        pcall(function()
            local d = DrawingLib.new("Circle")
            d.Thickness = 1
            d.NumSides = 64
            d.Filled = false
            d.Visible = false
            d.ZIndex = 998
            d.Color = Color3.fromRGB(80, 255, 120)
            aimFovCircle = d
        end)
    end
end

local function updateAimVisuals()
    if not DrawingLib then return end
    ensureAimVisuals()
    refreshCamera()

    if aimFovCircle then
        local aimOn = Config.AimEnabled and Config.AimShowFov
        aimFovCircle.Visible = aimOn
        if aimOn and CAM then
            local held = Config.AimAlways or Config.AimKey == "Always" or (Config.AimRightMouse and aimHeld) or mobileAimActive
            aimFovCircle.Color = held and Color3.fromRGB(80, 255, 120) or Color3.fromRGB(90, 160, 90)
            aimFovCircle.Position = Vector2.new(CAM.ViewportSize.X / 2, CAM.ViewportSize.Y / 2)
            aimFovCircle.Radius = Config.AimFov
        end
    end
end

local function destroyAimVisuals()
    if aimFovCircle then
        pcall(function() aimFovCircle:Remove() end)
        aimFovCircle = nil
    end
end

local lastCombatStatus = 0
local function updateCombatStatus()
    if not combatStatusPara then return end
    local now = os.clock()
    if now - lastCombatStatus < 0.5 then return end
    lastCombatStatus = now

    local targetText = "none"
    local t = lastAimTarget
    if t then
        if t.kind == "drone" then
            targetText = "drone " .. (t.owner and t.owner.Name or "?") .. " " .. math.floor(t.distance) .. "m"
        else
            targetText = (t.player and t.player.Name or "?") .. " " .. math.floor(t.distance) .. "m"
        end
    end

    local text = "Aim: " .. (Config.AimEnabled and "ON" or "OFF")
        .. " | WallCheck: " .. (Config.AimWallCheck and "ON" or "OFF")
        .. " | Method: " .. tostring(Config.AimMethod or "Mouse")
        .. " | Trigger: " .. (Config.TriggerBot and "ON" or "OFF")
        .. " | Target: " .. targetText

    local ok = pcall(function()
        combatStatusPara:Set({ Title = "Combat Status", Content = text })
    end)
    if not ok then
        pcall(function() combatStatusPara:Set(text) end)
    end
end

local function combatStep(dt)
    pcall(function()
        if Config.AimRightMouse then
            rmbHeld = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        else
            rmbHeld = false
        end
        updateAim(dt)
        updateTrigger()
        updateCombatStatus()
        updateAimVisuals()
    end)
end

if not combatBound then
    RunService:BindToRenderStep("TLF_Combat", Enum.RenderPriority.Camera.Value + 1, combatStep)
    combatBound = true
end

aimBeganConn = UserInputService.InputBegan:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if Config.AimRightMouse then
            aimHeld = true
        end
        return
    end
    if processed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard
        and input.KeyCode.Name == Config.AimKey then
        aimHeld = true
    end
end)

aimEndedConn = UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimHeld = false
        return
    end
    if input.UserInputType == Enum.UserInputType.Keyboard
        and input.KeyCode.Name == Config.AimKey then
        aimHeld = false
    end
end)

local function newText(size)
    local t = DrawingLib.new("Text")
    t.Text = ""
    t.Size = size
    t.Center = false
    t.Outline = true
    t.OutlineColor = Color3.new(0, 0, 0)
    t.Font = 2
    t.Color = Color3.new(1, 1, 1)
    t.Transparency = 1
    t.Visible = false
    return t
end

local makeLabel
local hideLabels
local destroyLabels

-- NOTE: In this executor, Drawing.Transparency behaves as opacity:
-- 1 = fully solid, 0 = invisible. Keep drawing elements at 1 for strong colors.
local function createPool()
    local pool = { bones = {}, _shown = false }
    pool.lblName = makeLabel(12, Enum.Font.GothamBold)
    pool.lblInfo = makeLabel(11, Enum.Font.GothamSemibold)
    pool.boxShadow = DrawingLib.new("Square")
    pool.boxShadow.Filled = false
    pool.boxShadow.Thickness = 3
    pool.boxShadow.Visible = false
    pool.box = DrawingLib.new("Square")
    pool.box.Filled = false
    pool.box.Thickness = 2
    pool.box.Visible = false
    pool.tracer = DrawingLib.new("Line")
    pool.tracer.Thickness = 2
    pool.tracer.Visible = false
    for i = 1, #R15_BONES do
        local line = DrawingLib.new("Line")
        line.Thickness = 3
        line.Visible = false
        pool.bones[i] = line
    end
    return pool
end

local function removeGlow(pool)
    if not pool then return end
    if pool.glow then
        pcall(function() pool.glow:Destroy() end)
        pool.glow = nil
    end
end

local function ensureGlow(pool, char, color)
    if not char then return end
    if pool.glow and pool.glow.Parent ~= char then
        removeGlow(pool)
    end
    if not pool.glow then
        local ok, hl = pcall(function()
            local h = Instance.new("Highlight")
            h.Name = "TLF_ESP_Glow"
            h.Adornee = char
            pcall(function() h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end)
            h.Parent = char
            return h
        end)
        pool.glow = (ok and hl) or nil
    end
    if pool.glow then
        pool.glow.FillColor = color
        pool.glow.OutlineColor = color
        pool.glow.FillTransparency = 0.7
        pool.glow.OutlineTransparency = 0
    end
end

local function hidePool(pool)
    if not pool or not pool._shown then return end
    pool._shown = false
    pool.boxShadow.Visible = false
    pool.box.Visible = false
    pool.tracer.Visible = false
    for i = 1, #pool.bones do pool.bones[i].Visible = false end
    removeGlow(pool)
    hideLabels(pool)
end

local function destroyPool(pool)
    if not pool then return end
    pcall(function() pool.boxShadow:Remove() end)
    pcall(function() pool.box:Remove() end)
    pcall(function() pool.tracer:Remove() end)
    for i = 1, #pool.bones do pcall(function() pool.bones[i]:Remove() end) end
    removeGlow(pool)
    destroyLabels(pool)
end

local function drawBones(pool, char, color)
    ensureGlow(pool, char, color)
    local set = char:FindFirstChild("UpperTorso") and R15_BONES or R6_BONES
    local idx = 1
    for _, pair in ipairs(set) do
        local a = char:FindFirstChild(pair[1])
        local b = char:FindFirstChild(pair[2])
        if a and b and a:IsA("BasePart") and b:IsA("BasePart") then
            local pa = project(a.Position)
            local pb = project(b.Position)
            local line = pool.bones[idx]
            if pa and pb and line then
                line.From = pa
                line.To = pb
                line.Color = color
                line.Transparency = 1
                line.Visible = true
                idx = idx + 1
            end
        end
    end
    for i = idx, #pool.bones do
        pool.bones[i].Visible = false
    end
end

local LabelGui = nil

local function ensureLabelGui()
    if LabelGui and LabelGui.Parent then return LabelGui end
    local hui = (gethui and gethui()) or game:GetService("CoreGui")
    LabelGui = Instance.new("ScreenGui")
    LabelGui.Name = "TLF_ESP_Labels"
    LabelGui.IgnoreGuiInset = false
    LabelGui.DisplayOrder = 999
    LabelGui.ResetOnSpawn = false
    LabelGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LabelGui.Parent = hui
    return LabelGui
end

makeLabel = function(size, font, color)
    local gui = ensureLabelGui()
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.BorderSizePixel = 0
    l.Size = UDim2.fromOffset(320, 16)
    l.Font = font
    l.TextSize = size
    l.TextColor3 = color or Color3.new(1, 1, 1)
    l.TextStrokeColor3 = Color3.new(0, 0, 0)
    l.TextStrokeTransparency = 0.15
    l.TextXAlignment = Enum.TextXAlignment.Center
    l.TextYAlignment = Enum.TextYAlignment.Top
    l.RichText = false
    l.Visible = false
    l.ZIndex = 10
    l.Parent = gui
    return l
end

hideLabels = function(pool)
    if pool.lblName then pool.lblName.Visible = false end
    if pool.lblInfo then pool.lblInfo.Visible = false end
end

destroyLabels = function(pool)
    if pool.lblName then pcall(function() pool.lblName:Destroy() end) end
    if pool.lblInfo then pcall(function() pool.lblInfo:Destroy() end) end
end

local function updateInfoLabels(pool, p, minX, minY, maxX, maxY, hum, dist, data)
    local screenX = CAM.ViewportSize.X
    local screenY = CAM.ViewportSize.Y
    if maxX < 0 or minX > screenX or maxY < 0 or minY > screenY then
        hideLabels(pool)
        return
    end

    local entries = {}

    local nameText = p.Name
    if Config.Team then
        nameText = nameText .. "  [" .. shortTeamName(data.team) .. "]"
    end
    entries[#entries + 1] = {
        label = pool.lblName,
        text = nameText,
        color = Config.Team and teamColorOf(data.team) or Color3.new(1, 1, 1),
    }

    local parts = {}
    if Config.Health then
        parts[#parts + 1] = "HP " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
    end
    if Config.Weapon then parts[#parts + 1] = prettyWeapon(data.weapon) end
    if Config.Ammo then parts[#parts + 1] = data.ammo and tostring(data.ammo) or "--" end
    if Config.Distance then parts[#parts + 1] = math.floor(dist) .. "m" end
    if #parts > 0 then
        entries[#entries + 1] = {
            label = pool.lblInfo,
            text = table.concat(parts, "  |  "),
            color = Color3.fromRGB(245, 245, 245),
        }
    end

    local lineH = 13
    local labelW = 320
    local startY = math.max(2, minY - (#entries * lineH + 3))
    local labelX = math.clamp((minX + maxX) / 2 - labelW / 2, 2, math.max(2, screenX - labelW - 2))
    for i, entry in ipairs(entries) do
        local lbl = entry.label
        lbl.Text = entry.text
        lbl.TextColor3 = entry.color
        lbl.Position = UDim2.fromOffset(labelX, startY + (i - 1) * lineH)
        lbl.Visible = true
    end

    if #parts == 0 then pool.lblInfo.Visible = false end
end

local pools = {}

local function drawPlayer(pool, p, char, hum, root, dist, data)
    pool._shown = true
    local col = teamColorOf(data.team)
    local short = shortTeamName(data.team)

    local bounds = projectBounds(char)
    local rootScreen = project(root.Position)
    local minX, minY, maxX, maxY

    if bounds then
        minX, minY, maxX, maxY = bounds.minX, bounds.minY, bounds.maxX, bounds.maxY
    elseif rootScreen then
        local w, h = 52, 104
        minX = rootScreen.X - w / 2
        maxX = rootScreen.X + w / 2
        minY = rootScreen.Y - h / 2
        maxY = rootScreen.Y + h / 2
    else
        hidePool(pool)
        return
    end

    if Config.Box then
        pool.boxShadow.Position = Vector2.new(minX - 1, minY - 1)
        pool.boxShadow.Size = Vector2.new(maxX - minX + 2, maxY - minY + 2)
        pool.boxShadow.Color = Color3.new(0, 0, 0)
        pool.boxShadow.Transparency = 0.85
        pool.boxShadow.Visible = true

        pool.box.Position = Vector2.new(minX, minY)
        pool.box.Size = Vector2.new(maxX - minX, maxY - minY)
        pool.box.Color = col
        pool.box.Transparency = 1
        pool.box.Visible = true
    else
        pool.boxShadow.Visible = false
        pool.box.Visible = false
    end

    if Config.Lines and rootScreen then
        pool.tracer.From = Vector2.new(CAM.ViewportSize.X / 2, CAM.ViewportSize.Y)
        pool.tracer.To = Vector2.new((minX + maxX) / 2, minY)
        pool.tracer.Color = col
        pool.tracer.Transparency = 0.85
        pool.tracer.Visible = true
    else
        pool.tracer.Visible = false
    end

    if Config.Bones then
        drawBones(pool, char, col)
    else
        for i = 1, #pool.bones do pool.bones[i].Visible = false end
        removeGlow(pool)
    end

    updateInfoLabels(pool, p, minX, minY, maxX, maxY, hum, dist, data)
end

local function createDronePool()
    local pool = { _shown = false }
    pool.lbl = makeLabel(11, Enum.Font.GothamBold)
    pool.boxShadow = DrawingLib.new("Square")
    pool.boxShadow.Filled = false
    pool.boxShadow.Thickness = 3
    pool.boxShadow.Visible = false
    pool.box = DrawingLib.new("Square")
    pool.box.Filled = false
    pool.box.Thickness = 2
    pool.box.Visible = false
    return pool
end

local droneSideColors = {
    enemy = Color3.fromRGB(255, 40, 40),
    friendly = Color3.fromRGB(50, 235, 95),
    unknown = Color3.fromRGB(255, 220, 40),
}

local function hideDronePool(pool)
    if not pool or not pool._shown then return end
    pool._shown = false
    pool.boxShadow.Visible = false
    pool.box.Visible = false
    if pool.lbl then pool.lbl.Visible = false end
end

local function destroyDronePool(pool)
    if not pool then return end
    pcall(function() pool.boxShadow:Remove() end)
    pcall(function() pool.box:Remove() end)
    if pool.lbl then pcall(function() pool.lbl:Destroy() end) end
end

local function updateDroneDraw()
    local active = {}
    if Config.DroneEsp then
        for model, info in pairs(droneData) do
            if model.Parent then
                local side = info.side or "unknown"
                if not (Config.DroneEnemyOnly and side ~= "enemy") then
                    local bounds = projectBounds(model)
                    local root = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                    if bounds and root then
                        local pool = dronePools[model]
                        if not pool then
                            pool = createDronePool()
                            dronePools[model] = pool
                        end
                        pool._shown = true
                        local col = droneSideColors[side] or droneSideColors.unknown
                        pool.boxShadow.Position = Vector2.new(bounds.minX - 1, bounds.minY - 1)
                        pool.boxShadow.Size = Vector2.new(bounds.maxX - bounds.minX + 2, bounds.maxY - bounds.minY + 2)
                        pool.boxShadow.Color = Color3.new(0, 0, 0)
                        pool.boxShadow.Transparency = 0.85
                        pool.boxShadow.Visible = true

                        pool.box.Position = Vector2.new(bounds.minX, bounds.minY)
                        pool.box.Size = Vector2.new(bounds.maxX - bounds.minX, bounds.maxY - bounds.minY)
                        pool.box.Color = col
                        pool.box.Transparency = 1
                        pool.box.Visible = true

                        local dist = (CAM.CFrame.Position - root.Position).Magnitude
                        local label = (side == "enemy" and "ENEMY DRONE") or (side == "friendly" and "FRIENDLY DRONE") or "DRONE"
                        local ownerName = info.owner and info.owner.Name or "?"
                        local olbl = pool.lbl
                        if olbl then
                            olbl.Text = label .. "  |  " .. ownerName .. "  |  " .. math.floor(dist) .. "m"
                            olbl.TextColor3 = col
                            local screenX = CAM.ViewportSize.X
                            local labelW = 320
                            local labelX = math.clamp((bounds.minX + bounds.maxX) / 2 - labelW / 2, 2, math.max(2, screenX - labelW - 2))
                            olbl.Position = UDim2.fromOffset(labelX, math.max(2, bounds.minY - 15))
                            olbl.Visible = true
                        end
                        active[model] = true
                    end
                end
            end
        end
    end

    for model, pool in pairs(dronePools) do
        if not active[model] then hideDronePool(pool) end
    end
end

local function updatePlayers()
    CAM = Workspace.CurrentCamera
    if not CAM then return end

    local now = os.clock()
    if now - lastGuiTeamRefresh > 2 then
        lastGuiTeamRefresh = now
        refreshGuiTeamMap()
    end

    local drawn = {}
    local tracked, enemies = 0, 0
    local myData = getPlayerData(LP)
    local myShort = myData.team and shortTeamName(myData.team) or "?"

    if Config.Players then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local char = p.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
                if char and hum and root and hum.Health > 0 then
                    local dist = (CAM.CFrame.Position - root.Position).Magnitude
                    if dist <= Config.MaxDistance then
                        local data = getPlayerData(p)
                        local itsShort = data.team and shortTeamName(data.team) or "?"
                        local isTeammate = myShort ~= "?" and itsShort ~= "?" and myShort == itsShort
                        if not (Config.TeamCheck and isTeammate) then
                            local pool = pools[p]
                            if not pool then
                                pool = createPool()
                                pools[p] = pool
                            end
                            drawPlayer(pool, p, char, hum, root, dist, data)
                            drawn[p] = true
                            tracked = tracked + 1
                            if myShort ~= "?" and itsShort ~= "?" and myShort ~= itsShort then
                                enemies = enemies + 1
                            end
                        end
                    end
                end
            end
        end
    end

    for p, pool in pairs(pools) do
        if not drawn[p] then hidePool(pool) end
    end

    if playerStatus then
        pcall(function()
            playerStatus:Set("Tracked: " .. tracked .. " | Enemies: " .. enemies)
        end)
    end
end

-- ============================================================
-- SCAN LOOP
-- ============================================================

local renderConn

task.spawn(function()
    refreshGuiTeamMap()
    while true do
        task.wait(1)
        pcall(function()
            local found = scanDronesNow()
            if Config.DroneAlerts then
                for _, model in ipairs(found) do
                    local info = droneData[model]
                    if info and info.side == "enemy" and not alertedDrones[model] then
                        alertedDrones[model] = true
                        notify("Enemy Drone Detected", (info.owner and info.owner.Name or "Unknown") .. " is using an enemy drone", 5)
                    end
                end
                for name, info in pairs(dronePilots) do
                    if info.side == "enemy" and not alertedPilots[name] then
                        alertedPilots[name] = true
                        notify("Enemy Drone Pilot", name .. " has an FPV drone", 5)
                    end
                end
            end
            local present = {}
            for _, m in ipairs(found) do present[m] = true end
            for m in pairs(alertedDrones) do
                if not present[m] then alertedDrones[m] = nil end
            end
            for name in pairs(alertedPilots) do
                if not dronePilots[name] then alertedPilots[name] = nil end
            end
            for m, pool in pairs(dronePools) do
                if not present[m] then
                    destroyDronePool(pool)
                    dronePools[m] = nil
                end
            end
            updateDroneStatus()
        end)
    end
end)

renderConn = RunService.RenderStepped:Connect(function()
    pcall(updatePlayers)
    pcall(updateDroneDraw)
end)

-- ============================================================
-- LIFECYCLE / EXPORTS
-- ============================================================

Players.PlayerRemoving:Connect(function(p)
    local pool = pools[p]
    if pool then
        destroyPool(pool)
        pools[p] = nil
    end
    dataCache[p] = nil
end)

local function CleanupAll()
    if renderConn then
        renderConn:Disconnect()
        renderConn = nil
    end
    pcall(resetAllWeaponStats)
    if originalMakeSpread then
        pcall(function()
            local sm = ReplicatedStorage:FindFirstChild("lIIIlllIIlIllIlllllIIllllIlllIlIlIIlIllIllllIIlIllIlllllIllI")
            if sm then
                local okM, m = pcall(require, sm)
                if okM and type(m) == "table" then
                    m.makeSpread = originalMakeSpread
                end
            end
        end)
    end
    if combatBound then
        pcall(function() RunService:UnbindFromRenderStep("TLF_Combat") end)
        combatBound = false
    end
    if aimBeganConn then
        aimBeganConn:Disconnect()
        aimBeganConn = nil
    end
    if aimEndedConn then
        aimEndedConn:Disconnect()
        aimEndedConn = nil
    end
    if aimKeyChangedConn then
        aimKeyChangedConn:Disconnect()
        aimKeyChangedConn = nil
    end
    destroyAimVisuals()
    if mobileGui then
        pcall(function() mobileGui:Destroy() end)
        mobileGui = nil
        mobileAimBtn = nil
    end
    lastAimTarget = nil
    currentAimTarget = nil
    aimKeybindSettings = nil
    for p, pool in pairs(pools) do
        destroyPool(pool)
    end
    for m, pool in pairs(dronePools) do
        destroyDronePool(pool)
    end
    pools = {}
    dronePools = {}
    droneData = {}
end

if type(GENV.__TLF_ESP_STOP) == "function" then
    pcall(GENV.__TLF_ESP_STOP)
end

GENV.__TLF_ESP_STOP = CleanupAll
GENV.__TLF_ESP = {
    Version = "1.0.4",
    Config = Config,
    ResetWeaponStats = resetAllWeaponStats,
    ApplyWeaponMods = applyAllWeaponMods,
    GetEquippedWeapons = getEquippedWeapons,
    IsPlayerStaff = isPlayerStaff,
    GetDetectedStaff = function() return detectedStaff end,
    IsEnemyDrone = function(instance)
        local side = droneSide(instance)
        return side == "enemy"
    end,
    GetDroneSide = function(instance)
        local side, owner = droneSide(instance)
        return side, owner and owner.Name or nil
    end,
    ScanDrones = function()
        return scanDronesNow()
    end,
    GetTeam = function(player)
        return resolveTeam(player or LP)
    end,
    IsEnemy = function(player)
        return isEnemyPlayer(player)
    end,
    IsTeammate = function(player)
        return isTeammatePlayer(player)
    end,
    GetPlayerInfo = function(player)
        local p = player
        if type(p) == "string" then p = Players:FindFirstChild(p) end
        if not p then return nil end
        local data = getPlayerData(p)
        local char = p.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
        local dist = nil
        if root and CAM then
            dist = math.floor((CAM.CFrame.Position - root.Position).Magnitude)
        end
        return {
            team = shortTeamName(data.team),
            teamRaw = tostring(data.team),
            weapon = prettyWeapon(data.weapon),
            ammo = data.ammo or "--",
            health = hum and math.floor(hum.Health) or nil,
            maxHealth = hum and math.floor(hum.MaxHealth) or nil,
            distance = dist,
        }
    end,
    GetDronePilots = function()
        return dronePilots
    end,
    Combat = {
        GetTarget = function() return lastAimTarget or currentAimTarget end,
        IsAimActive = function() return shouldAim() end,
        IsPartVisible = function(part, char) return isPartVisible(part, char) end,
    },
    Debug = function()
        local pn, ps = 0, 0
        local boneVisible, boneTotal = 0, 0
        local sampleTrans, sampleColor, sampleFrom, sampleTo = "?", "?", "?", "?"
        for _, pool in pairs(pools) do
            pn = pn + 1
            if pool._shown then ps = ps + 1 end
            for _, line in ipairs(pool.bones) do
                boneTotal = boneTotal + 1
                if line.Visible then
                    boneVisible = boneVisible + 1
                    if sampleTrans == "?" then
                        sampleTrans = tostring(line.Transparency)
                        sampleColor = tostring(line.Color)
                        sampleFrom = tostring(line.From)
                        sampleTo = tostring(line.To)
                    end
                end
            end
        end
        local dc = 0
        for _ in pairs(droneData) do dc = dc + 1 end
        local dn, ds = 0, 0
        for _, pool in pairs(dronePools) do
            dn = dn + 1
            if pool._shown then ds = ds + 1 end
        end
        return {
            playerPools = pn, playerShown = ps,
            droneData = dc, dronePools = dn, droneShown = ds,
            boneVisible = boneVisible, boneTotal = boneTotal,
            sampleTrans = sampleTrans, sampleColor = sampleColor,
            sampleFrom = sampleFrom, sampleTo = sampleTo,
            weaponsCached = #cachedWeapons,
            combatBound = combatBound,
        }
    end,
}

pcall(createMobileAimButton)

notify("The Lost Front ESP", "Loaded. Press RightShift to toggle the menu.", 5)
