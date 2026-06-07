--[[local oldtoclipboard = getgenv().toclipboard
local oldsetclipboard = getgenv().setclipboard
local oldsetrbxclipboard = getgenv().setrbxclipboard
local oldprint = getgenv().print
local oldwarn = getgenv().warn
local olderror = getgenv().error
local oldrconsoleprint = getgenv().rconsoleprint
local oldrconsoleinfo = getgenv().rconsoleinfo
local oldrconsolesettitle = getgenv().rconsolesettitle
local oldrconsolewarn = getgenv().rconsolewarn
local oldrconsoleinput = getgenv().rconsoleinput
local oldrconsoleerror = getgenv().rconsoleerror

task.spawn(function()
    toclipboard = function(arg)
        return oldtoclipboard("you tried using a executor method lol ez skid")
    end
    getgenv().oldtoclipboard = toclipboard

    setclipboard = function(arg)
        return oldsetclipboard("you tried using a executor method lol ez skid")
    end
    getgenv().oldsetclipboard = setclipboard

    setrbxclipboard = function(arg)
        return oldsetrbxclipboard("you tried using a executor method lol ez skid")
    end
    getgenv().oldsetrbxclipboard = setrbxclipboard

    print = function(...)
        return oldprint("you tried using a executor method lol ez skid")
    end
    getgenv().oldprint = print

    warn = function(...)
        return oldwarn("you tried using a executor method lol ez skid")
    end
    getgenv().oldwarn = warn

    error = function(...)
        return olderror("you tried using a executor method lol ez skid")
    end
    getgenv().olderror = error

    rconsoleprint = function(...)
        return oldrconsoleprint("you tried using a executor method lol ez skid")
    end
    getgenv().oldrconsoleprint = rconsoleprint

    rconsoleinfo = function(...)
        return oldrconsoleinfo("you tried using a executor method lol ez skid")
    end
    getgenv().oldrconsoleinfo = rconsoleinfo

    rconsolesettitle = function(...)
        return oldrconsolesettitle("you tried using a executor method lol ez skid")
    end
    getgenv().oldrconsolesettitle = rconsolesettitle

    rconsolewarn = function(...)
        return oldrconsolewarn("you tried using a executor method lol ez skid")
    end
    getgenv().oldrconsolewarn = rconsolewarn

    rconsoleinput = function(...)
        return oldrconsoleinput("you tried using a executor method lol ez skid")
    end
    getgenv().oldrconsoleinput = rconsoleinput

    rconsoleerror = function(...)
        return oldrconsoleerror("you tried using a executor method lol ez skid")
    end
    getgenv().oldrconsoleerror = rconsoleerror
end)--]]
local vape = shared.vape
local entitylib = vape.Libraries.entity
local runService = game:GetService('RunService')
local replicatedStorage = game:GetService('ReplicatedStorage')
local httpService = game:GetService('HttpService')
local playersService = game:GetService('Players')
local lplr = playersService.LocalPlayer
local OwlAura
local Targets
local RangeSlider
local PROJECTILE_SPEED = 220
local SHOOT_COOLDOWN = 0.87
local lastShot = 0

-- Cached NetManaged reference so WaitForChild isn't called every shot
local _NetManaged = nil
local function getNetManaged()
	if _NetManaged then return _NetManaged end
	local ok, nm = pcall(function()
		return replicatedStorage
			:WaitForChild("rbxts_include", 5)
			:WaitForChild("node_modules", 5)
			:WaitForChild("@rbxts", 5)
			:WaitForChild("net", 5)
			:WaitForChild("out", 5)
			:WaitForChild("_NetManaged", 5)
	end)
	if ok and nm then
		_NetManaged = nm
	end
	return _NetManaged
end

local function getOwlModel()
	return workspace:FindFirstChild("ClientOwl")
end

local function getBulletOrigin(owl)
	local primary = owl and owl.PrimaryPart
	if not primary then return nil end
	local bo = primary:FindFirstChild("bulletOrigin")
	return bo and bo.WorldPosition or primary.Position
end

