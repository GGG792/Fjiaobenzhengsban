-- F脚本中心 最终完整版 (修复手机端显示)
-- 主要修复：适配手机屏幕、防止UI被裁剪
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

-- 获取屏幕尺寸并计算适配
local screenSize = Camera.ViewportSize
local isMobile = UserInputService.TouchEnabled
local scale = math.min(screenSize.X / 520, screenSize.Y / 420, 1)
if isMobile then scale = math.min(scale, 0.85) end

local frameWidth = math.floor(520 * scale)
local frameHeight = math.floor(420 * scale)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FScriptHub"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
MainFrame.Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,30)
MainFrame.BackgroundTransparency = 0.35
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false
MainFrame.Visible = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 3
MainStroke.Transparency = 0.2
MainStroke.Parent = MainFrame
coroutine.wrap(function() while MainStroke and MainStroke.Parent do MainStroke.Color = Color3.fromHSV((tick()*0.5)%1,1,1); RunService.RenderStepped:Wait() end end)()

local FIcon = Instance.new("TextLabel")
FIcon.Name = "FIcon"
FIcon.Parent = MainFrame
FIcon.Size = UDim2.new(0,50,0,50)
FIcon.Position = UDim2.new(0,10,0,8)
FIcon.BackgroundColor3 = Color3.fromRGB(0,162,255)
FIcon.Text = "F"
FIcon.TextColor3 = Color3.white
FIcon.Font = Enum.Font.GothamBlack
FIcon.TextSize = 28

local FIconCorner = Instance.new("UICorner")
FIconCorner.CornerRadius = UDim.new(0,8)
FIconCorner.Parent = FIcon

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.Size = UDim2.new(0,150,0,25)
TitleLabel.Position = UDim2.new(0,65,0,10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "脚本中心"
TitleLabel.TextColor3 = Color3.white
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Parent = MainFrame
SubTitle.Size = UDim2.new(0,150,0,16)
SubTitle.Position = UDim2.new(0,65,0,35)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "终极完整版"
SubTitle.TextColor3 = Color3.fromRGB(150,150,160)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.Gotham

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0,28,0,28)
CloseBtn.Position = UDim2.new(1,-35,0,8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255,170,0)
CloseBtn.Text = "-"
CloseBtn.TextColor3 = Color3.white
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,6)
CloseCorner.Parent = CloseBtn

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(0, 140, 1, -70)
ScrollFrame.Position = UDim2.new(1, -150, 0, 60)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(35,35,42)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.CanvasSize = UDim2.new(0,0,0,2000)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0,6)
ScrollCorner.Parent = ScrollFrame

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.Padding = UDim.new(0,6)
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Parent = ScrollFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, -160, 1, -70)
ContentFrame.Position = UDim2.new(0, 8, 0, 60)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35,35,42)
ContentFrame.BackgroundTransparency = 0.3
ContentFrame.BorderSizePixel = 0

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0,6)
ContentCorner.Parent = ContentFrame

local PlayerInfoFrame = Instance.new("Frame")
PlayerInfoFrame.Name = "PlayerInfoFrame"
PlayerInfoFrame.Parent = ContentFrame
PlayerInfoFrame.Size = UDim2.new(1,-6,0,70)
PlayerInfoFrame.Position = UDim2.new(0,3,0,3)
PlayerInfoFrame.BackgroundColor3 = Color3.fromRGB(45,45,52)
PlayerInfoFrame.BackgroundTransparency = 0.3
PlayerInfoFrame.BorderSizePixel = 0

local PlayerInfoCorner = Instance.new("UICorner")
PlayerInfoCorner.CornerRadius = UDim.new(0,6)
PlayerInfoCorner.Parent = PlayerInfoFrame

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "AvatarImage"
AvatarImage.Parent = PlayerInfoFrame
AvatarImage.Size = UDim2.new(0,50,0,50)
AvatarImage.Position = UDim2.new(0,8,0,10)
AvatarImage.BackgroundTransparency = 1
pcall(function() AvatarImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)

local NameLabel = Instance.new("TextLabel")
NameLabel.Name = "NameLabel"
NameLabel.Parent = PlayerInfoFrame
NameLabel.Size = UDim2.new(1,-65,0,20)
NameLabel.Position = UDim2.new(0,62,0,8)
NameLabel.BackgroundTransparency = 1
NameLabel.Text = LocalPlayer.DisplayName
NameLabel.TextColor3 = Color3.white
NameLabel.TextSize = 14
NameLabel.Font = Enum.Font.GothamBold

local RoleLabel = Instance.new("TextLabel")
RoleLabel.Name = "RoleLabel"
RoleLabel.Parent = PlayerInfoFrame
RoleLabel.Size = UDim2.new(1,-65,0,16)
RoleLabel.Position = UDim2.new(0,62,0,28)
RoleLabel.BackgroundTransparency = 1
RoleLabel.Text = currentRole=="author" and "作者" or (currentRole=="vip" and "VIP" or "普通用户")
RoleLabel.TextSize = 12
RoleLabel.Font = Enum.Font.Gotham

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Name = "TimeLabel"
TimeLabel.Parent = PlayerInfoFrame
TimeLabel.Size = UDim2.new(1,-65,0,16)
TimeLabel.Position = UDim2.new(0,62,0,45)
TimeLabel.BackgroundTransparency = 1
TimeLabel.TextColor3 = Color3.fromRGB(180,180,255)
TimeLabel.TextSize = 11
TimeLabel.Font = Enum.Font.Gotham
coroutine.wrap(function() while TimeLabel and TimeLabel.Parent do TimeLabel.Text = os.date("%H:%M:%S"); task.wait(1) end end)()

