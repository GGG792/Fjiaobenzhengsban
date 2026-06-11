-- ============================================
-- F脚本中心 v6.0 启动器
-- 风格与主脚本界面统一
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local MAIN_URL = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/zhengw.lua"

-- 屏幕适配
local screenSize = Camera.ViewportSize
local isMobile = UserInputService.TouchEnabled
local baseW, baseH = 320, 220
local scale = math.min(screenSize.X / baseW, screenSize.Y / baseH, 1.2)
if isMobile then scale = math.min(scale, 1.0) end
local fw = math.floor(baseW * scale)
local fh = math.floor(baseH * scale)

-- 清理旧启动器
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("FScriptLoader") then
        LocalPlayer.PlayerGui.FScriptLoader:Destroy()
    end
end)

-- ========== 创建界面 ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FScriptLoader"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 主框架（与主脚本同款深色背景）
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, fw, 0, fh)
MainFrame.Position = UDim2.new(0.5, -fw/2, 0.5, -fh/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- 炫彩流光边框（与主脚本同款）
local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 3
MainStroke.Transparency = 0.15
MainStroke.Parent = MainFrame
coroutine.wrap(function()
    while MainStroke and MainStroke.Parent do
        MainStroke.Color = Color3.fromHSV((tick() * 0.4) % 1, 1, 1)
        RunService.RenderStepped:Wait()
    end
end)()

-- ========== 标题栏（与主脚本同款布局） ==========
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, math.floor(50 * scale))
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.BackgroundTransparency = 0.3
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

-- F 图标（与主脚本同款蓝色圆角方块）
local IconSize = math.floor(36 * scale)
local TitleIcon = Instance.new("TextLabel")
TitleIcon.Parent = TitleBar
TitleIcon.Size = UDim2.new(0, IconSize, 0, IconSize)
TitleIcon.Position = UDim2.new(0, math.floor(10 * scale), 0, math.floor(7 * scale))
TitleIcon.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
TitleIcon.Text = "F"
TitleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleIcon.Font = Enum.Font.GothamBlack
TitleIcon.TextSize = math.floor(20 * scale)

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 10)
IconCorner.Parent = TitleIcon

-- 标题文字
local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(0, 180, 0, math.floor(22 * scale))
TitleText.Position = UDim2.new(0, math.floor(52 * scale), 0, math.floor(6 * scale))
TitleText.BackgroundTransparency = 1
TitleText.Text = "F脚本中心"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = math.floor(18 * scale)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- 副标题
local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = TitleBar
SubTitle.Size = UDim2.new(0, 180, 0, math.floor(14 * scale))
SubTitle.Position = UDim2.new(0, math.floor(52 * scale), 0, math.floor(28 * scale))
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "v6.0 模块化版"
SubTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
SubTitle.TextSize = math.floor(11 * scale)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left

-- ========== 内容区域 ==========
local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, -16, 1, -math.floor(58 * scale))
ContentFrame.Position = UDim2.new(0, 8, 0, math.floor(54 * scale))
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
ContentFrame.BackgroundTransparency = 0.4
ContentFrame.BorderSizePixel = 0

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 12)
ContentCorner.Parent = ContentFrame

-- 欢迎文字
local WelcomeText = Instance.new("TextLabel")
WelcomeText.Parent = ContentFrame
WelcomeText.Size = UDim2.new(1, -10, 0, math.floor(24 * scale))
WelcomeText.Position = UDim2.new(0, 5, 0, math.floor(8 * scale))
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "欢迎使用 F脚本中心"
WelcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeText.TextSize = math.floor(14 * scale)
WelcomeText.Font = Enum.Font.GothamBold

-- 状态文字
local StatusText = Instance.new("TextLabel")
StatusText.Parent = ContentFrame
StatusText.Size = UDim2.new(1, -10, 0, math.floor(18 * scale))
StatusText.Position = UDim2.new(0, 5, 0, math.floor(34 * scale))
StatusText.BackgroundTransparency = 1
StatusText.Text = "点击下方按钮启动脚本"
StatusText.TextColor3 = Color3.fromRGB(150, 150, 255)
StatusText.TextSize = math.floor(11 * scale)
StatusText.Font = Enum.Font.Gotham

