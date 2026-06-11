local UI = {};
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Camera = workspace.CurrentCamera;
local THEME = {Background=Color3.fromRGB(30, 30, 46),Sidebar=Color3.fromRGB(24, 24, 37),Accent=Color3.fromRGB(119, 221, 255),Text=Color3.fromRGB(255, 255, 255),TextDark=Color3.fromRGB(170, 170, 170),Border=Color3.fromRGB(44, 44, 62),Card=Color3.fromRGB(37, 37, 53),Hover=Color3.fromRGB(45, 45, 65),Success=Color3.fromRGB(46, 213, 115),Error=Color3.fromRGB(255, 71, 87)};
local screenSize = Camera.ViewportSize;
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled;
local baseWidth, baseHeight = 700, 450;
local scale = math.min(screenSize.X / baseWidth, screenSize.Y / baseHeight, 1.2);
if isMobile then
	scale = math.min(scale, 0.85);
end
local frameWidth = math.floor(baseWidth * scale);
local frameHeight = math.floor(baseHeight * scale);
UI.new = function(class, parent, props)
	local obj = Instance.new(class);
	if parent then
		obj.Parent = parent;
	end
	if props then
		for k, v in pairs(props) do
			pcall(function()
				obj[k] = v;
			end);
		end
	end
	return obj;
end;
UI.corner = function(parent, radius)
	local c = Instance.new("UICorner");
	c.CornerRadius = UDim.new(0, radius or 6);
	c.Parent = parent;
	return c;
end;
UI.tween = function(obj, duration, props, easing, direction)
	local info = TweenInfo.new(duration or 0.3, easing or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out);
	local tw = TweenService:Create(obj, info, props);
	tw:Play();
	return tw;
