--[[
	atom.lua — AtomWare GUI
	Fork of new.lua:
	  • Fully rounded panels & buttons
	  • Springy Exponential/Back animations
	  • Rise-style ArrayList HUD (right-edge module list)
	  • Subtle UIStroke borders
	  • Atom watermark

	Strategy: run new.lua to get a fully-functional vape api, then
	patch it visually.  No separate ScreenGui — we reuse everything
	new.lua creates so ScaledGui, ClickGui, modules, categories, etc.
	all work exactly as normal.
--]]

-- ─── load new.lua and get its mainapi ─────────────────────
local isfile = isfile or function(f)
	local ok, r = pcall(readfile, f)
	return ok and r ~= nil and r ~= ''
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet(
				'https://raw.githubusercontent.com/endmylifehahahahahahahahaha/AtomWareV6/' ..
				readfile('newvape/profiles/commit.txt') .. '/' ..
				path:gsub('newvape/', ''), true)
		end)
		if not suc or res == '404: Not Found' then error(res) end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n' .. res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

-- Load new.lua as the base.  It returns mainapi with everything set up.
local newSource  = downloadFile('newvape/guis/new.lua')
local newFunc, newErr = loadstring(newSource, 'new.lua')
if not newFunc then error('[ATOM] failed to load new.lua base: ' .. tostring(newErr)) end
local mainapi = newFunc()
if not mainapi then error('[ATOM] new.lua returned nil') end

-- ─── grab references from new.lua ─────────────────────────
local gui        = mainapi.gui
local scaledgui  = gui and gui.ScaledGui
local clickgui   = scaledgui and scaledgui.ClickGui
local tweenService  = cloneref and cloneref(game:GetService('TweenService')) or game:GetService('TweenService')
local runService    = cloneref and cloneref(game:GetService('RunService'))    or game:GetService('RunService')
local guiService    = cloneref and cloneref(game:GetService('GuiService'))    or game:GetService('GuiService')
local textService   = cloneref and cloneref(game:GetService('TextService'))   or game:GetService('TextService')

local uipallet  = mainapi.Libraries.uipallet
local color     = mainapi.Libraries.color
local tween     = mainapi.Libraries.tween
local getcustomasset = mainapi.Libraries.getcustomasset

