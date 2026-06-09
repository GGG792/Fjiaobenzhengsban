-- F脚本中心 v5.0 全面优化版
-- 优化：更大界面、按钮图标、流畅动画、点击反馈
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

local AUTHOR_NAME = "noobnewfggg"
local IMAGE_URL = "https://i.imgur.com/h35hvJb.png"
local VIP_USERS = { ["sbcnm229"] = true }

local currentRole = "normal"
if LocalPlayer.Name == AUTHOR_NAME then currentRole = "author" elseif VIP_USERS[LocalPlayer.UserId] or VIP_USERS[LocalPlayer.Name] then currentRole = "vip" end
local isAuthor = currentRole == "author"
local isVIP = currentRole == "vip" or currentRole == "author"

pcall(function()
    if CoreGui:FindFirstChild("FScriptHub") then CoreGui.FScriptHub:Destroy() end
    if LocalPlayer.PlayerGui:FindFirstChild("FScriptHub") then LocalPlayer.PlayerGui.FScriptHub:Destroy() end
end)

-- ========== 屏幕适配 ==========
local screenSize = Camera.ViewportSize
local isMobile = UserInputService.TouchEnabled
local baseWidth, baseHeight = 600, 480
local scale = math.min(screenSize.X / baseWidth, screenSize.Y / baseHeight, 1.2)
if isMobile then scale = math.min(scale, 1.0) end

local frameWidth = math.floor(baseWidth * scale)
local frameHeight = math.floor(baseHeight * scale)

-- ========== 工具函数 ==========
local function new(class, parent, props)
    local obj = Instance.new(class)
    if parent then obj.Parent = parent end
    if props then
        for k, v in pairs(props) do
            pcall(function() obj[k] = v end)
        end
    end
    return obj
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = parent
    return c
end