-- 进度条背景
local ProgressBg = Instance.new("Frame")
ProgressBg.Parent = ContentFrame
ProgressBg.Size = UDim2.new(1, -20, 0, math.floor(6 * scale))
ProgressBg.Position = UDim2.new(0, 10, 0, math.floor(56 * scale))
ProgressBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ProgressBg.BorderSizePixel = 0
ProgressBg.BackgroundTransparency = 0.5

local ProgressCorner = Instance.new("UICorner")
ProgressCorner.CornerRadius = UDim.new(0, 3)
ProgressCorner.Parent = ProgressBg

-- 进度条前景
local ProgressFill = Instance.new("Frame")
ProgressFill.Parent = ProgressBg
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
ProgressFill.BorderSizePixel = 0

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 3)
FillCorner.Parent = ProgressFill

-- 进度条流光
local ProgressStroke = Instance.new("UIStroke")
ProgressStroke.Thickness = 1
ProgressStroke.Transparency = 0.3
ProgressStroke.Color = Color3.fromRGB(0, 200, 255)
ProgressStroke.Parent = ProgressFill

-- ========== 启动按钮 ==========
local btnW = math.floor(200 * scale)
local btnH = math.floor(42 * scale)
local StartBtn = Instance.new("TextButton")
StartBtn.Parent = ContentFrame
StartBtn.Size = UDim2.new(0, btnW, 0, btnH)
StartBtn.Position = UDim2.new(0.5, -btnW/2, 0, math.floor(72 * scale))
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
StartBtn.Text = "启  动  脚  本"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.TextSize = math.floor(15 * scale)
StartBtn.Font = Enum.Font.GothamBlack
StartBtn.BorderSizePixel = 0
StartBtn.AutoButtonColor = false

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = StartBtn

-- 按钮流光边框
local BtnStroke = Instance.new("UIStroke")
BtnStroke.Thickness = 2
BtnStroke.Transparency = 0.4
BtnStroke.Color = Color3.fromRGB(100, 200, 255)
BtnStroke.Parent = StartBtn

-- ========== 按钮动画 ==========
local hoverSize = UDim2.new(0, btnW + 12, 0, btnH + 4)
local normalSize = UDim2.new(0, btnW, 0, btnH)
local hoverColor = Color3.fromRGB(30, 180, 255)
local normalColor = Color3.fromRGB(0, 162, 255)
local pressColor = Color3.fromRGB(0, 130, 220)

StartBtn.MouseEnter:Connect(function()
    TweenService:Create(StartBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = hoverSize, BackgroundColor3 = hoverColor
    }):Play()
    BtnStroke.Transparency = 0.15
end)

StartBtn.MouseLeave:Connect(function()
    TweenService:Create(StartBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = normalSize, BackgroundColor3 = normalColor
    }):Play()
    BtnStroke.Transparency = 0.4
end)

StartBtn.MouseButton1Down:Connect(function()
    TweenService:Create(StartBtn, TweenInfo.new(0.1), {
        Size = UDim2.new(0, btnW - 6, 0, btnH - 3), BackgroundColor3 = pressColor
    }):Play()
end)

StartBtn.MouseButton1Up:Connect(function()
    TweenService:Create(StartBtn, TweenInfo.new(0.15), {
        Size = hoverSize, BackgroundColor3 = hoverColor
    }):Play()
end)

-- ========== 入场动画 ==========
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BackgroundTransparency = 1
TitleBar.BackgroundTransparency = 1
ContentFrame.BackgroundTransparency = 1
StartBtn.TextTransparency = 1
WelcomeText.TextTransparency = 1
StatusText.TextTransparency = 1

TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, fw, 0, fh),
    BackgroundTransparency = 0.2
}):Play()

