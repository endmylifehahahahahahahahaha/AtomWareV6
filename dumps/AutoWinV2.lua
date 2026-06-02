--// #2024-06-17 20:44:00, https://github.com/endmylifehahahahahahahahaha/AtomWareV6/, @superburger2753
--// AutoWinV2.lua > (this is deepseek coded, this is not mine however I found it in a different fork which was paid.)

--// Variables:
--7local 





--// return(function)
-->> CodeBlock 1























--//End of CodeBlock 1














--// return(function )
-->> CodeBlock 2
--[[task.spawn(function())]]

-->> CodeBlock 2



--[[
    Advanced Autowin v2 - Improved Performance & Reliability
    Features:
    - Better bed detection and pathing
    - Smarter player targeting
    - Anti-stuck system
    - Performance optimizations
    - Error handling improvements
    - Configurable settings
--]]

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
local playersService = cloneref(game:GetService('Players'))
local teleportService = cloneref(game:GetService('TeleportService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local collectionService = cloneref(game:GetService('CollectionService'))

local lplr = playersService.LocalPlayer
local vape = shared.vape
local bedwars = getgenv().bedwars or {}
local store = getgenv().store or {}

local tracker = {
    bed = nil, 
    nuking = false, 
    died = false, 
    kaing = false, 
    currentTarget = nil,
    lastTargetPos = nil,
    stuckCounter = 0,
    bedQueue = {},
    killedPlayers = {}
}

local beds = {}
local players = {}
local currentbedpos = Vector3.zero
local oldMomentumUpdate
local momentumCheck = 0

-- Configuration (adjustable)
local CONFIG = {
    TELEPORT_HEIGHT = 8, -- Height to teleport above targets
    BED_BREAK_RANGE = 35,
    BED_BREAK_SPEED = 0.2,
    KILLAURA_RANGE = 25,
    MAX_TARGETS = 3,
    UPDATE_RATE = 120,
    TELEPORT_DELAY = 0.08,
    STUCK_THRESHOLD = 5,
    BED_CHECK_INTERVAL = 0.15,
    PLAYER_CHECK_INTERVAL = 0.25
}

local function getAccountTier(player)
    if getgenv().getAccountTier then
        return getgenv().getAccountTier(player)
    end
    return 0
end

local function safeTeleport(part, position, yOffset)
    local success, err = pcall(function()
        part.CFrame = CFrame.new(position.X, position.Y + yOffset, position.Z)
    end)
    if not success then
        warn("[Autowin] Teleport failed: " .. tostring(err))
        return false
    end
    return true
end

local function getCharacterRoot(char)
    if not char then return nil end
    local root = char:FindFirstChild('HumanoidRootPart')
    if not root then
        root = char:FindFirstChild('UpperTorso') or char:FindFirstChild('Torso')
    end
    return root
end

local function isPlayerAlive(player)
    if not player then return false end
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChild('Humanoid')
    return hum and hum.Health > 0 and hum.Health < math.huge
end

local function getPlayerTeam(player)
    if not player or not player.Character then return nil end
    return player.Character:GetAttribute("Team")
end

local function setup()
    if not bedwars.GlacialSkaterController then 
        warn('[Autowin] No controller to hook onto') 
        return false 
    end
    if store.equippedKit ~= 'glacial_skater' then 
        warn('[Autowin] Not Krystal kit') 
        return false 
    end

    if not oldMomentumUpdate then
        oldMomentumUpdate = bedwars.GlacialSkaterController.updateMomentum
    end

    bedwars.GlacialSkaterController.updateMomentum = function(self, ...)
        self.momentum = 9e9
        self.lastMomentumReport = 9e9
        momentumCheck = momentumCheck + 1
        pcall(function()
            bedwars.Client:Get('MomentumUpdate'):SendToServer({ momentumValue = 9e9 })
        end)
    end

    return true
end

local function isBedObjectAt(pos, checkRange)
    checkRange = checkRange or 3
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "bed" and obj:IsA("BasePart") and (obj.Position - pos).Magnitude < checkRange then
            return true, obj
        end
    end
    return false, nil
end

local function cleanBedsTable()
    for i = #beds, 1, -1 do
        local exists = isBedObjectAt(beds[i])
        if not exists then
            table.remove(beds, i)
        end
    end
end

local function AllbedPOS()
    beds = {}
    local mapCFrames = workspace:FindFirstChild("MapCFrames")
    if mapCFrames then
        for _, obj in ipairs(mapCFrames:GetChildren()) do
            if string.match(obj.Name, "_bed$") then
                table.insert(beds, obj.Value.Position)
            end
        end
    end
    
    -- Also check for beds directly in workspace
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "bed" and obj:IsA("BasePart") then
            local pos = obj.Position
            local alreadyAdded = false
            for _, bedPos in ipairs(beds) do
                if (bedPos - pos).Magnitude < 2 then
                    alreadyAdded = true
                    break
                end
            end
            if not alreadyAdded then
                table.insert(beds, pos)
            end
        end
    end
    
    cleanBedsTable()
end

local function UpdateCurrentBedPOS()
    local mapCFrames = workspace:FindFirstChild("MapCFrames")
    if not mapCFrames then return end
    local team = lplr.Character and lplr.Character:GetAttribute("Team")
    if team then
        local bedObj = mapCFrames:FindFirstChild(tostring(team) .. "_bed")
        if bedObj then
            currentbedpos = bedObj.Value.Position
        end
    end
end

local function closestBed(origin)
    local closest, dist = nil, math.huge
    for i, pos in ipairs(beds) do
        if (pos - currentbedpos).Magnitude > 5 then
            local d = (pos - origin).Magnitude
            if d < dist then
                dist, closest = d, pos
            end
        end
    end
    return closest, dist
end

local function getBedsToNuke()
    local bedsToNuke = {}
    local myTeam = getPlayerTeam(lplr)
    
    for _, pos in ipairs(beds) do
        if (pos - currentbedpos).Magnitude > 5 then
            table.insert(bedsToNuke, pos)
        end
    end
    
    -- Sort by distance from center
    table.sort(bedsToNuke, function(a, b)
        return (a - Vector3.zero).Magnitude < (b - Vector3.zero).Magnitude
    end)
    
    return bedsToNuke
end

local function getallPlayers()
    players = {}
    for _, ent in entitylib.List do
        if ent.Player and ent.Player ~= lplr then
            table.insert(players, ent.Player)
        end
    end
end

local function getAlivePlayers()
    local alive = {}
    local myTeam = getPlayerTeam(lplr)
    
    for _, player in ipairs(players) do
        if player ~= lplr and not tracker.killedPlayers[player.Name] then
            local char = player.Character
            if char then
                local hum = char:FindFirstChild('Humanoid')
                if hum and hum.Health > 0 then
                    local playerTeam = getPlayerTeam(player)
                    if playerTeam ~= myTeam then -- Only target enemies
                        table.insert(alive, player)
                    end
                end
            end
        end
    end
    
    -- Sort by distance to current position for efficiency
    local myRoot = lplr.Character and getCharacterRoot(lplr.Character)
    if myRoot then
        table.sort(alive, function(a, b)
            local aChar = a.Character
            local bChar = b.Character
            local aRoot = aChar and getCharacterRoot(aChar)
            local bRoot = bChar and getCharacterRoot(bChar)
            local aDist = aRoot and (aRoot.Position - myRoot.Position).Magnitude or math.huge
            local bDist = bRoot and (bRoot.Position - myRoot.Position).Magnitude or math.huge
            return aDist < bDist
        end)
    end
    
    return alive
end

local function configureBreaker()
    if not vape.Modules.Breaker.Enabled then
        vape.Modules.Breaker:Toggle()
    end
    task.wait()
    task.spawn(function()
        local breaker = vape.Modules.Breaker
        
        -- Disable unnecessary options
        local disableList = {
            'Break Iron Ore', 'Break Crops', 'Break Hive', 
            'Require Mouse Down', 'Break Tesla', 'Break Pinata', 'Limit to items'
        }
        
        for _, option in ipairs(disableList) do
            if breaker.Options[option] and breaker.Options[option].Enabled then
                breaker.Options[option]:Toggle()
            end
        end
        
        -- Enable required options
        if not breaker.Options['Auto Tool'].Enabled then
            breaker.Options['Auto Tool']:Toggle()
        end
        if not breaker.Options['Break Bed'].Enabled then
            breaker.Options['Break Bed']:Toggle()
        end
        
        -- Set values
        breaker.Options['Break range']:SetValue(CONFIG.BED_BREAK_RANGE)
        breaker.Options['Break speed']:SetValue(CONFIG.BED_BREAK_SPEED)
        breaker.Options['Update rate']:SetValue(CONFIG.UPDATE_RATE)
    end)
end

local function configureKillaura()
    if not vape.Modules.Killaura.Enabled then
        vape.Modules.Killaura:Toggle()
    end
    if vape.Modules.GrandKillaura.Enabled then
        vape.Modules.GrandKillaura:Toggle()
    end
    if vape.Modules.SilentAura.Enabled then
        vape.Modules.SilentAura:Toggle()
    end
    
    task.wait()
    task.spawn(function()
        local ka = vape.Modules.Killaura
        
        -- Disable unnecessary options
        local disableList = {
            'Targets.Walls', 'Targets.NPCs', 'Targets.Invisible', 
            'Range Visualiser', 'Require mouse down', 'GUI check',
            'Continue Swinging', 'Custom Hit Reg', 'Sync Hits',
            'Target particles', 'Custom Animation', 'Limit to items',
            'Swing only', 'Dynamic Reach', 'Attack Check'
        }
        
        for _, option in ipairs(disableList) do
            local opt = ka.Options[option]
            if opt and opt.Enabled then
                opt:Toggle()
            end
        end
        
        -- Enable required options
        if not ka.Options.Targets.Players.Enabled then
            ka.Options.Targets.Players:Toggle()
        end
        if not ka.Options['Custom Swing Time'].Enabled then
            ka.Options['Custom Swing Time']:Toggle()
        end
        if not ka.Options['Show target'].Enabled then
            ka.Options['Show target']:Toggle()
        end
        if not ka.Options['Face target'].Enabled then
            ka.Options['Face target']:Toggle()
        end
        if not ka.Options['Fast Hits'].Enabled then
            ka.Options['Fast Hits']:Toggle()
        end
        
        -- Set values
        ka.Options['Target Priority']:SetValue('Distance')
        ka.Options['Swing range']:SetValue(CONFIG.KILLAURA_RANGE + 10)
        ka.Options['Attack range']:SetValue(CONFIG.KILLAURA_RANGE)
        ka.Options['Max angle']:SetValue(360)
        ka.Options['Update rate']:SetValue(CONFIG.UPDATE_RATE)
        ka.Options['Max targets']:SetValue(CONFIG.MAX_TARGETS)
        ka.Options['Target Mode']:SetValue('Distance')
        ka.Options['Swing Time']:SetValue(0)
    end)
end

local function breakBedAtPosition(bedPos)
    if not bedPos then return false end
    
    local root = lplr.Character and getCharacterRoot(lplr.Character)
    if not root then return false end
    
    -- Teleport to bed
    local success = safeTeleport(root, bedPos, CONFIG.TELEPORT_HEIGHT)
    if not success then return false end
    
    task.wait(CONFIG.TELEPORT_DELAY)
    
    -- Wait for bed to break
    local bedBroken = false
    local connection
    connection = workspace.DescendantRemoving:Connect(function(obj)
        if obj and obj.Name == "bed" and obj:IsA("BasePart") then
            if (obj.Position - bedPos).Magnitude < 4 then
                bedBroken = true
                connection:Disconnect()
            end
        end
    end)
    
    -- Check multiple times
    for i = 1, 10 do
        task.wait(0.2)
        if bedBroken then
            -- Verify the bed is actually gone
            local exists = isBedObjectAt(bedPos, 5)
            if not exists then
                return true
            end
        end
        
        -- Re-teleport if stuck
        local currentRoot = lplr.Character and getCharacterRoot(lplr.Character)
        if currentRoot and (currentRoot.Position - bedPos).Magnitude > 8 then
            safeTeleport(currentRoot, bedPos, CONFIG.TELEPORT_HEIGHT)
        end
    end
    
    connection:Disconnect()
    return isBedObjectAt(bedPos, 5) == false
end

local function killPlayer(targetPlayer)
    if not targetPlayer or not isPlayerAlive(targetPlayer) then
        return false
    end
    
    tracker.currentTarget = targetPlayer
    
    -- Teleport to player and kill
    local killAttempts = 0
    local maxAttempts = 5
    
    while killAttempts < maxAttempts and isPlayerAlive(targetPlayer) do
        local char = targetPlayer.Character
        if not char then break end
        
        local targetRoot = getCharacterRoot(char)
        if targetRoot then
            local myRoot = lplr.Character and getCharacterRoot(lplr.Character)
            if myRoot then
                -- Teleport to player
                safeTeleport(myRoot, targetRoot.Position, CONFIG.TELEPORT_HEIGHT)
                tracker.lastTargetPos = targetRoot.Position
            end
        end
        
        task.wait(0.3)
        killAttempts = killAttempts + 1
    end
    
    return not isPlayerAlive(targetPlayer)
end

run(function()
    local Autowin
    local renderConnection
    local bedConnection
    local deathConnection
    
    Autowin = vape.Categories.Minigames:CreateModule({
        Name = 'Autowin v2',
        Function = function(callback)
            repeat task.wait(0.08) until store.matchState ~= 0
            
            if not callback then
                -- Cleanup
                if renderConnection then renderConnection:Disconnect() end
                if bedConnection then bedConnection:Disconnect() end
                if deathConnection then deathConnection:Disconnect() end
                
                if oldMomentumUpdate and bedwars.GlacialSkaterController then
                    bedwars.GlacialSkaterController.updateMomentum = oldMomentumUpdate
                end
                
                tracker.nuking = false
                tracker.kaing = false
                tracker.currentTarget = nil
                tracker.killedPlayers = {}
                beds = {}
                return
            end
            
            -- Setup and validation
            if not setup() then
                vape:CreateNotification("Autowin v2", "Requires Krystal kit!", 8, 'warning')
                Autowin:Toggle(false)
                return
            end
            
            -- Kill player to reset position
            if lplr.Character and lplr.Character:FindFirstChild('Humanoid') then
                lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
            end
            task.wait(playersService.RespawnTime or 3)
            
            -- Momentum handler
            renderConnection = runService.RenderStepped:Connect(function()
                if not bedwars then return end
                pcall(function()
                    bedwars.GlacialSkaterController:updateMomentum({momentum=9e9,lastMomentumReport=9e9}, "newValue")
                end)
            end)
            Autowin:Clean(renderConnection)
            
            -- Update positions
            UpdateCurrentBedPOS()
            AllbedPOS()
            
            if #beds <= 1 then
                vape:CreateNotification("Autowin v2", "Not enough beds to nuke!", 6, 'warning')
                Autowin:Toggle(false)
                return
            end
            
            -- Configure modules
            configureBreaker()
            configureKillaura()
            tracker.nuking = true
            
            -- Bed nuking phase
            local bedsToNuke = getBedsToNuke()
            vape:CreateNotification("Autowin v2", string.format("Nuking %d beds...", #bedsToNuke), 4)
            
            for i, bedPos in ipairs(bedsToNuke) do
                if not Autowin.Enabled or not tracker.nuking then break end
                
                -- Check if bed still exists
                local bedExists = isBedObjectAt(bedPos)
                if not bedExists then
                    -- Remove from beds table
                    for j, pos in ipairs(beds) do
                        if (pos - bedPos).Magnitude < 2 then
                            table.remove(beds, j)
                            break
                        end
                    end
                    continue
                end
                
                vape:CreateNotification("Autowin v2", string.format("Breaking bed %d/%d", i, #bedsToNuke), 2)
                tracker.bed = bedPos
                
                local success = breakBedAtPosition(bedPos)
                if success then
                    vape:CreateNotification("Autowin v2", "Bed broken!", 1)
                end
                
                task.wait(0.2)
            end
            
            tracker.nuking = false
            tracker.bed = nil
            
            -- Player elimination phase
            if not Autowin.Enabled then return end
            
            vape:CreateNotification("Autowin v2", "All beds nuked! Eliminating players...", 5)
            
            if lplr.Character and lplr.Character:FindFirstChild('Humanoid') then
                lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
            end
            task.wait(playersService.RespawnTime or 3)
            
            getallPlayers()
            tracker.kaing = true
            
            local maxKillAttempts = 3
            local eliminationCount = 0
            
            while Autowin.Enabled and tracker.kaing do
                local alivePlayers = getAlivePlayers()
                
                if #alivePlayers == 0 then
                    break
                end
                
                for _, targetPlayer in ipairs(alivePlayers) do
                    if not Autowin.Enabled or not tracker.kaing then break end
                    
                    if tracker.killedPlayers[targetPlayer.Name] then
                        continue
                    end
                    
                    if not isPlayerAlive(targetPlayer) then
                        tracker.killedPlayers[targetPlayer.Name] = true
                        continue
                    end
                    
                    vape:CreateNotification("Autowin v2", string.format("Targeting %s", targetPlayer.Name), 2)
                    
                    local killed = false
                    for attempt = 1, maxKillAttempts do
                        if killPlayer(targetPlayer) then
                            killed = true
                            break
                        end
                        task.wait(0.5)
                    end
                    
                    if killed then
                        eliminationCount = eliminationCount + 1
                        tracker.killedPlayers[targetPlayer.Name] = true
                        vape:CreateNotification("Autowin v2", string.format("Eliminated %s (%d/%d)", 
                            targetPlayer.Name, eliminationCount, #alivePlayers), 3)
                    else
                        vape:CreateNotification("Autowin v2", string.format("Failed to kill %s, retrying...", 
                            targetPlayer.Name), 2, 'warning')
                    end
                    
                    task.wait(0.2)
                end
                
                task.wait(0.5)
            end
            
            tracker.kaing = false
            tracker.currentTarget = nil
            
            if Autowin.Enabled then
                vape:CreateNotification("Autowin v2", 
                    string.format("Complete! Eliminated %d players and nuked all beds!", eliminationCount), 5, 'success')
                Autowin:Toggle(false)
            end
        end
    })
end)