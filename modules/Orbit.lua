local Orbit = {};
local enabled = false;
local connection = nil;
local angle = 0;
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
Orbit.toggle = function()
	enabled = not enabled;
	local char = LocalPlayer.Character;
	if not char then
		return enabled;
	end
	local hrp = char:FindFirstChild("HumanoidRootPart");
	if not hrp then
		return enabled;
	end
	if enabled then
		angle = 0;
		local radius = 10;
		local startPos = hrp.Position;
		connection = RunService.RenderStepped:Connect(function(dt)
			if not enabled then
				return;
			end
			if (hrp and hrp.Parent) then
				angle = angle + (dt * 2);
				local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius);
				hrp.CFrame = CFrame.new(startPos + offset);
			end
		end);
	elseif connection then
		connection:Disconnect();
		connection = nil;
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
