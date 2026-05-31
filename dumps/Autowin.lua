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
local playersService = cloneref(game:GetService('Players'))

local lplr = playersService.LocalPlayer
local vape = shared.vape

local tracker = {bed = nil, nuking = false, died = false, kaing=false, currentTarget =  nil}
local beds = {}
local players = {}
local currentbedpos = Vector3.zero

local oldMomentumUpdate

local function getAccountTier(player)
    if getgenv().getAccountTier then
        return getgenv().getAccountTier(player)
    end
    return 0
end

local function setup()
    if not bedwars.GlacialSkaterController then 
        warn('no controller to hook onto') 
        return false 
    end
    if store.equippedKit ~= 'glacial_skater' then 
        warn('not krystal kit') 
        return false 
    end

    if not oldMomentumUpdate then
        oldMomentumUpdate = bedwars.GlacialSkaterController.updateMomentum
    end

    bedwars.GlacialSkaterController.updateMomentum = function(self, ...)
        self.momentum = 9e9
        self.lastMomentumReport = 9e9
        pcall(function()
            bedwars.Client:Get('MomentumUpdate'):SendToServer({ momentumValue = 9e9 })
        end)
    end

    return true
end

local function isBedObjectAt(pos)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "bed" and obj:IsA("BasePart") and (obj.Position - pos).Magnitude < 2 then
            return true
        end
    end
    return false
end

local function cleanBedsTable()
    for i = #beds, 1, -1 do
        if not isBedObjectAt(beds[i]) then
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
    for _, pos in ipairs(beds) do
        if (pos - currentbedpos).Magnitude > 5 then
            local d = (pos - origin).Magnitude
            if d < dist then
                dist, closest = d, pos
            end
        end
    end
    return closest
end

local function getallPlayers()
    players = {}
    for _, ent in entitylib.List do
        if ent.Player and ent.Player ~= lplr then
            table.insert(players, ent.Player)
        end
    end
end

