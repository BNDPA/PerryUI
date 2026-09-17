local PerryUI = {}
PerryUI.__index = PerryUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function PerryUI.CreateWindow(titleText, subtitleText)
    local self = setmetatable({}, PerryUI)
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PerryUI_Container"
    screenGui.ResetOnSpawn = false
    
    pcall(function()
        screenGui.Parent = CoreGui
    end)
    if not screenGui.Parent then
        screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- 1. Створення згорнутого виджета (Top Minimized Widget)
    local topWidget = Instance.new("Frame")
    topWidget.Name = "TopWidget"
    topWidget.Size = UDim2.new(0, 240, 0, 42)
    topWidget.Position = UDim2.new(0.5, -120, 0, 15) -- Відступ 15px від верху
    topWidget.BackgroundColor3 = Color3.fromRGB(15, 18, 16)
    topWidget.BorderSizePixel = 0
    topWidget.Visible = false
    topWidget.Parent = screenGui

    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(1, 0) -- Закруглені крачки як у капсули
    topCorner.Parent = topWidget

    local topStroke = Instance.new("UIStroke")
    topStroke.Color = Color3.fromRGB(180, 100, 255) -- Градієнт/неонова обводка
    topStroke.Thickness = 1.5
    topStroke.Parent = topWidget

    -- Іконка шестерні у виджеті
    local gearIcon = Instance.new("TextLabel")
    gearIcon.Text = "⚙"
    gearIcon.Font = Enum.Font.GothamBold
    gearIcon.TextSize = 18
    gearIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    gearIcon.Position = UDim2.new(0, 15, 0, 0)
    gearIcon.Size = UDim2.new(0, 30, 1, 0)
    gearIcon.BackgroundTransparency = 1
    gearIcon.Parent = topWidget

    -- Назва скрипта у виджеті (динамічно підставляється)
    local topTitle = Instance.new("TextLabel")
    topTitle.Text = titleText or "PerryUI"
    topTitle.Font = Enum.Font.GothamBold
    topTitle.TextSize = 14
    topTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    topTitle.Position = UDim2.new(0, 45, 0, 0)
    topTitle.Size = UDim2.new(1, -55, 1, 0)
    topTitle.TextXAlignment = Enum.TextXAlignment.Left
    topTitle.BackgroundTransparency = 1
    topTitle.Parent = topWidget

    -- Кнопка розгортання виджета
    local restoreBtn = Instance.new("TextButton")
    restoreBtn.Size = UDim2.new(1, 0, 1, 0)
    restoreBtn.BackgroundTransparency = 1
    restoreBtn.Text = ""
    restoreBtn.Parent = topWidget

    -- 2. Головне вікно
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 580, 0, 360)
    mainFrame.Position = UDim2.new(0.5, -290, 0.5, -180)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 22)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame
    
    -- Перетягування головного вікна
    local dragging, dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Кнопки керування вікном (Закрити та Згорнути)
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Text = "-"
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 18
    minimizeBtn.TextColor3 = Color3.fromRGB(160, 170, 165)
    minimizeBtn.Position = UDim2.new(1, -55, 0, 10)
    minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Parent = mainFrame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "×"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.TextColor3 = Color3.fromRGB(160, 170, 165)
    closeBtn.Position = UDim2.new(1, -30, 0, 10)
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = mainFrame

    -- Логіка згортання/розгортання/закриття
    minimizeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        topWidget.Visible = true
    end)

    restoreBtn.MouseButton1Click:Connect(function()
        topWidget.Visible = false
        mainFrame.Visible = true
    end)

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Заголовки та інтерфейс
    local title = Instance.new("TextLabel")
    title.Text = titleText or "PerryUI"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Position = UDim2.new(0, 20, 0, 15)
    title.Size = UDim2.new(0, 200, 0, 20)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = mainFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Text = subtitleText or "Custom Interface"
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 12
    subtitle.TextColor3 = Color3.fromRGB(150, 160, 155)
    subtitle.Position = UDim2.new(0, 20, 0, 35)
    subtitle.Size = UDim2.new(0, 200, 0, 15)
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.BackgroundTransparency = 1
    subtitle.Parent = mainFrame

    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 140, 1, -70)
    sidebar.Position = UDim2.new(0, 15, 0, 60)
    sidebar.BackgroundTransparency = 1
    sidebar.ScrollBarThickness = 0
    sidebar.Parent = mainFrame
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.Parent = sidebar

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -180, 1, -70)
    container.Position = UDim2.new(0, 165, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = mainFrame

    self.MainFrame = mainFrame
    self.Sidebar = sidebar
    self.Container = container
    self.Tabs = {}

    return self
end

function PerryUI:CreateTab(name)
    local tab = {}
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "_Button"
    tabBtn.Size = UDim2.new(1, 0, 0, 35)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 32)
    tabBtn.Text = "  " .. name
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 13
    tabBtn.TextColor3 = Color3.fromRGB(180, 190, 185)
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = self.Sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "_Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.ScrollBarThickness = 2
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 90, 85)
    tabContent.Visible = false
    tabContent.Parent = self.Container
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = tabContent

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Content.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 35, 32),
                TextColor3 = Color3.fromRGB(180, 190, 185)
            }):Play()
        end
        tabContent.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 80, 65),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)

    if #self.Tabs == 0 then
        tabContent.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(45, 80, 65)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    tab.Button = tabBtn
    tab.Content = tabContent
    table.insert(self.Tabs, tab)

    function tab:AddToggle(titleText, descText, defaultValue, callback)
        local state = defaultValue or false
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -10, 0, 50)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(28, 32, 30)
        toggleFrame.Parent = tabContent
        
        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(0, 6)
        tCorner.Parent = toggleFrame
        
        local tTitle = Instance.new("TextLabel")
        tTitle.Text = titleText
        tTitle.Font = Enum.Font.GothamBold
        tTitle.TextSize = 13
        tTitle.TextColor3 = Color3.fromRGB(230, 235, 230)
        tTitle.Position = UDim2.new(0, 12, 0, 8)
        tTitle.Size = UDim2.new(1, -70, 0, 18)
        tTitle.TextXAlignment = Enum.TextXAlignment.Left
        tTitle.BackgroundTransparency = 1
        tTitle.Parent = toggleFrame

        local tDesc = Instance.new("TextLabel")
        tDesc.Text = descText or ""
        tDesc.Font = Enum.Font.Gotham
        tDesc.TextSize = 11
        tDesc.TextColor3 = Color3.fromRGB(130, 140, 135)
        tDesc.Position = UDim2.new(0, 12, 0, 26)
        tDesc.Size = UDim2.new(1, -70, 0, 16)
        tDesc.TextXAlignment = Enum.TextXAlignment.Left
        tDesc.BackgroundTransparency = 1
        tDesc.Parent = toggleFrame

        local switchBG = Instance.new("Frame")
        switchBG.Size = UDim2.new(0, 38, 0, 20)
        switchBG.Position = UDim2.new(1, -50, 0.5, -10)
        switchBG.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 55, 52)
        switchBG.Parent = toggleFrame

        local sCorner = Instance.new("UICorner")
        sCorner.CornerRadius = UDim.new(1, 0)
        sCorner.Parent = switchBG

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 16, 0, 16)
        circle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        circle.BackgroundColor3 = state and Color3.fromRGB(20, 24, 22) or Color3.fromRGB(180, 185, 180)
        circle.Parent = switchBG

        local cCorner = Instance.new("UICorner")
        cCorner.CornerRadius = UDim.new(1, 0)
        cCorner.Parent = circle

        local clickBtn = Instance.new("TextButton")
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""
        clickBtn.Parent = toggleFrame

        clickBtn.MouseButton1Click:Connect(function()
            state = not state
            
            TweenService:Create(switchBG, TweenInfo.new(0.2), {
                BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 55, 52)
            }):Play()

            TweenService:Create(circle, TweenInfo.new(0.2), {
                Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = state and Color3.fromRGB(20, 24, 22) or Color3.fromRGB(180, 185, 180)
            }):Play()

            if callback then callback(state) end
        end)
    end

    return tab
end

return PerryUI

