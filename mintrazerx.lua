--[[
    ==============================================================================
    MINTRAZERX MULTI-GAME LOADER (RAYFIELD EDITION)
    Website & Authentication: https://mintrazerx-keysystem-wf4n.onrender.com/
    Supported Games:
      - The Lost Front (Place ID: 72299838142412)
      - Formula Apex (Place ID: 5976159288)
      - SCP: Roleplay (Place ID: 5041144419)
      - ZO Samurai (Place ID: 6678877691)
    
    Rules:
      - Clean English interface (No emojis)
      - Rayfield UI with built-in Key System verification
      - Games hub with live name and thumbnail fetching
      - Cloud script delivery directly into memory (Anti-dump)
    ==============================================================================
]]

local SERVER_URL = "https://mintrazerx-keysystem-wf4n.onrender.com"
local REDEEM_URL = SERVER_URL .. "/redeem"
local SAVE_KEY_FILE = "mintrazerx_key"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ==============================================================================
-- 1. HTTP REQUEST & HWID HELPER
-- ==============================================================================
local function HttpRequest(opts)
    if type(request) == "function" then
        return request(opts)
    elseif type(http_request) == "function" then
        return http_request(opts)
    elseif syn and syn.request then
        return syn.request(opts)
    elseif type(fluxus) == "table" and type(fluxus.request) == "function" then
        return fluxus.request(opts)
    end
    if opts.Method == "GET" or not opts.Method then
        local ok, body = pcall(function() return game:HttpGet(opts.Url) end)
        if ok then
            return { StatusCode = 200, Body = body }
        end
    end
    return { StatusCode = 500, Body = "No HTTP method available" }
end

local function GetHWID()
    local hwid = ""
    if type(gethwid) == "function" then
        local ok, res = pcall(gethwid)
        if ok and type(res) == "string" and #res > 5 then return res end
    end
    if type(rbx_gethwid) == "function" then
        local ok, res = pcall(rbx_gethwid)
        if ok and type(res) == "string" and #res > 5 then return res end
    end
    local ok, rbxId = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if ok and type(rbxId) == "string" and #rbxId > 5 then
        return rbxId
    end
    return tostring(LocalPlayer.UserId)
end

local CURRENT_HWID = GetHWID()

-- ==============================================================================
-- 2. ONLINE KEY VERIFICATION HELPER
-- ==============================================================================
local function VerifyKeyOnline(key)
    if not key or #key < 4 then
        return false, "Key too short"
    end
    local url = SERVER_URL .. "/api/client/verify?key=" .. HttpService:UrlEncode(key) .. "&hwid=" .. HttpService:UrlEncode(CURRENT_HWID)
    local res = HttpRequest({ Url = url, Method = "GET" })
    if res and res.StatusCode == 200 and res.Body then
        local ok, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
        if ok and data then
            if data.valid == true then
                return true, "Key Validated", data
            else
                return false, data.message or "Invalid Key", data
            end
        end
    end
    if res and res.Body then
        local ok, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
        if ok and data and data.message then
            return false, data.message, data
        end
    end
    return false, "Server connection failed (" .. tostring(res and res.StatusCode or 0) .. ")"
end

-- ==============================================================================
-- 3. LOAD SCRIPT FROM SERVER INTO MEMORY
-- ==============================================================================
local function ExecuteGameScript(key, gameCode, gameTitle, RayfieldLib)
    local url = SERVER_URL .. "/api/client/script?key=" .. HttpService:UrlEncode(key) .. "&hwid=" .. HttpService:UrlEncode(CURRENT_HWID) .. "&game=" .. HttpService:UrlEncode(gameCode)
    
    if RayfieldLib then
        RayfieldLib:Notify({
            Title = "MintraZERX Loader",
            Content = "Downloading " .. gameTitle .. " from server...",
            Duration = 3.5
        })
    end

    local res = HttpRequest({ Url = url, Method = "GET" })
    if not res or res.StatusCode ~= 200 or not res.Body or #res.Body < 50 then
        local err = "Failed to download payload from server"
        if res and res.Body then
            pcall(function()
                local data = HttpService:JSONDecode(res.Body)
                if data and data.message then err = data.message end
            end)
        end
        if RayfieldLib then
            RayfieldLib:Notify({
                Title = "Error",
                Content = err,
                Duration = 5
            })
        end
        return false, err
    end

    local fn, compileErr = loadstring(res.Body)
    if not fn then
        local err = "Compile Error: " .. tostring(compileErr)
        if RayfieldLib then
            RayfieldLib:Notify({ Title = "Execution Error", Content = err, Duration = 5 })
        end
        return false, err
    end

    task.spawn(fn)

    if RayfieldLib then
        RayfieldLib:Notify({
            Title = "Success",
            Content = gameTitle .. " executed in memory.",
            Duration = 4
        })
    end
    return true, "Success"
end

