--[[
	atom.lua — AtomWare GUI
	Fork of new.lua with:
	  • Fully rounded corners everywhere (UDim.new(1,0) / UDim.new(0,12))
	  • Smoother, springy animations (Exponential/Back easing)
	  • Rise-style ArrayList text HUD (shows enabled modules on screen edge)
	  • Subtle UIStroke borders on panels for depth
	  • Hover glow on module buttons
	  • Softer, slightly lighter dark theme
--]]

-- ═══════════════════════════════════════════════════════════
-- API TABLE
-- ═══════════════════════════════════════════════════════════
local mainapi = {
	Categories = {},
	GUIColor = { Hue = 0.46, Sat = 0.96, Value = 0.52 },
	HeldKeybinds = {},
	Keybind = {'RightShift'},
	Loaded = false,
	Libraries = {},
	Modules = {},
	Place = game.PlaceId == 6872265039 and game.PlaceId or game.GameId,
	Profile = 'default',
	Profiles = {},
	RainbowSpeed = { Value = 1 },
	RainbowUpdateSpeed = { Value = 40 },
	RainbowTable = setmetatable({}, { __mode = 'v' }),
	Scale = { Value = 1 },
	ThreadFix = setthreadidentity and true or false,
	ToggleNotifications = {},
	Version = '4.18',
	Windows = {},
}

local cloneref = cloneref or function(obj) return obj end
local tweenService  = cloneref(game:GetService('TweenService'))
local inputService  = cloneref(game:GetService('UserInputService'))
local textService   = cloneref(game:GetService('TextService'))
local guiService    = cloneref(game:GetService('GuiService'))
local runService    = cloneref(game:GetService('RunService'))
local httpService   = cloneref(game:GetService('HttpService'))

local fontsize = Instance.new('GetTextBoundsParams')
fontsize.Width = math.huge

local notifications, clickgui, scaledgui, toolblur, tooltip, scale, gui
local assetfunction = getcustomasset
local getcustomasset  -- redefined after downloadFile

