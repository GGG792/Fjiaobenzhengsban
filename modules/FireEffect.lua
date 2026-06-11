-- F脚本中心 - 燃烧效果模块
local FireEffect = {}
local enabled = false
local fires = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function FireEffect.toggle()
    enabled = not enabled
    local char = LocalPlayer.Character
    if not char then return enabled end

    if enabled then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                local fire = Instance.new("Fire")
                fire.Size = 3
                fire.Heat = 10
                fire.Color = Color3.fromRGB(255, 100, 0)
                fire.SecondaryColor = Color3.fromRGB(255, 200, 0)
                fire.Parent = part
                table.insert(fires, fire)
            end
        end
    else
        for _, fire in ipairs(fires) do
            if fire and fire.Parent then
                fire:Destroy()
            end
        end
        fires = {}
    end
    return enabled
end

function FireEffect.isEnabled() return enabled end
function FireEffect.disable()
    if enabled then FireEffect.toggle() end
end

return FireEffect
