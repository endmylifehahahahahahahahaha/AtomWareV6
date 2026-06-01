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
end)
--]]
local run = function(func)
    local suc, res = pcall(function()
        task.spawn(func)
    end)
    if not suc then
        warn('[AEROV4 MODULE ISSUE]: Failed to load module BACKTRACK')
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

    local function hook(pckt)
        if not pckt or pckt.PacketId ~= 0x1B then return end
        
        local success, err = pcall(function()
            local data = pckt.AsBuffer
            if data then
                buffer.writeu32(data, 1, 0xFFFFFFFF)
                pckt:SetData(data)
            end
        end)
        
        if not success then
            warn('[BackTrack] Hook error: ' .. tostring(err))
        end
    end
    
    local function getTargetRoot()
        local bestPlayer = nil
        local bestDot = -2
        local nearestDist = math.huge

        if not entitylib or not entitylib.isAlive or not lplr.Character or not lplr.Character.HumanoidRootPart then return nil end

        for _, ent in entitylib.List do
            if ent.Player ~= lplr and ent.Character then
                local root = ent.Character:FindFirstChild('HumanoidRootPart')
                if root then
                    local dir = (root.Position - lplr.Character.HumanoidRootPart.Position).Unit
                    local dot = dir:Dot(gameCamera.CFrame.LookVector)
                    if dot > bestDot and dot > 0.5 then
                        bestDot = dot
                        bestPlayer = root
                    end
                    if not bestPlayer then
                        local dist = (root.Position - lplr.Character.HumanoidRootPart.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            bestPlayer = root
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
        if not entitylib.isAlive or not lplr.Character or not lplr.Character.HumanoidRootPart then return 0.2 end
        if not entitylib.RootPart then return 0.2 end

        local selfpos = lplr.Character.HumanoidRootPart.Position
        local targetpos = targetRoot.Position
        local distance = (selfpos - targetpos).Magnitude

        local ping = 0.1
        local suc, res = pcall(function()
            ping = statsService.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
        end)
        if not suc then
            ping = lplr:GetNetworkPing()
        end

        local baseDelay = 0.2
        local PingFactor = ping * 1.5
        local distanceFactor = math.clamp((distance - 12) / 20, 0, 0.3)
        local dynamicDelay = math.clamp((baseDelay + PingFactor + distanceFactor),0.1,0.5)

        return dynamicDelay
    end

    local function getHistorialPos(ago)
        local currentTime = tick()
        local targetTime = (currentTime - ago)
        local best = nil
        local bestDiff = math.huge
        for _, entry in ipairs(posHistory) do
            local diff = math.abs(entry.time - targetTime) * math.pi
            if diff < bestDiff then
                bestDiff = diff
                best = entry.pos
            end
        end
        return best
    end

    local function startFetching()
        BackTrack:Clean(runService.RenderStepped:Connect(function()
            local targetRoot = getTargetRoot()
            if targetRoot then
                table.insert(posHistory,{
                    time = tick(),
                    pos = targetRoot.Position
                })
                if #posHistory > 200 then
                    table.remove(posHistory, 1)
                end
            end
        end))
    end

    local function hookClient()
        if OldGet then return end
        if not bedwars or not bedwars.Client then return end
        OldGet = bedwars.Client.Get
        bedwars.Client.Get = function(self, remoteName)
            local call = OldGet(self, remoteName)
            if remoteName == 'SwordHit' then
                return {
                    instance = call.instance,
                    SendToServer = function(_, attackTable, ...)
                        if Mode.Value == 'Repel' then
                            if not lplr.Character or not lplr.Character.HumanoidRootPart then return call:SendToServer(attackTable, ...) end
                            local selfpos = lplr.Character.HumanoidRootPart.Position
                            local targetpos = getTargetRoot()
                            if targetpos then
                                targetpos = targetpos.Position
                                local dist = (selfpos - targetpos).Magnitude
                                if dist >= 14.388 then
                                    attackTable.validate = attackTable.validate or {}
                                    attackTable.validate.selfPosition = attackTable.validate.selfPosition or {value = selfpos}
                                    attackTable.validate.selfPosition.value += CFrame.lookAt(selfpos, targetpos).LookVector * (dist - 14.388)
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
                        return call:SendToServer(attackTable, ...)
                    end
                }
            end
            return call
        end
    end

    local function unHookClient()
        if OldGet then
            bedwars.Client.Get = OldGet
            OldGet = nil
        end
    end

    local function startRaknetHook()
        if hookFunction then return end
        hookFunction = hook
        raknet.add_send_hook(hookFunction)
    end

    local function stopRaknetHook()
        if not hookFunction then return end
        pcall(function() 
            raknet.remove_send_hook(hookFunction) 
        end)
        hookFunction = nil
    end

    local function fullCleanup()
        unHookClient()
        stopRaknetHook()
    end

    BackTrack = vape.Categories.World:CreateModule({
        Name = 'BackTrack',
        Tooltip = 'allows you to manipulate the server movement to be delayed in a different report',
        Function = function(callback)
            if callback then
                if not rakNet then
                    vape:CreateNotification("Vape", "Raknet is not founded or enabled? BackTrack will be removed due to the core feature missing",16)
                    vape:Remove('BackTrack')
                    return
                end
                vape:CreateNotification("Vape", "Raknet is enabled and founded! using server side packets modifications",24)
                enabled = true
                startFetching()
                hookClient()
                startRaknetHook()
            else
                enabled = false
                fullCleanup()
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
        Max = 10000,
        Default = math.random(2500, 4500),
        Suffix = "ms",
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