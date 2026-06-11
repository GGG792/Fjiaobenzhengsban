-- F脚本中心 - 飞行模块
local Fly = {}
local enabled = false
local connection = nil
local bv = nil
local bg = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

function Fly.toggle()
    enabled = not enabled
    local char = LocalPlayer.Character
    if not char then return enabled end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return enabled end

    if enabled then
        bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(100000, 100000, 100000)
        bv.Parent = hrp

        bg = Instance.new("BodyGyro")
        bg.P = 100000
        bg.MaxTorque = Vector3.new(100000, 100000, 100000)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp

        connection = RunService.RenderStepped:Connect(function()
            if not enabled then return end
            if not hrp or not hrp.Parent then return end
            local cam = workspace.CurrentCamera
            local dir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
            bv.Velocity = dir.Unit * (humanoid.WalkSpeed * 2)
            bg.CFrame = cam.CFrame
        end)
    else
        if connection then connection:Disconnect() connection = nil end
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
    end
    return enabled
end

function Fly.isEnabled() return enabled end
function Fly.disable()
    if enabled then Fly.toggle() end
end

return Fly
