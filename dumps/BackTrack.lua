--[[local oldtoclipboard = getgenv().toclipboard
-- Anti-skid protection removed for performance
--]]

-- ═══════════════════════════════════════════════════════════════
-- BACKTRACK - ULTRA STABLE VERSION WITH COMPREHENSIVE ERROR HANDLING
-- ═══════════════════════════════════════════════════════════════

local run = function(func)
    local suc, res = pcall(function()
        task.spawn(func)
    end)
    if not suc then
        warn('[BACKTRACK] Failed to load module:', res)
    end
end

local cloneref = cloneref or function(obj) return obj end
local runService = cloneref(game:GetService('RunService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local httpService = cloneref(game:GetService('HttpService'))
local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local statsService = cloneref(game:GetService("Stats"))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer

local vape = shared.vape or {}
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local bedwars = getgenv().bedwars or {}
local store = getgenv().store or {}

local rakNet = (typeof(raknet) == 'table' or false)

run(function()
    local BackTrack
    local Mode
    local Delay

    local OldGet
    local enabled
    local posHistory = {}
    local hookFunction = nil
    local hookErrorCount = 0
    local lastErrorTime = 0
    local isShuttingDown = false
    local MAX_ERRORS_PER_SECOND = 20
    local watchdogTask = nil

    -- Comprehensive packet validation
    local function isValidPacket(pckt)
        if not pckt then return false end
        local success, result = pcall(function()
            return pckt.AsArray and pckt.AsArray[1] and pckt.AsBuffer and pckt.SetData
        end)
        return success and result
    end

    -- Ultra-safe hook with multiple layers of protection
    local function hook(pckt)
        if isShuttingDown then return end
        
        -- Rate limiting
        local now = tick()
        if now - lastErrorTime < 1 then
            if hookErrorCount > MAX_ERRORS_PER_SECOND then
                isShuttingDown = true
                warn("[BackTrack] Too many errors, auto-disabling")
                task.spawn(function()
                    if BackTrack and BackTrack.Enabled then
                        BackTrack:Toggle(false)
                    end
                end)
                return
            end
        else
            hookErrorCount = 0
            lastErrorTime = now
        end
        
        -- Validate packet
        if not isValidPacket(pckt) then return end
        
        -- Protected packet processing
        local success = pcall(function()
            if pckt.AsArray[1] == 0x1b then
                local data = pckt.AsBuffer
                if data and buffer then
                    pcall(function()
                        buffer.writeu32(data, 1, 0xFFFFFFFF)
                        pckt:SetData(data)
                    end)
                end
            end
        end)
        
        if not success then
            hookErrorCount = hookErrorCount + 1
        end
    end
    
    local function getTargetRoot()
        if not entitylib or not lplr.Character then return nil end
        
        local root = lplr.Character:FindFirstChild('HumanoidRootPart')
        if not root then return nil end
        if not entitylib.isAlive then return nil end

        local bestPlayer = nil
        local bestDot = -2
        local nearestDist = math.huge
        local selfPos = root.Position
        local lookVec = gameCamera.CFrame.LookVector

        for _, ent in entitylib.List do
            if ent.Player ~= lplr and ent.Character then
                local entRoot = ent.Character:FindFirstChild('HumanoidRootPart')
                if entRoot then
                    local dir = (entRoot.Position - selfPos).Unit
                    local dot = dir:Dot(lookVec)
                    if dot > bestDot and dot > 0.5 then
                        bestDot = dot
                        bestPlayer = entRoot
                    end
                    if not bestPlayer then
                        local dist = (entRoot.Position - selfPos).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            bestPlayer = entRoot
                        end
                    end
                end
            end
        end

        return bestPlayer
    end

    local function calculateDynamicDelay()
        local targetRoot = getTargetRoot()
        if not targetRoot then return 0.2 end
        if not entitylib.isAlive then return 0.2 end
        
        local root = lplr.Character:FindFirstChild('HumanoidRootPart')
        if not root then return 0.2 end

        local selfpos = root.Position
        local targetpos = targetRoot.Position
        local distance = (selfpos - targetpos).Magnitude

        local ping = 0.1
        local suc, res = pcall(function()
            return statsService.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
        end)
        if not suc then
            ping = lplr:GetNetworkPing()
        end

        local baseDelay = 0.2
        local pingFactor = ping * 1.5
        local distanceFactor = math.clamp((distance - 12) / 20, 0, 0.3)
        local dynamicDelay = math.clamp((baseDelay + pingFactor + distanceFactor), 0.1, 0.5)

        return dynamicDelay
    end

    local function getHistorialPos(ago)
        local currentTime = tick()
        local targetTime = (currentTime - ago)
        local best = nil
        local bestDiff = math.huge
        
        for _, entry in ipairs(posHistory) do
            local diff = math.abs(entry.time - targetTime)
            if diff < bestDiff then
                bestDiff = diff
                best = entry.pos
            end
        end
        return best
    end

    local function startFetching()
        BackTrack:Clean(runService.RenderStepped:Connect(function()
            if isShuttingDown then return end
            
            local targetRoot = getTargetRoot()
            if targetRoot then
                table.insert(posHistory, {
                    time = tick(),
                    pos = targetRoot.Position
                })
                -- Limit history to prevent memory leak (reduced from 150)
                if #posHistory > 100 then
                    table.remove(posHistory, 1)
                end
            end
        end))
    end
    
    local function hookClient()
        if OldGet or isShuttingDown then return end
        
        local success = pcall(function()
            OldGet = bedwars.Client.Get
            bedwars.Client.Get = function(self, remoteName)
                local call = OldGet(self, remoteName)
                if remoteName == 'SwordHit' then
                    return {
                        instance = call.instance,
                        SendToServer = function(_, attackTable, ...)
                            if not BackTrack or not BackTrack.Enabled then
                                return call:SendToServer(attackTable, ...)
                            end
                            
                            pcall(function()
                                if Mode.Value == 'Repel' then
                                    local root = lplr.Character:FindFirstChild('HumanoidRootPart')
                                    if not root then return end
                                    
                                    local selfpos = root.Position
                                    local targetRoot = getTargetRoot()
                                    if targetRoot then
                                        local targetpos = targetRoot.Position
                                        local dist = (selfpos - targetpos).Magnitude
                                        if dist >= 14.388 then
                                            attackTable.validate = attackTable.validate or {}
                                            attackTable.validate.selfPosition = attackTable.validate.selfPosition or {value = selfpos}
                                            attackTable.validate.selfPosition.value = attackTable.validate.selfPosition.value + CFrame.lookAt(selfpos, targetpos).LookVector * (dist - 14.388)
                                        end
                                    end
                                elseif Mode.Value == 'Default' then
                                    local ago = Delay.Value / 1000
                                    local oldpos = getHistorialPos(ago)
                                    if oldpos then
                                        attackTable.validate = attackTable.validate or {}
                                        attackTable.validate.targetPosition = attackTable.validate.targetPosition or {value = oldpos}
                                        attackTable.validate.targetPosition.value = oldpos
                                    end
                                elseif Mode.Value == 'Dynamic' then
                                    local dynDelay = calculateDynamicDelay()
                                    local oldPos = getHistorialPos(dynDelay)
                                    if oldPos then
                                        attackTable.validate = attackTable.validate or {}
                                        attackTable.validate.targetPosition = attackTable.validate.targetPosition or {value = oldPos}
                                        attackTable.validate.targetPosition.value = oldPos
                                    end
                                end
                            end)
                            
                            return call:SendToServer(attackTable, ...)
                        end
                    }
                end
                return call
            end
        end)
        
        if not success then
            warn("[BackTrack] Failed to hook Client.Get")
        end
    end

    local function unHookClient()
        if OldGet then
            pcall(function()
                bedwars.Client.Get = OldGet
            end)
            OldGet = nil
        end
    end

    local function startRaknetHook()
        if hookFunction or not rakNet or isShuttingDown then return end
        
        local success, err = pcall(function()
            hookFunction = hook
            raknet.add_send_hook(hookFunction)
        end)
        
        if not success then
            warn("[BackTrack] Failed to add raknet hook:", err)
            hookFunction = nil
        end
    end

    local function stopRaknetHook()
        if not hookFunction or not rakNet then return end
        
        -- Multiple attempts to remove hook
        for i = 1, 3 do
            local success = pcall(function() 
                raknet.remove_send_hook(hookFunction)
            end)
            if success then
                hookFunction = nil
                break
            end
            task.wait(0.1)
        end
        
        hookFunction = nil
    end

    local function startWatchdog()
        if watchdogTask then return end
        
        watchdogTask = task.spawn(function()
            while BackTrack and BackTrack.Enabled and not isShuttingDown do
                task.wait(10)
                
                -- Monitor error rate
                if hookErrorCount > 100 then
                    warn("[BackTrack] Too many cumulative errors, restarting hooks")
                    stopRaknetHook()
                    task.wait(1)
                    if BackTrack and BackTrack.Enabled then
                        startRaknetHook()
                    end
                    hookErrorCount = 0
                end
                
                -- Memory cleanup
                if #posHistory > 100 then
                    for i = 1, 20 do
                        table.remove(posHistory, 1)
                    end
                end
            end
        end)
    end

    local function fullCleanup()
        isShuttingDown = true
        
        -- Stop watchdog
        if watchdogTask then
            task.cancel(watchdogTask)
            watchdogTask = nil
        end
        
        -- Wait for any pending operations
        task.wait(0.1)
        
        -- Unhook client
        unHookClient()
        
        -- Stop raknet hook
        stopRaknetHook()
        
        -- Clear memory
        table.clear(posHistory)
        posHistory = {}
        
        hookErrorCount = 0
        lastErrorTime = 0
        
        -- Final wait
        task.wait(0.3)
    end

    BackTrack = vape.Categories.World:CreateModule({
        Name = 'BackTrack',
        Tooltip = 'Manipulates movement packets for delayed hits - Now with stability protection',
        Function = function(callback)
            if callback then
                if not rakNet then
                    vape:CreateNotification("BackTrack", "Raknet not available! Module disabled.", 10, "error")
                    vape:Remove('BackTrack')
                    return
                end
                
                isShuttingDown = false
                hookErrorCount = 0
                
                vape:CreateNotification("BackTrack", "Enabled with stability monitoring!", 5, "success")
                enabled = true
                startFetching()
                hookClient()
                startRaknetHook()
                startWatchdog()
            else
                enabled = false
                fullCleanup()
                vape:CreateNotification("BackTrack", "Disabled safely", 3)
            end
        end
    })

    Mode = BackTrack:CreateDropdown({
        Name = "Mode",
        List = {"Repel", "Dynamic", "Default"},
        Default = "Default",
        Function = function(val)
            if val == "Default" or val == "Dynamic" then
                startFetching()
            end
        end
    })

    Delay = BackTrack:CreateSlider({
        Name = "Delay",
        Min = 0,
        Max = 5000,
        Default = 2500,
        Suffix = "ms",
    })
end)

--[[
CHANGELOG:
- Added comprehensive packet validation
- Added error rate limiting (max 20 errors/sec)
- Added watchdog for monitoring and auto-recovery
- Added multi-attempt hook removal (3 tries)
- Added shutdown flag to prevent cleanup crashes
- Reduced position history from 150 to 100
- Added memory cleanup in watchdog (removes old entries)
- Added graceful fallback if raknet fails
- Improved error messages with context
- Removed anti-skid code for performance
--]]