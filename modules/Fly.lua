local Fly = {};
local enabled = false;
local connection = nil;
local bv = nil;
local bg = nil;
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local function getChar()
	local char = LocalPlayer.Character;
	if char then
		return char, char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid");
	end
	return nil, nil, nil;
end
Fly.toggle = function()
	enabled = not enabled;
	if enabled then
		connection = RunService.RenderStepped:Connect(function()
			if not enabled then
				return;
			end
			local char, hrp, humanoid = getChar();
			if (not char or not hrp or not humanoid) then
				return;
			end
			if (not bv or not bv.Parent or not bv:IsDescendantOf(char)) then
				if bv then
					pcall(function()
						bv:Destroy();
					end);
				end
				bv = Instance.new("BodyVelocity");
				bv.MaxForce = Vector3.new(100000, 100000, 100000);
				bv.Parent = hrp;
			end
			if (not bg or not bg.Parent or not bg:IsDescendantOf(char)) then
				if bg then
					pcall(function()
						bg:Destroy();
					end);
				end
				bg = Instance.new("BodyGyro");
				bg.P = 100000;
				bg.MaxTorque = Vector3.new(100000, 100000, 100000);
				bg.Parent = hrp;
			end
			local cam = workspace.CurrentCamera;
			local dir = Vector3.new(0, 0, 0);
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				dir = dir + cam.CFrame.LookVector;
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				dir = dir - cam.CFrame.LookVector;
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				dir = dir - cam.CFrame.RightVector;
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				dir = dir + cam.CFrame.RightVector;
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				dir = dir + Vector3.new(0, 1, 0);
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				dir = dir - Vector3.new(0, 1, 0);
			end
			if (dir.Magnitude > 0) then
				bv.Velocity = dir.Unit * humanoid.WalkSpeed * 2;
			else
				bv.Velocity = Vector3.new(0, 0, 0);
			end
			bg.CFrame = cam.CFrame;
		end);
	else
		if connection then
			connection:Disconnect();
			connection = nil;
		end
		if bv then
			pcall(function()
				bv:Destroy();
			end);
			bv = nil;
		end
		if bg then
			pcall(function()
				bg:Destroy();
			end);
			bg = nil;
		end
	end
	return enabled;
end;
Fly.isEnabled = function()
	return enabled;
end;
Fly.disable = function()
	if enabled then
		Fly.toggle();
	end
end;
return Fly;
