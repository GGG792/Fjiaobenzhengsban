-- F脚本中心 - 夜视/X光模块
local NightVision = {}

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local nightVisionEnabled = false
local xrayEnabled = false
local originalSettings = {}
local xrayConnection = nil

function NightVision.toggleNightVision()
    nightVisionEnabled = not nightVisionEnabled
    
    if nightVisionEnabled then
        -- 保存原始设置
        originalSettings.ClockTime = Lighting.ClockTime
        originalSettings.Brightness = Lighting.Brightness
        originalSettings.GlobalShadows = Lighting.GlobalShadows
        originalSettings.OutdoorAmbient = Lighting.OutdoorAmbient
        originalSettings.Ambient = Lighting.Ambient
        
        -- 开启夜视
        Lighting.ClockTime = 14
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        Lighting.Ambient = Color3.fromRGB(150, 150, 150)
        
        return true, "夜视已开启"
    else
        -- 恢复原始设置
        if originalSettings.ClockTime then
            Lighting.ClockTime = originalSettings.ClockTime
            Lighting.Brightness = originalSettings.Brightness
            Lighting.GlobalShadows = originalSettings.GlobalShadows
            Lighting.OutdoorAmbient = originalSettings.OutdoorAmbient
            Lighting.Ambient = originalSettings.Ambient
        end
        return false, "夜视已关闭"
    end
end

function NightVision.toggleXRay()
    xrayEnabled = not xrayEnabled
    
    if xrayEnabled then
        xrayConnection = RunService.RenderStepped:Connect(function()
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Transparency < 1 then
                    if not part:GetAttribute("OriginalTransparency") then
                        part:SetAttribute("OriginalTransparency", part.Transparency)
                    end
                    if part.Name:lower():match("wall") or part.Name:lower():match("door") or part.Name:lower():match("floor") then
                        part.Transparency = 0.7
                    end
                end
            end
        end)
        return true, "X光已开启"
    else
        if xrayConnection then
            xrayConnection:Disconnect()
            xrayConnection = nil
        end
        -- 恢复透明度
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                local original = part:GetAttribute("OriginalTransparency")
                if original then
                    part.Transparency = original
                end
            end
        end
        return false, "X光已关闭"
    end
end

function NightVision.disableAll()
    if nightVisionEnabled then
        NightVision.toggleNightVision()
    end
    if xrayEnabled then
        NightVision.toggleXRay()
    end
end

return NightVision
