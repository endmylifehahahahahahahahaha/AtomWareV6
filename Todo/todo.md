Implement these features:

Please note some features are tooken from other projects with different librarys, or liek differently named things. Just make sure you integrate it succesfully.


----
VapePrivateDetector:

run(function() local VapePrivateDetector = {Enabled = false}
	local VPLeave = {Enabled = false}
	local alreadydetected = {}
	VapePrivateDetector = GuiLibrary.ObjectsThatCanBeSaved.VoidwareWindow.Api.CreateOptionsButton({
		Name = "VapePrivateDetector",
		Function = function(callback)
			if callback then
				task.spawn(function()
					if not shared.vapewhitelist.loaded then 
						repeat task.wait() until shared.vapewhitelist.loaded or not VapePrivateDetector.Enabled
					end
					if not VapePrivateDetector.Enabled then 
						return 
					end
					for i,v in pairs(playersService:GetPlayers()) do
						if v ~= lplr then
							local rank = shared.vapewhitelist:get(v)
							if rank > 0 and not table.find(alreadydetected, v) then
								local rankstring = rank == 1 and "Private Member" or rank > 1 and "Owner"
								warningNotification("VapePrivateDetector", "Vape "..rankstring.." Detected! | "..v.DisplayName, 120)
								table.insert(alreadydetected, v)
								if VPLeave.Enabled then
									local newserver = nil
									repeat newserver = findnewserver() until newserver 
									game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, newserver, lplr)
								end
							end
						end
					end
					table.insert(VapePrivateDetector.Connections, playersService.PlayerAdded:Connect(function(v)
						local rank = shared.vapewhitelist:get(v)
						if rank > 0 and not table.find(alreadydetected, v) then
						local rankstring = rank == 1 and "Private Member" or rank > 1 and "Owner"
						warningNotification("VapePrivateDetector", "Vape "..rankstring.." Detected! | "..v.DisplayName, 120)
						table.insert(alreadydetected, v)
						if VPLeave.Enabled then
							local newserver = nil
							repeat newserver = findnewserver() until newserver 
							game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, newserver, lplr)
						end
						end 
					end))
				end)
			end
		end
	})
	VPLeave = VapePrivateDetector.CreateToggle({
		Name = "ServerHop",
		HoverText = "switches servers on detection.",
		Function = function() end
	})
	--[[task.spawn(function()
		repeat task.wait() until shared.vapewhitelist.loaded 
		if shared.vapewhitelist:get(lplr) ~= 0 then 
			pcall(GuiLibrary.RemoveObject, "VapePrivateDetectorOptionsButton")
		end
	end)--]]
end)

------------------------------------

replace custom animations for the killaura with this:


	local anims = {
		Normal = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.05},
			{CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.05}
		},
		Slow = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.15},
			{CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.15}
		},
		New = {
			{CFrame = CFrame.new(0.69, -0.77, 1.47) * CFrame.Angles(math.rad(-33), math.rad(57), math.rad(-81)), Time = 0.12},
			{CFrame = CFrame.new(0.74, -0.92, 0.88) * CFrame.Angles(math.rad(147), math.rad(71), math.rad(53)), Time = 0.12}
		},
		Latest = {
			{CFrame = CFrame.new(0.69, -0.7, 0.1) * CFrame.Angles(math.rad(-65), math.rad(55), math.rad(-51)), Time = 0.1},
			{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(-179), math.rad(54), math.rad(33)), Time = 0.1}
		},
		["Vertical Spin"] = {
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), math.rad(8), math.rad(5)), Time = 0.1},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(180), math.rad(3), math.rad(13)), Time = 0.1},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(90), math.rad(-5), math.rad(8)), Time = 0.1},
			{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(-0), math.rad(-0)), Time = 0.1}
		},
		Exhibition = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.1},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2}
		},
		["Exhibition Old"] = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.15},
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.05},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.1},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.05},
			{CFrame = CFrame.new(0.63, -0.1, 1.37) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.15}
		}
	}


   -------------


Implement these features :