-- ==============================================================================
-- 4. SUPPORTED GAMES DATABASE
-- ==============================================================================
local SupportedGames = {
    {
        Id = "thelostfront",
        Name = "The Lost Front",
        PlaceId = 72299838142412,
        IsActive = function()
            return game.PlaceId == 72299838142412 or (workspace:FindFirstChild("debris") and workspace:FindFirstChild("itemModels") ~= nil)
        end
    },
    {
        Id = "formulaapex",
        Name = "Formula Apex",
        PlaceId = 5976159288,
        IsActive = function()
            if game.PlaceId == 5976159288 then return true end
            local tracks = { "Canada", "Monaco", "Spa", "Silverstone", "Monza", "Bahrain" }
            for _, t in ipairs(tracks) do
                if workspace:FindFirstChild(t) then return true end
            end
            return false
        end
    },
    {
        Id = "scproleplay",
        Name = "SCP: Roleplay",
        PlaceId = 5041144419,
        IsActive = function()
            return game.PlaceId == 5041144419 or workspace:FindFirstChild("SCP") ~= nil
        end
    },
    {
        Id = "zosamurai",
        Name = "ZO Samurai",
        PlaceId = 6678877691,
        IsActive = function()
            return game.PlaceId == 6678877691 or game:GetService("ReplicatedStorage"):FindFirstChild("AirDensityMapIdentifier") ~= nil
        end
    }
}

local function GetCurrentActiveGame()
    for _, g in ipairs(SupportedGames) do
        if g.IsActive() then
            return g
        end
    end
    return nil
end

-- ==============================================================================
-- 5. LOAD RAYFIELD UI LIBRARY
-- ==============================================================================
local function LoadRayfield()
    local urls = {
        "https://sirius.menu/rayfield",
        "https://raw.githubusercontent.com/jensonhirst/Rayfield/main/source"
    }
    for _, u in ipairs(urls) do
        local ok, src = pcall(function() return game:HttpGet(u) end)
        if ok and type(src) == "string" and #src > 100 then
            local okLib, lib = pcall(function() return loadstring(src)() end)
            if okLib and type(lib) == "table" and lib.CreateWindow then
                return lib
            end
        end
    end
    return nil
end

local Rayfield = LoadRayfield()
if not Rayfield then
    warn("[MintraZERX] Failed to load Rayfield library.")
    return
end

-- ==============================================================================
-- 6. CHECK FOR CACHED KEY BEFORE KEYUI
-- ==============================================================================
local CachedKey = nil
local KeyFolder = "Rayfield/Key System"
local KeyPath = KeyFolder .. "/" .. SAVE_KEY_FILE .. ".rfld"

pcall(function()
    if isfile and isfile(KeyPath) and readfile then
        local raw = readfile(KeyPath)
        if raw and #raw >= 4 then
            CachedKey = raw:gsub("%s+", ""):upper()
        end
    end
end)

local AcceptedKeyList = {}
local ACTIVE_KEY = ""

if CachedKey then
    local ok, valid, data = VerifyKeyOnline(CachedKey)
    if valid then
        table.insert(AcceptedKeyList, CachedKey)
        ACTIVE_KEY = CachedKey
    else
        CachedKey = nil
        pcall(function()
            if delfile and isfile(KeyPath) then delfile(KeyPath) end
        end)
    end
end

-- ==============================================================================
-- 7. BACKGROUND KEY INTERCEPTOR FOR RAYFIELD KEYUI
-- ==============================================================================
local KeySettingsRef = {
    Title = "MintraZERX Suite",
    Subtitle = "Key System Verification",
    Note = "Redeem key at: " .. REDEEM_URL,
    FileName = SAVE_KEY_FILE,
    SaveKey = true,
    GrabKeyFromSite = false,
    Key = (CachedKey and { CachedKey }) or { "MINTRA_SECURITY_GATE_DEFAULT" }
}

if not CachedKey then
    task.spawn(function()
        local hui = (gethui and gethui()) or CoreGui
        local keyUI = nil
        for _ = 1, 60 do
            keyUI = hui:FindFirstChild("KeyUI") or CoreGui:FindFirstChild("KeyUI")
            if keyUI and keyUI:FindFirstChild("Main") then break end
            task.wait(0.1)
        end

        if keyUI and keyUI:FindFirstChild("Main") then
            local main = keyUI.Main
            local input = main:FindFirstChild("Input") and main.Input:FindFirstChild("InputBox")
            local note = main:FindFirstChild("NoteMessage")

            if input and note then
                note.Text = "Type or paste key. Press Enter to verify."

                local checking = false
                input.FocusLost:Connect(function(enterPressed)
                    local text = input.Text:gsub("%s+", ""):upper()
                    if #text < 4 or checking then return end
                    checking = true
                    note.Text = "Verifying with server..."

                    local ok, valid, msg = VerifyKeyOnline(text)
                    if valid then
                        ACTIVE_KEY = text
                        KeySettingsRef.Key = { text }
                        note.Text = "Key Approved! Logging in..."
                    else
                        KeySettingsRef.Key = { "MINTRA_INVALID_KEY" }
                        note.Text = "Rejected: " .. tostring(msg)
                    end
                    task.wait(0.3)
                    checking = false
                end)
            end
        end
    end)
end

