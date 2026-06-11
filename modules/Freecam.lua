local Freecam = {};
local enabled = false;
local connection = nil;
local moveConnection = nil;
local camera = workspace.CurrentCamera;
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local speed = 2;
local camCFrame = CFrame.new();
Freecam.toggle = function()
	enabled = not enabled;
	if enabled then
		local char = LocalPlayer.Character;
		if char then
			camCFrame = CFrame.new(char:GetPivot().Position);
		else
			camCFrame = camera.CFrame;
		end
		camera.CameraType = Enum.CameraType.Scriptable;
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
		moveConnection = RunService.RenderStepped:Connect(function(dt)
			if not enabled then
				return;
			end
			local dir = Vector3.new(0, 0, 0);
			local camCF = camera.CFrame;
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				dir = dir + camCF.LookVector;
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				dir = dir - camCF.LookVector;
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				dir = dir - camCF.RightVector;
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				dir = dir + camCF.RightVector;
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				dir = dir + Vector3.new(0, 1, 0);
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				dir = dir - Vector3.new(0, 1, 0);
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.E) then
				speed = math.min(speed + (dt * 5), 50);
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
				speed = math.max(speed - (dt * 5), 0.5);
			end
			if (dir.Magnitude > 0) then
				camCFrame = camCFrame + (dir.Unit * speed);
			end
			camera.CFrame = camCFrame;
		end);
	else
		if moveConnection then
			moveConnection:Disconnect();
			moveConnection = nil;
		end
		camera.CameraType = Enum.CameraType.Custom;
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
		speed = 2;
	end
	return enabled;
end;
Freecam.isEnabled = function()
	return enabled;
end;
Freecam.disable = function()
	if enabled then
		Freecam.toggle();
	end
end;
return Freecam;
