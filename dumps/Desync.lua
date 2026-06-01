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
local Desync

local hooktypes = {
	rakhook1 = false,
	rakhook2 = false,
	fflag = false
}

local rakNet = typeof(raknet) == "table"

local function rakhook(pckt)
	if not pckt then return end
	if pckt.PacketId == 0x1B or (pckt.AsArray and pckt.AsArray[1] == 0x1B) then
		local success, err = pcall(function()
			local buf = pckt.AsBuffer or buffer.create(100)
			buffer.writeu32(buf, 1, 0xFFFFFFFF)
			pckt:SetData(buf)
		end)
		if not success then
			warn("[Desync] Hook error:", err)
		end
	end
end

local function rakHookk(pckt)
	if not pckt then return end
	if pckt.PacketId == 0x1B then
		local success, err = pcall(function()
			local buf = pckt.AsBuffer
			if buf then
				buffer.writeu32(buf, 1, 0xFFFFFFFF)
				pckt:SetData(buf)
			end
		end)
		if not success then
			warn("[Desync] Hook2 error:", err)
		end
	end
end

local old = 0

Desync = vape.Categories.Blatant:CreateModule({
	Name = "Desync",
	Tooltip = "Uses various methods to desync your position",
	Function = function(callback)
		if callback then
			old = tick()

			if rakNet then
				vape:CreateNotification("Vape", "RakNet founded! Attempting to use server-sided desync...", 8)

				local suc1 = pcall(function()
					return raknet.add_send_hook(rakhook)
				end)

				if suc1 then
					hooktypes.rakhook1 = true
					vape:CreateNotification("Vape", "Desync, raknet Hook applied successfully", 6)
					return
				end

				task.wait(0.5)
				local suc2 = pcall(function()
					return raknet.add_send_hook(rakHookk)
				end)

				if suc2 then
					hooktypes.rakhook2 = true
					vape:CreateNotification("Vape", "Desync, raknet Second Hook applied successfully", 6)
					return
				end

				vape:CreateNotification("Vape", "Both raknet hooks failed. Falling back to fflag...", 8, "warning")
			else
				vape:CreateNotification("Vape", "raknet not supported? Using fflag method.", 8)
			end

			local fflagSuccess = pcall(function()
				return setfflag("NextGenReplicatorEnabledWrite4", "true")
			end)

			if fflagSuccess then
				hooktypes.fflag = true
				vape:CreateNotification("Vape", "Desync, fflag enabled", 6)
			else
				vape:CreateNotification("Vape", "All desync methods failed. Disabling module...", 8, "alert")
				task.delay(1.5, function()
					Desync:Toggle(false)
				end)
			end

		else
			if rakNet then
				if hooktypes.rakhook1 then
					pcall(function() raknet.remove_send_hook(rakhook) end)
				elseif hooktypes.rakhook2 then
					pcall(function() raknet.remove_send_hook(rakHookk) end)
				end
			end
			if hooktypes.fflag then
				pcall(function()
					setfflag("NextGenReplicatorEnabledWrite4", "false")
				end)
			end
			hooktypes.rakhook1 = false
			hooktypes.rakhook2 = false
			hooktypes.fflag = false
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
end) --]]