run(function()
    local GuiLibrary = shared.GuiLibrary
	local texture_pack = {};
	texture_pack = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = 'TexturePack',
		HoverText = 'Customizes your texture pack.',
		Function = function(callback)
			if callback then
				if not shared.VapeSwitchServers then
					warningNotification("TexturePack - Credits", "Credits to melo and star", 1.5)
				end
				if texture_pack_m.Value == 'Noboline' then
					local Players = game:GetService("Players")
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local Workspace = game:GetService("Workspace")
					local objs = game:GetObjects("rbxassetid://13988978091")
					local import = objs[1]
					import.Parent = game:GetService("ReplicatedStorage")
					local index = {
						{
							name = "wood_sword",
							offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
							model = import:WaitForChild("Wood_Sword"),
						},
						{
							name = "stone_sword",
							offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
							model = import:WaitForChild("Stone_Sword"),
						},
						{
							name = "iron_sword",
							offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
							model = import:WaitForChild("Iron_Sword"),
						},
						{
							name = "diamond_sword",
							offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
							model = import:WaitForChild("Diamond_Sword"),
						},
						{
							name = "emerald_sword",
							offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
							model = import:WaitForChild("Emerald_Sword"),
						},
						{
							name = "wood_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
							model = import:WaitForChild("Wood_Pickaxe"),
						},
						{
							name = "stone_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
							model = import:WaitForChild("Stone_Pickaxe"),
						},
						{
							name = "iron_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
							model = import:WaitForChild("Iron_Pickaxe"),
						},
						{
							name = "diamond_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)),
							model = import:WaitForChild("Diamond_Pickaxe"),
						},
						{
							name = "wood_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
							model = import:WaitForChild("Wood_Axe"),
						},
						{
							name = "stone_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
							model = import:WaitForChild("Stone_Axe"),
						},
						{
							name = "iron_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
							model = import:WaitForChild("Iron_Axe"),
						},
						{
							name = "diamond_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-95)),
							model = import:WaitForChild("Diamond_Axe"),
						},
					}
					local func = Workspace.Camera.Viewmodel.ChildAdded:Connect(function(tool)
						if not tool:IsA("Accessory") then
							return
						end
						for _, v in ipairs(index) do
							if v.name == tool.Name then
								for _, part in ipairs(tool:GetDescendants()) do
									if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
										part.Transparency = 1
									end
								end
								local model = v.model:Clone()
								model.CFrame = tool.Handle.CFrame * v.offset
								model.CFrame = model.CFrame * CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
								model.Parent = tool
								local weld = Instance.new("WeldConstraint")
								weld.Part0 = model
								weld.Part1 = tool.Handle
								weld.Parent = model
								local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
								for _, part in ipairs(tool2:GetDescendants()) do
									if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
										part.Transparency = 1
										if part.Name == "Handle" then
											part.Transparency = 0
										end
									end
								end
							end
						end
					end)
				elseif texture_pack_m.Value == 'Aquarium' then
					local objs = game:GetObjects("rbxassetid://14217388022")
					local import = objs[1]
					
					import.Parent = game:GetService("ReplicatedStorage")
					
					local index = {
					
						{
							name = "wood_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Wood_Sword"),
						},
						
						{
							name = "stone_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Stone_Sword"),
						},
						
						{
							name = "iron_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Iron_Sword"),
						},
						
						{
							name = "diamond_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Diamond_Sword"),
						},
						
						{
							name = "emerald_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Diamond_Sword"),
						},
						
						{
							name = "Rageblade",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Diamond_Sword"),
						},
						
					}
					
					local func = Workspace:WaitForChild("Camera").Viewmodel.ChildAdded:Connect(function(tool)
						
						if(not tool:IsA("Accessory")) then return end
						
						for i,v in pairs(index) do
						
							if(v.name == tool.Name) then
							
								for i,v in pairs(tool:GetDescendants()) do
						
									if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
										
										v.Transparency = 1
										
									end
								
								end
							
								local model = v.model:Clone()
								model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
								model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
								model.Parent = tool
								
								local weld = Instance.new("WeldConstraint",model)
								weld.Part0 = model
								weld.Part1 = tool:WaitForChild("Handle")
								
								local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
								
								for i,v in pairs(tool2:GetDescendants()) do
						
									if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
										
										v.Transparency = 1
										
									end
								
								end
								
								local model2 = v.model:Clone()
								model2.Anchored = false
								model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
								model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
								model2.CFrame *= CFrame.new(0.4,0,-.9)
								model2.Parent = tool2
								
								local weld2 = Instance.new("WeldConstraint",model)
								weld2.Part0 = model2
								weld2.Part1 = tool2:WaitForChild("Handle")
							
							end
						
						end
						
					end)
				else
					local Players = game:GetService("Players")
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local Workspace = game:GetService("Workspace")
					local objs = game:GetObjects("rbxassetid://14356045010")
					local import = objs[1]
					import.Parent = game:GetService("ReplicatedStorage")
					index = {
						{
							name = "wood_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Wood_Sword"),
						},
						{
							name = "stone_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Stone_Sword"),
						},
						{
							name = "iron_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Iron_Sword"),
						},
						{
							name = "diamond_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Diamond_Sword"),
						},
						{
							name = "emerald_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Emerald_Sword"),
						}, 
						{
							name = "rageblade",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(90)),
							model = import:WaitForChild("Rageblade"),
						}, 
						   {
							name = "fireball",
									offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
							model = import:WaitForChild("Fireball"),
						}, 
						{
							name = "telepearl",
									offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
							model = import:WaitForChild("Telepearl"),
						}, 
						{
							name = "wood_bow",
							offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
							model = import:WaitForChild("Bow"),
						},
						{
							name = "wood_crossbow",
							offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
							model = import:WaitForChild("Crossbow"),
						},
						{
							name = "tactical_crossbow",
							offset = CFrame.Angles(math.rad(0), math.rad(180), math.rad(-90)),
							model = import:WaitForChild("Crossbow"),
						},
							{
							name = "wood_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
							model = import:WaitForChild("Wood_Pickaxe"),
						},
						{
							name = "stone_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
							model = import:WaitForChild("Stone_Pickaxe"),
						},
						{
							name = "iron_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
							model = import:WaitForChild("Iron_Pickaxe"),
						},
						{
							name = "diamond_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)),
							model = import:WaitForChild("Diamond_Pickaxe"),
						},
					   {
								  
							name = "wood_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
							model = import:WaitForChild("Wood_Axe"),
						},
						{
							name = "stone_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
							model = import:WaitForChild("Stone_Axe"),
						},
						{
							name = "iron_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
							model = import:WaitForChild("Iron_Axe"),
						 },
						 {
							name = "diamond_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-95)),
							model = import:WaitForChild("Diamond_Axe"),
						 },
					
					
					
					 }
					local func = Workspace:WaitForChild("Camera").Viewmodel.ChildAdded:Connect(function(tool)
						if(not tool:IsA("Accessory")) then return end
						for i,v in pairs(index) do
							if(v.name == tool.Name) then
								for i,v in pairs(tool:GetDescendants()) do
									if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
										v.Transparency = 1
									end
								end
								local model = v.model:Clone()
								model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
								model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
								model.Parent = tool
								local weld = Instance.new("WeldConstraint",model)
								weld.Part0 = model
								weld.Part1 = tool:WaitForChild("Handle")
								local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
								for i,v in pairs(tool2:GetDescendants()) do
									if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
										v.Transparency = 1
									end
								end
								local model2 = v.model:Clone()
								model2.Anchored = false
								model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
								model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
								model2.CFrame *= CFrame.new(.7,0,-.8)
								model2.Parent = tool2
								local weld2 = Instance.new("WeldConstraint",model)
								weld2.Part0 = model2
								weld2.Part1 = tool2:WaitForChild("Handle")
							end
						end
					end)
				end
			end
		end
	})
	texture_pack_m = texture_pack.CreateDropdown({
		Name = 'Mode',
		List = {
			'Noboline',
			'Aquarium',
			'Ocean'
		},
		Default = 'Noboline',
		HoverText = 'Mode to render the texture pack.',
		Function = function() end;
	});
	local Credits
	Credits = texture_pack.CreateCredits({
        Name = 'CreditsButtonInstance',
        Credits = 'Melo and Star'
    })
end)