local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Name = "WelcomeLabel"
WelcomeLabel.Parent = ContentFrame
WelcomeLabel.Size = UDim2.new(1,-10,0,25)
WelcomeLabel.Position = UDim2.new(0,5,0,75)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "欢迎使用 F脚本中心"
WelcomeLabel.TextColor3 = Color3.white
WelcomeLabel.TextSize = 14
WelcomeLabel.Font = Enum.Font.GothamBold

local ServerPanel = Instance.new("Frame")
ServerPanel.Name = "ServerPanel"
ServerPanel.Parent = ContentFrame
ServerPanel.Size = UDim2.new(1,0,1,-75)
ServerPanel.Position = UDim2.new(0,0,0,75)
ServerPanel.BackgroundColor3 = Color3.fromRGB(45,45,52)
ServerPanel.BackgroundTransparency = 0.3
ServerPanel.BorderSizePixel = 0
ServerPanel.Visible = false

local ServerPanelCorner = Instance.new("UICorner")
ServerPanelCorner.CornerRadius = UDim.new(0,6)
ServerPanelCorner.Parent = ServerPanel

local ServerTitle = Instance.new("TextLabel")
ServerTitle.Name = "ServerTitle"
ServerTitle.Parent = ServerPanel
ServerTitle.Size = UDim2.new(1,-10,0,22)
ServerTitle.Position = UDim2.new(0,5,0,3)
ServerTitle.BackgroundTransparency = 1
ServerTitle.Text = "服务器脚本"
ServerTitle.TextColor3 = Color3.white
ServerTitle.TextSize = 14
ServerTitle.Font = Enum.Font.GothamBold

local ServerScroll = Instance.new("ScrollingFrame")
ServerScroll.Name = "ServerScroll"
ServerScroll.Parent = ServerPanel
ServerScroll.Size = UDim2.new(1,-6,1,-28)
ServerScroll.Position = UDim2.new(0,3,0,25)
ServerScroll.BackgroundColor3 = Color3.fromRGB(25,25,30)
ServerScroll.BorderSizePixel = 0
ServerScroll.ScrollBarThickness = 3
ServerScroll.CanvasSize = UDim2.new(0,0,0,0)
ServerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ServerScrollCorner = Instance.new("UICorner")
ServerScrollCorner.CornerRadius = UDim.new(0,3)
ServerScrollCorner.Parent = ServerScroll

local ServerListLayout = Instance.new("UIListLayout")
ServerListLayout.Padding = UDim.new(0,3)
ServerListLayout.Parent = ServerScroll

local buttonRefs = {}
local btnDefs = {
    {name = "启用飞行", color = Color3.fromRGB(0,162,255), id = "fly"},
    {name = "旋转脚本", color = Color3.fromRGB(255,100,50), id = "spin"},
    {name = "环绕旋转", color = Color3.fromRGB(150,50,255), id = "orbit"},
    {name = "无头效果", color = Color3.fromRGB(100,100,100), id = "headless"},
    {name = "燃烧效果", color = Color3.fromRGB(255,50,0), id = "fire"},
    {name = "烟雾效果", color = Color3.fromRGB(150,150,150), id = "smoke"},
    {name = "加速脚本", color = Color3.fromRGB(255,220,0), id = "speed"},
    {name = "跳跃增强", color = Color3.fromRGB(50,255,100), id = "jump"},
    {name = "穿墙脚本", color = Color3.fromRGB(180,100,50), id = "noclip"},
    {name = "ESP透视", color = Color3.fromRGB(255,50,100), id = "esp"},
    {name = "车辆加速", color = Color3.fromRGB(255,165,0), id = "carboost"},
    {name = "快速互动", color = Color3.fromRGB(0,255,200), id = "instantaction"},
    {name = "数据修改器", color = Color3.fromRGB(180,100,255), id = "datamod"},
    {name = "永久存在", color = Color3.fromRGB(255,200,100), id = "permanent"},
    {name = "取消永久", color = Color3.fromRGB(255,100,100), id = "unpermanent"},
    {name = "传送玩家", color = Color3.fromRGB(0,255,100), id = "teleport"},
    {name = "标记此处", color = Color3.fromRGB(255,200,0), id = "markpoint"},
    {name = "标记列表", color = Color3.fromRGB(255,150,50), id = "marklist"},
    {name = "管理员工具", color = Color3.fromRGB(255,215,0), id = "admintool"},
    {name = "服务器脚本", color = Color3.fromRGB(200,150,255), id = "serverscripts"},
    {name = "4:3比例", color = Color3.fromRGB(255,180,100), id = "ratio43"},
    {name = "超广角", color = Color3.fromRGB(100,255,200), id = "ultrawide"},
    {name = "切换身份", color = Color3.fromRGB(255,100,255), id = "switchrole"},
    {name = "赞助作者", color = Color3.fromRGB(255,215,0), id = "sponsor"},
}

for i, info in ipairs(btnDefs) do
    local btn = Instance.new("TextButton")
    btn.Name = info.id.."Btn"
    btn.Parent = ScrollFrame
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,55)
    btn.Text = info.name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.LayoutOrder = i
    btn.AutoButtonColor = false

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,6)
    btnCorner.Parent = btn

    buttonRefs[info.id] = btn
end