local function configureBreaker()
	if not vape.Modules.Breaker.Enabled then
		vape.Modules.Breaker:Toggle()
	end
	task.wait()
	task.spawn(function()
		if vape.Modules.Breaker.Options['Break Iron Ore'].Enabled then
			vape.Modules.Breaker.Options['Break Iron Ore']:Toggle()
		end
		if vape.Modules.Breaker.Options['Break Crops'].Enabled then
			vape.Modules.Breaker.Options['Break Crops']:Toggle()
		end
		if vape.Modules.Breaker.Options['Break Hive'].Enabled then
			vape.Modules.Breaker.Options['Break Hive']:Toggle()
		end
		if vape.Modules.Breaker.Options['Require Mouse Down'].Enabled then
			vape.Modules.Breaker.Options['Require Mouse Down']:Toggle()
		end
		if not vape.Modules.Breaker.Options['Auto Tool'].Enabled then
			vape.Modules.Breaker.Options['Auto Tool']:Toggle()
		end
		if vape.Modules.Breaker.Options['Limit to items'].Enabled then
			vape.Modules.Breaker.Options['Limit to items']:Toggle()
		end
		if vape.Modules.Breaker.Options['Break Tesla'].Enabled then
			vape.Modules.Breaker.Options['Break Tesla']:Toggle()
		end
		if vape.Modules.Breaker.Options['Break Pinata'].Enabled then
			vape.Modules.Breaker.Options['Break Pinata']:Toggle()
		end
		if not vape.Modules.Breaker.Options['Break Bed'].Enabled then
			vape.Modules.Breaker.Options['Break Bed']:Toggle()
		end
        vape.Modules.Breaker.Options['Break range']:SetValue(30)
        vape.Modules.Breaker.Options['Break speed']:SetValue(0.25)
        vape.Modules.Breaker.Options['Update rate']:SetValue(120)
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
		if not vape.Modules.Killaura.Options.Targets.Players.Enabled then
			vape.Modules.Killaura.Options.Targets.Players:Toggle()
		end
		if vape.Modules.Killaura.Options.Targets.Walls.Enabled then
			vape.Modules.Killaura.Options.Targets.Walls:Toggle()
		end
		if vape.Modules.Killaura.Options.Targets.NPCs.Enabled then
			vape.Modules.Killaura.Options.Targets.NPCs:Toggle()
		end
		if vape.Modules.Killaura.Options.Targets.Invisible.Enabled then
			vape.Modules.Killaura.Options.Targets.Invisible:Toggle()
		end
		if vape.Modules.Killaura.Options['Range Visualiser'].Enabled then
			vape.Modules.Killaura.Options['Range Visualiser']:Toggle()
		end
		if vape.Modules.Killaura.Options['Require mouse down'].Enabled then
			vape.Modules.Killaura.Options['Require mouse down']:Toggle()
		end
		if vape.Modules.Killaura.Options['GUI check'].Enabled then
			vape.Modules.Killaura.Options['GUI check']:Toggle()
		end
		if not vape.Modules.Killaura.Options['Custom Swing Time'].Enabled then
			vape.Modules.Killaura.Options['Custom Swing Time']:Toggle()
		end
		if vape.Modules.Killaura.Options['Continue Swinging'].Enabled then
			vape.Modules.Killaura.Options['Continue Swinging']:Toggle()
		end
		if vape.Modules.Killaura.Options['Custom Hit Reg'].Enabled then
			vape.Modules.Killaura.Options['Custom Hit Reg']:Toggle()
		end
		if vape.Modules.Killaura.Options['Sync Hits'].Enabled then
			vape.Modules.Killaura.Options['Sync Hits']:Toggle()
		end
		if vape.Modules.Killaura.Options['Show target'].Enabled then
			vape.Modules.Killaura.Options['Show target']:Toggle()
		end
		if vape.Modules.Killaura.Options['Target particles'].Enabled then
			vape.Modules.Killaura.Options['Target particles']:Toggle()
		end
		if vape.Modules.Killaura.Options['Face target'].Enabled then
			vape.Modules.Killaura.Options['Face target']:Toggle()
		end
		if vape.Modules.Killaura.Options['Custom Animation'].Enabled then
			vape.Modules.Killaura.Options['Custom Animation']:Toggle()
		end
		if vape.Modules.Killaura.Options['Limit to items'].Enabled then
			vape.Modules.Killaura.Options['Limit to items']:Toggle()
		end
		if vape.Modules.Killaura.Options['Swing only'].Enabled then
			vape.Modules.Killaura.Options['Swing only']:Toggle()
		end
		if vape.Modules.Killaura.Options['Air Hits'].Enabled then
			vape.Modules.Killaura.Options['Air Hits']:Toggle()
		end
		if vape.Modules.Killaura.Options['Dynamic Reach'].Enabled then
			vape.Modules.Killaura.Options['Dynamic Reach']:Toggle()
		end
		if vape.Modules.Killaura.Options['Attack Check'].Enabled then
			vape.Modules.Killaura.Options['Attack Check']:Toggle()
		end
		if vape.Modules.Killaura.Options['Fast Hits'].Enabled then
			vape.Modules.Killaura.Options['Fast Hits']:Toggle()
		end
		if vape.Modules.Killaura.Options['FastHits Blacklist'].Enabled then
			vape.Modules.Killaura.Options['FastHits Blacklist']:Toggle()
		end
		if vape.Modules.Killaura.Options['No Swing'].Enabled then
			vape.Modules.Killaura.Options['No Swing']:Toggle()
		end
		vape.Modules.Killaura.Options['Target Priority']:SetValue('Distance')
		vape.Modules.Killaura.Options['Swing range']:SetValue(40)
		vape.Modules.Killaura.Options['Attack range']:SetValue(22)
		vape.Modules.Killaura.Options['Attack range']:SetValue(22)
		vape.Modules.Killaura.Options['Max angle']:SetValue(360)
		vape.Modules.Killaura.Options['Update rate']:SetValue(120)
		vape.Modules.Killaura.Options['Max targets']:SetValue(5)
		vape.Modules.Killaura.Options['Target Mode']:SetValue('Distance')
		vape.Modules.Killaura.Options['Swing Time']:SetValue(0)
	end)
end

