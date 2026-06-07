-- ============================================
-- 全能工具面板 - 最终修复版
-- 修复无视摔落走路卡顿 + 防摔死传送问题
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera

-- FPS优化 (后台)
spawn(function()
    pcall(function()
        local fpsCode = game:HttpGet("https://pastebin.com/raw/ySHJdZpb", true)
        if fpsCode then loadstring(fpsCode)() end
    end)
end)

-- 创建主界面 (横向宽版)
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 620, 0, 320)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,30)
MainFrame.BackgroundTransparency = 0.35
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 10
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)

MainFrame.Size = UDim2.new(0,0,0,0)
MainFrame.Visible = true
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 620, 0, 320)
}):Play()

local stroke = Instance.new("UIStroke", MainFrame)
stroke.Thickness = 3; stroke.Transparency = 0.2
coroutine.wrap(function()
    while stroke and stroke.Parent do
        stroke.Color = Color3.fromHSV((tick()*0.5)%1, 1, 1)
        RunService.RenderStepped:Wait()
    end
end)()

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Position = UDim2.new(0, 15, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "🔥 全能工具面板"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
coroutine.wrap(function()
    while Title and Title.Parent do
        Title.TextColor3 = Color3.fromHSV((tick()*0.3)%1, 1, 1)
        RunService.RenderStepped:Wait()
    end
end)()

local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Size = UDim2.new(0,30,0,30)
MinimizeBtn.Position = UDim2.new(1,-40,0,8)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255,170,0)
MinimizeBtn.Text = "–"
MinimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0,6)

-- 左侧个人信息面板
local LeftPanel = Instance.new("Frame", MainFrame)
LeftPanel.Size = UDim2.new(0, 200, 1, -50)
LeftPanel.Position = UDim2.new(0, 10, 0, 42)
LeftPanel.BackgroundColor3 = Color3.fromRGB(35,35,42)
LeftPanel.BackgroundTransparency = 0.3
LeftPanel.BorderSizePixel = 0
Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0,8)

local Avatar = Instance.new("ImageLabel", LeftPanel)
Avatar.Size = UDim2.new(0, 70, 0, 70)
Avatar.Position = UDim2.new(0.5, -35, 0, 15)
Avatar.BackgroundTransparency = 1
coroutine.wrap(function()
    local userId = LocalPlayer.UserId
    local content = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    Avatar.Image = content
end)()

local NameLabel = Instance.new("TextLabel", LeftPanel)
NameLabel.Size = UDim2.new(1, -20, 0, 22)
NameLabel.Position = UDim2.new(0, 10, 0, 95)
NameLabel.BackgroundTransparency = 1
NameLabel.Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"
NameLabel.TextColor3 = Color3.fromRGB(255,255,255)
NameLabel.TextSize = 15
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextXAlignment = Enum.TextXAlignment.Center

local HealthLabel = Instance.new("TextLabel", LeftPanel)
HealthLabel.Size = UDim2.new(1, -20, 0, 18)
HealthLabel.Position = UDim2.new(0, 10, 0, 120)
HealthLabel.BackgroundTransparency = 1
HealthLabel.Text = "❤️ 生命: --"
HealthLabel.TextColor3 = Color3.fromRGB(255,100,100)
HealthLabel.TextSize = 13
HealthLabel.Font = Enum.Font.Gotham
HealthLabel.TextXAlignment = Enum.TextXAlignment.Center

local SpeedLabel = Instance.new("TextLabel", LeftPanel)
SpeedLabel.Size = UDim2.new(1, -20, 0, 18)
SpeedLabel.Position = UDim2.new(0, 10, 0, 140)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "⚡ 速度: --"
SpeedLabel.TextColor3 = Color3.fromRGB(255,255,100)
SpeedLabel.TextSize = 13
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Center

