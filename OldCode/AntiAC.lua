--[[ this is all skidded from AntiAC script leaked code
]]--
local lplr = game.Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local repstorage = game:GetService("ReplicatedStorage")

local getremote = function(tab)
    for i,v in pairs(tab) do
        if v == "Client" then
            return tab[i + 1]
        end
    end
    return ""
end



local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
local modules = {}
local replicatedStorageService = game:GetService("ReplicatedStorage")
local bedwars
-- local damage = require(lplr.PlayerScripts.TS.controllers.global.damage["damage-indicator-controller"]).DamageIndicatorController
bedwars = {
    ItemTable = debug.getupvalue(require(replicatedStorageService.TS.item["item-meta"]).getItemMeta, 1),
    SoundList = require(replicatedStorageService.TS.sound["game-sound"]).GameSound,
    SoundManager = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).SoundManager,
    DropItemRemote = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand)),
    SprintController = KnitClient.Controllers.SprintController,
    CombatConstant = require(repstorage.TS.combat["combat-constant"]).CombatConstant,
    KnockbackUtil = require(replicatedStorageService.TS.damage["knockback-util"]).KnockbackUtil,
    ClientHandlerStore = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
    PingController = require(lplr.PlayerScripts.TS.controllers.game.ping["ping-controller"]).PingController,
    SwordController = KnitClient.Controllers.SwordController,
    ViewmodelController = KnitClient.Controllers.ViewmodelController,
    ClientHandler = Client,
    AppController = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController,
    SwordRemote = getremote(debug.getconstants((KnitClient.Controllers.SwordController).attackEntity)),
    ProjectileController = KnitClient.Controllers.ProjectileController,
    CpsConstants = require(game:GetService("ReplicatedStorage").TS["shared-constants"]).CpsConstants,
}
local KnockbackTable = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
local RunService = game:GetService("RunService")

local knitRecieved, knit

local Library = loadstring(game:HttpGet("https://pastebin.com/raw/vff1bQ9F"))()
local Window = Library.CreateLib("Skidded script", "Midnight")

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="Skidded script";
    Text="Skiddee script has been injected";
    Duration=3;
})

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="Skidded script";
    Text="Skiddee script has a lot skidded and made my own stuff";
    Duration=3;
})


game:GetService("Chat"):SetBubbleChatSettings({
          BackgroundColor3 = Color3.fromRGB(15,15,15),
          TextColor3 = Color3.fromRGB(255,165,0)
 })

local function getSword()
    local bestSword, bestSwordSlot, bestSwordDamage = nil, nil, 0
    for slot, item in pairs(bedwars.ClientHandlerStore:getState().Inventory.observedInventory.inventory.items) do
        local swordMeta = bedwars.ItemTable[item.itemType].sword
        if swordMeta then
            local swordDamage = swordMeta.damage or 0
            if swordDamage > bestSwordDamage then
                bestSword, bestSwordSlot, bestSwordDamage = item, slot, swordDamage
            end
        end
    end
    return bestSword, bestSwordSlot
end

local Combat = Window:NewTab("Combat")
local Movement = Window:NewTab("Movement")
local Visuals = Window:NewTab("Visuals")
local Utility = Window:NewTab("Utility")

local CombatSection = Combat:NewSection("General")
local MovementSection = Movement:NewSection("General")
local VisualsSection = Visuals:NewSection("General")
local UtilitySection = Utility:NewSection("PlayerAnnoyer")

--folders
makefolder("Skiddd script")
makefolder("Skidded script/assets")




local function chat(msg)
	local args = {
		[1] = msg,
		[2] = "All"
	}

game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))

end

--Combat

local AuraRemote = bedwars.ClientHandler:Get("SwordHit")

