local PerryUI = {}
PerryUI.__index = PerryUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")

-- Система уведомлений (справа)
local NoticeContainer = Instance.new("Frame")
NoticeContainer.Name = "PerryUI_Notices"
NoticeContainer.Size = UDim2.new(0, 250, 1, -20)
NoticeContainer.Position = UDim2.new(1, -260, 0, 10)
NoticeContainer.BackgroundTransparency = 1
NoticeContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() NoticeContainer.Parent = CoreGui end)
if not NoticeContainer.Parent then
    NoticeContainer.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

local noticeLayout = Instance.new("UIListLayout")
noticeLayout.SortOrder = Enum.SortOrder.LayoutOrder
noticeLayout.Padding = UDim.new(0, 8)
noticeLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
noticeLayout.Parent = NoticeContainer

function PerryUI:Notify(titleText, messageText, duration)
    local dur = duration or 3
    
    local noticeFrame = Instance.new("Frame")
    noticeFrame.Size = UDim2.new(1, 0, 0, 55)
    noticeFrame.Position = UDim2.new(1, 20, 0, 0)
    noticeFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    noticeFrame.BorderSizePixel = 0
    noticeFrame.Parent = NoticeContainer
    
    local nCorner = Instance.new("UICorner")
    nCorner.CornerRadius = UDim.new(0, 8)
    nCorner.Parent = noticeFrame

    local nStroke = Instance.new("UIStroke")
    nStroke.Color = Color3.fromRGB(140, 90, 255)
    nStroke.Thickness = 1
    nStroke.Parent = noticeFrame

    local nTitle = Instance.new("TextLabel")
    nTitle.Text = titleText or "Notice"
    nTitle.Font = Enum.Font.GothamBold
    nTitle.TextSize = 13
    nTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    nTitle.Position = UDim2.new(0, 12, 0, 8)
    nTitle.Size = UDim2.new(1, -24, 0, 16)
    nTitle.TextXAlignment = Enum.TextXAlignment.Left
    nTitle.BackgroundTransparency = 1
    nTitle.Parent = noticeFrame

    local nDesc = Instance.new("TextLabel")
    nDesc.Text = messageText or ""
    nDesc.Font = Enum.Font.Gotham
    nDesc.TextSize = 11
    nDesc.TextColor3 = Color3.fromRGB(160, 160, 160)
    nDesc.Position = UDim2.new(0, 12, 0, 26)
    nDesc.Size = UDim2.new(1, -24, 0, 20)
    nDesc.TextXAlignment = Enum.TextXAlignment.Left
    nDesc.BackgroundTransparency = 1
    nDesc.Parent = noticeFrame

    TweenService:Create(noticeFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    task.delay(dur, function()
        local tweenOut = TweenService:Create(noticeFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 30, 0, 0)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            noticeFrame:Destroy()
        end)
    end)
end

