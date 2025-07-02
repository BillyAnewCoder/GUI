-- Modern GUI Application in Love2D
-- Educational GUI development example

local gui = {}
local fonts = {}
local colors = {}
local ui = {}
local currentTab = "home"
local windowWidth, windowHeight = 800, 600
local sidebarWidth = 200
local headerHeight = 50
local isMinimized = false
local dragOffset = {x = 0, y = 0}
local isDragging = false

-- Color scheme
colors.background = {0.1, 0.1, 0.1}
colors.sidebar = {0.08, 0.08, 0.08}
colors.header = {0.12, 0.12, 0.12}
colors.accent = {0.2, 0.6, 1.0}
colors.text = {0.9, 0.9, 0.9}
colors.textSecondary = {0.6, 0.6, 0.6}
colors.button = {0.15, 0.15, 0.15}
colors.buttonHover = {0.2, 0.2, 0.2}
colors.success = {0.2, 0.8, 0.2}
colors.warning = {1.0, 0.8, 0.2}
colors.error = {1.0, 0.3, 0.3}

-- GUI Components
local Button = {}
Button.__index = Button

function Button:new(x, y, width, height, text, callback)
    local btn = {
        x = x,
        y = y,
        width = width,
        height = height,
        text = text,
        callback = callback or function() end,
        isHovered = false,
        isPressed = false
    }
    setmetatable(btn, Button)
    return btn
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    self.isHovered = mx >= self.x and mx <= self.x + self.width and 
                     my >= self.y and my <= self.y + self.height
end

function Button:draw()
    local color = self.isHovered and colors.buttonHover or colors.button
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 8)
    
    love.graphics.setColor(colors.text)
    love.graphics.setFont(fonts.medium)
    local textWidth = fonts.medium:getWidth(self.text)
    local textHeight = fonts.medium:getHeight()
    love.graphics.print(self.text, 
                       self.x + (self.width - textWidth) / 2,
                       self.y + (self.height - textHeight) / 2)
end

function Button:click()
    if self.isHovered then
        self.callback()
        return true
    end
    return false
end

-- Tab system
local tabs = {
    {name = "home", display = "Home", icon = "🏠"},
    {name = "scripts", display = "Scripts", icon = "📜"},
    {name = "settings", display = "Settings", icon = "⚙️"},
    {name = "about", display = "About", icon = "ℹ️"}
}

local buttons = {}
local scriptButtons = {}
local logs = {}

function love.load()
    love.window.setTitle("Modern GUI - Educational Example")
    love.window.setMode(windowWidth, windowHeight, {resizable = false})
    
    -- Load fonts
    fonts.small = love.graphics.newFont(12)
    fonts.medium = love.graphics.newFont(16)
    fonts.large = love.graphics.newFont(24)
    fonts.title = love.graphics.newFont(32)
    
    -- Create UI elements
    createButtons()
    
    -- Add some sample logs
    addLog("GUI initialized successfully", "success")
    addLog("Welcome to the educational GUI demo", "info")
end

function createButtons()
    buttons = {}
    
    -- Close button
    table.insert(buttons, Button:new(windowWidth - 40, 10, 30, 30, "×", function()
        love.event.quit()
    end))
    
    -- Minimize button
    table.insert(buttons, Button:new(windowWidth - 80, 10, 30, 30, "−", function()
        isMinimized = not isMinimized
    end))
    
    -- Sample script buttons for scripts tab
    scriptButtons = {}
    table.insert(scriptButtons, Button:new(sidebarWidth + 20, 100, 200, 40, "Sample Script 1", function()
        addLog("Sample Script 1 executed", "success")
    end))
    
    table.insert(scriptButtons, Button:new(sidebarWidth + 20, 150, 200, 40, "Sample Script 2", function()
        addLog("Sample Script 2 executed", "success")
    end))
    
    table.insert(scriptButtons, Button:new(sidebarWidth + 20, 200, 200, 40, "Demo Function", function()
        addLog("Demo function called", "info")
    end))
end

function addLog(message, type)
    local logEntry = {
        message = message,
        type = type or "info",
        timestamp = os.date("%H:%M:%S")
    }
    table.insert(logs, logEntry)
    
    -- Keep only last 50 logs
    if #logs > 50 then
        table.remove(logs, 1)
    end
end

function love.update(dt)
    if isMinimized then return end
    
    -- Update all buttons
    for _, button in ipairs(buttons) do
        button:update(dt)
    end
    
    if currentTab == "scripts" then
        for _, button in ipairs(scriptButtons) do
            button:update(dt)
        end
    end
end

function love.draw()
    if isMinimized then
        love.graphics.setColor(colors.header)
        love.graphics.rectangle("fill", 0, 0, windowWidth, headerHeight)
        drawHeader()
        return
    end
    
    -- Background
    love.graphics.setColor(colors.background)
    love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)
    
    -- Draw main sections
    drawSidebar()
    drawHeader()
    drawMainContent()
    
    -- Draw buttons
    for _, button in ipairs(buttons) do
        button:draw()
    end
