-- Modern GUI for Roblox
-- This is a complete rewrite using Roblox GUI components

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernGUI"
screenGui.Parent = playerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 800, 0, 600)
mainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add corner radius
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Modern GUI Demo"
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.SourceSans
title.Parent = header

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(230, 230, 230)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.SourceSans
closeButton.BorderSizePixel = 0
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 200, 1, -50)
sidebar.Position = UDim2.new(0, 0, 0, 50)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

-- Content area
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -200, 1, -50)
contentArea.Position = UDim2.new(0, 200, 0, 50)
contentArea.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
contentArea.BorderSizePixel = 0
contentArea.Parent = mainFrame

-- Tab system
local tabs = {
    {name = "Home", icon = "🏠"},
    {name = "Scripts", icon = "📜"},
    {name = "Settings", icon = "⚙️"},
    {name = "About", icon = "ℹ️"}
}

local currentTab = "Home"
local tabButtons = {}

-- Create tab buttons
for i, tab in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tab.name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.Position = UDim2.new(0, 0, 0, (i-1) * 50 + 20)
    tabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tabButton.Text = tab.icon .. " " .. tab.name
    tabButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    tabButton.TextSize = 16
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Font = Enum.Font.SourceSans
    tabButton.BorderSizePixel = 0
    tabButton.Parent = sidebar
    
    -- Add padding
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.Parent = tabButton
    
    tabButtons[tab.name] = tabButton
end

-- Content frames for each tab
local contentFrames = {}

for _, tab in ipairs(tabs) do
    local frame = Instance.new("Frame")
    frame.Name = tab.name .. "Content"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = (tab.name == currentTab)
    frame.Parent = contentArea
    contentFrames[tab.name] = frame
end

-- Home tab content
local homeTitle = Instance.new("TextLabel")
homeTitle.Size = UDim2.new(1, -40, 0, 40)
homeTitle.Position = UDim2.new(0, 20, 0, 20)
homeTitle.BackgroundTransparency = 1
homeTitle.Text = "Welcome to Modern GUI Demo"
homeTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
homeTitle.TextSize = 24
homeTitle.TextXAlignment = Enum.TextXAlignment.Left
homeTitle.Font = Enum.Font.SourceSansBold
homeTitle.Parent = contentFrames["Home"]

local homeDesc = Instance.new("TextLabel")
homeDesc.Size = UDim2.new(1, -40, 0, 30)
homeDesc.Position = UDim2.new(0, 20, 0, 70)
homeDesc.BackgroundTransparency = 1
homeDesc.Text = "This is an educational example of GUI development in Roblox"
homeDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
homeDesc.TextSize = 16
homeDesc.TextXAlignment = Enum.TextXAlignment.Left
homeDesc.Font = Enum.Font.SourceSans
homeDesc.Parent = contentFrames["Home"]

-- Scripts tab content
local scriptsTitle = Instance.new("TextLabel")
scriptsTitle.Size = UDim2.new(1, -40, 0, 40)
scriptsTitle.Position = UDim2.new(0, 20, 0, 20)
scriptsTitle.BackgroundTransparency = 1
scriptsTitle.Text = "Scripts Library"
scriptsTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
scriptsTitle.TextSize = 24
scriptsTitle.TextXAlignment = Enum.TextXAlignment.Left
scriptsTitle.Font = Enum.Font.SourceSansBold
scriptsTitle.Parent = contentFrames["Scripts"]

-- Sample script button
local scriptButton = Instance.new("TextButton")
scriptButton.Size = UDim2.new(0, 200, 0, 40)
scriptButton.Position = UDim2.new(0, 20, 0, 100)
scriptButton.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
scriptButton.Text = "Sample Script"
scriptButton.TextColor3 = Color3.fromRGB(230, 230, 230)
scriptButton.TextSize = 16
scriptButton.Font = Enum.Font.SourceSans
scriptButton.BorderSizePixel = 0
scriptButton.Parent = contentFrames["Scripts"]

local scriptCorner = Instance.new("UICorner")
scriptCorner.CornerRadius = UDim.new(0, 8)
scriptCorner.Parent = scriptButton

-- Settings tab content
local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, -40, 0, 40)
settingsTitle.Position = UDim2.new(0, 20, 0, 20)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "Settings"
settingsTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
settingsTitle.TextSize = 24
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.Font = Enum.Font.SourceSansBold
settingsTitle.Parent = contentFrames["Settings"]

-- About tab content
local aboutTitle = Instance.new("TextLabel")
aboutTitle.Size = UDim2.new(1, -40, 0, 40)
aboutTitle.Position = UDim2.new(0, 20, 0, 20)
aboutTitle.BackgroundTransparency = 1
aboutTitle.Text = "About"
aboutTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
aboutTitle.TextSize = 24
aboutTitle.TextXAlignment = Enum.TextXAlignment.Left
aboutTitle.Font = Enum.Font.SourceSansBold
aboutTitle.Parent = contentFrames["About"]

local aboutDesc = Instance.new("TextLabel")
aboutDesc.Size = UDim2.new(1, -40, 0, 100)
aboutDesc.Position = UDim2.new(0, 20, 0, 70)
aboutDesc.BackgroundTransparency = 1
aboutDesc.Text = "Modern GUI Demo v1.0.0\n\nBuilt for Roblox\nEducational GUI development example"
aboutDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
aboutDesc.TextSize = 16
aboutDesc.TextXAlignment = Enum.TextXAlignment.Left
aboutDesc.TextYAlignment = Enum.TextYAlignment.Top
aboutDesc.Font = Enum.Font.SourceSans
aboutDesc.Parent = contentFrames["About"]

-- Functions
local function switchTab(tabName)
    for name, frame in pairs(contentFrames) do
        frame.Visible = (name == tabName)
    end
    
    for name, button in pairs(tabButtons) do
        if name == tabName then
            button.BackgroundColor3 = Color3.fromRGB(51, 153, 255)
        else
            button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        end
    end
    
    currentTab = tabName
end

-- Event connections
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

scriptButton.MouseButton1Click:Connect(function()
    print("Sample script executed!")
end)

-- Hover effects
local function addHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor})
        tween:Play()
    end)
end

addHoverEffect(closeButton, Color3.fromRGB(38, 38, 38), Color3.fromRGB(51, 51, 51))
addHoverEffect(scriptButton, Color3.fromRGB(38, 38, 38), Color3.fromRGB(51, 51, 51))

-- Initialize
switchTab("Home")

print("Modern GUI loaded successfully!")