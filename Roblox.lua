-- Modern GUI for Roblox - Enhanced Version
-- Features: No overlapping, smooth transitions, improved functionality

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
local CLICK_TWEEN = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TAB_TRANSITION = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- State management
local currentTab = "Home"
local isTransitioning = false
local logs = {}
local maxLogs = 20

-- Utility functions
local function addLog(message, logType)
    local timestamp = os.date("%H:%M:%S")
    table.insert(logs, 1, {
        message = message,
        type = logType or "info",
        timestamp = timestamp
    })
    
    -- Keep only recent logs
    if #logs > maxLogs then
        table.remove(logs, #logs)
    end
    
    -- Update log display if on home tab
    if currentTab == "Home" then
        updateLogDisplay()
    end
end

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 380)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 100
mainFrame.Parent = screenGui

-- Add corner radius and shadow
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Shadow frame
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

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 45)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0
header.ZIndex = 101
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Header bottom fix
local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
headerFix.BorderSizePixel = 0
headerFix.ZIndex = 101
headerFix.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0, 150, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "My GUI"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.ZIndex = 102
title.Parent = header

-- Status indicator - FIXED POSITIONING
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0, 80, 1, 0)
statusFrame.Position = UDim2.new(1, -200, 0, 0) -- Moved further left to avoid overlap
statusFrame.BackgroundTransparency = 1
statusFrame.ZIndex = 102
statusFrame.Parent = header

local statusDot = Instance.new("Frame")
statusDot.Name = "StatusDot"
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 0, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 103
statusDot.Parent = statusFrame

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(0.5, 0)
dotCorner.Parent = statusDot

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0, 60, 1, 0)
statusText.Position = UDim2.new(0, 15, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Connected"
statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
statusText.TextSize = 12
statusText.Font = Enum.Font.Gotham
statusText.ZIndex = 103
statusText.Parent = statusFrame

-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 28, 0, 28)
minimizeButton.Position = UDim2.new(1, -75, 0, 8.5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 16
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.BorderSizePixel = 0
minimizeButton.ZIndex = 102
minimizeButton.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0.5, 0)
minimizeCorner.Parent = minimizeButton

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -40, 0, 8.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 95, 95)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.ZIndex = 102
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 150, 1, -45)
sidebar.Position = UDim2.new(0, 0, 0, 45)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 101
sidebar.Parent = mainFrame

-- Content container
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -150, 1, -45)
contentContainer.Position = UDim2.new(0, 150, 0, 45)
contentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
contentContainer.BorderSizePixel = 0
contentContainer.ClipsDescendants = true
contentContainer.ZIndex = 101
contentContainer.Parent = mainFrame

-- Tab system - MORE HUMAN NAMES
local tabs = {
    {name = "Home", icon = "🏠", color = Color3.fromRGB(100, 200, 255)},
    {name = "Scripts", icon = "📜", color = Color3.fromRGB(255, 200, 100)},
    {name = "Executor", icon = "⚡", color = Color3.fromRGB(255, 100, 200)},
    {name = "Settings", icon = "⚙️", color = Color3.fromRGB(200, 100, 255)},
    {name = "About", icon = "ℹ️", color = Color3.fromRGB(100, 255, 200)}
}

local tabButtons = {}
local contentFrames = {}

-- Create tab buttons
for i, tab in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tab.name .. "Tab"
    tabButton.Size = UDim2.new(1, -10, 0, 38)
    tabButton.Position = UDim2.new(0, 5, 0, (i-1) * 42 + 10)
    tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabButton.Text = tab.icon .. " " .. tab.name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.TextSize = 14
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Font = Enum.Font.Gotham
    tabButton.BorderSizePixel = 0
    tabButton.ZIndex = 102
    tabButton.Parent = sidebar
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabButton
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.Parent = tabButton
    
    -- Selection indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 3, 0.7, 0)
    indicator.Position = UDim2.new(0, 0, 0.15, 0)
    indicator.BackgroundColor3 = tab.color
    indicator.BorderSizePixel = 0
    indicator.BackgroundTransparency = 1
    indicator.ZIndex = 103
    indicator.Parent = tabButton
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 2)
    indicatorCorner.Parent = indicator
    
    tabButtons[tab.name] = {
        button = tabButton, 
        indicator = indicator, 
        color = tab.color,
        originalColor = Color3.fromRGB(25, 25, 25)
    }
