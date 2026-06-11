local Jump = {};
local enabled = false;
local originalPower = 50;
local useJumpPower = true;
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local function applyJump()
	local char = LocalPlayer.Character;
	if not char then
		return;
	end
	local humanoid = char:FindFirstChildOfClass("Humanoid");
	if not humanoid then
		return;
	end
	if enabled then
		if useJumpPower then
			humanoid.JumpPower = 150;
		else
			humanoid.JumpHeight = 150;
		end
	end
end
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
		originalPower = (useJumpPower and humanoid.JumpPower) or humanoid.JumpHeight;
		useJumpPower = pcall(function()
			local v = humanoid.UseJumpPower;
			return v ~= false;
		end);
		applyJump();
	elseif useJumpPower then
		humanoid.JumpPower = originalPower;
	else
		humanoid.JumpHeight = originalPower;
	end
	return enabled;
end;
LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(1);
	if enabled then
		applyJump();
	end
end);
Jump.isEnabled = function()
	return enabled;
end;
Jump.disable = function()
	if enabled then
		Jump.toggle();
	end
end;
return Jump;
