-- SUNC Function Testing GUI for Roblox
-- Tests executor functions and displays results with animated progress

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Animation settings
local TWEEN_INFO = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local HOVER_TWEEN = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local PROGRESS_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- State management
local testResults = {
    passed = 0,
    timeout = 0,
    failed = 0,
    total = 0
}
local timeElapsed = 0
local isTestingActive = false
local functionLogs = {}

-- Function list to test
local functionsToTest = {
    "cache.invalidate", "cache.iscached", "cache.replace", "cloneref", "compareinstances",
    "base64_encode", "base64_decode", "debug.getconstant", "debug.getconstants", "debug.getinfo",
    "debug.getproto", "debug.getprotos", "debug.getupvalue", "debug.getupvalues", "debug.setconstant",
    "getgc", "getloadedmodules", "getrunningscripts", "getscripts", "getsenv",
    "hookmetamethod", "iscclosure", "isexecutorclosure", "islclosure", "newcclosure",
    "setreadonly", "lz4compress", "lz4decompress", "getscriptclosure", "request",
    "getcallbackvalue", "listfiles", "writefile", "isfolder", "makefolder",
    "appendfile", "isfile", "delfolder", "delfile", "loadfile",
    "gethui", "getrawmetatable", "isreadonly", "getnamecallmethod", "setscriptable",
    "isscriptable", "getinstances", "getnilinstances", "fireproximityprompt", "setrawmetatable",
    "getthreadidentity", "setthreadidentity", "getrenderproperty", "setrenderproperty", "Drawing.new",
    "Drawing.Fonts", "cleardrawcache", "loadstring", "debug.setupvalue", "readfile",
    "getscriptbytecode", "getcallingscript", "isrenderobj", "firesignal", "getscripthash",
    "identifyexecutor", "getfunctionhash", "gethiddenproperty", "debug.getstack", "firetouchinterest",
    "filtergc", "getrenv", "crypt.decrypt", "crypt.generatebytes", "crypt.generatekey",
    "getconnections", "checkcaller", "crypt.encrypt", "fireclickdetector", "debug.setstack",
    "decompile", "hookfunction", "restorefunction", "clonefunction", "getgenv",
    "getcustomasset", "sethiddenproperty", "WebSocket.connect", "replicatesignal", "crypt.hash"
}

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SUNCTestingGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 700, 0, 450)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 100
mainFrame.Parent = screenGui

-- Add corner radius and shadow
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local shadowFrame = Instance.new("Frame")
shadowFrame.Name = "Shadow"
shadowFrame.Size = UDim2.new(1, 8, 1, 8)
shadowFrame.Position = UDim2.new(0, -4, 0, -4)
shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame.BackgroundTransparency = 0.7
shadowFrame.BorderSizePixel = 0
shadowFrame.ZIndex = 99
shadowFrame.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 16)
shadowCorner.Parent = shadowFrame

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.ZIndex = 102
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

-- Left panel for circular progress and stats
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, 320, 1, 0)
leftPanel.Position = UDim2.new(0, 0, 0, 0)
leftPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
leftPanel.BorderSizePixel = 0
leftPanel.ZIndex = 101
leftPanel.Parent = mainFrame

-- Right panel for search and function logs
local rightPanel = Instance.new("Frame")
rightPanel.Name = "RightPanel"
rightPanel.Size = UDim2.new(1, -320, 1, 0)
rightPanel.Position = UDim2.new(0, 320, 0, 0)
rightPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
leftPanel.BorderSizePixel = 0
rightPanel.ZIndex = 101
rightPanel.Parent = mainFrame

-- Circular progress container
local progressContainer = Instance.new("Frame")
progressContainer.Name = "ProgressContainer"
progressContainer.Size = UDim2.new(0, 180, 0, 180)
progressContainer.Position = UDim2.new(0.5, -90, 0, 30)
progressContainer.BackgroundTransparency = 1
progressContainer.ZIndex = 102
progressContainer.Parent = leftPanel

