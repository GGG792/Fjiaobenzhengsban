-- ============================================
-- F脚本中心 正式版启动器
-- 点击启动后加载 Main.lua
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local MAIN_URL = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/zhengw.lua"

-- 创建启动器界面
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LoaderGui"
ScreenGui.Parent = LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Name = "LoaderFrame"
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 280, 0, 160)
Frame.Position = UDim2.new(0.5, -140, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Frame

-- 炫彩流光边框
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 3
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
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 15)
Title.BackgroundTransparency = 1
Title.Text = "F脚本中心 正式版"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBlack

-- 版本标识
local VersionLabel = Instance.new("TextLabel")
VersionLabel.Parent = Frame
VersionLabel.Size = UDim2.new(1, 0, 0, 20)
VersionLabel.Position = UDim2.new(0, 0, 0, 50)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v4.7 正式版"
VersionLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
VersionLabel.TextSize = 14
VersionLabel.Font = Enum.Font.GothamBold

-- 启动按钮
local StartBtn = Instance.new("TextButton")
StartBtn.Parent = Frame
StartBtn.Size = UDim2.new(0, 200, 0, 45)
StartBtn.Position = UDim2.new(0.5, -100, 0, 85)
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
StartBtn.Text = "启动脚本"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.TextSize = 18
StartBtn.Font = Enum.Font.GothamBlack
StartBtn.BorderSizePixel = 0

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = StartBtn

-- 按钮缩放动画
local enterTween = TweenService:Create(StartBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 210, 0, 50)})
local leaveTween = TweenService:Create(StartBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 45)})
StartBtn.MouseEnter:Connect(function() enterTween:Play() end)
StartBtn.MouseLeave:Connect(function() leaveTween:Play() end)

-- 点击启动
StartBtn.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet(MAIN_URL))()
    end)
    if not success then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "启动失败",
            Text = "错误: " .. tostring(err),
            Duration = 5
        })
    else
        ScreenGui:Destroy()  -- 启动成功后关闭启动器
    end
end)
