local Noclip = {};
local enabled = false;
local connection = nil;
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
Noclip.toggle = function()
	enabled = not enabled;
	if enabled then
		connection = RunService.Stepped:Connect(function()
			if not enabled then
				return;
			end
			local char = LocalPlayer.Character;
			if not char then
				return;
			end
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false;
				end
			end
		end);
	elseif connection then
		connection:Disconnect();
		connection = nil;
	end
	return enabled;
end;
Noclip.isEnabled = function()
	return enabled;
end;
Noclip.disable = function()
	if enabled then
		Noclip.toggle();
	end
end;
return Noclip;
