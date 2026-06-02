run(function()
    local Viewmodel
    local NoBob
    local Depth
    local Horizontal
    local Vertical
    local SwordScale
    local ColorHSV = {Hue = 0, Sat = 0, Val = 0}
    local OutlineColor = {Hue = 0, Sat = 0, Val = 0}
    local OutlineTrans = {Value = 0.5}
    local MaterialDropdown
    local Mode
    local Rots = {}
    local oldAnim, oldC1
    local Old = {Custom = {}, BaseSizes = {}}

    local function applyHighlight(part, original)
        local highlight = original or Instance.new("Highlight")
        highlight.FillColor = Color3.fromHSV(ColorHSV.Hue, ColorHSV.Sat, ColorHSV.Val)
        highlight.FillTransparency = math.clamp(OutlineTrans.Value + 0.2, 0, 1)
        highlight.OutlineColor = Color3.fromHSV(OutlineColor.Hue, OutlineColor.Sat, OutlineColor.Val)
        highlight.OutlineTransparency = OutlineTrans.Value
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = part
        table.insert(Old.Custom, highlight)
    end

    local function applyMaterial(part)
        local matName = MaterialDropdown.Value or "Neon"
        if Enum.Material[matName] then part.Material = Enum.Material[matName] end
        part.Color = Color3.fromHSV(ColorHSV.Hue, ColorHSV.Sat, ColorHSV.Val)
        
        if SwordScale then
            local scale = SwordScale.Value
            if not Old.BaseSizes[part] then Old.BaseSizes[part] = (part:IsA("MeshPart") and part.Size) or (part:FindFirstChildOfClass("SpecialMesh") and part:FindFirstChildOfClass("SpecialMesh").Scale) or Vector3.new(1,1,1) end
            
            if part:IsA("MeshPart") then
                part.Size = Old.BaseSizes[part] * scale
            else
                local mesh = part:FindFirstChildOfClass("SpecialMesh")
                if mesh then mesh.Scale = Old.BaseSizes[part] * scale end
            end
        end

        if part:IsA("MeshPart") then part.TextureID = "" else
            local mesh = part:FindFirstChildOfClass("SpecialMesh")
            if mesh then mesh.TextureId = "" end
        end
    end

    local function Main()
        local viewmodel = gameCamera:FindFirstChild("Viewmodel")
        if not viewmodel then return end

        if viewmodel:FindFirstChild("RightHand") and viewmodel.RightHand:FindFirstChild("RightWrist") then
            local rot = CFrame.Angles(math.rad(Rots[1].Value), math.rad(Rots[2].Value), math.rad(Rots[3].Value))
            viewmodel.RightHand.RightWrist.C1 = oldC1 * rot
        end

        for _, hl in next, Old.Custom do pcall(function() hl:Destroy() end) end
        table.clear(Old.Custom)

        for _, part in next, viewmodel:GetDescendants() do
            if part:IsA("BasePart") then
                applyMaterial(part)
                if Mode.Value == "Normal" or Mode.Value == "Mixed" then
                    applyHighlight(part)
                end
            end
        end
    end

    Viewmodel = vape.Legit:CreateModule({
        Name = "ViewmodelBeta",
        Tooltip = "Changes the viewmodel animations and color",
        Function = function(callback)
            if callback then
                local vmCtrl = lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]
                vmCtrl:SetAttribute("ConstantManager_DEPTH_OFFSET", -Depth.Value)
                vmCtrl:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", Horizontal.Value)
                vmCtrl:SetAttribute("ConstantManager_VERTICAL_OFFSET", Vertical.Value)

                local vm = gameCamera:FindFirstChild("Viewmodel")
                oldC1 = (vm and vm.RightHand.RightWrist.C1) or CFrame.identity
                oldAnim = bedwars.ViewmodelController.playAnimation
                if NoBob.Enabled then
                    bedwars.ViewmodelController.playAnimation = function(self, animtype, ...)
                        if bedwars.AnimationType and animtype == bedwars.AnimationType.FP_WALK then return end
                        return oldAnim(self, animtype, ...)
                    end
                end
                Viewmodel:Clean(runService.PostSimulation:Connect(Main))
            else
                if oldAnim then bedwars.ViewmodelController.playAnimation = oldAnim; oldAnim = nil end
                local vm = gameCamera:FindFirstChild("Viewmodel")
                if vm and vm:FindFirstChild("RightHand") then vm.RightHand.RightWrist.C1 = oldC1 end
                
                local vmCtrl = lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]
                vmCtrl:SetAttribute("ConstantManager_DEPTH_OFFSET", 0)
                vmCtrl:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", 0)
                vmCtrl:SetAttribute("ConstantManager_VERTICAL_OFFSET", 0)

                table.clear(Old.BaseSizes)
                for _, hl in next, Old.Custom do pcall(function() hl:Destroy() end) end
                table.clear(Old.Custom)
            end
        end
    })

    NoBob = Viewmodel:CreateToggle({Name = "No Bobbing", Default = true})
    Depth = Viewmodel:CreateSlider({Name = "Depth", Min = 0, Max = 2, Default = 0.8, Decimal = 10, Function = function(v) if Viewmodel.Enabled then lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", -v) end end})
    Horizontal = Viewmodel:CreateSlider({Name = "Horizontal", Min = 0, Max = 2, Default = 0.8, Decimal = 10, Function = function(v) if Viewmodel.Enabled then lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", v) end end})
    Vertical = Viewmodel:CreateSlider({Name = "Vertical", Min = -0.2, Max = 2, Default = -0.2, Decimal = 10, Function = function(v) if Viewmodel.Enabled then lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_VERTICAL_OFFSET", v) end end})
    SwordScale = Viewmodel:CreateSlider({Name = "Sword Scale", Min = 0.1, Max = 1, Default = 1, Decimal = 10})
    ColorHSV = Viewmodel:CreateColorSlider({Name = "Color", Darker = true, DefaultOpacity = 0.5, Function = function(h, s, v) ColorHSV = {Hue = h, Sat = s, Val = v} end})
    OutlineColor = Viewmodel:CreateColorSlider({Name = "Outline Color", Darker = true, DefaultOpacity = 0.5, Function = function(h, s, v) OutlineColor = {Hue = h, Sat = s, Val = v} end})
    OutlineTrans = Viewmodel:CreateSlider({Name = "Outline Trans", Min = 0, Max = 1, Default = 0.5, Decimal = 10, Function = function(v) OutlineTrans.Value = v end})
    MaterialDropdown = Viewmodel:CreateDropdown({Name = "Material", List = {"Neon", "Plastic", "ForceField"}, Default = "Neon"})
    Mode = Viewmodel:CreateDropdown({Name = "Color Mode", List = {"Normal", "Classic", "Mixed"}, Default = "Normal"})
    
    for i, name in next, {"Rotation X", "Rotation Y", "Rotation Z"} do
        table.insert(Rots, Viewmodel:CreateSlider({Name = name, Min = 0, Max = 360}))
    end

    -- AUTO-APPLY ON LOAD
    task.spawn(function()
        task.wait(2)
        local vmCtrl = lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]
        if vmCtrl and Viewmodel.Enabled then
            vmCtrl:SetAttribute("ConstantManager_DEPTH_OFFSET", -Depth.Value)
            vmCtrl:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", Horizontal.Value)
            vmCtrl:SetAttribute("ConstantManager_VERTICAL_OFFSET", Vertical.Value)
        end
    end)
end)