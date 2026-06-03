--[[local oldtoclipboard = getgenv().toclipboard
-- Anti-skid protection removed for performance
--]]

-- ═══════════════════════════════════════════════════════════════
-- DESYNC - ULTRA STABLE VERSION WITH COMPREHENSIVE ERROR HANDLING
-- ═══════════════════════════════════════════════════════════════

local vape = shared.vape
local Desync

local hooktypes = {
	rakhook1 = false,
	rakhook2 = false,
	fflag = false
}

local rakNet = typeof(raknet) == "table"
local hookRef1 = nil
local hookRef2 = nil
local hookErrorCount = 0
local lastErrorTime = 0
local MAX_ERRORS_PER_SECOND = 10
local isShuttingDown = false

-- Comprehensive packet validation
local function isValidPacket(pckt)
	if not pckt then return false end
	
	-- Check if packet has required properties
	local hasId = pcall(function() return pckt.PacketId end)
	local hasArray = pcall(function() return pckt.AsArray end)
	local hasBuffer = pcall(function() return pckt.AsBuffer end)
	local hasSetData = pcall(function() return pckt.SetData end)
	
	return hasId or hasArray, hasBuffer, hasSetData
end

-- Ultra-safe hook with multiple layers of protection
local function rakhook(pckt)
	-- Shutdown check
	if isShuttingDown then return end
	
	-- Rate limiting for errors
	local now = tick()
	if now - lastErrorTime < 1 then
		if hookErrorCount > MAX_ERRORS_PER_SECOND then
			isShuttingDown = true
			warn("[Desync] Too many errors, auto-disabling for safety")
			task.spawn(function()
				if Desync and Desync.Enabled then
					Desync:Toggle(false)
				end
			end)
			return
		end
	else
		hookErrorCount = 0
		lastErrorTime = now
	end
	
	-- Validate packet
	local hasId, hasBuffer, hasSetData = isValidPacket(pckt)
	if not hasId then return end
	
	-- Protected packet processing
	local success, err = pcall(function()
		local packetId = pckt.PacketId or (pckt.AsArray and pckt.AsArray[1])
		
		if packetId == 0x1B then
			-- Validate buffer access
			if not hasBuffer then return end
			
			local buf = pckt.AsBuffer
			if not buf then
				-- Create buffer if missing
				buf = buffer.create(100)
			end
			
			-- Safe buffer write
			local writeSuccess = pcall(function()
				buffer.writeu32(buf, 1, 0xFFFFFFFF)
			end)
			
			if writeSuccess and hasSetData then
				pcall(function()
					pckt:SetData(buf)
				end)
			end
		end
	end)
	
	if not success then
		hookErrorCount = hookErrorCount + 1
	end
end

-- Alternative hook implementation
local function rakHookk(pckt)
	if isShuttingDown then return end
	
	local now = tick()
	if now - lastErrorTime < 1 and hookErrorCount > MAX_ERRORS_PER_SECOND then
		isShuttingDown = true
		task.spawn(function()
			if Desync and Desync.Enabled then
				Desync:Toggle(false)
			end
		end)
		return
	end
	
	local hasId, hasBuffer, hasSetData = isValidPacket(pckt)
	if not hasId then return end
	
	local success = pcall(function()
		if pckt.PacketId == 0x1B then
			local buf = pckt.AsBuffer
			if buf and hasSetData then
				pcall(function()
					buffer.writeu32(buf, 1, 0xFFFFFFFF)
					pckt:SetData(buf)
				end)
			end
		end
	end)
	
	if not success then
		hookErrorCount = hookErrorCount + 1
	end
end

-- Watchdog to monitor hook health
local watchdogConnection = nil
local function startWatchdog()
	if watchdogConnection then return end
	
	watchdogConnection = task.spawn(function()
		while Desync and Desync.Enabled and not isShuttingDown do
			task.wait(5)
			
			-- Check if we're getting too many errors
			if hookErrorCount > 50 then
				warn("[Desync] Unstable raknet detected, switching to fflag")
				
				-- Disable raknet hooks
				if rakNet then
					if hooktypes.rakhook1 and hookRef1 then
						pcall(function() raknet.remove_send_hook(hookRef1) end)
						hooktypes.rakhook1 = false
					end
					if hooktypes.rakhook2 and hookRef2 then
						pcall(function() raknet.remove_send_hook(hookRef2) end)
						hooktypes.rakhook2 = false
					end
				end
				
				-- Enable fflag
				pcall(function()
					setfflag("NextGenReplicatorEnabledWrite4", "true")
					hooktypes.fflag = true
					vape:CreateNotification("Desync", "Switched to stable fflag method", 5)
				end)
				
				hookErrorCount = 0
			end
		end
	end)