end

-- Create content frames
for _, tab in ipairs(tabs) do
    local frame = Instance.new("ScrollingFrame")
    frame.Name = tab.name .. "Content"
    frame.Size = UDim2.new(1, -20, 1, -20)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 6
    frame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    frame.ScrollBarImageTransparency = 0.5
    frame.CanvasSize = UDim2.new(0, 0, 0, 500)
    frame.ScrollingDirection = Enum.ScrollingDirection.Y
    frame.Visible = false
    frame.ZIndex = 102
    frame.Parent = contentContainer
    contentFrames[tab.name] = frame
end

-- Home tab content - MORE HUMAN TEXT
local function createHomeContent()
    local homeFrame = contentFrames["Home"]
    
    local homeTitle = Instance.new("TextLabel")
    homeTitle.Size = UDim2.new(1, 0, 0, 35)
    homeTitle.Position = UDim2.new(0, 0, 0, 0)
    homeTitle.BackgroundTransparency = 1
    homeTitle.Text = "Hey there!"
    homeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    homeTitle.TextSize = 22
    homeTitle.TextXAlignment = Enum.TextXAlignment.Left
    homeTitle.Font = Enum.Font.GothamBold
    homeTitle.ZIndex = 103
    homeTitle.Parent = homeFrame
    
    local homeDesc = Instance.new("TextLabel")
    homeDesc.Size = UDim2.new(1, 0, 0, 50)
    homeDesc.Position = UDim2.new(0, 0, 0, 40)
    homeDesc.BackgroundTransparency = 1
    homeDesc.Text = "Everything's running smoothly.\nFeel free to explore the different tabs!"
    homeDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
    homeDesc.TextSize = 13
    homeDesc.TextXAlignment = Enum.TextXAlignment.Left
    homeDesc.TextYAlignment = Enum.TextYAlignment.Top
    homeDesc.Font = Enum.Font.Gotham
    homeDesc.ZIndex = 103
    homeDesc.Parent = homeFrame
    
    -- Stats cards
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, 0, 0, 70)
    statsFrame.Position = UDim2.new(0, 0, 0, 100)
    statsFrame.BackgroundTransparency = 1
    statsFrame.ZIndex = 103
    statsFrame.Parent = homeFrame
    
    local statsData = {
        {title = "Sessions", value = "1", color = Color3.fromRGB(100, 200, 255)},
        {title = "Status", value = "Good", color = Color3.fromRGB(50, 200, 50)},
        {title = "Runtime", value = "2h", color = Color3.fromRGB(255, 200, 100)}
    }
    
    for i, stat in ipairs(statsData) do
        local card = Instance.new("Frame")
        card.Size = UDim2.new(0.31, 0, 1, 0)
        card.Position = UDim2.new((i-1) * 0.345, 0, 0, 0)
        card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        card.BorderSizePixel = 0
        card.ZIndex = 103
        card.Parent = statsFrame
        
        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 8)
        cardCorner.Parent = card
        
        local cardTitle = Instance.new("TextLabel")
        cardTitle.Size = UDim2.new(1, -10, 0, 20)
        cardTitle.Position = UDim2.new(0, 5, 0, 8)
        cardTitle.BackgroundTransparency = 1
        cardTitle.Text = stat.title
        cardTitle.TextColor3 = stat.color
        cardTitle.TextSize = 11
        cardTitle.Font = Enum.Font.Gotham
        cardTitle.ZIndex = 104
        cardTitle.Parent = card
        
        local cardValue = Instance.new("TextLabel")
        cardValue.Size = UDim2.new(1, -10, 0, 30)
        cardValue.Position = UDim2.new(0, 5, 0, 30)
        cardValue.BackgroundTransparency = 1
        cardValue.Text = stat.value
        cardValue.TextColor3 = Color3.fromRGB(255, 255, 255)
        cardValue.TextSize = 18
        cardValue.Font = Enum.Font.GothamBold
        cardValue.ZIndex = 104
        cardValue.Parent = card
    end
    
    -- Activity log
    local logTitle = Instance.new("TextLabel")
    logTitle.Size = UDim2.new(1, 0, 0, 25)
    logTitle.Position = UDim2.new(0, 0, 0, 185)
    logTitle.BackgroundTransparency = 1
    logTitle.Text = "What's been happening"
    logTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    logTitle.TextSize = 16
    logTitle.TextXAlignment = Enum.TextXAlignment.Left
    logTitle.Font = Enum.Font.GothamBold
    logTitle.ZIndex = 103
    logTitle.Parent = homeFrame
    
    local logContainer = Instance.new("Frame")
    logContainer.Name = "LogContainer"
    logContainer.Size = UDim2.new(1, 0, 0, 200)
    logContainer.Position = UDim2.new(0, 0, 0, 215)
    logContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    logContainer.BorderSizePixel = 0
    logContainer.ZIndex = 103
    logContainer.Parent = homeFrame
    
    local logCorner = Instance.new("UICorner")
    logCorner.CornerRadius = UDim.new(0, 8)
    logCorner.Parent = logContainer
    
    local logScrollFrame = Instance.new("ScrollingFrame")
    logScrollFrame.Name = "LogScrollFrame"
    logScrollFrame.Size = UDim2.new(1, -10, 1, -10)
    logScrollFrame.Position = UDim2.new(0, 5, 0, 5)
    logScrollFrame.BackgroundTransparency = 1
    logScrollFrame.BorderSizePixel = 0
    logScrollFrame.ScrollBarThickness = 4
    logScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    logScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    logScrollFrame.ZIndex = 104
    logScrollFrame.Parent = logContainer
