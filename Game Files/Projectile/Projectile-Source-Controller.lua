-- https://lua.expert/
local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@easy-games", "game-core", "out")
local DeviceUtil = v1.DeviceUtil
local MobileButton = v1.MobileButton
local MobileTouchType = v1.MobileTouchType
local PressMode = v1.PressMode
local RandomUtil = v1.RandomUtil
local SoundManager = v1.SoundManager
local KnitClient = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@easy-games", "knit", "src").KnitClient
local SyncEventPriority = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@easy-games", "sync-event", "out").SyncEventPriority
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "roact", "src")
local v4 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ContextActionService = v4.ContextActionService
local HttpService = v4.HttpService
local Players = v4.Players
local RunService = v4.RunService
local UserInputService = v4.UserInputService
local Workspace = v4.Workspace
local ClientSyncEvents = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent.Parent, "client-sync-events").ClientSyncEvents
local HandKnitController = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent.Parent, "lib", "knit", "hand-knit-controller").HandKnitController
local ClientStore = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent.Parent, "ui", "store").ClientStore
local GameAnimationUtil = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "animation", "animation-util").GameAnimationUtil
local EntityUtil = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "entity", "entity-util").EntityUtil
local FrostyStaffUtil = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "games", "bedwars", "kit", "kits", "frosty-gun", "frosty-gun-util").FrostyStaffUtil
local GrapplingHookFunctions = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "grappling-hook", "grappling-hook-util").GrapplingHookFunctions
local BedwarsImageId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "image", "image-id").BedwarsImageId
local InventoryUtil = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "inventory", "inventory-util").InventoryUtil
local getItemMeta = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "item", "item-meta").getItemMeta
local ProjectileMeta = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "projectile", "projectile-meta").ProjectileMeta
local Setting = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "settings", "settings-types").Setting
local SharedSyncEvents = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "shared-sync-events").SharedSyncEvents
local StatusEffectUtil = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "status-effect", "status-effect-util").StatusEffectUtil
local Theme = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "theme", "theme").Theme
local ProjectileController = RuntimeLib.import(script, script.Parent, "projectile-controller").ProjectileController
local v5 = setmetatable({}, {
	__tostring = function() --[[ __tostring | Line: 42 ]]
		return "ProjectileSourceController"
	end,
	__index = HandKnitController
})
v5.__index = v5
function v5.constructor(p1, ...) --[[ constructor | Line: 48 | Upvalues: HandKnitController (copy), v2 (copy) ]]
	HandKnitController.constructor(p1, ...)
	p1.maid = v2.new()
	p1.uiMaid = v2.new()
	p1.aimingMaid = v2.new()
	p1.reloadingWeaponSet = {}
end
function v5.KnitStart(p1) --[[ KnitStart | Line: 55 | Upvalues: HandKnitController (copy), ClientSyncEvents (copy), SyncEventPriority (copy), EntityUtil (copy), StatusEffectUtil (copy), SoundManager (copy), Theme (copy) ]]
	HandKnitController.KnitStart(p1)
	ClientSyncEvents.StartLaunchProjectile:setPriority(SyncEventPriority.HIGH):connect(function(p1) --[[ Line: 57 | Upvalues: EntityUtil (ref), StatusEffectUtil (ref), SoundManager (ref), Theme (ref) ]]
		if p1:isCancelled() then
			return nil
		end
		local v1 = EntityUtil:getLocalPlayerEntity()
		if not v1 then
			return nil
		end
		if not p1.projectileSource.blockingStatusEffects then
			return nil
		end
		if not StatusEffectUtil:hasAnyActive(v1:getInstance(), p1.projectileSource.blockingStatusEffects) then
			return
		end
		SoundManager:playSound(Theme.sound.uiDisabled)
		p1:setCancelled(true)
	end)
