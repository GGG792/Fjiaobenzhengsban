-- F脚本中心 v6.0 模块化版本
-- 所有功能通过模块动态加载
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

-- 模块基础URL
local MODULE_URL = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/modules/"

-- 加载UI框架模块
local UI = loadstring(game:HttpGet(MODULE_URL .. "UIFramework.lua"))()

-- 创建主UI
local uiElements = UI.createMainUI()
local ScreenGui = uiElements.ScreenGui
local MainFrame = uiElements.MainFrame
local LeftPanel = uiElements.LeftPanel
local RightPanel = uiElements.RightPanel
local ScrollFrame = uiElements.ScrollFrame
local WelcomeLabel = uiElements.WelcomeLabel
local buttons = uiElements.buttons
local openBtn = uiElements.openBtn

-- 功能按钮定义 (id -> 模块名映射)
local btnDefs = {
    {name = "启用飞行",    icon = "✈",  color = Color3.fromRGB(0,162,255),   id = "fly",       module = "Fly"},
    {name = "旋转脚本",    icon = "🔄", color = Color3.fromRGB(255,100,50),  id = "spin",      module = "Spin"},
    {name = "环绕旋转",    icon = "🪐", color = Color3.fromRGB(150,50,255),  id = "orbit",     module = "Orbit"},
    {name = "无头效果",    icon = "👤", color = Color3.fromRGB(100,100,100),  id = "headless",  module = "Headless"},
    {name = "燃烧效果",    icon = "🔥", color = Color3.fromRGB(255,50,0),    id = "fire",       module = "FireEffect"},
    {name = "烟雾效果",    icon = "💨", color = Color3.fromRGB(150,150,150),  id = "smoke",      module = "SmokeEffect"},
    {name = "加速脚本",    icon = "⚡", color = Color3.fromRGB(255,220,0),   id = "speed",      module = "Speed"},
    {name = "跳跃增强",    icon = "🦘", color = Color3.fromRGB(50,255,100),   id = "jump",       module = "Jump"},
    {name = "穿墙脚本",    icon = "🧱", color = Color3.fromRGB(180,100,50),  id = "noclip",     module = "Noclip"},
    {name = "ESP透视",     icon = "👁", color = Color3.fromRGB(255,50,100),  id = "esp",        module = "ESP"},
    {name = "车辆加速",    icon = "🏎", color = Color3.fromRGB(255,165,0),   id = "carboost",   module = "CarBoost"},
    {name = "快速互动",    icon = "⚡", color = Color3.fromRGB(0,255,200),   id = "instantaction", module = "InstantAction"},
    -- 新增ChronixHub功能
    {name = "防挂机",      icon = "😴", color = Color3.fromRGB(100,255,100), id = "antiafk",    module = "AntiAFK"},
    {name = "夜视模式",    icon = "🌙", color = Color3.fromRGB(200,200,100), id = "nightvision", module = "NightVision"},
    {name = "X光透视",     icon = "👓", color = Color3.fromRGB(255,255,0),   id = "xray",       module = "NightVision"},
    {name = "自由相机",    icon = "📹", color = Color3.fromRGB(150,100,255), id = "freecam",    module = "Freecam"},
    {name = "点击传送",    icon = "👆", color = Color3.fromRGB(0,200,150),   id = "clicktp",    module = "ClickTP"},
    {name = "无限连跳",    icon = "🦘", color = Color3.fromRGB(50,200,255),  id = "infjump",    module = "InfiniteJump"},
    {name = "防甩飞",      icon = "🛡", color = Color3.fromRGB(255,100,100), id = "antifling",  module = "AntiFling"},
    {name = "防踢出",      icon = "🚫", color = Color3.fromRGB(255,50,50),   id = "antikick",   module = "AntiFling"},
    {name = "路径点",      icon = "📍", color = Color3.fromRGB(0,255,100),   id = "waypoint",   module = "Waypoint"},
    -- 特殊功能（非模块）
    {name = "数据修改器",  icon = "📊", color = Color3.fromRGB(180,100,255), id = "datamod",    module = nil},
    {name = "永久存在",    icon = "💾", color = Color3.fromRGB(255,200,100), id = "permanent",  module = nil},
    {name = "取消永久",    icon = "🗑", color = Color3.fromRGB(255,100,100),  id = "unpermanent", module = nil},
    {name = "传送玩家",    icon = "📍", color = Color3.fromRGB(0,255,100),   id = "teleport",   module = nil},
    {name = "标记此处",    icon = "📌", color = Color3.fromRGB(255,200,0),   id = "markpoint",  module = nil},
    {name = "标记列表",    icon = "📋", color = Color3.fromRGB(255,150,50),  id = "marklist",   module = nil},
    {name = "管理员工具",  icon = "🛠", color = Color3.fromRGB(255,215,0),   id = "admintool",  module = nil},
    {name = "服务器脚本",  icon = "🖥", color = Color3.fromRGB(200,150,255), id = "serverscripts", module = nil},
    {name = "4:3比例",     icon = "📐", color = Color3.fromRGB(255,180,100), id = "ratio43",    module = nil},
    {name = "超广角",      icon = "📷", color = Color3.fromRGB(100,255,200), id = "ultrawide",  module = nil},
    {name = "切换身份",    icon = "🎭", color = Color3.fromRGB(255,100,255), id = "switchrole", module = nil},
    {name = "赞助作者",    icon = "☕", color = Color3.fromRGB(255,215,0),   id = "sponsor",    module = nil},
}