end

-- Scripts tab content - MORE HUMAN DESCRIPTIONS
local function createScriptsContent()
    local scriptsFrame = contentFrames["Scripts"]
    
    local scriptsTitle = Instance.new("TextLabel")
    scriptsTitle.Size = UDim2.new(1, 0, 0, 35)
    scriptsTitle.Position = UDim2.new(0, 0, 0, 0)
    scriptsTitle.BackgroundTransparency = 1
    scriptsTitle.Text = "Ready-made Scripts"
    scriptsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptsTitle.TextSize = 22
    scriptsTitle.TextXAlignment = Enum.TextXAlignment.Left
    scriptsTitle.Font = Enum.Font.GothamBold
    scriptsTitle.ZIndex = 103
    scriptsTitle.Parent = scriptsFrame
    
    local scriptsDesc = Instance.new("TextLabel")
    scriptsDesc.Size = UDim2.new(1, 0, 0, 25)
    scriptsDesc.Position = UDim2.new(0, 0, 0, 40)
    scriptsDesc.BackgroundTransparency = 1
    scriptsDesc.Text = "Some useful scripts I've put together"
    scriptsDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
    scriptsDesc.TextSize = 13
    scriptsDesc.TextXAlignment = Enum.TextXAlignment.Left
    scriptsDesc.Font = Enum.Font.Gotham
    scriptsDesc.ZIndex = 103
    scriptsDesc.Parent = scriptsFrame
    
    -- Script buttons - MORE HUMAN NAMES
    local scriptData = {
        {name = "Speed Boost", desc = "Makes you run faster", color = Color3.fromRGB(100, 200, 255)},
        {name = "Jump Higher", desc = "Increases your jump power", color = Color3.fromRGB(255, 200, 100)},
        {name = "Fly Around", desc = "Let's you fly in the game", color = Color3.fromRGB(200, 100, 255)},
        {name = "Quick Travel", desc = "Teleport to different spots", color = Color3.fromRGB(100, 255, 200)},
        {name = "God Mode", desc = "Makes you invincible", color = Color3.fromRGB(255, 100, 100)}
    }
    
    for i, script in ipairs(scriptData) do
        local scriptButton = Instance.new("TextButton")
        scriptButton.Size = UDim2.new(1, 0, 0, 45)
        scriptButton.Position = UDim2.new(0, 0, 0, 75 + (i-1) * 50)
        scriptButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        scriptButton.Text = ""
        scriptButton.BorderSizePixel = 0
        scriptButton.ZIndex = 103
        scriptButton.Parent = scriptsFrame
        
        local scriptCorner = Instance.new("UICorner")
        scriptCorner.CornerRadius = UDim.new(0, 8)
        scriptCorner.Parent = scriptButton
        
        local scriptName = Instance.new("TextLabel")
        scriptName.Size = UDim2.new(1, -60, 0, 20)
        scriptName.Position = UDim2.new(0, 15, 0, 8)
        scriptName.BackgroundTransparency = 1
        scriptName.Text = script.name
        scriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
        scriptName.TextSize = 14
        scriptName.TextXAlignment = Enum.TextXAlignment.Left
        scriptName.Font = Enum.Font.GothamBold
        scriptName.ZIndex = 104
        scriptName.Parent = scriptButton
        
        local scriptDesc = Instance.new("TextLabel")
        scriptDesc.Size = UDim2.new(1, -60, 0, 15)
        scriptDesc.Position = UDim2.new(0, 15, 0, 25)
        scriptDesc.BackgroundTransparency = 1
        scriptDesc.Text = script.desc
        scriptDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
        scriptDesc.TextSize = 11
        scriptDesc.TextXAlignment = Enum.TextXAlignment.Left
        scriptDesc.Font = Enum.Font.Gotham
        scriptDesc.ZIndex = 104
        scriptDesc.Parent = scriptButton
        
        local executeButton = Instance.new("TextButton")
        executeButton.Size = UDim2.new(0, 50, 0, 25)
        executeButton.Position = UDim2.new(1, -60, 0.5, -12.5)
        executeButton.BackgroundColor3 = script.color
        executeButton.Text = "Run"
        executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        executeButton.TextSize = 12
        executeButton.Font = Enum.Font.GothamBold
        executeButton.BorderSizePixel = 0
        executeButton.ZIndex = 104
        executeButton.Parent = scriptButton
        
        local executeCorner = Instance.new("UICorner")
        executeCorner.CornerRadius = UDim.new(0, 6)
        executeCorner.Parent = executeButton
        
        -- Add functionality
        executeButton.MouseButton1Click:Connect(function()
            addLog("Ran " .. script.name, "success")
            
            -- Visual feedback
            local originalColor = executeButton.BackgroundColor3
            local tween = TweenService:Create(executeButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
            tween:Play()
            tween.Completed:Connect(function()
                local returnTween = TweenService:Create(executeButton, TweenInfo.new(0.3), {BackgroundColor3 = originalColor})
                returnTween:Play()
            end)
        end)
        
        addButtonAnimations(executeButton, script.color, Color3.new(script.color.R + 0.1, script.color.G + 0.1, script.color.B + 0.1))
        addButtonAnimations(scriptButton, Color3.fromRGB(40, 40, 40), Color3.fromRGB(50, 50, 50))
    end
end

-- Executor tab content - IMPROVED VERSION
local function createExecutorContent()
    local executorFrame = contentFrames["Executor"]
    
    local executorTitle = Instance.new("TextLabel")
    executorTitle.Size = UDim2.new(1, 0, 0, 35)
    executorTitle.Position = UDim2.new(0, 0, 0, 0)
    executorTitle.BackgroundTransparency = 1
    executorTitle.Text = "Code Runner"
    executorTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    executorTitle.TextSize = 22
    executorTitle.TextXAlignment = Enum.TextXAlignment.Left
    executorTitle.Font = Enum.Font.GothamBold
    executorTitle.ZIndex = 103
    executorTitle.Parent = executorFrame
    
    -- Code editor container
    local editorContainer = Instance.new("Frame")
    editorContainer.Size = UDim2.new(1, 0, 0, 180)
    editorContainer.Position = UDim2.new(0, 0, 0, 50)
    editorContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    editorContainer.BorderSizePixel = 0
    editorContainer.ZIndex = 103
    editorContainer.Parent = executorFrame
    
    local editorCorner = Instance.new("UICorner")
    editorCorner.CornerRadius = UDim.new(0, 8)
    editorCorner.Parent = editorContainer
    
    -- Line numbers frame
    local lineNumberFrame = Instance.new("Frame")
    lineNumberFrame.Size = UDim2.new(0, 30, 1, 0)
    lineNumberFrame.Position = UDim2.new(0, 0, 0, 0)
    lineNumberFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    lineNumberFrame.BorderSizePixel = 0
    lineNumberFrame.ZIndex = 104
    lineNumberFrame.Parent = editorContainer
    
    local lineCorner = Instance.new("UICorner")
    lineCorner.CornerRadius = UDim.new(0, 8)
    lineCorner.Parent = lineNumberFrame
    
    -- Line numbers text
    local lineNumbers = Instance.new("TextLabel")
    lineNumbers.Name = "LineNumbers"
    lineNumbers.Size = UDim2.new(1, -5, 1, -10)
    lineNumbers.Position = UDim2.new(0, 0, 0, 5)
    lineNumbers.BackgroundTransparency = 1
    lineNumbers.Text = "1\n2\n3\n4\n5\n6\n7\n8\n9"
    lineNumbers.TextColor3 = Color3.fromRGB(100, 100, 100)
    lineNumbers.TextSize = 12
    lineNumbers.Font = Enum.Font.Code
    lineNumbers.TextXAlignment = Enum.TextXAlignment.Center
    lineNumbers.TextYAlignment = Enum.TextYAlignment.Top
    lineNumbers.ZIndex = 105
    lineNumbers.Parent = lineNumberFrame
    
    -- Code input box
    local codeBox = Instance.new("TextBox")
    codeBox.Name = "CodeBox"
    codeBox.Size = UDim2.new(1, -40, 1, -10)
    codeBox.Position = UDim2.new(0, 35, 0, 5)
    codeBox.BackgroundTransparency = 1
    codeBox.Text = "-- Write your code here\nprint('Hello there!')\nwait(1)\nprint('Code ran successfully!')"
    codeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    codeBox.TextSize = 12
    codeBox.Font = Enum.Font.Code
    codeBox.TextXAlignment = Enum.TextXAlignment.Left
    codeBox.TextYAlignment = Enum.TextYAlignment.Top
    codeBox.MultiLine = true
    codeBox.ClearTextOnFocus = false
    codeBox.BorderSizePixel = 0
    codeBox.ZIndex = 104
    codeBox.Parent = editorContainer
    
    -- Update line numbers when text changes
    local function updateLineNumbers()
        local lines = {}
        local lineCount = 1
        for _ in codeBox.Text:gmatch("\n") do
            lineCount = lineCount + 1
        end
        
        for i = 1, math.max(lineCount, 9) do
            table.insert(lines, tostring(i))
        end
        
        lineNumbers.Text = table.concat(lines, "\n")
    end
    
    codeBox:GetPropertyChangedSignal("Text"):Connect(updateLineNumbers)
    
    -- Status display
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 25)
    statusFrame.Position = UDim2.new(0, 0, 0, 240)
    statusFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    statusFrame.BorderSizePixel = 0
    statusFrame.ZIndex = 103
    statusFrame.Parent = executorFrame
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusFrame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -10, 1, 0)
    statusLabel.Position = UDim2.new(0, 5, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Ready to run your code"
    statusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    statusLabel.TextSize = 11
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.ZIndex = 104
    statusLabel.Parent = statusFrame
    
    -- Button container
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, 0, 0, 35)
    buttonContainer.Position = UDim2.new(0, 0, 0, 275)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.ZIndex = 103
    buttonContainer.Parent = executorFrame
    
    -- Execute button
    local executeButton = Instance.new("TextButton")
    executeButton.Size = UDim2.new(0, 100, 1, 0)
    executeButton.Position = UDim2.new(0, 0, 0, 0)
    executeButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    executeButton.Text = "▶ Run Code"
    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeButton.TextSize = 14
    executeButton.Font = Enum.Font.GothamBold
    executeButton.BorderSizePixel = 0
    executeButton.ZIndex = 104
    executeButton.Parent = buttonContainer
    
    local executeCorner = Instance.new("UICorner")
    executeCorner.CornerRadius = UDim.new(0, 8)
    executeCorner.Parent = executeButton
    
    -- Clear button
    local clearButton = Instance.new("TextButton")
    clearButton.Size = UDim2.new(0, 80, 1, 0)
    clearButton.Position = UDim2.new(0, 110, 0, 0)
    clearButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    clearButton.Text = "Clear"
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.TextSize = 14
    clearButton.Font = Enum.Font.GothamBold
    clearButton.BorderSizePixel = 0
    clearButton.ZIndex = 104
    clearButton.Parent = buttonContainer
    
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 8)
    clearCorner.Parent = clearButton
    
    -- Save button
    local saveButton = Instance.new("TextButton")
    saveButton.Size = UDim2.new(0, 70, 1, 0)
    saveButton.Position = UDim2.new(0, 200, 0, 0)
    saveButton.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    saveButton.Text = "Save"
    saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    saveButton.TextSize = 14
    saveButton.Font = Enum.Font.GothamBold
    saveButton.BorderSizePixel = 0
    saveButton.ZIndex = 104
    saveButton.Parent = buttonContainer
    
    local saveCorner = Instance.new("UICorner")
    saveCorner.CornerRadius = UDim.new(0, 8)
    saveCorner.Parent = saveButton
    
    -- Load button
    local loadButton = Instance.new("TextButton")
    loadButton.Size = UDim2.new(0, 70, 1, 0)
    loadButton.Position = UDim2.new(0, 280, 0, 0)
    loadButton.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
    loadButton.Text = "Load"
    loadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadButton.TextSize = 14
    loadButton.Font = Enum.Font.GothamBold
    loadButton.BorderSizePixel = 0
    loadButton.ZIndex = 104
    loadButton.Parent = buttonContainer
    
    local loadCorner = Instance.new("UICorner")
    loadCorner.CornerRadius = UDim.new(0, 8)
    loadCorner.Parent = loadButton
    
    -- Script storage
    local savedScript = ""
    
    -- Button functionality
    executeButton.MouseButton1Click:Connect(function()
        local code = codeBox.Text
        if code and code ~= "" and code ~= "-- Write your code here" then
            statusLabel.Text = "Running your code..."
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            
            -- Execute the code safely
            local success, result = pcall(function()
                return loadstring(code)()
            end)
            
            if success then
                statusLabel.Text = "Code ran perfectly!"
                statusLabel.TextColor3 = Color3.fromRGB(50, 200, 50)
                addLog("Code executed successfully", "success")
            else
                statusLabel.Text = "Oops: " .. tostring(result)
                statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                addLog("Code error: " .. tostring(result), "error")
            end
            
            -- Reset status after 3 seconds
            wait(3)
            statusLabel.Text = "Ready to run your code"
            statusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        else
            statusLabel.Text = "Nothing to run"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            addLog("No code to execute", "warning")
        end
    end)
    
    clearButton.MouseButton1Click:Connect(function()
        codeBox.Text = "-- Write your code here\n"
        statusLabel.Text = "Editor cleared"
        statusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        addLog("Code editor cleared", "info")
        updateLineNumbers()
    end)
    
    saveButton.MouseButton1Click:Connect(function()
        savedScript = codeBox.Text
        statusLabel.Text = "Code saved!"
        statusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        addLog("Script saved", "success")
    end)
    
    loadButton.MouseButton1Click:Connect(function()
        if savedScript ~= "" then
            codeBox.Text = savedScript
            statusLabel.Text = "Code loaded!"
            statusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            addLog("Script loaded", "success")
            updateLineNumbers()
        else
            statusLabel.Text = "Nothing saved yet"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            addLog("No saved script found", "warning")
        end
    end)
    
    -- Add button animations
    addButtonAnimations(executeButton, Color3.fromRGB(50, 200, 50), Color3.fromRGB(70, 220, 70))
    addButtonAnimations(clearButton, Color3.fromRGB(100, 100, 100), Color3.fromRGB(120, 120, 120))
    addButtonAnimations(saveButton, Color3.fromRGB(255, 200, 100), Color3.fromRGB(255, 220, 120))
    addButtonAnimations(loadButton, Color3.fromRGB(200, 100, 255), Color3.fromRGB(220, 120, 255))
    
    -- Initialize line numbers
    updateLineNumbers()
