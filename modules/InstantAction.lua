local InstantAction = {};
local enabled = false;
local originalPrompt = nil;
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
InstantAction.toggle = function()
	enabled = not enabled;
	if enabled then
		pcall(function()
			originalPrompt = game:GetService("ProximityPromptService").PromptButtonHoldBegan;
			game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
				prompt.HoldDuration = 0;
			end);
		end);
		local char = LocalPlayer.Character;
		if char then
			for _, prompt in ipairs(char:GetDescendants()) do
				if prompt:IsA("ProximityPrompt") then
					prompt.HoldDuration = 0;
				end
			end
		end
	else
		pcall(function()
			if originalPrompt then
			end
		end);
	end
	return enabled;
end;
InstantAction.isEnabled = function()
	return enabled;
end;
InstantAction.disable = function()
	if enabled then
		InstantAction.toggle();
	end
end;
return InstantAction;
