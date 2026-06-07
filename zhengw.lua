-- ============================================
-- F脚本中心 - 正式版 v5.0 (速度调节 + 传送)
-- 全部功能完整版
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

-- ★ 配置
local AUTHOR_NAME = "noobnewfggg"
local IMAGE_URL = "https://i.imgur.com/h35hvJb.png"
local VIP_USERS = { ["sbcnm229"] = true }

-- 身份
local isAuthor = (LocalPlayer.Name == AUTHOR_NAME)
local isVIP = VIP_USERS[LocalPlayer.UserId] or VIP_USERS[LocalPlayer.Name] or false
local roleText, roleColor
if isAuthor then roleText="👑 作者"; roleColor=Color3.fromRGB(255,215,0)
elseif isVIP then roleText="🌟 VIP用户"; roleColor=Color3.fromRGB(255,215,0)
else roleText="普通用户"; roleColor=Color3.fromRGB(200,200,200) end

-- 启动通知
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "F脚本中心 v5.0",
    Text = isAuthor and "欢迎 F脚本作者" or "欢迎使用，作者："..AUTHOR_NAME,
    Duration = 5
})

-- 启动大字 (作者/VIP)
if isAuthor or isVIP then
    spawn(function()
        local msg = isAuthor and "👑 作者大大，欢迎回来！" or "🌟 VIP 用户，欢迎使用！"
        local col = isAuthor and Color3.fromRGB(255,0,0) or Color3.fromRGB(255,215,0)
        local lab = Instance.new("TextLabel", LocalPlayer.PlayerGui)
        lab.BackgroundTransparency=1; lab.Text=msg; lab.TextColor3=col; lab.Font=Enum.Font.GothamBlack
        lab.TextSize=50; lab.TextStrokeTransparency=0.5; lab.TextStrokeColor3=Color3.fromRGB(0,0,0)
        lab.Size=UDim2.new(1,0,1,0); lab.Position=UDim2.new(0,0,0,0); lab.ZIndex=10
        TweenService:Create(lab, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency=1, TextStrokeTransparency=1
        }):Play()
        task.delay(4, function() if lab.Parent then lab:Destroy() end end)
    end)
end

-- ============================================
-- 清理旧界面
-- ============================================
if CoreGui:FindFirstChild("FScriptHub") then CoreGui.FScriptHub:Destroy() end
if LocalPlayer.PlayerGui:FindFirstChild("FScriptHub") then LocalPlayer.PlayerGui.FScriptHub:Destroy() end

-- ============================================
-- 永久存在检测 (文件优先)
-- ============================================
local permanentFile = "FScriptHub_Permanent.dat"
local isPermanent = false
if writefile and readfile then
    local success, content = pcall(function() return readfile(permanentFile) end)
    if success and content == "1" then isPermanent = true end
else
    isPermanent = (CoreGui:FindFirstChild("FScriptHubPermanent") ~= nil)
end

if isPermanent then
    spawn(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "F脚本中心", Text = "脚本已自动加载", Duration = 5
        })
        local lab = Instance.new("TextLabel", LocalPlayer.PlayerGui)
        lab.BackgroundTransparency=1; lab.Text="脚本已自动加载"; lab.TextColor3=Color3.fromRGB(0,255,0)
        lab.Font=Enum.Font.GothamBlack; lab.TextSize=40; lab.TextStrokeTransparency=0.5
        lab.Size=UDim2.new(1,0,1,0); lab.Position=UDim2.new(0,0,0,0); lab.ZIndex=10
        game:GetService("Debris"):AddItem(lab, 3)
    end)
end

-- ============================================
-- 创建主界面
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FScriptHub"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 520, 0, 420)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Visible = isPermanent
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)

-- 炫彩边框
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 3; MainStroke.Transparency = 0.2
coroutine.wrap(function()
    while MainStroke and MainStroke.Parent do
        MainStroke.Color = Color3.fromHSV((tick()*0.5)%1, 1, 1)
        RunService.RenderStepped:Wait()
    end
end)()

-- F图标
local FIcon = Instance.new("TextLabel", MainFrame)
FIcon.Size = UDim2.new(0,60,0,60); FIcon.Position = UDim2.new(0,15,0,10)
FIcon.BackgroundColor3 = Color3.fromRGB(0,162,255); FIcon.Text = "F"
FIcon.TextColor3 = Color3.fromRGB(255,255,255); FIcon.TextSize = 36; FIcon.Font = Enum.Font.GothamBlack
Instance.new("UICorner", FIcon).CornerRadius = UDim.new(0,10)

-- 标题
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(0,200,0,30); TitleLabel.Position = UDim2.new(0,85,0,15)
TitleLabel.BackgroundTransparency=1; TitleLabel.Text="脚本中心"
TitleLabel.TextColor3=Color3.fromRGB(255,255,255); TitleLabel.TextSize=22; TitleLabel.Font=Enum.Font.GothamBold

local SubTitle = Instance.new("TextLabel", MainFrame)
SubTitle.Size = UDim2.new(0,200,0,18); SubTitle.Position = UDim2.new(0,85,0,45)
SubTitle.BackgroundTransparency=1; SubTitle.Text="v5.0 速度调节版"
SubTitle.TextColor3=Color3.fromRGB(150,150,160); SubTitle.TextSize=12; SubTitle.Font=Enum.Font.Gotham

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size=UDim2.new(0,30,0,30); CloseBtn.Position=UDim2.new(1,-40,0,10)
CloseBtn.BackgroundColor3=Color3.fromRGB(255,70,70); CloseBtn.Text="✕"; CloseBtn.TextColor3=Color3.fromRGB(255,255,255)
CloseBtn.TextSize=16; CloseBtn.Font=Enum.Font.GothamBold; CloseBtn.BorderSizePixel=0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,8)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- 右侧滑动栏
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(0, 180, 1, -80)
ScrollFrame.Position = UDim2.new(1, -195, 0, 70)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(35,35,42)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1400)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", ScrollFrame).CornerRadius = UDim.new(0,8)
local ScrollLayout = Instance.new("UIListLayout", ScrollFrame)
ScrollLayout.Padding = UDim.new(0, 8)
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 左侧内容区
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -210, 1, -80)
ContentFrame.Position = UDim2.new(0, 10, 0, 70)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35,35,42)
ContentFrame.BorderSizePixel = 0
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0,8)

-- 玩家信息面板
local PlayerInfoFrame = Instance.new("Frame", ContentFrame)
PlayerInfoFrame.Size = UDim2.new(1,-10,0,80); PlayerInfoFrame.Position = UDim2.new(0,5,0,5)
PlayerInfoFrame.BackgroundColor3=Color3.fromRGB(45,45,52); PlayerInfoFrame.BorderSizePixel=0
Instance.new("UICorner", PlayerInfoFrame).CornerRadius = UDim.new(0,8)