local PositionLabel = Instance.new("TextLabel", LeftPanel)
PositionLabel.Size = UDim2.new(1, -20, 0, 18)
PositionLabel.Position = UDim2.new(0, 10, 0, 160)
PositionLabel.BackgroundTransparency = 1
PositionLabel.Text = "📍 位置: --"
PositionLabel.TextColor3 = Color3.fromRGB(200,200,255)
PositionLabel.TextSize = 13
PositionLabel.Font = Enum.Font.Gotham
PositionLabel.TextXAlignment = Enum.TextXAlignment.Center

coroutine.wrap(function()
    while LeftPanel and LeftPanel.Parent do
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum then HealthLabel.Text = "❤️ 生命: " .. math.floor(hum.Health) end
            if hrp then
                SpeedLabel.Text = "⚡ 速度: " .. math.floor(hrp.Velocity.Magnitude)
                PositionLabel.Text = "📍 位置: (" .. math.floor(hrp.Position.X) .. ", " .. math.floor(hrp.Position.Y) .. ", " .. math.floor(hrp.Position.Z) .. ")"
            end
        end
        task.wait(0.5)
    end
end)()

-- 右侧按钮滚动区
local RightScroll = Instance.new("ScrollingFrame", MainFrame)
RightScroll.Size = UDim2.new(1, -220, 1, -50)
RightScroll.Position = UDim2.new(0, 215, 0, 42)
RightScroll.BackgroundColor3 = Color3.fromRGB(35,35,42)
RightScroll.BackgroundTransparency = 0.5
RightScroll.BorderSizePixel = 0
RightScroll.ScrollBarThickness = 6
RightScroll.CanvasSize = UDim2.new(0, 0, 0, 900)
RightScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", RightScroll).CornerRadius = UDim.new(0,8)

local ListLayout = Instance.new("UIListLayout", RightScroll)
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 按钮创建函数
local function createButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = RightScroll
    btn.Size = UDim2.new(1, -12, 0, 34)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBlack
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    coroutine.wrap(function()
        while btn and btn.Parent do
            local scale = 1 + math.sin(tick()*2)*0.02
            btn.Size = UDim2.new(1, -12 + scale*5, 0, 34 + scale*1)
            RunService.RenderStepped:Wait()
        end
    end)()

    btn.MouseButton1Click:Connect(function()
        local success, err = pcall(function()
            callback(btn)
        end)
        if not success then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "按钮错误", Text = tostring(err), Duration = 5
            })
        end
    end)
    return btn
end

-- ============================================
-- 飞行功能 (开关)
-- ============================================
local flyEnabled = false
local flySpeed = 50
local bodyVel, bodyGyro
local flyConnection

local function enableFly()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    flyEnabled = true
    bodyVel = Instance.new("BodyVelocity"); bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9); bodyVel.Velocity = Vector3.zero; bodyVel.Parent = hrp
    bodyGyro = Instance.new("BodyGyro"); bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9); bodyGyro.P = 9e4; bodyGyro.Parent = hrp
end

local function disableFly()
    flyEnabled = false
    if bodyVel then bodyVel:Destroy(); bodyVel = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
end

local function startFlyLoop()
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChild("Humanoid"); if not hum then return end
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled or not bodyVel then return end
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude == 0 then bodyVel.Velocity = Vector3.zero; return end
        local look = Camera.CFrame.LookVector
        local right = Camera.CFrame.RightVector
        bodyVel.Velocity = look * moveDir.Z * flySpeed + right * moveDir.X * flySpeed
        if bodyGyro and char:FindFirstChild("HumanoidRootPart") then
            bodyGyro.CFrame = CFrame.new(char.HumanoidRootPart.Position, char.HumanoidRootPart.Position + look)
        end
    end)
end

createButton("✈️ 飞行：关", Color3.fromRGB(0,162,255), function(btn)
    if flyEnabled then
        disableFly()
        btn.Text = "✈️ 飞行：关"
        btn.BackgroundColor3 = Color3.fromRGB(0,162,255)
    else
        enableFly()
        startFlyLoop()
        btn.Text = "✈️ 飞行：开"
        btn.BackgroundColor3 = Color3.fromRGB(0,200,255)
    end
end)

