local AntiFling = {};
local antiFlingEnabled = false;
local antiKickEnabled = false;
local flingConnection = nil;
local oldNamecall = nil;
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
AntiFling.toggleAntiFling = function()
	antiFlingEnabled = not antiFlingEnabled;
	if antiFlingEnabled then
		flingConnection = RunService.Heartbeat:Connect(function()
			if not antiFlingEnabled then
				return;
			end
			local char = LocalPlayer.Character;
			if not char then
				return;
			end
			local hrp = char:FindFirstChild("HumanoidRootPart");
			if not hrp then
				return;
			end
			local vel = hrp.AssemblyLinearVelocity;
			if (vel and (vel.Magnitude > 500)) then
				hrp.AssemblyLinearVelocity = vel.Unit * 500;
				pcall(function()
					hrp:SetNetworkOwner(LocalPlayer);
				end);
			end
		end);
	elseif flingConnection then
		flingConnection:Disconnect();
		flingConnection = nil;
	end
	return antiFlingEnabled;
end;
AntiFling.toggleAntiKick = function()
	antiKickEnabled = not antiKickEnabled;
	if antiKickEnabled then
		pcall(function()
			local mt = getrawmetatable(game);
			if mt then
				oldNamecall = mt.__namecall;
				setreadonly(mt, false);
				mt.__namecall = newcclosure(function(self, method, ...)
					if ((method == "Kick") and (self == LocalPlayer)) then
						return nil;
					end
					if oldNamecall then
						return oldNamecall(self, ...);
					end
					return self[method](self, ...);
				end);
				setreadonly(mt, true);
			end
		end);
	else
		pcall(function()
			if oldNamecall then
				local mt = getrawmetatable(game);
				if mt then
					setreadonly(mt, false);
					mt.__namecall = oldNamecall;
					setreadonly(mt, true);
				end
				oldNamecall = nil;
			end
		end);
	end
	return antiKickEnabled;
end;
AntiFling.disableAntiFling = function()
	if antiFlingEnabled then
		AntiFling.toggleAntiFling();
	end
end;
AntiFling.disableAntiKick = function()
	if antiKickEnabled then
		AntiFling.toggleAntiKick();
	end
end;
AntiFling.disable = function()
	AntiFling.disableAntiFling();
	AntiFling.disableAntiKick();
end;
return AntiFling;
