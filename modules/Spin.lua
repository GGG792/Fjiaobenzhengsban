local Spin = {};
local enabled = false;
local connection = nil;
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
Spin.toggle = function()
	enabled = not enabled;
	if enabled then
		connection = RunService.RenderStepped:Connect(function()
			if not enabled then
				return;
			end
			local char = LocalPlayer.Character;
			if char then
				local hrp = char:FindFirstChild("HumanoidRootPart");
				if hrp then
					hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(15), 0);
				end
			end
		end);
	elseif connection then
		connection:Disconnect();
		connection = nil;
	end
	return enabled;
end;
Spin.isEnabled = function()
	return enabled;
end;
Spin.disable = function()
	if enabled then
		Spin.toggle();
	end
end;
return Spin;