end;
UI.createMainUI = function()
	local ScreenGui = UI.new("ScreenGui", LocalPlayer.PlayerGui, {Name="FScriptHub",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling});
	local MainFrame = UI.new("Frame", ScreenGui, {Name="MainFrame",Size=UDim2.new(0, frameWidth, 0, frameHeight),Position=UDim2.new(0.5, -frameWidth / 2, 0.5, -frameHeight / 2),BackgroundColor3=THEME.Background,BackgroundTransparency=0,BorderSizePixel=0,Active=true,Draggable=true,ClipsDescendants=true,Visible=false});
	UI.corner(MainFrame, 8);
	local MainStroke = UI.new("UIStroke", MainFrame, {Thickness=1,Transparency=0.5,Color=THEME.Border});
	local sidebarWidth = math.floor(160 * scale);
	local Sidebar = UI.new("Frame", MainFrame, {Name="Sidebar",Size=UDim2.new(0, sidebarWidth, 1, 0),Position=UDim2.new(0, 0, 0, 0),BackgroundColor3=THEME.Sidebar,BackgroundTransparency=0,BorderSizePixel=0});
	local SidebarTitle = UI.new("TextLabel", Sidebar, {Size=UDim2.new(1, -10, 0, 40),Position=UDim2.new(0, 10, 0, 8),BackgroundTransparency=1,Text="F脚本中心",TextColor3=THEME.Accent,TextSize=math.floor(16 * scale),Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left});
	local SidebarVersion = UI.new("TextLabel", Sidebar, {Size=UDim2.new(1, -10, 0, 16),Position=UDim2.new(0, 10, 0, 34),BackgroundTransparency=1,Text="v6.0 模块化",TextColor3=THEME.TextDark,TextSize=math.floor(10 * scale),Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left});
	local SidebarLine = UI.new("Frame", Sidebar, {Size=UDim2.new(1, -16, 0, 1),Position=UDim2.new(0, 8, 0, 56),BackgroundColor3=THEME.Border,BorderSizePixel=0});
	local ScrollFrame = UI.new("ScrollingFrame", Sidebar, {Name="ScrollFrame",Size=UDim2.new(1, -8, 1, -110),Position=UDim2.new(0, 4, 0, 62),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,CanvasSize=UDim2.new(0, 0, 0, 2000),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarImageColor3=THEME.Border});
	local ScrollLayout = UI.new("UIListLayout", ScrollFrame, {Padding=UDim.new(0, 4),SortOrder=Enum.SortOrder.LayoutOrder});
	local PlayerBar = UI.new("Frame", Sidebar, {Size=UDim2.new(1, 0, 0, 44),Position=UDim2.new(0, 0, 1, -44),BackgroundColor3=THEME.Card,BorderSizePixel=0});
	local AvatarContainer = UI.new("Frame", PlayerBar, {Size=UDim2.new(0, 32, 0, 32),Position=UDim2.new(0, 8, 0, 6),BackgroundColor3=THEME.Border,BorderSizePixel=0});
	UI.corner(AvatarContainer, 6);
	local AvatarImage = UI.new("ImageLabel", AvatarContainer, {Size=UDim2.new(1, -2, 1, -2),Position=UDim2.new(0, 1, 0, 1),BackgroundTransparency=1,Image=""});
	UI.corner(AvatarImage, 5);
	pcall(function()
		AvatarImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
	end);
	local PlayerName = UI.new("TextLabel", PlayerBar, {Size=UDim2.new(1, -50, 0, 18),Position=UDim2.new(0, 46, 0, 4),BackgroundTransparency=1,Text=LocalPlayer.DisplayName,TextColor3=THEME.Text,TextSize=math.floor(12 * scale),Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left});
	local PlayerInfo = UI.new("TextLabel", PlayerBar, {Size=UDim2.new(1, -50, 0, 14),Position=UDim2.new(0, 46, 0, 22),BackgroundTransparency=1,Text="普通用户",TextColor3=THEME.TextDark,TextSize=math.floor(10 * scale),Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left});
	local ContentFrame = UI.new("Frame", MainFrame, {Name="ContentFrame",Size=UDim2.new(1, -sidebarWidth, 1, 0),Position=UDim2.new(0, sidebarWidth, 0, 0),BackgroundColor3=THEME.Background,BackgroundTransparency=0,BorderSizePixel=0});
	local TitleBar = UI.new("Frame", ContentFrame, {Size=UDim2.new(1, 0, 0, 42),BackgroundColor3=THEME.Background,BackgroundTransparency=0,BorderSizePixel=0});
	local TitleLabel = UI.new("TextLabel", TitleBar, {Size=UDim2.new(0, 200, 0, 24),Position=UDim2.new(0, 14, 0, 9),BackgroundTransparency=1,Text="功能面板",TextColor3=THEME.Text,TextSize=math.floor(15 * scale),Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left});
	local buttons = {};
	local buttonConfigs = {{name="ClearScripts",text="🗑",pos=UDim2.new(1, -110, 0, 7)},{name="Layout",text="⟲",pos=UDim2.new(1, -78, 0, 7)},{name="Minimize",text="−",pos=UDim2.new(1, -46, 0, 7)},{name="Close",text="×",pos=UDim2.new(1, -14, 0, 7)}};
	for _, cfg in ipairs(buttonConfigs) do
		local btn = UI.new("TextButton", TitleBar, {Name=(cfg.name .. "Btn"),Size=UDim2.new(0, 26, 0, 26),Position=cfg.pos,BackgroundColor3=THEME.Card,Text=cfg.text,TextColor3=THEME.TextDark,Font=Enum.Font.GothamBold,TextSize=16,BorderSizePixel=0});
		UI.corner(btn, 6);
		btn.MouseEnter:Connect(function()
			UI.tween(btn, 0.2, {BackgroundColor3=THEME.Hover,TextColor3=THEME.Text});
		end);
		btn.MouseLeave:Connect(function()
			UI.tween(btn, 0.2, {BackgroundColor3=THEME.Card,TextColor3=THEME.TextDark});
		end);
		buttons[cfg.name] = btn;
	end
	local ContentLine = UI.new("Frame", ContentFrame, {Size=UDim2.new(1, -20, 0, 1),Position=UDim2.new(0, 10, 0, 42),BackgroundColor3=THEME.Border,BorderSizePixel=0});
	local RightPanel = UI.new("Frame", ContentFrame, {Size=UDim2.new(1, 0, 1, -42),Position=UDim2.new(0, 0, 0, 42),BackgroundTransparency=1,BorderSizePixel=0});
	local WelcomeCard = UI.new("Frame", RightPanel, {Size=UDim2.new(1, -20, 0, 80),Position=UDim2.new(0, 10, 0, 10),BackgroundColor3=THEME.Card,BorderSizePixel=0});
	UI.corner(WelcomeCard, 8);
	local WelcomeTitle = UI.new("TextLabel", WelcomeCard, {Size=UDim2.new(1, -20, 0, 24),Position=UDim2.new(0, 10, 0, 10),BackgroundTransparency=1,Text="欢迎使用 F脚本中心",TextColor3=THEME.Text,TextSize=math.floor(14 * scale),Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left});
	local WelcomeDesc = UI.new("TextLabel", WelcomeCard, {Size=UDim2.new(1, -20, 0, 18),Position=UDim2.new(0, 10, 0, 36),BackgroundTransparency=1,Text="点击左侧功能按钮开始使用",TextColor3=THEME.TextDark,TextSize=math.floor(11 * scale),Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left});
	local TimeLabel = UI.new("TextLabel", WelcomeCard, {Size=UDim2.new(1, -20, 0, 16),Position=UDim2.new(0, 10, 0, 56),BackgroundTransparency=1,TextColor3=THEME.Accent,TextSize=math.floor(10 * scale),Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left});
	coroutine.wrap(function()
		while TimeLabel and TimeLabel.Parent do
			TimeLabel.Text = os.date("%Y-%m-%d %H:%M:%S");
			task.wait(1);
		end
	end)();
	local fpsLabel = UI.new("TextLabel", ScreenGui, {Name="FPSLabel",Size=UDim2.new(0, 80, 0, 22),Position=UDim2.new(1, -90, 0, 5),BackgroundColor3=THEME.Card,BackgroundTransparency=0.2,Text="FPS: 60",TextColor3=THEME.Success,TextSize=12,Font=Enum.Font.GothamBold,ZIndex=200});
	UI.corner(fpsLabel, 6);
	local fpsStroke = UI.new("UIStroke", fpsLabel, {Thickness=1,Transparency=0.5,Color=THEME.Success});
	local lastTime = tick();
	local frameCount = 0;
	RunService.RenderStepped:Connect(function()
		frameCount = frameCount + 1;
		local currentTime = tick();
		if ((currentTime - lastTime) >= 1) then
			local fps = math.floor(frameCount / (currentTime - lastTime));
			frameCount = 0;
			lastTime = currentTime;
			if (fpsLabel and fpsLabel.Parent) then
				fpsLabel.Text = "FPS: " .. fps;
				if (fps >= 55) then
					fpsLabel.TextColor3 = THEME.Success;
					fpsStroke.Color = THEME.Success;
				elseif (fps >= 30) then
					fpsLabel.TextColor3 = Color3.fromRGB(255, 220, 0);
					fpsStroke.Color = Color3.fromRGB(255, 220, 0);
				else
					fpsLabel.TextColor3 = THEME.Error;
					fpsStroke.Color = THEME.Error;
				end
			end
		end
	end);
	local openBtn = UI.new("TextButton", ScreenGui, {Name="OpenBtn",Size=UDim2.new(0, 50, 0, 50),Position=UDim2.new(0, 15, 0.5, -25),BackgroundColor3=THEME.Accent,Text="F",TextColor3=Color3.fromRGB(0, 0, 0),Font=Enum.Font.GothamBlack,TextSize=22,BorderSizePixel=0,ZIndex=100,Active=true,Draggable=true});
	UI.corner(openBtn, 25);
	local openBtnStroke = UI.new("UIStroke", openBtn, {Thickness=2,Transparency=0.3,Color=THEME.Accent});
	return {ScreenGui=ScreenGui,MainFrame=MainFrame,Sidebar=Sidebar,ScrollFrame=ScrollFrame,ContentFrame=ContentFrame,RightPanel=RightPanel,WelcomeCard=WelcomeCard,buttons=buttons,openBtn=openBtn,UI=UI,frameWidth=frameWidth,frameHeight=frameHeight,sidebarWidth=sidebarWidth};
