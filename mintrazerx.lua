--[[
    ==============================================================================
    MINTRAZERX MULTI-GAME HUB & SECURE LOADER (RAYFIELD EDITION)
    Server: https://mintrazerx-keysystem-wf4n.onrender.com/
    
    Features:
      - Clean English interface (No emojis)
      - Rayfield UI with smooth animated Key System Login
      - Direct online key verification with Render server
      - Multi-Game Hub with live name and thumbnail fetching
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
local TweenService = game:GetService("TweenService")
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
    local cleanKey = key:gsub("%s+", ""):upper()
    local url = SERVER_URL .. "/api/client/verify?key=" .. HttpService:UrlEncode(cleanKey) .. "&hwid=" .. HttpService:UrlEncode(CURRENT_HWID)
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
    return false, "Connection failed (" .. tostring(res and res.StatusCode or 0) .. ")"
end

-- ==============================================================================
-- 3. LOAD SCRIPT FROM SERVER INTO MEMORY
-- ==============================================================================
local function ExecuteGameScript(key, gameCode, gameTitle, RayfieldLib)
    local cleanKey = tostring(key or ""):gsub("%s+", ""):upper()
    if #cleanKey < 4 then
        pcall(function()
            if isfile and isfile("mintrazerx_key.txt") and readfile then
                local diskKey = readfile("mintrazerx_key.txt")
                if diskKey and #diskKey >= 4 then cleanKey = diskKey:gsub("%s+", ""):upper() end
            end
        end)
    end

    local url = SERVER_URL .. "/api/client/script?key=" .. HttpService:UrlEncode(cleanKey) .. "&hwid=" .. HttpService:UrlEncode(CURRENT_HWID) .. "&game=" .. HttpService:UrlEncode(gameCode)
    
    if RayfieldLib then
        RayfieldLib:Notify({
            Title = "Loader Script",
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

-- Forward declaration of Main Window Launcher
local OpenRayfieldHub = nil

OpenRayfieldHub = function(validKey)
    local Rayfield = LoadRayfield()
    if not Rayfield then
        warn("[MintraZERX] Failed to load Rayfield library.")
        return
    end

    local Window = Rayfield:CreateWindow({
        Name = "Loader Script",
        LoadingTitle = "Loader Script",
        LoadingSubtitle = "made by valexcryzer",
        ConfigurationSaving = {
            Enabled = false
        },
        Discord = {
            Enabled = false
        },
        KeySystem = false
    })

    -- TAB 1: GAMES HUB
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
                ExecuteGameScript(validKey, currentActive.Id, currentActive.Name, Rayfield)
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
        pcall(function()
            local pInfo = MarketplaceService:GetProductInfo(gInfo.PlaceId)
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
                    ExecuteGameScript(validKey, gInfo.Id, gInfo.Name, Rayfield)
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

    -- TAB 2: LICENSE INFO
    local LicenseTab = Window:CreateTab("License Info", nil)

    LicenseTab:CreateSection("LICENSE STATUS")

    local displayKey = validKey
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
                local keyPath = "Rayfield/Key System/" .. SAVE_KEY_FILE .. ".rfld"
                if delfile and isfile(keyPath) then delfile(keyPath) end
                if delfile and isfile("mintrazerx_key.txt") then delfile("mintrazerx_key.txt") end
            end)
            Rayfield:Notify({
                Title = "Logged Out",
                Content = "Saved key cleared. Please restart the loader.",
                Duration = 5
            })
        end
    })

    LicenseTab:CreateButton({
        Name = "Close Loader Script",
        Callback = function()
            Rayfield:Destroy()
        end
    })

    Rayfield:Notify({
        Title = "Loader Script",
        Content = "Authenticated successfully.",
        Duration = 3.5
    })
end

-- ==============================================================================
-- 6. RAYFIELD-STYLED AUTHENTICATION KEY UI
-- ==============================================================================
local function ShowRayfieldKeyLogin()
    local parentGui = (gethui and gethui()) or CoreGui

    local oldUI = parentGui:FindFirstChild("MintraZERX_RayKeyUI")
    if oldUI then oldUI:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MintraZERX_RayKeyUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Key Window (Matches Rayfield KeyUI design)
    local Main = Instance.new("Frame")
    Main.Name = "KeyMain"
    Main.Size = UDim2.new(0, 480, 0, 210)
    Main.Position = UDim2.new(0.5, -240, 0.5, -105)
    Main.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(55, 55, 65)
    MainStroke.Thickness = 1.2
    MainStroke.Parent = Main

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = "Loader Script"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.Size = UDim2.new(1, -40, 0, 25)
    Title.Position = UDim2.new(0, 20, 0, 16)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Main

    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Text = "Key System Verification"
    Subtitle.Font = Enum.Font.GothamMedium
    Subtitle.TextSize = 13
    Subtitle.TextColor3 = Color3.fromRGB(150, 150, 165)
    Subtitle.Size = UDim2.new(1, -40, 0, 18)
    Subtitle.Position = UDim2.new(0, 20, 0, 42)
    Subtitle.BackgroundTransparency = 1
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Main

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Text = "X"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -38, 0, 14)
    CloseBtn.Parent = Main
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Input Box Frame
    local InputFrame = Instance.new("Frame")
    InputFrame.Name = "InputFrame"
    InputFrame.Size = UDim2.new(1, -40, 0, 44)
    InputFrame.Position = UDim2.new(0, 20, 0, 72)
    InputFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    InputFrame.BorderSizePixel = 0
    InputFrame.Parent = Main

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 8)
    InputCorner.Parent = InputFrame

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.fromRGB(60, 60, 75)
    InputStroke.Thickness = 1
    InputStroke.Parent = InputFrame

    local InputBox = Instance.new("TextBox")
    InputBox.Name = "InputBox"
    InputBox.Size = UDim2.new(1, -20, 1, 0)
    InputBox.Position = UDim2.new(0, 10, 0, 0)
    InputBox.BackgroundTransparency = 1
    InputBox.Font = Enum.Font.Gotham
    InputBox.TextSize = 14
    InputBox.TextColor3 = Color3.fromRGB(240, 240, 240)
    InputBox.PlaceholderText = "Paste your license key here..."
    InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 135)
    InputBox.ClearTextOnFocus = false
    InputBox.Parent = InputFrame

    -- Note / Status Message
    local NoteMessage = Instance.new("TextLabel")
    NoteMessage.Name = "NoteMessage"
    NoteMessage.Text = "Enter key and click Verify or press Enter."
    NoteMessage.Font = Enum.Font.Gotham
    NoteMessage.TextSize = 12
    NoteMessage.TextColor3 = Color3.fromRGB(150, 150, 165)
    NoteMessage.Size = UDim2.new(1, -40, 0, 18)
    NoteMessage.Position = UDim2.new(0, 20, 0, 124)
    NoteMessage.BackgroundTransparency = 1
    NoteMessage.TextXAlignment = Enum.TextXAlignment.Left
    NoteMessage.Parent = Main

    -- Action Buttons (Verify & Get Key)
    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Name = "VerifyButton"
    VerifyBtn.Text = "VERIFY KEY"
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 13
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(45, 110, 230)
    VerifyBtn.Size = UDim2.new(0.55, -25, 0, 36)
    VerifyBtn.Position = UDim2.new(0, 20, 0, 154)
    VerifyBtn.BorderSizePixel = 0
    VerifyBtn.Parent = Main

    local VerifyCorner = Instance.new("UICorner")
    VerifyCorner.CornerRadius = UDim.new(0, 6)
    VerifyCorner.Parent = VerifyBtn

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Name = "GetKeyButton"
    GetKeyBtn.Text = "GET KEY / REDEEM"
    GetKeyBtn.Font = Enum.Font.GothamMedium
    GetKeyBtn.TextSize = 12
    GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 215)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
    GetKeyBtn.Size = UDim2.new(0.45, -25, 0, 36)
    GetKeyBtn.Position = UDim2.new(0.55, 5, 0, 154)
    GetKeyBtn.BorderSizePixel = 0
    GetKeyBtn.Parent = Main

    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 6)
    GetKeyCorner.Parent = GetKeyBtn

    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(REDEEM_URL)
            NoteMessage.Text = "Redeem link copied to clipboard."
            NoteMessage.TextColor3 = Color3.fromRGB(100, 220, 120)
        else
            NoteMessage.Text = "URL: " .. REDEEM_URL
        end
    end)

    -- Verification Process
    local isVerifying = false
    local function DoVerify()
        if isVerifying then return end
        local rawText = InputBox.Text:gsub("%s+", ""):upper()
        if #rawText < 4 then
            NoteMessage.Text = "Please enter a valid key code."
            NoteMessage.TextColor3 = Color3.fromRGB(255, 80, 80)
            return
        end

        isVerifying = true
        VerifyBtn.Text = "VERIFYING..."
        NoteMessage.Text = "Contacting authentication server..."
        NoteMessage.TextColor3 = Color3.fromRGB(200, 200, 210)

        task.spawn(function()
            local isValid, message, data = VerifyKeyOnline(rawText)
            if isValid == true then
                NoteMessage.Text = "Key Approved! Loading Hub..."
                NoteMessage.TextColor3 = Color3.fromRGB(100, 255, 120)

                -- Save Key to Disk
                pcall(function()
                    if writefile then
                        if not isfolder("Rayfield/Key System") then
                            pcall(makefolder, "Rayfield/Key System")
                        end
                        writefile("Rayfield/Key System/" .. SAVE_KEY_FILE .. ".rfld", rawText)
                        writefile("mintrazerx_key.txt", rawText)
                    end
                end)

                task.wait(0.6)
                ScreenGui:Destroy()
                OpenRayfieldHub(rawText)
            else
                isVerifying = false
                VerifyBtn.Text = "VERIFY KEY"
                local errMsg = message or (data and data.message) or "Invalid key. Check website."
                NoteMessage.Text = "Rejected: " .. tostring(errMsg)
                NoteMessage.TextColor3 = Color3.fromRGB(255, 80, 80)

                -- Shake animation
                local origPos = Main.Position
                TweenService:Create(Main, TweenInfo.new(0.08, Enum.EasingStyle.Linear), { Position = UDim2.new(origPos.X.Scale, origPos.X.Offset - 10, origPos.Y.Scale, origPos.Y.Offset) }):Play()
                task.wait(0.08)
                TweenService:Create(Main, TweenInfo.new(0.08, Enum.EasingStyle.Linear), { Position = UDim2.new(origPos.X.Scale, origPos.X.Offset + 10, origPos.Y.Scale, origPos.Y.Offset) }):Play()
                task.wait(0.08)
                TweenService:Create(Main, TweenInfo.new(0.08, Enum.EasingStyle.Linear), { Position = origPos }):Play()
            end
        end)
    end

    VerifyBtn.MouseButton1Click:Connect(DoVerify)
    InputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            DoVerify()
        end
    end)

    ScreenGui.Parent = parentGui