end

-- Settings and About content - MORE HUMAN TEXT
local function createSettingsContent()
    local settingsFrame = contentFrames["Settings"]
    
    local settingsTitle = Instance.new("TextLabel")
    settingsTitle.Size = UDim2.new(1, 0, 0, 35)
    settingsTitle.Position = UDim2.new(0, 0, 0, 0)
    settingsTitle.BackgroundTransparency = 1
    settingsTitle.Text = "Preferences"
    settingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsTitle.TextSize = 22
    settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
    settingsTitle.Font = Enum.Font.GothamBold
    settingsTitle.ZIndex = 103
    settingsTitle.Parent = settingsFrame
    
    local settingsOptions = {
        "🎨 Theme: Dark (looks better)",
        "🔊 Sounds: On",
        "📱 Auto-save: Enabled",
        "🔒 Safe mode: Always on",
        "⚡ Smooth animations: Yes"
    }
    
    for i, option in ipairs(settingsOptions) do
        local optionLabel = Instance.new("TextLabel")
        optionLabel.Size = UDim2.new(1, 0, 0, 30)
        optionLabel.Position = UDim2.new(0, 0, 0, 50 + (i-1) * 35)
        optionLabel.BackgroundTransparency = 1
        optionLabel.Text = option
        optionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        optionLabel.TextSize = 14
        optionLabel.TextXAlignment = Enum.TextXAlignment.Left
        optionLabel.Font = Enum.Font.Gotham
        optionLabel.ZIndex = 103
        optionLabel.Parent = settingsFrame
    end
