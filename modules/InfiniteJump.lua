-- F脚本中心 - 无限连跳模块
local InfiniteJump = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local infiniteJumpEnabled = false
local jumpConnection = nil

function InfiniteJump.toggle()
    infiniteJumpEnabled = not infiniteJumpEnabled
    
    if infiniteJumpEnabled then
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        return true, "无限连跳已开启"
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
        return false, "无限连跳已关闭"
    end
end

function InfiniteJump.disable()
    if infiniteJumpEnabled then
        InfiniteJump.toggle()
    end
end

return InfiniteJump