end

-- ==============================================================================
-- 7. INITIAL LAUNCH ENTRY POINT
-- ==============================================================================
local function Start()
    -- Check for cached key on disk
    local cached = nil
    pcall(function()
        local rfldPath = "Rayfield/Key System/" .. SAVE_KEY_FILE .. ".rfld"
        if isfile and isfile(rfldPath) and readfile then
            local c = readfile(rfldPath)
            if c and #c >= 4 then cached = c:gsub("%s+", ""):upper() end
        end
        if not cached and isfile and isfile("mintrazerx_key.txt") and readfile then
            local c = readfile("mintrazerx_key.txt")
            if c and #c >= 4 then cached = c:gsub("%s+", ""):upper() end
        end
    end)

    if cached then
        print("[MintraZERX] Verifying cached license key: " .. tostring(cached))
        local isValid, message, data = VerifyKeyOnline(cached)
        if isValid == true then
            print("[MintraZERX] License verified. Opening Hub...")
            OpenRayfieldHub(cached)
            return
        else
            warn("[MintraZERX] Cached key invalid: " .. tostring(message) .. ". Purging cache...")
            pcall(function()
                local rfldPath = "Rayfield/Key System/" .. SAVE_KEY_FILE .. ".rfld"
                if delfile then
                    pcall(delfile, rfldPath)
                    pcall(delfile, "mintrazerx_key.txt")
                elseif writefile then
                    pcall(writefile, rfldPath, "")
                    pcall(writefile, "mintrazerx_key.txt", "")
                end
            end)
        end
    end

    -- Show Key Login UI
    ShowRayfieldKeyLogin()
end

Start()