local function tween(obj, duration, props, easing, direction)
    local info = TweenInfo.new(duration or 0.3, easing or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

-- ========== 主界面 ==========
local ScreenGui = new("ScreenGui", LocalPlayer.PlayerGui, {
    Name = "FScriptHub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local MainFrame = new("Frame", ScreenGui, {
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
corner(MainFrame, 16)

-- 炫彩边框
local MainStroke = new("UIStroke", MainFrame, { Thickness = 3, Transparency = 0.15 })
coroutine.wrap(function()
    while MainStroke and MainStroke.Parent do
        MainStroke.Color = Color3.fromHSV((tick()*0.4)%1, 1, 1)
        RunService.RenderStepped:Wait()
    end
end)()

-- 标题栏
local TitleBar = new("Frame", MainFrame, {
    Size = UDim2.new(1, 0, 0, 55),
    BackgroundColor3 = Color3.fromRGB(35,35,45),
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0
})
corner(TitleBar, 16)

local TitleIcon = new("TextLabel", TitleBar, {
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(0, 10, 0, 7),
    BackgroundColor3 = Color3.fromRGB(0,162,255),
    Text = "F",
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.GothamBlack,
    TextSize = 22
})
corner(TitleIcon, 10)

local TitleText = new("TextLabel", TitleBar, {
    Size = UDim2.new(0, 200, 0, 25),
    Position = UDim2.new(0, 58, 0, 6),
    BackgroundTransparency = 1,
    Text = "F脚本中心",
    TextColor3 = Color3.fromRGB(255,255,255),
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
})

local SubTitleText = new("TextLabel", TitleBar, {
    Size = UDim2.new(0, 200, 0, 16),
    Position = UDim2.new(0, 58, 0, 30),
    BackgroundTransparency = 1,
    Text = "v5.0 全面优化版",
    TextColor3 = Color3.fromRGB(0,255,150),
    TextSize = 12,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- 关闭按钮
local CloseBtn = new("TextButton", TitleBar, {
    Size = UDim2.new(0, 32, 0, 32),
    Position = UDim2.new(1, -40, 0, 11),
    BackgroundColor3 = Color3.fromRGB(255,100,50),
    Text = "-",
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    BorderSizePixel = 0
})
corner(CloseBtn, 8)

-- 左侧按钮列表
local LeftPanel = new("Frame", MainFrame, {
    Size = UDim2.new(0, 170, 1, -65),
    Position = UDim2.new(0, 8, 0, 60),
    BackgroundColor3 = Color3.fromRGB(35,35,42),
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0
})
corner(LeftPanel, 12)

local ScrollFrame = new("ScrollingFrame", LeftPanel, {
    Size = UDim2.new(1, -8, 1, -8),
    Position = UDim2.new(0, 4, 0, 4),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    CanvasSize = UDim2.new(0, 0, 0, 2000),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
})

local ScrollLayout = new("UIListLayout", ScrollFrame, {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder
})

-- 右侧内容区
local RightPanel = new("Frame", MainFrame, {
    Size = UDim2.new(1, -190, 1, -65),
    Position = UDim2.new(0, 182, 0, 60),
    BackgroundColor3 = Color3.fromRGB(35,35,42),
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0
})
corner(RightPanel, 12)

-- 玩家信息卡
local PlayerCard = new("Frame", RightPanel, {
    Size = UDim2.new(1, -10, 0, 80),
    Position = UDim2.new(0, 5, 0, 5),
    BackgroundColor3 = Color3.fromRGB(45,45,55),
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0
})
corner(PlayerCard, 10)

local AvatarImage = new("ImageLabel", PlayerCard, {
    Size = UDim2.new(0, 56, 0, 56),
    Position = UDim2.new(0, 10, 0, 12),
    BackgroundTransparency = 1
})
corner(AvatarImage, 28)
pcall(function() AvatarImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)

local NameLabel = new("TextLabel", PlayerCard, {
    Size = UDim2.new(1, -80, 0, 22),
    Position = UDim2.new(0, 74, 0, 10),
    BackgroundTransparency = 1,
    Text = LocalPlayer.DisplayName,
    TextColor3 = Color3.fromRGB(255,255,255),
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
})

local RoleLabel = new("TextLabel", PlayerCard, {
    Size = UDim2.new(1, -80, 0, 18),
    Position = UDim2.new(0, 74, 0, 32),
    BackgroundTransparency = 1,
    Text = currentRole=="author" and "作者" or (currentRole=="vip" and "VIP" or "普通用户"),
    TextColor3 = currentRole=="author" and Color3.fromRGB(255,215,0) or (currentRole=="vip" and Color3.fromRGB(0,255,150) or Color3.fromRGB(180,180,180)),
    TextSize = 13,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left
})

local TimeLabel = new("TextLabel", PlayerCard, {
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
local WelcomeLabel = new("TextLabel", RightPanel, {
    Size = UDim2.new(1, -10, 0, 28),
    Position = UDim2.new(0, 5, 0, 90),
    BackgroundTransparency = 1,
    Text = "欢迎使用 F脚本中心",
    TextColor3 = Color3.fromRGB(255,255,255),
    TextSize = 15,
    Font = Enum.Font.GothamBold
})

-- ========== 按钮定义（带图标） ==========
local buttonRefs = {}
local btnDefs = {
    {name = "启用飞行",    icon = "✈",  color = Color3.fromRGB(0,162,255),   id = "fly"},
    {name = "旋转脚本",    icon = "🔄", color = Color3.fromRGB(255,100,50),  id = "spin"},
    {name = "环绕旋转",    icon = "🪐", color = Color3.fromRGB(150,50,255),  id = "orbit"},
    {name = "无头效果",    icon = "👤", color = Color3.fromRGB(100,100,100),  id = "headless"},
    {name = "燃烧效果",    icon = "🔥", color = Color3.fromRGB(255,50,0),    id = "fire"},
    {name = "烟雾效果",    icon = "💨", color = Color3.fromRGB(150,150,150),  id = "smoke"},
    {name = "加速脚本",    icon = "⚡", color = Color3.fromRGB(255,220,0),   id = "speed"},
    {name = "跳跃增强",    icon = "🦘", color = Color3.fromRGB(50,255,100),   id = "jump"},
    {name = "穿墙脚本",    icon = "🧱", color = Color3.fromRGB(180,100,50),  id = "noclip"},
    {name = "ESP透视",     icon = "👁", color = Color3.fromRGB(255,50,100),  id = "esp"},
    {name = "车辆加速",    icon = "🏎", color = Color3.fromRGB(255,165,0),   id = "carboost"},
    {name = "快速互动",    icon = "⚡", color = Color3.fromRGB(0,255,200),   id = "instantaction"},
    {name = "数据修改器",  icon = "📊", color = Color3.fromRGB(180,100,255), id = "datamod"},
    {name = "永久存在",    icon = "💾", color = Color3.fromRGB(255,200,100), id = "permanent"},
    {name = "取消永久",    icon = "🗑", color = Color3.fromRGB(255,100,100),  id = "unpermanent"},
    {name = "传送玩家",    icon = "📍", color = Color3.fromRGB(0,255,100),   id = "teleport"},
    {name = "标记此处",    icon = "📌", color = Color3.fromRGB(255,200,0),   id = "markpoint"},
    {name = "标记列表",    icon = "📋", color = Color3.fromRGB(255,150,50),  id = "marklist"},
    {name = "管理员工具",  icon = "🛠", color = Color3.fromRGB(255,215,0),   id = "admintool"},
    {name = "服务器脚本",  icon = "🖥", color = Color3.fromRGB(200,150,255), id = "serverscripts"},
    {name = "4:3比例",     icon = "📐", color = Color3.fromRGB(255,180,100), id = "ratio43"},
    {name = "超广角",      icon = "📷", color = Color3.fromRGB(100,255,200), id = "ultrawide"},
    {name = "切换身份",    icon = "🎭", color = Color3.fromRGB(255,100,255), id = "switchrole"},
    {name = "赞助作者",    icon = "☕", color = Color3.fromRGB(255,215,0),   id = "sponsor"},
}

-- ========== 创建带图标的按钮 ==========
for i, info in ipairs(btnDefs) do
    local btn = new("TextButton", ScrollFrame, {
        Name = info.id.."Btn",
        Size = UDim2.new(1, -8, 0, 38),
        BackgroundColor3 = Color3.fromRGB(50,50,60),
        Text = "",
        BorderSizePixel = 0,
        LayoutOrder = i,
        AutoButtonColor = false
    })
    corner(btn, 8)

    -- 图标
    local iconLabel = new("TextLabel", btn, {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 6, 0, 5),
        BackgroundTransparency = 1,
        Text = info.icon,
        TextSize = 18,
        Font = Enum.Font.GothamBold
    })

    -- 文字
    local textLabel = new("TextLabel", btn, {
        Name = "BtnText",
        Size = UDim2.new(1, -44, 1, 0),
        Position = UDim2.new(0, 32, 0, 0),
        BackgroundTransparency = 1,
        Text = info.name,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextScaled = false
    })

    -- 颜色条
    local colorBar = new("Frame", btn, {
        Size = UDim2.new(0, 3, 0.6, 0),
        Position = UDim2.new(1, -6, 0.2, 0),
        BackgroundColor3 = info.color,
        BorderSizePixel = 0
    })
    corner(colorBar, 2)

    -- ========== 按钮动画效果 ==========
    local originalColor = Color3.fromRGB(50,50,60)
    local hoverColor = Color3.fromRGB(65,65,80)
    local clickColor = Color3.fromRGB(80,80,100)

    btn.MouseEnter:Connect(function()
        tween(btn, 0.2, {BackgroundColor3 = hoverColor, Size = UDim2.new(1, -4, 0, 40)})
    end)

    btn.MouseLeave:Connect(function()
        tween(btn, 0.2, {BackgroundColor3 = originalColor, Size = UDim2.new(1, -8, 0, 38)})
    end)

    btn.MouseButton1Down:Connect(function()
        tween(btn, 0.1, {BackgroundColor3 = clickColor, Size = UDim2.new(1, -12, 0, 36)})
    end)

    btn.MouseButton1Up:Connect(function()
        tween(btn, 0.15, {BackgroundColor3 = hoverColor, Size = UDim2.new(1, -4, 0, 40)})
    end)

    buttonRefs[info.id] = btn
end

-- ========== 权限控制 ==========
if LocalPlayer.Name ~= AUTHOR_NAME then
    for _, id in ipairs({"markpoint","marklist","serverscripts","switchrole"}) do
        local b = buttonRefs[id]
        if b then b.Visible = false end
    end
end

local datamodBtn = buttonRefs["datamod"]
if datamodBtn and not isVIP then
    local txt = datamodBtn:FindFirstChild("BtnText")
    if txt then txt.Text = "数据修改器 (VIP)" end
    datamodBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
end

-- ========== 展开/收起动画 ==========
local openBtn, animating = nil, false

-- 创建悬浮F按钮
openBtn = new("TextButton", ScreenGui, {
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
corner(openBtn, 14)

-- 展开动画：F按钮缩小→移到中间→淡出，同时主界面从中间放大出现
local function expandUI()
    if animating then return end
    animating = true

    local startPos = openBtn.Position
    local centerPos = UDim2.new(0.5, -25, 0.5, -25)

    -- 阶段1：F按钮缩小并移到屏幕中心
    tween(openBtn, 0.35, {
        Position = centerPos,
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundTransparency = 0.5
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    task.delay(0.35, function()
        -- 阶段2：F按钮淡出
        tween(openBtn, 0.25, {
            BackgroundTransparency = 1,
            TextTransparency = 1
        })

        -- 同时主界面从中心出现
        MainFrame.Position = centerPos
        MainFrame.Size = UDim2.new(0, 60, 0, 50)
        MainFrame.BackgroundTransparency = 1
        MainFrame.Visible = true

        -- 阶段3：主界面放大到正常尺寸
        tween(MainFrame, 0.5, {
            Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2),
            Size = UDim2.new(0, frameWidth, 0, frameHeight),
            BackgroundTransparency = 0.2
        }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        task.delay(0.5, function()
            -- 恢复F按钮状态（隐藏）
            openBtn.Position = startPos
            openBtn.Size = UDim2.new(0, 50, 0, 50)
            openBtn.BackgroundTransparency = 0
            openBtn.TextTransparency = 0
            openBtn.Visible = false
            animating = false
        end)
    end)
end

-- 收起动画：主界面缩小→移到F按钮位置→淡出，同时F按钮出现
local function collapseUI()
    if animating or not MainFrame.Visible then return end
    animating = true

    local targetPos = openBtn.Position
    local centerPos = UDim2.new(0.5, -25, 0.5, -25)

    -- 阶段1：主界面缩小到中心
    tween(MainFrame, 0.35, {
        Position = centerPos,
        Size = UDim2.new(0, 60, 0, 50),
        BackgroundTransparency = 0.8
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    task.delay(0.35, function()
        -- 阶段2：主界面淡出，F按钮出现
        MainFrame.Visible = false
        openBtn.Visible = true
        openBtn.Position = centerPos
        openBtn.Size = UDim2.new(0, 30, 0, 30)
        openBtn.BackgroundTransparency = 1
        openBtn.TextTransparency = 1

        -- F按钮放大回到原位
        tween(openBtn, 0.4, {
            Position = targetPos,
            Size = UDim2.new(0, 50, 0, 50),
            BackgroundTransparency = 0,
            TextTransparency = 0
        }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        task.delay(0.4, function()
            animating = false
        end)
    end)
end

openBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        collapseUI()
    else
        expandUI()
    end
end)

CloseBtn.MouseButton1Click:Connect(collapseUI)

-- 初始显示展开动画
MainFrame.Visible = true
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BackgroundTransparency = 1
tween(MainFrame, 0.6, {
    Size = UDim2.new(0, frameWidth, 0, frameHeight),
    BackgroundTransparency = 0.2
}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- ========== 功能脚本（保留原有功能） ==========
local flySpeed, spinSpeed, orbitSpeed = 50, 20, 3

-- 速度调节
local function createSpeedInput(name, def, cb)
    local row = new("Frame", ScrollFrame, {
        Size = UDim2.new(1, -8, 0, 34),
        BackgroundTransparency = 1
    })
    local label = new("TextLabel", row, {
        Size = UDim2.new(0, 60, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Color3.fromRGB(200,200,200),
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local input = new("TextBox", row, {
        Size = UDim2.new(1, -100, 1, -6),
        Position = UDim2.new(0, 65, 0, 3),
        Text = tostring(def),
        TextColor3 = Color3.fromRGB(0,0,0),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        Font = Enum.Font.Gotham,
        TextSize = 11,
        BorderSizePixel = 0
    })
    corner(input, 4)
    local applyBtn = new("TextButton", row, {
        Size = UDim2.new(0, 32, 1, -6),
        Position = UDim2.new(1, -32, 0, 3),
        BackgroundColor3 = Color3.fromRGB(0,162,255),
        Text = "OK",
        TextColor3 = Color3.fromRGB(255,255,255),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        BorderSizePixel = 0
    })
    corner(applyBtn, 4)
    applyBtn.MouseButton1Click:Connect(function()
        local n = tonumber(input.Text)
        if n then cb(n) end
    end)
end

createSpeedInput("飞行速度", 50, function(v) flySpeed = v end)
createSpeedInput("旋转速度", 20, function(v) spinSpeed = v end)
createSpeedInput("环绕速度", 3, function(v) orbitSpeed = v end)

-- ========== 功能实现 ==========
local flyEnabled = false
local bodyVel, bodyGyro, flyConn

local function enableFly()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    flyEnabled = true
    bodyVel = Instance.new("BodyVelocity", hrp)
    bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVel.Velocity = Vector3.zero
    bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e4
end

local function disableFly()
    flyEnabled = false
    if bodyVel then bodyVel:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    if flyConn then flyConn:Disconnect() end
end

local function flyLoop()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if not hum then return end
    flyConn = RunService.RenderStepped:Connect(function()
        if not flyEnabled or not bodyVel then return end
        local move = hum.MoveDirection
        if move.Magnitude == 0 then bodyVel.Velocity = Vector3.zero return end
        local look = Camera.CFrame.LookVector
        local right = Camera.CFrame.RightVector
        local fwd = move:Dot(look)
        local side = move:Dot(right)
        local vel = Vector3.zero
        if fwd > 0.1 then vel = look * flySpeed
        elseif fwd < -0.1 then vel = Vector3.zero
        elseif math.abs(side) > 0.1 then vel = right * (side > 0 and 1 or -1) * flySpeed end
        bodyVel.Velocity = vel
        if bodyGyro then
            bodyGyro.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, LocalPlayer.Character.HumanoidRootPart.Position + look)
        end
    end)
end

-- 旋转
local spinEnabled = false
local function toggleSpin()
    spinEnabled = not spinEnabled
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    if spinEnabled then
        hum.AutoRotate = false
        local bav = Instance.new("BodyAngularVelocity", hrp)
        bav.Name = "SpinVelocity"
        bav.AngularVelocity = Vector3.new(0, spinSpeed, 0)
        bav.MaxTorque = Vector3.new(0, 9e9, 0)
        hum.PlatformStand = false
    else
        hum.AutoRotate = true
        local bav = hrp:FindFirstChild("SpinVelocity")
        if bav then bav:Destroy() end
    end
end

-- 环绕
local orbitEnabled = false
local orbitConnection, orbitTargetPlayer, orbitAngle = nil, nil, 0

local function stopOrbit()
    orbitEnabled = false
    if orbitConnection then orbitConnection:Disconnect() end
    orbitTargetPlayer = nil
    local ob = buttonRefs["orbit"]
    if ob then
        local txt = ob:FindFirstChild("BtnText")
        if txt then txt.Text = "环绕旋转" end
        ob.BackgroundColor3 = Color3.fromRGB(50,50,60)
    end
end

-- 玩家选择面板
local PlayerSelectFrame = new("Frame", MainFrame, {
    Name = "PlayerSelectFrame",
    Size = UDim2.new(0.75, 0, 0.65, 0),
    Position = UDim2.new(0.125, 0, 0.175, 0),
    BackgroundColor3 = Color3.fromRGB(30,30,35),
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 50
})
corner(PlayerSelectFrame, 12)

local SelectTitle = new("TextLabel", PlayerSelectFrame, {
    Size = UDim2.new(1, 0, 0, 35),
    Position = UDim2.new(0, 0, 0, 5),
    BackgroundTransparency = 1,
    Text = "选择玩家",
    TextColor3 = Color3.fromRGB(255,255,255),
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    ZIndex = 51
})

local SelectCloseBtn = new("TextButton", PlayerSelectFrame, {
    Size = UDim2.new(0, 28, 0, 28),
    Position = UDim2.new(1, -33, 0, 6),
    BackgroundColor3 = Color3.fromRGB(255,70,70),
    Text = "X",
    TextColor3 = Color3.fromRGB(255,255,255),
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    ZIndex = 51
})
corner(SelectCloseBtn, 6)
SelectCloseBtn.MouseButton1Click:Connect(function() PlayerSelectFrame.Visible = false end)

local PlayerScroll = new("ScrollingFrame", PlayerSelectFrame, {
    Size = UDim2.new(1, -12, 1, -50),
    Position = UDim2.new(0, 6, 0, 40),
    BackgroundColor3 = Color3.fromRGB(40,40,48),
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 51
})
corner(PlayerScroll, 8)

local PlayerListLayout = new("UIListLayout", PlayerScroll, {
    Padding = UDim.new(0, 5),
    ZIndex = 51
})

local function refreshPlayerList()
    for _, child in ipairs(PlayerScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local pBtn = new("TextButton", PlayerScroll, {
                Size = UDim2.new(1, -10, 0, 36),
                BackgroundColor3 = Color3.fromRGB(55,55,65),
                Text = player.Name,
                TextColor3 = Color3.fromRGB(255,255,255),
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                BorderSizePixel = 0,
                ZIndex = 51
            })
            corner(pBtn, 6)
            pBtn.MouseButton1Click:Connect(function()
                PlayerSelectFrame.Visible = false
                orbitTargetPlayer = player
                orbitEnabled = true
                orbitAngle = 0
                if orbitConnection then orbitConnection:Disconnect() end
                orbitConnection = RunService.RenderStepped:Connect(function(dt)
                    if not orbitEnabled or not orbitTargetPlayer or not orbitTargetPlayer.Character or not orbitTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        stopOrbit()
                        return
                    end
                    local myChar = LocalPlayer.Character
                    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
                    local myHRP = myChar.HumanoidRootPart
                    local targetHRP = orbitTargetPlayer.Character.HumanoidRootPart
                    orbitAngle = orbitAngle + dt * orbitSpeed
                    local radius = 10
                    myHRP.CFrame = CFrame.new(targetHRP.Position + Vector3.new(math.cos(orbitAngle)*radius, 3, math.sin(orbitAngle)*radius))
                end)
                local ob = buttonRefs["orbit"]
                if ob then
                    local txt = ob:FindFirstChild("BtnText")
                    if txt then txt.Text = "环绕中..." end
                    ob.BackgroundColor3 = Color3.fromRGB(120,40,200)
                end
            end)
        end
    end
end

-- 无头
local headlessEnabled = false
local function toggleHeadless()
    headlessEnabled = not headlessEnabled
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = headlessEnabled and 1 or 0
        for _, v in ipairs(head:GetChildren()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = headlessEnabled and 1 or 0
            end
        end
    end
    local neck = char:FindFirstChild("Neck", true)
    if neck and neck:IsA("Motor6D") then
        neck.Transform = headlessEnabled and CFrame.new(0, -10, 0) or CFrame.new(0, 0, 0)
    end
end

-- 燃烧
local fireEnabled = false
local fireObj
local function toggleFire()
    fireEnabled = not fireEnabled
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if fireEnabled then
        fireObj = Instance.new("Fire", hrp)
        fireObj.Size = 8
        fireObj.Heat = 10
        fireObj.Color = Color3.fromRGB(255, 100, 0)
        fireObj.SecondaryColor = Color3.fromRGB(255, 200, 0)
        local leftFoot = char:FindFirstChild("Left Foot")
        local rightFoot = char:FindFirstChild("Right Foot")
        if leftFoot then
            local f1 = Instance.new("Fire", leftFoot)
            f1.Size = 4; f1.Heat = 5; f1.Color = Color3.fromRGB(255, 50, 0)
            f1.SecondaryColor = Color3.fromRGB(255, 150, 0)
            f1.Name = "ScriptFire"
        end
        if rightFoot then
            local f2 = Instance.new("Fire", rightFoot)
            f2.Size = 4; f2.Heat = 5; f2.Color = Color3.fromRGB(255, 50, 0)
            f2.SecondaryColor = Color3.fromRGB(255, 150, 0)
            f2.Name = "ScriptFire"
        end
    else
        if fireObj then fireObj:Destroy(); fireObj = nil end
        for _, p in ipairs(char:GetDescendants()) do
            if p.Name == "ScriptFire" and p:IsA("Fire") then p:Destroy() end
        end
    end
end

-- 烟雾
local smokeEnabled = false
local function toggleSmoke()
    smokeEnabled = not smokeEnabled
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if smokeEnabled then
        local smoke = Instance.new("Smoke", hrp)
        smoke.Name = "ScriptSmoke"
        smoke.Size = 8; smoke.Opacity = 0.5; smoke.RiseVelocity = 3
        smoke.Color = Color3.fromRGB(80, 80, 80)
        local leftFoot = char:FindFirstChild("Left Foot")
        local rightFoot = char:FindFirstChild("Right Foot")
        if leftFoot then
            local s1 = Instance.new("Smoke", leftFoot)
            s1.Name = "ScriptSmoke"; s1.Size = 4; s1.Opacity = 0.4
            s1.RiseVelocity = 2; s1.Color = Color3.fromRGB(60, 60, 60)
        end
        if rightFoot then
            local s2 = Instance.new("Smoke", rightFoot)
            s2.Name = "ScriptSmoke"; s2.Size = 4; s2.Opacity = 0.4
            s2.RiseVelocity = 2; s2.Color = Color3.fromRGB(60, 60, 60)
        end
    else
        for _, p in ipairs(char:GetDescendants()) do
            if p.Name == "ScriptSmoke" and p:IsA("Smoke") then p:Destroy() end
        end
    end
end

-- 加速
local speedEnabled = false
local originalWalkSpeed = 16
local function toggleSpeed()
    speedEnabled = not speedEnabled
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = speedEnabled and 50 or originalWalkSpeed end
end

-- 跳跃
local jumpEnabled = false
local originalJumpPower = 50
local function toggleJump()
    jumpEnabled = not jumpEnabled
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        hum.JumpPower = jumpEnabled and 150 or originalJumpPower
        hum.UseJumpPower = jumpEnabled
    end
end

-- 穿墙
local noclipEnabled = false
local noclipConn
local function startNoclip()
    noclipConn = RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end)
end
local function stopNoclip()
    if noclipConn then noclipConn:Disconnect() end
    if LocalPlayer.Character then
        for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then startNoclip() else stopNoclip() end
end

-- ESP
local espEnabled = false
local espObjects = {}
local function clearESP()
    for _, obj in ipairs(espObjects) do
        if obj.Parent then obj:Destroy() end
    end
    espObjects = {}
end
local function createESP()
    clearESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hl = Instance.new("Highlight", player.Character)
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.FillTransparency = 0.7
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineTransparency = 0
            table.insert(espObjects, hl)
        end
    end
end

-- 车辆加速
local carboostEnabled = false
local carboostConn
local function enableCarBoost()
    if carboostEnabled then return end
    carboostEnabled = true
    carboostConn = RunService.RenderStepped:Connect(function()
        local seat = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Seat")
        if seat and seat:IsA("VehicleSeat") then
            local vehicle = seat:FindFirstAncestorOfClass("Model")
            if vehicle then
                for _, p in ipairs(vehicle:GetDescendants()) do
                    if p:IsA("Motor") or p:IsA("HingeConstraint") or p:IsA("PrismaticConstraint") then
                        p.Speed = p.MaxSpeed or 1000
                    end
                end
            end
        end
    end)
    local btn = buttonRefs["carboost"]
    if btn then
        local txt = btn:FindFirstChild("BtnText")
        if txt then txt.Text = "车辆加速 (开)" end
        btn.BackgroundColor3 = Color3.fromRGB(200, 120, 0)
    end
end
local function disableCarBoost()
    carboostEnabled = false
    if carboostConn then carboostConn:Disconnect() end
    local btn = buttonRefs["carboost"]
    if btn then
        local txt = btn:FindFirstChild("BtnText")
        if txt then txt.Text = "车辆加速" end
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end
end

-- 快速互动
local instantActionEnabled = false
local function enableInstantAction()
    if instantActionEnabled then return end
    instantActionEnabled = true
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = 0.1
            obj:GetPropertyChangedSignal("HoldDuration"):Connect(function()
                if instantActionEnabled then obj.HoldDuration = 0.1 end
            end)
        end
    end
    workspace.DescendantAdded:Connect(function(obj)
        if instantActionEnabled and obj:IsA("ProximityPrompt") then obj.HoldDuration = 0.1 end
    end)
    task.spawn(function()
        while instantActionEnabled do
            for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
                if gui:IsA("ScreenGui") then
                    for _, obj in ipairs(gui:GetDescendants()) do
                        if (obj.Name == "ProgressBar" or obj.Name == "Fill") and obj:IsA("Frame") then
                            obj.Size = UDim2.new(1, 0, 1, 0)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
    local btn = buttonRefs["instantaction"]
    if btn then
        local txt = btn:FindFirstChild("BtnText")
        if txt then txt.Text = "快速互动 (开)" end
        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 160)
    end
end
local function disableInstantAction()
    instantActionEnabled = false
    local btn = buttonRefs["instantaction"]
    if btn then
        local txt = btn:FindFirstChild("BtnText")
        if txt then txt.Text = "快速互动" end
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end
end

-- 数据修改器
local dataWindow = nil
local function createDataWindow()
    if dataWindow then return end
    dataWindow = new("Frame", ScreenGui, {
        Size = UDim2.new(0, 280, 0, 240),
        Position = UDim2.new(0.5, -140, 0.5, -120),
        BackgroundColor3 = Color3.fromRGB(35, 35, 42),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Visible = false,
        ZIndex = 60
    })
    corner(dataWindow, 10)

    local dwTitle = new("TextLabel", dataWindow, {
        Size = UDim2.new(1, -30, 0, 28),
        Position = UDim2.new(0, 15, 0, 6),
        BackgroundTransparency = 1,
        Text = "数据修改器",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 61
    })

    local dwClose = new("TextButton", dataWindow, {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -28, 0, 6),
        BackgroundColor3 = Color3.fromRGB(255, 70, 70),
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 61
    })
    corner(dwClose, 5)
    dwClose.MouseButton1Click:Connect(function() dataWindow.Visible = false end)

    local dataScroll = new("ScrollingFrame", dataWindow, {
        Size = UDim2.new(1, -10, 1, -40),
        Position = UDim2.new(0, 5, 0, 32),
        BackgroundColor3 = Color3.fromRGB(45, 45, 52),
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 400),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 61
    })

    local dataLayout = new("UIListLayout", dataScroll, { Padding = UDim.new(0, 5), ZIndex = 61 })

    local function addDataRow(parent, labelText, currentValue, applyFunc)
        local row = new("Frame", parent, { Size = UDim2.new(1, -8, 0, 34), BackgroundTransparency = 1, ZIndex = 61 })
        local label = new("TextLabel", row, {
            Size = UDim2.new(0, 75, 1, 0),
            BackgroundTransparency = 1,
            Text = labelText,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 61
        })
        local textBox = new("TextBox", row, {
            Size = UDim2.new(1, -115, 1, -4),
            Position = UDim2.new(0, 80, 0, 2),
            Text = tostring(currentValue),
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.Gotham,
            TextSize = 12,
            BorderSizePixel = 0,
            ZIndex = 61
        })
        corner(textBox, 4)
        local applyBtn = new("TextButton", row, {
            Size = UDim2.new(0, 30, 1, -4),
            Position = UDim2.new(1, -30, 0, 2),
            BackgroundColor3 = Color3.fromRGB(0, 162, 255),
            Text = "OK",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            BorderSizePixel = 0,
            ZIndex = 61
        })
        corner(applyBtn, 3)
        applyBtn.MouseButton1Click:Connect(function() applyFunc(textBox.Text) end)
        return textBox
    end

    local textBoxes = {}
    local function refreshData()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if not hum then return end
        if textBoxes.walk then textBoxes.walk.Text = tostring(hum.WalkSpeed) end
        if textBoxes.jump then textBoxes.jump.Text = tostring(hum.JumpPower) end
        if textBoxes.health then textBoxes.health.Text = tostring(hum.Health) end
        if textBoxes.maxhealth then textBoxes.maxhealth.Text = tostring(hum.MaxHealth) end
        if textBoxes.gravity then textBoxes.gravity.Text = tostring(workspace.Gravity) end
    end

    textBoxes.walk = addDataRow(dataScroll, "移动速度", 16, function(val)
        local num = tonumber(val)
        if num and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = num
        end
    end)
    textBoxes.jump = addDataRow(dataScroll, "跳跃力", 50, function(val)
        local num = tonumber(val)
        if num and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = num
            LocalPlayer.Character.Humanoid.UseJumpPower = true
        end
    end)
    textBoxes.health = addDataRow(dataScroll, "生命值", 100, function(val)
        local num = tonumber(val)
        if num and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = math.max(num, 0.1)
        end
    end)
    textBoxes.maxhealth = addDataRow(dataScroll, "最大生命", 100, function(val)
        local num = tonumber(val)
        if num and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.MaxHealth = num
        end
    end)
    textBoxes.gravity = addDataRow(dataScroll, "重力", 196.2, function(val)
        local num = tonumber(val)
        if num then workspace.Gravity = num end
    end)

    local refreshBtn = new("TextButton", dataScroll, {
        Size = UDim2.new(1, -8, 0, 28),
        Text = "刷新数据",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundColor3 = Color3.fromRGB(100, 100, 100),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        ZIndex = 61
    })
    corner(refreshBtn, 4)
    refreshBtn.MouseButton1Click:Connect(refreshData)
end

-- ========== 按钮事件绑定 ==========
local function setBtnText(id, text)
    local btn = buttonRefs[id]
    if btn then
        local txt = btn:FindFirstChild("BtnText")
        if txt then txt.Text = text end
    end
end

local flyBtn = buttonRefs["fly"]
if flyBtn then
    flyBtn.MouseButton1Click:Connect(function()
        if flyEnabled then
            disableFly()
            setBtnText("fly", "启用飞行")
            flyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        else
            enableFly()
            flyLoop()
            setBtnText("fly", "飞行中...")
            flyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        end
    end)
end

local spinBtn = buttonRefs["spin"]
if spinBtn then
    spinBtn.MouseButton1Click:Connect(function()
        toggleSpin()
        setBtnText("spin", spinEnabled and "旋转中..." or "旋转脚本")
        spinBtn.BackgroundColor3 = spinEnabled and Color3.fromRGB(200, 80, 40) or Color3.fromRGB(50, 50, 60)
    end)
end

local orbitBtn = buttonRefs["orbit"]
if orbitBtn then
    orbitBtn.MouseButton1Click:Connect(function()
        if orbitEnabled then
            stopOrbit()
        else
            refreshPlayerList()
            PlayerSelectFrame.Visible = true
        end
    end)
end

local headlessBtn = buttonRefs["headless"]
if headlessBtn then
    headlessBtn.MouseButton1Click:Connect(function()
        toggleHeadless()
        setBtnText("headless", headlessEnabled and "无头中..." or "无头效果")
        headlessBtn.BackgroundColor3 = headlessEnabled and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(50, 50, 60)
    end)
end

local fireBtn = buttonRefs["fire"]
if fireBtn then
    fireBtn.MouseButton1Click:Connect(function()
        toggleFire()
        setBtnText("fire", fireEnabled and "燃烧中..." or "燃烧效果")
        fireBtn.BackgroundColor3 = fireEnabled and Color3.fromRGB(200, 40, 0) or Color3.fromRGB(50, 50, 60)
    end)
end

local smokeBtn = buttonRefs["smoke"]
if smokeBtn then
    smokeBtn.MouseButton1Click:Connect(function()
        toggleSmoke()
        setBtnText("smoke", smokeEnabled and "冒烟中..." or "烟雾效果")
        smokeBtn.BackgroundColor3 = smokeEnabled and Color3.fromRGB(120, 120, 120) or Color3.fromRGB(50, 50, 60)
    end)
end

local speedBtn = buttonRefs["speed"]
if speedBtn then
    speedBtn.MouseButton1Click:Connect(function()
        toggleSpeed()
        setBtnText("speed", speedEnabled and "加速中..." or "加速脚本")
        speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(200, 170, 0) or Color3.fromRGB(50, 50, 60)
    end)
end

local jumpBtn = buttonRefs["jump"]
if jumpBtn then
    jumpBtn.MouseButton1Click:Connect(function()
        toggleJump()
        setBtnText("jump", jumpEnabled and "超级跳..." or "跳跃增强")
        jumpBtn.BackgroundColor3 = jumpEnabled and Color3.fromRGB(40, 200, 80) or Color3.fromRGB(50, 50, 60)
    end)
end

local noclipBtn = buttonRefs["noclip"]
if noclipBtn then
    noclipBtn.MouseButton1Click:Connect(function()
        toggleNoclip()
        setBtnText("noclip", noclipEnabled and "穿墙中..." or "穿墙脚本")
        noclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(140, 80, 40) or Color3.fromRGB(50, 50, 60)
    end)
end

local espBtn = buttonRefs["esp"]
if espBtn then
    espBtn.MouseButton1Click:Connect(function()
        if espEnabled then
            espEnabled = false
            clearESP()
            setBtnText("esp", "ESP透视")
            espBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        else
            espEnabled = true
            createESP()
            setBtnText("esp", "ESP中...")
            espBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 80)
        end
    end)
end

local carboostBtn = buttonRefs["carboost"]
if carboostBtn then
    carboostBtn.MouseButton1Click:Connect(function()
        if carboostEnabled then disableCarBoost() else enableCarBoost() end
    end)
end

local instantBtn = buttonRefs["instantaction"]
if instantBtn then
    instantBtn.MouseButton1Click:Connect(function()
        if instantActionEnabled then disableInstantAction() else enableInstantAction() end
    end)
end

if datamodBtn then
    datamodBtn.MouseButton1Click:Connect(function()
        if not isVIP then
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {Title = "权限不足", Text = "请升级到VIP", Duration = 3})
            end)
            return
        end
        if not dataWindow then createDataWindow() end
        dataWindow.Visible = not dataWindow.Visible
    end)
end

local permanentBtn = buttonRefs["permanent"]
if permanentBtn then
    permanentBtn.MouseButton1Click:Connect(function()
        if writefile then
            pcall(function() writefile("FScriptHub_Permanent.dat", "1") end)
        else
            Instance.new("BoolValue", CoreGui).Name = "FScriptHubPermanent"
        end
    end)
end

local unpermanentBtn = buttonRefs["unpermanent"]
if unpermanentBtn then
    unpermanentBtn.MouseButton1Click:Connect(function()
        if writefile then pcall(function() delfile("FScriptHub_Permanent.dat") end) end
        local m = CoreGui:FindFirstChild("FScriptHubPermanent")
        if m then m:Destroy() end
    end)
end

local teleportBtn = buttonRefs["teleport"]
if teleportBtn then
    teleportBtn.MouseButton1Click:Connect(function()
        refreshPlayerList()
        PlayerSelectFrame.Visible = true
        for _, b in ipairs(PlayerScroll:GetChildren()) do
            if b:IsA("TextButton") then
                b.MouseButton1Click:Connect(function()
                    local p = Players:FindFirstChild(b.Text)
                    if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local c = LocalPlayer.Character
                        if c and c:FindFirstChild("HumanoidRootPart") then
                            c:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                            PlayerSelectFrame.Visible = false
                        end
                    end
                end)
            end
        end
    end)
end

local marks = {}
local markpointBtn = buttonRefs["markpoint"]
if markpointBtn then
    markpointBtn.MouseButton1Click:Connect(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then marks[#marks+1] = hrp.CFrame end
    end)
end

local marklistBtn = buttonRefs["marklist"]
if marklistBtn then
    marklistBtn.MouseButton1Click:Connect(function()
        if #marks > 0 then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = marks[#marks]
                table.remove(marks, #marks)
            end
        end
    end)
end

local admintoolBtn = buttonRefs["admintool"]
if admintoolBtn then
    admintoolBtn.MouseButton1Click:Connect(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
    end)
end

-- 服务器脚本弹窗
local ServerScriptsWindow = nil
local function createServerScriptsWindow()
    if ServerScriptsWindow then return end
    ServerScriptsWindow = new("Frame", ScreenGui, {
        Name = "ServerScriptsWindow",
        Size = UDim2.new(0, 300, 0, 380),
        Position = UDim2.new(0.5, -150, 0.5, -190),
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Visible = false,
        ZIndex = 70
    })
    corner(ServerScriptsWindow, 12)

    local ssTitle = new("TextLabel", ServerScriptsWindow, {
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1,
        Text = "服务器脚本",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        ZIndex = 71
    })

    local ssClose = new("TextButton", ServerScriptsWindow, {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -33, 0, 6),
        BackgroundColor3 = Color3.fromRGB(255, 70, 70),
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 71
    })
    corner(ssClose, 6)
    ssClose.MouseButton1Click:Connect(function() ServerScriptsWindow.Visible = false end)

    local ssScroll = new("ScrollingFrame", ServerScriptsWindow, {
        Size = UDim2.new(1, -12, 1, -50),
        Position = UDim2.new(0, 6, 0, 40),
        BackgroundColor3 = Color3.fromRGB(40, 40, 48),
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 71
    })
    corner(ssScroll, 8)

    local ssLayout = new("UIListLayout", ssScroll, {
        Padding = UDim.new(0, 5),
        ZIndex = 71
    })

    -- 脚本列表定义
    local BASE_URL = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/"
    local scriptList = {
        {name = "自然灾害", icon = "🌪", color = Color3.fromRGB(255, 100, 50), file = "ziran.lua"},
        {name = "8个球池经典", icon = "🎱", color = Color3.fromRGB(0, 162, 255), file = "scripts/8个球池经典.lua"},
        {name = "99夜", icon = "🌙", color = Color3.fromRGB(100, 50, 200), file = "scripts/99夜.lua"},
        {name = "保护房子不受怪物入侵", icon = "🏠", color = Color3.fromRGB(255, 200, 0), file = "scripts/保护房子不受怪物入侵.lua"},
        {name = "餐厅大亨3", icon = "🍽", color = Color3.fromRGB(255, 150, 50), file = "scripts/餐厅大亨3.lua"},
        {name = "超高速跑者", icon = "🏃", color = Color3.fromRGB(0, 255, 150), file = "scripts/超高速跑者.lua"},
        {name = "超真实CSGO", icon = "🔫", color = Color3.fromRGB(200, 50, 50), file = "scripts/超真实csgo.lua"},
        {name = "沉默的刺客", icon = "🗡", color = Color3.fromRGB(80, 80, 80), file = "scripts/沉默的刺客.lua"},
        {name = "刀刃球", icon = "⚔", color = Color3.fromRGB(255, 80, 80), file = "scripts/刀刃球.lua"},
        {name = "钓鱼模拟器", icon = "🎣", color = Color3.fromRGB(0, 200, 255), file = "scripts/钓鱼模拟器.lua"},
        {name = "犯罪", icon = "🔫", color = Color3.fromRGB(255, 50, 0), file = "scripts/犯罪.lua"},
        {name = "防御", icon = "🛡", color = Color3.fromRGB(50, 150, 255), file = "scripts/防御.lua"},
        {name = "花园地平线", icon = "🌸", color = Color3.fromRGB(255, 150, 200), file = "scripts/花园地平线.lua"},
        {name = "滑石头RNG", icon = "🪨", color = Color3.fromRGB(180, 130, 80), file = "scripts/滑石头RNG.lua"},
    }

    -- 按钮悬停效果
    local function addHoverEffect(btn)
        local originalColor = btn.BackgroundColor3
        btn.MouseEnter:Connect(function()
            tween(btn, 0.2, {BackgroundColor3 = Color3.fromRGB(70, 70, 85)})
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, 0.2, {BackgroundColor3 = originalColor})
        end)
    end

    -- 创建每个脚本按钮
    for _, scriptInfo in ipairs(scriptList) do
        local sBtn = new("TextButton", ssScroll, {
            Size = UDim2.new(1, -10, 0, 38),
            BackgroundColor3 = Color3.fromRGB(55, 55, 65),
            Text = "",
            BorderSizePixel = 0,
            ZIndex = 72
        })
        corner(sBtn, 8)

        local sIcon = new("TextLabel", sBtn, {
            Size = UDim2.new(0, 26, 0, 26),
            Position = UDim2.new(0, 7, 0, 6),
            BackgroundTransparency = 1,
            Text = scriptInfo.icon,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            ZIndex = 73
        })

        local sText = new("TextLabel", sBtn, {
            Size = UDim2.new(1, -42, 1, 0),
            Position = UDim2.new(0, 34, 0, 0),
            BackgroundTransparency = 1,
            Text = scriptInfo.name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 73
        })

        local sColor = new("Frame", sBtn, {
            Size = UDim2.new(0, 3, 0.6, 0),
            Position = UDim2.new(1, -6, 0.2, 0),
            BackgroundColor3 = scriptInfo.color,
            BorderSizePixel = 0,
            ZIndex = 73
        })
        corner(sColor, 2)

        addHoverEffect(sBtn)

        sBtn.MouseButton1Click:Connect(function()
            pcall(function()
                loadstring(game:HttpGet(BASE_URL .. scriptInfo.file))()
            end)
            -- 清理其他脚本的FPS显示
            task.delay(2, function()
                pcall(function()
                    for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
                        if gui:IsA("ScreenGui") and gui.Name ~= "FScriptHub" then
                            for _, obj in ipairs(gui:GetDescendants()) do
                                if obj:IsA("TextLabel") and (obj.Name:lower():match("fps") or obj.Text:lower():match("fps")) then
                                    obj:Destroy()
                                end
                            end
                        end
                    end
                end)
                pcall(function()
                    for _, gui in ipairs(CoreGui:GetChildren()) do
                        if gui:IsA("ScreenGui") and gui.Name ~= "FScriptHub" then
                            for _, obj in ipairs(gui:GetDescendants()) do
                                if obj:IsA("TextLabel") and (obj.Name:lower():match("fps") or obj.Text:lower():match("fps")) then
                                    obj:Destroy()
                                end
                            end
                        end
                    end
                end)
            end)
            ServerScriptsWindow.Visible = false
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "服务器脚本",
                    Text = scriptInfo.name .. " 已加载",
                    Duration = 3
                })
            end)
        end)
    end
end

local serverscriptsBtn = buttonRefs["serverscripts"]
if serverscriptsBtn then
    serverscriptsBtn.MouseButton1Click:Connect(function()
        if not ServerScriptsWindow then createServerScriptsWindow() end
        ServerScriptsWindow.Visible = not ServerScriptsWindow.Visible
    end)
end

local ratio43Btn = buttonRefs["ratio43"]
if ratio43Btn then
    ratio43Btn.MouseButton1Click:Connect(function()
        Camera.FieldOfView = Camera.FieldOfView == 60 and 70 or 60
        setBtnText("ratio43", Camera.FieldOfView == 60 and "4:3比例 (开)" or "4:3比例")
    end)
end

local ultrawideBtn = buttonRefs["ultrawide"]
if ultrawideBtn then
    ultrawideBtn.MouseButton1Click:Connect(function()
        Camera.FieldOfView = Camera.FieldOfView == 100 and 70 or 100
        setBtnText("ultrawide", Camera.FieldOfView == 100 and "超广角 (开)" or "超广角")
    end)
end

local switchroleBtn = buttonRefs["switchrole"]
if switchroleBtn then
    switchroleBtn.MouseButton1Click:Connect(function()
        local selectFrame = new("Frame", ScreenGui, {
            Size = UDim2.new(0, 180, 0, 120),
            Position = UDim2.new(0.5, -90, 0.5, -60),
            BackgroundColor3 = Color3.fromRGB(35, 35, 42),
            BorderSizePixel = 0,
            Active = true,
            Draggable = true,
            ZIndex = 55
        })
        corner(selectFrame, 8)

        local lbl = new("TextLabel", selectFrame, {
            Size = UDim2.new(1, 0, 0, 25),
            Position = UDim2.new(0, 0, 0, 5),
            BackgroundTransparency = 1,
            Text = "选择身份",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 15,
            Font = Enum.Font.GothamBold,
            ZIndex = 56
        })

        local options = {
            {name = "作者", role = "author", col = Color3.fromRGB(255, 215, 0)},
            {name = "VIP", role = "vip", col = Color3.fromRGB(0, 255, 150)},
            {name = "普通用户", role = "normal", col = Color3.fromRGB(200, 200, 200)},
        }

        for i, opt in ipairs(options) do
            local optBtn = new("TextButton", selectFrame, {
                Size = UDim2.new(1, -20, 0, 26),
                Position = UDim2.new(0, 10, 0, 32 + (i-1) * 28),
                BackgroundColor3 = opt.col,
                Text = opt.name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                BorderSizePixel = 0,
                ZIndex = 56
            })
            corner(optBtn, 4)
            optBtn.MouseButton1Click:Connect(function()
                currentRole = opt.role
                isAuthor = currentRole == "author"
                isVIP = currentRole == "author" or currentRole == "vip"
                RoleLabel.Text = opt.name
                RoleLabel.TextColor3 = opt.col
                if datamodBtn then
                    if isVIP then
                        setBtnText("datamod", "数据修改器")
                        datamodBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                    else
                        setBtnText("datamod", "数据修改器 (VIP)")
                        datamodBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    end
                end
                selectFrame:Destroy()
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "身份切换",
                        Text = "已切换为 " .. opt.name,
                        Duration = 3
                    })
                end)
            end)
        end
    end)
end

local sponsorBtn = buttonRefs["sponsor"]
if sponsorBtn then
    sponsorBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(IMAGE_URL) end)
    end)
end

-- ========== 重生恢复 ==========
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if flyEnabled then disableFly(); task.wait(0.5); enableFly(); flyLoop() end
    if spinEnabled then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bav = Instance.new("BodyAngularVelocity", hrp)
            bav.Name = "SpinVelocity"
            bav.AngularVelocity = Vector3.new(0, spinSpeed, 0)
            bav.MaxTorque = Vector3.new(0, 9e9, 0)
        end
    end
    if noclipEnabled then stopNoclip(); task.wait(0.5); startNoclip() end
    if espEnabled then task.wait(1); createESP() end
end)

-- ========== FPS显示 ==========
local fpsLabel = nil
local function createFPSDisplay()
    fpsLabel = new("TextLabel", ScreenGui, {
        Name = "FPSLabel",
        Size = UDim2.new(0, 80, 0, 22),
        Position = UDim2.new(1, -90, 0, 5),
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        BackgroundTransparency = 0.3,
        Text = "FPS: 60",
        TextColor3 = Color3.fromRGB(0, 255, 100),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        ZIndex = 200
    })
    corner(fpsLabel, 6)

    local fpsStroke = new("UIStroke", fpsLabel, {
        Thickness = 1,
        Transparency = 0.5,
        Color = Color3.fromRGB(0, 255, 100)
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
                    fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                    fpsStroke.Color = Color3.fromRGB(0, 255, 100)
                elseif fps >= 30 then
                    fpsLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
                    fpsStroke.Color = Color3.fromRGB(255, 220, 0)
                else
                    fpsLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
                    fpsStroke.Color = Color3.fromRGB(255, 70, 70)
                end
            end
        end
    end)
end
createFPSDisplay()

-- ========== 解除帧率限制 ==========
local fpsUnlocked = false
local function unlockFPS()
    fpsUnlocked = true
    pcall(function()
        setfpscap(999)
    end)
    pcall(function()
        if settings then
            settings().Rendering.FrameRateManager = 999
        end
    end)
end

-- 自动解除帧率限制
unlockFPS()

-- ========== 完成通知 ==========
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "F脚本中心",
        Text = "v5.1 已加载 | FPS已解锁",
        Duration = 4
    })
end)
