local Jump = {};
local enabled = false;
local originalPower = 50;
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
Jump.toggle = function()
	enabled = not enabled;
	local char = LocalPlayer.Character;
	if not char then
		return enabled;
	end
	local humanoid = char:FindFirstChildOfClass("Humanoid");
	if not humanoid then
		return enabled;
	end
	if enabled then
		originalPower = humanoid.JumpPower;
		humanoid.JumpPower = 150;
	else
		humanoid.JumpPower = originalPower;
	end
	return enabled;
end;
Jump.isEnabled = function()
	return enabled;
end;
Jump.disable = function()
	if enabled then
		Jump.toggle();
	end
end;
return Jump;
