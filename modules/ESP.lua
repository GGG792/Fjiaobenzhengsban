-- F脚本中心 - ESP透视模块
local ESP = {}
local enabled = false
local espObjects = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

function ESP.toggle()
    enabled = not enabled

    if enabled then
        local function createESP(player)
            if player == LocalPlayer then return end
            local function onCharacterAdded(char)
                local hrp = char:WaitForChild("HumanoidRootPart", 5)
                if not hrp then return end
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "FScriptESP"
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.Parent = hrp

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                frame.BackgroundTransparency = 0.7
                frame.BorderSizePixel = 0
                frame.Parent = billboard

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = player.DisplayName
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextSize = 10
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.Parent = frame

                local distLabel = Instance.new("TextLabel")
                distLabel.Size = UDim2.new(1, 0, 0.5, 0)
                distLabel.Position = UDim2.new(0, 0, 0.5, 0)
                distLabel.BackgroundTransparency = 1
                distLabel.Text = "0m"
                distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                distLabel.TextSize = 8
                distLabel.Font = Enum.Font.Gotham
                distLabel.Parent = frame

                table.insert(espObjects, billboard)

                RunService.RenderStepped:Connect(function()
                    if billboard and billboard.Parent then
                        local myChar = LocalPlayer.Character
                        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        if myHrp and hrp and hrp.Parent then
                            local dist = (myHrp.Position - hrp.Position).Magnitude
                            distLabel.Text = math.floor(dist) .. "m"
                        end
                    end
                end)
            end
            if player.Character then
                onCharacterAdded(player.Character)
            end
            player.CharacterAdded:Connect(onCharacterAdded)
        end

        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
        Players.PlayerAdded:Connect(createESP)
    else
        for _, obj in ipairs(espObjects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        espObjects = {}
    end
    return enabled
end

function ESP.isEnabled() return enabled end
function ESP.disable()
    if enabled then ESP.toggle() end
end

return ESP
