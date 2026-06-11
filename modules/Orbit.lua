local Orbit = {};
local enabled = false;
local connection = nil;
local angle = 0;
local startPos = nil;
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
Orbit.toggle = function()
	enabled = not enabled;
	if enabled then
		local char = LocalPlayer.Character;
		if char then
			local hrp = char:FindFirstChild("HumanoidRootPart");
			if hrp then
				startPos = hrp.Position;
			end
		end
		angle = 0;
		local radius = 10;
		connection = RunService.RenderStepped:Connect(function(dt)
			if not enabled then
				return;
			end
			local char = LocalPlayer.Character;
			if char then
				local hrp = char:FindFirstChild("HumanoidRootPart");
				if hrp then
					if not startPos then
						startPos = hrp.Position;
					end
					angle = angle + (dt * 2);
					local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius);
					hrp.CFrame = CFrame.new(startPos + offset);
				end
			end
		end);
	else
		if connection then
			connection:Disconnect();
			connection = nil;
		end
		startPos = nil;
	end
	return enabled;
end;
Orbit.isEnabled = function()
	return enabled;
end;
Orbit.disable = function()
	if enabled then
		Orbit.toggle();
	end
end;
return Orbit;
