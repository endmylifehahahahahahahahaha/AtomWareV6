local oldtoclipboard = getgenv().toclipboard
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
end)
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

local function getOwlModel()
	return workspace:FindFirstChild("ClientOwl")
end

local function getBulletOrigin(owl)
	local primary = owl and owl.PrimaryPart
	if not primary then return nil end
	local bo = primary:FindFirstChild("bulletOrigin")
	return bo and bo.WorldPosition or primary.Position
end

local function fireOwlProjectile(fromPos, targetPos, targetVel)
	local owl = getOwlModel()
	if not owl then return end
	local owlHandle = owl:FindFirstChild("Handle") or owl.PrimaryPart
	if not owlHandle then return end

	local NetManaged = replicatedStorage
		:WaitForChild("rbxts_include")
		:WaitForChild("node_modules")
		:WaitForChild("@rbxts")
		:WaitForChild("net")
		:WaitForChild("out")
		:WaitForChild("_NetManaged")

	local owlAiming = NetManaged:FindFirstChild("OwlAiming")
	local owlFireProjectile = NetManaged:FindFirstChild("OwlFireProjectile")
	if not owlAiming or not owlFireProjectile then return end

	local direction = (targetPos - fromPos).Unit * PROJECTILE_SPEED
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

OwlAura = vape.Categories.Blatant:CreateModule({
	Name = 'OwlAura',
	Tooltip = 'auto shoots at nearby enemies...',
	Function = function(callback)
		if callback then
			OwlAura:Clean(runService.Heartbeat:Connect(function()
				if tick() - lastShot < SHOOT_COOLDOWN then return end
				if not entitylib.isAlive then return end

				local owl = getOwlModel()
				local myRoot = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
				if not myRoot then return end
				local fromPos = owl and getBulletOrigin(owl) or myRoot.Position

				local ent = entitylib.EntityPosition({
					Range = RangeSlider and RangeSlider.Value or 40,
					Part = 'RootPart',
					Origin = fromPos,
					Wallcheck = Targets.Walls.Enabled,
					Players = Targets.Players.Enabled,
					NPCs = Targets.NPCs.Enabled,
				})

				if not ent or not ent.RootPart then return end

				local rootPos = ent.RootPart.Position
				local vel = ent.RootPart.AssemblyLinearVelocity
				local dist = (fromPos - rootPos).Magnitude
				local timeToHit = dist / PROJECTILE_SPEED
				local predictedPos = rootPos + vel * timeToHit

				lastShot = tick()
				fireOwlProjectile(fromPos, predictedPos, Vector3.zero)
			end))
		end
	end
})

Targets = OwlAura:CreateTargets({})
RangeSlider = OwlAura:CreateSlider({
	Name = 'Range',
	Min = 10,
	Max = 60,
	Default = 40,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})

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