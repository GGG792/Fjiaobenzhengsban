local InfiniteJump = {};
local enabled = false;
local connection = nil;
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
InfiniteJump.toggle = function()
	enabled = not enabled;
	if enabled then
		connection = UserInputService.JumpRequest:Connect(function()
			if not enabled then
				return;
			end
			local char = LocalPlayer.Character;
			if char then
				local humanoid = char:FindFirstChildOfClass("Humanoid");
				if humanoid then
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping);
				end
			end
		end);
	elseif connection then
		connection:Disconnect();
		connection = nil;
	end
	return enabled;
end;
InfiniteJump.isEnabled = function()
	return enabled;
end;
InfiniteJump.disable = function()
	if enabled then
		InfiniteJump.toggle();
	end
end;
return InfiniteJump;