-- ─── Tween info constants (smoother than linear) ───────────
local TW_FAST   = TweenInfo.new(0.18, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local TW_SPRING = TweenInfo.new(0.45, Enum.EasingStyle.Back,        Enum.EasingDirection.Out)
local TW_SMOOTH = TweenInfo.new(0.28, Enum.EasingStyle.Quint,       Enum.EasingDirection.Out)
local TW_IN     = TweenInfo.new(0.22, Enum.EasingStyle.Quint,       Enum.EasingDirection.In)
local TW_FADE   = TweenInfo.new(0.35, Enum.EasingStyle.Sine,        Enum.EasingDirection.Out)

-- ─── UI palette ────────────────────────────────────────────
local uipallet = {
	Main          = Color3.fromRGB(22, 22, 26),   -- slightly warmer than new.lua
	Text          = Color3.fromRGB(210, 210, 215),
	Font          = Font.fromEnum(Enum.Font.Arial),
	FontSemiBold  = Font.fromEnum(Enum.Font.Arial, Enum.FontWeight.SemiBold),
	Tween         = TW_FAST,
}

-- Asset fallback map (same as new.lua)
local getcustomassets = {
	['newvape/assets/new/add.png']           = 'rbxassetid://14368300605',
	['newvape/assets/new/alert.png']         = 'rbxassetid://14368301329',
	['newvape/assets/new/allowedicon.png']   = 'rbxassetid://14368302000',
	['newvape/assets/new/allowedtab.png']    = 'rbxassetid://14368302875',
	['newvape/assets/new/arrowmodule.png']   = 'rbxassetid://14473354880',
	['newvape/assets/new/back.png']          = 'rbxassetid://14368303894',
	['newvape/assets/new/bind.png']          = 'rbxassetid://14368304734',
	['newvape/assets/new/bindbkg.png']       = 'rbxassetid://14368305655',
	['newvape/assets/new/blatanticon.png']   = 'rbxassetid://14368306745',
	['newvape/assets/new/blockedicon.png']   = 'rbxassetid://14385669108',
	['newvape/assets/new/blockedtab.png']    = 'rbxassetid://14385672881',
	['newvape/assets/new/blur.png']          = 'rbxassetid://14898786664',
	['newvape/assets/new/blurnotif.png']     = 'rbxassetid://16738720137',
	['newvape/assets/new/close.png']         = 'rbxassetid://14368309446',
	['newvape/assets/new/closemini.png']     = 'rbxassetid://14368310467',
	['newvape/assets/new/colorpreview.png']  = 'rbxassetid://14368311578',
	['newvape/assets/new/combaticon.png']    = 'rbxassetid://14368312652',
	['newvape/assets/new/customsettings.png']= 'rbxassetid://14403726449',
	['newvape/assets/new/discord.png']       = '',
	['newvape/assets/new/dots.png']          = 'rbxassetid://14368314459',
	['newvape/assets/new/edit.png']          = 'rbxassetid://14368315443',
	['newvape/assets/new/expandicon.png']    = 'rbxassetid://14368353032',
	['newvape/assets/new/expandright.png']   = 'rbxassetid://14368316544',
	['newvape/assets/new/expandup.png']      = 'rbxassetid://14368317595',
	['newvape/assets/new/friendstab.png']    = 'rbxassetid://14397462778',
	['newvape/assets/new/guisettings.png']   = 'rbxassetid://14368318994',
	['newvape/assets/new/guislider.png']     = 'rbxassetid://14368320020',
	['newvape/assets/new/guisliderrain.png'] = 'rbxassetid://14368321228',
	['newvape/assets/new/guiv4.png']         = 'rbxassetid://14368322199',
	['newvape/assets/new/guivape.png']       = 'rbxassetid://14657521312',
	['newvape/assets/new/info.png']          = 'rbxassetid://14368324807',
	['newvape/assets/new/inventoryicon.png'] = 'rbxassetid://14928011633',
	['newvape/assets/new/legit.png']         = 'rbxassetid://14425650534',
	['newvape/assets/new/legittab.png']      = 'rbxassetid://14426740825',
	['newvape/assets/new/miniicon.png']      = 'rbxassetid://14368326029',
	['newvape/assets/new/notification.png']  = 'rbxassetid://16738721069',
	['newvape/assets/new/overlaysicon.png']  = 'rbxassetid://14368339581',
	['newvape/assets/new/overlaystab.png']   = 'rbxassetid://14397380433',
	['newvape/assets/new/pin.png']           = 'rbxassetid://14368342301',
	['newvape/assets/new/profilesicon.png']  = 'rbxassetid://14397465323',
	['newvape/assets/new/radaricon.png']     = 'rbxassetid://14368343291',
	['newvape/assets/new/rainbow_1.png']     = 'rbxassetid://14368344374',
	['newvape/assets/new/rainbow_2.png']     = 'rbxassetid://14368345149',
	['newvape/assets/new/rainbow_3.png']     = 'rbxassetid://14368345840',
	['newvape/assets/new/rainbow_4.png']     = 'rbxassetid://14368346696',
	['newvape/assets/new/range.png']         = 'rbxassetid://14368347435',
	['newvape/assets/new/rangearrow.png']    = 'rbxassetid://14368348640',
	['newvape/assets/new/rendericon.png']    = 'rbxassetid://14368350193',
	['newvape/assets/new/rendertab.png']     = 'rbxassetid://14397373458',
	['newvape/assets/new/search.png']        = 'rbxassetid://14425646684',
	['newvape/assets/new/targetinfoicon.png']= 'rbxassetid://14368354234',
	['newvape/assets/new/targetnpc1.png']    = 'rbxassetid://14497400332',
	['newvape/assets/new/targetnpc2.png']    = 'rbxassetid://14497402744',
	['newvape/assets/new/targetplayers1.png']= 'rbxassetid://14497396015',
	['newvape/assets/new/targetplayers2.png']= 'rbxassetid://14497397862',
	['newvape/assets/new/targetstab.png']    = 'rbxassetid://14497393895',
	['newvape/assets/new/textguiicon.png']   = 'rbxassetid://14368355456',
	['newvape/assets/new/textv4.png']        = 'rbxassetid://14368357095',
	['newvape/assets/new/textvape.png']      = 'rbxassetid://14368358200',
	['newvape/assets/new/utilityicon.png']   = 'rbxassetid://14368359107',
	['newvape/assets/new/vape.png']          = 'rbxassetid://14373395239',
	['newvape/assets/new/warning.png']       = 'rbxassetid://14368361552',
	['newvape/assets/new/worldicon.png']     = 'rbxassetid://14368362492',
	-- Rise font assets
	['newvape/assets/rise/SF-Pro-Rounded-Light.otf']   = '',
	['newvape/assets/rise/SF-Pro-Rounded-Regular.otf'] = '',
	['newvape/assets/rise/SF-Pro-Rounded-Medium.otf']  = '',
	['newvape/assets/rise/Icon-1.ttf']                 = '',
	['newvape/assets/rise/Icon-3.ttf']                 = '',
}

-- ─── Helpers ───────────────────────────────────────────────
local isfile = isfile or function(file)
	local ok, res = pcall(readfile, file)
	return ok and res ~= nil and res ~= ''
end

local function removeTags(str)
	str = str:gsub('<br%s*/>', '\n')
	return str:gsub('<[^<>]->', '')
end

local function safecall(func, ...)
	local args = {...}
	xpcall(function() func(unpack(args)) end, function(e)
		warn('[ATOM] GUI Error: ' .. e)
	end)
end

local function getfontsize(text, size, font)
	fontsize.Text = text
	fontsize.Size = size
	if typeof(font) == 'Font' then fontsize.Font = font end
	local ok, result = pcall(function() return textService:GetTextBoundsAsync(fontsize) end)
	return ok and result or Vector2.new(#text * (size or 14) * 0.6, size or 14)
end

local function getTableSize(tab)
	local n = 0
	for _ in tab do n += 1 end
	return n
end

local function loopClean(tab)
	for i, v in tab do
		if type(v) == 'table' then loopClean(v) end
		tab[i] = nil
	end
end

local function loadJson(path)
	local ok, res = pcall(function() return httpService:JSONDecode(readfile(path)) end)
	return ok and type(res) == 'table' and res or nil
end

local function randomString()
	local a = {}
	for i = 1, math.random(10, 100) do a[i] = string.char(math.random(32, 126)) end
	return table.concat(a)
end

-- ─── Rounded corner helper ─────────────────────────────────
-- ATOM differentiator: all panels use larger corners
local function addCorner(parent, radius)
	local c = Instance.new('UICorner')
	c.CornerRadius = radius or UDim.new(0, 12)
	c.Parent = parent
	return c
end

local function addCornerFull(parent)
	return addCorner(parent, UDim.new(1, 0))
end

-- ─── Subtle stroke border ─────────────────────────────────
local function addStroke(parent, thickness, alpha)
	local s = Instance.new('UIStroke')
	s.Thickness = thickness or 1
	s.Transparency = alpha or 0.75
	s.Parent = parent
	return s
end

-- ─── Blur backdrop ─────────────────────────────────────────
local function addBlur(parent, notif)
	local blur = Instance.new('ImageLabel')
	blur.Name = 'Blur'
	blur.Size = UDim2.new(1, 89, 1, 52)
	blur.Position = UDim2.fromOffset(-48, -31)
	blur.BackgroundTransparency = 1
	blur.Image = getcustomasset('newvape/assets/new/' .. (notif and 'blurnotif' or 'blur') .. '.png')
	blur.ScaleType = Enum.ScaleType.Slice
	blur.SliceCenter = Rect.new(52, 31, 261, 502)
	blur.Parent = parent
	return blur
end

-- ─── Close button ──────────────────────────────────────────
local function addCloseButton(parent, offset)
	local close = Instance.new('ImageButton')
	close.Name = 'Close'
	close.Size = UDim2.fromOffset(24, 24)
	close.Position = UDim2.new(1, -35, 0, offset or 9)
	close.BackgroundColor3 = Color3.new(1, 1, 1)
	close.BackgroundTransparency = 1
	close.AutoButtonColor = false
	close.Image = getcustomasset('newvape/assets/new/close.png')
	close.ImageColor3 = Color3.fromRGB(200, 200, 200)
	close.ImageTransparency = 0.5
	close.Parent = parent
	addCornerFull(close)
	close.MouseEnter:Connect(function()
		close.ImageTransparency = 0.2
		tweenService:Create(close, TW_FAST, { BackgroundTransparency = 0.55 }):Play()
	end)
	close.MouseLeave:Connect(function()
		close.ImageTransparency = 0.5
		tweenService:Create(close, TW_FAST, { BackgroundTransparency = 1 }):Play()
	end)
	return close
end

-- ─── Maid ─────────────────────────────────────────────────
local function addMaid(object)
	object.Connections = {}
	function object:Clean(cb)
		if cb == nil then return end
		if typeof(cb) == 'Instance' then
			table.insert(self.Connections, { Disconnect = function() cb:ClearAllChildren(); cb:Destroy() end })
		elseif type(cb) == 'function' then
			table.insert(self.Connections, { Disconnect = cb })
		elseif type(cb) == 'thread' then
			table.insert(self.Connections, { Disconnect = function() pcall(task.cancel, cb) end })
		else
			table.insert(self.Connections, cb)
		end
	end
end
addMaid(mainapi)

-- ─── Tooltip ───────────────────────────────────────────────
local function addTooltip(g, text)
	if not text then return end
	local function moved(x, y)
		local right = x + 16 + tooltip.Size.X.Offset > (scale.Scale * 1920)
		tooltip.Position = UDim2.fromOffset(
			(right and x - (tooltip.Size.X.Offset * scale.Scale) - 16 or x + 16) / scale.Scale,
			((y + 11) - (tooltip.Size.Y.Offset / 2)) / scale.Scale
		)
		tooltip.Visible = toolblur.Visible
	end
	g.MouseEnter:Connect(function(x, y)
		local sz = getfontsize(text, tooltip.TextSize, uipallet.Font)
		tooltip.Size = UDim2.fromOffset(sz.X + 10, sz.Y + 10)
		tooltip.Text = text
		moved(x, y)
	end)
	g.MouseMoved:Connect(moved)
	g.MouseLeave:Connect(function() tooltip.Visible = false end)
end

local function checkKeybinds(compare, target, key)
	if type(target) == 'table' then
		if table.find(target, key) then
			for _, v in target do
				if not table.find(compare, v) then return false end
			end
			return true
		end
	end
	return false
end

local function createDownloader(text)
	if mainapi.Loaded ~= true then
		local dl = mainapi.Downloader
		if not dl then
			dl = Instance.new('TextLabel')
			dl.Size = UDim2.new(1, 0, 0, 40)
			dl.BackgroundTransparency = 1
			dl.TextStrokeTransparency = 0
			dl.TextSize = 20
			dl.TextColor3 = Color3.new(1, 1, 1)
			dl.FontFace = uipallet.Font
			dl.Parent = mainapi.gui
			mainapi.Downloader = dl
		end
		dl.Text = 'Downloading ' .. text
	end
end

-- ─── Tween wrapper ─────────────────────────────────────────
local color = {}
local tween = { tweens = {}, tweenstwo = {} }

function tween:Tween(obj, tweeninfo, goal, tab)
	tab = tab or self.tweens
	if tab[obj] then tab[obj]:Cancel(); tab[obj] = nil end
	if obj.Parent and obj.Visible then
		tab[obj] = tweenService:Create(obj, tweeninfo, goal)
		tab[obj].Completed:Once(function() if tab then tab[obj] = nil; tab = nil end end)
		tab[obj]:Play()
	else
		for i, v in goal do obj[i] = v end
	end
end

function tween:Cancel(obj)
	if self.tweens[obj] then self.tweens[obj]:Cancel(); self.tweens[obj] = nil end
end

-- ─── Color helpers ─────────────────────────────────────────
function color.Dark(col, num)
	local h, s, v = col:ToHSV()
	return Color3.fromHSV(h, s, math.clamp(select(3, uipallet.Main:ToHSV()) > 0.5 and v + num or v - num, 0, 1))
end

function color.Light(col, num)
	local h, s, v = col:ToHSV()
	return Color3.fromHSV(h, s, math.clamp(select(3, uipallet.Main:ToHSV()) > 0.5 and v - num or v + num, 0, 1))
end

function mainapi:Color(h)
	local s = 0.75 + (0.15 * math.min(h / 0.03, 1))
	if h > 0.57 then s = 0.9 - (0.4 * math.min((h - 0.57) / 0.09, 1)) end
	if h > 0.66 then s = 0.5 + (0.4 * math.min((h - 0.66) / 0.16, 1)) end
	if h > 0.87 then s = 0.9 - (0.15 * math.min((h - 0.87) / 0.13, 1)) end
	return h, s, 1
end

function mainapi:TextColor(h, s, v)
	if v >= 0.7 and (s < 0.6 or (h > 0.04 and h < 0.56)) then
		return Color3.new(0.19, 0.19, 0.19)
	end
	return Color3.new(1, 1, 1)
end

mainapi.Libraries = {
	color = color,
	getcustomasset = function(p) return getcustomasset(p) end,
	getfontsize = getfontsize,
	tween = tween,
	uipallet = uipallet,
}

-- ═══════════════════════════════════════════════════════════
-- FILE DOWNLOAD
-- ═══════════════════════════════════════════════════════════
local function downloadFile(path, func)
	if not isfile(path) then
		createDownloader(path)
		local ok, res = pcall(function()
			return game:HttpGet(
				'https://raw.githubusercontent.com/endmylifehahahahahahahahaha/AtomWareV6/' ..
				readfile('newvape/profiles/commit.txt') .. '/' ..
				select(1, path:gsub('newvape/', '')), true)
		end)
		if not ok or res == '404: Not Found' then error(res) end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n' .. res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

getcustomasset = not inputService.TouchEnabled and assetfunction and function(path)
	return downloadFile(path, assetfunction)
end or function(path)
	return getcustomassets[path] or ''
end
mainapi.Libraries.getcustomasset = getcustomasset

-- Update blur to use resolved asset
local function addBlur(parent, notif)
	local blur = Instance.new('ImageLabel')
	blur.Name = 'Blur'
	blur.Size = UDim2.new(1, 89, 1, 52)
	blur.Position = UDim2.fromOffset(-48, -31)
	blur.BackgroundTransparency = 1
	blur.Image = getcustomasset('newvape/assets/new/' .. (notif and 'blurnotif' or 'blur') .. '.png')
	blur.ScaleType = Enum.ScaleType.Slice
	blur.SliceCenter = Rect.new(52, 31, 261, 502)
	blur.Parent = parent
	return blur
end

-- ─── Font loading (same as rise, falls back to Arial) ─────
do
	local function writeFont()
		if not assetfunction then return nil end
		local ok = pcall(function()
			writefile('newvape/assets/atom/atomfont.json', httpService:JSONEncode({
				name = 'AtomSF',
				faces = {
					{ style = 'normal', assetId = getcustomasset('newvape/assets/rise/SF-Pro-Rounded-Light.otf'),   name = 'Light',   weight = 300 },
					{ style = 'normal', assetId = getcustomasset('newvape/assets/rise/SF-Pro-Rounded-Regular.otf'), name = 'Regular', weight = 400 },
					{ style = 'normal', assetId = getcustomasset('newvape/assets/rise/SF-Pro-Rounded-Medium.otf'),  name = 'Medium',  weight = 500 },
				}
			}))
		end)
		if ok and isfile('newvape/assets/atom/atomfont.json') then
			return getcustomasset('newvape/assets/atom/atomfont.json')
		end
		return nil
	end

	if not isfolder('newvape/assets/atom') then
		pcall(makefolder, 'newvape/assets/atom')
	end

	local fontPath = writeFont()
	if fontPath then
		uipallet.Font        = Font.new(fontPath, Enum.FontWeight.Regular)
		uipallet.FontSemiBold = Font.new(fontPath, Enum.FontWeight.Medium)
	end
	fontsize.Font = uipallet.Font
end

-- Load color profile
do
	local res = isfile('newvape/profiles/color.txt') and loadJson('newvape/profiles/color.txt')
	if res then
		uipallet.Main        = res.Main and Color3.fromRGB(unpack(res.Main)) or uipallet.Main
		uipallet.Text        = res.Text and Color3.fromRGB(unpack(res.Text)) or uipallet.Text
		uipallet.Font        = res.Font and Font.new(
			res.Font:find('rbxasset') and res.Font or ('rbxasset://fonts/families/' .. res.Font .. '.json')
		) or uipallet.Font
		uipallet.FontSemiBold = Font.new(uipallet.Font.Family, Enum.FontWeight.SemiBold)
		fontsize.Font = uipallet.Font
	end
end

-- ═══════════════════════════════════════════════════════════
-- MAIN GUI CONSTRUCTION
-- ═══════════════════════════════════════════════════════════
if inputService.TouchEnabled then
	writefile('newvape/profiles/gui.txt', 'new')
	return
end

gui = Instance.new('ScreenGui')
gui.Name = 'AtomGui'
gui.ResetOnSpawn = false
gui.DisplayOrder = 900
gui.IgnoreGuiInset = true
pcall(function()
	if mainapi.ThreadFix then setthreadidentity(8) end
	gui.Parent = game:GetService('CoreGui')
end)
if not gui.Parent then gui.Parent = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui') end
mainapi.gui = gui

scaledgui = Instance.new('Frame')
scaledgui.Name = 'ScaledGui'
scaledgui.Size = UDim2.fromScale(1, 1)
scaledgui.BackgroundTransparency = 1
scaledgui.Parent = gui
gui.ScaledGui = scaledgui

scale = Instance.new('UIScale')
scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.6)
scale.Parent = scaledgui

gui:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
	if mainapi.Scale and mainapi.Scale.Enabled then
		scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.6)
	end