task.delay(0.15, function()
    TweenService:Create(TitleBar, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0.3
    }):Play()
    TweenService:Create(ContentFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0.4
    }):Play()
end)

task.delay(0.3, function()
    TweenService:Create(WelcomeText, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(StatusText, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(StartBtn, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
end)

-- ========== 模拟进度条动画 ==========
local progressAnim = coroutine.wrap(function()
    while ProgressFill and ProgressFill.Parent do
        local current = ProgressFill.Size.X.Offset
        if current < (ProgressBg.Size.X.Offset - 4) then
            TweenService:Create(ProgressFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, current + math.random(5, 15), 1, 0)
            }):Play()
        end
        task.wait(math.random(0.3, 0.8))
    end
end)
progressAnim()

-- ========== 点击启动 ==========
local isLoading = false

StartBtn.MouseButton1Click:Connect(function()
    if isLoading then return end
    isLoading = true

    -- 更新状态
    StartBtn.Text = "加 载 中 . . ."
    StartBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    BtnStroke.Color = Color3.fromRGB(150, 150, 150)
    StatusText.Text = "正在连接服务器..."
    StatusText.TextColor3 = Color3.fromRGB(255, 220, 0)

    -- 进度条快速填满动画
    local targetW = ProgressBg.Size.X.Offset - 4
    TweenService:Create(ProgressFill, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, targetW * 0.5, 1, 0)
    }):Play()

    task.delay(0.3, function()
        StatusText.Text = "正在下载主脚本..."
        TweenService:Create(ProgressFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, targetW * 0.8, 1, 0)
        }):Play()
    end)

    task.delay(0.6, function()
        StatusText.Text = "正在初始化模块..."
        TweenService:Create(ProgressFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, targetW, 1, 0)
        }):Play()
    end)

    -- 实际加载
    task.delay(0.8, function()
        local success, err = pcall(function()
            local code = game:HttpGet(MAIN_URL)
            if code and #code > 100 then
                StatusText.Text = "正在执行脚本..."
                ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
                ProgressStroke.Color = Color3.fromRGB(0, 255, 150)
                loadstring(code)()
            else
                error("获取脚本失败，返回内容过短")
            end
        end)

        if not success then
            -- 加载失败
            StartBtn.Text = "启  动  失  败"
            StartBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            BtnStroke.Color = Color3.fromRGB(255, 100, 100)
            StatusText.Text = "加载失败，请重试"
            StatusText.TextColor3 = Color3.fromRGB(255, 80, 80)
            ProgressFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            ProgressStroke.Color = Color3.fromRGB(255, 80, 80)
            TweenService:Create(ProgressFill, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 0, 1, 0)
            }):Play()

            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "启动失败",
                    Text = tostring(err):sub(1, 50) or "请检查网络连接",
                    Duration = 5
                })
            end)

            -- 3秒后恢复按钮
            task.delay(3, function()
                isLoading = false
                StartBtn.Text = "启  动  脚  本"
                StartBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
                BtnStroke.Color = Color3.fromRGB(100, 200, 255)
                StatusText.Text = "点击下方按钮启动脚本"
                StatusText.TextColor3 = Color3.fromRGB(150, 150, 255)
                ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
                ProgressStroke.Color = Color3.fromRGB(0, 200, 255)
                progressAnim()
            end)
        else
            -- 加载成功 - 淡出关闭
            StatusText.Text = "加载成功！"
            StatusText.TextColor3 = Color3.fromRGB(0, 255, 150)

            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, fw * 0.8, 0, fh * 0.8)
            }):Play()

            TweenService:Create(TitleBar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(ContentFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(StartBtn, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(WelcomeText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(StatusText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()

            task.delay(0.5, function()
                ScreenGui:Destroy()
            end)
        end
    end)
end)

-- ========== 通知 ==========
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "F脚本中心",
        Text = "v6.0 模块化版 - 点击启动按钮开始",
        Duration = 3
    })
end)
