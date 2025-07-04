-- Modern Roblox GUI - Circular Progress Design
-- Based on the provided image reference

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Animation settings
local TWEEN_INFO = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local HOVER_TWEEN = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local PROGRESS_TWEEN = TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- State management
local currentProgress = 100
local maxProgress = 72
local currentValue = 72
local timeElapsed = 0

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernProgressGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 100
mainFrame.Parent = screenGui

-- Add corner radius
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

-- Left panel for circular progress
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, 280, 1, 0)
leftPanel.Position = UDim2.new(0, 0, 0, 0)
leftPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
leftPanel.BorderSizePixel = 0
leftPanel.ZIndex = 101
leftPanel.Parent = mainFrame

-- Right panel for search and content
local rightPanel = Instance.new("Frame")
rightPanel.Name = "RightPanel"
rightPanel.Size = UDim2.new(1, -280, 1, 0)
rightPanel.Position = UDim2.new(0, 280, 0, 0)
rightPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
rightPanel.BorderSizePixel = 0
rightPanel.ZIndex = 101
rightPanel.Parent = mainFrame

-- Circular progress container
local progressContainer = Instance.new("Frame")
progressContainer.Name = "ProgressContainer"
progressContainer.Size = UDim2.new(0, 200, 0, 200)
progressContainer.Position = UDim2.new(0.5, -100, 0, 50)
progressContainer.BackgroundTransparency = 1
progressContainer.ZIndex = 102
progressContainer.Parent = leftPanel

-- Create circular progress using ImageLabel with rotation
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
progressText.Text = "100%"
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
progressSubtext.Text = "72/72"
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
statusText.Position = UDim2.new(0, 10, 0, 270)
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
versionText.Position = UDim2.new(0, 10, 0, 295)
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
zenithContainer.Position = UDim2.new(0, 10, 0, 320)
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

-- Statistics container
local statsContainer = Instance.new("Frame")
statsContainer.Name = "StatsContainer"
statsContainer.Size = UDim2.new(1, -20, 0, 120)
statsContainer.Position = UDim2.new(0, 10, 0, 80)
statsContainer.BackgroundTransparency = 1
statsContainer.ZIndex = 102
statsContainer.Parent = rightPanel

-- Create stat cards
local statData = {
    {title = "Passed", value = "0", color = Color3.fromRGB(100, 255, 100)},
    {title = "Timeout", value = "0", color = Color3.fromRGB(255, 200, 100)},
    {title = "Failed", value = "0", color = Color3.fromRGB(255, 100, 100)}
}

for i, stat in ipairs(statData) do
    local statCard = Instance.new("Frame")
    statCard.Name = stat.title .. "Card"
    statCard.Size = UDim2.new(0.31, 0, 0, 80)
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
end

-- Time taken display
local timeContainer = Instance.new("Frame")
timeContainer.Name = "TimeContainer"
timeContainer.Size = UDim2.new(1, -20, 0, 80)
timeContainer.Position = UDim2.new(0, 10, 0, 220)
timeContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
timeContainer.BorderSizePixel = 0
timeContainer.ZIndex = 102
timeContainer.Parent = rightPanel

local timeCorner = Instance.new("UICorner")
timeCorner.CornerRadius = UDim.new(0, 8)
timeCorner.Parent = timeContainer

local timeValue = Instance.new("TextLabel")
timeValue.Name = "TimeValue"
timeValue.Size = UDim2.new(1, -10, 0, 35)
timeValue.Position = UDim2.new(0, 5, 0, 15)
timeValue.BackgroundTransparency = 1
timeValue.Text = "0s"
timeValue.TextColor3 = Color3.fromRGB(255, 255, 255)
timeValue.TextSize = 28
timeValue.Font = Enum.Font.GothamBold
timeValue.TextXAlignment = Enum.TextXAlignment.Center
timeValue.ZIndex = 103
timeValue.Parent = timeContainer

local timeTitle = Instance.new("TextLabel")
timeTitle.Size = UDim2.new(1, -10, 0, 20)
timeTitle.Position = UDim2.new(0, 5, 0, 50)
timeTitle.BackgroundTransparency = 1
timeTitle.Text = "Time Taken"
timeTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
timeTitle.TextSize = 12
timeTitle.Font = Enum.Font.Gotham
timeTitle.TextXAlignment = Enum.TextXAlignment.Center
timeTitle.ZIndex = 103
timeTitle.Parent = timeContainer

-- Animation functions
local function addButtonAnimations(button, normalColor, hoverColor)
    local originalSize = button.Size
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
local function updateProgress(newProgress, newValue, newMax)
    currentProgress = newProgress
    currentValue = newValue
    maxProgress = newMax
    
    -- Update text
    progressText.Text = math.floor(newProgress) .. "%"
    progressSubtext.Text = newValue .. "/" .. newMax
    
    -- Animate progress circle (simplified visual representation)
    local progressTween = TweenService:Create(progressStroke, PROGRESS_TWEEN, {
        Transparency = 1 - (newProgress / 100)
    })
    progressTween:Play()
end

-- Time counter
local function startTimeCounter()
    RunService.Heartbeat:Connect(function(deltaTime)
        timeElapsed = timeElapsed + deltaTime
        timeValue.Text = math.floor(timeElapsed) .. "s"
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

-- Add button animations
addButtonAnimations(closeButton, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 60, 60))

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

-- Initialize
startTimeCounter()

-- Entrance animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

wait(0.1)

local entranceTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 600, 0, 400),
    Position = UDim2.new(0.5, -300, 0.5, -200)
})
entranceTween:Play()

-- Demo: Update progress after a delay
wait(1)
updateProgress(100, 72, 72)

print("Modern Progress GUI loaded successfully!")