local Headless = {};
local enabled = false;
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local function applyHeadless()
	local char = LocalPlayer.Character;
	if not char then
		return;
	end
	local head = char:FindFirstChild("Head");
	if not head then
		return;
	end
	head.Transparency = 1;
	if head:FindFirstChild("face") then
		head.face.Transparency = 1;
	end
end
local function removeHeadless()
	local char = LocalPlayer.Character;
	if not char then
		return;
	end
	local head = char:FindFirstChild("Head");
	if not head then
		return;
	end
	head.Transparency = 0;
	if head:FindFirstChild("face") then
		head.face.Transparency = 0;
	end
end
Headless.toggle = function()
	enabled = not enabled;
	if enabled then
		applyHeadless();
	else
		removeHeadless();
	end
	return enabled;
end;
LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(1);
	if enabled then
		applyHeadless();
	end
end);
Headless.isEnabled = function()
	return enabled;
end;
Headless.disable = function()
	if enabled then
		Headless.toggle();
	end
end;
return Headless;
