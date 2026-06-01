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

local run = function(func)
    local suc, res = pcall(function()
        task.spawn(func)
    end)
    if not suc then
        warn(`[AEROV4 MODULE ISSUE]: Failed to load module response {res}`)
    end
end
local cloneref = cloneref or function(obj) return obj end
local runService = cloneref(game:GetService('RunService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local httpService = cloneref(game:GetService('HttpService'))
local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))


local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer

local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local bedwars = getgenv().bedwars or {}
local store = getgenv().store or {}
local remotes = getgenv().remotes or {}


local function getAccountTier(player)
	if getgenv().getAccountTier then
		return getgenv().getAccountTier(player)
	end
	return 0
end  

local function isFrozen(entity, threshold)
    threshold = threshold or 10
    local char
    if type(entity) == "table" and entity.Character then
        char = entity.Character
    elseif type(entity) == "Instance" and entity:IsA("Model") then
        char = entity
    elseif entity == nil then
        if not entitylib.isAlive then return false end
        char = entitylib.character.Character
    else
        return false
    end

    local stacks = char:GetAttribute("ColdStacks") or char:GetAttribute("FrostStacks")
               or char:GetAttribute("FreezeStacks") or char:GetAttribute("FROZEN_STACKS")
    if stacks and stacks >= threshold then return true end

    local statusEffects = char:GetAttribute("StatusEffects")
    if type(statusEffects) == "table" then
        for effectName, stackCount in pairs(statusEffects) do
            local nameLower = tostring(effectName):lower()
            if nameLower:match("cold") or nameLower:match("frost") or nameLower:match("freeze") then
                if type(stackCount) == "number" then
                    if stackCount >= threshold then return true end
                elseif stackCount then
                    return true
                end
            end
        end
    end

    if char:FindFirstChild("IceBlock") or char:FindFirstChild("FrozenBlock") or char:FindFirstChild("IceShell") then
        return true
    end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.WalkSpeed <= 2 then
        return true
    end

    return false
end

local function switchItem(tool, delayTime)
	delayTime = delayTime or 0.05
	local check = lplr.Character and lplr.Character:FindFirstChild('HandInvItem') or nil
	if check and check.Value ~= tool and tool.Parent ~= nil then
		task.spawn(function()
			bedwars.Client:Get(remotes.EquipItem):CallServerAsync({hand = tool})
		end)
		check.Value = tool
		if delayTime > 0 then
			task.wait(delayTime)
		end
		return true
	end
end

