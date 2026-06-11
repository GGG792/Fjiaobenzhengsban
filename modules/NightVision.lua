local NightVision = {};
local nvEnabled = false;
local xrEnabled = false;
local savedLighting = {};
local partCache = {};
local Lighting = game:GetService("Lighting");
NightVision.toggleNightVision = function()
	nvEnabled = not nvEnabled;
	if nvEnabled then
		savedLighting.Brightness = Lighting.Brightness;
		savedLighting.ClockTime = Lighting.ClockTime;
		savedLighting.FogEnd = Lighting.FogEnd;
		savedLighting.Ambient = Lighting.Ambient;
		Lighting.Brightness = 2;
		Lighting.ClockTime = 14;
		Lighting.FogEnd = 100000;
		Lighting.Ambient = Color3.fromRGB(178, 178, 178);
	else
		if savedLighting.Brightness then
			Lighting.Brightness = savedLighting.Brightness;
		end
		if savedLighting.ClockTime then
			Lighting.ClockTime = savedLighting.ClockTime;
		end
		if savedLighting.FogEnd then
			Lighting.FogEnd = savedLighting.FogEnd;
		end
		if savedLighting.Ambient then
			Lighting.Ambient = savedLighting.Ambient;
		end
	end
	return nvEnabled;
end;
NightVision.toggleXRay = function()
	xrEnabled = not xrEnabled;
	if xrEnabled then
		partCache = {};
		for _, part in ipairs(workspace:GetDescendants()) do
			if (part:IsA("BasePart") and (part.Name ~= "HumanoidRootPart") and (part.Name ~= "Head")) then
				if (part.Transparency < 0.5) then
					partCache[part] = part.Transparency;
					part.Transparency = 0.5;
				end
			end
		end
	else
		for part, origTrans in pairs(partCache) do
			if (part and part.Parent) then
				part.Transparency = origTrans;
			end
		end
		partCache = {};
	end
	return xrEnabled;
end;
NightVision.disableNightVision = function()
	if nvEnabled then
		NightVision.toggleNightVision();
	end
end;
NightVision.disableXRay = function()
	if xrEnabled then
		NightVision.toggleXRay();
	end
end;
NightVision.disableAll = function()
	NightVision.disableNightVision();
	NightVision.disableXRay();
end;
return NightVision;