local AvatarImage = Instance.new("ImageLabel", PlayerInfoFrame)
AvatarImage.Size=UDim2.new(0,60,0,60); AvatarImage.Position=UDim2.new(0,10,0,10); AvatarImage.BackgroundTransparency=1
coroutine.wrap(function()
    local userId = LocalPlayer.UserId
    local content = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    AvatarImage.Image = content
end)()

local NameLabel = Instance.new("TextLabel", PlayerInfoFrame)
NameLabel.Size=UDim2.new(1,-80,0,22); NameLabel.Position=UDim2.new(0,80,0,10)
NameLabel.BackgroundTransparency=1; NameLabel.Text=LocalPlayer.DisplayName.." (@"..LocalPlayer.Name..")"
NameLabel.TextColor3=Color3.fromRGB(255,255,255); NameLabel.TextSize=16; NameLabel.Font=Enum.Font.GothamBold

local RoleLabel = Instance.new("TextLabel", PlayerInfoFrame)
RoleLabel.Size=UDim2.new(1,-80,0,18); RoleLabel.Position=UDim2.new(0,80,0,35)
RoleLabel.BackgroundTransparency=1; RoleLabel.Text=roleText; RoleLabel.TextColor3=roleColor; RoleLabel.TextSize=14; RoleLabel.Font=Enum.Font.Gotham

local TimeLabel = Instance.new("TextLabel", PlayerInfoFrame)
TimeLabel.Size=UDim2.new(1,-80,0,18); TimeLabel.Position=UDim2.new(0,80,0,55)
TimeLabel.BackgroundTransparency=1; TimeLabel.TextColor3=Color3.fromRGB(180,180,255); TimeLabel.TextSize=13; TimeLabel.Font=Enum.Font.Gotham
coroutine.wrap(function() while TimeLabel and TimeLabel.Parent do TimeLabel.Text = os.date("%Y-%m-%d %H:%M:%S"); task.wait(1) end end)()

local WelcomeLabel = Instance.new("TextLabel", ContentFrame)
WelcomeLabel.Size=UDim2.new(1,-20,0,30); WelcomeLabel.Position=UDim2.new(0,10,0,90)
WelcomeLabel.BackgroundTransparency=1; WelcomeLabel.Text="欢迎使用 F脚本中心"; WelcomeLabel.TextColor3=Color3.fromRGB(255,255,255); WelcomeLabel.TextSize=16; WelcomeLabel.Font=Enum.Font.GothamBold

local InfoLabel = Instance.new("TextLabel", ContentFrame)
InfoLabel.Size=UDim2.new(1,-20,0,80); InfoLabel.Position=UDim2.new(0,10,0,125)
InfoLabel.BackgroundTransparency=1; InfoLabel.Text="作者: "..AUTHOR_NAME.."\n飞行/旋转/环绕速度可调\n传送：选择玩家后传送"
InfoLabel.TextColor3=Color3.fromRGB(150,150,160); InfoLabel.TextSize=12; InfoLabel.Font=Enum.Font.Gotham; InfoLabel.TextWrapped=true

-- 环绕选择面板
local PlayerSelectFrame = Instance.new("Frame", MainFrame)
PlayerSelectFrame.Name="PlayerSelectFrame"; PlayerSelectFrame.Size=UDim2.new(1,-20,1,-20); PlayerSelectFrame.Position=UDim2.new(0,10,0,10)
PlayerSelectFrame.BackgroundColor3=Color3.fromRGB(30,30,35); PlayerSelectFrame.BorderSizePixel=0; PlayerSelectFrame.Visible=false
Instance.new("UICorner", PlayerSelectFrame).CornerRadius=UDim.new(0,12)
local SelectTitle = Instance.new("TextLabel", PlayerSelectFrame)
SelectTitle.Size=UDim2.new(1,0,0,40); SelectTitle.Position=UDim2.new(0,0,0,10); SelectTitle.BackgroundTransparency=1; SelectTitle.Text="选择玩家"; SelectTitle.TextColor3=Color3.fromRGB(255,255,255); SelectTitle.TextSize=20; SelectTitle.Font=Enum.Font.GothamBold
local SelectCloseBtn = Instance.new("TextButton", PlayerSelectFrame)
SelectCloseBtn.Size=UDim2.new(0,30,0,30); SelectCloseBtn.Position=UDim2.new(1,-40,0,10); SelectCloseBtn.BackgroundColor3=Color3.fromRGB(255,70,70); SelectCloseBtn.Text="✕"; SelectCloseBtn.TextColor3=Color3.fromRGB(255,255,255); SelectCloseBtn.TextSize=16; SelectCloseBtn.Font=Enum.Font.GothamBold; SelectCloseBtn.BorderSizePixel=0
Instance.new("UICorner", SelectCloseBtn).CornerRadius=UDim.new(0,8)
SelectCloseBtn.MouseButton1Click:Connect(function() PlayerSelectFrame.Visible = false end)
local PlayerScroll = Instance.new("ScrollingFrame", PlayerSelectFrame)
PlayerScroll.Size=UDim2.new(1,-20,1,-60); PlayerScroll.Position=UDim2.new(0,10,0,55)
PlayerScroll.BackgroundColor3=Color3.fromRGB(40,40,48); PlayerScroll.BorderSizePixel=0; PlayerScroll.ScrollBarThickness=6; PlayerScroll.CanvasSize=UDim2.new(0,0,0,0); PlayerScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
local PlayerListLayout = Instance.new("UIListLayout", PlayerScroll); PlayerListLayout.Padding=UDim.new(0,5)