-- 已加载的模块缓存
local loadedModules = {}
local buttonRefs = {}
local buttonStates = {} -- 记录按钮状态
local savedLocations = {} -- 标记点列表
local isPermanent = false

-- 加载模块函数
local function loadModule(moduleName)
    if loadedModules[moduleName] then
        return loadedModules[moduleName]
    end
    local success, result = pcall(function()
        return loadstring(game:HttpGet(MODULE_URL .. moduleName .. ".lua"))()
    end)
    if success then
        loadedModules[moduleName] = result
        return result
    else
        warn("[F脚本中心] 加载模块失败: " .. moduleName .. " - " .. tostring(result))
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "模块加载失败", Text = moduleName .. " 加载失败", Duration = 3
            })
        end)
        return nil
    end
end

-- 更新按钮状态显示
local function updateButtonState(id, isActive)
    buttonStates[id] = isActive
    local btn = buttonRefs[id]
    if not btn then return end
    local textLabel = btn:FindFirstChild("BtnText")
    if textLabel then
        local originalName = nil
        for _, info in ipairs(btnDefs) do
            if info.id == id then
                originalName = info.name
                break
            end
        end
        if originalName then
            textLabel.Text = isActive and (originalName .. " ✓") or originalName
            textLabel.TextColor3 = isActive and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
        end
    end
end