run(function()
    local TexturePacksV2 = {Enabled = false}
    local TexturePacksV2_Connections = {}
    local TexturePacksV2_GUI_Elements = {
        Material = {Value = "Forcefield"},
        Color = {Hue = 0, Sat = 0, Value = 0},
        GuiSync = {Enabled = false}
    }

    local function refreshChild(child, children)
        if (not child) then return warn("[refreshChild]: invalid child!") end
        if (not table.find(children, child)) then table.insert(children, child) end
        if child.ClassName == "Accessory" then
            for i, v in pairs(child:GetChildren()) do
                if v.ClassName == "MeshPart" then
                    --v.Material = Enum.Material[TexturePacksV2_GUI_Elements.Material.Value]
					v.Material = Enum.Material.ForceField
                    if TexturePacksV2_GUI_Elements.GuiSync.Enabled and TexturePacksV2.Enabled then
                        if shared.RiseMode and GuiLibrary.GUICoreColor and GuiLibrary.GUICoreColorChanged then
                            v.Color = GuiLibrary.GUICoreColor
                            GuiLibrary.GUICoreColorChanged.Event:Connect(function()
                                if TexturePacksV2_GUI_Elements.GuiSync.Enabled then v.Color = GuiLibrary.GUICoreColor end
                            end)
                        else
                            local color = GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api
                            v.Color = Color3.fromHSV(color.Hue, color.Sat, color.Value)
                            VoidwareFunctions.Connections:register(VoidwareFunctions.Controllers:get("UpdateUI").UIUpdate.Event:Connect(function(h, s, v)
                                if TexturePacksV2_GUI_Elements.GuiSync.Enabled and TexturePacksV2.Enabled then
                                    local color = GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api
                                    v.Color = Color3.fromHSV(color.Hue, color.Sat, color.Value)
                                    if TexturePacksV2.Enabled then
                                        color = {Hue = h, Sat = s, Value = v}
                                        v.Color = Color3.fromHSV(color.Hue, color.Sat, color.Value)
                                    end
                                end
                            end))
                        end
                    else
                        v.Color = Color3.fromHSV(TexturePacksV2_GUI_Elements.Color.Hue, TexturePacksV2_GUI_Elements.Color.Sat, TexturePacksV2_GUI_Elements.Color.Value)
                    end
                end
            end
        end
    end

    local function refreshChildren()
        local children = gameCamera and gameCamera:FindFirstChild("Viewmodel") and gameCamera:FindFirstChild("Viewmodel").ClassName and gameCamera:FindFirstChild("Viewmodel").ClassName == "Model" and gameCamera:FindFirstChild("Viewmodel"):GetChildren() or {}
        for i, v in pairs(children) do refreshChild(v, children) end
    end

    TexturePacksV2 = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
        Name = "TexturePacksV2",
        Function = function(call)
            if call then
                task.spawn(function()
                    repeat
                        refreshChildren()
                        task.wait()
                    until (not TexturePacksV2.Enabled)
                end)
            else
                for i, v in pairs(TexturePacksV2_Connections) do
                    pcall(function() v:Disconnect() end)
                end
            end
        end
    })

    TexturePacksV2.Restart = function()
        if TexturePacksV2.Enabled then
            TexturePacksV2.ToggleButton(false)
            TexturePacksV2.ToggleButton(false)
        end
    end

    TexturePacksV2_GUI_Elements.Material = TexturePacksV2.CreateDropdown({
        Name = "Material",
        Function = refreshChildren,
        List = GetEnumItems("Material"),
        Default = "Forcefield"
    })
	TexturePacksV2_GUI_Elements.Material.Object.Visible = false

    TexturePacksV2_GUI_Elements.Color = TexturePacksV2.CreateColorSlider({
        Name = "Color",
        Function = refreshChildren
    })

    TexturePacksV2_GUI_Elements.GuiSync = TexturePacksV2.CreateToggle({
        Name = "GUI Color Sync",
        Function = TexturePacksV2.Restart,
        Default = true
    })
end)