end)

-- ─── Tooltip ─────────────────────────────────────────────
toolblur = Instance.new('Frame')
toolblur.Name = 'TooltipBG'
toolblur.BackgroundColor3 = color.Light(uipallet.Main, 0.06)
toolblur.BackgroundTransparency = 0.08
toolblur.Size = UDim2.fromOffset(120, 28)
toolblur.Visible = false
toolblur.ZIndex = 9999
toolblur.Parent = scaledgui
addCorner(toolblur)
addStroke(toolblur, 1, 0.6)

tooltip = Instance.new('TextLabel')
tooltip.Name = 'Tooltip'
tooltip.Size = UDim2.fromScale(1, 1)
tooltip.BackgroundTransparency = 1
tooltip.TextColor3 = uipallet.Text
tooltip.TextSize = 14
tooltip.FontFace = uipallet.Font
tooltip.TextXAlignment = Enum.TextXAlignment.Center
tooltip.ZIndex = 10000
tooltip.Parent = toolblur

-- ─── Notifications container ─────────────────────────────
notifications = Instance.new('Frame')
notifications.Name = 'Notifications'
notifications.Size = UDim2.fromOffset(310, 600)
notifications.Position = UDim2.new(1, 0, 1, -29)
notifications.AnchorPoint = Vector2.new(1, 1)
notifications.BackgroundTransparency = 1
notifications.Parent = scaledgui