end

local function createAboutContent()
    local aboutFrame = contentFrames["About"]
    
    local aboutTitle = Instance.new("TextLabel")
    aboutTitle.Size = UDim2.new(1, 0, 0, 35)
    aboutTitle.Position = UDim2.new(0, 0, 0, 0)
    aboutTitle.BackgroundTransparency = 1
    aboutTitle.Text = "About This GUI"
    aboutTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    aboutTitle.TextSize = 22
    aboutTitle.TextXAlignment = Enum.TextXAlignment.Left
    aboutTitle.Font = Enum.Font.GothamBold
    aboutTitle.ZIndex = 103
    aboutTitle.Parent = aboutFrame
    
    local aboutInfo = {
        "My GUI v2.1",
        "Made for Roblox using Lua",
        "",
        "What it does:",
        "• Smooth animations that feel nice",
        "• No annoying overlaps",
        "• You can drag it around",
        "• Run your own code",
        "• Keep track of what's happening",
        "• Clean, simple design"
    }
    
    for i, info in ipairs(aboutInfo) do
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Size = UDim2.new(1, 0, 0, 25)
        infoLabel.Position = UDim2.new(0, 0, 0, 50 + (i-1) * 25)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Text = info
        infoLabel.TextColor3 = info:find("•") and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(200, 200, 200)
        infoLabel.TextSize = info == "" and 5 or (info:find("My GUI") and 16 or 13)
        infoLabel.TextXAlignment = Enum.TextXAlignment.Left
        infoLabel.Font = info:find("My GUI") and Enum.Font.GothamBold or Enum.Font.Gotham
        infoLabel.ZIndex = 103
        infoLabel.Parent = aboutFrame
    end
