local oldtoclipboard = getgenv().toclipboard
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
local bedwars = getgenv().bedwars
local store = getgenv().store

local CK = {}

function CK:blood_assassin(callback, module)
    
    if not module then return end
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
        module:Clean(workspace.DescendantAdded:Connect(function(child)
            if vape.ThreadFix then setthreadidentity(8) end
            if child and child.Name == 'BloodAssassinDecay' then
                pcall(function()
                    child:Destroy()
                end)
            end
        end))
        for _, child in workspace:GetDescendants() do
            if vape.ThreadFix then setthreadidentity(8) end
            if child and child.Name == 'BloodAssassinDecay' then
                pcall(function()
                    child:Destroy()
                end)
            end
        end
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
        print('caitlyn off')
    end
end

function CK:drill(callback, module)
    
    if not module then return end
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
        module:Clean(workspace.ChildAdded:Connect(function(child)
            if vape.ThreadFix then setthreadidentity(8) end
            if child and child.Name == 'Drill' then
                for _, v in child:GetDescendants() do
                    if v:IsA('BasePart') then
                        bedwars.QueryUtil:setQueryIgnored(v, true)
                    end
                end
            end
            if child and child.Name == 'diamond' or child.Name == 'gold' or child.Name == 'emerald' then
                if vape.ThreadFix then setthreadidentity(8) end
                pcall(function()
                    child:Destroy()
                end)
            end
        end))
        for _, child in workspace:GetChildren() do
            if vape.ThreadFix then setthreadidentity(8) end
            if child and child.Name == 'Drill' then
                for _, v in child:GetDescendants() do
                    if v:IsA('BasePart') then
                        bedwars.QueryUtil:setQueryIgnored(v, true)
                    end
                end
            end
            if child and child.Name == 'diamond' or child.Name == 'gold' or child.Name == 'emerald' then
                if vape.ThreadFix then setthreadidentity(8) end
                pcall(function()
                    child:Destroy()
                end)
            end
        end
    else
         store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
        for _, child in workspace:GetChildren() do
            if vape.ThreadFix then setthreadidentity(8) end
            if child and child.Name == 'Drill' then
                for _, v in child:GetDescendants() do
                    if v:IsA('BasePart') then
                        bedwars.QueryUtil:setQueryIgnored(v, false)
                    end
                end
            end
        end
    end
end

function CK:star_collector(callback, module)
    
    if not module then return end
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
        module:Clean(workspace.ChildAdded:Connect(function(child)
            if vape.ThreadFix then setthreadidentity(8) end
            if child and (child.Name == 'CritStar' or child.Name == 'VitalityStar') then
                local ID = game.HttpService:GenerateGUID(true)
                child:SetAttribute('id', ID)
                child.AnimationController:SetAttribute('id', ID)
                for _, v in child:GetDescendants() do
                    if v:IsA('BasePart') then
                        bedwars.QueryUtil:setQueryIgnored(v, true)
                        child.AnimationController.Parent = game.ReplicatedStorage
                    end
                end
            end
        end))
        for _, child in workspace:GetChildren() do
            if vape.ThreadFix then setthreadidentity(8) end
            if child and (child.Name == 'CritStar' or child.Name == 'VitalityStar') then
                local ID = game.HttpService:GenerateGUID(true)
                child:SetAttribute('id', ID)
                child.AnimationController:SetAttribute('id', ID)
                for _, v in child:GetDescendants() do
                    if v:IsA('BasePart') then
                        bedwars.QueryUtil:setQueryIgnored(v, true)
                        child.AnimationController.Parent = game.ReplicatedStorage
                    end
                end
            end
        end
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
        for _, star in workspace:GetChildren() do
            if vape.ThreadFix then
                setthreadidentity(8)
            end
            if star and (star.Name == 'CritStar' or star.Name == 'VitalityStar') then
                local id = star:GetAttribute("id")
                if id then
                    for _, v in game.ReplicatedStorage:GetChildren() do
                        if v.Name == "AnimationController" and v:GetAttribute("id") == id then
                            v.Parent = star
                            v:SetAttribute("id", nil)
                            star:SetAttribute("id", nil)
                            for _, part in star:GetDescendants() do
                                if part:IsA("BasePart") then
                                    bedwars.QueryUtil:setQueryIgnored(part, false)
                                end
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end

