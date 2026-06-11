local SmokeEffect = {};
local enabled = false;
local smokes = {};
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
SmokeEffect.toggle = function()
	enabled = not enabled;
	local char = LocalPlayer.Character;
	if not char then
		return enabled;
	end
	if enabled then
		for _, part in ipairs(char:GetDescendants()) do
			if (part:IsA("BasePart") or part:IsA("MeshPart")) then
				local smoke = Instance.new("Smoke");
				smoke.Size = 2;
				smoke.Opacity = 0.3;
				smoke.RiseVelocity = 2;
				smoke.Color = Color3.fromRGB(150, 150, 150);
				smoke.Parent = part;
				table.insert(smokes, smoke);
			end
		end
	else
		for _, smoke in ipairs(smokes) do
			if (smoke and smoke.Parent) then
				smoke:Destroy();
			end
		end
		smokes = {};
	end
	return enabled;
end;
SmokeEffect.isEnabled = function()
	return enabled;
end;
SmokeEffect.disable = function()
	if enabled then
		SmokeEffect.toggle();
	end
end;
return SmokeEffect;
