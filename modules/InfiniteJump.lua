local InfiniteJump = {};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local infiniteJumpEnabled = false;
local jumpConnection = nil;
InfiniteJump.toggle = function()
	infiniteJumpEnabled = not infiniteJumpEnabled;
	if infiniteJumpEnabled then
		jumpConnection = UserInputService.JumpRequest:Connect(function()
			local char = LocalPlayer.Character;
			if (char and char:FindFirstChild("Humanoid")) then
				char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping);
			end
		end);
		return true, "无限连跳已开启";
	else
		if jumpConnection then
			jumpConnection:Disconnect();
			jumpConnection = nil;
		end
		return false, "无限连跳已关闭";
	end
end;
InfiniteJump.disable = function()
	if infiniteJumpEnabled then
		InfiniteJump.toggle();
	end
end;
return InfiniteJump;