end;
UI.createFeatureButton = function(parent, info, index)
	local btn = UI.new("TextButton", parent, {Name=(info.id .. "Btn"),Size=UDim2.new(1, -8, 0, 34),BackgroundColor3=Color3.fromRGB(37, 37, 53),Text="",BorderSizePixel=0,LayoutOrder=index,AutoButtonColor=false});
	UI.corner(btn, 6);
	local iconLabel = UI.new("TextLabel", btn, {Size=UDim2.new(0, 22, 0, 22),Position=UDim2.new(0, 8, 0, 6),BackgroundTransparency=1,Text=info.icon,TextSize=14,Font=Enum.Font.GothamBold});
	local textLabel = UI.new("TextLabel", btn, {Name="BtnText",Size=UDim2.new(1, -40, 1, 0),Position=UDim2.new(0, 32, 0, 0),BackgroundTransparency=1,Text=info.name,TextColor3=Color3.fromRGB(170, 170, 170),TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left});
	local indicator = UI.new("Frame", btn, {Name="Indicator",Size=UDim2.new(0, 3, 0.5, 0),Position=UDim2.new(0, 0, 0.25, 0),BackgroundColor3=THEME.Accent,BorderSizePixel=0,Visible=false});
	UI.corner(indicator, 2);
	local originalColor = Color3.fromRGB(37, 37, 53);
	local hoverColor = Color3.fromRGB(45, 45, 65);
	btn.MouseEnter:Connect(function()
		UI.tween(btn, 0.2, {BackgroundColor3=hoverColor});
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
	end);
	btn.MouseLeave:Connect(function()
		UI.tween(btn, 0.2, {BackgroundColor3=originalColor});
		textLabel.TextColor3 = Color3.fromRGB(170, 170, 170);
	end);
	btn.MouseButton1Down:Connect(function()
		UI.tween(btn, 0.1, {BackgroundColor3=Color3.fromRGB(55, 55, 75)});
	end);
	btn.MouseButton1Up:Connect(function()
		UI.tween(btn, 0.15, {BackgroundColor3=hoverColor});
	end);
	return btn;
end;
return UI;