end
function v5.onEnable(p1, p2, p3) --[[ onEnable | Line: 74 | Upvalues: getItemMeta (copy), GameAnimationUtil (copy), Players (copy), ClientSyncEvents (copy), Setting (copy), Flamework (copy), HttpService (copy), SharedSyncEvents (copy), RunService (copy), MobileTouchType (copy), UserInputService (copy), ContextActionService (copy), KnitClient (copy) ]]
	p1.maid:DoCleaning()
	local projectileSource = getItemMeta(p2.itemType).projectileSource
	if projectileSource ~= nil then
		projectileSource = projectileSource.thirdPerson
		if projectileSource ~= nil then
			projectileSource = projectileSource.idleAnimation
		end
	end
	local v1 = projectileSource
	if v1 ~= 0 and (v1 == v1 and v1) then
		p1:setupYield(function() --[[ Line: 86 | Upvalues: GameAnimationUtil (ref), Players (ref), v1 (copy), p1 (copy) ]]
			local v12 = GameAnimationUtil:playAnimation(Players.LocalPlayer, v1)
			p1.maid:GiveTask(function() --[[ Line: 88 | Upvalues: v12 (copy) ]]
				local v1 = v12
				if v1 == nil then
					return
				end
				v1:Stop()
			end)
			return function() --[[ Line: 94 | Upvalues: v12 (copy) ]]
				if not v12 then
					return
				end
				v12:Stop()
			end
		end)
	end
	p1.maid:GiveTask(ClientSyncEvents.SettingChanged:connect(function(p12) --[[ Line: 101 | Upvalues: Setting (ref), p1 (copy), p3 (copy) ]]
		if p12.setting ~= Setting.MOBILE_PROJECTILE_BUTTON then
			return nil
		end
		if not p1:isEnabled() then
			return nil
		end
		if p12.value == true then
			p1:displayMobileButton(p3)
		else
			p1.uiMaid:DoCleaning()
		end
	end))
	local v2 = p1:getProjectileSource(p2)
	local v3 = p1:getCooldownId(v2, p2.itemType)
	if p1.reloadingWeaponSet[p2.itemType] ~= nil then
		local cooldown = ClientSyncEvents.ItemCooldownModifierCheck:fire(v2.fireDelaySec).cooldown
		local v4 = Flamework.resolveDependency("@easy-games/game-core:client/controllers/cooldown/cooldown-controller@CooldownController")
		local t = {}
		local v5, v6
		if v2.cooldownBar then
			local t2 = {}
			local cooldownBar = v2.cooldownBar
			if cooldownBar ~= nil then
				cooldownBar = cooldownBar.colorGradient
			end
			t2.colorGradient = cooldownBar
			local cooldownBar_2 = v2.cooldownBar
			if cooldownBar_2 ~= nil then
				cooldownBar_2 = cooldownBar_2.title
			end
			t2.title = cooldownBar_2
			v5 = t2
			v6 = cooldown
		else
			v5 = nil
			v6 = cooldown
		end
		t.cooldownBar = v5
		v4:setOnCooldown(v3, v6, t)
		task.spawn(function() --[[ Line: 149 | Upvalues: p1 (copy), p3 (copy) ]]
			p1:onStartReload(p3)
		end)
	end
	local v7 = "projectile-source-" .. HttpService:GenerateGUID(false)
	p1.maid:GiveTask(p1.aimingMaid)
	local v8 = nil
	SharedSyncEvents.HookFunctionSwapEvent:connect(function(p12) --[[ Line: 156 | Upvalues: p1 (copy) ]]
		p1.hookStatus = p12.hookFunction
	end)
	p1:displayMobileButton(p3)
	local v9 = Flamework.resolveDependency("@easy-games/game-core:client/controllers/keybind/action-binder-controller@ActionBinderController"):bindAction({
		action = "Attack",
		actionId = v7,
		boundFunction = function(p12, p22, p32) --[[ boundFunction | Line: 163 | Upvalues: p1 (copy), v8 (ref), p3 (copy), RunService (ref), p2 (copy), Flamework (ref), v3 (copy) ]]
			if p22 == Enum.UserInputState.Begin then
				if p1.projectileHandler then
					return nil
				end
				if not p1:canLaunch() then
					return nil
				end
				if p32.UserInputType == Enum.UserInputType.Touch then
					v8 = p32
				end
				local function f1() --[[ Line: 174 | Upvalues: p1 (ref), p3 (ref), p32 (copy), RunService (ref), p2 (ref) ]]
					if p1.projectileHandler then
						return nil
					end
					if not p3() then
						return nil
					end
					if not p1:canLaunch() then
						return nil
					end
					if p32.UserInputState == Enum.UserInputState.End or p32.UserInputState == Enum.UserInputState.Cancel then
						return nil
					end
					if p32.UserInputType == Enum.UserInputType.Touch then
						local v1 = 0
						RunService:BindToRenderStep("projectile-mobile-confirm", 250, function(p12) --[[ Line: 190 | Upvalues: v1 (ref), p1 (ref), RunService (ref), p2 (ref), p32 (ref) ]]
							v1 = v1 + p12
							if not (v1 >= 0.3) then
								return
							end
							if p1.projectileHandler then
								return nil
							end
							RunService:UnbindFromRenderStep("projectile-mobile-confirm")
							p1:beginHolding(p2, p32, p1.aimingMaid, false)
						end)
						return nil
					else
						p1:beginHolding(p2, nil, p1.aimingMaid, false)
					end
				end
				if Flamework.resolveDependency("@easy-games/game-core:client/controllers/cooldown/cooldown-controller@CooldownController"):isOnCooldown(v3) then
					Flamework.resolveDependency("@easy-games/game-core:client/controllers/cooldown/cooldown-controller@CooldownController"):registerBufferedCallback(v3, "callback", function() --[[ Line: 205 | Upvalues: f1 (copy) ]]
						f1()
					end)
					return nil
				end
				f1()
			else
				if p22 ~= Enum.UserInputState.End then
					return Enum.ContextActionResult.Pass
				end
				if v8 and p32 ~= v8 then
					return nil
				end
				v8 = nil
				p1:releaseChargeInput(p1.aimingMaid, p3, p32)
			end
			return Enum.ContextActionResult.Pass
		end,
		mobile = {
			touchType = MobileTouchType.TouchBeginEnd
		},
		priority = Enum.ContextActionPriority.Medium.Value
	})
	p1.maid:GiveTask(v9)
	p1.maid:GiveTask(UserInputService.TouchMoved:Connect(function(p1, p2) --[[ Line: 226 | Upvalues: v8 (ref), Players (ref), RunService (ref) ]]
		if p1 ~= v8 then
			return nil
		end
		local Character = Players.LocalPlayer.Character
		if Character ~= nil then
			local v1 = Character:FindFirstChildWhichIsA("Humanoid")
			Character = if v1 == nil then v1 else v1.MoveDirection
		end
		if Character == nil or Character == Vector3.new() then
			return
		end
		pcall(function() --[[ Line: 239 | Upvalues: RunService (ref) ]]
			return RunService:UnbindFromRenderStep("projectile-mobile-confirm")
		end)
	end))
	p1.maid:GiveTask(function() --[[ Line: 244 | Upvalues: ContextActionService (ref), v7 (copy), KnitClient (ref), p1 (copy), RunService (ref), v8 (ref) ]]
		ContextActionService:UnbindAction(v7)
		KnitClient.Controllers.ProjectileController:disableTargeting()
		p1.projectileHandler = nil
		pcall(function() --[[ Line: 248 | Upvalues: RunService (ref) ]]
			return RunService:UnbindFromRenderStep("projectile-mobile-confirm")
		end)
		v8 = nil
	end)