-- 创建按钮并绑定点击事件
for i, info in ipairs(btnDefs) do
    local btn = UI.createFeatureButton(ScrollFrame, info, i)
    buttonRefs[info.id] = btn
    buttonStates[info.id] = false

    btn.MouseButton1Click:Connect(function()
        -- 点击动画
        UI.tween(btn, 0.1, {BackgroundColor3 = Color3.fromRGB(80,80,100), Size = UDim2.new(1, -12, 0, 36)})
        task.delay(0.1, function()
            UI.tween(btn, 0.15, {BackgroundColor3 = Color3.fromRGB(65,65,80), Size = UDim2.new(1, -4, 0, 40)})
        end)

        -- 处理模块按钮
        if info.module then
            local mod = loadModule(info.module)
            if mod then
                local success, result = pcall(function()
                    -- 特殊处理：NightVision有两个功能
                    if info.id == "nightvision" and mod.toggleNightVision then
                        return mod.toggleNightVision()
                    elseif info.id == "xray" and mod.toggleXRay then
                        return mod.toggleXRay()
                    elseif info.id == "antifling" and mod.toggleAntiFling then
                        return mod.toggleAntiFling()
                    elseif info.id == "antikick" and mod.toggleAntiKick then
                        return mod.toggleAntiKick()
                    elseif mod.toggle then
                        return mod.toggle()
                    end
                    return false
                end)
                if success then
                    updateButtonState(info.id, result)
                    pcall(function()
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = info.name,
                            Text = result and (info.name .. " 已启用") or (info.name .. " 已关闭"),
                            Duration = 2
                        })
                    end)
                else
                    warn("[F脚本中心] " .. info.name .. " 执行失败: " .. tostring(result))
                end
            end
            return
        end

        -- 处理非模块的特殊功能
        if info.id == "datamod" then
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "数据修改器", Text = "请在控制台使用", Duration = 3
                })
            end)

        elseif info.id == "permanent" then
            isPermanent = true
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "永久存在", Text = "已启用永久存在模式", Duration = 3
                })
            end)
            updateButtonState(info.id, true)

        elseif info.id == "unpermanent" then
            isPermanent = false
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "取消永久", Text = "已关闭永久存在模式", Duration = 3
                })
            end)
            updateButtonState("permanent", false)

        elseif info.id == "teleport" then
            -- 简单的传送输入框
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "传送玩家", Text = "点击玩家即可传送", Duration = 3
                })
            end)
            -- 临时点击传送
            local conn
            conn = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local mouse = LocalPlayer:GetMouse()
                    if mouse.Target then
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                        end
                    end
                    if conn then conn:Disconnect() end
                end
            end)

        elseif info.id == "markpoint" then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                table.insert(savedLocations, {name = "标记 " .. #savedLocations + 1, pos = pos})
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "标记此处", Text = "已保存当前位置", Duration = 2
                    })
                end)
            end

        elseif info.id == "marklist" then
            if #savedLocations == 0 then
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "标记列表", Text = "暂无保存的位置", Duration = 2
                    })
                end)
            else
                local listText = ""
                for i, loc in ipairs(savedLocations) do
                    listText = listText .. i .. ". " .. loc.name .. "\n"
                end
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "标记列表 (共" .. #savedLocations .. "个)", Text = listText, Duration = 5
                    })
                end)
            end

        elseif info.id == "admintool" then
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            end)
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "管理员工具", Text = "Infinite Yield 已加载", Duration = 3
                })
            end)

        elseif info.id == "serverscripts" then
            -- 服务器脚本弹窗
            pcall(function()
                local scripts = {
                    {name = "自然灾害", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/ziran.lua"},
                    {name = " Brookhaven", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/brookhaven.lua"},
                    {name = "监狱人生", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/prisonlife.lua"},
                    {name = "收养我", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/adoptme.lua"},
                    {name = " Blox Fruits", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/bloxfruits.lua"},
                    {name = " King Legacy", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/kinglegacy.lua"},
                    {name = " Arsenal", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/arsenal.lua"},
                    {name = " Phantom Forces", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/phantomforces.lua"},
                    {name = " Doors", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/doors.lua"},
                    {name = " Bedwars", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/bedwars.lua"},
                }

                local popup = Instance.new("Frame")
                popup.Name = "ServerScriptsPopup"
                popup.Size = UDim2.new(0, 300, 0, 350)
                popup.Position = UDim2.new(0.5, -150, 0.5, -175)
                popup.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                popup.BackgroundTransparency = 0.1
                popup.BorderSizePixel = 0
                popup.Parent = ScreenGui
                popup.ZIndex = 50

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 12)
                corner.Parent = popup

                local title = Instance.new("TextLabel")
                title.Size = UDim2.new(1, 0, 0, 40)
                title.BackgroundTransparency = 1
                title.Text = "🖥 服务器脚本"
                title.TextColor3 = Color3.fromRGB(255, 255, 255)
                title.TextSize = 16
                title.Font = Enum.Font.GothamBold
                title.Parent = popup

                local closeBtn = Instance.new("TextButton")
                closeBtn.Size = UDim2.new(0, 30, 0, 30)
                closeBtn.Position = UDim2.new(1, -35, 0, 5)
                closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
                closeBtn.Text = "×"
                closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                closeBtn.Font = Enum.Font.GothamBold
                closeBtn.TextSize = 18
                closeBtn.Parent = popup
                Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
                closeBtn.MouseButton1Click:Connect(function() popup:Destroy() end)

                local scroll = Instance.new("ScrollingFrame")
                scroll.Size = UDim2.new(1, -10, 1, -50)
                scroll.Position = UDim2.new(0, 5, 0, 45)
                scroll.BackgroundTransparency = 1
                scroll.BorderSizePixel = 0
                scroll.ScrollBarThickness = 4
                scroll.CanvasSize = UDim2.new(0, 0, 0, #scripts * 45)
                scroll.Parent = popup

                local layout = Instance.new("UIListLayout")
                layout.Padding = UDim.new(0, 5)
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.Parent = scroll

                for idx, scriptInfo in ipairs(scripts) do
                    local sbtn = Instance.new("TextButton")
                    sbtn.Size = UDim2.new(1, -5, 0, 40)
                    sbtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
                    sbtn.Text = scriptInfo.name
                    sbtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    sbtn.TextSize = 13
                    sbtn.Font = Enum.Font.GothamBold
                    sbtn.LayoutOrder = idx
                    sbtn.Parent = scroll
                    Instance.new("UICorner", sbtn).CornerRadius = UDim.new(0, 8)

                    sbtn.MouseButton1Click:Connect(function()
                        pcall(function()
                            loadstring(game:HttpGet(scriptInfo.url))()
                        end)
                        pcall(function()
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "加载脚本", Text = scriptInfo.name .. " 已加载", Duration = 3
                            })
                        end)
                    end)
                end
            end)

        elseif info.id == "ratio43" then
            Camera.FieldOfView = 70
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "4:3比例", Text = "FOV已设为70", Duration = 2
                })
            end)

        elseif info.id == "ultrawide" then
            Camera.FieldOfView = 120
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "超广角", Text = "FOV已设为120", Duration = 2
                })
            end)

        elseif info.id == "switchrole" then
            currentRole = currentRole == "normal" and "vip" or "normal"
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "切换身份", Text = "当前身份: " .. currentRole, Duration = 2
                })
            end)

        elseif info.id == "sponsor" then
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "赞助作者", Text = "感谢支持！请联系作者: noobnewfggg", Duration = 4
                })
            end)
        end
    end)