-- Create circular progress using frames
local function createCircularProgress()
    -- Background circle
    local bgCircle = Instance.new("Frame")
    bgCircle.Name = "BackgroundCircle"
    bgCircle.Size = UDim2.new(1, 0, 1, 0)
    bgCircle.Position = UDim2.new(0, 0, 0, 0)
    bgCircle.BackgroundTransparency = 1
    bgCircle.ZIndex = 103
    bgCircle.Parent = progressContainer
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.fromRGB(40, 40, 40)
    bgStroke.Thickness = 8
    bgStroke.Parent = bgCircle
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0.5, 0)
    bgCorner.Parent = bgCircle
    
    -- Progress circle
    local progressCircle = Instance.new("Frame")
    progressCircle.Name = "ProgressCircle"
    progressCircle.Size = UDim2.new(1, 0, 1, 0)
    progressCircle.Position = UDim2.new(0, 0, 0, 0)
    progressCircle.BackgroundTransparency = 1
    progressCircle.ZIndex = 104
    progressCircle.Parent = progressContainer
    
    local progressStroke = Instance.new("UIStroke")
    progressStroke.Color = Color3.fromRGB(100, 255, 100)
    progressStroke.Thickness = 8
    progressStroke.Transparency = 1
    progressStroke.Parent = progressCircle
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0.5, 0)
    progressCorner.Parent = progressCircle
    
    -- Create gradient for progress effect
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 200, 50))
    }
    gradient.Rotation = 90
    gradient.Parent = progressStroke
    
    return progressCircle, progressStroke
end

local progressCircle, progressStroke = createCircularProgress()

-- Progress text in center
local progressText = Instance.new("TextLabel")
progressText.Name = "ProgressText"
progressText.Size = UDim2.new(0, 120, 0, 40)
progressText.Position = UDim2.new(0.5, -60, 0.5, -35)
progressText.BackgroundTransparency = 1
progressText.Text = "0%"
progressText.TextColor3 = Color3.fromRGB(255, 255, 255)
progressText.TextSize = 32
progressText.Font = Enum.Font.GothamBold
progressText.TextXAlignment = Enum.TextXAlignment.Center
progressText.ZIndex = 105
progressText.Parent = progressContainer

-- Progress subtext
local progressSubtext = Instance.new("TextLabel")
progressSubtext.Name = "ProgressSubtext"
progressSubtext.Size = UDim2.new(0, 120, 0, 20)
progressSubtext.Position = UDim2.new(0.5, -60, 0.5, 5)
progressSubtext.BackgroundTransparency = 1
progressSubtext.Text = "0/" .. #functionsToTest
progressSubtext.TextColor3 = Color3.fromRGB(150, 150, 150)
progressSubtext.TextSize = 16
progressSubtext.Font = Enum.Font.Gotham
progressSubtext.TextXAlignment = Enum.TextXAlignment.Center
progressSubtext.ZIndex = 105
progressSubtext.Parent = progressContainer

-- Status text below circle
local statusText = Instance.new("TextLabel")
statusText.Name = "StatusText"
statusText.Size = UDim2.new(1, -20, 0, 25)
statusText.Position = UDim2.new(0, 10, 0, 230)
statusText.BackgroundTransparency = 1
statusText.Text = "no faked aura +100"
statusText.TextColor3 = Color3.fromRGB(100, 100, 100)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.ZIndex = 103
statusText.Parent = leftPanel

-- Version text
local versionText = Instance.new("TextLabel")
versionText.Name = "VersionText"
versionText.Size = UDim2.new(1, -20, 0, 25)
versionText.Position = UDim2.new(0, 10, 0, 255)
versionText.BackgroundTransparency = 1
versionText.Text = "v1.2.0"
versionText.TextColor3 = Color3.fromRGB(100, 100, 100)
versionText.TextSize = 12
versionText.Font = Enum.Font.Gotham
versionText.TextXAlignment = Enum.TextXAlignment.Center
versionText.ZIndex = 103
versionText.Parent = leftPanel

-- Zenith indicator
local zenithContainer = Instance.new("Frame")
zenithContainer.Name = "ZenithContainer"
zenithContainer.Size = UDim2.new(1, -20, 0, 30)
zenithContainer.Position = UDim2.new(0, 10, 0, 280)
zenithContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
zenithContainer.BorderSizePixel = 0
zenithContainer.ZIndex = 103
zenithContainer.Parent = leftPanel

local zenithCorner = Instance.new("UICorner")
zenithCorner.CornerRadius = UDim.new(0, 6)
zenithCorner.Parent = zenithContainer