-- ============================================
-- 功能按钮列表
-- ============================================
local scripts = {
    {name = "✈️ 启用飞行", color = Color3.fromRGB(0,162,255), id = "fly"},
    {name = "🔄 旋转脚本", color = Color3.fromRGB(255,100,50), id = "spin"},
    {name = "🌀 环绕旋转", color = Color3.fromRGB(150,50,255), id = "orbit"},
    {name = "👻 无头效果", color = Color3.fromRGB(100,100,100), id = "headless"},
    {name = "🔥 燃烧效果", color = Color3.fromRGB(255,50,0), id = "fire"},
    {name = "💨 烟雾效果", color = Color3.fromRGB(150,150,150), id = "smoke"},
    {name = "⚡ 加速脚本", color = Color3.fromRGB(255,220,0), id = "speed"},
    {name = "🦘 跳跃增强", color = Color3.fromRGB(50,255,100), id = "jump"},
    {name = "🧱 穿墙脚本", color = Color3.fromRGB(180,100,50), id = "noclip"},
    {name = "👁️ ESP透视", color = Color3.fromRGB(255,50,100), id = "esp"},
    {name = "🚗 车辆加速", color = Color3.fromRGB(255,165,0), id = "carboost"},
    {name = "⚡ 快速互动", color = Color3.fromRGB(0,255,200), id = "instantaction"},
    {name = "📊 数据修改器", color = Color3.fromRGB(180,100,255), id = "datamod"},
    {name = "💾 永久存在", color = Color3.fromRGB(255,200,100), id = "permanent"},
    {name = "❌ 取消永久", color = Color3.fromRGB(255,100,100), id = "unpermanent"},
    {name = "📌 传送玩家", color = Color3.fromRGB(0,255,100), id = "teleport"},
    {name = "💰 赞助作者", color = Color3.fromRGB(255,215,0), id = "sponsor"},
}

-- 创建按钮
for i, info in ipairs(scripts) do
    local btn = Instance.new("TextButton")
    btn.Name = info.id .. "Btn"
    btn.Parent = ScrollFrame
    btn.Size = UDim2.new(1, -16, 0, 40)
    btn.Position = UDim2.new(0, 8, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,55)
    btn.Text = info.name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.LayoutOrder = i
    btn.AutoButtonColor = false

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    local colorBar = Instance.new("Frame", btn)
    colorBar.Size = UDim2.new(0,4,1,0); colorBar.BackgroundColor3 = info.color; colorBar.BorderSizePixel = 0
    Instance.new("UICorner", colorBar).CornerRadius = UDim.new(0,8)

    local enterTween = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -10, 0, 44)})
    local leaveTween = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -16, 0, 40)})
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55,55,70)}):Play()
        enterTween:Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45,45,55)}):Play()
        leaveTween:Play()
    end)
end

-- 数据修改器VIP限制
local datamodBtn = ScrollFrame:FindFirstChild("datamodBtn")
if datamodBtn and not (isAuthor or isVIP) then
    datamodBtn.Text = "📊 数据修改器 (VIP)"
    datamodBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    datamodBtn.TextColor3 = Color3.fromRGB(180,180,180)
end

-- ============================================
-- 速度调节输入框
-- ============================================
local flySpeed = 50
local spinSpeed = 20
local orbitSpeed = 3

local function createSpeedInput(name, defaultValue, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -16, 0, 36)
    row.BackgroundTransparency = 1
    row.Parent = ScrollFrame

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0, 60, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham

    local input = Instance.new("TextBox", row)
    input.Size = UDim2.new(1, -120, 1, -4)
    input.Position = UDim2.new(0, 65, 0, 2)
    input.Text = tostring(defaultValue)
    input.TextColor3 = Color3.fromRGB(0,0,0)
    input.BackgroundColor3 = Color3.fromRGB(255,255,255)
    input.Font = Enum.Font.Gotham
    input.TextSize = 13
    input.BorderSizePixel = 0

    local applyBtn = Instance.new("TextButton", row)
    applyBtn.Size = UDim2.new(0, 40, 1, -4)
    applyBtn.Position = UDim2.new(1, -40, 0, 2)
    applyBtn.BackgroundColor3 = Color3.fromRGB(0,162,255)
    applyBtn.Text = "应用"
    applyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 13
    applyBtn.BorderSizePixel = 0
    Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0,4)

    applyBtn.MouseButton1Click:Connect(function()
        local num = tonumber(input.Text)
        if num then callback(num) end
    end)
end

createSpeedInput("飞行速度", 50, function(v) flySpeed = v end)
createSpeedInput("旋转速度", 20, function(v)
    spinSpeed = v
    if spinEnabled then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local bav = hrp and hrp:FindFirstChild("SpinVelocity")
        if bav then bav.AngularVelocity = Vector3.new(0, v, 0) end
    end
end)
createSpeedInput("环绕速度", 3, function(v) orbitSpeed = v end)

-- ============================================
-- 飞行系统
-- ============================================
local flyEnabled = false
local bodyVelocity, bodyGyro
local flyConnection

local function enableFly()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    flyEnabled = true
    bodyVelocity = Instance.new("BodyVelocity"); bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9); bodyVelocity.Velocity = Vector3.new(0,0,0); bodyVelocity.Parent = hrp
    bodyGyro = Instance.new("BodyGyro"); bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9); bodyGyro.P = 9e4; bodyGyro.Parent = hrp
end

local function disableFly()
    flyEnabled = false
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
end

local function setupFlyMovement()
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChild("Humanoid"); if not hum then return end
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled or not bodyVelocity then return end
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude == 0 then bodyVelocity.Velocity = Vector3.new(0,0,0) return end
        local look = Camera.CFrame.LookVector
        local right = Camera.CFrame.RightVector
        bodyVelocity.Velocity = look * moveDir.Z * flySpeed + right * moveDir.X * flySpeed
        if bodyGyro and char:FindFirstChild("HumanoidRootPart") then
            bodyGyro.CFrame = CFrame.new(char.HumanoidRootPart.Position, char.HumanoidRootPart.Position + look)
        end
    end)
end

local flyBtn = ScrollFrame:FindFirstChild("flyBtn")
if flyBtn then
    flyBtn.MouseButton1Click:Connect(function()
        if flyEnabled then
            disableFly()
            flyBtn.Text = "✈️ 启用飞行"; flyBtn.BackgroundColor3 = Color3.fromRGB(45,45,55)
            WelcomeLabel.Text = "飞行已关闭"
        else
            enableFly(); setupFlyMovement()
            flyBtn.Text = "✈️ 飞行中..."; flyBtn.BackgroundColor3 = Color3.fromRGB(0,120,200)
            WelcomeLabel.Text = "飞行已开启！"
        end
    end)
end

-- ============================================
-- 旋转脚本
-- ============================================
local spinEnabled = false
local function toggleSpin()
    spinEnabled = not spinEnabled
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if spinEnabled then
        local bav = Instance.new("BodyAngularVelocity"); bav.Name = "SpinVelocity"; bav.AngularVelocity = Vector3.new(0, spinSpeed, 0); bav.MaxTorque = Vector3.new(0,9e9,0); bav.Parent = hrp
    else
        local bav = hrp:FindFirstChild("SpinVelocity"); if bav then bav:Destroy() end
    end