-- 环绕选择面板
local PlayerSelectFrame = Instance.new("Frame", MainFrame)
PlayerSelectFrame.Name="PlayerSelectFrame"; PlayerSelectFrame.Size=UDim2.new(0.8,0,0.7,0); PlayerSelectFrame.Position=UDim2.new(0.1,0,0.15,0)
PlayerSelectFrame.BackgroundColor3=Color3.fromRGB(30,30,35); PlayerSelectFrame.BorderSizePixel=0; PlayerSelectFrame.Visible=false
Instance.new("UICorner", PlayerSelectFrame).CornerRadius=UDim.new(0,8)
local SelectTitle = Instance.new("TextLabel", PlayerSelectFrame); SelectTitle.Size=UDim2.new(1,0,0,30); SelectTitle.Position=UDim2.new(0,0,0,5); SelectTitle.BackgroundTransparency=1; SelectTitle.Text="选择玩家"; SelectTitle.TextColor3=Color3.white; SelectTitle.TextSize=16; SelectTitle.Font=Enum.Font.GothamBold
local SelectCloseBtn = Instance.new("TextButton", PlayerSelectFrame); SelectCloseBtn.Size=UDim2.new(0,25,0,25); SelectCloseBtn.Position=UDim2.new(1,-30,0,5); SelectCloseBtn.BackgroundColor3=Color3.fromRGB(255,70,70); SelectCloseBtn.Text="X"; SelectCloseBtn.TextColor3=Color3.white; SelectCloseBtn.TextSize=14; SelectCloseBtn.Font=Enum.Font.GothamBold; SelectCloseBtn.BorderSizePixel=0
Instance.new("UICorner", SelectCloseBtn).CornerRadius=UDim.new(0,6); SelectCloseBtn.MouseButton1Click:Connect(function() PlayerSelectFrame.Visible = false end)
local PlayerScroll = Instance.new("ScrollingFrame", PlayerSelectFrame); PlayerScroll.Size=UDim2.new(1,-10,1,-45); PlayerScroll.Position=UDim2.new(0,5,0,35)
PlayerScroll.BackgroundColor3=Color3.fromRGB(40,40,48); PlayerScroll.BorderSizePixel=0; PlayerScroll.ScrollBarThickness=4; PlayerScroll.CanvasSize=UDim2.new(0,0,0,0); PlayerScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
local PlayerListLayout = Instance.new("UIListLayout", PlayerScroll); PlayerListLayout.Padding=UDim.new(0,4)

-- 权限控制
if LocalPlayer.Name ~= AUTHOR_NAME then
    for _, id in ipairs({"markpoint","marklist","serverscripts","switchrole"}) do
        local b = buttonRefs[id] if b then b.Visible = false end
    end
end
local datamodBtn = buttonRefs["datamod"]
if datamodBtn and not isVIP then
    datamodBtn.Text = "数据修改器 (VIP)"; datamodBtn.BackgroundColor3 = Color3.fromRGB(80,80,80); datamodBtn.TextColor3 = Color3.fromRGB(180,180,180)
end

-- 速度调节
local flySpeed, spinSpeed, orbitSpeed = 50, 20, 3
local function createSpeedInput(name, def, cb)
    local row = Instance.new("Frame", ScrollFrame); row.Size = UDim2.new(1,-10,0,30); row.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", row); label.Size = UDim2.new(0,50,1,0); label.Position = UDim2.new(0,0,0,0)
    label.BackgroundTransparency=1; label.Text=name; label.TextColor3=Color3.fromRGB(200,200,200); label.TextSize=11; label.Font=Enum.Font.Gotham
    local input = Instance.new("TextBox", row); input.Size = UDim2.new(1,-90,1,-4); input.Position = UDim2.new(0,55,0,2)
    input.Text=tostring(def); input.TextColor3=Color3.fromRGB(0,0,0); input.BackgroundColor3=Color3.fromRGB(255,255,255); input.Font=Enum.Font.Gotham; input.TextSize=11; input.BorderSizePixel=0
    local applyBtn = Instance.new("TextButton", row); applyBtn.Size = UDim2.new(0,30,1,-4); applyBtn.Position = UDim2.new(1,-30,0,2)
    applyBtn.BackgroundColor3=Color3.fromRGB(0,162,255); applyBtn.Text="OK"; applyBtn.TextColor3=Color3.white; applyBtn.Font=Enum.Font.GothamBold; applyBtn.TextSize=11; applyBtn.BorderSizePixel=0
    Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0,3)
    applyBtn.MouseButton1Click:Connect(function() local n = tonumber(input.Text); if n then cb(n) end end)
end
createSpeedInput("飞行速度", 50, function(v) flySpeed = v end)
createSpeedInput("旋转速度", 20, function(v) spinSpeed = v end)
createSpeedInput("环绕速度", 3, function(v) orbitSpeed = v end)

-- 飞行
local flyEnabled = false; local bodyVel, bodyGyro, flyConn
local function enableFly()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    flyEnabled = true; bodyVel = Instance.new("BodyVelocity",hrp); bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9); bodyVel.Velocity = Vector3.zero
    bodyGyro = Instance.new("BodyGyro",hrp); bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9); bodyGyro.P = 9e4
end
local function disableFly() flyEnabled = false; if bodyVel then bodyVel:Destroy() end; if bodyGyro then bodyGyro:Destroy() end; if flyConn then flyConn:Disconnect() end end
local function flyLoop()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid"); if not hum then return end
    flyConn = RunService.RenderStepped:Connect(function()
        if not flyEnabled or not bodyVel then return end
        local move = hum.MoveDirection; if move.Magnitude == 0 then bodyVel.Velocity = Vector3.zero; return end
        local look = Camera.CFrame.LookVector; local right = Camera.CFrame.RightVector
        local fwd = move:Dot(look); local side = move:Dot(right)
        local vel = Vector3.zero
        if fwd > 0.1 then vel = look * flySpeed elseif fwd < -0.1 then vel = Vector3.zero elseif math.abs(side) > 0.1 then vel = right * math.sign(side) * flySpeed end
        bodyVel.Velocity = vel; if bodyGyro then bodyGyro.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, LocalPlayer.Character.HumanoidRootPart.Position + look) end
    end)
end

-- 旋转
local spinEnabled = false
local function toggleSpin()
    spinEnabled = not spinEnabled; local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid"); if not hrp or not hum then return end
    if spinEnabled then hum.AutoRotate = false; local bav = Instance.new("BodyAngularVelocity",hrp); bav.Name="SpinVelocity"; bav.AngularVelocity=Vector3.new(0,spinSpeed,0); bav.MaxTorque=Vector3.new(0,9e9,0); hum.PlatformStand = false
    else hum.AutoRotate = true; local bav = hrp:FindFirstChild("SpinVelocity") if bav then bav:Destroy() end end
