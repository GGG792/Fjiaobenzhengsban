-- F脚本中心 - 点击传送模块
local ClickTP = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local clickTPEnabled = false
local clickTPConnection = nil

function ClickTP.toggle()
    clickTPEnabled = not clickTPEnabled
    
    if clickTPEnabled then
        clickTPConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                local mouse = LocalPlayer:GetMouse()
                if mouse.Hit then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                    end
                end
            end
        end)
        return true, "点击传送已开启 (按住Ctrl+点击地面)"
    else
        if clickTPConnection then
            clickTPConnection:Disconnect()
            clickTPConnection = nil
        end
        return false, "点击传送已关闭"
    end
end

function ClickTP.disable()
    if clickTPEnabled then
        ClickTP.toggle()
    end
end

return ClickTP
