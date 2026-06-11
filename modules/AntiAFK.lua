local AntiAFK = {};
local Players = game:GetService("Players");
local VirtualUser = game:GetService("VirtualUser");
local LocalPlayer = Players.LocalPlayer;
local antiAFKEnabled = false;
local antiAFKConnection = nil;
AntiAFK.toggle = function()
	antiAFKEnabled = not antiAFKEnabled;
	if antiAFKEnabled then
		antiAFKConnection = LocalPlayer.Idled:Connect(function()
			VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
			task.wait(1);
			VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
		end);
		return true, "防挂机已开启";
	else
		if antiAFKConnection then
			antiAFKConnection:Disconnect();
			antiAFKConnection = nil;
		end
		return false, "防挂机已关闭";
	end
end;
AntiAFK.isEnabled = function()
	return antiAFKEnabled;
end;
AntiAFK.disable = function()
	if antiAFKEnabled then
		AntiAFK.toggle();
	end
end;
return AntiAFK;
