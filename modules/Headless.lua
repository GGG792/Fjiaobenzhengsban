local Headless = {};
local enabled = false;
local originalHead = nil;
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
Headless.toggle = function()
	enabled = not enabled;
	local char = LocalPlayer.Character;
	if not char then
		return enabled;
	end
	local head = char:FindFirstChild("Head");
	if not head then
		return enabled;
	end
	if enabled then
		originalHead = head:Clone();
		originalHead.Name = "OriginalHead";
		originalHead.Parent = char;
		for _, part in ipairs(head:GetDescendants()) do
			if (part:IsA("BasePart") or part:IsA("MeshPart")) then
				part.Transparency = 1;
			end
		end
		head.Transparency = 1;
		if head:FindFirstChild("face") then
			head.face.Transparency = 1;
		end
	else
		head.Transparency = 0;
		if head:FindFirstChild("face") then
			head.face.Transparency = 0;
		end
		for _, part in ipairs(head:GetDescendants()) do
			if (part:IsA("BasePart") or part:IsA("MeshPart")) then
				part.Transparency = 0;
			end
		end
		if originalHead then
			originalHead:Destroy();
			originalHead = nil;
		end
	end
	return enabled;
end;
Headless.isEnabled = function()
	return enabled;
end;
Headless.disable = function()
	if enabled then
		Headless.toggle();
	end
end;
return Headless;