local zenithText = Instance.new("TextLabel")
zenithText.Size = UDim2.new(1, -40, 1, 0)
zenithText.Position = UDim2.new(0, 10, 0, 0)
zenithText.BackgroundTransparency = 1
zenithText.Text = "Zenith"
zenithText.TextColor3 = Color3.fromRGB(200, 200, 200)
zenithText.TextSize = 14
zenithText.Font = Enum.Font.Gotham
zenithText.TextXAlignment = Enum.TextXAlignment.Left
zenithText.ZIndex = 104
zenithText.Parent = zenithContainer

local zenithValue = Instance.new("TextLabel")
zenithValue.Size = UDim2.new(0, 30, 1, 0)
zenithValue.Position = UDim2.new(1, -35, 0, 0)
zenithValue.BackgroundTransparency = 1
zenithValue.Text = "8"
zenithValue.TextColor3 = Color3.fromRGB(200, 200, 200)
zenithValue.TextSize = 14
zenithValue.Font = Enum.Font.GothamBold
zenithValue.TextXAlignment = Enum.TextXAlignment.Right
zenithValue.ZIndex = 104
zenithValue.Parent = zenithContainer

-- Statistics container
local statsContainer = Instance.new("Frame")
statsContainer.Name = "StatsContainer"
statsContainer.Size = UDim2.new(1, -20, 0, 80)
statsContainer.Position = UDim2.new(0, 10, 0, 320)
statsContainer.BackgroundTransparency = 1
statsContainer.ZIndex = 102
statsContainer.Parent = leftPanel

-- Create stat cards
local statData = {
    {title = "Passed", value = "0", color = Color3.fromRGB(100, 255, 100), key = "passed"},
    {title = "Timeout", value = "0", color = Color3.fromRGB(255, 200, 100), key = "timeout"},
    {title = "Failed", value = "0", color = Color3.fromRGB(255, 100, 100), key = "failed"}
}

local statCards = {}

for i, stat in ipairs(statData) do
    local statCard = Instance.new("Frame")
    statCard.Name = stat.title .. "Card"
    statCard.Size = UDim2.new(0.31, 0, 1, 0)
    statCard.Position = UDim2.new((i-1) * 0.345, 0, 0, 0)
    statCard.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    statCard.BorderSizePixel = 0
    statCard.ZIndex = 103
    statCard.Parent = statsContainer
    
    local statCorner = Instance.new("UICorner")
    statCorner.CornerRadius = UDim.new(0, 8)
    statCorner.Parent = statCard
    
    -- Stat value
    local statValue = Instance.new("TextLabel")
    statValue.Name = "Value"
    statValue.Size = UDim2.new(1, -10, 0, 35)
    statValue.Position = UDim2.new(0, 5, 0, 15)
    statValue.BackgroundTransparency = 1
    statValue.Text = stat.value
    statValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    statValue.TextSize = 28
    statValue.Font = Enum.Font.GothamBold
    statValue.TextXAlignment = Enum.TextXAlignment.Center
    statValue.ZIndex = 104
    statValue.Parent = statCard
    
    -- Stat title
    local statTitle = Instance.new("TextLabel")
    statTitle.Size = UDim2.new(1, -10, 0, 20)
    statTitle.Position = UDim2.new(0, 5, 0, 50)
    statTitle.BackgroundTransparency = 1
    statTitle.Text = stat.title
    statTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    statTitle.TextSize = 12
    statTitle.Font = Enum.Font.Gotham
    statTitle.TextXAlignment = Enum.TextXAlignment.Center
    statTitle.ZIndex = 104
    statTitle.Parent = statCard
    
    statCards[stat.key] = statValue
end

-- Time taken display
local timeContainer = Instance.new("Frame")
timeContainer.Name = "TimeContainer"
timeContainer.Size = UDim2.new(1, -20, 0, 40)
timeContainer.Position = UDim2.new(0, 10, 0, 405)
timeContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
timeContainer.BorderSizePixel = 0
timeContainer.ZIndex = 102
timeContainer.Parent = leftPanel

local timeCorner = Instance.new("UICorner")
timeCorner.CornerRadius = UDim.new(0, 8)
timeCorner.Parent = timeContainer