run(function()
	local TexturePacks = {["Enabled"] = false}
	local packselected = {["Value"] = "OldBedwars"}

	local toolFunction = function() end
	local con

	local packfunctions = {
		SeventhPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14033898270")
				local import = objs[1]
				import.Parent = ReplicatedStorage
				local index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},	
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "wood_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Wood_Pickaxe"),
					},
					{
						name = "stone_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Stone_Pickaxe"),
					},
					{
						name = "iron_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Iron_Pickaxe"),
					},
					{
						name = "diamond_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)),
						model = import:WaitForChild("Diamond_Pickaxe"),
					},	
					{
						name = "wood_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Wood_Axe"),
					},	
					{
						name = "stone_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Stone_Axe"),
					},	
					{
						name = "iron_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Iron_Axe"),
					},	
					{
						name = "diamond_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-95)),
						model = import:WaitForChild("Diamond_Axe"),
					},	
					{
						name = "fireball",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Fireball"),
					},	
					{
						name = "telepearl",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Telepearl"),
					},
				}
				toolFunction = function(tool)	
					if not tool:IsA("Accessory") then return end	
					for _, v in ipairs(index) do	
						if v.name == tool.Name then		
							for _, part in ipairs(tool:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1
								end			
							end		
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool			
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")			
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)			
							for _, part in ipairs(tool2:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1				
								end			
							end			
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							if v.name:match("sword") or v.name:match("blade") then
								model2.CFrame *= CFrame.new(.5, 0, -1.1) - Vector3.new(0, 0, -.3)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and v.name:match("diamond") then
								model2.CFrame *= CFrame.new(.08, 0, -1.1) - Vector3.new(0, 0, -.9)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and not v.name:match("diamond") then
								model2.CFrame *= CFrame.new(-.2, 0, -2.4) + Vector3.new(0, 0, 2.12)
							else
								model2.CFrame *= CFrame.new(.2, 0, -.09)
							end
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
			end)
		end,
		EighthPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14078540433")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-90),math.rad(90)),
						model = import:WaitForChild("Rageblade"),
					}, 
				}
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(.5,0,-.8)
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
			end)
		end,
		SixthPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")

				local objs = game:GetObjects("rbxassetid://13780890894")
				local import = objs[1]
				import.Parent = ReplicatedStorage
				
				local swordIndex = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
				}
				
				local pickaxeIndex = {
					{
						name = "wood_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Wood_Pickaxe"),
					},
					{
						name = "stone_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Stone_Pickaxe"),
					},
					{
						name = "iron_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Iron_Pickaxe"),
					},
					{
						name = "diamond_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)),
						model = import:WaitForChild("Diamond_Pickaxe"),
					},
				}

				local swordFunction = function(tool)
					if not tool:IsA("Accessory") then
						return
					end
					
					for _, v in pairs(swordIndex) do
						if v.name == tool.Name then
							for _, v in pairs(tool:GetDescendants()) do
								if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
									v.Transparency = 1
								end
							end
							
							local model = v.model:Clone()
							model.CFrame = tool.Handle.CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool
							
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool.Handle
							
							local tool2 = Players.LocalPlayer.Character[tool.Name]
							
							for _, v in pairs(tool2:GetDescendants()) do
								if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
									v.Transparency = 1
								end
							end
							
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2.Handle.CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model2.CFrame *= CFrame.new(0.4, 0, -0.9)
							model2.Parent = tool2
							
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2.Handle
						end
					end
				end

				local pickaxeFunction = function(tool)
					if not tool:IsA("Accessory") then
						return
					end

					for _, v in pairs(pickaxeIndex) do
						if v.name == tool.Name then
							for _, v in pairs(tool:GetDescendants()) do
								if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool.Handle.CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool.Handle
							local tool2 = Players.LocalPlayer.Character[tool.Name]
							for _, v in pairs(tool2:GetDescendants()) do
								if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
									v.Transparency = 1
								end
							end
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2.Handle.CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model2.CFrame *= CFrame.new(-0.2, 0, -0.08)
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2.Handle
						end
					end
				end

				toolFunction = function(tool)
					task.spawn(function() swordFunction(tool) end)
					task.spawn(function() pickaxeFunction(tool) end)
				end
			end)
		end,
		FifthPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				
				local objs = game:GetObjects("rbxassetid://13802020264")
				local import = objs[1]
				
				import.Parent = game:GetService("ReplicatedStorage")
				
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					
					
				}
				
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
						
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(0.8,0,-.9)
							model2.Parent = tool2
							
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")			
						end
					end
				end
			end)
		end,
		FourthPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				
				local objs = game:GetObjects("rbxassetid://13801509384")
				local import = objs[1]
				
				import.Parent = game:GetService("ReplicatedStorage")
				
				index = {
				
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-270)),
						model = import:WaitForChild("Rageblade"),
					},
					
					
				}

				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then	
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then	
									v.Transparency = 1
								end
							end
						
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then	
									v.Transparency = 1	
								end	
							end

							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(0.4,0,-.9)
							model2.Parent = tool2
							
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")					
						end
					end
				end
			end)
		end,
		SecondPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://13801616054")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(100),math.rad(-270)),
						model = import:WaitForChild("Rageblade"),
					},
					
					
				}

				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
						
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(0.8,0,-.9)
							model2.Parent = tool2
							
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
			end)
		end,
		FirstPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://13783192680")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					
					
				}
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(0.4,0,-.9)
							model2.Parent = tool2
							
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
			end)
		end,
		CottonCandy = function() 
			task.spawn(function() 
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14161283331")
				local import = objs[1]
				import.Parent = ReplicatedStorage
				local index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},	
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(90)),
						model = import:WaitForChild("Rageblade"),
					}, 
					{
						name = "wood_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Wood_Pickaxe"),
					},
					{
						name = "stone_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Stone_Pickaxe"),
					},
					{
						name = "iron_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-18033), math.rad(-95)),
						model = import:WaitForChild("Iron_Pickaxe"),
					},
					{
						name = "diamond_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)),
						model = import:WaitForChild("Diamond_Pickaxe"),
					},	
					{
						name = "wood_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Wood_Axe"),
					},	
					{
						name = "stone_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Stone_Axe"),
					},	
					{
						name = "iron_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Iron_Axe"),
					},	
					{
						name = "diamond_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-95)),
						model = import:WaitForChild("Diamond_Axe"),
					},	
					{
						name = "fireball",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Fireball"),
					},	
					{
						name = "telepearl",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Telepearl"),
					},
					{
						name = "diamond",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Diamond"),
					},
					{
						name = "iron",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Iron"),
					},
					{
						name = "gold",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Gold"),
					},
					{
						name = "emerald",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Emerald"),
					},
					{
						name = "wood_bow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "wood_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "tactical_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(180), math.rad(-90)),
						model = import:WaitForChild("Bow"),
					},
				}
				toolFunction = function(tool)	
					if not tool:IsA("Accessory") then return end	
					for _, v in ipairs(index) do	
						if v.name == tool.Name then		
							for _, part in ipairs(tool:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1
								end			
							end		
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool			
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")			
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)			
							for _, part in ipairs(tool2:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1				
								end			
							end			
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							if v.name:match("rageblade") then
								model2.CFrame *= CFrame.new(0.7, 0, -1)                           
							elseif v.name:match("sword") or v.name:match("blade") then
								model2.CFrame *= CFrame.new(.6, 0, -1.1) - Vector3.new(0, 0, -.3)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and v.name:match("diamond") then
								model2.CFrame *= CFrame.new(.08, 0, -1.1) - Vector3.new(0, 0, -1.1)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and not v.name:match("diamond") then
								model2.CFrame *= CFrame.new(-.2, 0, -2.4) + Vector3.new(0, 0, 2.12)
							elseif v.name:match("iron") then
								model2.CFrame *= CFrame.new(0, -.24, 0)
							elseif v.name:match("gold") then
								model2.CFrame *= CFrame.new(0, .03, 0)
							elseif v.name:match("diamond") then
								model2.CFrame *= CFrame.new(0, .027, 0)
							elseif v.name:match("emerald") then
								model2.CFrame *= CFrame.new(0, .001, 0)
							elseif v.name:match("telepearl") then
								model2.CFrame *= CFrame.new(.1, 0, .1)
							elseif v.name:match("fireball") then
								model2.CFrame *= CFrame.new(.28, .1, 0)
							elseif v.name:match("bow") and not v.name:match("crossbow") then
								model2.CFrame *= CFrame.new(-.29, .1, -.2)
							elseif v.name:match("wood_crossbow") and not v.name:match("tactical_crossbow") then
								model2.CFrame *= CFrame.new(-.6, 0, 0)
							elseif v.name:match("tactical_crossbow") and not v.name:match("wood_crossbow") then
								model2.CFrame *= CFrame.new(-.5, 0, -1.2)
							else
								model2.CFrame *= CFrame.new(.2, 0, -.2)
							end
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end   
			end)
		end,
		EgirlPack = function() 
			task.spawn(function() 	
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14126814481")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-90),math.rad(90)),
						model = import:WaitForChild("Rageblade"),
					}, 
				}
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(.6,0,-1)
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end             
			end)
		end,
		GlizzyPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://13804645310")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-270)),
						model = import:WaitForChild("Rageblade"),
					},
				}
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(100),math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-105),math.rad(0))
							model2.CFrame *= CFrame.new(-0.4,0,-0.10)
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
			end)
        end,
		PrivatePack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14161283331")
				local import = objs[1]
				import.Parent = ReplicatedStorage
				local index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},	
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(90)),
						model = import:WaitForChild("Rageblade"),
					}, 
					{
						name = "wood_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Wood_Pickaxe"),
					},
					{
						name = "stone_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Stone_Pickaxe"),
					},
					{
						name = "iron_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-18033), math.rad(-95)),
						model = import:WaitForChild("Iron_Pickaxe"),
					},
					{
						name = "diamond_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)),
						model = import:WaitForChild("Diamond_Pickaxe"),
					},	
					{
						name = "wood_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Wood_Axe"),
					},	
					{
						name = "stone_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Stone_Axe"),
					},	
					{
						name = "iron_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Iron_Axe"),
					},	
					{
						name = "diamond_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-95)),
						model = import:WaitForChild("Diamond_Axe"),
					},	
					{
						name = "fireball",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Fireball"),
					},	
					{
						name = "telepearl",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Telepearl"),
					},
					{
						name = "diamond",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Diamond"),
					},
					{
						name = "iron",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Iron"),
					},
					{
						name = "gold",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Gold"),
					},
					{
						name = "emerald",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Emerald"),
					},
					{
						name = "wood_bow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "wood_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "tactical_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(180), math.rad(-90)),
						model = import:WaitForChild("Bow"),
					},
				}
				toolFunction = function(tool)	
					if not tool:IsA("Accessory") then return end	
					for _, v in ipairs(index) do	
						if v.name == tool.Name then		
							for _, part in ipairs(tool:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1
								end			
							end		
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool			
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")			
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)			
							for _, part in ipairs(tool2:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1				
								end			
							end			
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							if v.name:match("rageblade") then
								model2.CFrame *= CFrame.new(0.7, 0, -1)                           
							elseif v.name:match("sword") or v.name:match("blade") then
								model2.CFrame *= CFrame.new(.6, 0, -1.1) - Vector3.new(0, 0, -.3)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and v.name:match("diamond") then
								model2.CFrame *= CFrame.new(.08, 0, -1.1) - Vector3.new(0, 0, -1.1)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and not v.name:match("diamond") then
								model2.CFrame *= CFrame.new(-.2, 0, -2.4) + Vector3.new(0, 0, 2.12)
							elseif v.name:match("iron") then
								model2.CFrame *= CFrame.new(0, -.24, 0)
							elseif v.name:match("gold") then
								model2.CFrame *= CFrame.new(0, .03, 0)
							elseif v.name:match("diamond") then
								model2.CFrame *= CFrame.new(0, .027, 0)
							elseif v.name:match("emerald") then
								model2.CFrame *= CFrame.new(0, .001, 0)
							elseif v.name:match("telepearl") then
								model2.CFrame *= CFrame.new(.1, 0, .1)
							elseif v.name:match("fireball") then
								model2.CFrame *= CFrame.new(.28, .1, 0)
							elseif v.name:match("bow") and not v.name:match("crossbow") then
								model2.CFrame *= CFrame.new(-.29, .1, -.2)
							elseif v.name:match("wood_crossbow") and not v.name:match("tactical_crossbow") then
								model2.CFrame *= CFrame.new(-.6, 0, 0)
							elseif v.name:match("tactical_crossbow") and not v.name:match("wood_crossbow") then
								model2.CFrame *= CFrame.new(-.5, 0, -1.2)
							else
								model2.CFrame *= CFrame.new(.2, 0, -.2)
							end
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end          
			end)
        end,
		DemonSlayerPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14241215869")
				local import = objs[1]
				import.Parent = ReplicatedStorage
				local index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},	
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "wood_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Wood_Pickaxe"),
					},
					{
						name = "stone_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Stone_Pickaxe"),
					},
					{
						name = "iron_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Iron_Pickaxe"),
					},
					{
						name = "diamond_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(90), math.rad(-95)),
						model = import:WaitForChild("Diamond_Pickaxe"),
					},	
					{
						name = "fireball",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Fireball"),
					},	
					{
						name = "telepearl",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Telepearl"),
					},
					{
						name = "diamond",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-90)),
						model = import:WaitForChild("Diamond"),
					},
					{
						name = "iron",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Iron"),
					},
					{
						name = "gold",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Gold"),
					},
					{
						name = "emerald",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-90)),
						model = import:WaitForChild("Emerald"),
					},
					{
						name = "wood_bow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "wood_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "tactical_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(180), math.rad(-90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "wood_dao",
						offset = CFrame.Angles(math.rad(0), math.rad(89), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_dao",
						offset = CFrame.Angles(math.rad(0), math.rad(89), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_dao",
						offset = CFrame.Angles(math.rad(0), math.rad(89), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_dao",
						offset = CFrame.Angles(math.rad(0), math.rad(89), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
				}
				toolFunction = function(tool)	
					if not tool:IsA("Accessory") then return end	
					for _, v in ipairs(index) do	
						if v.name == tool.Name then		
							for _, part in ipairs(tool:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1
								end			
							end		
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool			
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")			
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)			
							for _, part in ipairs(tool2:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1				
								end			
							end			
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							if v.name:match("rageblade") then
								model2.CFrame *= CFrame.new(0.7, 0, -.7)                           
							elseif v.name:match("sword") or v.name:match("blade") then
								model2.CFrame *= CFrame.new(.2, 0, -.8)
							elseif v.name:match("dao") then
								model2.CFrame *= CFrame.new(.7, 0, -1.3)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and v.name:match("diamond") then
								model2.CFrame *= CFrame.new(.08, 0, -1.1) - Vector3.new(0, 0, -1.1)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and not v.name:match("diamond") then
								model2.CFrame *= CFrame.new(-.2, 0, -2.4) + Vector3.new(0, 0, 2.12)
							elseif v.name:match("diamond_pickaxe") then
								model2.CFrame *= CFrame.new(.2, 0, -.26)
							elseif v.name:match("iron") and not v.name:match("iron_pickaxe") then
								model2.CFrame *= CFrame.new(0, -.24, 0)
							elseif v.name:match("gold") then
								model2.CFrame *= CFrame.new(0, .03, 0)
							elseif v.name:match("diamond") or v.name:match("emerald") then
								model2.CFrame *= CFrame.new(0, -.03, 0)
							elseif v.name:match("telepearl") then
								model2.CFrame *= CFrame.new(.1, 0, .1)
							elseif v.name:match("fireball") then
								model2.CFrame *= CFrame.new(.28, .1, 0)
							elseif v.name:match("bow") and not v.name:match("crossbow") then
								model2.CFrame *= CFrame.new(-.2, .1, -.05)
							elseif v.name:match("wood_crossbow") and not v.name:match("tactical_crossbow") then
								model2.CFrame *= CFrame.new(-.5, 0, .05)
							elseif v.name:match("tactical_crossbow") and not v.name:match("wood_crossbow") then
								model2.CFrame *= CFrame.new(-.35, 0, -1.2)
							else
								model2.CFrame *= CFrame.new(.0, 0, -.06)
							end
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
			end)
		end,
        FirstHighResPack = function() 
            task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14224565815")
				local import = objs[1]
				import.Parent = ReplicatedStorage
				local index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
          			{
                        name = "rageblade",
                        offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(90)),
                        model = import:WaitForChild("Rageblade"),
          			},
					{
						name = "wood_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Wood_Pickaxe"),
					},
					{
						name = "stone_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Stone_Pickaxe"),
					},
					{
						name = "iron_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Iron_Pickaxe"),
					},
					{
						name = "diamond_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(90), math.rad(-95)),
						model = import:WaitForChild("Diamond_Pickaxe"),
					},
					{
						name = "wood_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Wood_Axe"),
					},
					{
						name = "stone_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Stone_Axe"),
					},
					{
						name = "iron_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Iron_Axe"),
					},
					{
						name = "diamond_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-95)),
						model = import:WaitForChild("Diamond_Axe"),
					},
					{
						name = "fireball",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Fireball"),
					},
					{
						name = "telepearl",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Telepearl"),
					},
					{
						name = "diamond",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-90)),
						model = import:WaitForChild("Diamond"),
					},
					{
						name = "iron",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Iron"),
					},
					{
						name = "gold",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Gold"),
					},
					{
						name = "emerald",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-90)),
						model = import:WaitForChild("Emerald"),
					},
					{
						name = "wood_bow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "wood_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "tactical_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(180), math.rad(-90)),
						model = import:WaitForChild("Bow"),
					},
				}
				toolFunction = function(tool)
					if not tool:IsA("Accessory") then return end
					for _, v in ipairs(index) do
						if v.name == tool.Name then
							for _, part in ipairs(tool:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
									part.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							for _, part in ipairs(tool2:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
									part.Transparency = 1
								end
							end
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							if v.name:match("rageblade") then
								model2.CFrame *= CFrame.new(0.7, 0, -1)
							elseif v.name:match("sword") or v.name:match("blade") then
								model2.CFrame *= CFrame.new(.6, 0, -1.1) - Vector3.new(0, 0, -.3)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and v.name:match("diamond") then
								model2.CFrame *= CFrame.new(.08, 0, -1.1) - Vector3.new(0, 0, -1.1)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and not v.name:match("diamond") then
								model2.CFrame *= CFrame.new(-.2, 0, -2.4) + Vector3.new(0, 0, 2.12)
							elseif v.name:match("diamond_pickaxe") then
								model2.CFrame *= CFrame.new(.2, 0, -.26)
							elseif v.name:match("iron") and not v.name:match("iron_pickaxe") then
								model2.CFrame *= CFrame.new(0, -.24, 0)
							elseif v.name:match("gold") then
								model2.CFrame *= CFrame.new(0, .03, 0)
							elseif v.name:match("diamond") or v.name:match("emerald") then
								model2.CFrame *= CFrame.new(0, -.03, 0)
							elseif v.name:match("telepearl") then
								model2.CFrame *= CFrame.new(.1, 0, .1)
							elseif v.name:match("fireball") then
								model2.CFrame *= CFrame.new(.28, .1, 0)
							elseif v.name:match("bow") and not v.name:match("crossbow") then
								model2.CFrame *= CFrame.new(-.2, .1, -.05)
							elseif v.name:match("wood_crossbow") and not v.name:match("tactical_crossbow") then
								model2.CFrame *= CFrame.new(-.5, 0, .05)
							elseif v.name:match("tactical_crossbow") and not v.name:match("wood_crossbow") then
								model2.CFrame *= CFrame.new(-.35, 0, -1.2)
							else
								model2.CFrame *= CFrame.new(.2, 0, -.24)
							end
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
           end)
		end,
        RandomPack = function() 
            task.spawn(function()  
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14282106674")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-89),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-89),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-89),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-89),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-89),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
				}
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end            
							end            
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(0.6,0,-.9)
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end  
           end)
		end,
		SecondHighResPack = function() 
            task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14078540433")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-90),math.rad(90)),
						model = import:WaitForChild("Rageblade"),
					}, 
				}
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(.5,0,-.8)
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
           end)
		end
	}

	if (not TexturePacks.Enabled) then toolFunction = function() end end

	local function refresh()
		pcall(function() con:Disconnect() end)
		con = game:GetService("Workspace"):WaitForChild("Camera").Viewmodel.ChildAdded:Connect(toolFunction)
		for i,v in pairs(game:GetService("Workspace"):WaitForChild("Camera").Viewmodel:GetChildren()) do toolFunction(v) end
	end

	TexturePacks = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "TexturePacksV3",
		["Function"] = function(callback) 
			if callback then 
				packfunctions[packselected["Value"]]()
				refresh()
            else 
				toolFunction = function() end
				refresh()
			end
		end
	})
	local list = {}
	for i,v in pairs(packfunctions) do table.insert(list, tostring(i)) end
	packselected = TexturePacks.CreateDropdown({
		["Name"] = "Pack",
		["Function"] = function() if TexturePacks.Enabled then packfunctions[packselected["Value"]](); refresh() end end,
		["List"] = list
	})