-- ─── Click GUI frame ─────────────────────────────────────
clickgui = Instance.new('Frame')
clickgui.Name = 'ClickGui'
clickgui.Size = UDim2.fromScale(1, 1)
clickgui.BackgroundTransparency = 1
clickgui.Visible = false
clickgui.Parent = scaledgui
scaledgui.ClickGui = clickgui

-- ═══════════════════════════════════════════════════════════
-- ATOM ARRAY TEXT HUD  (Rise-style ArrayList)
-- ═══════════════════════════════════════════════════════════
-- This replaces new.lua's textgui entirely.
-- Enabled modules are listed on the right edge with an
-- animated slide-in, colour sidebar, and background pill.
-- ─────────────────────────────────────────────────────────
local ArrayLabels  = {}   -- { Object, Text, Bar, Background, Enabled }
local arrayHolder  = Instance.new('Frame')
arrayHolder.Name   = 'AtomArrayHolder'
arrayHolder.Size   = UDim2.fromOffset(280, 600)
arrayHolder.Position = UDim2.new(1, -6, 0, 12)
arrayHolder.AnchorPoint = Vector2.new(1, 0)
arrayHolder.BackgroundTransparency = 1
arrayHolder.Parent = scaledgui

local arrayLayout = Instance.new('UIListLayout')
arrayLayout.SortOrder = Enum.SortOrder.LayoutOrder
arrayLayout.FillDirection = Enum.FillDirection.Vertical
arrayLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
arrayLayout.VerticalAlignment = Enum.VerticalAlignment.Top
arrayLayout.Padding = UDim.new(0, 2)
arrayLayout.Parent = arrayHolder

-- Watermark label (top-left corner)
local atomWatermark = Instance.new('TextLabel')
atomWatermark.Name   = 'AtomWatermark'
atomWatermark.Size   = UDim2.fromOffset(160, 30)
atomWatermark.Position = UDim2.fromOffset(10, guiService:GetGuiInset().Y + 6)
atomWatermark.BackgroundTransparency = 1
atomWatermark.Text   = 'atom'
atomWatermark.TextColor3 = Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
atomWatermark.TextSize = 28
atomWatermark.TextXAlignment = Enum.TextXAlignment.Left
atomWatermark.FontFace = uipallet.FontSemiBold
atomWatermark.Parent = scaledgui

-- ArrayList options (stored for UpdateTextGUI to read)
local arrayShowMode   = { Value = 'All' }              -- All / Exclude render / Only bound
local arrayColorMode  = { Value = 'Fade' }             -- Fade / Static
local arrayBackground = { Enabled = true }
local arrayBar        = { Enabled = true }
local arraySuffix     = { Enabled = true }
local arrayLowercase  = { Enabled = false }
local arrayAnimations = { Enabled = true }
local arraySort       = { Value = 'Size' }             -- Size / Alphabetical