end
function v5.beginHolding(p1, p2, p3, p4, p5) --[[ beginHolding | Line: 254 | Upvalues: getItemMeta (copy), ClientSyncEvents (copy), GrapplingHookFunctions (copy), InventoryUtil (copy), Players (copy), EntityUtil (copy), ProjectileMeta (copy), KnitClient (copy), SoundManager (copy), RandomUtil (copy), ProjectileController (copy), Workspace (copy), DeviceUtil (copy), RuntimeLib (copy), RunService (copy) ]]
	local v1 = getItemMeta(p2.itemType)
	local projectileSource = v1.projectileSource
	if projectileSource ~= nil then
		projectileSource = projectileSource.ammoItemTypes
	end
	if if projectileSource then not p1:getAmmoType(p2.itemType) else projectileSource then
		return false
	end
	if ClientSyncEvents.BeginProjectileTargeting:fire(p2, p3):isCancelled() then
		return false
	end
	local v3 = p1:getProjectileSource(p2)
	local v4 = p1:getAmmoType(p2.itemType)
	if v3.waitForHit and p1.hookStatus ~= GrapplingHookFunctions.HOOK_CHAMBERED then
		return false
	end
	local projectileSource_2 = v1.projectileSource
	if projectileSource_2 ~= nil then
		projectileSource_2 = projectileSource_2.ammoItemTypes
	end
	if (if projectileSource_2 == nil then false else true) or (if v4 == nil then false else true) then
		if v4 == nil then
			return false
		end
		if not InventoryUtil.hasEnough(Players.LocalPlayer, v4, 1) then
			return false
		end
	end
	local Character = Players.LocalPlayer.Character
	if Character ~= nil then
		Character = Character.PrimaryPart
	end
	if not Character then
		return true
	end
	if not EntityUtil:getEntity(Players.LocalPlayer) then
		return false
	end
	p1:onStartCharging()
	p4:GiveTask(function() --[[ Line: 304 | Upvalues: p1 (copy) ]]
		return p1:onStopCharging()
	end)
	local walkSpeedMultiplier = v3.walkSpeedMultiplier
	if walkSpeedMultiplier ~= 0 and (walkSpeedMultiplier == walkSpeedMultiplier and walkSpeedMultiplier) then
		local v6 = ProjectileMeta[v3.projectileType(v4)]
		local v7 = if v6 == nil then v6 else v6.getProjectileOverridesFunction
		local v8 = if v7 then v6.getProjectileOverridesFunction(Players.LocalPlayer) else nil
		local v9 = if v8 then v8.walkSpeedMultiplierOverride else v8
		if v9 == 0 or (v9 ~= v9 or not v9) then
			p4:GiveTask(KnitClient.Controllers.SprintController:getMovementStatusModifier():addModifier({
				blockSprint = true,
				moveSpeedMultiplier = v3.walkSpeedMultiplier
			}))
		else
			p4:GiveTask(KnitClient.Controllers.SprintController:getMovementStatusModifier():addModifier({
				moveSpeedMultiplier = v8.walkSpeedMultiplierOverride,
				blockSprint = v8.walkSpeedMultiplierOverride ~= 1
			}))
		end
	end
	if v3.chargeBeginSound then
		local v11 = SoundManager:playSound(RandomUtil.fromList(unpack(v3.chargeBeginSound)))
		if v11 then
			p4:GiveTask(v11)
		end
	end
	local v13 = v3.projectileType(v4)
	local t = {}
	local minStrengthScalar = v3.minStrengthScalar
	if minStrengthScalar == nil then
		minStrengthScalar = 1
	end
	t.initialVelocityMultiplier = minStrengthScalar
	local v14
	if p5 then
		local CurrentCamera = Workspace.CurrentCamera
		if CurrentCamera ~= nil then
			CurrentCamera = CurrentCamera.ViewportSize / 2 - Vector2.new(0, game:GetService("GuiService"):GetGuiInset().Y / 2)
		end
		v14 = CurrentCamera
	else
		v14 = nil
	end
	t.lockedAimPoint = v14
	local sword = v1.sword
	if sword ~= nil then
		sword = sword.chargedAttack
	end
	t.displayBeamDelay = if sword then 0.25 else nil
	local v16 = ProjectileController:enableTargeting(p2.itemType, v13, v3, p3, t)
	p1.projectileHandler = v16
	p1.projectileHandler.projectileSourceController = p1
	p1.projectileHandler.player = Players.LocalPlayer
	local sword_2 = v1.sword
	if sword_2 ~= nil then
		sword_2 = sword_2.chargedAttack
	end
	if sword_2 then
		if DeviceUtil.isMobileControls() then
			KnitClient.Controllers.SwordChargeController:startCharging(p2.itemType)
		end
		task.delay(0.25, function() --[[ Line: 382 | Upvalues: KnitClient (ref), p2 (copy) ]]
			if KnitClient.Controllers.SwordChargeController:isWeaponCharging(p2.itemType) then
				return
			end
			KnitClient.Controllers.ProjectileController:disableTargeting()
		end)
	end
	local maxStrengthChargeSec = v3.maxStrengthChargeSec
	if maxStrengthChargeSec == 0 or (maxStrengthChargeSec ~= maxStrengthChargeSec or not maxStrengthChargeSec) then
		p1:onMaxCharge()
	else
		local maxChargeTime = ClientSyncEvents.ProjectileMaxChargeTimeModifierCheck:fire(v3.maxStrengthChargeSec).maxChargeTime
		local v17 = true
		p1.maid:GiveTask(function() --[[ Line: 393 | Upvalues: v17 (ref) ]]
			v17 = false
		end)
		RuntimeLib.Promise.defer(function() --[[ Line: 396 | Upvalues: v16 (copy), v17 (ref), p1 (copy), RunService (ref), maxChargeTime (ref), v3 (copy), ClientSyncEvents (ref), p2 (copy) ]]
			v16.drawDurationSeconds = 0
			local v1 = false
			while v17 and v16 == p1.projectileHandler do
				local v2 = v16
				v2.drawDurationSeconds = v2.drawDurationSeconds + RunService.RenderStepped:Wait()
				local v4 = math.min(1, v16.drawDurationSeconds / maxChargeTime)
				local minStrengthScalar = v3.minStrengthScalar
				if minStrengthScalar == nil then
					minStrengthScalar = 0.5
				end
				v16.velocityMultiplier = v4 + (1 - v4) * minStrengthScalar
				if not v1 and v4 >= 1 then
					ClientSyncEvents.ProjectileMaxCharged:fire(p2.itemType)
					p1:onMaxCharge()
					v1 = true
				end
			end
		end)
	end
	return true