local timeValue = Instance.new("TextLabel")
timeValue.Name = "TimeValue"
timeValue.Size = UDim2.new(0, 60, 1, 0)
timeValue.Position = UDim2.new(0, 10, 0, 0)
timeValue.BackgroundTransparency = 1
timeValue.Text = "0s"
timeValue.TextColor3 = Color3.fromRGB(255, 255, 255)
timeValue.TextSize = 18
timeValue.Font = Enum.Font.GothamBold
timeValue.TextXAlignment = Enum.TextXAlignment.Left
timeValue.ZIndex = 103
timeValue.Parent = timeContainer

local timeTitle = Instance.new("TextLabel")
timeTitle.Size = UDim2.new(1, -70, 1, 0)
timeTitle.Position = UDim2.new(0, 70, 0, 0)
timeTitle.BackgroundTransparency = 1
timeTitle.Text = "Time Taken"
timeTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
timeTitle.TextSize = 14
timeTitle.Font = Enum.Font.Gotham
timeTitle.TextXAlignment = Enum.TextXAlignment.Left
timeTitle.ZIndex = 103
timeTitle.Parent = timeContainer

-- Search bar in right panel
local searchContainer = Instance.new("Frame")
searchContainer.Name = "SearchContainer"
searchContainer.Size = UDim2.new(1, -20, 0, 40)
searchContainer.Position = UDim2.new(0, 10, 0, 20)
searchContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
searchContainer.BorderSizePixel = 0
searchContainer.ZIndex = 102
searchContainer.Parent = rightPanel

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = searchContainer

-- Search icon
local searchIcon = Instance.new("TextLabel")
searchIcon.Size = UDim2.new(0, 30, 1, 0)
searchIcon.Position = UDim2.new(0, 10, 0, 0)
searchIcon.BackgroundTransparency = 1
searchIcon.Text = "🔍"
searchIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
searchIcon.TextSize = 16
searchIcon.Font = Enum.Font.Gotham
searchIcon.TextXAlignment = Enum.TextXAlignment.Center
searchIcon.ZIndex = 103
searchIcon.Parent = searchContainer

-- Search textbox
local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Size = UDim2.new(1, -50, 1, 0)
searchBox.Position = UDim2.new(0, 40, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.Text = ""
searchBox.PlaceholderText = "Search functions..."
searchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.TextSize = 14
searchBox.Font = Enum.Font.Gotham
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.BorderSizePixel = 0
searchBox.ZIndex = 103
searchBox.Parent = searchContainer

-- Functions title
local functionsTitle = Instance.new("TextLabel")
functionsTitle.Size = UDim2.new(1, -20, 0, 30)
functionsTitle.Position = UDim2.new(0, 10, 0, 80)
functionsTitle.BackgroundTransparency = 1
functionsTitle.Text = "Functions"
functionsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
functionsTitle.TextSize = 18
functionsTitle.Font = Enum.Font.GothamBold
functionsTitle.TextXAlignment = Enum.TextXAlignment.Left
functionsTitle.ZIndex = 103
functionsTitle.Parent = rightPanel

-- Start test button
local startButton = Instance.new("TextButton")
startButton.Name = "StartButton"
startButton.Size = UDim2.new(0, 100, 0, 30)
startButton.Position = UDim2.new(1, -110, 0, 80)
startButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
startButton.Text = "Start Test"
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startButton.TextSize = 14
startButton.Font = Enum.Font.GothamBold
startButton.BorderSizePixel = 0
startButton.ZIndex = 103
startButton.Parent = rightPanel

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 6)
startCorner.Parent = startButton

-- Function logs container
local logsContainer = Instance.new("ScrollingFrame")
logsContainer.Name = "LogsContainer"
logsContainer.Size = UDim2.new(1, -20, 1, -130)
logsContainer.Position = UDim2.new(0, 10, 0, 120)
logsContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
logsContainer.BorderSizePixel = 0
logsContainer.ScrollBarThickness = 6
logsContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
logsContainer.ScrollBarImageTransparency = 0.5
logsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
logsContainer.ScrollingDirection = Enum.ScrollingDirection.Y
logsContainer.ZIndex = 102
logsContainer.Parent = rightPanel

local logsCorner = Instance.new("UICorner")
logsCorner.CornerRadius = UDim.new(0, 8)
logsCorner.Parent = logsContainer

