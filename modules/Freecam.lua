local Freecam = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local freecamEnabled = false;
local camera = workspace.CurrentCamera;
local freecamConnection = nil;
local originalCameraType = nil;
local originalCameraSubject = nil;
local freecamPosition = nil;
local freecamRotation = nil;
Freecam.toggle = function()
	freecamEnabled = not freecamEnabled;
	if freecamEnabled then
		originalCameraType = camera.CameraType;
		originalCameraSubject = camera.CameraSubject;
		freecamPosition = camera.CFrame.Position;
		freecamRotation = Vector2.new(camera.CFrame.Rotation.X, camera.CFrame.Rotation.Y);
		camera.CameraType = Enum.CameraType.Scriptable;
		camera.CameraSubject = nil;
		local speed = 2;
		local moveVector = Vector3.zero;
		freecamConnection = RunService.RenderStepped:Connect(function()
			if not freecamEnabled then
				return;
			end
			moveVector = Vector3.zero;
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				moveVector = moveVector + camera.CFrame.LookVector;
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				moveVector = moveVector - camera.CFrame.LookVector;
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				moveVector = moveVector - camera.CFrame.RightVector;
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				moveVector = moveVector + camera.CFrame.RightVector;
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.E) then
				moveVector = moveVector + Vector3.new(0, 1, 0);
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
				moveVector = moveVector - Vector3.new(0, 1, 0);
			end
			if (moveVector.Magnitude > 0) then
				freecamPosition = freecamPosition + (moveVector.Unit * speed);
			end
			local mouseDelta = UserInputService:GetMouseDelta();
			freecamRotation = freecamRotation + Vector2.new(-mouseDelta.Y * 0.1, -mouseDelta.X * 0.1);
			freecamRotation = Vector2.new(math.clamp(freecamRotation.X, -80, 80), freecamRotation.Y);
			local rotation = CFrame.Angles(math.rad(freecamRotation.X), math.rad(freecamRotation.Y), 0);
			camera.CFrame = CFrame.new(freecamPosition) * rotation;
		end);
		return true, "自由相机已开启 (WASD移动, 鼠标转向, Q/E上下)";
	else
		if freecamConnection then
			freecamConnection:Disconnect();
			freecamConnection = nil;
		end
		camera.CameraType = originalCameraType or Enum.CameraType.Custom;
		camera.CameraSubject = originalCameraSubject or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid"));
		return false, "自由相机已关闭";
	end
end;
Freecam.disable = function()
	if freecamEnabled then
		Freecam.toggle();
	end
end;
return Freecam;
