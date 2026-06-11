local CarBoost = {};
local enabled = false;
local connection = nil;
local MAX_SPEED = 300;
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
CarBoost.toggle = function()
	enabled = not enabled;
	if enabled then
		connection = RunService.Heartbeat:Connect(function()
			if not enabled then
				return;
			end
			local char = LocalPlayer.Character;
			if not char then
				return;
			end
			local humanoid = char:FindFirstChildOfClass("Humanoid");
			if not humanoid then
				return;
			end
			local seat = humanoid.SeatPart;
			if (seat and seat:IsA("VehicleSeat")) then
				local vehicleModel = seat:FindFirstAncestorOfClass("Model");
				if vehicleModel then
					local primaryPart = vehicleModel.PrimaryPart or vehicleModel:FindFirstChildWhichIsA("BasePart");
					if primaryPart then
						local lookVector = primaryPart.CFrame.LookVector;
						local currentVel = primaryPart.AssemblyLinearVelocity;
						local newVel = currentVel + (lookVector * 5);
						if (newVel.Magnitude > MAX_SPEED) then
							newVel = newVel.Unit * MAX_SPEED;
						end
						primaryPart.AssemblyLinearVelocity = newVel;
					end
				end
			end
		end);
	elseif connection then
		connection:Disconnect();
		connection = nil;
	end
	return enabled;
end;
CarBoost.isEnabled = function()
	return enabled;
end;
CarBoost.disable = function()
	if enabled then
		CarBoost.toggle();
	end
end;
return CarBoost;