end

-- 环绕
local orbitEnabled = false; local orbitConnection, orbitTargetPlayer, orbitAngle = nil, nil, 0
local function stopOrbit() orbitEnabled = false; if orbitConnection then orbitConnection:Disconnect() end; orbitTargetPlayer = nil; local ob = buttonRefs["orbit"] if ob then ob.Text="环绕旋转"; ob.BackgroundColor3=Color3.fromRGB(45,45,55) end end
local function refreshPlayerList()
    for _, child in ipairs(PlayerScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    for _, player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer then
        local pBtn = Instance.new("TextButton"); pBtn.Size = UDim2.new(1,-8,0,32); pBtn.BackgroundColor3=Color3.fromRGB(55,55,65); pBtn.Text = player.Name; pBtn.TextColor3 = Color3.white; pBtn.TextSize = 12; pBtn.Font = Enum.Font.GothamBold; pBtn.BorderSizePixel = 0
        Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0,4)
        pBtn.MouseButton1Click:Connect(function()
            PlayerSelectFrame.Visible = false; orbitTargetPlayer = player; orbitEnabled = true; orbitAngle = 0
            if orbitConnection then orbitConnection:Disconnect() end
            orbitConnection = RunService.RenderStepped:Connect(function(dt)
                if not orbitEnabled or not orbitTargetPlayer or not orbitTargetPlayer.Character or not orbitTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then stopOrbit() return end
                local myChar = LocalPlayer.Character; if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
                local myHRP = myChar.HumanoidRootPart; local targetHRP = orbitTargetPlayer.Character.HumanoidRootPart
                orbitAngle = orbitAngle + dt * orbitSpeed; local radius = 10
                myHRP.CFrame = CFrame.new(targetHRP.Position + Vector3.new(math.cos(orbitAngle)*radius, 3, math.sin(orbitAngle)*radius))
            end)
            local ob = buttonRefs["orbit"] if ob then ob.Text="环绕中..."; ob.BackgroundColor3=Color3.fromRGB(120,40,200) end
        end)
        pBtn.Parent = PlayerScroll
    end end
end