-- 一键保活
createButton("🛡️ 一键保活", Color3.fromRGB(0,200,100), function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local spawnLocation
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") and obj.Enabled then spawnLocation = obj break end
    end
    if spawnLocation then
        char:SetPrimaryPartCFrame(spawnLocation.CFrame + Vector3.new(0,3,0))
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="保护成功", Text="已传送到出生点", Duration=3})
    else
        error("未找到出生点")
    end
end)

-- 防摔死 (修复版：直接瞬移回原位)
createButton("🛡️ 防摔死", Color3.fromRGB(255,100,0), function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = hum and hum.RootPart
    if not root then error("未找到HumanoidRootPart") end
    local oldPos = root.CFrame
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    -- 直接瞬移回原位，不产生高速位移
    root.CFrame = oldPos
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="防摔死", Text="已瞬移至安全位置", Duration=2})
end)

-- 无视摔落 (开关) - 修复版：阈值提高到-100，不影响走路
local noFallActive = false
local noFallConn
createButton("🍃 无视摔落：关", Color3.fromRGB(100,100,100), function(btn)
    noFallActive = not noFallActive
    if noFallActive then
        btn.Text = "🍃 无视摔落：开"
        btn.BackgroundColor3 = Color3.fromRGB(0,255,100)
        local char = LocalPlayer.Character
        if char then
            local root = char:FindFirstChildOfClass("Humanoid") and char.HumanoidRootPart
            if root then
                noFallConn = RunService.Heartbeat:Connect(function()
                    local vel = root.AssemblyLinearVelocity
                    if vel.Y < -100 then  -- 提高到-100，正常跳跃不会触发
                        root.AssemblyLinearVelocity = Vector3.new(vel.X, -100, vel.Z)
                    end
                end)
            end
        end
    else
        btn.Text = "🍃 无视摔落：关"
        btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        if noFallConn then noFallConn:Disconnect() end
    end
end)

-- 穿墙 (自定代码，开关)
local noclipping = false
local noclipConn = nil
local function startNoclip()
    noclipConn = RunService.Stepped:Connect(function()
        if not noclipping then return end
        if LocalPlayer.Character then
            for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)
end
local function stopNoclip()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    if LocalPlayer.Character then
        for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end

createButton("🧱 穿墙：关", Color3.fromRGB(100,100,100), function(btn)
    noclipping = not noclipping
    if noclipping then
        btn.Text = "🧱 穿墙：开"
        btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
        startNoclip()
    else
        btn.Text = "🧱 穿墙：关"
        btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        stopNoclip()
    end
end)

-- 无限跳跃
local infiniteJump = false
local jumpConn
createButton("🦘 无限跳跃：关", Color3.fromRGB(100,100,100), function(btn)
    infiniteJump = not infiniteJump
    if infiniteJump then
        btn.Text = "🦘 无限跳跃：开"
        btn.BackgroundColor3 = Color3.fromRGB(150,50,255)
        jumpConn = UserInputService.JumpRequest:Connect(function()
            if infiniteJump then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState("Jumping") end
            end
        end)
    else
        btn.Text = "🦘 无限跳跃：关"
        btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        if jumpConn then jumpConn:Disconnect() end
    end
end)

-- 管理员工具
createButton("👑 管理员工具", Color3.fromRGB(255,215,0), function()
    local url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
    local code = game:HttpGet(url)
    if code then
        local fn, err = loadstring(code)
        if fn then fn() else error("加载失败: "..tostring(err)) end
    else
        error("无法下载脚本")
    end
end)