end

-- Animation functions
function addButtonAnimations(button, normalColor, hoverColor)
    local originalSize = button.Size
    local isHovered = false
    
    button.MouseEnter:Connect(function()
        if not isHovered then
            isHovered = true
            local colorTween = TweenService:Create(button, HOVER_TWEEN, {BackgroundColor3 = hoverColor})
            local sizeTween = TweenService:Create(button, HOVER_TWEEN, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, originalSize.Y.Scale, originalSize.Y.Offset + 2)})
            colorTween:Play()
            sizeTween:Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if isHovered then
            isHovered = false
            local colorTween = TweenService:Create(button, HOVER_TWEEN, {BackgroundColor3 = normalColor})
            local sizeTween = TweenService:Create(button, HOVER_TWEEN, {Size = originalSize})
            colorTween:Play()
            sizeTween:Play()
        end
    end)
    
    button.MouseButton1Down:Connect(function()
        local tween = TweenService:Create(button, CLICK_TWEEN, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 4, originalSize.Y.Scale, originalSize.Y.Offset - 2)})
        tween:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        local tween = TweenService:Create(button, CLICK_TWEEN, {Size = originalSize})
        tween:Play()
    end)
end

-- Tab switching with no overlap
local function switchTab(tabName)
    if isTransitioning or currentTab == tabName then return end
    
    isTransitioning = true
    local oldFrame = contentFrames[currentTab]
    local newFrame = contentFrames[tabName]
    
    -- Hide old content first
    if oldFrame then
        local hideOldTween = TweenService:Create(oldFrame, TAB_TRANSITION, {
            Position = UDim2.new(-1, 10, 0, 10),
            BackgroundTransparency = 1
        })
        hideOldTween:Play()
        
        hideOldTween.Completed:Connect(function()
            oldFrame.Visible = false
            oldFrame.Position = UDim2.new(0, 10, 0, 10)
            oldFrame.BackgroundTransparency = 0
            
            -- Show new content
            newFrame.Visible = true
            newFrame.Position = UDim2.new(1, 10, 0, 10)
            
            local showNewTween = TweenService:Create(newFrame, TAB_TRANSITION, {
                Position = UDim2.new(0, 10, 0, 10)
            })
            showNewTween:Play()
            
            showNewTween.Completed:Connect(function()
                isTransitioning = false
            end)
        end)
    else
        -- First time showing
        newFrame.Visible = true
        isTransitioning = false
    end
    
    -- Update tab buttons
    for name, tabData in pairs(tabButtons) do
        if name == tabName then
            local buttonTween = TweenService:Create(tabData.button, TWEEN_INFO, {
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            })
            local indicatorTween = TweenService:Create(tabData.indicator, TWEEN_INFO, {
                BackgroundTransparency = 0
            })
            buttonTween:Play()
            indicatorTween:Play()
        else
            local buttonTween = TweenService:Create(tabData.button, TWEEN_INFO, {
                BackgroundColor3 = tabData.originalColor,
                TextColor3 = Color3.fromRGB(200, 200, 200)
            })
            local indicatorTween = TweenService:Create(tabData.indicator, TWEEN_INFO, {
                BackgroundTransparency = 1
            })
            buttonTween:Play()
            indicatorTween:Play()
        end
    end
    
    currentTab = tabName
    addLog("Switched to " .. tabName, "info")