end
local spinBtn = ScrollFrame:FindFirstChild("spinBtn")
if spinBtn then
    spinBtn.MouseButton1Click:Connect(function()
        toggleSpin()
        spinBtn.Text = spinEnabled and "🔄 旋转中..." or "🔄 旋转脚本"
        spinBtn.BackgroundColor3 = spinEnabled and Color3.fromRGB(200,80,40) or Color3.fromRGB(45,45,55)
        WelcomeLabel.Text = spinEnabled and "旋转已开启" or "旋转已关闭"
    end)
end

-- ============================================
-- 环绕旋转
-- ============================================
local orbitEnabled = false
local orbitConnection
local orbitTargetPlayer = nil
local orbitAngle = 0

local function stopOrbit()
    orbitEnabled = false
    if orbitConnection then orbitConnection:Disconnect(); orbitConnection = nil end
    orbitTargetPlayer = nil
    local orbitBtn = ScrollFrame:FindFirstChild("orbitBtn")
    if orbitBtn then orbitBtn.Text = "🌀 环绕旋转"; orbitBtn.BackgroundColor3 = Color3.fromRGB(45,45,55) end
    WelcomeLabel.Text = "环绕旋转已关闭"
end

local function refreshPlayerList()
    for _, child in ipairs(PlayerScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, -10, 0, 40); pBtn.BackgroundColor3 = Color3.fromRGB(55,55,65)
            pBtn.Text = player.Name; pBtn.TextColor3 = Color3.fromRGB(255,255,255); pBtn.TextSize = 14; pBtn.Font = Enum.Font.GothamBold; pBtn.BorderSizePixel = 0
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0,8)
            pBtn.MouseButton1Click:Connect(function()
                PlayerSelectFrame.Visible = false
                orbitTargetPlayer = player; orbitEnabled = true; orbitAngle = 0
                if orbitConnection then orbitConnection:Disconnect() end
                orbitConnection = RunService.RenderStepped:Connect(function(dt)
                    if not orbitEnabled or not orbitTargetPlayer or not orbitTargetPlayer.Character or not orbitTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        stopOrbit(); return
                    end
                    local myChar = LocalPlayer.Character; if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
                    local myHRP = myChar.HumanoidRootPart
                    local targetHRP = orbitTargetPlayer.Character.HumanoidRootPart
                    orbitAngle = orbitAngle + dt * orbitSpeed
                    local radius = 10
                    myHRP.CFrame = CFrame.new(targetHRP.Position + Vector3.new(math.cos(orbitAngle)*radius, 3, math.sin(orbitAngle)*radius))
                end)
                local orbitBtn = ScrollFrame:FindFirstChild("orbitBtn")
                if orbitBtn then orbitBtn.Text = "🌀 环绕中..."; orbitBtn.BackgroundColor3 = Color3.fromRGB(120,40,200) end
                WelcomeLabel.Text = "环绕: " .. player.Name
            end)
            pBtn.Parent = PlayerScroll
        end
    end
end

local orbitBtn = ScrollFrame:FindFirstChild("orbitBtn")
if orbitBtn then
    orbitBtn.MouseButton1Click:Connect(function()
        if orbitEnabled then stopOrbit(); return end
        refreshPlayerList(); PlayerSelectFrame.Visible = true
    end)
end

