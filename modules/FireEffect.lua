local FireEffect = {};
local enabled = false;
local fires = {};
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
FireEffect.toggle = function()
	enabled = not enabled;
	local char = LocalPlayer.Character;
	if not char then
		return enabled;
	end
	if enabled then
		for _, part in ipairs(char:GetDescendants()) do
			if (part:IsA("BasePart") or part:IsA("MeshPart")) then
				local fire = Instance.new("Fire");
				fire.Size = 3;
				fire.Heat = 10;
				fire.Color = Color3.fromRGB(255, 100, 0);
				fire.SecondaryColor = Color3.fromRGB(255, 200, 0);
				fire.Parent = part;
				table.insert(fires, fire);
			end
		end
	else
		for _, fire in ipairs(fires) do
			if (fire and fire.Parent) then
				fire:Destroy();
			end
		end
		fires = {};
	end
	return enabled;
end;
FireEffect.isEnabled = function()
	return enabled;
end;
FireEffect.disable = function()
	if enabled then
		FireEffect.toggle();
	end
end;
return FireEffect;