-- Перетаскивание БЕЗ вращения камеры
local function makeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos

    local function freezeCamera(actionName, inputState, inputObject)
        if dragging then
            return Enum.ContextAnimationFrameResult.Sink
        end
        return Enum.ContextAnimationFrameResult.Pass
    end

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            
            -- Захватываем ввод, чтобы камера не вращалась
            ContextActionService:BindActionAtPriority("PerryUI_FreezeCam", function()
                return Enum.ContextActionResult.Sink
            end, false, 3000, Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch)

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    ContextActionService:UnbindAction("PerryUI_FreezeCam")
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function PerryUI.CreateWindow(titleText, subtitleText)
    local self = setmetatable({}, PerryUI)
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PerryUI_Container"
    screenGui.ResetOnSpawn = false
    
    pcall(function() screenGui.Parent = CoreGui end)
    if not screenGui.Parent then
        screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local scriptTitle = titleText or "MyScript"
    local scriptSubtitle = subtitleText or "Script Subtitle"

    -- Виджет сверху
    local topWidget = Instance.new("Frame")
    topWidget.Name = "TopWidget"
    topWidget.Size = UDim2.new(0, 220, 0, 44)
    topWidget.Position = UDim2.new(0.5, -110, 0, 15)
    topWidget.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    topWidget.BorderSizePixel = 0
    topWidget.Visible = false
    topWidget.Parent = screenGui

    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(1, 0)
    topCorner.Parent = topWidget

    local topStroke = Instance.new("UIStroke")
    topStroke.Color = Color3.fromRGB(140, 90, 255)
    topStroke.Thickness = 1.5
    topStroke.Parent = topWidget

    local gearIcon = Instance.new("TextLabel")
    gearIcon.Text = "⚙"
    gearIcon.Font = Enum.Font.GothamBold
    gearIcon.TextSize = 18
    gearIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    gearIcon.Position = UDim2.new(0, 12, 0, 0)
    gearIcon.Size = UDim2.new(0, 26, 1, 0)
    gearIcon.BackgroundTransparency = 1
    gearIcon.Parent = topWidget

    local topTitle = Instance.new("TextLabel")
    topTitle.Text = scriptTitle
    topTitle.Font = Enum.Font.GothamBold
    topTitle.TextSize = 14
    topTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    topTitle.Position = UDim2.new(0, 42, 0, 0)
    topTitle.Size = UDim2.new(1, -52, 1, 0)
    topTitle.TextXAlignment = Enum.TextXAlignment.Left
    topTitle.BackgroundTransparency = 1
    topTitle.Parent = topWidget

    local restoreBtn = Instance.new("TextButton")
    restoreBtn.Size = UDim2.new(1, 0, 1, 0)
    restoreBtn.BackgroundTransparency = 1
    restoreBtn.Text = ""
    restoreBtn.Parent = topWidget

    makeDraggable(topWidget)

    -- Главное окно
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 540, 0, 340)
    mainFrame.Position = UDim2.new(0.5, -270, 0.5, -170)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    makeDraggable(mainFrame)

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Text = "-"
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 22
    minimizeBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    minimizeBtn.Position = UDim2.new(1, -65, 0, 10)
    minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Parent = mainFrame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "×"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 22
    closeBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    closeBtn.Position = UDim2.new(1, -35, 0, 10)
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = mainFrame

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

    local title = Instance.new("TextLabel")
    title.Text = scriptTitle
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Position = UDim2.new(0, 18, 0, 12)
    title.Size = UDim2.new(0, 220, 0, 20)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = mainFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Text = scriptSubtitle
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 11
    subtitle.TextColor3 = Color3.fromRGB(130, 130, 130)
    subtitle.Position = UDim2.new(0, 18, 0, 32)
    subtitle.Size = UDim2.new(0, 220, 0, 16)
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.BackgroundTransparency = 1
    subtitle.Parent = mainFrame

    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 135, 1, -65)
    sidebar.Position = UDim2.new(0, 15, 0, 55)
    sidebar.BackgroundTransparency = 1
    sidebar.ScrollBarThickness = 0
    sidebar.Parent = mainFrame
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.Parent = sidebar

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -170, 1, -65)
    container.Position = UDim2.new(0, 155, 0, 55)
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
    tabBtn.Size = UDim2.new(1, 0, 0, 38)
    tabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tabBtn.Text = "  " .. name
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 13
    tabBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = self.Sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = tabBtn

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "_Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.ScrollBarThickness = 3
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    tabContent.Visible = false
    tabContent.Parent = self.Container
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tabContent

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Content.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                TextColor3 = Color3.fromRGB(160, 160, 160)
            }):Play()
        end
        tabContent.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 40, 38),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)

    if #self.Tabs == 0 then
        tabContent.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 38)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    tab.Button = tabBtn
    tab.Content = tabContent
    table.insert(self.Tabs, tab)

    -- Одноразовая кнопка (Button)
    function tab:AddButton(titleText, descText, callback)
        local btnFrame = Instance.new("Frame")
        btnFrame.Size = UDim2.new(1, -8, 0, 48)
        btnFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        btnFrame.Parent = tabContent
        
        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 8)
        bCorner.Parent = btnFrame
        
        local bTitle = Instance.new("TextLabel")
        bTitle.Text = titleText
        bTitle.Font = Enum.Font.GothamBold
        bTitle.TextSize = 13
        bTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
        bTitle.Position = UDim2.new(0, 12, 0, 7)
        bTitle.Size = UDim2.new(1, -24, 0, 18)
        bTitle.TextXAlignment = Enum.TextXAlignment.Left
        bTitle.BackgroundTransparency = 1
        bTitle.Parent = btnFrame

        local bDesc = Instance.new("TextLabel")
        bDesc.Text = descText or ""
        bDesc.Font = Enum.Font.Gotham
        bDesc.TextSize = 11
        bDesc.TextColor3 = Color3.fromRGB(120, 120, 120)
        bDesc.Position = UDim2.new(0, 12, 0, 25)
        bDesc.Size = UDim2.new(1, -24, 0, 16)
        bDesc.TextXAlignment = Enum.TextXAlignment.Left
        bDesc.BackgroundTransparency = 1
        bDesc.Parent = btnFrame

        local clickBtn = Instance.new("TextButton")
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""
        clickBtn.Parent = btnFrame

        clickBtn.MouseButton1Click:Connect(function()
            -- Анимация клика
            TweenService:Create(btnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            task.delay(0.1, function()
                TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(18, 18, 18)}):Play()
            end)
            
            if callback then callback() end
        end)
    end

    -- Переключатель (Toggle)
    function tab:AddToggle(titleText, descText, defaultValue, callback)
        local state = defaultValue or false
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -8, 0, 52)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        toggleFrame.Parent = tabContent
        
        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(0, 8)
        tCorner.Parent = toggleFrame
        
        local tTitle = Instance.new("TextLabel")
        tTitle.Text = titleText
        tTitle.Font = Enum.Font.GothamBold
        tTitle.TextSize = 13
        tTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
        tTitle.Position = UDim2.new(0, 12, 0, 8)
        tTitle.Size = UDim2.new(1, -75, 0, 18)
        tTitle.TextXAlignment = Enum.TextXAlignment.Left
        tTitle.BackgroundTransparency = 1
        tTitle.Parent = toggleFrame

        local tDesc = Instance.new("TextLabel")
        tDesc.Text = descText or ""
        tDesc.Font = Enum.Font.Gotham
        tDesc.TextSize = 11
        tDesc.TextColor3 = Color3.fromRGB(120, 120, 120)
        tDesc.Position = UDim2.new(0, 12, 0, 27)
        tDesc.Size = UDim2.new(1, -75, 0, 16)
        tDesc.TextXAlignment = Enum.TextXAlignment.Left
        tDesc.BackgroundTransparency = 1
        tDesc.Parent = toggleFrame

        local switchBG = Instance.new("Frame")
        switchBG.Size = UDim2.new(0, 42, 0, 22)
        switchBG.Position = UDim2.new(1, -54, 0.5, -11)
        switchBG.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
        switchBG.Parent = toggleFrame

        local sCorner = Instance.new("UICorner")
        sCorner.CornerRadius = UDim.new(1, 0)
        sCorner.Parent = switchBG

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 18, 0, 18)
        circle.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        circle.BackgroundColor3 = state and Color3.fromRGB(15, 15, 15) or Color3.fromRGB(180, 180, 180)
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
                BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
            }):Play()

            TweenService:Create(circle, TweenInfo.new(0.2), {
                Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
                BackgroundColor3 = state and Color3.fromRGB(15, 15, 15) or Color3.fromRGB(180, 180, 180)
            }):Play()

            if callback then callback(state) end
        end)
    end

    return tab
end

return PerryUI