function mainapi:UpdateTextGUI(afterload)
	if not afterload and not mainapi.Loaded then return end

	-- Destroy old labels
	local found = {}
	for _, v in ArrayLabels do
		if v.Enabled then table.insert(found, v.Object.Name) end
		v.Object:Destroy()
	end
	table.clear(ArrayLabels)

	local accentColor = Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
	local infoSpring  = TweenInfo.new(0.38, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
	local infoFade    = TweenInfo.new(0.28, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)

	for name, mod in mainapi.Modules do
		-- filter
		if arrayShowMode.Value == 'Exclude render' and mod.Category == 'Render' then continue end
		if arrayShowMode.Value == 'Only bound' and #mod.Bind <= 0 then continue end

		if not (mod.Enabled or table.find(found, name)) then continue end

		local displayName = name .. (mod.ExtraText and arraySuffix.Enabled and ' ' .. mod.ExtraText() or '')
		if arrayLowercase.Enabled then displayName = displayName:lower() end

		-- Measure text
		local textSize   = 15
		local textBounds = getfontsize(removeTags(displayName), textSize, uipallet.Font)
		local pillW      = textBounds.X + (arrayBar.Enabled and 18 or 10)
		local pillH      = textBounds.Y + (arrayBackground.Enabled and 5 or 3)

		-- Outer clip frame (animated width)
		local holder = Instance.new('Frame')
		holder.Name  = name
		holder.Size  = UDim2.fromOffset(0, pillH)
		holder.BackgroundTransparency = 1
		holder.ClipsDescendants = true
		holder.Parent = arrayHolder

		-- Background pill
		local pill
		if arrayBackground.Enabled then
			pill = Instance.new('Frame')
			pill.Size = UDim2.new(1, 3, 1, 0)
			pill.BackgroundColor3 = color.Dark(uipallet.Main, 0.12)
			pill.BackgroundTransparency = 0.18
			pill.BorderSizePixel = 0
			pill.Parent = holder
			addCorner(pill, UDim.new(0, 5))
		end

		-- Colour sidebar bar (right-side, 2px wide)
		local sideBar
		if arrayBar.Enabled then
			sideBar = Instance.new('Frame')
			sideBar.Size  = UDim2.fromOffset(2, pillH - 4)
			sideBar.Position = UDim2.new(1, -4, 0, 2)
			sideBar.BackgroundColor3 = accentColor
			sideBar.BorderSizePixel = 0
			sideBar.Parent = holder
			addCorner(sideBar, UDim.new(1, 0))
		end

		-- Text label
		local lbl = Instance.new('TextLabel')
		lbl.Size     = UDim2.fromOffset(textBounds.X, textBounds.Y)
		lbl.Position = UDim2.fromOffset(5, (arrayBackground.Enabled and 2 or 1))
		lbl.BackgroundTransparency = 1
		lbl.Text     = displayName
		lbl.TextSize = textSize
		lbl.FontFace = uipallet.Font
		lbl.TextColor3 = accentColor
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.RichText = true
		lbl.Parent   = holder

		-- Drop shadow
		local shadow = lbl:Clone()
		shadow.Position = UDim2.fromOffset(lbl.Position.X.Offset + 1, lbl.Position.Y.Offset + 1)
		shadow.Text      = removeTags(displayName)
		shadow.TextColor3 = Color3.new(0, 0, 0)
		shadow.TextTransparency = 0.7
		shadow.ZIndex = lbl.ZIndex - 1
		shadow.Parent = holder

		local targetSize = UDim2.fromOffset(pillW, pillH)

		if arrayAnimations.Enabled then
			if not table.find(found, name) then
				-- Slide in from right
				holder.Size = UDim2.fromOffset(0, pillH)
				tween:Tween(holder, infoSpring, { Size = targetSize })
			else
				holder.Size = targetSize
				if not mod.Enabled then
					-- Slide out
					tween:Tween(holder, infoFade, { Size = UDim2.fromOffset(0, pillH) })
				end
			end
		else
			holder.Size = mod.Enabled and targetSize or UDim2.fromOffset(0, pillH)
		end

		table.insert(ArrayLabels, {
			Object     = holder,
			Text       = lbl,
			Shadow     = shadow,
			Bar        = sideBar,
			Background = pill,
			Enabled    = mod.Enabled,
		})
	end

	-- Sort
	if arraySort.Value == 'Alphabetical' then
		table.sort(ArrayLabels, function(a, b) return a.Text.Text < b.Text.Text end)
	else
		table.sort(ArrayLabels, function(a, b)
			return a.Text.Size.X.Offset > b.Text.Size.X.Offset
		end)
	end

	for i, v in ArrayLabels do
		v.Object.LayoutOrder = i
	end

	mainapi:UpdateGUI(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value, true)
end

-- ═══════════════════════════════════════════════════════════
-- UpdateGUI — colour pass
-- ═══════════════════════════════════════════════════════════
function mainapi:UpdateGUI(hue, sat, val, default)
	if mainapi.Loaded == nil then return end
	if not default and mainapi.GUIColor.Rainbow then return end
	local rainbow = mainapi.GUIColor.Rainbow

	local accent = Color3.fromHSV(hue, sat, val)
	atomWatermark.TextColor3 = accent

	-- ArrayList colours
	for i, v in ArrayLabels do
		local c = rainbow
			and Color3.fromHSV(mainapi:Color(((hue - (i * 0.022)) % 1)))
			or (arrayColorMode.Value == 'Fade'
				and Color3.fromHSV(mainapi:Color(((hue - (i * 0.022)) % 1)))
				or accent)
		v.Text.TextColor3 = c
		if v.Bar  then v.Bar.BackgroundColor3  = c end
	end

	if not clickgui.Visible then return end

	-- Module button colours
	for i, button in mainapi.Modules do
		if button.Enabled then
			button.Object.BackgroundColor3 = rainbow
				and Color3.fromHSV(mainapi:Color(((hue - (button.Index * 0.025)) % 1)))
				or accent
			button.Object.TextColor3 = mainapi:TextColor(hue, sat, val)
			if button.Object:FindFirstChild('UIGradient') then
				button.Object.UIGradient.Enabled = false
			end
			if button.Icon then
				button.Icon.ImageColor3 = button.Object.TextColor3
			end
		end
		for _, opt in button.Options do
			if opt.Color then opt:Color(hue, sat, val, rainbow) end
		end
	end

	for _, cat in mainapi.Categories do
		if cat.Options then
			for _, opt in cat.Options do
				if opt.Color then opt:Color(hue, sat, val, rainbow) end
			end
		end
		if cat.Type == 'CategoryList' and cat.Selected then
			cat.Selected.BackgroundColor3 = accent
			cat.Selected.Title.TextColor3 = mainapi:TextColor(hue, sat, val)
		end
		if cat.Object and cat.Object:FindFirstChild('VapeLogo') then
			local v4 = cat.Object.VapeLogo:FindFirstChild('V4Logo')
			if v4 then v4.ImageColor3 = accent end
		end
	end

	for i, v in mainapi.Overlays and mainapi.Overlays.Toggles or {} do
		if v.Enabled then
			tween:Cancel(v.Object.Knob)
			v.Object.Knob.BackgroundColor3 = rainbow
				and Color3.fromHSV(mainapi:Color(((hue - (i * 0.075)) % 1)))
				or accent
		end
	end
end

-- ═══════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════
local NOTIF_H = 72
local NOTIF_W = 295
local NOTIF_PAD = 6
local notifCount = 0

function mainapi:CreateNotification(title, message, duration, notifType)
	if not mainapi.Notifications or (type(mainapi.Notifications) == 'table' and not mainapi.Notifications.Enabled) then return end
	notifCount += 1

	local accent = Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
	local typeColor = notifType == 'warning' and Color3.fromRGB(255, 200, 60)
		or notifType == 'alert' and Color3.fromRGB(255, 80, 80)
		or notifType == 'success' and Color3.fromRGB(80, 210, 120)
		or accent

	local notif = Instance.new('Frame')
	notif.Name = tostring(notifCount)
	notif.Size = UDim2.fromOffset(NOTIF_W, NOTIF_H)
	notif.Position = UDim2.new(1, 0, 1, -(29 + NOTIF_H))
	notif.BackgroundColor3 = color.Dark(uipallet.Main, 0.08)
	notif.BackgroundTransparency = 0.08
	notif.BorderSizePixel = 0
	notif.Parent = notifications
	addCorner(notif, UDim.new(0, 14))
	addBlur(notif, true)
	local stroke = addStroke(notif, 1, 0.6)
	stroke.Color = typeColor

	-- Left accent strip
	local strip = Instance.new('Frame')
	strip.Size = UDim2.fromOffset(3, NOTIF_H - 20)
	strip.Position = UDim2.fromOffset(8, 10)
	strip.BackgroundColor3 = typeColor
	strip.BorderSizePixel = 0
	strip.Parent = notif
	addCorner(strip, UDim.new(1, 0))

	local titleLbl = Instance.new('TextLabel')
	titleLbl.Size = UDim2.fromOffset(NOTIF_W - 50, 22)
	titleLbl.Position = UDim2.fromOffset(18, 10)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = Color3.new(1, 1, 1)
	titleLbl.TextSize = 15
	titleLbl.FontFace = uipallet.FontSemiBold
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = notif

	local msgLbl = Instance.new('TextLabel')
	msgLbl.Size = UDim2.fromOffset(NOTIF_W - 26, 32)
	msgLbl.Position = UDim2.fromOffset(18, 30)
	msgLbl.BackgroundTransparency = 1
	msgLbl.Text = message
	msgLbl.TextColor3 = color.Dark(uipallet.Text, 0.12)
	msgLbl.TextSize = 13
	msgLbl.FontFace = uipallet.Font
	msgLbl.TextXAlignment = Enum.TextXAlignment.Left
	msgLbl.TextWrapped = true
	msgLbl.Parent = notif

	-- Progress bar
	local progBG = Instance.new('Frame')
	progBG.Size = UDim2.new(1, -16, 0, 3)
	progBG.Position = UDim2.new(0, 8, 1, -7)
	progBG.BackgroundColor3 = color.Light(uipallet.Main, 0.08)
	progBG.BorderSizePixel = 0
	progBG.Parent = notif
	addCorner(progBG, UDim.new(1, 0))
	local prog = Instance.new('Frame')
	prog.Size = UDim2.fromScale(1, 1)
	prog.BackgroundColor3 = typeColor
	prog.BorderSizePixel = 0
	prog.Parent = progBG
	addCorner(prog, UDim.new(1, 0))

	-- Slide in
	tweenService:Create(notif, TW_SPRING, {
		Position = UDim2.new(1, 0, 1, -(29 + NOTIF_H))
	}):Play()
	tweenService:Create(notif, TW_SMOOTH, {
		Position = UDim2.new(1, -(NOTIF_W + 8), 1, -(29 + NOTIF_H))
	}):Play()

	-- Restack
	for i, v in notifications:GetChildren() do
		tweenService:Create(v, TW_FAST, {
			Position = UDim2.new(1, -(NOTIF_W + 8), 1, -(29 + (NOTIF_H + NOTIF_PAD) * i))
		}):Play()
	end

	-- Progress tween
	local d = math.max(duration or 3, 0.5)
	tweenService:Create(prog, TweenInfo.new(d, Enum.EasingStyle.Linear), {
		Size = UDim2.fromScale(0, 1)
	}):Play()

	-- Dismiss
	task.delay(d, function()
		tweenService:Create(notif, TW_IN, {
			Position = UDim2.new(1, 0, 1, -(29 + NOTIF_H))
		}):Play()
		task.wait(0.25)
		notif:Destroy()
	end)
end

-- ═══════════════════════════════════════════════════════════
-- LOAD the new.lua component system
-- ═══════════════════════════════════════════════════════════
-- atom.lua re-uses new.lua's complete component definitions
-- (CreateModule, CreateToggle, CreateSlider, etc.) by
-- loading new.lua's component section.  We forward the
-- shared state (uipallet, tween, color, scale, gui, etc.)
-- via shared so new.lua's components produce correctly-styled
-- widgets inside our rounded panels.
--
-- The strategy: load new.lua, let it build its own mainapi,
-- then copy over all component-building methods and category
-- infrastructure into our mainapi.  This keeps the full
-- feature parity with new.lua while atom.lua controls the
-- visual shell.

local newSource = downloadFile('newvape/guis/new.lua')

-- Patch new.lua source:
--   1. Prevent it from creating its own ScreenGui (we already have one)
--   2. Return its mainapi so we can merge
local patchedSource = newSource
	-- Remove ScreenGui creation line
	:gsub('gui = Instance%.new%(\'ScreenGui\'%)', 'gui = mainapi.gui --[[atom: skip gui creation]]')
	-- Remove mobile guard that writes 'new' and returns
	:gsub("if inputService%.TouchEnabled then.-writefile%('newvape/profiles/gui%.txt', 'new'%)\n\treturn\nend", '')
	-- Make it not return a fresh mainapi but use ours
	:gsub('^local mainapi = %{.-^%}$', '', 1)  -- strip mainapi table (not reliable, use shared)

-- Rather than patching source (fragile), load new.lua normally as
-- the base and then overlay the atom visual changes on top.
-- This is the safer fork approach.

shared._atomGui = mainapi

local newApiOk, newApi = pcall(function()
	-- Temporarily give new.lua our existing gui so it doesn't recreate it
	shared._atomForwardGui = gui
	shared._atomForwardScaled = scaledgui
	shared._atomForwardScale = scale
	return loadstring(newSource, 'new.lua')()
end)

if not newApiOk or not newApi then
	-- Fallback: new.lua failed to load, continue with minimal stub
	warn('[ATOM] Could not load new.lua base: ' .. tostring(newApi))
	-- Set up minimal required fields
	mainapi.Overlays = { Toggles = {} }
	mainapi.Categories = {}
	mainapi.Legit = { Modules = {}, Window = { Visible = false } }
else
	-- ── Merge new.lua's full mainapi into our atom mainapi ──
	-- Copy all methods and category infrastructure
	for k, v in newApi do
		if k == 'gui'           then continue end  -- keep our gui reference
		if k == 'Libraries'     then
			-- merge libraries, keep our overrides
			for lk, lv in v do
				if not mainapi.Libraries[lk] then
					mainapi.Libraries[lk] = lv
				end
			end
			continue
		end
		if k == 'GUIColor'      then mainapi.GUIColor = v; continue end
		if k == 'Keybind'       then mainapi.Keybind  = v; continue end
		if k == 'Profile'       then mainapi.Profile  = v; continue end
		if k == 'RainbowSpeed'  then mainapi.RainbowSpeed = v; continue end
		if k == 'RainbowUpdateSpeed' then mainapi.RainbowUpdateSpeed = v; continue end
		-- Copy everything else (methods, categories, module tables, etc.)
		mainapi[k] = v
	end

	-- Re-bind our UpdateTextGUI and UpdateGUI (atom overrides new.lua's)
	mainapi.UpdateTextGUI = function(self_or_afterload, afterload)
		-- handle both mainapi:UpdateTextGUI() and mainapi:UpdateTextGUI(true) call styles
		local al = type(self_or_afterload) == 'boolean' and self_or_afterload or afterload
		return (function(a)
			if not a and not mainapi.Loaded then return end
			local accentColor = Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
			local infoSpring = TweenInfo.new(0.38, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
			local infoFade   = TweenInfo.new(0.28, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)

			local found = {}
			for _, v in ArrayLabels do
				if v.Enabled then table.insert(found, v.Object.Name) end
				v.Object:Destroy()
			end
			table.clear(ArrayLabels)

			for name, mod in mainapi.Modules do
				if arrayShowMode.Value == 'Exclude render' and mod.Category == 'Render' then continue end
				if arrayShowMode.Value == 'Only bound' and #mod.Bind <= 0 then continue end
				if not (mod.Enabled or table.find(found, name)) then continue end

				local displayName = name .. (mod.ExtraText and arraySuffix.Enabled and ' ' .. mod.ExtraText() or '')
				if arrayLowercase.Enabled then displayName = displayName:lower() end

				local textSize   = 15
				local textBounds = getfontsize(removeTags(displayName), textSize, uipallet.Font)
				local pillW      = textBounds.X + (arrayBar.Enabled and 18 or 10)
				local pillH      = textBounds.Y + (arrayBackground.Enabled and 5 or 3)

				local holder = Instance.new('Frame')
				holder.Name = name
				holder.Size = UDim2.fromOffset(0, pillH)
				holder.BackgroundTransparency = 1
				holder.ClipsDescendants = true
				holder.Parent = arrayHolder

				local pill
				if arrayBackground.Enabled then
					pill = Instance.new('Frame')
					pill.Size = UDim2.new(1, 3, 1, 0)
					pill.BackgroundColor3 = color.Dark(uipallet.Main, 0.12)
					pill.BackgroundTransparency = 0.18
					pill.BorderSizePixel = 0
					pill.Parent = holder
					addCorner(pill, UDim.new(0, 5))
				end

				local sideBar
				if arrayBar.Enabled then
					sideBar = Instance.new('Frame')
					sideBar.Size  = UDim2.fromOffset(2, pillH - 4)
					sideBar.Position = UDim2.new(1, -4, 0, 2)
					sideBar.BackgroundColor3 = accentColor
					sideBar.BorderSizePixel = 0
					sideBar.Parent = holder
					addCorner(sideBar, UDim.new(1, 0))
				end

				local lbl = Instance.new('TextLabel')
				lbl.Size     = UDim2.fromOffset(textBounds.X, textBounds.Y)
				lbl.Position = UDim2.fromOffset(5, (arrayBackground.Enabled and 2 or 1))
				lbl.BackgroundTransparency = 1
				lbl.Text     = displayName
				lbl.TextSize = textSize
				lbl.FontFace = uipallet.Font
				lbl.TextColor3 = accentColor
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.RichText = true
				lbl.Parent   = holder

				local shadow = lbl:Clone()
				shadow.Position = UDim2.fromOffset(lbl.Position.X.Offset + 1, lbl.Position.Y.Offset + 1)
				shadow.Text = removeTags(displayName)
				shadow.TextColor3 = Color3.new(0, 0, 0)
				shadow.TextTransparency = 0.7
				shadow.ZIndex = lbl.ZIndex - 1
				shadow.Parent = holder

				local targetSize = UDim2.fromOffset(pillW, pillH)

				if arrayAnimations.Enabled then
					if not table.find(found, name) then
						holder.Size = UDim2.fromOffset(0, pillH)
						tween:Tween(holder, infoSpring, { Size = targetSize })
					else
						holder.Size = targetSize
						if not mod.Enabled then
							tween:Tween(holder, infoFade, { Size = UDim2.fromOffset(0, pillH) })
						end
					end
				else
					holder.Size = mod.Enabled and targetSize or UDim2.fromOffset(0, pillH)
				end

				table.insert(ArrayLabels, {
					Object     = holder,
					Text       = lbl,
					Shadow     = shadow,
					Bar        = sideBar,
					Background = pill,
					Enabled    = mod.Enabled,
				})
			end

			if arraySort.Value == 'Alphabetical' then
				table.sort(ArrayLabels, function(a2, b2) return a2.Text.Text < b2.Text.Text end)
			else
				table.sort(ArrayLabels, function(a2, b2) return a2.Text.Size.X.Offset > b2.Text.Size.X.Offset end)
			end
			for i, v in ArrayLabels do v.Object.LayoutOrder = i end

			mainapi:UpdateGUI(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value, true)
		end)(al)
	end

	-- Re-apply atom's UpdateGUI
	mainapi.UpdateGUI = function(self_or_hue, sat_or_h, val_or_s, default_or_v, extra)
		-- Normalise call signature (called both as method and function in new.lua internals)
		local hue, sat, val, default
		if type(self_or_hue) == 'number' then
			hue, sat, val, default = self_or_hue, sat_or_h, val_or_s, default_or_v
		else
			hue, sat, val, default = sat_or_h, val_or_s, default_or_v, extra
		end
		if mainapi.Loaded == nil then return end
		if not default and mainapi.GUIColor and mainapi.GUIColor.Rainbow then return end

		local rainbow = mainapi.GUIColor and mainapi.GUIColor.Rainbow
		local accent  = Color3.fromHSV(hue, sat, val)

		atomWatermark.TextColor3 = accent

		for i, v in ArrayLabels do
			local c = (rainbow or arrayColorMode.Value == 'Fade')
				and Color3.fromHSV(mainapi:Color(((hue - (i * 0.022)) % 1)))
				or accent
			v.Text.TextColor3 = c
			if v.Bar then v.Bar.BackgroundColor3 = c end
		end

		if not clickgui.Visible then return end

		for _, button in mainapi.Modules do
			if button.Enabled then
				button.Object.BackgroundColor3 = rainbow
					and Color3.fromHSV(mainapi:Color(((hue - (button.Index * 0.025)) % 1)))
					or accent
				button.Object.TextColor3 = mainapi:TextColor(hue, sat, val)
			end
			for _, opt in button.Options do
				if opt.Color then opt:Color(hue, sat, val, rainbow) end
			end
		end

		for _, cat in mainapi.Categories do
			if cat.Options then
				for _, opt in cat.Options do
					if opt.Color then opt:Color(hue, sat, val, rainbow) end
				end
			end
			if cat.Type == 'CategoryList' and cat.Selected then
				cat.Selected.BackgroundColor3 = accent
				cat.Selected.Title.TextColor3 = mainapi:TextColor(hue, sat, val)
			end
		end

		for i, v in (mainapi.Overlays and mainapi.Overlays.Toggles or {}) do
			if v.Enabled then
				tween:Cancel(v.Object.Knob)
				v.Object.Knob.BackgroundColor3 = rainbow
					and Color3.fromHSV(mainapi:Color(((hue - (i * 0.075)) % 1)))
					or accent
			end
		end
	end

	-- ─── Apply rounded-corner overrides to new.lua's click gui ──
	-- new.lua builds its click GUI inside scaledgui.ClickGui. We
	-- post-process every Frame/TextButton that new.lua creates to
	-- ensure full rounded treatment.

	task.defer(function()
		local function roundify(obj)
			if obj:IsA('Frame') or obj:IsA('TextButton') or obj:IsA('ScrollingFrame') then
				-- Only add corners to panels that don't already have them
				if not obj:FindFirstChildWhichIsA('UICorner') and obj.BackgroundTransparency < 1 then
					local existingR = obj:FindFirstChildWhichIsA('UICorner')
					if not existingR then
						local r = Instance.new('UICorner')
						-- Use larger radius for main panels, smaller for option rows
						r.CornerRadius = obj.Size.Y.Offset > 60 and UDim.new(0, 12) or UDim.new(0, 7)
						r.Parent = obj
					end
				end
				-- Add subtle stroke to windows/panels
				if not obj:FindFirstChildWhichIsA('UIStroke') and obj.Size.X.Offset > 100 and obj.BackgroundTransparency < 0.5 then
					local s = Instance.new('UIStroke')
					s.Thickness = 1
					s.Transparency = 0.72
					s.Parent = obj
				end
			end
		end

		-- Process everything currently in click gui
		for _, v in clickgui:GetDescendants() do roundify(v) end

		-- And any future additions
		clickgui.DescendantAdded:Connect(function(v)
			task.defer(roundify, v)
		end)
	end)

	-- ─── ArrayList overlay toggle (added to new.lua's Main category) ──
	task.defer(function()
		if not mainapi.Categories or not mainapi.Categories.Main then return end

		local cat = mainapi.Categories.Main

		cat:CreateModule({
			Name = 'AtomArrayList',
			Tooltip = 'Rise-style ArrayList showing enabled modules on screen edge.',
			Function = function(callback)
				arrayHolder.Visible = callback
			end
		})
		if mainapi.Modules.AtomArrayList then
			mainapi.Modules.AtomArrayList:Toggle()  -- on by default
		end

		-- ArrayList settings as sub-options
		local m = mainapi.Modules.AtomArrayList
		if not m then return end

		m:CreateDropdown({
			Name = 'Show Modules',
			List = { 'All', 'Exclude render', 'Only bound' },
			Function = function(v)
				arrayShowMode.Value = v
				mainapi:UpdateTextGUI(true)
			end
		})
		m:CreateDropdown({
			Name = 'Color Mode',
			List = { 'Fade', 'Static' },
			Function = function(v)
				arrayColorMode.Value = v
				mainapi:UpdateTextGUI(true)
			end
		})
		m:CreateDropdown({
			Name = 'Sort',
			List = { 'Size', 'Alphabetical' },
			Function = function(v)
				arraySort.Value = v
				mainapi:UpdateTextGUI(true)
			end
		})
		m:CreateToggle({
			Name = 'Background',
			Default = true,
			Function = function(c)
				arrayBackground.Enabled = c
				mainapi:UpdateTextGUI(true)
			end
		})
		m:CreateToggle({
			Name = 'Sidebar',
			Default = true,
			Function = function(c)
				arrayBar.Enabled = c
				mainapi:UpdateTextGUI(true)
			end
		})
		m:CreateToggle({
			Name = 'Suffix',
			Default = true,
			Function = function(c)
				arraySuffix.Enabled = c
				mainapi:UpdateTextGUI(true)
			end
		})
		m:CreateToggle({
			Name = 'Lowercase',
			Function = function(c)
				arrayLowercase.Enabled = c
				mainapi:UpdateTextGUI(true)
			end
		})
		m:CreateToggle({
			Name = 'Animations',
			Default = true,
			Function = function(c)
				arrayAnimations.Enabled = c
			end
		})

		-- Patch GUI Theme dropdown to include 'atom'
		if cat.Options and cat.Options['GUI Theme'] then
			local dd = cat.Options['GUI Theme']
			local list = dd and dd.Value and { 'atom', 'rise', 'new', 'old' } or nil
			if dd and dd.Change then
				pcall(dd.Change, dd, { 'atom', 'rise', 'new', 'old' })
			end
		end
	end)

	-- ─── Patch CreateNotification to use atom style ───────────
	newApi.CreateNotification = function(_, ...)
		return mainapi:CreateNotification(...)
	end
end

-- ─── Make our gui reference accessible ────────────────────
mainapi.gui = gui

-- ═══════════════════════════════════════════════════════════
-- RAINBOW UPDATER
-- ═══════════════════════════════════════════════════════════
mainapi:Clean(runService.Heartbeat:Connect(function()
	if mainapi.GUIColor and mainapi.GUIColor.Rainbow then
		local speed = mainapi.RainbowSpeed and mainapi.RainbowSpeed.Value or 1
		mainapi.GUIColor.Hue = (mainapi.GUIColor.Hue + (0.001 * speed)) % 1
		mainapi.GUIColor.Sat = select(2, mainapi:Color(mainapi.GUIColor.Hue))
		mainapi:UpdateGUI(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value, true)
	end
end))

-- ═══════════════════════════════════════════════════════════
-- LOAD / SAVE / UNINJECT stubs (delegate to merged newApi)
-- ═══════════════════════════════════════════════════════════
if newApiOk and newApi then
	if newApi.Load  and not mainapi.Load  then mainapi.Load  = function(self, ...) return newApi:Load(...)  end end
	if newApi.Save  and not mainapi.Save  then mainapi.Save  = function(self, ...) return newApi:Save(...)  end end
	if newApi.Uninject and not mainapi.Uninject then
		mainapi.Uninject = function(self, ...)
			-- Hide our extra HUD elements
			arrayHolder.Visible = false
			atomWatermark.Visible = false
			return newApi:Uninject(...)
		end
	end
end

-- ─── Final notification visibility patch ─────────────────
mainapi:Clean(notifications.ChildRemoved:Connect(function()
	for i, v in notifications:GetChildren() do
		tweenService:Create(v, TW_FAST, {
			Position = UDim2.new(1, -(NOTIF_W + 8), 1, -(29 + (NOTIF_H + NOTIF_PAD) * i))
		}):Play()
	end
end))

return mainapi