end

-- ========== 展开/收起动画 ==========
local animating = false

local function expandUI()
    if animating then return end
    animating = true
    local startPos = openBtn.Position
    local centerPos = UDim2.new(0.5, -25, 0.5, -25)

    UI.tween(openBtn, 0.35, {
        Position = centerPos,
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundTransparency = 0.5
    })

    task.delay(0.35, function()
        UI.tween(openBtn, 0.25, {BackgroundTransparency = 1, TextTransparency = 1})
        MainFrame.Position = centerPos
        MainFrame.Size = UDim2.new(0, 60, 0, 50)
        MainFrame.BackgroundTransparency = 1
        MainFrame.Visible = true

        UI.tween(MainFrame, 0.5, {
            Position = UDim2.new(0.5, -uiElements.frameWidth/2, 0.5, -uiElements.frameHeight/2),
            Size = UDim2.new(0, uiElements.frameWidth, 0, uiElements.frameHeight),
            BackgroundTransparency = 0.2
        }, Enum.EasingStyle.Back)

        task.delay(0.5, function()
            openBtn.Position = startPos
            openBtn.Size = UDim2.new(0, 50, 0, 50)
            openBtn.BackgroundTransparency = 0
            openBtn.TextTransparency = 0
            openBtn.Visible = false
            animating = false
        end)
    end)
end