function CK:cat(callback, module)
    
    if not module then return end
    lplr.PlayerGui:FindFirstChild('ActionBarScreenGui'):WaitForChild('ActionBar',10):WaitForChild("CatStaminaBar",25).Visible = not callback
    if callback then
        module:Clean(workspace.DescendantAdded:Connect(function(child)
            if vape.ThreadFix then setthreadidentity(8) end
            if child and (child.Name == 'BlockRegionBox' or child.Name:find('Decay') or child.Name:find('decay')) then
                if vape.ThreadFix then setthreadidentity(8) end
                pcall(function()
                    child:Destroy()
                end)
            end
        end))
        for _, child in workspace:GetDescendants() do
            if vape.ThreadFix then setthreadidentity(8) end
            if child and (child.Name == 'BlockRegionBox' or child.Name:find('Decay') or child.Name:find('decay')) then
                if vape.ThreadFix then setthreadidentity(8) end
                pcall(function()
                    child:Destroy()
                end)
            end
        end
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
    end
end

function CK:sword_shield(callback, module)
    
    if not module then return end
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
        for _, child in lplr.Character:GetDescendants() do
            if vape.ThreadFix then setthreadidentity(8) end
            if child and (child.Name:find('Shield')) then
                if vape.ThreadFix then setthreadidentity(8) end
                pcall(function()
                    child:Destroy()
                end)
            end
        end
        module:Clean(lplr.Character.DescendantAdded:Connect(function(child)
            if vape.ThreadFix then setthreadidentity(8) end
            if child and (child.Name:find('Shield')) then
                if vape.ThreadFix then setthreadidentity(8) end
                pcall(function()
                    child:Destroy()
                end)
            end
        end))
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
    end
end

function CK:glacial_skater(callback, module)
    if not module then return end
    lplr.PlayerGui.ActionBarScreenGui.ActionBar.MomentumBarUi.Visible = not callback
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
        module:Clean(lplr.PlayerGui.StatusEffectHudScreen.StatusEffectHud.ChildAdded:Connect(function(child)
            if child and (child.Name == 'On Ice' or child.Name == 'High Speed Skating') then
                pcall(function()
                    child:Destroy()
                end)
            end
        end))
        for _, child in StatusEffectHudScreen.StatusEffectHud:GetChildren() do
            if child and (child.Name == 'On Ice' or child.Name == 'High Speed Skating') then
                pcall(function()
                    child:Destroy()
                end)
            end
        end
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
    end
end

function CK:defender(callback, module)
    local old = {}
    if not module then return end
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
        for _, child in workspace:GetDescendants() do
            if child and (child.Name == 'DefenderSchematicBlock' or child.Name == 'DefenderCustomBlockHighlight') then
                child.Transparency = 0
            end
            if child and (child.Name == 'DefenderBlockPopup') then
                for _, v in child:GetChildren() do
                    v.Visible = (v.Name == 'Cost')
                end
            end
        end
        module:Clean(workspace.DescendantAdded:Connect(function(child)
            if child and (child.Name == 'DefenderSchematicBlock' or child.Name == 'DefenderCustomBlockHighlight') then
                child.Transparency = 0
            end
            if child and (child.Name == 'DefenderBlockPopup') then
                for _, v in child:GetChildren() do
                    v.Visible = (v.Name == 'Cost')
                end
            end
        end))
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
        for _, child in workspace:GetDescendants() do
            if child and (child.Name == 'DefenderSchematicBlock' or child.Name == 'DefenderCustomBlockHighlight') then
                child.Transparency = 0.95
            end
            if child and (child.Name == 'DefenderBlockPopup') then
                for _, v in child:GetChildren() do
                    v.Visible = true
                end
            end
        end
    end
end

function CK:berserker(callback, module)
    if not module then return end
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
        for _, child in lplr.Character:GetDescendants() do
            if child and (child.Name == 'BerserkerRageEffect') then
                child:Destroy()
            end
        end
        module:Clean(lplr.Character.ChildAdded:Connect(function(child)
            if child and (child.Name == 'BerserkerRageEffect') then
                child:Destroy()
            end
        end))
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
    end
end

--[[
function CK:(callback, module)
    
    if not module then return end
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
    end
end

--[[
function CK:(callback, module)
    
    if not module then return end
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
    end
end


function CK:(callback, module)
    
    if not module then return end
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
    end
end

function CK:(callback, module)
    
    if not module then return end
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
    end
end

function CK:(callback, module)
    
    if not module then return end
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
    end
end


function CK:(callback, module)
    
    if not module then return end
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
    end
end

function CK:(callback, module)
    
    if not module then return end
    if callback then
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = true
    else
        store.CleanKit[lplr:GetAttribute('PlayingAsKits') or 'none'] = false
    end
end
--]]


run(function()
    local CleanKit
    
    CleanKit = vape.Categories.Render:CreateModule({
        Name = 'Clean Kit',
        Function = function(callback)
            local suc, res = pcall(function()
                return CK[lplr:GetAttribute("PlayingAsKits") or 'none'](CK, callback, CleanKit)
            end)

            if not suc then
                print('failed', res)
            end
        end
    })
end)
task.spawn(function()
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
end)