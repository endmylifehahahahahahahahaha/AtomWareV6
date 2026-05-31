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
local runService = game:GetService('RunService')
local KrystalDisabler
local old = nil
local renderConn = nil
local bedwarsCtrl = nil
local store = getgenv().store or {}

local function setup()
	local ok, Knit = pcall(function()
		return require(game.ReplicatedStorage.rbxts_include.node_modules['@easy-games'].knit.src).KnitClient
	end)
	if not ok or not Knit.Controllers.GlacialSkaterController then return false end
	if store.equippedKit ~= 'glacial_skater' then return false end
	local Client = require(game.ReplicatedStorage.TS.remotes).default.Client
	bedwarsCtrl = { GlacialSkaterController = Knit.Controllers.GlacialSkaterController }
	old = bedwarsCtrl.GlacialSkaterController.updateMomentum
	bedwarsCtrl.GlacialSkaterController.updateMomentum = function(self, ...)
		self.momentum = 9e9
		self.lastMomentumReport = 9e9
		pcall(function()
			Client:Get('MomentumUpdate'):SendToServer({ momentumValue = 9e9 })
		end)
	end
	return true
end

KrystalDisabler = vape.Categories.Blatant:CreateModule({
	Name = 'KrystalDisabler',
	Tooltip = 'Requires Krystal kit.',
	Function = function(callback)
		if callback then
			local ok = setup()
			if not ok then
				vape:CreateNotification("KrystalDisabler", "Not on Krystal kit!", 5, 'alert')
				KrystalDisabler:Toggle()
				return
			end
			renderConn = runService.RenderStepped:Connect(function()
				if not bedwarsCtrl then return end
				pcall(function()
					bedwarsCtrl.GlacialSkaterController:updateMomentum(9e9, 'newValue')
				end)
			end)
			vape:CreateNotification("KrystalDisabler", "Reset to use disabler", 5)
		else
			if renderConn then
				renderConn:Disconnect()
				renderConn = nil
			end
			if bedwarsCtrl and old then
				bedwarsCtrl.GlacialSkaterController.updateMomentum = old
				old = nil
			end
			bedwarsCtrl = nil
		end
	end
})

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
end)    --]]    