run(function()
	local SilentAura
	local Targets
	local AimSpeed
	local AimSmoothness
	local AimShake
	local AimShakeValue
	local Angle
	local Sort
	local SyncHits
	local Mouse
	local Swing
	local SilentAim
	local Limit
	local TargetArea
	local ChargeTime
	local ChargeTimeSlider
	local UpdateRate
	local ExtendAttackRange
	local ExtendSwingRange

	local defaultAttackRange = 12.6
	local defaultSwingRange = 14.4
	local lastAttackTime = 0
	local Attacking = false
	local AnimDelay = 0
	local swingCooldown = 0
	local rng = Random.new()
	local SyncChecks = {
		ViewSwing = false,
		ThirdSwing = false,
	}
	local lastAnimationTime = 0
	local isClaw = false
    local lastCharge = tick()
    local lc = 0

	local AttackRemote = nil

	local Boxes = {}
	local suc, res = pcall(function()
		AttackRemote = bedwars.Client:Get('SwordHit')
	end)


	local kitChecks = {
		['Sophia'] = function() return isFrozen(nil, 10) end,
		['Sigrid'] = function() return entitylib.isAlive and lplr.Character and lplr.Character:FindFirstChild('elk') ~= nil end,
	}

	local function setupAnimationTracking()
		if not getgenv().oldViewModelKA then
			getgenv().oldViewModelKA = bedwars.ViewmodelController.playAnimation
		end
		bedwars.ViewmodelController.playAnimation = function(...)
			local call = {...}
			local id = select(2, ...)
			if id == 15 or id == '15' or id == 16 or id == '16' then
				SyncChecks.ViewSwing = true
				lastAnimationTime = tick()
				task.delay(0.2, function()
					SyncChecks.ViewSwing = false
				end)
			end
			return getgenv().oldViewModelKA(unpack(call))
		end

		if not getgenv().oldSwordCtlerKA then
			getgenv().oldSwordCtlerKA = bedwars.SwordController.playSwordEffect
		end
		bedwars.SwordController.playSwordEffect = function(...)
			local call = {...}
			SyncChecks.ThirdSwing = true
			lastAnimationTime = tick()
			task.delay(0.2, function()
				SyncChecks.ThirdSwing = false
			end)
			return getgenv().oldSwordCtlerKA(unpack(call))
		end
	end

	local function getAttackData()
		local stunTime = lplr.Character and lplr.Character:GetAttribute('StunnedUntilTime')
		if stunTime and stunTime > workspace:GetServerTimeNow() then return false end
		
		for _, check in pairs(kitChecks) do
			if check() then return false end
		end

		if bedwars.SummonerKitController:isPlayerCastingSpell(lplr) then return false end
		
		if Mouse.Enabled then
			local recentSwing = (tick() - bedwars.SwordController.lastSwing) <= 0.2
			if not recentSwing and not inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
				return false
			end
		end

		if bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then return false end

		local sword = Limit.Enabled and store.hand or store.tools.sword
		if not sword or not sword.tool then return false end

		if Limit.Enabled and (store.hand.toolType ~= 'sword' or bedwars.DaoController.chargingMaid) then 
			return false 
		end

		if SyncHits and SyncHits.Enabled then
			return sword, bedwars.ItemMeta[sword.tool.Name], true
		else
			local chargeTimeValue = (ChargeTime and ChargeTime.Enabled and ChargeTimeSlider and ChargeTimeSlider.Value) or 0.38
			return sword, bedwars.ItemMeta[sword.tool.Name], (tick() - lastAttackTime) >= chargeTimeValue
		end
	end

	local function playSwordAnimation(meta)
		if not meta then return end
		pcall(function()
			if isClaw then
				bedwars.SummonerClawController:clawAttack(lplr, entitylib.character.RootPart.Position, gameCamera.CFrame.LookVector, store.hand.tool.Name or 'summoner_claw_1')
			else
				bedwars.SwordController:playSwordEffect(meta, false)
				if meta.displayName and meta.displayName:find(' Scythe') then
					bedwars.ScytheController:playLocalAnimation()
				end
			end
		end)
	end

	local function SilentAimFunc(ent, dt)
		if not SilentAim.Enabled or not ent or not ent.RootPart then return end

		local root = entitylib.character.RootPart
		local aimPos

		if TargetArea.Value == 'Head' then
			local head = ent.Character and ent.Character:FindFirstChild('Head')
			aimPos = head and head.Position or ent.RootPart.Position + Vector3.new(0, 2.5, 0)
		else
			aimPos = ent.RootPart.Position + Vector3.new(0, 2, 0)
		end

		local noise = (rng:NextNumber() - 0.5) * (AimShake.Enabled and AimShakeValue.Value / 8 or 1.2)
		aimPos += Vector3.new(noise * 0.6, noise * 0.3 + (rng:NextNumber()-0.5)*0.4, noise * 0.6)

		local baseSpeed = (AimSpeed.Value or 4.2) / 10
		local smoothness = (AimSmoothness.Value or 12) / 30
		local speed = math.clamp(baseSpeed * (1 - smoothness) + 0.11, 0.07, 0.89)

		local targetCFrame = CFrame.lookAt(gameCamera.CFrame.Position, aimPos)
		gameCamera.CFrame = gameCamera.CFrame:Lerp(targetCFrame, speed)
	end

	SilentAura = vape.Categories.Combat:CreateModule({
		Name = 'SilentAura',
		Tooltip = 'legit killaura',
		Function = function(callback)
			if callback then
				if not suc then
					vape:CreateNotification('Vape', 'Remote fetch failed. Using fallback.', 16, 'warning')
                    AttackRemote = {
                        SendToServer = function(...)
                            local args = {...}
                            replicatedStorage:FindFirstChild("rbxts_include"):FindFirstChild("node_modules"):FindFirstChild("@rbxts"):FindFirstChild("net"):FindFirstChild("out"):FindFirstChild("_NetManaged"):FindFirstChild("SwordHit"):FireServer(unpack(args))
                        end,
                    }
				else
					AttackRemote = res
				end

				if vape.Modules.Killaura and vape.Modules.Killaura.Enabled then
					vape.Modules.Killaura:Toggle()
				end
				if vape.Modules.GrandKillaura and vape.Modules.GrandKillaura.Enabled then
					vape.Modules.GrandKillaura:Toggle()
				end

				setupAnimationTracking()

				local currentTarget = nil
				local lastTargetSwitch = 0
				local lastAttack = 0
				local lastSwingAnimTime = 0

				SilentAura:Clean(runService.Heartbeat:Connect(function(dt)
					if not entitylib.isAlive then return end

					local root = entitylib.character.RootPart
					if not root then return end

					local swingRange = defaultSwingRange + (ExtendSwingRange and ExtendSwingRange.Value or 0)
					
					local Plrs = entitylib.AllPosition({
						Range = swingRange,
						Wallcheck = Targets.Walls.Enabled,
						Part = 'RootPart',
						Players = Targets.Players.Enabled,
						NPCs = Targets.NPCs.Enabled,
						Limit = 1,
					})

					if #Plrs > 0 then
						local best = Plrs[1]
						if best ~= currentTarget and (tick() - lastTargetSwitch) > 0.12 then
							if currentTarget and math.random(1,100) <= 28 then
								return
							end
							currentTarget = best
							lastTargetSwitch = tick()
						end
					else
						currentTarget = nil
					end

					if not currentTarget or not currentTarget.RootPart then
						Attacking = false
						store.SilentauraTarget = nil
						return
					end

					Attacking = true
					store.SilentauraTarget = currentTarget

					SilentAimFunc(currentTarget, dt)

					local ent = currentTarget
					local delta = ent.RootPart.Position - root.Position
					local distance = delta.Magnitude

					local sword, meta, canAttack = getAttackData()
					local attackRange = defaultAttackRange + (ExtendAttackRange and ExtendAttackRange.Value or 0)

					if sword and canAttack and distance <= attackRange then
						switchItem(sword.tool, 0)
						local now = tick()
						local minDelay = 0.17
						
						if SyncHits and SyncHits.Enabled then
							minDelay = 0.12
						else
							minDelay = (ChargeTime and ChargeTime.Enabled and ChargeTimeSlider and ChargeTimeSlider.Value) or 0.38
						end

						if (now - lastAttack) >= minDelay + rng:NextNumber(0, 0.065) then
							if math.random(1, 100) <= 9 then
								lastAttack = now + 0.08
								return
							end

							if SyncHits and SyncHits.Enabled then
								playSwordAnimation(meta)
								lastSwingAnimTime = now
								task.wait(lplr:GetNetworkPing())
								if not SyncChecks.ViewSwing and not SyncChecks.ThirdSwing then
									task.wait(0.03)
								end
							else
								if not Swing.Enabled then
									playSwordAnimation(meta)
								end
							end

							local camPos = gameCamera.CFrame.Position
							local dir = (ent.RootPart.Position - camPos).Unit

							lastAttack = now
							lastAttackTime = now
                            lc = lastCharge
                            lastCharge = tick() - lc
                            

							local attackData = {
								weapon = sword.tool,
								entityInstance = ent.Character,
								chargedAttack = {chargeRatio = lastCharge},
								validate = {
									raycast = {
										cameraPosition = {value = camPos},
										cursorDirection = {value = dir}
									},
									targetPosition = {value = ent.RootPart.Position},
									selfPosition = {value = root.Position}
								}
							}

							local dsuc, dres = pcall(function()
								return playersService:GetPlayerFromCharacter(attackData.entityInstance)
							end)

							if dsuc then
								pcall(function()
									if getAccountTier(dres) == 4 and getAccountTier(lplr) == 0 then lastAttack = lastAttack * 6 end
									if getAccountTier(dres) >= 99 and getAccountTier(lplr) <= 4 then lastAttack = math.huge end
								end)
							end

							pcall(function()
                                lastCharge = tick()
								bedwars.Client:Get('SwordHit'):SendToServer(attackData)
							end)

							targetinfo.Targets[ent] = now + 1
						end
					end
				end))

			else
				Attacking = false
				store.SilentauraTarget = nil
				if getgenv().oldViewModelKA then
					bedwars.ViewmodelController.playAnimation = getgenv().oldViewModelKA
				end
				if getgenv().oldSwordCtlerKA then
					bedwars.SwordController.playSwordEffect = getgenv().oldSwordCtlerKA
				end
			end
		end
	})
	
	repeat task.wait(0.08) until SilentAura
	
	Targets = SilentAura:CreateTargets({ 
		Players = true, 
		Walls = true 
	})

	SilentAim = SilentAura:CreateToggle({
		Name = 'Silent Aim',
		Default = true,
		Function = function(c)
			if AimSpeed then AimSpeed.Object.Visible = c end
			if AimSmoothness then AimSmoothness.Object.Visible = c end
			if AimShake then AimShake.Object.Visible = c end
            if TargetArea then TargetArea.Object.Visible = c end
		end
	})

	TargetArea = SilentAura:CreateDropdown({ 
		Name = 'Target Area', 
		List = {'RootPart', 'Head'},
        Visible = SilentAim.Enabled,
	})

	AimSpeed = SilentAura:CreateSlider({ 
		Name = "Aim Speed", 
		Min = 1, 
		Max = 10, 
		Default = 4.2,
        Visible = SilentAim.Enabled,
	})

	AimSmoothness = SilentAura:CreateSlider({ 
		Name = "Aim Smoothness", 
		Min = 1, 
		Max = 30, 
		Default = 13,
        Visible = SilentAim.Enabled,
	})

	AimShake = SilentAura:CreateToggle({
		Name = "Aim Shake",
		Default = true,
        Visible = SilentAim.Enabled,
		Function = function(c)
			if AimShakeValue then AimShakeValue.Object.Visible = c end
		end
	})

	AimShakeValue = SilentAura:CreateSlider({ 
		Name = "Shake Amount", 
		Min = 1, 
		Max = 12,
		Default = 3.5, 
		Visible = AimShake.Enabled 
	})

	SyncHits = SilentAura:CreateToggle({
		Name = 'Sync Hits',
		Tooltip = 'when enabled syncs attacks with sword animations\n when enabled off uses Charge Time value for attack speed.',
		Default = false,
		Function = function(c)
			if ChargeTime then 
				ChargeTime.Object.Visible = not c
			end
			if ChargeTimeSlider then
				ChargeTimeSlider.Object.Visible = not c
			end
		end
	})

	ChargeTime = SilentAura:CreateToggle({
		Name = 'Custom Charge Time',
		Default = true,
		Visible = true,
		Function = function(c)
			if ChargeTimeSlider then
				ChargeTimeSlider.Object.Visible = c and not SyncHits.Enabled
			end
		end
	})

	ChargeTimeSlider = SilentAura:CreateSlider({
		Name = 'Charge Time Value', 
		Min = 0.1, 
		Max = 1, 
		Default = 0.38, 
		Decimal = 100,
		Suffix = 's',
		Tooltip = 'Time between attacks when Sync Hits is OFF',
		Visible = true
	})

	Mouse = SilentAura:CreateToggle({Name = "Require Mouse down"})
	Swing = SilentAura:CreateToggle({ Name = "Swing Only", Tooltip = "Only swings visually, doesn't attack" })
	Limit = SilentAura:CreateToggle({Name = "Limit to items"})

	Angle = SilentAura:CreateSlider({ 
		Name = 'Max Angle', 
		Min = 60,
		Max = 360,
		Default = 145 
	})

	ExtendAttackRange = SilentAura:CreateSlider({ 
		Name = 'Extend Attack Range', 
		Min = 0, 
		Max = 8, 
		Default = 1.4, 
		Decimal = 100
	})

	ExtendSwingRange = SilentAura:CreateSlider({ 
		Name = 'Extend Swing Range', 
		Min = 0, 
		Max = 12, 
		Default = 3.2,
		Decimal = 100
	})

	UpdateRate = SilentAura:CreateSlider({ 
		Name = 'Update Rate', 
		Suffix = 'hz', 
		Min = 15, 
		Max = 90, 
		Default = 45 
	})

	task.defer(function()
		if AimSpeed then AimSpeed.Object.Visible = SilentAim.Enabled end
		if AimSmoothness then AimSmoothness.Object.Visible = SilentAim.Enabled end
		if AimShake then AimShake.Object.Visible = SilentAim.Enabled end
		if ChargeTime and SyncHits then
			ChargeTime.Object.Visible = not SyncHits.Enabled
			if ChargeTimeSlider then
				ChargeTimeSlider.Object.Visible = not SyncHits.Enabled and ChargeTime.Enabled
			end
		end
	end)

end)

--[[task.spawn(function()
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
end) --]]