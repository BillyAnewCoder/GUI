-- Modern GUI for Roblox - Improved Version
-- Features: Smaller size, draggable, smooth animations

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Animation settings
local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local HOVER_TWEEN = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local CLICK_TWEEN = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main frame (much smaller now)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 350) -- Reduced from 800x600
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Add corner radius and shadow effect
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Shadow frame for depth
local shadowFrame = Instance.new("Frame")
shadowFrame.Name = "Shadow"
shadowFrame.Size = UDim2.new(1, 6, 1, 6)
shadowFrame.Position = UDim2.new(0, -3, 0, -3)
shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame.BackgroundTransparency = 0.8
shadowFrame.BorderSizePixel = 0
shadowFrame.ZIndex = -1
shadowFrame.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 15)
shadowCorner.Parent = shadowFrame

-- Header (draggable area)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40) -- Reduced height
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Fix header corners (only top corners rounded)
local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Title with glow effect
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Modern GUI"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = header

-- Status indicator
local statusDot = Instance.new("Frame")
statusDot.Name = "StatusDot"
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(1, -80, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
statusDot.BorderSizePixel = 0
statusDot.Parent = header

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(0.5, 0)
dotCorner.Parent = statusDot

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0, 50, 1, 0)
statusText.Position = UDim2.new(1, -65, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Online"
statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
statusText.TextSize = 12
statusText.Font = Enum.Font.Gotham
statusText.Parent = header

-- Close button with hover animation
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -32, 0, 7.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 95, 95)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

-- Sidebar (smaller)
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 140, 1, -40) -- Reduced width
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

-- Content area
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -140, 1, -40)
contentArea.Position = UDim2.new(0, 140, 0, 40)
contentArea.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
contentArea.BorderSizePixel = 0
contentArea.Parent = mainFrame

-- Tab system
local tabs = {
    {name = "Home", icon = "🏠", color = Color3.fromRGB(100, 200, 255)},
    {name = "Scripts", icon = "📜", color = Color3.fromRGB(255, 200, 100)},
    {name = "Settings", icon = "⚙️", color = Color3.fromRGB(200, 100, 255)},
    {name = "About", icon = "ℹ️", color = Color3.fromRGB(100, 255, 200)}
}

local currentTab = "Home"
local tabButtons = {}

-- Create tab buttons with animations
for i, tab in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tab.name .. "Tab"
    tabButton.Size = UDim2.new(1, -10, 0, 35)
    tabButton.Position = UDim2.new(0, 5, 0, (i-1) * 40 + 10)
    tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabButton.Text = tab.icon .. " " .. tab.name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.TextSize = 14
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Font = Enum.Font.Gotham
    tabButton.BorderSizePixel = 0
    tabButton.Parent = sidebar
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabButton
    
    -- Add padding
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
    indicator.Parent = tabButton
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 2)
    indicatorCorner.Parent = indicator
    
    tabButtons[tab.name] = {button = tabButton, indicator = indicator, color = tab.color}
end

-- Content frames for each tab
local contentFrames = {}

for _, tab in ipairs(tabs) do
    local frame = Instance.new("ScrollingFrame")
    frame.Name = tab.name .. "Content"
    frame.Size = UDim2.new(1, -20, 1, -20)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    frame.CanvasSize = UDim2.new(0, 0, 0, 400)
    frame.Visible = (tab.name == currentTab)
    frame.Parent = contentArea
    contentFrames[tab.name] = frame
end

-- Home tab content
local homeTitle = Instance.new("TextLabel")
homeTitle.Size = UDim2.new(1, 0, 0, 30)
homeTitle.Position = UDim2.new(0, 0, 0, 0)
homeTitle.BackgroundTransparency = 1
homeTitle.Text = "Welcome Back!"
homeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
homeTitle.TextSize = 20
homeTitle.TextXAlignment = Enum.TextXAlignment.Left
homeTitle.Font = Enum.Font.GothamBold
homeTitle.Parent = contentFrames["Home"]

local homeDesc = Instance.new("TextLabel")
homeDesc.Size = UDim2.new(1, 0, 0, 40)
homeDesc.Position = UDim2.new(0, 0, 0, 35)
homeDesc.BackgroundTransparency = 1
homeDesc.Text = "Modern GUI with smooth animations\nand responsive design."
homeDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
homeDesc.TextSize = 12
homeDesc.TextXAlignment = Enum.TextXAlignment.Left
homeDesc.TextYAlignment = Enum.TextYAlignment.Top
homeDesc.Font = Enum.Font.Gotham
homeDesc.Parent = contentFrames["Home"]

-- Stats cards
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, 0, 0, 60)
statsFrame.Position = UDim2.new(0, 0, 0, 90)
statsFrame.BackgroundTransparency = 1
statsFrame.Parent = contentFrames["Home"]

for i = 1, 3 do
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.3, -5, 1, 0)
    card.Position = UDim2.new((i-1) * 0.33, 0, 0, 0)
    card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    card.BorderSizePixel = 0
    card.Parent = statsFrame
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card
    
    local cardTitle = Instance.new("TextLabel")
    cardTitle.Size = UDim2.new(1, -10, 0, 20)
    cardTitle.Position = UDim2.new(0, 5, 0, 5)
    cardTitle.BackgroundTransparency = 1
    cardTitle.Text = ({"Active", "Status", "Uptime"})[i]
    cardTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    cardTitle.TextSize = 10
    cardTitle.Font = Enum.Font.Gotham
    cardTitle.Parent = card
    
    local cardValue = Instance.new("TextLabel")
    cardValue.Size = UDim2.new(1, -10, 0, 25)
    cardValue.Position = UDim2.new(0, 5, 0, 25)
    cardValue.BackgroundTransparency = 1
    cardValue.Text = ({"1", "OK", "24h"})[i]
    cardValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    cardValue.TextSize = 16
    cardValue.Font = Enum.Font.GothamBold
    cardValue.Parent = card
