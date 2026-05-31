--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.
local entitylib = {
	isAlive = false,
	character = {},
	List = {},
	Connections = {},
	PlayerConnections = {},
	EntityThreads = {},
	Running = false,
	Events = setmetatable({}, {
		__index = function(self, ind)
			self[ind] = {
				Connections = {},
				Connect = function(rself, func)
					table.insert(rself.Connections, func)
					return {
						Disconnect = function()
							local rind = table.find(rself.Connections, func)
							if rind then
								table.remove(rself.Connections, rind)
							end
						end
					}
				end,
				Fire = function(rself, ...)
					for _, v in rself.Connections do
						task.spawn(v, ...)
					end
				end,
				Destroy = function(rself)
					table.clear(rself.Connections)
					table.clear(rself)
				end
			}

			return self[ind]
		end
	})
}

local cloneref = cloneref or function(obj)
	return obj
end
local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local lplr = playersService.LocalPlayer
local gameCamera = workspace.CurrentCamera

local function getMousePosition()
	if inputService.TouchEnabled then
		return gameCamera.ViewportSize / 2
	end
	return inputService.GetMouseLocation(inputService)
end

local function loopClean(tbl)
	if not tbl or type(tbl) ~= 'table' then return end
	table.clear(tbl)
end

local function waitForChildOfType(obj, name, timeout, prop)
	if not obj or not name or not timeout then return nil end
	
	timeout = math.max(0, timeout or 10)
	local startTime = tick()
	
	repeat
		local child
		if prop then
			child = obj[name]
		else
			pcall(function()
				child = obj:FindFirstChild(name)
			end)
		end
		
		if child then return child end
		if tick() - startTime > timeout then return nil end
		
		task.wait()
	until false
end

local function ensureHumanoidScaleValues(hum)
	for _, name in {'BodyDepthScale', 'BodyHeightScale', 'BodyWidthScale', 'HeadScale', 'BodyTypeScale', 'BodyProportionScale'} do
		if not hum:FindFirstChild(name) then
			local value = Instance.new('NumberValue')
			value.Name = name
			value.Value = (name == 'BodyTypeScale' or name == 'BodyProportionScale') and 0 or 1
			value.Parent = hum
		end
	end
end

entitylib.targetCheck = function(ent)
	if ent.TeamCheck then
		return ent:TeamCheck()
	end
	if ent.NPC then return true end
	if not lplr.Team then return true end
	if not ent.Player.Team then return true end
	if ent.Player.Team ~= lplr.Team then return true end
	return #ent.Player.Team:GetPlayers() == #playersService:GetPlayers()
end

entitylib.getUpdateConnections = function(ent)
	local hum = ent.Humanoid
	return {
		hum:GetPropertyChangedSignal('Health'),
		hum:GetPropertyChangedSignal('MaxHealth')
	}
end

entitylib.isVulnerable = function(ent)
	return ent.Health > 0 and not ent.Character.FindFirstChildWhichIsA(ent.Character, 'ForceField')
end

entitylib.getEntityColor = function(ent)
	ent = ent.Player
	return ent and tostring(ent.TeamColor) ~= 'White' and ent.TeamColor.Color or nil
end

entitylib.IgnoreObject = RaycastParams.new()
entitylib.IgnoreObject.RespectCanCollide = true
entitylib.Wallcheck = function(origin, position, ignoreobject)
	if typeof(ignoreobject) ~= 'Instance' then
		local ignorelist = {gameCamera, lplr.Character}
		for _, v in entitylib.List do
			if v.Targetable then
				table.insert(ignorelist, v.Character)
			end
		end

		if typeof(ignoreobject) == 'table' then
			for _, v in ignoreobject do
				table.insert(ignorelist, v)
			end
		end

		ignoreobject = entitylib.IgnoreObject
		ignoreobject.FilterDescendantsInstances = ignorelist
	end
	return workspace.Raycast(workspace, origin, (position - origin), ignoreobject)
end

