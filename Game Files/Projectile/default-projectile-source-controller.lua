-- https://lua.expert/
local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local KnitClient = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@easy-games", "knit", "src").KnitClient
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local TripleShotUtil = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "games", "bedwars", "items", "triple-shot", "triple-shot-util").TripleShotUtil
local WizardUtil = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "games", "bedwars", "kit", "kits", "wizard", "wizard-util").WizardUtil
local getItemMeta = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "item", "item-meta").getItemMeta
local ItemType = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "item", "item-type").ItemType
local ProjectileSourceController = RuntimeLib.import(script, script.Parent, "projectile-source-controller").ProjectileSourceController
local v1 = setmetatable({}, {
	__tostring = function() --[[ __tostring | Line: 15 ]]
		return "DefaultProjectileSourceController"
	end,
	__index = ProjectileSourceController
})
v1.__index = v1
function v1.new(...) --[[ new | Line: 21 | Upvalues: v1 (copy) ]]
	local v2 = setmetatable({}, v1)
	return v2:constructor(...) or v2
end
function v1.constructor(p1, ...) --[[ constructor | Line: 25 | Upvalues: ProjectileSourceController (copy) ]]
	ProjectileSourceController.constructor(p1, ...)
	p1.Name = "DefaultProjectileSourceController"
end
function v1.isRelevantItem(p1, p2) --[[ isRelevantItem | Line: 29 | Upvalues: ItemType (copy), WizardUtil (copy), TripleShotUtil (copy), Players (copy), getItemMeta (copy) ]]
	if p2.itemType == ItemType.LASSO then
		return false
	end
	if p2.itemType == ItemType.BLUNDERBUSS then
		return false
	end
	if WizardUtil:isWizardStaff(p2.itemType) then
		return false
	end
	if p2.itemType == ItemType.FISHING_ROD then
		return false
	end
	if p2.itemType == ItemType.VACUUM then
		return false
	end
	if p2.itemType == ItemType.FEATHER_BOW then
		return false
	end
	if TripleShotUtil.isTripleShot(p2.itemType, Players.LocalPlayer) then
		return false
	end
	if p2.itemType == ItemType.SPEAR or (p2.itemType == ItemType.SAND_SPEAR or p2.itemType == ItemType.HARPOON) then
		return false
	end
	local v1 = getItemMeta(p2.itemType)
	if v1.projectileSource == nil then
		return false
	else
		return not v1.projectileSource.multiShot
	end
end
function v1.onStartCharging(p1) --[[ onStartCharging | Line: 74 ]] end
function v1.onStopCharging(p1) --[[ onStopCharging | Line: 76 ]] end
function v1.onMaxCharge(p1) --[[ onMaxCharge | Line: 78 ]] end
function v1.onLaunch(p1) --[[ onLaunch | Line: 80 ]] end
function v1.onStartReload(p1) --[[ onStartReload | Line: 82 ]] end
return {
	DefaultProjectileSourceController = KnitClient.CreateController(v1.new())
}
