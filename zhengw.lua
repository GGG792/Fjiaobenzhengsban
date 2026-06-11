-- F脚本中心 v6.0 - 使用 ChronixHub 原生 UI 库
-- 直接加载 ChronixUI 库来构建界面
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

local AUTHOR_NAME = "noobnewfggg"
local VIP_USERS = { ["sbcnm229"] = true }

local currentRole = "normal"
if LocalPlayer.Name == AUTHOR_NAME then currentRole = "author" elseif VIP_USERS[LocalPlayer.UserId] or VIP_USERS[LocalPlayer.Name] then currentRole = "vip" end

-- 清理旧界面
pcall(function()
    if CoreGui:FindFirstChild("FScriptHub") then CoreGui.FScriptHub:Destroy() end
    if LocalPlayer.PlayerGui:FindFirstChild("FScriptHub") then LocalPlayer.PlayerGui.FScriptHub:Destroy() end
end)

-- 模块基础URL
local MODULE_URL = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/modules/"
local CHRONIX_UI_URL = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/modules/ChronixUI_Lib.lua"

-- 加载 ChronixUI 库
local ChronixUI = loadstring(game:HttpGet(CHRONIX_UI_URL))()

-- 创建窗口
local Window = ChronixUI:CreateWindow({
    Name = "F脚本中心 v6.0",
    ShowLoadingAnimation = true,
    CloseCallback = function()
        -- 关闭时清理
    end
})

-- 已加载的模块缓存
local loadedModules = {}
local buttonStates = {}

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
        ChronixUI:Notify({
            Title = "模块加载",
            Content = moduleName .. " 加载成功",
            Type = "success",
            Duration = 2
        })
        return result
    else
        ChronixUI:Notify({
            Title = "模块加载失败",
            Content = moduleName .. " 加载失败: " .. tostring(result):sub(1, 50),
            Type = "error",
            Duration = 3
        })
        return nil
    end
end

-- ========== 创建 Tab 页面 ==========

-- 玩家功能 Tab
local PlayerTab = Window:CreateTab({Name = "玩家功能", HasIcon = false})

-- 飞行
PlayerTab:AddToggle({
    Label = "启用飞行",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("Fly")
        if mod then mod.toggle() end
    end
})

-- 旋转
PlayerTab:AddToggle({
    Label = "旋转脚本",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("Spin")
        if mod then mod.toggle() end
    end
})

-- 环绕
PlayerTab:AddToggle({
    Label = "环绕旋转",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("Orbit")
        if mod then mod.toggle() end
    end
})

-- 无头
PlayerTab:AddToggle({
    Label = "无头效果",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("Headless")
        if mod then mod.toggle() end
    end
})

-- 燃烧
PlayerTab:AddToggle({
    Label = "燃烧效果",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("FireEffect")
        if mod then mod.toggle() end
    end
})

-- 烟雾
PlayerTab:AddToggle({
    Label = "烟雾效果",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("SmokeEffect")
        if mod then mod.toggle() end
    end
})

-- 加速
PlayerTab:AddToggle({
    Label = "加速脚本",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("Speed")
        if mod then mod.toggle() end
    end
})

-- 跳跃增强
PlayerTab:AddToggle({
    Label = "跳跃增强",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("Jump")
        if mod then mod.toggle() end
    end
})

-- 穿墙
PlayerTab:AddToggle({
    Label = "穿墙脚本",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("Noclip")
        if mod then mod.toggle() end
    end
})

-- ESP
PlayerTab:AddToggle({
    Label = "ESP透视",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("ESP")
        if mod then mod.toggle() end
    end
})

-- 无限连跳
PlayerTab:AddToggle({
    Label = "无限连跳",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("InfiniteJump")
        if mod then mod.toggle() end
    end
})

-- 点击传送
PlayerTab:AddToggle({
    Label = "点击传送",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("ClickTP")
        if mod then mod.toggle() end
    end
})

-- 自由相机
PlayerTab:AddToggle({
    Label = "自由相机",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("Freecam")
        if mod then mod.toggle() end
    end
})

-- ========== 防护功能 Tab ==========
local ProtectTab = Window:CreateTab({Name = "防护功能", HasIcon = false})

-- 防挂机
ProtectTab:AddToggle({
    Label = "防挂机",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("AntiAFK")
        if mod then mod.toggle() end
    end
})

