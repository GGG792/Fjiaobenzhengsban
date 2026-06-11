local Waypoint = {};
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local waypoints = {};
local waypointUI = nil;
Waypoint.add = function(name)
	local char = LocalPlayer.Character;
	if (not char or not char:FindFirstChild("HumanoidRootPart")) then
		return false, "无法获取当前位置";
	end
	local pos = char.HumanoidRootPart.Position;
	local wpName = name or ("路径点 " .. (#waypoints + 1));
	table.insert(waypoints, {name=wpName,position=pos,cframe=char.HumanoidRootPart.CFrame});
	return true, "已保存: " .. wpName;
end;
Waypoint.teleport = function(index)
	if not waypoints[index] then
		return false, "路径点不存在";
	end
	local char = LocalPlayer.Character;
	if (not char or not char:FindFirstChild("HumanoidRootPart")) then
		return false, "角色未加载";
	end
	char.HumanoidRootPart.CFrame = waypoints[index].cframe;
	return true, "已传送到: " .. waypoints[index].name;
end;
Waypoint.delete = function(index)
	if not waypoints[index] then
		return false, "路径点不存在";
	end
	local name = waypoints[index].name;
	table.remove(waypoints, index);
	return true, "已删除: " .. name;
end;
Waypoint.getList = function()
	return waypoints;
end;
Waypoint.clear = function()
	waypoints = {};
	return true, "已清空所有路径点";
end;
return Waypoint;
