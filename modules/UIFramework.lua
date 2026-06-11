-- F脚本中心 - UI框架模块
-- 提供基础UI创建工具和动画效果
local UI = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- 屏幕尺寸计算
local screenSize = Camera.ViewportSize
local isMobile = UserInputService.TouchEnabled
local baseWidth, baseHeight = 600, 480
local scale = math.min(screenSize.X / baseWidth, screenSize.Y / baseHeight, 1.2)
if isMobile then scale = math.min(scale, 1.0) end
local frameWidth = math.floor(baseWidth * scale)
local frameHeight = math.floor(baseHeight * scale)

-- 工具函数
function UI.new(class, parent, props)
    local obj = Instance.new(class)
    if parent then obj.Parent = parent end
    if props then
        for k, v in pairs(props) do
            pcall(function() obj[k] = v end)
        end
    end
    return obj
end

function UI.corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = parent
    return c
end

function UI.tween(obj, duration, props, easing, direction)
    local info = TweenInfo.new(duration or 0.3, easing or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

-- 创建主界面
function UI.createMainUI()
    local ScreenGui = UI.new("ScreenGui", LocalPlayer.PlayerGui, {
        Name = "FScriptHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local MainFrame = UI.new("Frame", ScreenGui, {
        Name = "MainFrame",
        Size = UDim2.new(0, frameWidth, 0, frameHeight),
        Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2),
        BackgroundColor3 = Color3.fromRGB(25,25,30),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        ClipsDescendants = false,
        Visible = false
    })
    UI.corner(MainFrame, 16)

    -- 炫彩边框
    local MainStroke = UI.new("UIStroke", MainFrame, { Thickness = 3, Transparency = 0.15 })
    coroutine.wrap(function()
        while MainStroke and MainStroke.Parent do
            MainStroke.Color = Color3.fromHSV((tick()*0.4)%1, 1, 1)
            RunService.RenderStepped:Wait()
        end
    end)()

    -- 标题栏
    local TitleBar = UI.new("Frame", MainFrame, {
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundColor3 = Color3.fromRGB(35,35,45),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0
    })
    UI.corner(TitleBar, 16)

    local TitleIcon = UI.new("TextLabel", TitleBar, {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 10, 0, 7),
        BackgroundColor3 = Color3.fromRGB(0,162,255),
        Text = "F",
        TextColor3 = Color3.fromRGB(255,255,255),
        Font = Enum.Font.GothamBlack,
        TextSize = 22
    })
    UI.corner(TitleIcon, 10)

    local TitleText = UI.new("TextLabel", TitleBar, {
        Size = UDim2.new(0, 200, 0, 25),
        Position = UDim2.new(0, 58, 0, 6),
        BackgroundTransparency = 1,
        Text = "F脚本中心",
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local SubTitleText = UI.new("TextLabel", TitleBar, {
        Size = UDim2.new(0, 200, 0, 16),
        Position = UDim2.new(0, 58, 0, 30),
        BackgroundTransparency = 1,
        Text = "v6.0 模块化版",
        TextColor3 = Color3.fromRGB(0,255,150),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- 按钮容器
    local LeftPanel = UI.new("Frame", MainFrame, {
        Size = UDim2.new(0, 170, 1, -65),
        Position = UDim2.new(0, 8, 0, 60),
        BackgroundColor3 = Color3.fromRGB(35,35,42),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0
    })
    UI.corner(LeftPanel, 12)

    local ScrollFrame = UI.new("ScrollingFrame", LeftPanel, {
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 2000),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })

    local ScrollLayout = UI.new("UIListLayout", ScrollFrame, {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    -- 右侧内容区
    local RightPanel = UI.new("Frame", MainFrame, {
        Size = UDim2.new(1, -190, 1, -65),
        Position = UDim2.new(0, 182, 0, 60),
        BackgroundColor3 = Color3.fromRGB(35,35,42),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0
    })
    UI.corner(RightPanel, 12)

    -- 玩家信息卡
    local PlayerCard = UI.new("Frame", RightPanel, {
        Size = UDim2.new(1, -10, 0, 80),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundColor3 = Color3.fromRGB(45,45,55),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0
    })
    UI.corner(PlayerCard, 10)

    local AvatarImage = UI.new("ImageLabel", PlayerCard, {
        Size = UDim2.new(0, 56, 0, 56),
        Position = UDim2.new(0, 10, 0, 12),
        BackgroundTransparency = 1
    })
    UI.corner(AvatarImage, 28)
    pcall(function() AvatarImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)

    local NameLabel = UI.new("TextLabel", PlayerCard, {
        Size = UDim2.new(1, -80, 0, 22),
        Position = UDim2.new(0, 74, 0, 10),
        BackgroundTransparency = 1,
        Text = LocalPlayer.DisplayName,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local RoleLabel = UI.new("TextLabel", PlayerCard, {
        Size = UDim2.new(1, -80, 0, 18),
        Position = UDim2.new(0, 74, 0, 32),
        BackgroundTransparency = 1,
        Text = "普通用户",
        TextColor3 = Color3.fromRGB(180,180,180),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local TimeLabel = UI.new("TextLabel", PlayerCard, {
        Size = UDim2.new(1, -80, 0, 16),
        Position = UDim2.new(0, 74, 0, 52),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(150,150,255),
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    coroutine.wrap(function()
        while TimeLabel and TimeLabel.Parent do
            TimeLabel.Text = os.date("%H:%M:%S")
            task.wait(1)
        end
    end)()

    -- 欢迎文字
    local WelcomeLabel = UI.new("TextLabel", RightPanel, {
        Size = UDim2.new(1, -10, 0, 28),
        Position = UDim2.new(0, 5, 0, 90),
        BackgroundTransparency = 1,
        Text = "欢迎使用 F脚本中心",
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 15,
        Font = Enum.Font.GothamBold
    })

    -- 标题栏按钮
    local buttons = {}
    local buttonConfigs = {
        {name = "ClearScripts", text = "🗑", color = Color3.fromRGB(255,50,80), pos = UDim2.new(1, -154, 0, 11)},
        {name = "Layout", text = "⟲", color = Color3.fromRGB(0,162,255), pos = UDim2.new(1, -116, 0, 11)},
        {name = "Minimize", text = "−", color = Color3.fromRGB(255,180,0), pos = UDim2.new(1, -78, 0, 11)},
        {name = "Close", text = "×", color = Color3.fromRGB(255,100,50), pos = UDim2.new(1, -40, 0, 11)},
    }

    for _, cfg in ipairs(buttonConfigs) do
        local btn = UI.new("TextButton", TitleBar, {
            Name = cfg.name.."Btn",
            Size = UDim2.new(0, 32, 0, 32),
            Position = cfg.pos,
            BackgroundColor3 = cfg.color,
            Text = cfg.text,
            TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            BorderSizePixel = 0
        })
        UI.corner(btn, 8)
        buttons[cfg.name] = btn
    end

    -- FPS显示
    local fpsLabel = UI.new("TextLabel", ScreenGui, {
        Name = "FPSLabel",
        Size = UDim2.new(0, 80, 0, 22),
        Position = UDim2.new(1, -90, 0, 5),
        BackgroundColor3 = Color3.fromRGB(25,25,30),
        BackgroundTransparency = 0.3,
        Text = "FPS: 60",
        TextColor3 = Color3.fromRGB(0,255,100),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        ZIndex = 200
    })
    UI.corner(fpsLabel, 6)

    local fpsStroke = UI.new("UIStroke", fpsLabel, {
        Thickness = 1, Transparency = 0.5, Color = Color3.fromRGB(0,255,100)
    })

    local lastTime = tick()
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            local fps = math.floor(frameCount / (currentTime - lastTime))
            frameCount = 0
            lastTime = currentTime
            if fpsLabel and fpsLabel.Parent then
                fpsLabel.Text = "FPS: " .. fps
                if fps >= 55 then
                    fpsLabel.TextColor3 = Color3.fromRGB(0,255,100)
                    fpsStroke.Color = Color3.fromRGB(0,255,100)
                elseif fps >= 30 then
                    fpsLabel.TextColor3 = Color3.fromRGB(255,220,0)
                    fpsStroke.Color = Color3.fromRGB(255,220,0)
                else
                    fpsLabel.TextColor3 = Color3.fromRGB(255,70,70)
                    fpsStroke.Color = Color3.fromRGB(255,70,70)
                end
            end
        end
    end)

    -- 创建悬浮F按钮
    local openBtn = UI.new("TextButton", ScreenGui, {
        Name = "OpenBtn",
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 15, 0.5, -25),
        BackgroundColor3 = Color3.fromRGB(0,162,255),
        Text = "F",
        TextColor3 = Color3.fromRGB(255,255,255),
        Font = Enum.Font.GothamBlack,
        TextSize = 24,
        BorderSizePixel = 0,
        ZIndex = 100,
        Active = true,
        Draggable = true
    })
    UI.corner(openBtn, 14)

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        LeftPanel = LeftPanel,
        RightPanel = RightPanel,
        ScrollFrame = ScrollFrame,
        PlayerCard = PlayerCard,
        WelcomeLabel = WelcomeLabel,
        buttons = buttons,
        openBtn = openBtn,
        UI = UI,
        frameWidth = frameWidth,
        frameHeight = frameHeight
    }
end

-- 创建功能按钮
function UI.createFeatureButton(parent, info, index)
    local btn = UI.new("TextButton", parent, {
        Name = info.id.."Btn",
        Size = UDim2.new(1, -8, 0, 38),
        BackgroundColor3 = Color3.fromRGB(50,50,60),
        Text = "",
        BorderSizePixel = 0,
        LayoutOrder = index,
        AutoButtonColor = false
    })
    UI.corner(btn, 8)

    local iconLabel = UI.new("TextLabel", btn, {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 6, 0, 6),
        BackgroundTransparency = 1,
        Text = info.icon,
        TextSize = 16,
        Font = Enum.Font.GothamBold
    })

    local textLabel = UI.new("TextLabel", btn, {
        Name = "BtnText",
        Size = UDim2.new(1, -44, 1, 0),
        Position = UDim2.new(0, 32, 0, 0),
        BackgroundTransparency = 1,
        Text = info.name,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local colorBar = UI.new("Frame", btn, {
        Size = UDim2.new(0, 3, 0.6, 0),
        Position = UDim2.new(1, -6, 0.2, 0),
        BackgroundColor3 = info.color,
        BorderSizePixel = 0
    })
    UI.corner(colorBar, 2)

    -- 按钮动画
    local originalColor = Color3.fromRGB(50,50,60)
    local hoverColor = Color3.fromRGB(65,65,80)
    local clickColor = Color3.fromRGB(80,80,100)

    btn.MouseEnter:Connect(function()
        UI.tween(btn, 0.2, {BackgroundColor3 = hoverColor, Size = UDim2.new(1, -4, 0, 40)})
    end)
    btn.MouseLeave:Connect(function()
        UI.tween(btn, 0.2, {BackgroundColor3 = originalColor, Size = UDim2.new(1, -8, 0, 38)})
    end)
    btn.MouseButton1Down:Connect(function()
        UI.tween(btn, 0.1, {BackgroundColor3 = clickColor, Size = UDim2.new(1, -12, 0, 36)})
    end)
    btn.MouseButton1Up:Connect(function()
        UI.tween(btn, 0.15, {BackgroundColor3 = hoverColor, Size = UDim2.new(1, -4, 0, 40)})
    end)

    return btn
end

return UI