-- ============================================
-- 传送功能
-- ============================================
local teleportBtn = ScrollFrame:FindFirstChild("teleportBtn")
if teleportBtn then
    teleportBtn.MouseButton1Click:Connect(function()
        refreshPlayerList()
        -- 修改每个玩家按钮的点击事件为传送
        for _, btn in ipairs(PlayerScroll:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.MouseButton1Click:Connect(function()
                    local player = Players:FindFirstChild(btn.Text)
                    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                            PlayerSelectFrame.Visible = false
                        end
                    end
                end)
            end
        end
        PlayerSelectFrame.Visible = true
    end)
end

-- ============================================
-- 无头效果
-- ============================================
local headlessEnabled = false
local function toggleHeadless()
    headlessEnabled = not headlessEnabled
    local char = LocalPlayer.Character; if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = headlessEnabled and 1 or 0
        for _, v in ipairs(head:GetChildren()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = headlessEnabled and 1 or 0 end end
    end
    local neck = char:FindFirstChild("Neck", true)
    if neck and neck:IsA("Motor6D") then neck.Transform = headlessEnabled and CFrame.new(0, -10, 0) or CFrame.new(0,0,0) end
end
local headlessBtn = ScrollFrame:FindFirstChild("headlessBtn")
if headlessBtn then
    headlessBtn.MouseButton1Click:Connect(function()
        toggleHeadless()
        headlessBtn.Text = headlessEnabled and "👻 无头中..." or "👻 无头效果"
        headlessBtn.BackgroundColor3 = headlessEnabled and Color3.fromRGB(80,80,80) or Color3.fromRGB(45,45,55)
        WelcomeLabel.Text = headlessEnabled and "无头效果已开启" or "无头效果已关闭"
    end)
end

-- ============================================
-- 燃烧效果
-- ============================================
local fireEnabled = false
local fireObj
local function toggleFire()
    fireEnabled = not fireEnabled
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if fireEnabled then
        fireObj = Instance.new("Fire"); fireObj.Size = 8; fireObj.Heat = 10; fireObj.Color = Color3.fromRGB(255,100,0); fireObj.SecondaryColor = Color3.fromRGB(255,200,0); fireObj.Parent = hrp
        local leftFoot = char:FindFirstChild("Left Foot"); local rightFoot = char:FindFirstChild("Right Foot")
        if leftFoot then local f1 = Instance.new("Fire"); f1.Size = 4; f1.Heat = 5; f1.Color = Color3.fromRGB(255,50,0); f1.SecondaryColor = Color3.fromRGB(255,150,0); f1.Name = "ScriptFire"; f1.Parent = leftFoot end
        if rightFoot then local f2 = Instance.new("Fire"); f2.Size = 4; f2.Heat = 5; f2.Color = Color3.fromRGB(255,50,0); f2.SecondaryColor = Color3.fromRGB(255,150,0); f2.Name = "ScriptFire"; f2.Parent = rightFoot end
    else
        if fireObj then fireObj:Destroy(); fireObj = nil end
        for _, part in ipairs(char:GetDescendants()) do if part.Name == "ScriptFire" and part:IsA("Fire") then part:Destroy() end end
    end
end
local fireBtn = ScrollFrame:FindFirstChild("fireBtn")
if fireBtn then
    fireBtn.MouseButton1Click:Connect(function()
        toggleFire()
        fireBtn.Text = fireEnabled and "🔥 燃烧中..." or "🔥 燃烧效果"
        fireBtn.BackgroundColor3 = fireEnabled and Color3.fromRGB(200,40,0) or Color3.fromRGB(45,45,55)
        WelcomeLabel.Text = fireEnabled and "燃烧效果已开启" or "燃烧效果已关闭"
    end)
end

-- ============================================
-- 烟雾效果
-- ============================================
local smokeEnabled = false
local function toggleSmoke()
    smokeEnabled = not smokeEnabled
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if smokeEnabled then
        local smoke = Instance.new("Smoke"); smoke.Name = "ScriptSmoke"; smoke.Size = 8; smoke.Opacity = 0.5; smoke.RiseVelocity = 3; smoke.Color = Color3.fromRGB(80,80,80); smoke.Parent = hrp
        local leftFoot = char:FindFirstChild("Left Foot"); local rightFoot = char:FindFirstChild("Right Foot")
        if leftFoot then local s1 = Instance.new("Smoke"); s1.Name = "ScriptSmoke"; s1.Size = 4; s1.Opacity = 0.4; s1.RiseVelocity = 2; s1.Color = Color3.fromRGB(60,60,60); s1.Parent = leftFoot end
        if rightFoot then local s2 = Instance.new("Smoke"); s2.Name = "ScriptSmoke"; s2.Size = 4; s2.Opacity = 0.4; s2.RiseVelocity = 2; s2.Color = Color3.fromRGB(60,60,60); s2.Parent = rightFoot end
    else
        for _, part in ipairs(char:GetDescendants()) do if part.Name == "ScriptSmoke" and part:IsA("Smoke") then part:Destroy() end end
    end
end
local smokeBtn = ScrollFrame:FindFirstChild("smokeBtn")
if smokeBtn then
    smokeBtn.MouseButton1Click:Connect(function()
        toggleSmoke()
        smokeBtn.Text = smokeEnabled and "💨 冒烟中..." or "💨 烟雾效果"
        smokeBtn.BackgroundColor3 = smokeEnabled and Color3.fromRGB(120,120,120) or Color3.fromRGB(45,45,55)
        WelcomeLabel.Text = smokeEnabled and "烟雾效果已开启" or "烟雾效果已关闭"
    end)
end

-- ============================================
-- 加速脚本
-- ============================================
local speedEnabled = false
local originalWalkSpeed = 16
local function toggleSpeed()
    speedEnabled = not speedEnabled
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChild("Humanoid"); if not hum then return end
    if speedEnabled then originalWalkSpeed = hum.WalkSpeed; hum.WalkSpeed = 50
    else hum.WalkSpeed = originalWalkSpeed end
end
local speedBtn = ScrollFrame:FindFirstChild("speedBtn")
if speedBtn then
    speedBtn.MouseButton1Click:Connect(function()
        toggleSpeed()
        speedBtn.Text = speedEnabled and "⚡ 加速中..." or "⚡ 加速脚本"
        speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(200,170,0) or Color3.fromRGB(45,45,55)
        WelcomeLabel.Text = speedEnabled and "加速已开启" or "加速已关闭"
    end)
end

-- ============================================
-- 跳跃增强
-- ============================================
local jumpEnabled = false
local originalJumpPower = 50
local function toggleJump()
    jumpEnabled = not jumpEnabled
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChild("Humanoid"); if not hum then return end
    if jumpEnabled then originalJumpPower = hum.JumpPower; hum.JumpPower = 150; hum.UseJumpPower = true
    else hum.JumpPower = originalJumpPower end
end
local jumpBtn = ScrollFrame:FindFirstChild("jumpBtn")
if jumpBtn then
    jumpBtn.MouseButton1Click:Connect(function()
        toggleJump()
        jumpBtn.Text = jumpEnabled and "🦘 超级跳..." or "🦘 跳跃增强"
        jumpBtn.BackgroundColor3 = jumpEnabled and Color3.fromRGB(40,200,80) or Color3.fromRGB(45,45,55)
        WelcomeLabel.Text = jumpEnabled and "跳跃增强已开启" or "跳跃增强已关闭"
    end)
end

-- ============================================
-- 穿墙脚本
-- ============================================
local noclipEnabled = false
local noclipConnection
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        local char = LocalPlayer.Character
        if char then for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
    end
end
local noclipBtn = ScrollFrame:FindFirstChild("noclipBtn")
if noclipBtn then
    noclipBtn.MouseButton1Click:Connect(function()
        toggleNoclip()
        noclipBtn.Text = noclipEnabled and "🧱 穿墙中..." or "🧱 穿墙脚本"
        noclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(140,80,40) or Color3.fromRGB(45,45,55)
        WelcomeLabel.Text = noclipEnabled and "穿墙已开启" or "穿墙已关闭"
    end)
end

-- ============================================
-- ESP 透视
-- ============================================
local espEnabled = false
local espObjects = {}
local function clearESP()
    for _, obj in ipairs(espObjects) do if obj and obj.Parent then obj:Destroy() end end
    espObjects = {}
end
local function createESP()
    clearESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head"); local hum = char:FindFirstChild("Humanoid")
            if head and hum then
                local hl = Instance.new("Highlight"); hl.FillColor = Color3.fromRGB(255,0,0); hl.FillTransparency = 0.7; hl.OutlineColor = Color3.fromRGB(255,255,255); hl.OutlineTransparency = 0; hl.Parent = char
                table.insert(espObjects, hl)
                local bb = Instance.new("BillboardGui"); bb.Adornee = head; bb.Size = UDim2.new(0,100,0,40); bb.StudsOffset = Vector3.new(0,3,0); bb.AlwaysOnTop = true; bb.Parent = char
                local nameLabel = Instance.new("TextLabel"); nameLabel.Size = UDim2.new(1,0,0,20); nameLabel.BackgroundTransparency = 1; nameLabel.Text = player.Name; nameLabel.TextColor3 = Color3.fromRGB(255,255,255); nameLabel.TextSize = 14; nameLabel.Font = Enum.Font.GothamBold; nameLabel.TextStrokeTransparency = 0; nameLabel.Parent = bb
                local healthBg = Instance.new("Frame"); healthBg.Size = UDim2.new(1,0,0,6); healthBg.Position = UDim2.new(0,0,0,22); healthBg.BackgroundColor3 = Color3.fromRGB(50,50,50); healthBg.BorderSizePixel = 0; healthBg.Parent = bb
                local healthBar = Instance.new("Frame"); healthBar.Size = UDim2.new(1,0,1,0); healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0); healthBar.BorderSizePixel = 0; healthBar.Parent = healthBg
                Instance.new("UICorner", healthBg).CornerRadius = UDim.new(0,3)
                local distLabel = Instance.new("TextLabel"); distLabel.Size = UDim2.new(1,0,0,14); distLabel.Position = UDim2.new(0,0,0,30); distLabel.BackgroundTransparency = 1; distLabel.Text = ""; distLabel.TextColor3 = Color3.fromRGB(255,255,0); distLabel.TextSize = 11; distLabel.Font = Enum.Font.Gotham; distLabel.TextStrokeTransparency = 0; distLabel.Parent = bb
                table.insert(espObjects, bb)
            end
        end
    end
end
local espUpdateConnection
local function startESPUpdate()
    espUpdateConnection = RunService.RenderStepped:Connect(function()
        if not espEnabled then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local char = player.Character
                local bb = char:FindFirstChild("ESPBillboard"); local hum = char:FindFirstChild("Humanoid")
                if bb and hum then
                    local distLabel = bb:FindFirstChild("ESPDist")
                    local healthBar = bb:FindFirstChild("HealthBg") and bb.HealthBg:FindFirstChild("HealthBar")
                    if distLabel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
                        distLabel.Text = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude) .. " studs"
                    end
                    if healthBar then
                        local percent = hum.Health / hum.MaxHealth
                        healthBar.Size = UDim2.new(percent,0,1,0)
                        healthBar.BackgroundColor3 = percent > 0.5 and Color3.fromRGB(0,255,0) or (percent > 0.25 and Color3.fromRGB(255,200,0) or Color3.fromRGB(255,0,0))
                    end
                end
            end
        end
    end)