end

Desync = vape.Categories.Blatant:CreateModule({
	Name = "Desync",
	Tooltip = "Uses various methods to desync your position - Now with stability protection",
	Function = function(callback)
		if callback then
			isShuttingDown = false
			hookErrorCount = 0
			lastErrorTime = 0

			if rakNet then
				vape:CreateNotification("Vape", "RakNet detected! Using advanced desync with stability protection...", 8)

				-- Try first hook method with validation
				local suc1, err1 = pcall(function()
					hookRef1 = rakhook
					return raknet.add_send_hook(hookRef1)
				end)

				if suc1 then
					hooktypes.rakhook1 = true
					startWatchdog()
					vape:CreateNotification("Vape", "Desync active with stability monitoring", 6, "success")
					return
				end

				task.wait(0.5)
				
				-- Try second hook method
				local suc2, err2 = pcall(function()
					hookRef2 = rakHookk
					return raknet.add_send_hook(hookRef2)
				end)

				if suc2 then
					hooktypes.rakhook2 = true
					startWatchdog()
					vape:CreateNotification("Vape", "Desync active (method 2) with stability monitoring", 6, "success")
					return
				end

				warn("[Desync] Both raknet hooks failed:", err1, err2)
				vape:CreateNotification("Vape", "RakNet hooks failed, using stable fflag method", 8, "warning")
			else
				vape:CreateNotification("Vape", "RakNet not available, using fflag method", 8)
			end

			-- Fallback to fflag (most stable)
			local fflagSuccess = pcall(function()
				setfflag("NextGenReplicatorEnabledWrite4", "true")
			end)

			if fflagSuccess then
				hooktypes.fflag = true
				vape:CreateNotification("Vape", "Desync active (stable fflag mode)", 6, "success")
			else
				vape:CreateNotification("Vape", "All desync methods failed. Disabling module...", 8, "alert")
				task.delay(1.5, function()
					if Desync and Desync.Enabled then
						Desync:Toggle(false)
					end
				end)
			end

		else
			-- Comprehensive cleanup
			isShuttingDown = true
			
			-- Stop watchdog
			if watchdogConnection then
				task.cancel(watchdogConnection)
				watchdogConnection = nil
			end
			
			-- Wait a frame for any pending hooks to finish
			task.wait()
			
			-- Remove hooks with multiple attempts
			if rakNet then
				for i = 1, 3 do
					if hooktypes.rakhook1 and hookRef1 then
						local success = pcall(function() 
							raknet.remove_send_hook(hookRef1)
						end)
						if success then
							hookRef1 = nil
							hooktypes.rakhook1 = false
							break
						end
						task.wait(0.1)
					end
				end
				
				for i = 1, 3 do
					if hooktypes.rakhook2 and hookRef2 then
						local success = pcall(function() 
							raknet.remove_send_hook(hookRef2)
						end)
						if success then
							hookRef2 = nil
							hooktypes.rakhook2 = false
							break
						end
						task.wait(0.1)
					end
				end
			end
			
			-- Disable fflag
			if hooktypes.fflag then
				pcall(function()
					setfflag("NextGenReplicatorEnabledWrite4", "false")
				end)
				hooktypes.fflag = false
			end
			
			-- Final cleanup
			task.wait(0.5)
			hookRef1 = nil
			hookRef2 = nil
			hookErrorCount = 0
		end
	end
})

--[[
CHANGELOG:
- Added comprehensive packet validation
- Added error rate limiting (max 10 errors/sec)
- Added watchdog to monitor hook health
- Added automatic fallback to fflag if unstable
- Added multi-attempt cleanup on disable
- Added shutdown flag to prevent crashes during cleanup
- Removed anti-skid code for better performance
--]]