end

-- Update log display
function updateLogDisplay()
    local homeFrame = contentFrames["Home"]
    if not homeFrame then return end
    
    local logScrollFrame = homeFrame:FindFirstChild("LogContainer")
    if logScrollFrame then
        logScrollFrame = logScrollFrame:FindFirstChild("LogScrollFrame")
        if logScrollFrame then
            -- Clear existing logs
            for _, child in ipairs(logScrollFrame:GetChildren()) do
                if child:IsA("TextLabel") then
                    child:Destroy()
                end
            end
            
            -- Add new logs
            for i, log in ipairs(logs) do
                local logLabel = Instance.new("TextLabel")
                logLabel.Size = UDim2.new(1, -10, 0, 20)
                logLabel.Position = UDim2.new(0, 5, 0, (i-1) * 22)
                logLabel.BackgroundTransparency = 1
                logLabel.Text = "[" .. log.timestamp .. "] " .. log.message
                logLabel.TextColor3 = log.type == "success" and Color3.fromRGB(100, 255, 100) or 
                                   log.type == "error" and Color3.fromRGB(255, 100, 100) or 
                                   Color3.fromRGB(200, 200, 200)
                logLabel.TextSize = 11
                logLabel.TextXAlignment = Enum.TextXAlignment.Left
                logLabel.Font = Enum.Font.Code
                logLabel.ZIndex = 105
                logLabel.Parent = logScrollFrame
            end
            
            logScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #logs * 22)
        end
    end
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

