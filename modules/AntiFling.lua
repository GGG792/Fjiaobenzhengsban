-- F脚本中心 - 防甩飞/防踢出模块
local AntiFling = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local antiFlingEnabled = false
local antiKickEnabled = false
local flingConnection = nil
local kickConnection = nil
local originalPosition = nil

function AntiFling.toggleAntiFling()
    antiFlingEnabled = not antiFlingEnabled
    
    if antiFlingEnabled then
        flingConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                -- 检测异常速度（被甩飞）
                if hrp.AssemblyLinearVelocity.Magnitude > 500 then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    if originalPosition then
                        hrp.CFrame = CFrame.new(originalPosition)
                    end
                else
                    originalPosition = hrp.Position
                end
                -- 防止被物理劫持
                hrp:SetNetworkOwner(LocalPlayer)
            end
        end)
        return true, "防甩飞已开启"
    else
        if flingConnection then
            flingConnection:Disconnect()
            flingConnection = nil
        end
        return false, "防甩飞已关闭"
    end
end

function AntiFling.toggleAntiKick()
    antiKickEnabled = not antiKickEnabled
    
    if antiKickEnabled then
        -- 拦截Kick函数
        local mt = getrawmetatable(game)
        if mt then
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" and self == LocalPlayer then
                    return warn("[F脚本中心] 已拦截踢出")
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
        end
        return true, "防踢出已开启"
    else
        return false, "防踢出已关闭（需重启生效）"
    end
end

function AntiFling.disableAll()
    if antiFlingEnabled then
        AntiFling.toggleAntiFling()
    end
end

return AntiFling