end)


---------------------

run(function()
	local ProjectileAura
	local Targets
	local Range
	local List = {ListEnabled = {'arrow', 'snowball'}}
	local rayCheck = RaycastParams.new()
	rayCheck.FilterType = Enum.RaycastFilterType.Include

	local projectileRemote = {InvokeServer = function() end}
	local FireDelays = {}
	task.spawn(function()
		projectileRemote = bedwars.Client:Get(remotes.FireProjectile).instance
	end)

	local function getAmmo(check, item)
		if not check.ammoItemTypes then return item.itemType end
		for _, item in store.localInventory.inventory.items do
			if check.ammoItemTypes and table.find(check.ammoItemTypes, item.itemType) then
				return item.itemType
			end
		end
	end
	
	local function getProjectiles()
		local items = {}
		for _, item in store.localInventory.inventory.items do
			if item and item.itemType == "mage_spellbook" then
				table.insert(items, {
					item,
					nil, 
					nil,
					0.3
				})
				continue
			end
			if item and item.itemType == "owl_orb" then
				table.insert(items, {
					item,
					nil, 
					nil,
					0.3
				})
				continue
			end
			if item and item.itemType == "light_sword" then
				table.insert(items, {
					item,
					nil, 
					nil,
					0.3
				})
			end
			local proj = bedwars.ItemTable[item.itemType].projectileSource
			local ammo = proj and getAmmo(proj, item)
			if not table.find(List.ListEnabled, 'sword_wave1') then table.insert(List.ListEnabled, 'sword_wave1') end
			if not table.find(List.ListEnabled, 'ninja_chakram_4') then table.insert(List.ListEnabled, 'ninja_chakram_4') end
			if ammo and table.find(List.ListEnabled, ammo) then
				table.insert(items, {
					item,
					ammo,
					proj.projectileType(ammo),
					proj
				})
			end
		end
		return items
	end

	local HttpService = game:GetService("HttpService")

	local function specialGUID()
		return string.upper((tostring(HttpService:GenerateGUID(false)):split("-"))[1])
	end
	
	local function selfPosition()
		return lplr.Character and lplr.Character.PrimaryPart and lplr.Character.PrimaryPart.Position
	end

	local handle = {
		Lumen = function(ent, item, ammo, projectile, itemMeta)
			if not item.tool then return end
			if not ent then return end
			local selfPos = selfPosition()
			if not selfPos then return end
	
			local vec = ent.RootPart.Position * Vector3.new(1, 0, 1)
			lplr.Character.PrimaryPart.CFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(vec.X, lplr.Character.PrimaryPart.Position.Y + 0.001, vec.Z))
	
			local mag = lplr.Character.PrimaryPart.CFrame.LookVector*80
	
			projectileRemote:InvokeServer(
				item.tool,
				"light_sword",
				"sword_wave1",
				Vector3.new(selfPos.X, selfPos.Y + 2, selfPos.Z),
				selfPos,
				mag,
				specialGUID(),
				{
					["shotId"] = specialGUID(),
					["drawDurationSec"] = 0
				},
				workspace:GetServerTimeNow() - 0.045
			)
			
			pcall(function()
				FireDelays[item.itemType] = tick() + itemMeta.fireDelaySec
			end)
		end,
		Umeko = function(ent, item, ammo, projectile, itemMeta)
			if not item.tool then return end
			if not ent then return end
			local selfPos = selfPosition()
			if not selfPos then return end
	
			local vec = ent.RootPart.Position * Vector3.new(1, 0, 1)
			lplr.Character.PrimaryPart.CFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(vec.X, lplr.Character.PrimaryPart.Position.Y + 0.001, vec.Z))
	
			switchItem(item.tool)

			local targetPos = ent.RootPart.Position

			local expectedTime = (selfPos - targetPos).Magnitude / 160
			targetPos += (ent.RootPart.Velocity * expectedTime)

			projectileRemote:InvokeServer(
				item.tool,
				nil,
				"ninja_chakram_4",
				selfPos + Vector3.new(0, 2, 0),
				selfPos,
				(selfPos - targetPos).Unit * -160,
				specialGUID(),
				{
					["shotId"] = specialGUID(),
					["drawDurationSec"] = 1
				},
				workspace:GetServerTimeNow() - 0.045
			)
			
			pcall(function()
				FireDelays[item.itemType] = tick() + itemMeta.fireDelaySec
			end)
		end,
		Whim = function(ent, item, ammo, projectile, itemMeta)
			if not item.tool then return end
			if not ent then return end
			local selfPos = selfPosition()
			if not selfPos then return end
	
			local vec = ent.RootPart.Position * Vector3.new(1, 0, 1)
			lplr.Character.PrimaryPart.CFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(vec.X, lplr.Character.PrimaryPart.Position.Y + 0.001, vec.Z))
	
			switchItem(item.tool)

			local targetPos = ent.RootPart.Position

			local expectedTime = (selfPos - targetPos).Magnitude / 160
			targetPos += (ent.RootPart.Velocity * expectedTime)

			projectileRemote:InvokeServer(
				item.tool,
				nil,
				"mage_spell_base",
				selfPos + Vector3.new(0, 2, 0),
				selfPos,
				(selfPos - targetPos).Unit * -160,
				specialGUID(),
				{
					["shotId"] = specialGUID(),
					["drawDurationSec"] = 1
				},
				workspace:GetServerTimeNow() - 0.045
			)
			
			pcall(function()
				FireDelays[item.itemType] = tick() + itemMeta.fireDelaySec
			end)
		end,
		Whisper = function(ent, item, ammo, projectile, itemMeta)
			local function getPlayerFromUserId(userId)
				if not userId then return nil end
				local suc = pcall(function()
					userId = tonumber(userId)
				end)
				if not suc then return nil end
				for i,v in pairs(game:GetService("Players"):GetPlayers()) do
					if v.UserId == userId then return v end
				end
			end
			local function getOwl()
				local owl = Filter(game.Workspace:GetChildren(), function(v)
					if v.ClassName and v.ClassName == "Model" and v.Name and v.Name == "ServerOwl" and tostring(v:GetAttribute("Owner")) == tostring(lplr.UserId) and getPlayerFromUserId(tostring(v:GetAttribute("Target"))) then 
						return true
					else
						return false
					end
				end)
				if not owl then return end

				if not item.tool then return end
				if not ent then return end
				local selfPos = selfPosition()
				if not selfPos then return end

				local targetPosition = ent.RootPart.Position
				local direction = (targetPosition - lplr.Character.HumanoidRootPart.Position).unit

				local target = getPlayerFromUserId(tostring(owl:GetAttribute("Target")))
				local ProjectileRefId, direction, fromPosition, initialVelocity = specialGUID(), direction, nil, direction
				local suc = pcall(function()
					fromPosition = target.Character.HumanoidRootPart.Position
				end)
				if not suc then return end

				bedwars.Client:Get(remotes.OwlFireProjectile):SendToServer({
					ProjectileRefId = ProjectileRefId,
					direction = direction,
					fromPosition = fromPosition,
					initialVelocity = initialVelocity
				})
			end
		end
	}
	
	ProjectileAura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = 'ProjectileAura',
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						if (workspace:GetServerTimeNow() - bedwars.SwordController.lastAttack) > 0.5 then
							task.spawn(function()
								local ent = entitylib.EntityPosition({
									Range = Range.Value,
									Part = 'RootPart',
									Players = true,
									NPCs = true
								})
								if ent then
									if Targets.Walls.Enabled then
										if not Wallcheck(lplr.Character, ent.Character) then return end
									end
									local pos = entitylib.character.HumanoidRootPart.Position
									for _, data in getProjectiles() do
										local item, ammo, projectile, itemMeta = unpack(data)
										if (FireDelays[item.itemType] or 0) < tick() then
											if item.itemType == "light_sword" then
												handle.Lumen(ent, unpack(data))
												continue
											elseif item.itemType == "ninja_chakram_4" then
												handle.Umeko(ent, unpack(data))
												continue
											elseif item.itemType == "mage_spellbook" then
												handle.Whim(ent, unpack(data))
												continue
											elseif item.itemType == "owl_orb" then
												handle.Whisper(ent, unpack(data))
												continue
											end
											rayCheck.FilterDescendantsInstances = {workspace.Map}
											local meta = bedwars.ProjectileMeta[projectile]
											local projSpeed, gravity = meta.launchVelocity, meta.gravitationalAcceleration or 196.2
											local calc = prediction.SolveTrajectory(pos, projSpeed, gravity, ent.RootPart.Position, ent.RootPart.Velocity, workspace.Gravity, ent.HipHeight, ent.Jumping and 42.6 or nil, rayCheck)
											if calc then
												local switched = switchItem(item.tool)
			
												task.spawn(function()
													local dir, id = CFrame.lookAt(pos, calc).LookVector, httpService:GenerateGUID(true)
													local shootPosition = (CFrame.new(pos, calc) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, -bedwars.BowConstantsTable.RelZ))).Position
													bedwars.ProjectileController:createLocalProjectile(meta, ammo, projectile, shootPosition, id, dir * projSpeed, {drawDurationSeconds = 1})
													local res = projectileRemote:InvokeServer(item.tool, ammo, projectile, shootPosition, pos, dir * projSpeed, id, {drawDurationSeconds = 1, shotId = httpService:GenerateGUID(false)}, workspace:GetServerTimeNow() - 0.045)
													if not res then
														FireDelays[item.itemType] = tick()
													else
														local shoot = itemMeta.launchSound
														shoot = shoot and shoot[math.random(1, #shoot)] or nil
														if shoot then
															bedwars.SoundManager:playSound(shoot)
														end
													end
												end)
			
												FireDelays[item.itemType] = tick() + itemMeta.fireDelaySec
												if switched then
													task.wait(0.05)
												end
											end
										end
									end
								end
							end)
						end
						task.wait(0.1)
					until not ProjectileAura.Enabled
				end)
			end
		end,
		HoverText = 'Shoots people around you'
	})
	Targets = ProjectileAura.CreateTargetWindow({})
	Range = ProjectileAura.CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 50,
		Default = 50,
		Function = function() end
	})
