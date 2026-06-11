local ESP = {};
local enabled = false;
local espObjects = {};
local connections = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local updateConnection = nil;
local function createESP(player)
	if (player == LocalPlayer) then
		return;
	end
	local function onCharacterAdded(char)
		local hrp = char:WaitForChild("HumanoidRootPart", 5);
		if not hrp then
			return;
		end
		local billboard = Instance.new("BillboardGui");
		billboard.Name = "FScriptESP";
		billboard.AlwaysOnTop = true;
		billboard.Size = UDim2.new(0, 100, 0, 40);
		billboard.StudsOffset = Vector3.new(0, 3, 0);
		billboard.Parent = hrp;
		local frame = Instance.new("Frame");
		frame.Size = UDim2.new(1, 0, 1, 0);
		frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0);
		frame.BackgroundTransparency = 0.7;
		frame.BorderSizePixel = 0;
		frame.Parent = billboard;
		local nameLabel = Instance.new("TextLabel");
		nameLabel.Name = "NameLabel";
		nameLabel.Size = UDim2.new(1, 0, 0.5, 0);
		nameLabel.BackgroundTransparency = 1;
		nameLabel.Text = player.DisplayName;
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
		nameLabel.TextSize = 10;
		nameLabel.Font = Enum.Font.GothamBold;
		nameLabel.Parent = frame;
		local distLabel = Instance.new("TextLabel");
		distLabel.Name = "DistLabel";
		distLabel.Size = UDim2.new(1, 0, 0.5, 0);
		distLabel.Position = UDim2.new(0, 0, 0.5, 0);
		distLabel.BackgroundTransparency = 1;
		distLabel.Text = "0m";
		distLabel.TextColor3 = Color3.fromRGB(200, 200, 200);
		distLabel.TextSize = 8;
		distLabel.Font = Enum.Font.Gotham;
		distLabel.Parent = frame;
		table.insert(espObjects, {gui=billboard,player=player,hrp=hrp,nameLabel=nameLabel,distLabel=distLabel});
	end
	if player.Character then
		pcall(onCharacterAdded, player.Character);
	end
	local conn = player.CharacterAdded:Connect(onCharacterAdded);
	table.insert(connections, conn);
end
ESP.toggle = function()
	enabled = not enabled;
	if enabled then
		updateConnection = RunService.RenderStepped:Connect(function()
			if not enabled then
				return;
			end
			local myChar = LocalPlayer.Character;
			local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart");
			for _, data in ipairs(espObjects) do
				if (data.gui and data.gui.Parent and data.hrp and data.hrp.Parent) then
					if myHrp then
						local dist = (myHrp.Position - data.hrp.Position).Magnitude;
						data.distLabel.Text = math.floor(dist) .. "m";
					end
					data.nameLabel.Text = data.player.DisplayName;
				end
			end
		end);
		for _, player in ipairs(Players:GetPlayers()) do
			createESP(player);
		end
		local conn = Players.PlayerAdded:Connect(createESP);
		table.insert(connections, conn);
	else
		if updateConnection then
			updateConnection:Disconnect();
			updateConnection = nil;
		end
		for _, obj in ipairs(espObjects) do
			if (obj.gui and obj.gui.Parent) then
				obj.gui:Destroy();
			end
		end
		espObjects = {};
		for _, conn in ipairs(connections) do
			if conn then
				conn:Disconnect();
			end
		end
		connections = {};
	end
	return enabled;
end;
ESP.isEnabled = function()
	return enabled;
end;
ESP.disable = function()
	if enabled then
		ESP.toggle();
	end
end;
return ESP;