entitylib.EntityMouse = function(entitysettings)
	if not entitysettings or not entitylib.isAlive then
		if entitysettings then table.clear(entitysettings) end
		return nil
	end
	
	local mouseLocation, sortingTable = entitysettings.MouseOrigin or getMousePosition(), {}
	
	-- Early exit if we have no entities to check
	if #entitylib.List == 0 then
		table.clear(entitysettings)
		return nil
	end
	
	for _, v in ipairs(entitylib.List) do
		-- Validate entity and settings
		if not v or not v[entitysettings.Part] then continue end
		if not entitysettings.Players and v.Player then continue end
		if not entitysettings.NPCs and v.NPC then continue end
		if not v.Targetable then continue end
		
		local position, vis = gameCamera:WorldToViewportPoint(v[entitysettings.Part].Position)
		if not vis then continue end
		
		local mag = (mouseLocation - Vector2.new(position.x, position.y)).Magnitude
		if mag > (entitysettings.Range or math.huge) then continue end
		
		if entitylib.isVulnerable(v) then
			table.insert(sortingTable, {
				Entity = v,
				Magnitude = v.Target and -1 or mag
			})
		end
	end

	table.sort(sortingTable, entitysettings.Sort or function(a, b)
		return a.Magnitude < b.Magnitude
	end)

	for _, data in ipairs(sortingTable) do
		if entitysettings.Wallcheck then
			if entitylib.Wallcheck(entitysettings.Origin, data.Entity[entitysettings.Part].Position, entitysettings.Wallcheck) then 
				continue 
			end
		end
		loopClean(entitysettings)
		loopClean(sortingTable)
		return data.Entity
	end
	
	loopClean(sortingTable)
	loopClean(entitysettings)
	return nil
end

entitylib.EntityPosition = function(entitysettings)
	if not entitysettings or not entitylib.isAlive then
		if entitysettings then table.clear(entitysettings) end
		return nil
	end
	
	local localPosition = entitysettings.Origin or (entitylib.character and entitylib.character.HumanoidRootPart and entitylib.character.HumanoidRootPart.Position)
	if not localPosition then 
		table.clear(entitysettings)
		return nil 
	end
	
	local sortingTable = {}
	
	-- Early exit if we have no entities
	if #entitylib.List == 0 then
		table.clear(entitysettings)
		return nil
	end
	
	for _, v in ipairs(entitylib.List) do
		if not v or not v[entitysettings.Part] then continue end
		if not entitysettings.Players and v.Player then continue end
		if not entitysettings.NPCs and v.NPC then continue end
		if not v.Targetable then continue end
		
		local mag = (v[entitysettings.Part].Position - localPosition).Magnitude
		if mag > (entitysettings.Range or math.huge) then continue end
		
		if entitylib.isVulnerable(v) then
			table.insert(sortingTable, {
				Entity = v,
				Magnitude = v.Target and -1 or mag
			})
		end
	end

	table.sort(sortingTable, entitysettings.Sort or function(a, b)
		return a.Magnitude < b.Magnitude
	end)

	for _, data in ipairs(sortingTable) do
		if entitysettings.Wallcheck then
			if entitylib.Wallcheck(localPosition, data.Entity[entitysettings.Part].Position, entitysettings.Wallcheck) then 
				continue 
			end
		end
		loopClean(entitysettings)
		loopClean(sortingTable)
		return data.Entity
	end
	
	loopClean(sortingTable)
	loopClean(entitysettings)
	return nil
end

entitylib.AllPosition = function(entitysettings)
	local returned = {}
	
	if not entitysettings or not entitylib.isAlive then
		if entitysettings then table.clear(entitysettings) end
		return returned
	end
	
	local localPosition = entitysettings.Origin or (entitylib.character and entitylib.character.HumanoidRootPart and entitylib.character.HumanoidRootPart.Position)
	if not localPosition then 
		table.clear(entitysettings)
		return returned 
	end
	
	local sortingTable = {}
	local maxLimit = entitysettings.Limit or math.huge
	
	-- Early exit if no entities
	if #entitylib.List == 0 then
		table.clear(entitysettings)
		return returned
	end
	
	for _, v in ipairs(entitylib.List) do
		if not v or not v[entitysettings.Part] then continue end
		if not entitysettings.Players and v.Player then continue end
		if not entitysettings.NPCs and v.NPC then continue end
		if not v.Targetable then continue end
		
		local mag = (v[entitysettings.Part].Position - localPosition).Magnitude
		if mag > (entitysettings.Range or math.huge) then continue end
		
		if entitylib.isVulnerable(v) then
			table.insert(sortingTable, {Entity = v, Magnitude = v.Target and -1 or mag})
		end
	end

	table.sort(sortingTable, entitysettings.Sort or function(a, b)
		return a.Magnitude < b.Magnitude
	end)

	for _, data in ipairs(sortingTable) do
		if entitysettings.Wallcheck then
			if entitylib.Wallcheck(localPosition, data.Entity[entitysettings.Part].Position, entitysettings.Wallcheck) then 
				continue 
			end
		end
		table.insert(returned, data.Entity)
		if #returned >= maxLimit then break end
	end
	
	loopClean(sortingTable)
	loopClean(entitysettings)
	return returned