run(function()
    local Autowin
    local Empty
    Autowin = vape.Categories.Minigames:CreateModule({
        Name = 'Autowin',
        Function = function(callback)
            repeat task.wait(0.08) until store.matchState ~= 0
            if not callback then
                if oldMomentumUpdate and bedwars.GlacialSkaterController then
                    bedwars.GlacialSkaterController.updateMomentum = oldMomentumUpdate
                end
                tracker.nuking = false
                tracker.kaing = false
                tracker.currentTarget = nil
                beds = {}
                return
            end
            if not setup() then
                vape:CreateNotification("Vape", "Autowin requires Krystal kit!", 8, 'warning')
                Autowin:Toggle(false)
                return
            end
            lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
            task.wait(playersService.RespawnTime or 3)
            Autowin:Clean(runService.RenderStepped:Connect(function()
                if not bedwars then return end
                pcall(function()
                    bedwars.GlacialSkaterController:updateMomentum({momentum=9e9,lastMomentumReport=9e9}, "newValue")
                end)
            end))
            UpdateCurrentBedPOS()
            AllbedPOS()
            if #beds <= 1 then
                vape:CreateNotification("Autowin", "Not enough beds to nuke!", 6, 'warning')
                Autowin:Toggle(false)
                return
            end
            configureBreaker()
            configureKillaura()
            tracker.nuking = true

            Autowin:Clean(lplr.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                local root = char:WaitForChild('HumanoidRootPart', 5)
                if root then
                    if tracker.bed then
                        vape:CreateNotification("Autowin", "Reteleporting to old bed tracker...",4)
                        root.CFrame = CFrame.new(tracker.bed.X, tracker.bed.Y + 6, tracker.bed.Z)
                    elseif tracker.kaing and tracker.currentTarget then
                        local targetChar = tracker.currentTarget.Character
                        local targetRoot = targetChar and targetChar:FindFirstChild('HumanoidRootPart')
                        if targetRoot then
                            root.CFrame = CFrame.new(targetRoot.Position.X, targetRoot.Position.Y + 6, targetRoot.Position.Z)
                        elseif tracker.lastTargetPos then
                            root.CFrame = CFrame.new(tracker.lastTargetPos.X, tracker.lastTargetPos.Y + 6, tracker.lastTargetPos.Z)
                        end
                    end
                end
            end))

            task.spawn(function()
                while Autowin.Enabled and #beds > 1 and tracker.nuking do
                    local root = lplr.Character and lplr.Character:FindFirstChild('HumanoidRootPart')
                    if not root then 
                        task.wait(0.5)
                        continue 
                    end
                    local nextBed = closestBed(root.Position)
                    if not nextBed then break end

                    if not isBedObjectAt(nextBed) then
                        for i, v in ipairs(beds) do
                            if (v - nextBed).Magnitude < 0.1 then
                                table.remove(beds, i)
                                break
                            end
                        end
                        tracker.bed = nil
                        continue
                    end

                    tracker.bed = nextBed
                    root.CFrame = CFrame.new(nextBed.X, nextBed.Y + 6, nextBed.Z)
                    task.wait(0.1)
                    local conn
                    conn = workspace.DescendantRemoving:Connect(function(obj)
                        if obj and obj.Name == "bed" and (obj.Position - nextBed).Magnitude < 3 then
                            for i, v in ipairs(beds) do
                                if (v - nextBed).Magnitude < 3 then
                                    table.remove(beds, i)
                                    break
                                end
                            end
                            tracker.bed = nil
                            conn:Disconnect()
                        end
                    end)

                    task.wait(0.3)
                end

                tracker.nuking = false
                tracker.bed = nil
                vape:CreateNotification("Autowin",'Nuked all beds. Moving onto Players..',8)
                if lplr.Character and lplr.Character:FindFirstChild('Humanoid') then
                    lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                end
                task.wait(playersService.RespawnTime or 3)

                getallPlayers()
                local function getAlivePlayers()
                    local alive = {}
                    for _, player in ipairs(players) do
                        if player ~= lplr then
                            local char = player.Character
                            if char then
                                local hum = char:FindFirstChild('Humanoid')
                                if hum and hum.Health > 0 then
                                    table.insert(alive, player)
                                end
                            end
                        end
                    end
                    return alive
                end

                local alivePlayers = getAlivePlayers()
                if #alivePlayers == 0 then
                    vape:CreateNotification("Autowin", "Done. no players needed to kill", 5)
                    Autowin:Toggle(false)
                    return
                end

                tracker.kaing = true

                for i = 1, #alivePlayers do
                    if not Autowin.Enabled or not tracker.kaing then break end

                    local targetPlayer = alivePlayers[i]
                    local char = targetPlayer.Character
                    local hum = char and char:FindFirstChild('Humanoid')
                    if not hum or hum.Health <= 0 then
                        for idx, p in ipairs(players) do
                            if p == targetPlayer then
                                table.remove(players, idx)
                                break
                            end
                        end
                        continue
                    end

                    tracker.currentTarget = targetPlayer
                    tracker.lastTargetPos = nil

                    local function teleportToTarget()
                        local char = targetPlayer.Character
                        if char then
                            local targetRoot = char:FindFirstChild('HumanoidRootPart')
                            if targetRoot then
                                local pos = targetRoot.Position
                                tracker.lastTargetPos = pos
                                local myRoot = lplr.Character and lplr.Character:FindFirstChild('HumanoidRootPart')
                                if myRoot then
                                    myRoot.CFrame = CFrame.new(pos.X, pos.Y + 6, pos.Z)
                                end
                            end
                        end
                    end
                    teleportToTarget()

                    while Autowin.Enabled and tracker.kaing and tracker.currentTarget == targetPlayer do
                        local char = targetPlayer.Character
                        local hum = char and char:FindFirstChild('Humanoid')
                        if not hum or hum.Health <= 0 then
                            break
                        end
                        local root = char:FindFirstChild('HumanoidRootPart')
                        if root then
                            tracker.lastTargetPos = root.Position
                        end
                        task.wait(0.3)
                    end

                    for idx, p in ipairs(players) do
                        if p == targetPlayer then
                            table.remove(players, idx)
                            break
                        end
                    end

                    if not Autowin.Enabled or not tracker.kaing then break end
                    vape:CreateNotification("Autowin", targetPlayer.Name .. " killed.", 3)
                end

                tracker.kaing = false
                tracker.currentTarget = nil
                if Autowin.Enabled then
                    vape:CreateNotification("Autowin", "Done. Killed all players and nuked all beds!", 5)
                    Autowin:Toggle(false)
                end
            end)
        end
    })
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