-- 无头
local headlessEnabled = false
local function toggleHeadless()
    headlessEnabled = not headlessEnabled; local char = LocalPlayer.Character; if not char then return end
    local head = char:FindFirstChild("Head"); if head then head.Transparency = headlessEnabled and 1 or 0; for _,v in ipairs(head:GetChildren()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = headlessEnabled and 1 or 0 end end end
    local neck = char:FindFirstChild("Neck",true); if neck and neck:IsA("Motor6D") then neck.Transform = headlessEnabled and CFrame.new(0,-10,0) or CFrame.new(0,0,0) end
end

-- 燃烧
local fireEnabled = false; local fireObj
local function toggleFire()
    fireEnabled = not fireEnabled; local char = LocalPlayer.Character; if not char then return end; local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if fireEnabled then fireObj = Instance.new("Fire",hrp); fireObj.Size=8; fireObj.Heat=10; fireObj.Color=Color3.fromRGB(255,100,0); fireObj.SecondaryColor=Color3.fromRGB(255,200,0)
        local leftFoot=char:FindFirstChild("Left Foot"); local rightFoot=char:FindFirstChild("Right Foot")
        if leftFoot then local f1=Instance.new("Fire",leftFoot); f1.Size=4; f1.Heat=5; f1.Color=Color3.fromRGB(255,50,0); f1.SecondaryColor=Color3.fromRGB(255,150,0); f1.Name="ScriptFire" end
        if rightFoot then local f2=Instance.new("Fire",rightFoot); f2.Size=4; f2.Heat=5; f2.Color=Color3.fromRGB(255,50,0); f2.SecondaryColor=Color3.fromRGB(255,150,0); f2.Name="ScriptFire" end
    else if fireObj then fireObj:Destroy(); fireObj=nil end; for _,p in ipairs(char:GetDescendants()) do if p.Name=="ScriptFire" and p:IsA("Fire") then p:Destroy() end end end
end

-- 烟雾
local smokeEnabled = false
local function toggleSmoke()
    smokeEnabled = not smokeEnabled; local char = LocalPlayer.Character; if not char then return end; local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if smokeEnabled then local smoke=Instance.new("Smoke",hrp); smoke.Name="ScriptSmoke"; smoke.Size=8; smoke.Opacity=0.5; smoke.RiseVelocity=3; smoke.Color=Color3.fromRGB(80,80,80)
        local leftFoot=char:FindFirstChild("Left Foot"); local rightFoot=char:FindFirstChild("Right Foot")
        if leftFoot then local s1=Instance.new("Smoke",leftFoot); s1.Name="ScriptSmoke"; s1.Size=4; s1.Opacity=0.4; s1.RiseVelocity=2; s1.Color=Color3.fromRGB(60,60,60) end
        if rightFoot then local s2=Instance.new("Smoke",rightFoot); s2.Name="ScriptSmoke"; s2.Size=4; s2.Opacity=0.4; s2.RiseVelocity=2; s2.Color=Color3.fromRGB(60,60,60) end
    else for _,p in ipairs(char:GetDescendants()) do if p.Name=="ScriptSmoke" and p:IsA("Smoke") then p:Destroy() end end end
end

-- 加速
local speedEnabled = false; local originalWalkSpeed = 16
local function toggleSpeed() speedEnabled = not speedEnabled; local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid"); if hum then hum.WalkSpeed = speedEnabled and 50 or originalWalkSpeed end end

-- 跳跃
local jumpEnabled = false; local originalJumpPower = 50
local function toggleJump() jumpEnabled = not jumpEnabled; local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid"); if hum then hum.JumpPower = jumpEnabled and 150 or originalJumpPower; hum.UseJumpPower = jumpEnabled end end

-- 穿墙
local noclipEnabled = false; local noclipConn
local function startNoclip() noclipConn = RunService.Stepped:Connect(function() if LocalPlayer.Character then for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide=false end end end end) end
local function stopNoclip() if noclipConn then noclipConn:Disconnect() end; if LocalPlayer.Character then for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=true end end end end
local function toggleNoclip() noclipEnabled = not noclipEnabled; if noclipEnabled then startNoclip() else stopNoclip() end end

-- ESP
local espEnabled = false; local espObjects = {}
local function clearESP() for _,obj in ipairs(espObjects) do if obj.Parent then obj:Destroy() end end; espObjects = {} end
local function createESP()
    clearESP()
    for _,player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character then
        local hl = Instance.new("Highlight",player.Character); hl.FillColor=Color3.fromRGB(255,0,0); hl.FillTransparency=0.7; hl.OutlineColor=Color3.white; hl.OutlineTransparency=0
        table.insert(espObjects,hl)
    end end
end

-- 车辆加速
local carboostEnabled = false; local carboostConn
local function enableCarBoost() if carboostEnabled then return end; carboostEnabled = true; carboostConn = RunService.RenderStepped:Connect(function() local seat = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Seat"); if seat and seat:IsA("VehicleSeat") then local vehicle = seat:FindFirstAncestorOfClass("Model") if vehicle then for _,p in ipairs(vehicle:GetDescendants()) do if p:IsA("Motor") or p:IsA("HingeConstraint") or p:IsA("PrismaticConstraint") then p.Speed = p.MaxSpeed or 1000 end end end end end) local btn = buttonRefs["carboost"] if btn then btn.Text = "车辆加速 (开)"; btn.BackgroundColor3 = Color3.fromRGB(200,120,0) end end
local function disableCarBoost() carboostEnabled = false; if carboostConn then carboostConn:Disconnect() end; local btn = buttonRefs["carboost"] if btn then btn.Text = "车辆加速"; btn.BackgroundColor3 = Color3.fromRGB(255,165,0) end end

-- 快速互动
local instantActionEnabled = false
local function enableInstantAction()
    if instantActionEnabled then return end; instantActionEnabled = true
    for _,obj in ipairs(workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") then obj.HoldDuration = 0.1; obj:GetPropertyChangedSignal("HoldDuration"):Connect(function() if instantActionEnabled then obj.HoldDuration = 0.1 end end) end end
    workspace.DescendantAdded:Connect(function(obj) if instantActionEnabled and obj:IsA("ProximityPrompt") then obj.HoldDuration = 0.1 end end)
    task.spawn(function() while instantActionEnabled do for _,gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do if gui:IsA("ScreenGui") then for _,obj in ipairs(gui:GetDescendants()) do if (obj.Name=="ProgressBar" or obj.Name=="Fill") and obj:IsA("Frame") then obj.Size = UDim2.new(1,0,1,0) end end end end task.wait(0.1) end end)
    local btn = buttonRefs["instantaction"] if btn then btn.Text="快速互动 (开)"; btn.BackgroundColor3=Color3.fromRGB(0,180,160) end
end
local function disableInstantAction() instantActionEnabled = false; local btn = buttonRefs["instantaction"] if btn then btn.Text="快速互动"; btn.BackgroundColor3=Color3.fromRGB(0,255,200) end end

-- 数据修改器
local dataWindow = nil
local function createDataWindow()
    if dataWindow then return end
    dataWindow = Instance.new("Frame",ScreenGui); dataWindow.Size=UDim2.new(0,260,0,220); dataWindow.Position=UDim2.new(0.5,-130,0.5,-110)
    dataWindow.BackgroundColor3=Color3.fromRGB(35,35,42); dataWindow.BorderSizePixel=0; dataWindow.Active=true; dataWindow.Draggable=true
    Instance.new("UICorner",dataWindow).CornerRadius=UDim.new(0,8)
    local dwTitle = Instance.new("TextLabel",dataWindow); dwTitle.Size=UDim2.new(1,-30,0,25); dwTitle.Position=UDim2.new(0,15,0,5)
    dwTitle.BackgroundTransparency=1; dwTitle.Text="数据修改器"; dwTitle.TextColor3=Color3.white; dwTitle.TextSize=16; dwTitle.Font=Enum.Font.GothamBold; dwTitle.TextXAlignment=Enum.TextXAlignment.Center
    local dwClose = Instance.new("TextButton",dataWindow); dwClose.Size=UDim2.new(0,22,0,22); dwClose.Position=UDim2.new(1,-26,0,5)
    dwClose.BackgroundColor3=Color3.fromRGB(255,70,70); dwClose.Text="X"; dwClose.TextColor3=Color3.white; dwClose.TextSize=12; dwClose.Font=Enum.Font.GothamBold; dwClose.BorderSizePixel=0
    Instance.new("UICorner",dwClose).CornerRadius=UDim.new(0,5); dwClose.MouseButton1Click:Connect(function() dataWindow.Visible=false end)
    local dataScroll = Instance.new("ScrollingFrame",dataWindow); dataScroll.Size=UDim2.new(1,-8,1,-35); dataScroll.Position=UDim2.new(0,4,0,30)
    dataScroll.BackgroundColor3=Color3.fromRGB(45,45,52); dataScroll.BorderSizePixel=0; dataScroll.ScrollBarThickness=3; dataScroll.CanvasSize=UDim2.new(0,0,0,400); dataScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local dataLayout = Instance.new("UIListLayout",dataScroll); dataLayout.Padding=UDim.new(0,4)
    local function addDataRow(parent,labelText,currentValue,applyFunc)
        local row = Instance.new("Frame",parent); row.Size=UDim2.new(1,-8,0,32); row.BackgroundTransparency=1
        local label = Instance.new("TextLabel",row); label.Size=UDim2.new(0,70,1,0); label.Position=UDim2.new(0,0,0,0)
        label.BackgroundTransparency=1; label.Text=labelText; label.TextColor3=Color3.fromRGB(200,200,200); label.TextSize=12; label.Font=Enum.Font.Gotham; label.TextXAlignment=Enum.TextXAlignment.Left
        local textBox = Instance.new("TextBox",row); textBox.Size=UDim2.new(1,-110,1,-4); textBox.Position=UDim2.new(0,75,0,2)
        textBox.Text=tostring(currentValue); textBox.TextColor3=Color3.fromRGB(0,0,0); textBox.BackgroundColor3=Color3.fromRGB(255,255,255); textBox.Font=Enum.Font.Gotham; textBox.TextSize=12; textBox.BorderSizePixel=0
        local applyBtn = Instance.new("TextButton",row); applyBtn.Size=UDim2.new(0,30,1,-4); applyBtn.Position=UDim2.new(1,-30,0,2)
        applyBtn.BackgroundColor3=Color3.fromRGB(0,162,255); applyBtn.Text="OK"; applyBtn.TextColor3=Color3.white; applyBtn.Font=Enum.Font.GothamBold; applyBtn.TextSize=11; applyBtn.BorderSizePixel=0
        Instance.new("UICorner",applyBtn).CornerRadius=UDim.new(0,3)
        applyBtn.MouseButton1Click:Connect(function() applyFunc(textBox.Text) end)
        return textBox
    end
    local textBoxes = {}
    local function refreshData()
        local char = LocalPlayer.Character; local hum = char and char:FindFirstChild("Humanoid"); if not hum then return end
        if textBoxes.walk then textBoxes.walk.Text=tostring(hum.WalkSpeed) end
        if textBoxes.jump then textBoxes.jump.Text=tostring(hum.JumpPower) end
        if textBoxes.health then textBoxes.health.Text=tostring(hum.Health) end
        if textBoxes.maxhealth then textBoxes.maxhealth.Text=tostring(hum.MaxHealth) end
        if textBoxes.gravity then textBoxes.gravity.Text=tostring(workspace.Gravity) end
    end
    textBoxes.walk = addDataRow(dataScroll,"移动速度",16,function(val) local num=tonumber(val) if num and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed=num end end)
    textBoxes.jump = addDataRow(dataScroll,"跳跃力",50,function(val) local num=tonumber(val) if num and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower=num; LocalPlayer.Character.Humanoid.UseJumpPower=true end end)
    textBoxes.health = addDataRow(dataScroll,"生命值",100,function(val) local num=tonumber(val) if num and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.Health=math.max(num,0.1) end end)
    textBoxes.maxhealth = addDataRow(dataScroll,"最大生命",100,function(val) local num=tonumber(val) if num and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.MaxHealth=num end end)
    textBoxes.gravity = addDataRow(dataScroll,"重力",196.2,function(val) local num=tonumber(val) if num then workspace.Gravity=num end end)
    local refreshBtn = Instance.new("TextButton",dataScroll); refreshBtn.Size=UDim2.new(1,-8,0,25); refreshBtn.Text="刷新数据"; refreshBtn.TextColor3=Color3.white; refreshBtn.BackgroundColor3=Color3.fromRGB(100,100,100); refreshBtn.Font=Enum.Font.GothamBold; refreshBtn.TextSize=12; refreshBtn.BorderSizePixel=0
    refreshBtn.MouseButton1Click:Connect(refreshData)
    dataWindow.Visible = false
end

-- 按钮事件绑定
local flyBtn = buttonRefs["fly"]
if flyBtn then flyBtn.MouseButton1Click:Connect(function() if flyEnabled then disableFly(); flyBtn.Text="启用飞行"; flyBtn.BackgroundColor3=Color3.fromRGB(45,45,55) else enableFly(); flyLoop(); flyBtn.Text="飞行中..."; flyBtn.BackgroundColor3=Color3.fromRGB(0,120,200) end end) end

local spinBtn = buttonRefs["spin"]
if spinBtn then spinBtn.MouseButton1Click:Connect(function() toggleSpin(); spinBtn.Text = spinEnabled and "旋转中..." or "旋转脚本"; spinBtn.BackgroundColor3 = spinEnabled and Color3.fromRGB(200,80,40) or Color3.fromRGB(45,45,55) end) end

local orbitBtn = buttonRefs["orbit"]
if orbitBtn then orbitBtn.MouseButton1Click:Connect(function() if orbitEnabled then stopOrbit() else refreshPlayerList(); PlayerSelectFrame.Visible = true end end) end

local headlessBtn = buttonRefs["headless"]
if headlessBtn then headlessBtn.MouseButton1Click:Connect(function() toggleHeadless(); headlessBtn.Text = headlessEnabled and "无头中..." or "无头效果"; headlessBtn.BackgroundColor3 = headlessEnabled and Color3.fromRGB(80,80,80) or Color3.fromRGB(45,45,55) end) end

local fireBtn = buttonRefs["fire"]
if fireBtn then fireBtn.MouseButton1Click:Connect(function() toggleFire(); fireBtn.Text = fireEnabled and "燃烧中..." or "燃烧效果"; fireBtn.BackgroundColor3 = fireEnabled and Color3.fromRGB(200,40,0) or Color3.fromRGB(45,45,55) end) end

local smokeBtn = buttonRefs["smoke"]
if smokeBtn then smokeBtn.MouseButton1Click:Connect(function() toggleSmoke(); smokeBtn.Text = smokeEnabled and "冒烟中..." or "烟雾效果"; smokeBtn.BackgroundColor3 = smokeEnabled and Color3.fromRGB(120,120,120) or Color3.fromRGB(45,45,55) end) end

local speedBtn = buttonRefs["speed"]
if speedBtn then speedBtn.MouseButton1Click:Connect(function() toggleSpeed(); speedBtn.Text = speedEnabled and "加速中..." or "加速脚本"; speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(200,170,0) or Color3.fromRGB(45,45,55) end) end

local jumpBtn = buttonRefs["jump"]
if jumpBtn then jumpBtn.MouseButton1Click:Connect(function() toggleJump(); jumpBtn.Text = jumpEnabled and "超级跳..." or "跳跃增强"; jumpBtn.BackgroundColor3 = jumpEnabled and Color3.fromRGB(40,200,80) or Color3.fromRGB(45,45,55) end) end

local noclipBtn = buttonRefs["noclip"]
if noclipBtn then noclipBtn.MouseButton1Click:Connect(function() toggleNoclip(); noclipBtn.Text = noclipEnabled and "穿墙中..." or "穿墙脚本"; noclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(140,80,40) or Color3.fromRGB(45,45,55) end) end

local espBtn = buttonRefs["esp"]
if espBtn then espBtn.MouseButton1Click:Connect(function() if espEnabled then espEnabled=false; clearESP(); espBtn.Text="ESP透视"; espBtn.BackgroundColor3=Color3.fromRGB(45,45,55) else espEnabled=true; createESP(); espBtn.Text="ESP中..."; espBtn.BackgroundColor3=Color3.fromRGB(200,40,80) end end) end

local carboostBtn = buttonRefs["carboost"]
if carboostBtn then carboostBtn.MouseButton1Click:Connect(function() if carboostEnabled then disableCarBoost() else enableCarBoost() end end) end

local instantBtn = buttonRefs["instantaction"]
if instantBtn then instantBtn.MouseButton1Click:Connect(function() if instantActionEnabled then disableInstantAction() else enableInstantAction() end end) end

if datamodBtn then
    datamodBtn.MouseButton1Click:Connect(function()
        if not isVIP then game:GetService("StarterGui"):SetCore("SendNotification",{Title="权限不足",Text="请升级到VIP",Duration=3}) return end
        if not dataWindow then createDataWindow() end; dataWindow.Visible = not dataWindow.Visible
    end)
end

local permanentBtn = buttonRefs["permanent"]
if permanentBtn then permanentBtn.MouseButton1Click:Connect(function() if writefile then pcall(function() writefile("FScriptHub_Permanent.dat","1") end) else Instance.new("BoolValue",CoreGui).Name="FScriptHubPermanent" end end) end
local unpermanentBtn = buttonRefs["unpermanent"]
if unpermanentBtn then unpermanentBtn.MouseButton1Click:Connect(function() if writefile then pcall(function() delfile("FScriptHub_Permanent.dat") end) end; local m = CoreGui:FindFirstChild("FScriptHubPermanent") if m then m:Destroy() end end) end

local teleportBtn = buttonRefs["teleport"]
if teleportBtn then teleportBtn.MouseButton1Click:Connect(function() refreshPlayerList(); PlayerSelectFrame.Visible = true; for _,b in ipairs(PlayerScroll:GetChildren()) do if b:IsA("TextButton") then b.MouseButton1Click:Connect(function() local p = Players:FindFirstChild(b.Text) if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local c = LocalPlayer.Character if c and c:FindFirstChild("HumanoidRootPart") then c:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3)) PlayerSelectFrame.Visible = false end end end) end end end) end

local marks = {}
local markpointBtn = buttonRefs["markpoint"]
if markpointBtn then markpointBtn.MouseButton1Click:Connect(function() local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if hrp then marks[#marks+1] = hrp.CFrame end end) end
local marklistBtn = buttonRefs["marklist"]
if marklistBtn then marklistBtn.MouseButton1Click:Connect(function() if #marks > 0 then local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame = marks[#marks]; table.remove(marks,#marks) end end end) end

local admintoolBtn = buttonRefs["admintool"]
if admintoolBtn then admintoolBtn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end) end) end

local serverscriptsBtn = buttonRefs["serverscripts"]
if serverscriptsBtn then serverscriptsBtn.MouseButton1Click:Connect(function() ServerPanel.Visible = not ServerPanel.Visible end) end

local ratio43Btn = buttonRefs["ratio43"]
if ratio43Btn then ratio43Btn.MouseButton1Click:Connect(function() Camera.FieldOfView = Camera.FieldOfView == 60 and 70 or 60; ratio43Btn.Text = Camera.FieldOfView == 60 and "4:3比例 (开)" or "4:3比例" end) end
local ultrawideBtn = buttonRefs["ultrawide"]
if ultrawideBtn then ultrawideBtn.MouseButton1Click:Connect(function() Camera.FieldOfView = Camera.FieldOfView == 100 and 70 or 100; ultrawideBtn.Text = Camera.FieldOfView == 100 and "超广角 (开)" or "超广角" end) end

local switchroleBtn = buttonRefs["switchrole"]
if switchroleBtn then switchroleBtn.MouseButton1Click:Connect(function()
    local selectFrame = Instance.new("Frame",ScreenGui); selectFrame.Size=UDim2.new(0,160,0,100); selectFrame.Position=UDim2.new(0.5,-80,0.5,-50)
    selectFrame.BackgroundColor3=Color3.fromRGB(35,35,42); selectFrame.BorderSizePixel=0; selectFrame.Active=true; selectFrame.Draggable=true
    Instance.new("UICorner",selectFrame).CornerRadius=UDim.new(0,6)
    local lbl = Instance.new("TextLabel",selectFrame); lbl.Size=UDim2.new(1,0,0,20); lbl.Position=UDim2.new(0,0,0,3); lbl.BackgroundTransparency=1; lbl.Text="选择身份"; lbl.TextColor3=Color3.white; lbl.TextSize=14; lbl.Font=Enum.Font.GothamBold
    local options = {
        {name="作者", role="author", col=Color3.fromRGB(255,215,0)},
        {name="VIP", role="vip", col=Color3.fromRGB(255,215,0)},
        {name="普通用户", role="normal", col=Color3.fromRGB(200,200,200)},
    }
    for i,opt in ipairs(options) do
        local optBtn = Instance.new("TextButton",selectFrame); optBtn.Size=UDim2.new(1,-16,0,22); optBtn.Position=UDim2.new(0,8,0,28+(i-1)*24)
        optBtn.BackgroundColor3=opt.col; optBtn.Text=opt.name; optBtn.TextColor3=Color3.white; optBtn.TextSize=12; optBtn.Font=Enum.Font.GothamBold; optBtn.BorderSizePixel=0
        Instance.new("UICorner",optBtn).CornerRadius=UDim.new(0,3)
        optBtn.MouseButton1Click:Connect(function() currentRole = opt.role; isAuthor = currentRole=="author"; isVIP = currentRole=="author" or currentRole=="vip"
            RoleLabel.Text = opt.name; if datamodBtn then if isVIP then datamodBtn.Text="数据修改器"; datamodBtn.BackgroundColor3=Color3.fromRGB(45,45,55); datamodBtn.TextColor3=Color3.white else datamodBtn.Text="数据修改器 (VIP)"; datamodBtn.BackgroundColor3=Color3.fromRGB(80,80,80); datamodBtn.TextColor3=Color3.fromRGB(180,180,180) end end
            selectFrame:Destroy()
            game:GetService("StarterGui"):SetCore("SendNotification",{Title="身份切换",Text="已切换为 "..opt.name,Duration=3})
        end)
    end
end) end

local sponsorBtn = buttonRefs["sponsor"]
if sponsorBtn then sponsorBtn.MouseButton1Click:Connect(function() pcall(function() setclipboard(IMAGE_URL) end) end) end

-- 缩小动画
local miniIcon, animating = nil, false
local function createMiniIcon()
    if miniIcon then return end
    miniIcon = Instance.new("TextButton", ScreenGui)
    miniIcon.Size = UDim2.new(0,40,0,40); miniIcon.Position = UDim2.new(0,8,0.5,-20)
    miniIcon.BackgroundColor3 = Color3.fromRGB(255,100,0); miniIcon.Text = "F"; miniIcon.TextColor3 = Color3.white; miniIcon.Font = Enum.Font.GothamBlack; miniIcon.TextSize = 20
    miniIcon.BorderSizePixel = 0; miniIcon.ZIndex = 100; miniIcon.Active = true; miniIcon.Draggable = true
    Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(0,8)
    miniIcon.Visible = false
    miniIcon.MouseButton1Click:Connect(function()
        if animating then return end
        animating = true; miniIcon.Visible = false
        local startPos = miniIcon.Position
        TweenService:Create(miniIcon, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position=UDim2.new(0.5,-20,0.5,-20), TextTransparency=1, BackgroundTransparency=1}):Play()
        task.delay(0.4, function()
            miniIcon.Position = startPos; miniIcon.TextTransparency = 0; miniIcon.BackgroundTransparency = 0
            MainFrame.Position = UDim2.new(0.5,-frameWidth/2,0.5,-frameHeight/2); MainFrame.Size = UDim2.new(0,0,0,0); MainFrame.BackgroundTransparency = 1; MainFrame.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0,frameWidth,0,frameHeight), BackgroundTransparency=0.35}):Play()
            animating = false
        end)
    end)