-- ==============================================================================
-- 8. CREATE RAYFIELD WINDOW
-- ==============================================================================
local Window = Rayfield:CreateWindow({
    Name = "MintraZERX Multi-Game Hub",
    LoadingTitle = "MintraZERX Suite",
    LoadingSubtitle = "Cloud Protected Client",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = true,
    KeySettings = KeySettingsRef
})

-- ==============================================================================
-- 9. TAB 1: GAMES HUB (LIVE NAME & THUMBNAIL FETCHING)
-- ==============================================================================
local GamesTab = Window:CreateTab("Games Hub", nil)

local currentActive = GetCurrentActiveGame()

GamesTab:CreateSection("CURRENT SESSION")

if currentActive then
    GamesTab:CreateParagraph({
        Title = "Detected Active Game",
        Content = "You are currently playing: " .. currentActive.Name .. " (Place ID: " .. tostring(currentActive.PlaceId) .. ")\nStatus: Ready to load script."
    })

    GamesTab:CreateButton({
        Name = "Launch " .. currentActive.Name .. " Script",
        Callback = function()
            local keyToUse = ACTIVE_KEY ~= "" and ACTIVE_KEY or CachedKey
            if not keyToUse or #keyToUse < 4 then
                Rayfield:Notify({ Title = "Key Missing", Content = "No valid key active.", Duration = 4 })
                return
            end
            ExecuteGameScript(keyToUse, currentActive.Id, currentActive.Name, Rayfield)
        end
    })
else
    GamesTab:CreateParagraph({
        Title = "No Supported Game Active",
        Content = "Current game is not in the supported list. Select a game below to launch or teleport."
    })
end

GamesTab:CreateSection("ALL SUPPORTED GAMES")

for _, gInfo in ipairs(SupportedGames) do
    local liveName = gInfo.Name
    local pInfo = nil
    pcall(function()
        pInfo = MarketplaceService:GetProductInfo(gInfo.PlaceId)
        if pInfo and pInfo.Name then
            liveName = pInfo.Name
        end
    end)

    local isPlayingThis = (game.PlaceId == gInfo.PlaceId)
    local statusText = isPlayingThis and "Status: Currently in this game" or "Status: Not in this game"

    GamesTab:CreateParagraph({
        Title = liveName,
        Content = "Place ID: " .. tostring(gInfo.PlaceId) .. "\n" .. statusText .. "\nThumbnail: rbxthumb://type=GameIcon&id=" .. tostring(gInfo.PlaceId) .. "&w=150&h=150"
    })

    if isPlayingThis then
        GamesTab:CreateButton({
            Name = "Launch " .. gInfo.Name .. " Script",
            Callback = function()
                local keyToUse = ACTIVE_KEY ~= "" and ACTIVE_KEY or CachedKey
                if not keyToUse then
                    Rayfield:Notify({ Title = "Key Missing", Content = "Please re-authenticate.", Duration = 4 })
                    return
                end
                ExecuteGameScript(keyToUse, gInfo.Id, gInfo.Name, Rayfield)
            end
        })
    else
        GamesTab:CreateButton({
            Name = "Teleport to " .. gInfo.Name,
            Callback = function()
                Rayfield:Notify({
                    Title = "Teleporting",
                    Content = "Connecting to " .. gInfo.Name .. "...",
                    Duration = 4
                })
                pcall(function()
                    TeleportService:Teleport(gInfo.PlaceId, LocalPlayer)
                end)
            end
        })
    end
end

-- ==============================================================================
-- 10. TAB 2: LICENSE & SETTINGS
-- ==============================================================================
local LicenseTab = Window:CreateTab("License Info", nil)

LicenseTab:CreateSection("LICENSE STATUS")

local displayKey = ACTIVE_KEY ~= "" and ACTIVE_KEY or (CachedKey or "Not Loaded")
if #displayKey > 8 then
    displayKey = string.sub(displayKey, 1, 8) .. "-****-****"
end

LicenseTab:CreateParagraph({
    Title = "Active License",
    Content = "Key: " .. displayKey .. "\nHardware ID: " .. CURRENT_HWID .. "\nServer: " .. SERVER_URL
})

LicenseTab:CreateButton({
    Name = "Copy Redeem Portal Link",
    Callback = function()
        if setclipboard then
            setclipboard(REDEEM_URL)
            Rayfield:Notify({
                Title = "Copied",
                Content = "Redeem portal link copied to clipboard.",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Redeem URL",
                Content = REDEEM_URL,
                Duration = 6
            })
        end
    end
})

LicenseTab:CreateButton({
    Name = "Clear Saved Key & Logout",
    Callback = function()
        pcall(function()
            if delfile and isfile(KeyPath) then
                delfile(KeyPath)
            end
        end)
        Rayfield:Notify({
            Title = "Logged Out",
            Content = "Saved key cleared. Please restart the loader.",
            Duration = 5
        })
    end
})

LicenseTab:CreateButton({
    Name = "Close MintraZERX Hub",
    Callback = function()
        Rayfield:Destroy()
    end
})

Rayfield:Notify({
    Title = "MintraZERX Hub",
    Content = "Authenticated successfully.",
    Duration = 3.5
})