local function collapseUI()
    if animating or not MainFrame.Visible then return end
    animating = true

    local targetPos = openBtn.Position
    local centerPos = UDim2.new(0.5, -25, 0.5, -25)

    UI.tween(MainFrame, 0.35, {
        Position = centerPos,
        Size = UDim2.new(0, 60, 0, 50),
        BackgroundTransparency = 0.8
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    task.delay(0.35, function()
        MainFrame.Visible = false
        openBtn.Visible = true
        openBtn.Position = centerPos
        openBtn.Size = UDim2.new(0, 30, 0, 30)
        openBtn.BackgroundTransparency = 1
        openBtn.TextTransparency = 1

        UI.tween(openBtn, 0.4, {
            Position = targetPos,
            Size = UDim2.new(0, 50, 0, 50),
            BackgroundTransparency = 0,
            TextTransparency = 0
        }, Enum.EasingStyle.Back)

        task.delay(0.4, function()
            animating = false
        end)
    end)
end

openBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then collapseUI() else expandUI() end
end)

buttons.Close.MouseButton1Click:Connect(collapseUI)
buttons.Minimize.MouseButton1Click:Connect(collapseUI)

-- 横版/竖版切换
local isHorizontal = false
buttons.Layout.MouseButton1Click:Connect(function()
    if animating then return end
    animating = true
    isHorizontal = not isHorizontal

    if isHorizontal then
        UI.tween(LeftPanel, 0.4, {Size = UDim2.new(1, -16, 0, 120), Position = UDim2.new(0, 8, 0, 60)})
        UI.tween(RightPanel, 0.4, {Size = UDim2.new(1, -16, 1, -190), Position = UDim2.new(0, 8, 0, 185)})
        UI.tween(MainFrame, 0.4, {Size = UDim2.new(0, math.min(uiElements.frameWidth * 1.3, Camera.ViewportSize.X * 0.9), 0, uiElements.frameHeight)})
        buttons.Layout.Text = "⟳"
    else
        UI.tween(LeftPanel, 0.4, {Size = UDim2.new(0, 170, 1, -65), Position = UDim2.new(0, 8, 0, 60)})
        UI.tween(RightPanel, 0.4, {Size = UDim2.new(1, -190, 1, -65), Position = UDim2.new(0, 182, 0, 60)})
        UI.tween(MainFrame, 0.4, {Size = UDim2.new(0, uiElements.frameWidth, 0, uiElements.frameHeight)})
        buttons.Layout.Text = "⟲"
    end

    task.delay(0.4, function() animating = false end)
end)

-- 删除脚本按钮
buttons.ClearScripts.MouseButton1Click:Connect(function()
    local clearedCount = 0
    pcall(function()
        for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "FScriptHub" then
                gui:Destroy()
                clearedCount = clearedCount + 1
            end
        end
    end)
    pcall(function()
        for _, gui in ipairs(CoreGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "FScriptHub" then
                gui:Destroy()
                clearedCount = clearedCount + 1
            end
        end
    end)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "清理完成", Text = "已清理 " .. clearedCount .. " 个脚本UI", Duration = 3
        })
    end)
end)

-- 关闭时禁用所有功能
local function disableAllFeatures()
    for id, state in pairs(buttonStates) do
        if state then
            for _, info in ipairs(btnDefs) do
                if info.id == id and info.module then
                    local mod = loadedModules[info.module]
                    if mod then
                        pcall(function()
                            if id == "nightvision" and mod.disableNightVision then
                                mod.disableNightVision()
                            elseif id == "xray" and mod.disableXRay then
                                mod.disableXRay()
                            elseif id == "antifling" and mod.disableAntiFling then
                                mod.disableAntiFling()
                            elseif id == "antikick" and mod.disableAntiKick then
                                mod.disableAntiKick()
                            elseif mod.disable then
                                mod.disable()
                            end
                        end)
                    end
                    updateButtonState(id, false)
                    break
                end
            end
        end
    end
end

-- 监听关闭事件
ScreenGui.AncestryChanged:Connect(function()
    if not ScreenGui.Parent then
        disableAllFeatures()
    end
end)

-- 初始显示
MainFrame.Visible = true
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BackgroundTransparency = 1
UI.tween(MainFrame, 0.6, {
    Size = UDim2.new(0, uiElements.frameWidth, 0, uiElements.frameHeight),
    BackgroundTransparency = 0.2
}, Enum.EasingStyle.Back)

-- 通知
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "F脚本中心", Text = "v6.0 模块化版已加载 | 共 " .. #btnDefs .. " 个功能", Duration = 4
    })
end)