end
local function stopESPUpdate()
    if espUpdateConnection then espUpdateConnection:Disconnect(); espUpdateConnection = nil end
end
local playerAddedConnection
local function enableESP()
    espEnabled = true; createESP(); startESPUpdate()
    playerAddedConnection = Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function() task.wait(1); if espEnabled then createESP() end end)
    end)
end
local function disableESP()
    espEnabled = false; clearESP(); stopESPUpdate()
    if playerAddedConnection then playerAddedConnection:Disconnect(); playerAddedConnection = nil end
end
local espBtn = ScrollFrame:FindFirstChild("espBtn")
if espBtn then
    espBtn.MouseButton1Click:Connect(function()
        if espEnabled then disableESP()
            espBtn.Text = "👁️ ESP透视"; espBtn.BackgroundColor3 = Color3.fromRGB(45,45,55); WelcomeLabel.Text = "ESP已关闭"
        else enableESP()
            espBtn.Text = "👁️ ESP中..."; espBtn.BackgroundColor3 = Color3.fromRGB(200,40,80); WelcomeLabel.Text = "ESP已开启"
        end
    end)
end

-- ============================================
-- 车辆加速
-- ============================================
local carboostEnabled = false
local carboostConnection
local function enableCarBoost()
    if carboostEnabled then return end
    carboostEnabled = true
    carboostConnection = RunService.RenderStepped:Connect(function()
        if not carboostEnabled then return end
        local char = LocalPlayer.Character; if not char then return end
        local seat = char:FindFirstChildOfClass("Seat")
        if seat and seat:IsA("VehicleSeat") then
            local vehicle = seat:FindFirstAncestorOfClass("Model")
            if vehicle then
                for _, part in ipairs(vehicle:GetDescendants()) do
                    if part:IsA("Motor") or part:IsA("HingeConstraint") or part:IsA("PrismaticConstraint") then
                        part.Speed = part.MaxSpeed or 1000
                    end
                end
            end
        end
    end)
    local btn = ScrollFrame:FindFirstChild("carboostBtn")
    if btn then btn.Text = "🚗 加速中..."; btn.BackgroundColor3 = Color3.fromRGB(200,120,0) end
    WelcomeLabel.Text = "车辆加速已开启"
end
local function disableCarBoost()
    carboostEnabled = false
    if carboostConnection then carboostConnection:Disconnect(); carboostConnection = nil end
    local btn = ScrollFrame:FindFirstChild("carboostBtn")
    if btn then btn.Text = "🚗 车辆加速"; btn.BackgroundColor3 = Color3.fromRGB(255,165,0) end
    WelcomeLabel.Text = "车辆加速已关闭"
end
local carboostBtn = ScrollFrame:FindFirstChild("carboostBtn")
if carboostBtn then carboostBtn.MouseButton1Click:Connect(function()
    if carboostEnabled then disableCarBoost() else enableCarBoost() end
end) end

