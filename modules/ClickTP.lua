local ClickTP = {};
local enabled = false;
local connection = nil;
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
ClickTP.toggle = function()
	enabled = not enabled;
	if enabled then
		connection = UserInputService.InputBegan:Connect(function(input, processed)
			if processed then
				return;
			end
			if not enabled then
				return;
			end
			if (input.UserInputType == Enum.UserInputType.MouseButton1) then
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
					local mousePos = UserInputService:GetMouseLocation();
					local ray = workspace.CurrentCamera:ViewportPointToRay(mousePos);
					local rayResult = workspace:Raycast(ray.Origin, ray.Direction * 1000);
					if rayResult then
						local char = LocalPlayer.Character;
						if (char and char:FindFirstChild("HumanoidRootPart")) then
							char.HumanoidRootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0));
						end
					end
				end
			end
		end);
	elseif connection then
		connection:Disconnect();
		connection = nil;
	end
	return enabled;
end;
ClickTP.isEnabled = function()
	return enabled;
end;
ClickTP.disable = function()
	if enabled then
		ClickTP.toggle();
	end
end;
return ClickTP;