end

function drawHeader()
    love.graphics.setColor(colors.header)
    love.graphics.rectangle("fill", 0, 0, windowWidth, headerHeight)
    
    -- Title
    love.graphics.setColor(colors.text)
    love.graphics.setFont(fonts.medium)
    love.graphics.print("Modern GUI Demo", 10, 15)
    
    -- Status indicator
    love.graphics.setColor(colors.success)
    love.graphics.circle("fill", windowWidth - 120, 25, 5)
    love.graphics.setColor(colors.text)
    love.graphics.print("Online", windowWidth - 110, 18)
end

function drawSidebar()
    love.graphics.setColor(colors.sidebar)
    love.graphics.rectangle("fill", 0, headerHeight, sidebarWidth, windowHeight - headerHeight)
    
    -- Tab buttons
    for i, tab in ipairs(tabs) do
        local y = headerHeight + (i - 1) * 50 + 20
        local isActive = currentTab == tab.name
        
        if isActive then
            love.graphics.setColor(colors.accent)
            love.graphics.rectangle("fill", 0, y, sidebarWidth, 40, 0, 8)
        end
        
        love.graphics.setColor(colors.text)
        love.graphics.setFont(fonts.medium)
        love.graphics.print(tab.icon .. " " .. tab.display, 15, y + 10)
    end
    
    -- Version info at bottom
    love.graphics.setColor(colors.textSecondary)
    love.graphics.setFont(fonts.small)
    love.graphics.print("v1.0.0", 10, windowHeight - 30)
    love.graphics.print("Educational Demo", 10, windowHeight - 15)
end

function drawMainContent()
    local contentX = sidebarWidth + 20
    local contentY = headerHeight + 20
    local contentWidth = windowWidth - sidebarWidth - 40
    
    love.graphics.setColor(colors.text)
    love.graphics.setFont(fonts.large)
    
    if currentTab == "home" then
        drawHomeTab(contentX, contentY, contentWidth)
    elseif currentTab == "scripts" then
        drawScriptsTab(contentX, contentY, contentWidth)
    elseif currentTab == "settings" then
        drawSettingsTab(contentX, contentY, contentWidth)
    elseif currentTab == "about" then
        drawAboutTab(contentX, contentY, contentWidth)
    end
end

function drawHomeTab(x, y, width)
    love.graphics.print("Welcome to Modern GUI Demo", x, y)
    
    love.graphics.setFont(fonts.medium)
    love.graphics.setColor(colors.textSecondary)
    love.graphics.print("This is an educational example of GUI development in Lua", x, y + 40)
    
    -- Stats cards
    local cardWidth = (width - 20) / 3
    local cardHeight = 80
    local cardY = y + 100
    
    -- Card 1
    love.graphics.setColor(colors.button)
    love.graphics.rectangle("fill", x, cardY, cardWidth, cardHeight, 8)
    love.graphics.setColor(colors.accent)
    love.graphics.print("Active Sessions", x + 10, cardY + 10)
    love.graphics.setFont(fonts.title)
    love.graphics.setColor(colors.text)
    love.graphics.print("1", x + 10, cardY + 35)
    
    -- Card 2
    love.graphics.setColor(colors.button)
    love.graphics.rectangle("fill", x + cardWidth + 10, cardY, cardWidth, cardHeight, 8)
    love.graphics.setFont(fonts.medium)
    love.graphics.setColor(colors.success)
    love.graphics.print("Status", x + cardWidth + 20, cardY + 10)
    love.graphics.setFont(fonts.title)
    love.graphics.setColor(colors.text)
    love.graphics.print("OK", x + cardWidth + 20, cardY + 35)
    
    -- Card 3
    love.graphics.setColor(colors.button)
    love.graphics.rectangle("fill", x + cardWidth * 2 + 20, cardY, cardWidth, cardHeight, 8)
    love.graphics.setFont(fonts.medium)
    love.graphics.setColor(colors.warning)
    love.graphics.print("Uptime", x + cardWidth * 2 + 30, cardY + 10)
    love.graphics.setFont(fonts.title)
    love.graphics.setColor(colors.text)
    love.graphics.print("24h", x + cardWidth * 2 + 30, cardY + 35)
    
    -- Recent logs
    love.graphics.setFont(fonts.medium)
    love.graphics.setColor(colors.text)
    love.graphics.print("Recent Activity", x, cardY + 120)
    
    drawLogPanel(x, cardY + 150, width, 200)
end