end

-- Scripts tab content
local scriptsTitle = Instance.new("TextLabel")
scriptsTitle.Size = UDim2.new(1, 0, 0, 30)
scriptsTitle.Position = UDim2.new(0, 0, 0, 0)
scriptsTitle.BackgroundTransparency = 1
scriptsTitle.Text = "Script Library"
scriptsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptsTitle.TextSize = 20
scriptsTitle.TextXAlignment = Enum.TextXAlignment.Left
scriptsTitle.Font = Enum.Font.GothamBold
scriptsTitle.Parent = contentFrames["Scripts"]

-- Sample script buttons
local scriptButtons = {}
for i = 1, 3 do
    local scriptButton = Instance.new("TextButton")
    scriptButton.Size = UDim2.new(1, 0, 0, 35)
    scriptButton.Position = UDim2.new(0, 0, 0, 40 + (i-1) * 40)
    scriptButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    scriptButton.Text = "Sample Script " .. i
    scriptButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    scriptButton.TextSize = 14
    scriptButton.Font = Enum.Font.Gotham
    scriptButton.BorderSizePixel = 0
    scriptButton.Parent = contentFrames["Scripts"]
    
    local scriptCorner = Instance.new("UICorner")
    scriptCorner.CornerRadius = UDim.new(0, 8)
    scriptCorner.Parent = scriptButton
    
    table.insert(scriptButtons, scriptButton)
end

-- Settings and About content (simplified)
for _, tabName in ipairs({"Settings", "About"}) do
    local tabTitle = Instance.new("TextLabel")
    tabTitle.Size = UDim2.new(1, 0, 0, 30)
    tabTitle.Position = UDim2.new(0, 0, 0, 0)
    tabTitle.BackgroundTransparency = 1
    tabTitle.Text = tabName
    tabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabTitle.TextSize = 20
    tabTitle.TextXAlignment = Enum.TextXAlignment.Left
    tabTitle.Font = Enum.Font.GothamBold
    tabTitle.Parent = contentFrames[tabName]
    
    local tabDesc = Instance.new("TextLabel")
    tabDesc.Size = UDim2.new(1, 0, 0, 60)
    tabDesc.Position = UDim2.new(0, 0, 0, 40)
    tabDesc.BackgroundTransparency = 1
    tabDesc.Text = tabName == "Settings" and "Configure your preferences\nand application settings." or "Modern GUI Demo v2.0\nBuilt for Roblox with smooth animations\nand responsive design."
    tabDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabDesc.TextSize = 12
    tabDesc.TextXAlignment = Enum.TextXAlignment.Left
    tabDesc.TextYAlignment = Enum.TextYAlignment.Top
    tabDesc.Font = Enum.Font.Gotham
    tabDesc.Parent = contentFrames[tabName]
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

-- Animation functions
local function switchTab(tabName)
    -- Animate content transition
    for name, frame in pairs(contentFrames) do
        if name == tabName then
            frame.Visible = true
            frame.Position = UDim2.new(0, 20, 0, 10)
            local tween = TweenService:Create(frame, TWEEN_INFO, {Position = UDim2.new(0, 10, 0, 10)})
            tween:Play()
        else
            local tween = TweenService:Create(frame, TWEEN_INFO, {Position = UDim2.new(0, -20, 0, 10)})
            tween:Play()
            tween.Completed:Connect(function()
                frame.Visible = false
            end)
        end
    end
    
    -- Animate tab buttons
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
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
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
end

-- Add hover and click animations
local function addButtonAnimations(button, normalColor, hoverColor)
    local originalSize = button.Size
    
    button.MouseEnter:Connect(function()
        local colorTween = TweenService:Create(button, HOVER_TWEEN, {BackgroundColor3 = hoverColor})
        local sizeTween = TweenService:Create(button, HOVER_TWEEN, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, originalSize.Y.Scale, originalSize.Y.Offset + 2)})
        colorTween:Play()
        sizeTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local colorTween = TweenService:Create(button, HOVER_TWEEN, {BackgroundColor3 = normalColor})
        local sizeTween = TweenService:Create(button, HOVER_TWEEN, {Size = originalSize})
        colorTween:Play()
        sizeTween:Play()
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

-- Tab button connections
for tabName, tabData in pairs(tabButtons) do
    tabData.button.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
    addButtonAnimations(tabData.button, Color3.fromRGB(25, 25, 25), Color3.fromRGB(35, 35, 35))
end

-- Script button connections
for i, button in ipairs(scriptButtons) do
    button.MouseButton1Click:Connect(function()
        print("Sample Script " .. i .. " executed!")
        -- Add visual feedback
        local originalColor = button.BackgroundColor3
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 200, 100)})
        tween:Play()
        tween.Completed:Connect(function()
            local returnTween = TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = originalColor})
            returnTween:Play()
        end)
    end)
    addButtonAnimations(button, Color3.fromRGB(40, 40, 40), Color3.fromRGB(55, 55, 55))
end

-- Close button animations
addButtonAnimations(closeButton, Color3.fromRGB(255, 95, 95), Color3.fromRGB(255, 120, 120))

-- Status dot animation
local function animateStatusDot()
    local tween = TweenService:Create(statusDot, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundTransparency = 0.3
    })
    tween:Play()
end

-- Initialize
switchTab("Home")
animateStatusDot()

-- Entrance animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local entranceTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 500, 0, 350),
    Position = UDim2.new(0.5, -250, 0.5, -175)
})
entranceTween:Play()

print("Modern GUI v2.0 loaded successfully!")