-- Animation functions
local function addButtonAnimations(button, normalColor, hoverColor)
    local isHovered = false
    
    button.MouseEnter:Connect(function()
        if not isHovered then
            isHovered = true
            local colorTween = TweenService:Create(button, HOVER_TWEEN, {BackgroundColor3 = hoverColor})
            colorTween:Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if isHovered then
            isHovered = false
            local colorTween = TweenService:Create(button, HOVER_TWEEN, {BackgroundColor3 = normalColor})
            colorTween:Play()
        end
    end)
end

-- Update progress animation
local function updateProgress(current, total)
    local percentage = math.floor((current / total) * 100)
    
    -- Update text
    progressText.Text = percentage .. "%"
    progressSubtext.Text = current .. "/" .. total
    
    -- Animate progress circle
    local progressTween = TweenService:Create(progressStroke, PROGRESS_TWEEN, {
        Transparency = 1 - (percentage / 100)
    })
    progressTween:Play()
end

-- Update statistics
local function updateStats()
    statCards.passed.Text = tostring(testResults.passed)
    statCards.timeout.Text = tostring(testResults.timeout)
    statCards.failed.Text = tostring(testResults.failed)
end

-- Add function log
local function addFunctionLog(functionName, status, details)
    local logEntry = {
        name = functionName,
        status = status,
        details = details or "",
        timestamp = os.date("%H:%M:%S")
    }
    table.insert(functionLogs, logEntry)
    
    -- Create log UI element
    local logFrame = Instance.new("Frame")
    logFrame.Name = "LogEntry" .. #functionLogs
    logFrame.Size = UDim2.new(1, -10, 0, 30)
    logFrame.Position = UDim2.new(0, 5, 0, (#functionLogs - 1) * 32)
    logFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    logFrame.BorderSizePixel = 0
    logFrame.ZIndex = 103
    logFrame.Parent = logsContainer
    
    local logCorner = Instance.new("UICorner")
    logCorner.CornerRadius = UDim.new(0, 4)
    logCorner.Parent = logFrame
    
    -- Status indicator
    local statusIndicator = Instance.new("TextLabel")
    statusIndicator.Size = UDim2.new(0, 30, 1, 0)
    statusIndicator.Position = UDim2.new(0, 5, 0, 0)
    statusIndicator.BackgroundTransparency = 1
    statusIndicator.Text = status == "passed" and "✅" or "❌"
    statusIndicator.TextColor3 = status == "passed" and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    statusIndicator.TextSize = 16
    statusIndicator.Font = Enum.Font.Gotham
    statusIndicator.TextXAlignment = Enum.TextXAlignment.Center
    statusIndicator.ZIndex = 104
    statusIndicator.Parent = logFrame
    
    -- Function name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -80, 1, 0)
    nameLabel.Position = UDim2.new(0, 35, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = functionName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 104
    nameLabel.Parent = logFrame
    
    -- Timestamp
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(0, 45, 1, 0)
    timeLabel.Position = UDim2.new(1, -45, 0, 0)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = logEntry.timestamp
    timeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    timeLabel.TextSize = 10
    timeLabel.Font = Enum.Font.Gotham
    timeLabel.TextXAlignment = Enum.TextXAlignment.Right
    timeLabel.ZIndex = 104
    timeLabel.Parent = logFrame
    
    -- Update canvas size
    logsContainer.CanvasSize = UDim2.new(0, 0, 0, #functionLogs * 32)
    
    -- Auto-scroll to bottom
    logsContainer.CanvasPosition = Vector2.new(0, logsContainer.CanvasSize.Y.Offset)
end

-- Test a single function
local function testFunction(functionName)
    local success = false
    local details = ""
    
    -- Try to access the function
    local func = nil
    if functionName:find("%.") then
        -- Handle nested functions like debug.getconstant
        local parts = functionName:split(".")
        func = _G
        for _, part in ipairs(parts) do
            if func and type(func) == "table" then
                func = func[part]
            else
                func = nil
                break
            end
        end
    else
        func = _G[functionName]
    end
    
    if func and type(func) == "function" then
        success = true
        details = "Function exists and is callable"
    elseif func then
        success = true
        details = "Property exists but is not a function"
    else
        success = false
        details = "Function not found"
    end
    
    -- Update results
    if success then
        testResults.passed = testResults.passed + 1
    else
        testResults.failed = testResults.failed + 1
    end
    testResults.total = testResults.total + 1
    
    -- Log to console
    if success then
        print("✅ " .. functionName .. " - " .. details)
    else
        print("❌ " .. functionName .. " - " .. details)
    end
    
    -- Add to GUI log
    addFunctionLog(functionName, success and "passed" or "failed", details)
    
    return success
end

-- Run SUNC test
local function runSUNCTest()
    if isTestingActive then return end
    
    isTestingActive = true
    startButton.Text = "Testing..."
    startButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    
    -- Reset results
    testResults = {passed = 0, timeout = 0, failed = 0, total = 0}
    functionLogs = {}
    timeElapsed = 0
    
    -- Clear logs
    for _, child in ipairs(logsContainer:GetChildren()) do
        if child.Name:find("LogEntry") then
            child:Destroy()
        end
    end
    
    -- Set up SUNC environment
    getgenv().sUNCDebug = {
        ["printcheckpoints"] = false,
        ["delaybetweentests"] = 0
    }
    
    print("🚀 Starting SUNC function compatibility test...")
    print("Testing " .. #functionsToTest .. " functions...")
    
    -- Start time counter
    local startTime = tick()
    local timeConnection
    timeConnection = RunService.Heartbeat:Connect(function()
        if isTestingActive then
            timeElapsed = tick() - startTime
            timeValue.Text = math.floor(timeElapsed) .. "s"
        else
            timeConnection:Disconnect()
        end
    end)
    
    -- Test functions with delay for animation
    spawn(function()
        for i, functionName in ipairs(functionsToTest) do
            if not isTestingActive then break end
            
            testFunction(functionName)
            updateProgress(i, #functionsToTest)
            updateStats()
            
            wait(0.1) -- Small delay for smooth animation
        end
        
        -- Test complete
        isTestingActive = false
        startButton.Text = "Start Test"
        startButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        
        print("🏁 SUNC test completed!")
        print("Results: " .. testResults.passed .. " passed, " .. testResults.failed .. " failed")
        
        -- Try to run actual SUNC script
        spawn(function()
            local success, result = pcall(function()
                return loadstring(game:HttpGet("https://script.sunc.su/"))()
            end)
            
            if success then
                print("✅ SUNC script executed successfully")
                addFunctionLog("SUNC Script", "passed", "Script executed successfully")
            else
                print("❌ SUNC script failed: " .. tostring(result))
                addFunctionLog("SUNC Script", "failed", "Script execution failed: " .. tostring(result))
            end
        end)
    end)
end

-- Time counter (separate from test timer)
local function startTimeCounter()
    local startTime = tick()
    RunService.Heartbeat:Connect(function()
        if not isTestingActive then
            local elapsed = tick() - startTime
            -- Only update if not testing (testing has its own timer)
        end
    end)
end

-- Dragging functionality
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    if dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                connection:Disconnect()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

-- Event connections
closeButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(mainFrame, TWEEN_INFO, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

startButton.MouseButton1Click:Connect(function()
    runSUNCTest()
end)

-- Add button animations
addButtonAnimations(closeButton, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 60, 60))
addButtonAnimations(startButton, Color3.fromRGB(100, 200, 255), Color3.fromRGB(120, 220, 255))

-- Search functionality
searchBox.FocusGained:Connect(function()
    local tween = TweenService:Create(searchContainer, HOVER_TWEEN, {
        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    })
    tween:Play()
end)

searchBox.FocusLost:Connect(function()
    local tween = TweenService:Create(searchContainer, HOVER_TWEEN, {
        BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    })
    tween:Play()
end)

-- Search filtering
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchTerm = searchBox.Text:lower()
    
    for _, child in ipairs(logsContainer:GetChildren()) do
        if child.Name:find("LogEntry") then
            local nameLabel = child:FindFirstChild("TextLabel")
            if nameLabel then
                local functionName = nameLabel.Text:lower()
                child.Visible = functionName:find(searchTerm) ~= nil or searchTerm == ""
            end
        end
    end
end)

-- Initialize
startTimeCounter()
updateStats()

-- Entrance animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

wait(0.1)

local entranceTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 700, 0, 450),
    Position = UDim2.new(0.5, -350, 0.5, -225)
})
entranceTween:Play()

print("🎯 SUNC Testing GUI loaded successfully!")
print("Click 'Start Test' to begin function compatibility testing")