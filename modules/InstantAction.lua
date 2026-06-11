local InstantAction = {};
local enabled = false;
local connection = nil;
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
InstantAction.toggle = function()
	enabled = not enabled;
	if enabled then
		connection = game:GetService("ProximityPromptService").PromptShown:Connect(function(prompt, _)
			if enabled then
				prompt.HoldDuration = 0;
			end
		end);
		local char = LocalPlayer.Character;
		if char then
			for _, obj in ipairs(char:GetDescendants()) do
				if obj:IsA("ProximityPrompt") then
					obj.HoldDuration = 0;
				end
			end
		end
	elseif connection then
		connection:Disconnect();
		connection = nil;
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