end
function v5.releaseChargeInput(p1, p2, p3, p4) --[[ releaseChargeInput | Line: 421 | Upvalues: RunService (copy), ClientSyncEvents (copy), getItemMeta (copy), DeviceUtil (copy), KnitClient (copy), Flamework (copy), SoundManager (copy), RandomUtil (copy) ]]
	if not p1:canLaunch() then
		return nil
	end
	if p1.bufferPromise then
		p1.bufferPromise:cancel()
		p1.bufferPromise = nil
	end
	pcall(function() --[[ Line: 429 | Upvalues: RunService (ref) ]]
		return RunService:UnbindFromRenderStep("projectile-mobile-confirm")
	end)
	p2:DoCleaning()
	if p1.projectileHandler then
		local v1 = p1:getHandItem()
		local v2 = p1:getProjectileSource(v1)
		local v3 = p1:getAmmoType(v1.itemType)
		if p1:onLaunch(p3) == false then
			return nil
		end
		if not p3() then
			return nil
		end
		if ClientSyncEvents.ProjectileTargetingEnded:fire(v1, p4):isCancelled() then
			return false
		end
		local v4 = getItemMeta(v1.itemType)
		local sword = v4.sword
		if sword ~= nil then
			sword = sword.chargedAttack
		end
		if sword and DeviceUtil.isMobileControls() then
			KnitClient.Controllers.SwordChargeController:stopCharging(v1.itemType)
		end
		local sword_2 = v4.sword
		if sword_2 ~= nil then
			sword_2 = sword_2.chargedAttack
		end
		if if sword_2 then v4.projectileSource else sword_2 then
			KnitClient.Controllers.ProjectileController:disableTargeting()
			return nil
		end
		KnitClient.Controllers.ProjectileController:launchProjectile(v1.itemType, v3, p1.projectileHandler, v1.tool, v2)
		local cooldown = ClientSyncEvents.ProjectileCooldownModifierCheck:fire(v2.fireDelaySec).cooldown
		local v6 = p1:getProjectileOverrides()
		if v6 then
			local cooldownOverride = v6.cooldownOverride
			if cooldownOverride ~= 0 and (cooldownOverride == cooldownOverride and cooldownOverride) then
				cooldown = v6.cooldownOverride
			end
		end
		local v7 = p1:getCooldownId(v2, v1.itemType)
		local v8 = Flamework.resolveDependency("@easy-games/game-core:client/controllers/cooldown/cooldown-controller@CooldownController")
		local t = {}
		local v9, v10
		if v2.cooldownBar then
			local t2 = {}
			local cooldownBar = v2.cooldownBar
			if cooldownBar ~= nil then
				cooldownBar = cooldownBar.colorGradient
			end
			t2.colorGradient = cooldownBar
			local cooldownBar_2 = v2.cooldownBar
			if cooldownBar_2 ~= nil then
				cooldownBar_2 = cooldownBar_2.title
			end
			t2.title = cooldownBar_2
			v9 = t2
			v10 = cooldown
		else
			v9 = nil
			v10 = cooldown
		end
		t.cooldownBar = v9
		v8:setOnCooldown(v7, v10, t)
		Flamework.resolveDependency("@easy-games/game-core:client/controllers/cooldown/cooldown-controller@CooldownController"):registerBufferedCallback(v7, "reloading_clear", function() --[[ Line: 507 | Upvalues: p1 (copy), v1 (copy) ]]
			p1.reloadingWeaponSet[v1.itemType] = nil
		end)
		if v2.activeReload == true then
			p1.reloadingWeaponSet[v1.itemType] = true
		end
		task.spawn(function() --[[ Line: 517 | Upvalues: p1 (copy), p3 (copy) ]]
			p1:onStartReload(p3)
		end)
		local reload = v2.reload
		if reload ~= nil then
			reload = reload.reloadSound
		end
		if reload then
			local v11 = SoundManager:playSound(RandomUtil.fromList(unpack(reload)))
			if v11 then
				p1.maid:GiveTask(v11)
			end
		end
	end
	KnitClient.Controllers.ProjectileController:disableTargeting()
	p1.projectileHandler = nil