-- 防甩飞
ProtectTab:AddToggle({
    Label = "防甩飞",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("AntiFling")
        if mod and mod.toggleAntiFling then mod.toggleAntiFling() end
    end
})

-- 防踢出
ProtectTab:AddToggle({
    Label = "防踢出",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("AntiFling")
        if mod and mod.toggleAntiKick then mod.toggleAntiKick() end
    end
})

-- ========== 视觉功能 Tab ==========
local VisualTab = Window:CreateTab({Name = "视觉功能", HasIcon = false})

-- 夜视
VisualTab:AddToggle({
    Label = "夜视模式",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("NightVision")
        if mod and mod.toggleNightVision then mod.toggleNightVision() end
    end
})

-- X光
VisualTab:AddToggle({
    Label = "X光透视",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("NightVision")
        if mod and mod.toggleXRay then mod.toggleXRay() end
    end
})

-- ========== 载具功能 Tab ==========
local VehicleTab = Window:CreateTab({Name = "载具功能", HasIcon = false})

-- 车辆加速
VehicleTab:AddToggle({
    Label = "车辆加速",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("CarBoost")
        if mod then mod.toggle() end
    end
})

-- ========== 工具功能 Tab ==========
local ToolTab = Window:CreateTab({Name = "工具功能", HasIcon = false})

-- 快速互动
ToolTab:AddToggle({
    Label = "快速互动",
    Default = false,
    Callback = function(Value)
        local mod = loadModule("InstantAction")
        if mod then mod.toggle() end
    end
})

-- 路径点
ToolTab:AddButton({
    Text = "添加路径点",
    Callback = function()
        local mod = loadModule("Waypoint")
        if mod and mod.add then
            mod.add("路径点 " .. os.time())
            ChronixUI:Notify({
                Title = "路径点",
                Content = "已添加当前位置",
                Type = "success",
                Duration = 2
            })
        end
    end
})

ToolTab:AddButton({
    Text = "传送到路径点",
    Callback = function()
        local mod = loadModule("Waypoint")
        if mod and mod.getList then
            local list = mod.getList()
            if #list > 0 then
                mod.teleport(1)
            else
                ChronixUI:Notify({
                    Title = "路径点",
                    Content = "暂无保存的路径点",
                    Type = "warning",
                    Duration = 2
                })
            end
        end
    end
})

ToolTab:AddButton({
    Text = "清除所有路径点",
    Callback = function()
        local mod = loadModule("Waypoint")
        if mod and mod.clear then
            mod.clear()
            ChronixUI:Notify({
                Title = "路径点",
                Content = "已清除所有路径点",
                Type = "info",
                Duration = 2
            })
        end
    end
})

-- ========== 服务器脚本 Tab ==========
local ServerTab = Window:CreateTab({Name = "服务器脚本", HasIcon = false})

