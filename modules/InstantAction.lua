-- F脚本中心 - 快速互动模块
local InstantAction = {}
local enabled = false
local originalPrompt = nil

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function InstantAction.toggle()
    enabled = not enabled

    if enabled then
        pcall(function()
            originalPrompt = game:GetService("ProximityPromptService").PromptButtonHoldBegan
            game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
                prompt.HoldDuration = 0
            end)
        end)
        local char = LocalPlayer.Character
        if char then
            for _, prompt in ipairs(char:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    prompt.HoldDuration = 0
                end
            end
        end
    else
        pcall(function()
            if originalPrompt then
                -- 无法完全恢复，但可以将新prompt的hold duration设回默认值
            end
        end)
    end
    return enabled
end

function InstantAction.isEnabled() return enabled end
function InstantAction.disable()
    if enabled then InstantAction.toggle() end
end

return InstantAction
