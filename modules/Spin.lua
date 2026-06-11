-- F脚本中心 - 旋转模块
local Spin = {}
local enabled = false
local connection = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

function Spin.toggle()
    enabled = not enabled
    local char = LocalPlayer.Character
    if not char then return enabled end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return enabled end

    if enabled then
        connection = RunService.RenderStepped:Connect(function()
            if not enabled then return end
            if hrp and hrp.Parent then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(15), 0)
            end
        end)
    else
        if connection then connection:Disconnect() connection = nil end
    end
    return enabled
end

function Spin.isEnabled() return enabled end
function Spin.disable()
    if enabled then Spin.toggle() end
end

return Spin