header.InputBegan:Connect(function(input)
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

-- Minimize functionality
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        local tween = TweenService:Create(mainFrame, TWEEN_INFO, {
            Size = UDim2.new(0, 520, 0, 45)
        })
        tween:Play()
        minimizeButton.Text = "+"
    else
        local tween = TweenService:Create(mainFrame, TWEEN_INFO, {
            Size = UDim2.new(0, 520, 0, 380)
        })
        tween:Play()
        minimizeButton.Text = "−"
    end
end)

-- Tab button connections
for tabName, tabData in pairs(tabButtons) do
    tabData.button.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
    addButtonAnimations(tabData.button, tabData.originalColor, Color3.fromRGB(35, 35, 35))
end

-- Button animations for header buttons
addButtonAnimations(closeButton, Color3.fromRGB(255, 95, 95), Color3.fromRGB(255, 120, 120))
addButtonAnimations(minimizeButton, Color3.fromRGB(255, 200, 50), Color3.fromRGB(255, 220, 80))

-- Status dot animation
local function animateStatusDot()
    local tween = TweenService:Create(statusDot, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundTransparency = 0.3
    })
    tween:Play()
end

-- Initialize content
createHomeContent()
createScriptsContent()
createExecutorContent()
createSettingsContent()
createAboutContent()

-- Initialize
switchTab("Home")
animateStatusDot()

-- Add initial logs - MORE HUMAN
addLog("GUI started up", "success")
addLog("Everything looks good", "info")
addLog("Welcome! Feel free to look around", "info")

-- Entrance animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

wait(0.1)

local entranceTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 520, 0, 380),
    Position = UDim2.new(0.5, -260, 0.5, -190)
})
entranceTween:Play()

print("My GUI v2.1 loaded - No overlaps, smooth experience!")