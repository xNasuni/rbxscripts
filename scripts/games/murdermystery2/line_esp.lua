--[[ XNASUNI'S LINE ESP ]]--
local lines = {}

local bottomVector = Vector2.new(1000, 1080)

function getBackpack(player)
    return game:GetService('Players')[player].Backpack 
end

function getCharacter(player)
    return game:GetService('Players')[player].Character
end

function determineRole(player)
    if getBackpack(player.Name):FindFirstChild('Knife') or getCharacter(player.Name):FindFirstChild('Knife') then
        return 'Murderer'
    elseif getBackpack(player.Name):FindFirstChild('Gun') or getCharacter(player.Name):FindFirstChild('Gun') then
        return 'Sheriff'
    elseif game:GetService('Players').LocalPlayer:IsFriendsWith(player.UserId) then
        return 'Friend'
    elseif not getBackpack(player.Name):FindFirstChild('Knife') or not getCharacter(player.Name):FindFirstChild('Knife') or not getBackpack(player.Name):FindFirstChild('Gun') or not getCharacter(player.Name):FindFirstChild('Gun') then
        return 'None'
    end
end

function get(part)
	local camera = workspace['CurrentCamera']
	return camera:WorldToScreenPoint(part.Position)
end

function draw(p1, p2, player, properties)
	properties = properties or {}
	local line = Drawing.new('Line')
	line.From = p1
	line.To = p2
	line.Visible = true
	line.Color = Color3.fromRGB(255, 255, 255)
	line.Thickness = 1
	table.foreach(properties, function(i, v)
		line[i] = v
	end)
	
	if (determineRole(player) == 'Murderer') then
	    line.Color = Color3.fromRGB(255, 85, 85)
	elseif (determineRole(player) == 'Sheriff') then
	    line.Color = Color3.fromRGB(85, 85, 255)
	elseif (determineRole(player) == 'Friend') then
            line.Color = Color3.fromRGB(255, 175, 255)
	elseif (determineRole(player) == 'None') then
            line.Color = Color3.fromRGB(255, 255, 255)
    	end
	
	return line
end

function rendertbl(tbl)
	for _,part in pairs(tbl) do
		local position, onscreen = get(part)
		if onscreen then
			local line = draw(bottomVector, Vector2.new(position.X, position.Y + 45))
			index = table.insert(lines, line)
			table.remove(lines, index)
			wait()
			line:Remove()
		end
	end
end

shared.connection = game:GetService('RunService').RenderStepped:Connect(function()
	local playerRoots = {}
	table.foreach(game:GetService('Players'):GetPlayers(), function(index, player)
	    if player.Character:FindFirstChild('HumanoidRootPart') then
	        if player.Character:FindFirstChild('Humanoid') and player.Character.Humanoid.Health ~= 0 then
	            if player.Name ~= game:GetService('Players').LocalPlayer.Name then
		            table.insert(playerRoots, player.Character.HumanoidRootPart)
	            end
		    end
	    end
	end)
	rendertbl(playerRoots)
end)