local function fireOwlProjectile(fromPos, targetPos)
	local owl = getOwlModel()
	if not owl then return end
	local owlHandle = owl:FindFirstChild("Handle") or owl.PrimaryPart
	if not owlHandle then return end

	local NetManaged = getNetManaged()
	if not NetManaged then return end

	local owlAiming = NetManaged:FindFirstChild("OwlAiming")
	local owlFireProjectile = NetManaged:FindFirstChild("OwlFireProjectile")
	if not owlAiming or not owlFireProjectile then return end

	-- Avoid zero-direction crash if fromPos == targetPos
	local delta = targetPos - fromPos
	if delta.Magnitude < 0.01 then return end
	local direction = delta.Unit * PROJECTILE_SPEED
	local refId = httpService:GenerateGUID(false):sub(1, 8):upper()

	owlAiming:FireServer({ owl = owlHandle, starting = true })
	task.wait(0.05)
	owlAiming:FireServer({ owl = owlHandle, starting = false })
	owlFireProjectile:FireServer({
		fromPosition = fromPos,
		direction = direction,
		offset = nil,
		ProjectileRefId = refId,
		initialVelocity = direction
	})
end

-- Fallback entity scan — searches all players directly when entitylib has no targets
local function findNearestPlayerFallback(fromPos, range)
	local best, bestDist = nil, range * range
	for _, plr in playersService:GetPlayers() do
		if plr == lplr then continue end
		local char = plr.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not root then continue end
		local hum = char:FindFirstChild("Humanoid")
		if not hum or hum.Health <= 0 then continue end
		local distSq = (root.Position - fromPos).Magnitude
		if distSq < bestDist then
			bestDist = distSq
			best = root
		end
	end
	return best
end

OwlAura = vape.Categories.Blatant:CreateModule({
	Name = 'OwlAura',
	Tooltip = 'Auto-shoots the owl at nearby enemies. Range increased, fallback targeting included.',
	Function = function(callback)
		if callback then
			-- Pre-warm the NetManaged cache so there's no WaitForChild delay mid-shot
			task.spawn(getNetManaged)

			OwlAura:Clean(runService.Heartbeat:Connect(function()
				if tick() - lastShot < SHOOT_COOLDOWN then return end

				-- Require character but NOT entitylib.isAlive — isAlive can be nil
				-- right after spawn or on certain kits, causing the module to never fire
				local myRoot = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
				if not myRoot then return end

				local owl = getOwlModel()
				local fromPos = owl and getBulletOrigin(owl) or myRoot.Position
				local range = RangeSlider and RangeSlider.Value or 80

				local rootPos, vel

				-- Primary: use entitylib (respects walls / team checks)
				if entitylib.isAlive then
					local ent = entitylib.EntityPosition({
						Range = range,
						Part = 'RootPart',
						Origin = fromPos,
						Wallcheck = Targets and Targets.Walls and Targets.Walls.Enabled or false,
						Players = Targets and Targets.Players and Targets.Players.Enabled or true,
						NPCs = Targets and Targets.NPCs and Targets.NPCs.Enabled or false,
					})
					if ent and ent.RootPart then
						rootPos = ent.RootPart.Position
						vel = ent.RootPart.AssemblyLinearVelocity
					end
				end

				-- Fallback: scan players directly if entitylib returned nothing
				if not rootPos then
					local fallbackRoot = findNearestPlayerFallback(fromPos, range)
					if fallbackRoot then
						rootPos = fallbackRoot.Position
						vel = fallbackRoot.AssemblyLinearVelocity
					end
				end

				if not rootPos then return end

				-- Lead the target based on flight time
				local dist = (fromPos - rootPos).Magnitude
				local timeToHit = dist / PROJECTILE_SPEED
				local predictedPos = rootPos + (vel or Vector3.zero) * timeToHit

				lastShot = tick()
				fireOwlProjectile(fromPos, predictedPos)
			end))
		end
	end
})

Targets = OwlAura:CreateTargets({ Players = true })
RangeSlider = OwlAura:CreateSlider({
	Name = 'Range',
	Min = 10,
	Max = 150,
	Default = 80,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
--[[
task.spawn(function()
    toclipboard = oldtoclipboard
    setclipboard = oldsetclipboard
    setrbxclipboard = oldsetrbxclipboard
    print = oldprint
    warn = oldwarn
    error = olderror
    rconsoleprint = oldrconsoleprint
    rconsoleinfo = oldrconsoleinfo
    rconsolesettitle = oldrconsolesettitle
    rconsolewarn = oldrconsolewarn
    rconsoleinput = oldrconsoleinput
    rconsoleerror = oldrconsoleerror
end) 
--]]