function drawScriptsTab(x, y, width)
    love.graphics.print("Scripts Library", x, y)
    
    love.graphics.setFont(fonts.medium)
    love.graphics.setColor(colors.textSecondary)
    love.graphics.print("Educational script examples", x, y + 40)
    
    -- Draw script buttons
    for _, button in ipairs(scriptButtons) do
        button:draw()
    end
    
    -- Script info panel
    love.graphics.setColor(colors.button)
    love.graphics.rectangle("fill", x + 250, 100, width - 270, 300, 8)
    
    love.graphics.setColor(colors.text)
    love.graphics.setFont(fonts.medium)
    love.graphics.print("Script Information", x + 270, 120)
    
    love.graphics.setColor(colors.textSecondary)
    love.graphics.print("Select a script to view details", x + 270, 150)
    love.graphics.print("• Educational purpose only", x + 270, 180)
    love.graphics.print("• Safe demonstration code", x + 270, 200)
    love.graphics.print("• No harmful functionality", x + 270, 220)
end

function drawSettingsTab(x, y, width)
    love.graphics.print("Settings", x, y)
    
    love.graphics.setFont(fonts.medium)
    love.graphics.setColor(colors.textSecondary)
    love.graphics.print("Application configuration", x, y + 40)
    
    -- Settings options
    local settingsY = y + 100
    love.graphics.setColor(colors.text)
    love.graphics.print("🎨 Theme: Dark Mode", x, settingsY)
    love.graphics.print("🔊 Sound: Enabled", x, settingsY + 30)
    love.graphics.print("📱 Auto-updates: Enabled", x, settingsY + 60)
    love.graphics.print("🔒 Safe Mode: Enabled", x, settingsY + 90)
    
    -- Note
    love.graphics.setColor(colors.warning)
    love.graphics.print("Note: This is a demo - settings are not functional", x, settingsY + 150)
end

function drawAboutTab(x, y, width)
    love.graphics.print("About", x, y)
    
    love.graphics.setFont(fonts.medium)
    love.graphics.setColor(colors.textSecondary)
    love.graphics.print("Modern GUI Demo v1.0.0", x, y + 40)
    
    love.graphics.setColor(colors.text)
    love.graphics.print("Built with Love2D and Lua", x, y + 80)
    love.graphics.print("Educational GUI development example", x, y + 110)
    
    love.graphics.setColor(colors.textSecondary)
    love.graphics.print("This application demonstrates:", x, y + 150)
    love.graphics.print("• Modern UI design principles", x, y + 180)
    love.graphics.print("• Lua programming concepts", x, y + 210)
    love.graphics.print("• Love2D framework usage", x, y + 240)
    love.graphics.print("• Component-based architecture", x, y + 270)
    
    love.graphics.setColor(colors.accent)
    love.graphics.print("Created for educational purposes only", x, y + 320)
end

function drawLogPanel(x, y, width, height)
    love.graphics.setColor(colors.button)
    love.graphics.rectangle("fill", x, y, width, height, 8)
    
    love.graphics.setColor(colors.text)
    love.graphics.setFont(fonts.small)
    
    local startY = y + 10
    local lineHeight = 20
    local maxLines = math.floor((height - 20) / lineHeight)
    
    for i = math.max(1, #logs - maxLines + 1), #logs do
        local log = logs[i]
        local logY = startY + (i - math.max(1, #logs - maxLines + 1)) * lineHeight
        
        -- Color based on log type
        if log.type == "success" then
            love.graphics.setColor(colors.success)
        elseif log.type == "warning" then
            love.graphics.setColor(colors.warning)
        elseif log.type == "error" then
            love.graphics.setColor(colors.error)
        else
            love.graphics.setColor(colors.textSecondary)
        end
        
        love.graphics.print(log.timestamp, x + 10, logY)
        love.graphics.setColor(colors.text)
        love.graphics.print(log.message, x + 80, logY)
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- Check button clicks
        for _, btn in ipairs(buttons) do
            if btn:click() then
                return
            end
        end
        
        if currentTab == "scripts" then
            for _, btn in ipairs(scriptButtons) do
                if btn:click() then
                    return
                end
            end
        end
        
        -- Check tab clicks
        if x <= sidebarWidth and y >= headerHeight then
            local tabIndex = math.floor((y - headerHeight - 20) / 50) + 1
            if tabIndex >= 1 and tabIndex <= #tabs then
                currentTab = tabs[tabIndex].name
                addLog("Switched to " .. tabs[tabIndex].display .. " tab", "info")
            end
        end
        
        -- Check header drag
        if y <= headerHeight then
            isDragging = true
            dragOffset.x = x
            dragOffset.y = y
        end
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        isDragging = false
    end
end

function love.mousemoved(x, y, dx, dy)
    if isDragging then
        -- In a real application, you would move the window here
        -- Love2D doesn't support window dragging directly
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "f1" then
        currentTab = "home"
        addLog("Switched to Home tab via F1", "info")
    elseif key == "f2" then
        currentTab = "scripts"
        addLog("Switched to Scripts tab via F2", "info")
    elseif key == "f3" then
        currentTab = "settings"
        addLog("Switched to Settings tab via F3", "info")
    elseif key == "f4" then
        currentTab = "about"
        addLog("Switched to About tab via F4", "info")
    end
end