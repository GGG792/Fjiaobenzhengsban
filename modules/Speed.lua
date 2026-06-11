local Speed = {};
local enabled = false;
local originalSpeed = 16;
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
Speed.toggle = function()
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
		originalSpeed = humanoid.WalkSpeed;
		humanoid.WalkSpeed = 100;
	else
		humanoid.WalkSpeed = originalSpeed;
	end
	return enabled;
end;
Speed.isEnabled = function()
	return enabled;
end;
Speed.disable = function()
	if enabled then
		Speed.toggle();
	end
end;
return Speed;