-- ============================================
-- 快速互动
-- ============================================
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
        if instantActionEnabled and obj:IsA("ProximityPrompt") then
            obj.HoldDuration = 0.1
            obj:GetPropertyChangedSignal("HoldDuration"):Connect(function()
                if instantActionEnabled then obj.HoldDuration = 0.1 end
            end)
        end
    end)
    task.spawn(function()
        while instantActionEnabled do
            for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
                if gui:IsA("ScreenGui") then
                    for _, obj in ipairs(gui:GetDescendants()) do
                        if (obj.Name == "ProgressBar" or obj.Name == "Fill") and obj:IsA("Frame") then
                            obj.Size = UDim2.new(1,0,1,0)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
    local btn = ScrollFrame:FindFirstChild("instantactionBtn")
    if btn then btn.Text = "⚡ 快速互动中..."; btn.BackgroundColor3 = Color3.fromRGB(0,180,160) end
    WelcomeLabel.Text = "快速互动已开启"
end
local function disableInstantAction()
    instantActionEnabled = false
    local btn = ScrollFrame:FindFirstChild("instantactionBtn")
    if btn then btn.Text = "⚡ 快速互动"; btn.BackgroundColor3 = Color3.fromRGB(0,255,200) end
    WelcomeLabel.Text = "快速互动已关闭"
end
local instantBtn = ScrollFrame:FindFirstChild("instantactionBtn")
if instantBtn then instantBtn.MouseButton1Click:Connect(function()
    if instantActionEnabled then disableInstantAction() else enableInstantAction() end
end) end

-- ============================================
-- 数据修改器窗口（仅VIP/作者可用）
-- ============================================
local dataWindow = nil
local function createDataWindow()
    if dataWindow then return end
    dataWindow = Instance.new("Frame")
    dataWindow.Name = "DataWindow"
    dataWindow.Parent = ScreenGui
    dataWindow.Size = UDim2.new(0, 300, 0, 250)
    dataWindow.Position = UDim2.new(0.5, -150, 0.5, -125)
    dataWindow.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    dataWindow.BorderSizePixel = 0
    dataWindow.Active = true
    dataWindow.Draggable = true
    Instance.new("UICorner", dataWindow).CornerRadius = UDim.new(0,8)

    local dwTitle = Instance.new("TextLabel", dataWindow)
    dwTitle.Size = UDim2.new(1, -30, 0, 30); dwTitle.Position = UDim2.new(0,15,0,5)
    dwTitle.BackgroundTransparency = 1; dwTitle.Text = "数据修改器"; dwTitle.TextColor3 = Color3.fromRGB(255,255,255); dwTitle.TextSize = 18; dwTitle.Font = Enum.Font.GothamBold; dwTitle.TextXAlignment = Enum.TextXAlignment.Center

    local dwClose = Instance.new("TextButton", dataWindow)
    dwClose.Size = UDim2.new(0,25,0,25); dwClose.Position = UDim2.new(1,-30,0,5)
    dwClose.BackgroundColor3 = Color3.fromRGB(255,70,70); dwClose.Text = "✕"; dwClose.TextColor3 = Color3.fromRGB(255,255,255); dwClose.TextSize = 14; dwClose.Font = Enum.Font.GothamBold; dwClose.BorderSizePixel = 0
    Instance.new("UICorner", dwClose).CornerRadius = UDim.new(0,6)
    dwClose.MouseButton1Click:Connect(function() dataWindow.Visible = false end)

    local dataScroll = Instance.new("ScrollingFrame", dataWindow)
    dataScroll.Size = UDim2.new(1, -10, 1, -40); dataScroll.Position = UDim2.new(0,5,0,35)
    dataScroll.BackgroundColor3 = Color3.fromRGB(45,45,52); dataScroll.BorderSizePixel = 0; dataScroll.ScrollBarThickness = 4
    dataScroll.CanvasSize = UDim2.new(0,0,0,600); dataScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local dataLayout = Instance.new("UIListLayout", dataScroll); dataLayout.Padding = UDim.new(0,5); dataLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function addDataRow(parent, labelText, currentValue, applyFunc)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, -10, 0, 40); row.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(0, 80, 1, 0); label.Position = UDim2.new(0,0,0,0)
        label.BackgroundTransparency = 1; label.Text = labelText; label.TextColor3 = Color3.fromRGB(200,200,200); label.TextSize = 14; label.Font = Enum.Font.Gotham; label.TextXAlignment = Enum.TextXAlignment.Left

        local textBox = Instance.new("TextBox", row)
        textBox.Size = UDim2.new(1, -130, 1, -6); textBox.Position = UDim2.new(0, 85, 0, 3)
        textBox.Text = tostring(currentValue); textBox.TextColor3 = Color3.fromRGB(0,0,0); textBox.BackgroundColor3 = Color3.fromRGB(255,255,255); textBox.Font = Enum.Font.Gotham; textBox.TextSize = 14; textBox.BorderSizePixel = 0

        local applyBtn = Instance.new("TextButton", row)
        applyBtn.Size = UDim2.new(0, 40, 1, -6); applyBtn.Position = UDim2.new(1, -40, 0, 3)
        applyBtn.BackgroundColor3 = Color3.fromRGB(0,162,255); applyBtn.Text = "应用"; applyBtn.TextColor3 = Color3.fromRGB(255,255,255); applyBtn.Font = Enum.Font.GothamBold; applyBtn.TextSize = 13; applyBtn.BorderSizePixel = 0
        Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0,4)

        applyBtn.MouseButton1Click:Connect(function()
            applyFunc(textBox.Text)
        end)
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

    local refreshBtn = Instance.new("TextButton", dataScroll)
    refreshBtn.Size = UDim2.new(1, -10, 0, 30); refreshBtn.Text = "刷新数据"; refreshBtn.TextColor3 = Color3.fromRGB(255,255,255); refreshBtn.BackgroundColor3 = Color3.fromRGB(100,100,100); refreshBtn.Font = Enum.Font.GothamBold; refreshBtn.TextSize = 14; refreshBtn.BorderSizePixel = 0
    refreshBtn.MouseButton1Click:Connect(refreshData)

    local resizeGrip = Instance.new("TextButton", dataWindow)
    resizeGrip.Size = UDim2.new(0,20,0,20); resizeGrip.Position = UDim2.new(1,-20,1,-20)
    resizeGrip.BackgroundColor3 = Color3.fromRGB(100,100,100); resizeGrip.Text = "↘"; resizeGrip.TextColor3 = Color3.fromRGB(255,255,255); resizeGrip.TextSize = 12; resizeGrip.Font = Enum.Font.GothamBold; resizeGrip.BorderSizePixel = 0

    local draggingResize = false
    local startPos, startSize
    resizeGrip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingResize = true
            startPos = UserInputService:GetMouseLocation()
            startSize = dataWindow.AbsoluteSize
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then draggingResize = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingResize and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = UserInputService:GetMouseLocation() - startPos
            dataWindow.Size = UDim2.new(0, math.max(200, startSize.X + delta.X), 0, math.max(150, startSize.Y + delta.Y))
        end
    end)

    dataWindow.Visible = false
end

if datamodBtn then
    datamodBtn.MouseButton1Click:Connect(function()
        if not (isAuthor or isVIP) then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "权限不足", Text = "请升级到VIP才能使用数据修改器", Duration = 3
            })
            return
        end
        if not dataWindow then createDataWindow() end
        dataWindow.Visible = not dataWindow.Visible
        if dataWindow.Visible then
            for _, child in ipairs(dataWindow:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    local refresh = child:FindFirstChild("刷新数据")
                    if refresh then refresh.MouseButton1Click:Fire() end
                end
            end
        end
    end)
end

-- ============================================
-- 赞助图片显示
-- ============================================
local sponsorImage = nil
local sponsorCloseBtn = {}
local sponsorBg = nil

local function clearSponsorDrawings()
    if sponsorImage then sponsorImage:Remove(); sponsorImage = nil end
    for _, d in ipairs(sponsorCloseBtn) do d:Remove() end
    sponsorCloseBtn = {}
    if sponsorBg then sponsorBg:Remove(); sponsorBg = nil end
end