end

entitylib.getEntity = function(char)
	for i, v in entitylib.List do
		if v.Player == char or v.Character == char then
			return v, i
		end
	end
end

entitylib.addEntity = function(char, plr, teamfunc)
	if not char then return end
	entitylib.EntityThreads[char] = task.spawn(function()
		local hum = waitForChildOfType(char, 'Humanoid', 10)
		if plr == lplr and hum then
			ensureHumanoidScaleValues(hum)
		end
		local humrootpart = hum and waitForChildOfType(hum, 'RootPart', workspace.StreamingEnabled and 9e9 or 10, true)
		local head = char:WaitForChild('Head', 10) or humrootpart

		if hum and humrootpart then
			-- Safe HipHeight calculation with nil checks
			local rigType = hum.RigType
			local rigOffset = (rigType == Enum.HumanoidRigType.R6) and 2 or 0
			local rootSize = humrootpart.Size
			local hipHeight = hum.HipHeight + (rootSize and rootSize.Y / 2 or 0) + rigOffset
			
			local entity = {
				Connections = {},
				Character = char,
				Health = hum.Health,
				Head = head,
				Humanoid = hum,
				HumanoidRootPart = humrootpart,
				HipHeight = hipHeight,
				MaxHealth = hum.MaxHealth,
				NPC = plr == nil,
				Player = plr,
				RootPart = humrootpart,
				TeamCheck = teamfunc
			}

			if plr == lplr then
				entitylib.character = entity
				entitylib.isAlive = true
				entitylib.Events.LocalAdded:Fire(entity)
			else
				entity.Targetable = entitylib.targetCheck(entity)

				for _, v in entitylib.getUpdateConnections(entity) do
					table.insert(entity.Connections, v:Connect(function()
						entity.Health = hum.Health
						entity.MaxHealth = hum.MaxHealth
						entitylib.Events.EntityUpdated:Fire(entity)
					end))
				end

				table.insert(entitylib.List, entity)
				entitylib.Events.EntityAdded:Fire(entity)
			end
			--[[table.insert(entity.Connections, char.ChildRemoved:Connect(function(part)
				if (part == humrootpart or part == hum or part == head) then
					local found = char:FindFirstChild(part.Name)
					if found then
						if part == humrootpart then
							entity.HumanoidRootPart = found
							entity.RootPart = found
							humrootpart = found
							return
						elseif part == head then
							entity.Head = found
							head = found
							return
						end
					end
					entitylib.removeEntity(char, plr == lplr)
				end
			end))]]
		end
		entitylib.EntityThreads[char] = nil
	end)
end

entitylib.removeEntity = function(char, localcheck)
	if localcheck then
		if entitylib.isAlive then
			entitylib.isAlive = false
			-- Safely disconnect all connections
			if entitylib.character and entitylib.character.Connections then
				for _, connection in ipairs(entitylib.character.Connections) do
					if connection and typeof(connection) == 'RBXScriptConnection' then
						pcall(function() connection:Disconnect() end)
					end
				end
				table.clear(entitylib.character.Connections)
			end
			entitylib.Events.LocalRemoved:Fire(entitylib.character)
		end
		return
	end

	if not char then return end
	
	-- Cancel the entity spawn task if it's still running
	if entitylib.EntityThreads[char] then
		pcall(task.cancel, entitylib.EntityThreads[char])
		entitylib.EntityThreads[char] = nil
	end

	local entity, ind = entitylib.getEntity(char)
	if entity and ind then
		-- Safely disconnect all entity connections
		if entity.Connections then
			for _, connection in ipairs(entity.Connections) do
				if connection and typeof(connection) == 'RBXScriptConnection' then
					pcall(function() connection:Disconnect() end)
				end
			end
			table.clear(entity.Connections)
		end
		table.remove(entitylib.List, ind)
		entitylib.Events.EntityRemoved:Fire(entity)
	end
end