end
function v5.onDisable(p1) --[[ onDisable | Line: 535 ]]
	p1.maid:DoCleaning()
	p1.uiMaid:DoCleaning()
end
function v5.onMaxCharge(p1) --[[ onMaxCharge | Line: 539 ]] end
function v5.canLaunch(p1) --[[ canLaunch | Line: 541 ]]
	return true
end
function v5.getProjectileSource(p1, p2) --[[ getProjectileSource | Line: 544 | Upvalues: getItemMeta (copy) ]]
	return getItemMeta(p2.itemType).projectileSource
end
function v5.getAmmoType(p1, p2) --[[ getAmmoType | Line: 547 | Upvalues: getItemMeta (copy), ClientStore (copy) ]]
	local projectileSource = getItemMeta(p2).projectileSource
	if projectileSource ~= nil then
		projectileSource = projectileSource.ammoItemTypes
	end
	if not projectileSource then
		return nil
	end
	local hotbar = ClientStore:getState().Inventory.observedInventory.hotbar
	for v2, v3 in projectileSource do
		local v4 = nil
		for v5, v6 in hotbar do
			local item = v6.item
			if item ~= nil then
				item = item.itemType
			end
			if (if item == v3 then true else false) == true then
				v4 = v6
				break
			end
		end
		if v4 then
			return v3
		end
	end
	local inventory = ClientStore:getState().Inventory.observedInventory.inventory
	for v8, v9 in projectileSource do
		local v10 = nil
		for v11, v12 in inventory.items do
			if v12.itemType == v9 == true then
				v10 = v12
				break
			end
		end
		if v10 then
			return v9
		end
	end
	return nil