CombatSection:NewToggle("Aura", "so funny", function(state)
    if state then
        local lplr = game:GetService("Players").LocalPlayer
        spawn(function()
            while state do
                lplr = game:GetService("Players").LocalPlayer
                
                if lplr.Character and lplr.Character:FindFirstChild("Humanoid") and lplr.Character.Humanoid.Health > 0 then
                    local sword = getSword()
                    for i,v in pairs(game:GetService("Players"):GetChildren()) do
                        if v ~= lplr then
                            if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                                if (v.Character:GetPivot().Position - lplr.Character:GetPivot().Position).Magnitude <= 30 then
                                    for _ = 1, 10, 1 do
                                        AuraRemote:SendToServer({
                                            ["entityInstance"] = v.Character,
                                            ["chargedAttack"] = {
                                                ["chargeRatio"] = 0,
                                            },
                                            ["validate"] = {
                                                ["selfPosition"] = {
                                                    ["value"] = (lplr.Character:GetPivot() * CFrame.new(0, 2, -8)).Position
                                                },
                                                ["targetPosition"] = {
                                                    ["value"] = v.Character:GetPivot().Position
                                                },
                                            },
                                            ["weapon"] = sword.tool,
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
                game:GetService("RunService").Heartbeat:Wait()
            end
        end)
    end
end)



local lplr = game:GetService("Players").LocalPlayer
local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
local bedwars = {
    DamageIndicator = KnitClient.Controllers.DamageIndicatorController.spawnDamageIndicator
}
local Messages = {"OH YES DADDY","Go in a little harder","Fuck me more","HARDER HARDER","That pussy is getting weak","common you can do better","Use Skidded script","your dog shit "}
CombatSection:NewToggle("DamageIndicator", "so funny", function(state)
if state then
    spawn(function()
            debug.setupvalue(bedwars["DamageIndicator"],10,{
                Create = function(self,obj,...)
                     obj.Parent.Text = Messages[math.random(1, #Messages)]
                     obj.Parent.Font = Enum.Font.GothamBlack
                     obj.Parent.TextColor3 = Color3.fromRGB(255,165,0)
                 end
            })
        end)
     end
end)



local oldSprintFunc = {}
CombatSection:NewToggle("AutoSprint", "sprinting automaticly", function(state)
    if state then
        bedwars["SprintController"]:startSprinting()
        -- oldSprintFunc[1] = bedwars["SprintController"].startSprinting
        -- oldSprintFunc[2] = bedwars["SprintController"].stopSprinting
        -- bedwars["SprintController"].sprinting = true
        -- bedwars["SprintController"].attemptingSprint = true
        -- lplr:SetAttribute("Sprinting", true)
        -- bedwars["SprintController"]:setSpeed(20)
    else
        bedwars["SprintController"]:stopSprinting()
    end
end)

local applyKnockback
CombatSection:NewToggle("Velocity", "makes you take no knock back", function(state)
    if state then
        applyKnockback = bedwars.KnockbackUtil.applyKnockback
		bedwars.KnockbackUtil.applyKnockback = function()
            speed += 6
            speedtick = tick() + .8
			return nil
		end
    else
        bedwars.KnockbackUtil.applyKnockback = applyKnockback
    end
end)


--Movement

MovementSection:NewButton("infjump", "ButtonInfo", function()
game.UserInputService.JumpRequest:Connect(function()
  game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
end)
end)

MovementSection:NewButton("funny exploit", "ButtonInfo", function()
while task.wait() do
    for i,v in next, Bedwars["InventoryUtil"].getInventory(lplr).items do 
        Bedwars['ClientHandler']:Get("SetInvItem"):CallServerAsync({
            ["hand"]  = v.tool
        })
    end
end
end)

local speedTgl = false
local speed = 23
local goodSpeed = speed
local speedtick = tick()
MovementSection:NewToggle("Speed", "Speed", function(state)
    speedTgl = state
	if state then
        task.spawn(function()
            repeat
                if speedtick <= tick() then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = goodSpeed
                else
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
                end
                task.wait()
            until not speedTgl
        end)
	else
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 14
	end
end)



MovementSection:NewLabel("Keybinds")

MovementSection:NewKeybind("infFly", "KeybindInfo", Enum.KeyCode.F, function()
	local lplr = game:GetService("Players").LocalPlayer

local tween
local clone
local clonehrp
local part

lplr.Character.Archivable = true
clone = lplr.Character:Clone()
clonehrp = clone:WaitForChild("HumanoidRootPart")
clone.Parent = workspace
getgenv().loop = true -- change to false to disable

if getgenv().loop == true then
    part = Instance.new("Part")
    part.Parent = workspace
    part.Size = Vector3.new(3,0,3)
    part.Anchored = true
    part.Transparency = 1
    part.CFrame = clone.HumanoidRootPart.CFrame * CFrame.new(0,-3,0)
    game:GetService("Workspace").Camera.CameraSubject = clone.Humanoid
    clone.Parent = lplr.Character
end


local rayparms = RaycastParams.new()
rayparms.FilterDescendantsInstances = {workspace.Map}
rayparms.FilterType = Enum.RaycastFilterType.Whitelist
while getgenv().loop == true do
    task.wait()
    if getgenv().loop == true then
        part.CFrame = clone.HumanoidRootPart.CFrame * CFrame.new(0,-3,0)
        if tonumber(50000) > tonumber(lplr.Character.HumanoidRootPart.CFrame.Y) then
            lplr.Character.HumanoidRootPart.CFrame *= CFrame.new(0,5000,0)
        end
        clonehrp.CFrame = CFrame.new(lplr.Character.HumanoidRootPart.CFrame.x, clone.HumanoidRootPart.CFrame.Y, lplr.Character.HumanoidRootPart.CFrame.Z)
    else
        lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame * CFrame.new(0,clone.HumanoidRootPart.CFrame.Y,0)
        game:GetService("Workspace").Camera.CameraSubject = lplr.Character.Humanoid
        local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, Vector3.new(0,-50000,0), rayparms)
        if ray then
            task.wait(0.24)
            lplr.Character.HumanoidRootPart.CFrame = CFrame.new(ray.Position)
            task.wait(0.1)
        else
            lplr.Character.HumanoidRootPart.CFrame = clone.HumanoidRootPart.CFrame
        end
        part:Destroy()
        lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end
end
end)



local flytgl = false
MovementSection:NewKeybind("Fly", "KeybindInfo", Enum.KeyCode.R, function()
	flytgl = not flytgl
    if flytgl then
        task.spawn(function()
            repeat
                game.Workspace.Gravity = 0
                task.wait()
            until not flytgl
            game.Workspace.Gravity = 192.6
        end)
    end
end)



MovementSection:NewKeybind("Highjump", "Highjump", Enum.KeyCode.H, function()
	local Velocity = Instance.new("BodyVelocity",game.Players.LocalPlayer.Character.HumanoidRootPart)
	Velocity.Name = "Velocity1"
	game.Workspace.Gravity = 0
	Velocity.Velocity = Vector3.new(0,500,0)
	wait(1.6)
	game.Workspace.Gravity = 192.6
	game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity1:Destroy()
end)

MovementSection:NewKeybind("deathTp", "KeybindInfo", Enum.KeyCode.P, function()
    local lplr = game:GetService("Players").LocalPlayer
                    local NewPos = lplr.Character:FindFirstChild("HumanoidRootPart").CFrame
                    local plr = game:GetService("Players").LocalPlayer
                    lplr.Character:FindFirstChild("Humanoid").Health = 0 
                    lplr.CharacterAdded:wait()
                    spawn(function()
                        repeat
                        task.wait()
                            until (lplr.Character:WaitForChild("HumanoidRootPart"))
                        end)
                        local TS = game:GetService("TweenService")
                            for i = 1, 1 do
                                task.wait()
                                    local Prim = lplr.Character and lplr.Character:WaitForChild("HumanoidRootPart").CFrame
                                        local tween = TS:Create(lplr.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(1), {CFrame = (NewPos)})
                                        tween:play()
                                        tween.Completed:Wait()
                          end
end)

--Visuals

VisualsSection:NewKeybind("Toggle Ui", "Toggle Ui", Enum.KeyCode.RightShift, function()
	Library:ToggleUI()
end)

VisualsSection:NewToggle("Outline Item", "", function(v)
    if v then
        repeat
            task.wait()
            for i,v in pairs(game:GetService("Workspace").Camera.Viewmodel:GetChildren()) do
                if (v:IsA("Accessory")) then
                    if v:FindFirstChild("Handle") then
                        if v:FindFirstChild("Handle"):FindFirstChild("ItemOutline") then
                            task.wait()
                        else
                            local OutLine = Instance.new("Highlight", v:FindFirstChild("Handle"))
                            OutLine.Enabled = true
                            OutLine.FillTransparency = 1
                            OutLine.Name = "ItemOutline"
                        end
                        if v:FindFirstChild("Handle"):FindFirstChild("ItemOutline") then
                            v:FindFirstChild("Handle"):FindFirstChild("ItemOutline").OutlineColor = Color3.fromHSV(0,1,0) -- Color
                        end
                    end
                end
            end
        until (not v)
    else
        for i,v in pairs(game:GetService("Workspace").Camera.Viewmodel:GetChildren()) do
            if (v:IsA("Accessory")) then
                if v:FindFirstChild("Handle"):FindFirstChild("ItemOutline") then
                    v:FindFirstChild("Handle"):FindFirstChild("ItemOutline"):Destroy()
                end
            end
        end
    end
end)

VisualsSection:NewButton("Game theme", "ButtonInfo", function()
game.Lighting.Ambient = Color3.fromRGB(255,165,0)
end)

VisualsSection:NewButton("ping", "", function()
        local textlab = Instance.new("TextLabel")
        textlab.Size = UDim2.new(0, 200, 0, 28)
        textlab.BackgroundTransparency = 1
        textlab.TextColor3 = Color3.new(1, 1, 1)
        textlab.TextStrokeTransparency = 0
        textlab.TextStrokeColor3 = Color3.new(0.24, 0.24, 0.24)
        textlab.Font = Enum.Font.SourceSans
        textlab.TextSize = 28
        textlab.Text = "1 ping"
        textlab.BackgroundColor3 = Color3.new(0, 0, 0)
        textlab.Position = UDim2.new(1, -254, 0, 0)
        textlab.TextXAlignment = Enum.TextXAlignment.Right
        textlab.BorderSizePixel = 0
        textlab.Parent = game.CoreGui.RobloxGui
        spawn(function()
            repeat
                wait(1)
                local ping = tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue())
                ping = math.floor(ping)
                textlab.Text = ping.." ping"
            until textlab == nil
        end)

end)



VisualsSection:NewButton("Chams", "", function()
    for i,v in pairs(game.Players:GetPlayers()) do
        local cham = Instance.new("Highlight",v.Character)
    end
end)



VisualsSection:NewButton("RGB", "ButtonInfo", function()
-- the definition of messy code
    local path = workspace.CurrentCamera.Viewmodel:FindFirstChildWhichIsA("Accessory"):FindFirstChild("Handle")
  workspace.CurrentCamera.Viewmodel.ChildAdded:Connect(function(e)
if e:IsA("Accessory") then
path = e:WaitForChild("Handle")
path.TextureID = ""
path.Material = Enum.Material.Neon
end
end)

if path then
   path.TextureID = ""
   path.Material = Enum.Material.Neon
end
    local speed = .9

while true do
    for i = 0,1,0.001 * speed do
        path.Color = Color3.fromHSV(i,1,1)
        wait()
    end
task.wait()
end
end)



local fov
VisualsSection:NewSlider("Fov", "SliderInfo", 120, 70, function(s) -- 120 (MaxValue) 
    if not fov then
        -- bedwars["SprintController"].startSprinting = nil
        game:GetService("RunService").PreRender:Connect(function()
            workspace.CurrentCamera.FieldOfView = fov or s
        end)
    end
    fov = s
end)

--Utility


local currentEventVal
UtilitySection:NewDropdown("PlayerAnnoyer", "DropdownInf", {"Party popper", "DragonBreath", "Yuzi"}, function(opt)
    currentEventVal = opt
end)
task.spawn(function()
local opt -- lazy gay line
while true do
opt = currentEventVal
if opt == "Party popper" then
        game:GetService("ReplicatedStorage")["events-@easy-games/game-core:shared/game-core-networking@getEvents.Events"].useAbility:FireServer("PARTY_POPPER")
    end

    if opt == "DragonBreath" then
        local args = {
            [1] = {
                ["player"] = game:GetService("Players").LocalPlayer
            }
        }

        game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.DragonBreath:FireServer(unpack(args))
    end

    if opt == "Yuzi" then
        game:GetService("ReplicatedStorage"):FindFirstChild("events-@easy-games/game-core:shared/game-core-networking@getEvents.Events").useAbility:FireServer(unpack(args))
    end
task.wait()
end
end)



UtilitySection:NewLabel("ChatSpammer")
local spam = "Skidded script script on top " --Default spam here
local SpammerEnabled = false

UtilitySection:NewToggle("ChatSpammer", "", function(state)
    if state then
        SpammerEnabled = true
        repeat task.wait(1)
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(spam,"All")
        until not SpammerEnabled
    else
         RemoveModule("ChatSpammer")
        SpammerEnabled = false
    end
end)


UtilitySection:NewTextBox("Chat spammer text", "allows this to go to chat spammer", function(txt)
    spam = txt
end)

setfpscap(1000)

UtilitySection:NewLabel("AntiVoid")
local transparancy
local colorval = Color3.fromRGB(22, 50, 222)
UtilitySection:NewToggle("AntiVoid", "Antivoid", function(state)
    if state then
        local e = Instance.new("Part",workspace)
        e.Size = Vector3.new(999999999999, 2, 999999999999)
        e.Position = Vector3.new(0, 20, 0)
        e.Anchored = true
        e.BrickColor = BrickColor.new("Royal purple")


        local function PlayerTouched(Part)
            local Parent = Part.Parent
            if game.Players:GetPlayerFromCharacter(Parent) then
                for i = 1, 3, 1 do
                    task.wait(.1)
                    Parent.HumanoidRootPart.CFrame = Parent.HumanoidRootPart.CFrame + Vector3.new(0, 25 * i, 0)
                end

            end
        end

        e.Touched:connect(PlayerTouched)
        while true do
            e.Transparency = transparancy
            wait()
        end
    else
        game.Workspace.Part:Destroy()
    end
end)

UtilitySection:NewSlider("Transparancy", "", 100, 0, function(s) -- 500 (MaxValue) | 0 (MinValue)
    local value = "0." .. tostring(s)
    transparancy = value
    if s == 100 then
        transparancy = 1
    end
end)

UtilitySection:NewLabel("Bed nuker")

UtilitySection:NewToggle("Bed nuker", "ToggleInfo", function(state)
    if state then
local lplr = game:GetService("Players").LocalPlayer

function nukepos(pos)
    local xval = math.round(pos.X/3)
    local yval = math.round(pos.Y/3)
    local zval = math.round(pos.Z/3)
    return Vector3.new(xval, yval, zval)
end

getgenv().nuker = true

while getgenv().nuker == true do
task.wait(0.4)
    for i,v in next, game:GetService("Workspace"):GetDescendants() do
        if v.Name == "bed" and v:FindFirstChild("Covers") and v:FindFirstChild("Covers").BrickColor ~= lplr.Team.TeamColor then   
            task.wait()
            if lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Humanoid").Health > 0 then
                local mag = (v.Position - lplr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
                if mag < 26 then
                    game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.DamageBlock:InvokeServer({
                        ["blockRef"] = {
                            ["blockPosition"] = nukepos(v.Position)
                        },
                        ["hitPosition"] = nukepos(v.Position),
                        ["hitNormal"] = nukepos(v.Position)
                    })
                end
            end
        end
    end
end
end
end)

UtilitySection:NewLabel("NoFall")


local nofall
UtilitySection:NewToggle("Nofall", "makes you take no fall damage", function(state)
    if state then
        nofall = true
        task.spawn(function()
          while nofall do
              task.wait(.1)
              game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit:FireServer()
          end
        end)
    else
        nofall = false
    end
end)


game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage",{
        Text = "Skidded script",
        Color = Color3.fromRGB(255,200,65),
        Font = Enum.Font.SourceSansBold,
    })
   