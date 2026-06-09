-- ============================================
-- F脚本中心 正式版启动器 (手机端适配)
-- 点击启动后加载 Main.lua
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local MAIN_URL = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/zhengw.lua"

-- 获取屏幕尺寸并计算适配
local screenSize = Camera.ViewportSize
local isMobile = UserInputService.TouchEnabled
local scale = math.min(screenSize.X / 300, screenSize.Y / 200, 1)
if isMobile then scale = math.min(scale, 0.9) end

local frameWidth = math.floor(280 * scale)
local frameHeight = math.floor(150 * scale)

-- 创建启动器界面
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LoaderGui"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Name = "LoaderFrame"
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
Frame.Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.ClipsDescendants = false

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Frame

-- 炫彩流光边框
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Transparency = 0.2
Stroke.Parent = Frame
coroutine.wrap(function()
    while Stroke and Stroke.Parent do
        local hue = (tick() * 0.5) % 1
        Stroke.Color = Color3.fromHSV(hue, 1, 1)
        RunService.RenderStepped:Wait()
    end
end)()

-- 标题
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, math.floor(25 * scale))
Title.Position = UDim2.new(0, 0, 0, math.floor(10 * scale))
Title.BackgroundTransparency = 1
Title.Text = "F脚本中心"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = math.floor(18 * scale)
Title.Font = Enum.Font.GothamBlack

-- 版本标识
local VersionLabel = Instance.new("TextLabel")
VersionLabel.Parent = Frame
VersionLabel.Size = UDim2.new(1, 0, 0, math.floor(16 * scale))
VersionLabel.Position = UDim2.new(0, 0, 0, math.floor(38 * scale))
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v4.7 正式版"
VersionLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
VersionLabel.TextSize = math.floor(11 * scale)
VersionLabel.Font = Enum.Font.GothamBold

-- 启动按钮
local btnWidth = math.floor(180 * scale)
local btnHeight = math.floor(38 * scale)
local StartBtn = Instance.new("TextButton")
StartBtn.Parent = Frame
StartBtn.Size = UDim2.new(0, btnWidth, 0, btnHeight)
StartBtn.Position = UDim2.new(0.5, -btnWidth/2, 0, math.floor(65 * scale))
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
StartBtn.Text = "启动脚本"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.TextSize = math.floor(15 * scale)
StartBtn.Font = Enum.Font.GothamBlack
StartBtn.BorderSizePixel = 0

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = StartBtn

-- 按钮缩放动画
local enterTween = TweenService:Create(StartBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, btnWidth + 10, 0, btnHeight + 5)})
local leaveTween = TweenService:Create(StartBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, btnWidth, 0, btnHeight)})
StartBtn.MouseEnter:Connect(function() enterTween:Play() end)
StartBtn.MouseLeave:Connect(function() leaveTween:Play() end)

-- 点击启动
StartBtn.MouseButton1Click:Connect(function()
    StartBtn.Text = "加载中..."
    StartBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    local success, err = pcall(function()
        loadstring(game:HttpGet(MAIN_URL))()
    end)
    
    if not success then
        StartBtn.Text = "启动脚本"
        StartBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "启动失败",
                Text = "请检查网络连接",
                Duration = 3
            })
        end)
    else
        ScreenGui:Destroy()
    end
end)

-- 通知
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "F脚本中心",
        Text = "点击启动按钮开始",
        Duration = 3
    })
end)