local scripts = {
    -- 原有脚本
    {name = "自然灾害", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/ziran.lua"},
    {name = "8个球池经典", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/8个球池经典.lua"},
    {name = "99夜", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/99夜.lua"},
    {name = "GB", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/GB.lua"},
    {name = "po大po", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/po大po.lua"},
    {name = "举重模拟器", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/举重模拟器.lua"},
    {name = "亡命速递", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/亡命速递.lua"},
    {name = "保护房子不受怪物入侵", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/保护房子不受怪物入侵.lua"},
    {name = "僵尸之塔", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/僵尸之塔.lua"},
    {name = "僵尸生存竞技场", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/僵尸生存竞技场.lua"},
    {name = "克隆王国大亨", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/克隆王国大亨.lua"},
    {name = "决斗场", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/决斗场.lua"},
    {name = "刀刃球", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/刀刃球.lua"},
    {name = "划开大海", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/划开大海.lua"},
    {name = "力量传奇", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/力量传奇.lua"},
    {name = "南极洲探险", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/南极洲探险.lua"},
    {name = "启示录", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/启示录.lua"},
    {name = "奴才大亨", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/奴才大亨.lua"},
    {name = "平滑切片", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/平滑切片.lua"},
    {name = "强壮传奇", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/强壮传奇.lua"},
    {name = "忍者传奇", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/忍者传奇.lua"},
    {name = "戒网瘾中心", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/戒网瘾中心.lua"},
    {name = "手枪竞技场", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/手枪竞技场.lua"},
    {name = "最强战场", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/最强战场.lua"},
    {name = "木筏101天生存", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/木筏101天生存.lua"},
    {name = "极速传奇", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/极速传奇.lua"},
    {name = "模仿者", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/模仿者.lua"},
    {name = "每步+1智商", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/每步+1智商.lua"},
    {name = "汽车经销商大亨", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/汽车经销商大亨.lua"},
    {name = "沉默的刺客", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/沉默的刺客.lua"},
    {name = "滑石头RNG", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/滑石头RNG.lua"},
    {name = "火球训练", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/火球训练.lua"},
    {name = "火箭发射模拟器", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/火箭发射模拟器.lua"},
    {name = "犯罪", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/犯罪.lua"},
    {name = "生存于杀手", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/生存于杀手.lua"},
    {name = "画我", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/画我.lua"},
    {name = "监狱泵", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/监狱泵.lua"},
    {name = "矿井", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/矿井.lua"},
    {name = "砍伐树木", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/砍伐树木.lua"},
    {name = "破坏者谜团2", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/破坏者谜团2.lua"},
    {name = "竞争对手", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/竞争对手.lua"},
    {name = "花园地平线", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/花园地平线.lua"},
    {name = "超真实csgo", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/超真实csgo.lua"},
    {name = "超高速跑者", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/超高速跑者.lua"},
    {name = "迷你帝国", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/迷你帝国.lua"},
    {name = "造船寻宝", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/造船寻宝.lua"},
    {name = "金币点击器", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/金币点击器.lua"},
    {name = "钓鱼模拟器", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/钓鱼模拟器.lua"},
    {name = "闪光", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/闪光.lua"},
    {name = "防御", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/防御.lua"},
    {name = "集装箱RNG", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/集装箱RNG.lua"},
    {name = "餐厅大亨3", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/餐厅大亨3.lua"},
    {name = "鲨鱼咬", url = "https://raw.githubusercontent.com/GGG792/Fjiaobenzhengsban/refs/heads/main/scripts/鲨鱼咬.lua"},
}

for _, scriptInfo in ipairs(scripts) do
    ServerTab:AddButton({
        Text = "加载 " .. scriptInfo.name,
        Callback = function()
            pcall(function() loadstring(game:HttpGet(scriptInfo.url))() end)
            ChronixUI:Notify({
                Title = "加载脚本",
                Content = scriptInfo.name .. " 已加载",
                Type = "success",
                Duration = 3
            })
        end
    })
end

-- ========== 设置 Tab ==========
local SettingsTab = Window:CreateTab({Name = "设置", IsSettings = true, HasIcon = false})

SettingsTab:AddButton({
    Text = "清理其他脚本UI",
    Callback = function()
        local clearedCount = 0
        pcall(function()
            for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Name ~= "FScriptHub" and not gui.Name:find("Chronix") then
                    gui:Destroy()
                    clearedCount = clearedCount + 1
                end
            end
        end)
        pcall(function()
            for _, gui in ipairs(CoreGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Name ~= "FScriptHub" and not gui.Name:find("Chronix") then
                    gui:Destroy()
                    clearedCount = clearedCount + 1
                end
            end
        end)
        ChronixUI:Notify({
            Title = "清理完成",
            Content = "已清理 " .. clearedCount .. " 个脚本UI",
            Type = "info",
            Duration = 3
        })
    end
})

SettingsTab:AddButton({
    Text = "加载 Infinite Yield",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
        ChronixUI:Notify({
            Title = "管理员工具",
            Content = "Infinite Yield 已加载",
            Type = "success",
            Duration = 3
        })
    end
})

SettingsTab:AddButton({
    Text = "4:3 比例 (FOV 70)",
    Callback = function()
        Camera.FieldOfView = 70
        ChronixUI:Notify({Title = "4:3比例", Content = "FOV已设为70", Type = "info", Duration = 2})
    end
})

SettingsTab:AddButton({
    Text = "超广角 (FOV 120)",
    Callback = function()
        Camera.FieldOfView = 120
        ChronixUI:Notify({Title = "超广角", Content = "FOV已设为120", Type = "info", Duration = 2})
    end
})

-- 初始通知
ChronixUI:Notify({
    Title = "F脚本中心",
    Content = "v6.0 已加载 | 使用 ChronixHub UI 库 | 共 " .. #scripts .. " 个服务器脚本",
    Type = "success",
    Duration = 5
})