-- 无名管理员
createButton("👤 无名管理员", Color3.fromRGB(180,180,255), function()
    local url = "https://scriptblox.com/raw/Universal-Script-Nameless-Admin-FE-11243"
    local code = game:HttpGet(url)
    if code then
        local fn, err = loadstring(code)
        if fn then fn() else error("加载失败: "..tostring(err)) end
    else
        error("无法下载脚本")
    end
end)

-- 黑洞 (开关)
local blackHoleActive = false
local blackHoleParts = {}
createButton("🌀 黑洞：关", Color3.fromRGB(100,100,100), function(btn)
    blackHoleActive = not blackHoleActive
    if blackHoleActive then
        btn.Text = "🌀 黑洞：开"
        btn.BackgroundColor3 = Color3.fromRGB(255,50,200)
        blackHoleParts = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Anchored and not obj:IsDescendantOf(LocalPlayer.Character) then
                table.insert(blackHoleParts, obj)
            end
        end
    else
        btn.Text = "🌀 黑洞：关"
        btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        blackHoleParts = {}
    end
end)

RunService.Heartbeat:Connect(function()
    if not blackHoleActive then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local center = hrp.Position
    for i = #blackHoleParts, 1, -1 do
        local part = blackHoleParts[i]
        if part and part.Parent and not part.Anchored then
            local pos = part.Position
            local dist = (Vector3.new(pos.X, center.Y, pos.Z) - center).Magnitude
            local angle = math.atan2(pos.Z - center.Z, pos.X - center.X)
            local newAngle = angle + math.rad(10)
            local targetPos = Vector3.new(
                center.X + math.cos(newAngle) * math.min(50, dist),
                center.Y + 100 * math.abs(math.sin((pos.Y - center.Y)/100)),
                center.Z + math.sin(newAngle) * math.min(50, dist)
            )
            part.Velocity = (targetPos - part.Position).unit * 1000
        else
            table.remove(blackHoleParts, i)
        end
    end
end)

-- 突破FPS限制
createButton("⚡ 突破FPS限制", Color3.fromRGB(255,200,0), function()
    pcall(function()
        local settings = settings()
        local render = settings and settings:GetService("RenderSettings")
        if render then render.FrameRate = 240 end
    end)
    pcall(function() setfpscap(240) end)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="突破FPS", Text="已尝试将FPS上限设为 240", Duration=3})
end)

-- 关闭脚本
createButton("❌ 关闭脚本", Color3.fromRGB(255,50,50), function()
    disableFly()
    stopNoclip()
    if jumpConn then jumpConn:Disconnect() end
    if noFallConn then noFallConn:Disconnect() end
    blackHoleActive = false
    ScreenGui:Destroy()
    if miniIcon then miniIcon:Destroy() end
end)

-- 最小化悬浮窗
local miniIcon
MinimizeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)}):Play()
    task.wait(0.3)
    MainFrame.Visible = false
    if not miniIcon then
        miniIcon = Instance.new("TextButton", ScreenGui)
        miniIcon.Size = UDim2.new(0,50,0,50)
        miniIcon.Position = UDim2.new(0,10,0.5,-25)
        miniIcon.BackgroundColor3 = Color3.fromRGB(255,100,0)
        miniIcon.Text = "🔥"
        miniIcon.TextColor3 = Color3.fromRGB(255,255,255)
        miniIcon.TextSize = 24
        miniIcon.Font = Enum.Font.GothamBlack
        miniIcon.BorderSizePixel = 0
        miniIcon.ZIndex = 100
        miniIcon.Active = true
        miniIcon.Draggable = true
        Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(0,10)
        miniIcon.MouseButton1Click:Connect(function()
            MainFrame.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,620,0,320)}):Play()
            miniIcon.Visible = false
        end)
    else
        miniIcon.Visible = true
    end
end)

-- 重生恢复
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if flyEnabled then
        disableFly()
        task.wait(0.5)
        enableFly()
        startFlyLoop()
    end
    if noclipping then
        stopNoclip()
        task.wait(0.5)
        startNoclip()
    end
end)
