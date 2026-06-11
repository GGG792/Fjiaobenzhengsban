-- F脚本中心 - 车辆加速模块
local CarBoost = {}
local enabled = false
local connection = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

function CarBoost.toggle()
    enabled = not enabled

    if enabled then
        connection = RunService.Heartbeat:Connect(function()
            if not enabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            local seat = humanoid.SeatPart
            if seat and seat:IsA("VehicleSeat") then
                local vehicleModel = seat:FindFirstAncestorOfClass("Model")
                if vehicleModel then
                    local primaryPart = vehicleModel.PrimaryPart or vehicleModel:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        local lookVector = primaryPart.CFrame.LookVector
                        primaryPart.Velocity = primaryPart.Velocity + lookVector * 5
                    end
                end
            end
        end)
    else
        if connection then connection:Disconnect() connection = nil end
    end
    return enabled
end

function CarBoost.isEnabled() return enabled end
function CarBoost.disable()
    if enabled then CarBoost.toggle() end
end

return CarBoost