end)

-----------------------

ProjectileAuraV2 :



run(function()
    local ProjectileAura
    local FireRate
    local Targets
    local Range
    local Sort
    local List
    local rayCheck = RaycastParams.new()
    rayCheck.FilterType = Enum.RaycastFilterType.Include
    local projectileRemote = { InvokeServer = function(self, ...) end }
    local projectileCooldown = 0
    local FireDelays = {}
    task.spawn(function()
    	projectileRemote = bedwars.Client:Get(remotes.FireProjectile).instance
    end)
    
    local function getAmmo(check)
    	for _, item in store.inventory.inventory.items do
    		if check.ammoItemTypes and table.find(check.ammoItemTypes, item.itemType) then
    			return item.itemType
    		end
    	end
    	return nil
    end
    local function getProjectiles()
    	local items = {}
    	for _, item in store.inventory.inventory.items do
    		local proj = bedwars.ItemMeta[item.itemType].projectileSource
    		local ammo = proj and getAmmo(proj)
    		if ammo and table.find(List.ListEnabled, ammo) then
    			table.insert(items, {
    				item,
    				ammo,
    				proj.projectileType(ammo),
    				proj,
    			})
    		end
    	end
    	return items
    end
    
    ProjectileAura = vape.Categories.Blatant:CreateModule({
    	Name = 'Projectile Aura',
    	Function = function(callback)
    		if callback then
    			repeat
    				if (workspace:GetServerTimeNow() - bedwars.SwordController.lastAttack) > 0.5 then
    					local ent = entitylib.EntityPosition({
    						Part = 'RootPart',
    						Range = Range.Value,
    						Sort = sortmethods[Sort.Value],
    						Players = Targets.Players.Enabled,
    						NPCs = Targets.NPCs.Enabled,
    						Wallcheck = Targets.Walls.Enabled,
    					})
    
    					if ent then
    						local pos = entitylib.character.RootPart.Position
    						for _, data in getProjectiles() do
    							local item, ammo, projectile, itemMeta = unpack(data)
    							if (FireDelays[item.itemType] or 0) < tick() then
    								rayCheck.FilterDescendantsInstances = { workspace.Map }
    								local meta = bedwars.ProjectileMeta[projectile]
    								local projSpeed, gravity = meta.launchVelocity, meta.gravitationalAcceleration or 196.2
    								local calc = prediction.SolveTrajectory(pos, projSpeed, gravity, ent.RootPart.Position + (ent.Humanoid.MoveDirection or Vector3.zero), ent.RootPart.Velocity, workspace.Gravity, ent.HipHeight + 2, ent.Jumping and 42.6 or nil, rayCheck)
    								if calc then
    									targetinfo.Targets[ent] = tick() + 1
    									local switched = switchItem(item.tool)
    
    									local v = ent.RootPart.AssemblyLinearVelocity
    									local s = v:Lerp(ent.RootPart.AssemblyLinearVelocity, 0.5)
    									pos = entitylib.character.RootPart.Position
    									local ps = math.min(lplr:GetNetworkPing(), 0.5)
    									local tpos = ent.RootPart.Position
    									if ps > 0.06 then
    										tpos = tpos + (v * ps)
    									end
    									calc = prediction.SolveTrajectory(pos, projSpeed, gravity, tpos, s, workspace.Gravity, ent.HipHeight + 2, ent.Jumping and 42.6 or nil, rayCheck)
    									if not calc then
                                            task.wait()
    										continue
    									end
    									task.spawn(function()
    										local dir, id =
    											CFrame.lookAt(pos, calc).LookVector, httpService:GenerateGUID(true)
    										local shootPosition = (CFrame.new(pos, calc) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, -bedwars.BowConstantsTable.RelZ))).Position
    										projectileCooldown = 9e9
    										local _, res = pcall(function() return projectileRemote:InvokeServer(
    											item.tool,
    											ammo,
    											projectile,
    											shootPosition,
    											pos,
    											dir * projSpeed,
    											id,
    											{ 
                                                    drawDurationSeconds = 1, 
                                                    shotId = httpService:GenerateGUID(false) 
                                                },
    											workspace:GetServerTimeNow() - 0.045
    										) end)
    										projectileCooldown = tick()
    										if not res then
    											FireDelays[item.itemType] = tick()
    										else
    											--res.Parent = replicatedStorage
    											local shoot = itemMeta.launchSound
    											shoot = shoot and shoot[math.random(1, #shoot)] or nil
    											if shoot then
    												bedwars.SoundManager:playSound(shoot)
    											end
    										end
    									end)
    
    									FireDelays[item.itemType] = tick() + itemMeta.fireDelaySec
    									if switched then
    										repeat task.wait() until tick() > projectileCooldown
    										if FireRate.Value > 0 then
    											task.wait(FireRate.Value)
    										end
    									end
    								end
    							end
    						end
    					end
    				end
    				task.wait(0.012)
    			until not ProjectileAura.Enabled
    		end
    	end,
    	Tooltip = 'Shoots people around you',
    })
    Targets = ProjectileAura:CreateTargets({
    	Players = true,
    	Walls = true,
    })
    local methods = {'Damage', 'Distance'}
    for i in sortmethods do
    	if not table.find(methods, i) then
    		table.insert(methods, i)
    	end
    end
    Sort = ProjectileAura:CreateDropdown({
    	Name = 'Target Mode',
    	List = methods,
    	Default = 'Distance'
    })
    List = ProjectileAura:CreateTextList({
    	Name = 'Projectiles',
    	Default = {'arrow', 'snowball'},
    })
    FireRate = ProjectileAura:CreateSlider({
    	Name = 'Fire Rate',
    	Min = 0,
    	Max = 2,
    	Default = 0.02,
    	Decimal = 100,
    	Suffix = 'seconds'
    })
    Range = ProjectileAura:CreateSlider({
    	Name = 'Range',
    	Min = 1,
    	Max = 50,
    	Default = 50,
    	Suffix = function(val)
    		return val == 1 and 'stud' or 'studs'
    	end,
    })
end)


-------