local function showSponsorImage()
    clearSponsorDrawings()
    local imageData
    local success = pcall(function()
        imageData = HttpService:GetAsync(IMAGE_URL)
    end)
    if not success or not imageData then
        pcall(function() setclipboard(IMAGE_URL) end)
        local screenSize = Camera.ViewportSize
        local failBg = Drawing.new("Square"); failBg.Size = Vector2.new(screenSize.X, screenSize.Y); failBg.Position = Vector2.new(0,0); failBg.Color = Color3.fromRGB(0,0,0); failBg.Transparency = 0.7; failBg.Visible = true; table.insert(sponsorCloseBtn, failBg)
        local failText = Drawing.new("Text"); failText.Text = "赞助图片加载失败\n链接已复制到剪贴板\n请用浏览器打开链接查看"; failText.Size = 50; failText.Color = Color3.fromRGB(255,50,50); failText.Font = Drawing.Fonts.System; failText.Center = true; failText.Position = Vector2.new(screenSize.X/2, screenSize.Y/2-50); failText.Visible = true; table.insert(sponsorCloseBtn, failText)
        local linkText = Drawing.new("Text"); linkText.Text = IMAGE_URL; linkText.Size = 20; linkText.Color = Color3.fromRGB(255,255,255); linkText.Font = Drawing.Fonts.System; linkText.Center = true; linkText.Position = Vector2.new(screenSize.X/2, screenSize.Y/2+50); linkText.Visible = true; table.insert(sponsorCloseBtn, linkText)
        local clickConnection
        clickConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                clearSponsorDrawings()
                clickConnection:Disconnect()
            end
        end)
        task.delay(5, function()
            if failBg and failBg.Visible then
                clearSponsorDrawings()
                if clickConnection then clickConnection:Disconnect() end
            end
        end)
        return
    end
    local screenSize = Camera.ViewportSize
    local imgW, imgH = 300, 300
    local posX = screenSize.X/2 - imgW/2
    local posY = screenSize.Y/2 - imgH/2 - 20
    sponsorBg = Drawing.new("Square"); sponsorBg.Size = Vector2.new(screenSize.X, screenSize.Y); sponsorBg.Position = Vector2.new(0,0); sponsorBg.Color = Color3.fromRGB(0,0,0); sponsorBg.Transparency = 0.5; sponsorBg.Visible = true
    sponsorImage = Drawing.new("Image"); sponsorImage.Data = imageData; sponsorImage.Size = Vector2.new(imgW, imgH); sponsorImage.Position = Vector2.new(posX, posY); sponsorImage.Visible = true
    local btnW, btnH = 80, 30; local closeX = posX + imgW/2 - btnW/2; local closeY = posY + imgH + 10
    local closeBg = Drawing.new("Square"); closeBg.Size = Vector2.new(btnW, btnH); closeBg.Position = Vector2.new(closeX, closeY); closeBg.Color = Color3.fromRGB(255,70,70); closeBg.Visible = true; table.insert(sponsorCloseBtn, closeBg)
    local closeText = Drawing.new("Text"); closeText.Text = "关闭"; closeText.Size = 20; closeText.Color = Color3.fromRGB(255,255,255); closeText.Font = Drawing.Fonts.System; closeText.Position = Vector2.new(closeX + btnW/2 - 16, closeY + 4); closeText.Visible = true; table.insert(sponsorCloseBtn, closeText)
    local clickConnection
    clickConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local mousePos = UserInputService:GetMouseLocation()
            if mousePos.X >= closeX and mousePos.X <= closeX + btnW and mousePos.Y >= closeY and mousePos.Y <= closeY + btnH then
                clearSponsorDrawings()
                clickConnection:Disconnect()
            end
        end
    end)
end

local sponsorBtn = ScrollFrame:FindFirstChild("sponsorBtn")
if sponsorBtn then sponsorBtn.MouseButton1Click:Connect(showSponsorImage) end

-- ============================================
-- 永久存在 / 取消永久
-- ============================================
local permanentBtn = ScrollFrame:FindFirstChild("permanentBtn")
local unpermanentBtn = ScrollFrame:FindFirstChild("unpermanentBtn")
if permanentBtn then
    permanentBtn.MouseButton1Click:Connect(function()
        if writefile then
            pcall(function() writefile(permanentFile, "1") end)
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="成功", Text="永久模式已开启，换服自动生效", Duration=5})
        else
            Instance.new("BoolValue", CoreGui).Name = "FScriptHubPermanent"
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="成功", Text="永久模式已开启（仅同服生效）", Duration=5})
        end
    end)
end
if unpermanentBtn then
    unpermanentBtn.MouseButton1Click:Connect(function()
        if writefile then
            pcall(function() delfile(permanentFile) end)
        end
        local marker = CoreGui:FindFirstChild("FScriptHubPermanent")
        if marker then marker:Destroy() end
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="已取消", Text="永久模式已关闭", Duration=3})
    end)
end

-- ============================================
-- 打开按钮 + 动画
-- ============================================
local openBtn = Instance.new("TextButton", ScreenGui)
openBtn.Size = UDim2.new(0, 50, 0, 50); openBtn.Position = UDim2.new(0, 10, 0.5, -25)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255); openBtn.Text = "F"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255); openBtn.TextSize = 24; openBtn.Font = Enum.Font.GothamBlack; openBtn.BorderSizePixel = 0
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0,12)
openBtn.MouseButton1Click:Connect(function()
    if not MainFrame.Visible then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 520, 0, 420)}):Play()
    else
        MainFrame.Visible = false
    end
end)

-- ============================================
-- 重生恢复
-- ============================================
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
    if flyEnabled then disableFly(); task.wait(0.5); enableFly(); setupFlyMovement() end
    if spinEnabled then
        task.wait(0.5)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bav = Instance.new("BodyAngularVelocity"); bav.Name = "SpinVelocity"; bav.AngularVelocity = Vector3.new(0, spinSpeed, 0); bav.MaxTorque = Vector3.new(0,9e9,0); bav.Parent = hrp
        end
    end
    if orbitEnabled and orbitTargetPlayer then
        local targetChar = orbitTargetPlayer.Character
        if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
            task.wait(0.5)
            orbitAngle = 0
            if orbitConnection then orbitConnection:Disconnect() end
            orbitConnection = RunService.RenderStepped:Connect(function(dt)
                if not orbitEnabled or not orbitTargetPlayer or not orbitTargetPlayer.Character or not orbitTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    stopOrbit(); return
                end
                local myChar = LocalPlayer.Character; if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
                orbitAngle = orbitAngle + dt * orbitSpeed
                local radius = 10
                myChar.HumanoidRootPart.CFrame = CFrame.new(orbitTargetPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.cos(orbitAngle)*radius, 3, math.sin(orbitAngle)*radius))
            end)
        else
            stopOrbit()
        end
    end
    if headlessEnabled then task.wait(0.5); toggleHeadless(); toggleHeadless() end
    if fireEnabled then task.wait(0.5); toggleFire(); toggleFire() end
    if smokeEnabled then task.wait(0.5); toggleSmoke(); toggleSmoke() end
    if speedEnabled then task.wait(0.5); toggleSpeed(); toggleSpeed() end
    if jumpEnabled then task.wait(0.5); toggleJump(); toggleJump() end
    if noclipEnabled then end
    if espEnabled then task.wait(1); createESP() end
    if carboostEnabled then disableCarBoost(); task.wait(0.5); enableCarBoost() end
    if instantActionEnabled then disableInstantAction(); task.wait(0.5); enableInstantAction() end
end)