end
local function minimizeUI()
    if animating or not MainFrame.Visible then return end
    animating = true; createMiniIcon()
    local targetPos = miniIcon.Position
    TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size=UDim2.new(0,0,0,0), Position=targetPos, BackgroundTransparency=1}):Play()
    task.delay(0.45, function() MainFrame.Visible = false; miniIcon.Visible = true; MainFrame.Position = UDim2.new(0.5,-frameWidth/2,0.5,-frameHeight/2); animating = false end)
end
CloseBtn.MouseButton1Click:Connect(minimizeUI)

-- F按钮
local openBtn = Instance.new("TextButton", ScreenGui)
openBtn.Size = UDim2.new(0,40,0,40); openBtn.Position = UDim2.new(0,8,0.5,-20)
openBtn.BackgroundColor3 = Color3.fromRGB(0,162,255); openBtn.Text = "F"; openBtn.TextColor3 = Color3.white; openBtn.Font = Enum.Font.GothamBlack; openBtn.TextSize = 20; openBtn.BorderSizePixel = 0
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0,8)
openBtn.MouseButton1Click:Connect(function()
    if miniIcon and miniIcon.Visible then miniIcon.MouseButton1Click:Fire() return end
    if not MainFrame.Visible then MainFrame.Visible = true; TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0,frameWidth,0,frameHeight)}):Play()
    else minimizeUI() end
end)

-- 重生恢复
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if flyEnabled then disableFly(); task.wait(0.5); enableFly(); flyLoop() end
    if spinEnabled then local hrp = char:FindFirstChild("HumanoidRootPart") if hrp then local bav = Instance.new("BodyAngularVelocity",hrp); bav.Name="SpinVelocity"; bav.AngularVelocity=Vector3.new(0,spinSpeed,0); bav.MaxTorque=Vector3.new(0,9e9,0) end end
    if noclipEnabled then stopNoclip(); task.wait(0.5); startNoclip() end
    if espEnabled then task.wait(1); createESP() end
end)

game:GetService("StarterGui"):SetCore("SendNotification",{Title="F脚本中心",Text="全功能已就绪",Duration=4})