end
function v5.displayMobileButton(p1, p2) --[[ displayMobileButton | Line: 604 | Upvalues: KnitClient (copy), Setting (copy), DeviceUtil (copy), v2 (copy), v3 (copy), MobileButton (copy), BedwarsImageId (copy), Flamework (copy), PressMode (copy), FrostyStaffUtil (copy), RunService (copy), Players (copy) ]]
	local v1 = p1:getHandItem()
	if not v1 then
		return nil
	end
	local v22 = p1:getCooldownId(p1:getProjectileSource(v1), v1.itemType)
	if not (KnitClient.Controllers.SettingsController:getSetting(Setting.MOBILE_PROJECTILE_BUTTON) and DeviceUtil.isMobileControls()) then
		return
	end
	p1:setupYield(function() --[[ Line: 613 | Upvalues: KnitClient (ref), v2 (ref), v3 (ref), MobileButton (ref), BedwarsImageId (ref), Flamework (ref), PressMode (ref), p1 (copy), p2 (copy), FrostyStaffUtil (ref), v1 (copy), RunService (ref), Players (ref), v22 (copy) ]]
		KnitClient.Controllers.MobileLayoutLoadController:onMobileLayoutLoaded():await()
		local v12 = v2.new()
		local v23 = v3.mount(v3.createElement("ScreenGui", {
			ResetOnSpawn = false
		}, { v3.createElement(MobileButton, {
				Image = BedwarsImageId.BOW_MOBILE,
				Position = Flamework.resolveDependency("@easy-games/game-core:client/controllers/mobile-layout/mobile-layout-controller@MobileLayoutController"):getMobileButtonPosition("FireProjectile"),
				Size = Flamework.resolveDependency("@easy-games/game-core:client/controllers/mobile-layout/mobile-layout-controller@MobileLayoutController"):getMobileButtonSize("FireProjectile"),
				PressMode = PressMode.FREE_MOVING_HOLD,
				OnPressDown = function() --[[ OnPressDown | Line: 624 | Upvalues: p1 (ref), p2 (ref), FrostyStaffUtil (ref), v1 (ref), KnitClient (ref), v12 (copy), RunService (ref), Players (ref), Flamework (ref), v22 (ref) ]]
					if p1.projectileHandler then
						return nil
					end
					local function f1() --[[ Line: 628 | Upvalues: p1 (ref), p2 (ref), FrostyStaffUtil (ref), v1 (ref), KnitClient (ref), v12 (ref), RunService (ref), Players (ref) ]]
						if p1.projectileHandler then
							return nil
						end
						if not p2() then
							return nil
						end
						if not p1:canLaunch() then
							return nil
						end
						if FrostyStaffUtil:isFrostyStaff(v1.itemType) and KnitClient.Controllers.FrostyGunController:canSpray() then
							KnitClient.Controllers.FrostyGunController:beginSprayHolding(true)
						end
						if p1:beginHolding(v1, nil, p1.aimingMaid, true) then
							v12:DoCleaning()
							local v13 = 0
							v12:GiveTask(RunService.RenderStepped:Connect(function(p1) --[[ Line: 648 | Upvalues: v13 (ref), Players (ref) ]]
								v13 = v13 + p1
								local v2 = math.clamp(v13 * 3, 0, 0.8)
								local Character = Players.LocalPlayer.Character
								if Character == nil then
									return
								end
								for v3, v4 in Character:GetDescendants() do
									if v4:IsA("BasePart") then
										v4.LocalTransparencyModifier = math.max(v4.LocalTransparencyModifier, v2)
									end
								end
							end))
						else
							return nil
						end
					end
					if Flamework.resolveDependency("@easy-games/game-core:client/controllers/cooldown/cooldown-controller@CooldownController"):isOnCooldown(v22) then
						Flamework.resolveDependency("@easy-games/game-core:client/controllers/cooldown/cooldown-controller@CooldownController"):registerBufferedCallback(v22, "callback", function() --[[ Line: 666 | Upvalues: f1 (copy) ]]
							f1()
						end)
						return nil
					else
						f1()
					end
				end,
				OnPressUp = function(p12) --[[ OnPressUp | Line: 673 | Upvalues: v12 (copy), Players (ref), p1 (ref), p2 (ref) ]]
					v12:DoCleaning()
					local Character = Players.LocalPlayer.Character
					if Character ~= nil then
						for v1, v2 in Character:GetDescendants() do
							if v2:IsA("BasePart") then
								v2.LocalTransparencyModifier = 0
							end
						end
					end
					p1:releaseChargeInput(p1.aimingMaid, p2, p12)
				end
			}) }), Players.LocalPlayer:WaitForChild("PlayerGui"))
		p1.uiMaid:GiveTask(function() --[[ Line: 691 | Upvalues: v3 (ref), v23 (copy) ]]
			v3.unmount(v23)
		end)
		return function() --[[ Line: 694 | Upvalues: v12 (copy), p1 (ref) ]]
			v12:DoCleaning()
			p1.uiMaid:DoCleaning()
		end
	end)
end
function v5.getProjectileHandler(p1) --[[ getProjectileHandler | Line: 701 ]]
	return p1.projectileHandler
end
function v5.clearProjectileHandler(p1) --[[ clearProjectileHandler | Line: 704 | Upvalues: KnitClient (copy) ]]
	KnitClient.Controllers.ProjectileController:disableTargeting()
	p1.projectileHandler = nil
end
function v5.getCooldownId(p1, p2, p3) --[[ getCooldownId | Line: 708 ]]
	return p2.cooldownId or p3 .. "-proj-source"
end
function v5.getProjectileOverrides(p1) --[[ getProjectileOverrides | Line: 711 ]]
	return {}
end
return {
	ProjectileSourceController = v5
}