entitylib.refreshEntity = function(char, plr)
	entitylib.removeEntity(char)
	entitylib.addEntity(char, plr)
end

entitylib.addPlayer = function(plr)
	if not plr then return end
	
	-- Add existing character if present
	if plr.Character then
		entitylib.refreshEntity(plr.Character, plr)
	end
	
	-- Set up connection table for this player
	local connections = {}
	
	-- Character added
	table.insert(connections, plr.CharacterAdded:Connect(function(char)
		if char then
			entitylib.refreshEntity(char, plr)
		end
	end))
	
	-- Character removing
	table.insert(connections, plr.CharacterRemoving:Connect(function(char)
		if char then
			entitylib.removeEntity(char, plr == lplr)
		end
	end))
	
	-- Team changed
	table.insert(connections, plr:GetPropertyChangedSignal('Team'):Connect(function()
		-- Update targetability for this player's entities
		for _, v in ipairs(entitylib.List) do
			if v.Player == plr and v.Targetable ~= entitylib.targetCheck(v) then
				entitylib.refreshEntity(v.Character, v.Player)
			end
		end
		
		-- Refresh all if local player changed team
		if plr == lplr then
			entitylib.start()
		end
	end))
	
	entitylib.PlayerConnections[plr] = connections
end

entitylib.removePlayer = function(plr)
	if not plr then return end
	
	-- Disconnect all player event connections safely
	if entitylib.PlayerConnections[plr] then
		local connections = entitylib.PlayerConnections[plr]
		for _, connection in ipairs(connections) do
			if connection and typeof(connection) == 'RBXScriptConnection' then
				pcall(function() connection:Disconnect() end)
			end
		end
		table.clear(connections)
		entitylib.PlayerConnections[plr] = nil
	end
	
	-- Remove player's character from entity list
	local entity, ind = entitylib.getEntity(plr)
	if entity and ind then
		entitylib.removeEntity(entity.Character, false)
	end
end

entitylib.start = function()
	if entitylib.Running then
		entitylib.stop()
	end
	table.insert(entitylib.Connections, playersService.PlayerAdded:Connect(function(v)
		entitylib.addPlayer(v)
	end))
	table.insert(entitylib.Connections, playersService.PlayerRemoving:Connect(function(v)
		entitylib.removePlayer(v)
	end))
	for _, v in playersService:GetPlayers() do
		entitylib.addPlayer(v)
	end
	table.insert(entitylib.Connections, workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function()
		gameCamera = workspace.CurrentCamera or workspace:FindFirstChildWhichIsA('Camera')
	end))
	entitylib.Running = true
end

entitylib.stop = function()
	if not entitylib.Running then return end
	
	-- Disconnect all global connections
	for _, connection in ipairs(entitylib.Connections) do
		if connection and typeof(connection) == 'RBXScriptConnection' then
			pcall(function() connection:Disconnect() end)
		end
	end
	table.clear(entitylib.Connections)
	
	-- Disconnect all player connections
	for plr, connections in pairs(entitylib.PlayerConnections) do
		if connections and type(connections) == 'table' then
			for _, connection in ipairs(connections) do
				if connection and typeof(connection) == 'RBXScriptConnection' then
					pcall(function() connection:Disconnect() end)
				end
			end
			table.clear(connections)
		end
	end
	table.clear(entitylib.PlayerConnections)
	
	-- Remove local player entity
	entitylib.removeEntity(nil, true)
	
	-- Remove all other entities
	local cloned = table.clone(entitylib.List)
	for _, v in ipairs(cloned) do
		if v and v.Character then
			entitylib.removeEntity(v.Character, false)
		end
	end
	table.clear(cloned)
	
	-- Cancel all pending entity spawn tasks
	for char, taskId in pairs(entitylib.EntityThreads) do
		if taskId then
			pcall(task.cancel, taskId)
		end
		entitylib.EntityThreads[char] = nil
	end
	
	entitylib.Running = false
end

entitylib.kill = function()
	if entitylib.Running then
		entitylib.stop()
	end
	for _, v in entitylib.Events do
		v:Destroy()
	end
	entitylib.IgnoreObject:Destroy()
	loopClean(entitylib)
end

entitylib.refresh = function()
	local cloned = table.clone(entitylib.List)
	for _, v in cloned do
		entitylib.refreshEntity(v.Character, v.Player)
	end
	table.clear(cloned)
end

entitylib.start()

return entitylib
