-- F脚本中心 - 穿墙模块
local Noclip = {}
local enabled = false
local connection = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

function Noclip.toggle()
    enabled = not enabled
    local char = LocalPlayer.Character
    if not char then return enabled end

    if enabled then
        connection = RunService.Stepped:Connect(function()
            if not enabled then return end
            local currentChar = LocalPlayer.Character
            if not currentChar then return end
            for _, part in ipairs(currentChar:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if connection then connection:Disconnect() connection = nil end
        local currentChar = LocalPlayer.Character
        if currentChar then
            for _, part in ipairs(currentChar:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then
                    part.CanCollide = true
                end
            end
        end
    end
    return enabled
end

function Noclip.isEnabled() return enabled end
function Noclip.disable()
    if enabled then Noclip.toggle() end
end

return Noclip