-- ─── Atom tween presets (smoother than new.lua's linear) ──
local TW_SPRING = TweenInfo.new(0.42, Enum.EasingStyle.Back,        Enum.EasingDirection.Out)
local TW_EXP    = TweenInfo.new(0.30, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local TW_EXPIN  = TweenInfo.new(0.24, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
local TW_FAST   = TweenInfo.new(0.16, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

-- Override the global tween table's Tween method with
-- exponential easing so ALL new.lua animations use it
local oldTween = tween.Tween
function tween:Tween(obj, tweeninfo, goal, tab)
	-- Swap linear tweens for exponential (faster-feeling, no speed change)
	if tweeninfo and tweeninfo.EasingStyle == Enum.EasingStyle.Linear then
		tweeninfo = TweenInfo.new(
			tweeninfo.Time,
			Enum.EasingStyle.Exponential,
			tweeninfo.EasingDirection
		)
	end
	return oldTween(self, obj, tweeninfo, goal, tab)
end
-- Also patch uipallet.Tween
uipallet.Tween = TW_EXP

-- ═══════════════════════════════════════════════════════════
-- ROUNDED CORNER PASS
-- Round every panel/button new.lua creates.
-- We do it lazily via DescendantAdded so we don't have to
-- enumerate 9000 lines of GUI construction.
-- ═══════════════════════════════════════════════════════════
local function addCornerTo(obj)
	if not obj:FindFirstChildWhichIsA('UICorner') then
		local c = Instance.new('UICorner')
		-- Large radius for panels/windows, smaller for rows
		if obj:IsA('ScrollingFrame') or obj.Size.Y.Offset > 80 or obj.Size.X.Offset > 200 then
			c.CornerRadius = UDim.new(0, 12)
		elseif obj.Size.Y.Offset > 30 then
			c.CornerRadius = UDim.new(0, 8)
		else
			c.CornerRadius = UDim.new(0, 6)
		end
		c.Parent = obj
	end
end

local function addStrokeTo(obj)
	if not obj:FindFirstChildWhichIsA('UIStroke')
		and obj.BackgroundTransparency < 0.85
		and (obj.Size.X.Offset > 80 or obj.Size.Y.Offset > 50) then
		local s = Instance.new('UIStroke')
		s.Thickness = 1
		s.Transparency = 0.78
		s.Parent = obj
	end
end

local function processObj(obj)
	if not (obj:IsA('Frame') or obj:IsA('TextButton') or obj:IsA('ScrollingFrame')) then return end
	if obj.BackgroundTransparency >= 1 then return end
	-- Skip tiny internal layout frames
	if obj.Size.X.Scale == 1 and obj.Size.Y.Scale == 1 then return end
	pcall(addCornerTo, obj)
	pcall(addStrokeTo, obj)
end

-- Process existing descendants (GUI is already built when we get here)
task.defer(function()
	if not gui then return end
	for _, v in gui:GetDescendants() do
		pcall(processObj, v)
	end
	gui.DescendantAdded:Connect(function(v)
		task.defer(processObj, v)
	end)
end)

-- ═══════════════════════════════════════════════════════════
-- ATOM ARRAYLIST HUD  (Rise-style right-edge module list)
-- ═══════════════════════════════════════════════════════════
if not scaledgui then
	warn('[ATOM] ScaledGui not found, skipping ArrayList')
	return mainapi
end

local ArrayLabels = {}

-- Container
local arrayHolder = Instance.new('Frame')
arrayHolder.Name  = 'AtomArrayHolder'
arrayHolder.Size  = UDim2.new(0, 260, 1, -40)
arrayHolder.Position = UDim2.new(1, -6, 0, 12)
arrayHolder.AnchorPoint = Vector2.new(1, 0)
arrayHolder.BackgroundTransparency = 1
arrayHolder.ZIndex = 10
arrayHolder.Parent = scaledgui

local arrayLayout = Instance.new('UIListLayout')
arrayLayout.SortOrder          = Enum.SortOrder.LayoutOrder
arrayLayout.FillDirection       = Enum.FillDirection.Vertical
arrayLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
arrayLayout.VerticalAlignment   = Enum.VerticalAlignment.Top
arrayLayout.Padding             = UDim.new(0, 2)
arrayLayout.Parent              = arrayHolder

-- Watermark
local atomWatermark = Instance.new('TextLabel')
atomWatermark.Name              = 'AtomWatermark'
atomWatermark.Size              = UDim2.fromOffset(140, 28)
atomWatermark.Position          = UDim2.fromOffset(10, guiService:GetGuiInset().Y + 4)
atomWatermark.BackgroundTransparency = 1
atomWatermark.Text              = 'atom'
atomWatermark.TextColor3        = Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
atomWatermark.TextSize          = 26
atomWatermark.TextXAlignment    = Enum.TextXAlignment.Left
atomWatermark.FontFace          = uipallet.FontSemiBold
atomWatermark.ZIndex            = 10
atomWatermark.Parent            = scaledgui

-- ArrayList config (controlled by AtomArrayList module options below)
local arrayCfg = {
	showMode   = 'All',      -- All / Exclude render / Only bound
	colorMode  = 'Fade',     -- Fade / Static
	background = true,
	bar        = true,
	suffix     = true,
	lowercase  = false,
	anim       = true,
	sort       = 'Size',     -- Size / Alphabetical
}

-- fontsize helper (mirror of new.lua)
local fsParams = Instance.new('GetTextBoundsParams')
fsParams.Width = math.huge
fsParams.Font = uipallet.Font

local function measure(text, size)
	fsParams.Text = text
	fsParams.Size = size
	fsParams.Font = uipallet.Font
	local ok, r = pcall(function() return textService:GetTextBoundsAsync(fsParams) end)
	return ok and r or Vector2.new(#text * size * 0.55, size)
end

local function removeTags(s)
	s = s:gsub('<br%s*/>', '\n')
	return s:gsub('<[^<>]->', '')
end

-- Rebuild the list whenever a module is toggled
local function buildArrayList()
	-- destroy old entries
	local found = {}
	for _, v in ArrayLabels do
		if v.Enabled then table.insert(found, v.Object.Name) end
		v.Object:Destroy()
	end
	table.clear(ArrayLabels)

	if not mainapi.Modules then return end

	local accent = Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)

	for name, mod in mainapi.Modules do
		if arrayCfg.showMode == 'Exclude render' and mod.Category == 'Render' then continue end
		if arrayCfg.showMode == 'Only bound'     and #mod.Bind <= 0             then continue end
		if not (mod.Enabled or table.find(found, name)) then continue end

		local text = name .. (mod.ExtraText and arrayCfg.suffix and ' ' .. mod.ExtraText() or '')
		if arrayCfg.lowercase then text = text:lower() end

		local TS    = 14
		local bounds = measure(removeTags(text), TS)
		local pillW  = bounds.X + (arrayCfg.bar and 16 or 8)
		local pillH  = bounds.Y + (arrayCfg.background and 4 or 2)

		-- Clip frame
		local holder = Instance.new('Frame')
		holder.Name               = name
		holder.BackgroundTransparency = 1
		holder.ClipsDescendants   = true
		holder.ZIndex             = 10
		holder.Parent             = arrayHolder

		-- Background pill
		local pill
		if arrayCfg.background then
			pill = Instance.new('Frame')
			pill.Size                  = UDim2.new(1, 2, 1, 0)
			pill.BackgroundColor3      = Color3.fromRGB(18, 18, 22)
			pill.BackgroundTransparency = 0.22
			pill.BorderSizePixel       = 0
			pill.ZIndex                = 10
			pill.Parent                = holder
			local pc = Instance.new('UICorner')
			pc.CornerRadius = UDim.new(0, 5)
			pc.Parent = pill
		end

		-- Sidebar colour bar (right edge)
		local bar
		if arrayCfg.bar then
			bar = Instance.new('Frame')
			bar.Size             = UDim2.fromOffset(2, math.max(pillH - 4, 2))
			bar.Position         = UDim2.new(1, -3, 0, 2)
			bar.BackgroundColor3 = accent
			bar.BorderSizePixel  = 0
			bar.ZIndex           = 11
			bar.Parent           = holder
			local bc = Instance.new('UICorner')
			bc.CornerRadius = UDim.new(1, 0)
			bc.Parent = bar
		end

		-- Text
		local lbl = Instance.new('TextLabel')
		lbl.Size                = UDim2.fromOffset(bounds.X, bounds.Y)
		lbl.Position            = UDim2.fromOffset(4, arrayCfg.background and 2 or 1)
		lbl.BackgroundTransparency = 1
		lbl.Text                = text
		lbl.TextSize            = TS
		lbl.FontFace            = uipallet.Font
		lbl.TextColor3          = accent
		lbl.TextXAlignment      = Enum.TextXAlignment.Left
		lbl.RichText            = true
		lbl.ZIndex              = 12
		lbl.Parent              = holder

		-- Drop shadow
		local shadow = lbl:Clone()
		shadow.Position   = UDim2.fromOffset(lbl.Position.X.Offset + 1, lbl.Position.Y.Offset + 1)
		shadow.Text       = removeTags(text)
		shadow.TextColor3 = Color3.new(0, 0, 0)
		shadow.TextTransparency = 0.65
		shadow.ZIndex     = lbl.ZIndex - 1
		shadow.Parent     = holder

		local target = UDim2.fromOffset(pillW, pillH)

		if arrayCfg.anim then
			if not table.find(found, name) then
				holder.Size = UDim2.fromOffset(0, pillH)
				tweenService:Create(holder, TW_EXP, { Size = target }):Play()
			else
				holder.Size = target
				if not mod.Enabled then
					tweenService:Create(holder, TW_EXPIN, { Size = UDim2.fromOffset(0, pillH) }):Play()
				end
			end
		else
			holder.Size = mod.Enabled and target or UDim2.fromOffset(0, pillH)
		end

		table.insert(ArrayLabels, {
			Object  = holder,
			Text    = lbl,
			Bar     = bar,
			Enabled = mod.Enabled,
		})
	end

	-- Sort
	if arrayCfg.sort == 'Alphabetical' then
		table.sort(ArrayLabels, function(a, b) return a.Text.Text < b.Text.Text end)
	else
		table.sort(ArrayLabels, function(a, b)
			return a.Text.Size.X.Offset > b.Text.Size.X.Offset
		end)
	end
	for i, v in ArrayLabels do v.Object.LayoutOrder = i end
end

-- ─── Patch new.lua's UpdateTextGUI to also rebuild our list ──
local origUpdateTextGUI = mainapi.UpdateTextGUI
function mainapi:UpdateTextGUI(afterload)
	-- run new.lua's original (manages its own TextGui overlay)
	if origUpdateTextGUI then
		pcall(origUpdateTextGUI, self, afterload)
	end
	-- rebuild atom's ArrayList
	pcall(buildArrayList)
end

-- ─── Patch UpdateGUI to tint watermark and list ───────────
local origUpdateGUI = mainapi.UpdateGUI
function mainapi:UpdateGUI(hue, sat, val, default)
	if origUpdateGUI then
		pcall(origUpdateGUI, self, hue, sat, val, default)
	end
	-- watermark colour
	if atomWatermark then
		atomWatermark.TextColor3 = Color3.fromHSV(hue, sat, val)
	end
	-- ArrayList accent
	local rainbow = mainapi.GUIColor and mainapi.GUIColor.Rainbow
	local accent  = Color3.fromHSV(hue, sat, val)
	for i, v in ArrayLabels do
		local c = (rainbow or arrayCfg.colorMode == 'Fade')
			and Color3.fromHSV(mainapi:Color(((hue - (i * 0.022)) % 1)))
			or accent
		v.Text.TextColor3 = c
		if v.Bar then v.Bar.BackgroundColor3 = c end
	end
end

-- ─── AtomArrayList module (settings in click-gui) ─────────
-- Added after new.lua finishes loading via task.defer so all
-- categories exist by the time we call CreateModule.
task.defer(function()
	if not mainapi.Categories or not mainapi.Categories.Main then return end

	-- Inject into the existing Main settings category
	local cat = mainapi.Categories.Main
	if not cat then return end

	local atomMod = cat:CreateModule({
		Name    = 'AtomArrayList',
		Tooltip = 'Atom right-edge module list (Rise-style ArrayList).',
		Function = function(callback)
			arrayHolder.Visible     = callback
			atomWatermark.Visible   = callback
			if callback then pcall(buildArrayList) end
		end
	})

	-- Enable it by default without triggering a notification
	if atomMod and not atomMod.Enabled then
		pcall(function() atomMod:Toggle() end)
	end

	-- Sub-options
	if atomMod then
		atomMod:CreateDropdown({
			Name = 'Show',
			List = { 'All', 'Exclude render', 'Only bound' },
			Function = function(v) arrayCfg.showMode = v; pcall(buildArrayList) end,
		})
		atomMod:CreateDropdown({
			Name = 'Color Mode',
			List = { 'Fade', 'Static' },
			Function = function(v) arrayCfg.colorMode = v; pcall(buildArrayList) end,
		})
		atomMod:CreateDropdown({
			Name = 'Sort',
			List = { 'Size', 'Alphabetical' },
			Function = function(v) arrayCfg.sort = v; pcall(buildArrayList) end,
		})
		atomMod:CreateToggle({
			Name = 'Background', Default = true,
			Function = function(c) arrayCfg.background = c; pcall(buildArrayList) end,
		})
		atomMod:CreateToggle({
			Name = 'Sidebar', Default = true,
			Function = function(c) arrayCfg.bar = c; pcall(buildArrayList) end,
		})
		atomMod:CreateToggle({
			Name = 'Suffix', Default = true,
			Function = function(c) arrayCfg.suffix = c; pcall(buildArrayList) end,
		})
		atomMod:CreateToggle({
			Name = 'Lowercase',
			Function = function(c) arrayCfg.lowercase = c; pcall(buildArrayList) end,
		})
		atomMod:CreateToggle({
			Name = 'Animations', Default = true,
			Function = function(c) arrayCfg.anim = c end,
		})
	end

	-- Initial build
	pcall(buildArrayList)
end)

-- ─── Return the fully-working new.lua mainapi ─────────────
-- Everything (Save, Load, modules, categories, keybinds, etc.)
-- is already wired up inside new.lua. We just return it.
return mainapi
