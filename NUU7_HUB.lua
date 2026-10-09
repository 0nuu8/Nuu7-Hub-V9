-- NUU7 HUB | LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local GUI_NAME = "NUU7_HUB"
local oldGui = PlayerGui:FindFirstChild(GUI_NAME)
if oldGui then
	oldGui:Destroy()
end
if shared.NUU7Hub and type(shared.NUU7Hub.Destroy) == "function" then
	pcall(shared.NUU7Hub.Destroy)
end

----------------------------------------------------------------
-- CONFIGURACIÓN CENTRAL
----------------------------------------------------------------
local Config = {
	HubName = "NUU7 HUB",
	LogoImage = "rbxassetid://92548753285325",
	AccentColor = Color3.fromRGB(90, 170, 255),
	DefaultPage = "NuShoot",
	ToggleKey = Enum.KeyCode.RightControl,
	ShowPlayerProfile = true,
	EnableAnimations = true,
	ShowFPS = true,
	AllowEnvironmentPreview = true,
	FPSUpdateInterval = 0.5,

	Window = {
		Width = 580,
		Height = 340,
		MarginX = 24,
		MarginY = 24,
		SidebarWidth = 150,
		SidebarCompactWidth = 56,
		CompactBelow = 520,
	},

	Pages = {
		{ Id = "NuShoot", Title = "NuShoot", Icon = "", Description = "Modo de disparo, detección y FOV." },
		{ Id = "ESP", Title = "ESP", Icon = "", Description = "Representación visual de objetivos y colores." },
		{ Id = "Hitbox", Title = "Hitbox", Icon = "", Description = "Detección, FOV y partes del cuerpo." },
		{ Id = "Settings", Title = "Settings", Icon = "", Description = "Temas, entorno e interfaz." },
		{ Id = "Avatar", Title = "Avatar", Icon = "", Description = "Personaliza tu tarjeta de perfil." },
	},

	BodyParts = {
		{ Name = "Head" },
		{ Name = "HumanoidRootPart" },
		{ Name = "Torso" },
		{ Name = "UpperTorso" },
		{ Name = "LowerTorso" },
		{ Name = "Left Arm" },
		{ Name = "Right Arm" },
		{ Name = "Left Leg" },
		{ Name = "Right Leg" },
		{ Name = "LeftUpperArm" },
		{ Name = "LeftLowerArm" },
		{ Name = "LeftHand" },
		{ Name = "RightUpperArm" },
		{ Name = "RightLowerArm" },
		{ Name = "RightHand" },
		{ Name = "LeftUpperLeg" },
		{ Name = "LeftLowerLeg" },
		{ Name = "LeftFoot" },
		{ Name = "RightUpperLeg" },
		{ Name = "RightLowerLeg" },
		{ Name = "RightFoot" },
	},
}

----------------------------------------------------------------
-- TEMA
----------------------------------------------------------------
local Theme = {
	Background = Color3.fromHex("08090B"),
	Surface = Color3.fromHex("111318"),
	SurfaceSecondary = Color3.fromHex("17191F"),
	SurfaceHover = Color3.fromHex("1D2028"),
	Border = Color3.new(1, 1, 1),
	BorderTransparency = 0.92,
	PrimaryText = Color3.fromHex("F5F5F7"),
	SecondaryText = Color3.fromHex("A1A1AA"),
	Accent = Config.AccentColor,
	Success = Color3.fromRGB(80, 210, 120),
	Danger = Color3.fromRGB(255, 90, 90),
	ToggleOff = Color3.fromHex("2A2D36"),
	TrackBar = Color3.fromHex("2A2D36"),
	Knob = Color3.fromHex("F5F5F7"),

	FontRegular = Enum.Font.Gotham,
	FontMedium = Enum.Font.GothamMedium,
	FontBold = Enum.Font.GothamBold,

	CornerLarge = 14,
	CornerMedium = 10,
	CornerSmall = 6,
}

local ThemePresets = {
	Default = {
		Label = "Default",
		Accent = Color3.fromRGB(90, 170, 255),
		Preview = { Color3.fromRGB(8, 9, 11), Color3.fromRGB(23, 25, 31), Color3.fromRGB(90, 170, 255) },
		Lighting = nil,
	},
	Tokoyami = {
		Label = "Tokoyami",
		Accent = Color3.fromRGB(255, 150, 80),
		Preview = { Color3.fromRGB(40, 22, 18), Color3.fromRGB(255, 150, 80), Color3.fromRGB(255, 210, 160) },
		Lighting = {
			ClockTime = 18,
			Ambient = Color3.fromRGB(120, 85, 70),
			OutdoorAmbient = Color3.fromRGB(150, 105, 80),
			FogColor = Color3.fromRGB(255, 170, 120),
			FogStart = 40,
			FogEnd = 450,
		},
	},
	Night = {
		Label = "Night",
		Accent = Color3.fromRGB(110, 120, 255),
		Preview = { Color3.fromRGB(6, 8, 24), Color3.fromRGB(110, 120, 255), Color3.fromRGB(0, 255, 220) },
		Lighting = {
			ClockTime = 0,
			Ambient = Color3.fromRGB(30, 35, 70),
			OutdoorAmbient = Color3.fromRGB(25, 30, 60),
			FogColor = Color3.fromRGB(10, 12, 35),
			FogStart = 80,
			FogEnd = 900,
		},
	},
	Pink = {
		Label = "Pink",
		Accent = Color3.fromRGB(255, 90, 200),
		Preview = { Color3.fromRGB(30, 10, 40), Color3.fromRGB(255, 90, 200), Color3.fromRGB(150, 90, 255) },
		Lighting = {
			ClockTime = 19,
			Ambient = Color3.fromRGB(110, 60, 130),
			OutdoorAmbient = Color3.fromRGB(140, 70, 150),
			FogColor = Color3.fromRGB(190, 80, 200),
			FogStart = 60,
			FogEnd = 700,
		},
	},
}

----------------------------------------------------------------
-- UTILIDADES
----------------------------------------------------------------
local Utils = {}

function Utils.Clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

function Utils.Snap(value, step, min)
	local snapped = min + math.floor((value - min) / step + 0.5) * step
	return math.floor(snapped * 1000000 + 0.5) / 1000000
end

function Utils.DeepCopy(value)
	if type(value) ~= "table" then
		return value
	end
	local copy = {}
	for k, v in pairs(value) do
		copy[k] = Utils.DeepCopy(v)
	end
	return copy
end

function Utils.SafeCall(fn, ...)
	if type(fn) ~= "function" then
		return false
	end
	local ok, err = pcall(fn, ...)
	if not ok then
		warn("[NUU7 HUB] Error controlado: " .. tostring(err))
	end
	return ok
end

function Utils.Require(options, key, expectedType, caller)
	if type(options) ~= "table" then
		error(("[NUU7 HUB] %s: se esperaba una tabla de opciones"):format(caller or "?"), 3)
	end
	if typeof(options[key]) ~= expectedType then
		error(("[NUU7 HUB] %s: '%s' debe ser de tipo %s"):format(caller or "?", key, expectedType), 3)
	end
end

function Utils.GetViewport()
	local camera = workspace.CurrentCamera
	if camera then
		return camera.ViewportSize
	end
	return Vector2.new(1280, 720)
end

function Utils.GetAvailableBodyParts(model)
	local result = {}
	for _, def in ipairs(Config.BodyParts) do
		if not model then
			table.insert(result, def.Name)
		else
			local part = model:FindFirstChild(def.Name)
			if part and part:IsA("BasePart") then
				table.insert(result, def.Name)
			end
		end
	end
	if #result == 0 then
		for _, def in ipairs(Config.BodyParts) do
			table.insert(result, def.Name)
		end
	end
	return result
end

function Utils.ColorToHex(color)
	return string.format(
		"#%02X%02X%02X",
		math.floor(color.R * 255 + 0.5),
		math.floor(color.G * 255 + 0.5),
		math.floor(color.B * 255 + 0.5)
	)
end

function Utils.New(className, props, children)
	local instance = Instance.new(className)
	local parent = nil
	if props then
		for k, v in pairs(props) do
			if k == "Parent" then
				parent = v
			else
				instance[k] = v
			end
		end
	end
	if children then
		for _, child in ipairs(children) do
			child.Parent = instance
		end
	end
	if parent then
		instance.Parent = parent
	end
	return instance
end

function Utils.Corner(parent, radius)
	return Utils.New("UICorner", { CornerRadius = UDim.new(0, radius or Theme.CornerMedium), Parent = parent })
end

function Utils.Stroke(parent, transparency, thickness, color)
	return Utils.New("UIStroke", {
		Color = color or Theme.Border,
		Transparency = transparency or Theme.BorderTransparency,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end

function Utils.Padding(parent, left, top, right, bottom)
	return Utils.New("UIPadding", {
		PaddingLeft = UDim.new(0, left or 0),
		PaddingTop = UDim.new(0, top or left or 0),
		PaddingRight = UDim.new(0, right or left or 0),
		PaddingBottom = UDim.new(0, bottom or top or left or 0),
		Parent = parent,
	})
end

function Utils.List(parent, padding, direction, horizontalAlignment, verticalAlignment)
	return Utils.New("UIListLayout", {
		Padding = UDim.new(0, padding or 0),
		FillDirection = direction or Enum.FillDirection.Vertical,
		HorizontalAlignment = horizontalAlignment or Enum.HorizontalAlignment.Left,
		VerticalAlignment = verticalAlignment or Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = parent,
	})
end

function Utils.Label(props)
	return Utils.New("TextLabel", {
		Name = props.Name or "Label",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = props.Font or Theme.FontRegular,
		Text = props.Text or "",
		TextColor3 = props.Color or Theme.PrimaryText,
		TextSize = props.Size or 13,
		TextXAlignment = props.AlignX or Enum.TextXAlignment.Left,
		TextYAlignment = props.AlignY or Enum.TextYAlignment.Center,
		TextTruncate = props.Truncate or Enum.TextTruncate.None,
		TextWrapped = props.Wrapped or false,
		AutomaticSize = props.AutoSize or Enum.AutomaticSize.None,
		Size = props.Frame or UDim2.new(1, 0, 0, 16),
		Position = props.Position or UDim2.new(0, 0, 0, 0),
		AnchorPoint = props.AnchorPoint or Vector2.new(0, 0),
		LayoutOrder = props.LayoutOrder or 0,
		Parent = props.Parent,
	})
end

----------------------------------------------------------------
-- MAID (LIMPIEZA DE CONEXIONES E INSTANCIAS)
----------------------------------------------------------------
local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({ _tasks = {} }, Maid)
end

function Maid:Give(task)
	table.insert(self._tasks, task)
	return task
end

function Maid:Clean()
	local tasks = self._tasks
	self._tasks = {}
	for i = #tasks, 1, -1 do
		local item = tasks[i]
		local kind = typeof(item)
		if kind == "RBXScriptConnection" then
			item:Disconnect()
		elseif kind == "Instance" then
			item:Destroy()
		elseif kind == "function" then
			pcall(item)
		elseif kind == "table" then
			if type(item.Disconnect) == "function" then
				pcall(item.Disconnect, item)
			elseif type(item.Clean) == "function" then
				pcall(item.Clean, item)
			elseif type(item.Destroy) == "function" then
				pcall(item.Destroy, item)
			end
		end
	end
end

local RootMaid = Maid.new()

----------------------------------------------------------------
-- ESTADO ÚNICO (SETTINGS) Y STORE
----------------------------------------------------------------
local Defaults = {
	-- Configuración de la mecánica de juego
	NuShoot = false,
	ClickShot = false,
	DetectionPoints = 10,
	FOVEnabled = false,
	FOVSize = 200,
	ESPEnabled = false,
	AllyESP = false,
	OutlineColor = Color3.fromRGB(0, 255, 255),
	AllyOutlineColor = Color3.fromRGB(90, 220, 100),
	SelectedBodyParts = {},
	GameTime = 14,
	CurrentTheme = "Default",

	-- Preferencias visuales
	AnimationsEnabled = Config.EnableAnimations,
	ShowProfile = Config.ShowPlayerProfile,
	ShowFPS = Config.ShowFPS,
	AccentColor = Config.AccentColor,
	AvatarShape = "Circle",
	AvatarSize = 64,
}

local Limits = {
	DetectionPoints = { Min = 1, Max = 50, Step = 1 },
	FOVSize = { Min = 100, Max = 500, Step = 1 },
	GameTime = { Min = 0, Max = 24, Step = 1 },
	AvatarSize = { Min = 40, Max = 96, Step = 1 },
}

local VisualKeys = {
	"AnimationsEnabled",
	"ShowProfile",
	"ShowFPS",
	"AccentColor",
	"AvatarShape",
	"AvatarSize",
}

local Settings = Utils.DeepCopy(Defaults)

-- Estado de la interfaz (separado de las preferencias)
local UIState = {
	CurrentPage = Config.DefaultPage,
	Minimized = false,
	Open = true,
	Destroyed = false,
}

local Store = {}
local listeners = {}
local allListeners = {}

local function fireChange(key, value)
	local bucket = listeners[key]
	if bucket then
		local snapshot = table.clone(bucket)
		for _, fn in ipairs(snapshot) do
			if table.find(bucket, fn) then
				Utils.SafeCall(fn, Utils.DeepCopy(value))
			end
		end
	end
	local snapshotAll = table.clone(allListeners)
	for _, fn in ipairs(snapshotAll) do
		if table.find(allListeners, fn) then
			Utils.SafeCall(fn, key, Utils.DeepCopy(value))
		end
	end
end

local function makeConnection(bucket, fn)
	local connected = true
	return {
		Disconnect = function()
			if not connected then
				return
			end
			connected = false
			local index = table.find(bucket, fn)
			if index then
				table.remove(bucket, index)
			end
		end,
	}
end

function Store.Get(key)
	return Utils.DeepCopy(Settings[key])
end

function Store.Set(key, value)
	local default = Defaults[key]
	if default == nil then
		warn("[NUU7 HUB] Clave de configuración desconocida: " .. tostring(key))
		return false
	end
	if typeof(value) ~= typeof(default) then
		warn(("[NUU7 HUB] Tipo inválido para '%s'"):format(tostring(key)))
		return false
	end
	local limit = Limits[key]
	if limit then
		value = Utils.Clamp(value, limit.Min, limit.Max)
		if limit.Step then
			value = Utils.Clamp(Utils.Snap(value, limit.Step, limit.Min), limit.Min, limit.Max)
		end
	end
	if typeof(value) == "table" then
		value = Utils.DeepCopy(value)
	elseif Settings[key] == value then
		return false
	end
	Settings[key] = value
	fireChange(key, value)
	return true
end

function Store.Bind(key, fn, maid)
	if Defaults[key] == nil then
		error("[NUU7 HUB] Bind: clave desconocida '" .. tostring(key) .. "'", 2)
	end
	listeners[key] = listeners[key] or {}
	table.insert(listeners[key], fn)
	local connection = makeConnection(listeners[key], fn)
	if maid then
		maid:Give(connection)
	end
	Utils.SafeCall(fn, Utils.DeepCopy(Settings[key]))
	return connection
end

function Store.BindAll(fn, maid)
	table.insert(allListeners, fn)
	local connection = makeConnection(allListeners, fn)
	if maid then
		maid:Give(connection)
	end
	return connection
end

function Store.ResetKeys(keys)
	for _, key in ipairs(keys) do
		local default = Defaults[key]
		if default ~= nil then
			if typeof(default) == "table" then
				Settings[key] = Utils.DeepCopy(default)
				fireChange(key, Settings[key])
			else
				Store.Set(key, default)
			end
		end
	end
end

function Store.ResetAll()
	local keys = {}
	for key in pairs(Defaults) do
		table.insert(keys, key)
	end
	Store.ResetKeys(keys)
end

function Store.ResetVisual()
	Store.ResetKeys(VisualKeys)
end

----------------------------------------------------------------
-- SISTEMA DE ANIMACIÓN
----------------------------------------------------------------
local Anim = {}

Anim.Infos = {
	Fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Normal = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Slow = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
}

local activeTweens = setmetatable({}, { __mode = "k" })

function Anim.Tween(instance, props, speed)
	if not instance then
		return nil
	end
	activeTweens[instance] = activeTweens[instance] or {}
	local registry = activeTweens[instance]

	if not Settings.AnimationsEnabled then
		for property, value in pairs(props) do
			local running = registry[property]
			if running then
				running:Cancel()
				registry[property] = nil
			end
			instance[property] = value
		end
		return nil
	end

	local info = Anim.Infos[speed or "Normal"] or Anim.Infos.Normal
	local lastTween = nil
	for property, value in pairs(props) do
		local running = registry[property]
		if running then
			running:Cancel()
		end
		local tween = TweenService:Create(instance, info, { [property] = value })
		registry[property] = tween
		tween.Completed:Once(function()
			if registry[property] == tween then
				registry[property] = nil
			end
		end)
		tween:Play()
		lastTween = tween
	end
	return lastTween
end

function Anim.Stop(instance)
	local registry = activeTweens[instance]
	if registry then
		for property, tween in pairs(registry) do
			tween:Cancel()
			registry[property] = nil
		end
	end
end

----------------------------------------------------------------
-- TABLA DE INTERFAZ
----------------------------------------------------------------
local UI = {
	Refs = {},
	Pages = {},
	SidebarButtons = {},
	Thumbs = {},
	Toasts = {},
	NavToken = 0,
	OpenToken = 0,
	ToastCounter = 0,
	Compact = false,
}

----------------------------------------------------------------
-- COMPONENTES BASE
----------------------------------------------------------------
Store.Bind("AccentColor", function(color)
	Theme.Accent = color
end, RootMaid)

function UI.OnAccent(maid, fn)
	return Store.Bind("AccentColor", function()
		fn(Theme.Accent)
	end, maid)
end

local function nextOrder(parent)
	local n = (parent:GetAttribute("NextOrder") or 0) + 1
	parent:SetAttribute("NextOrder", n)
	return n
end
UI.NextOrder = nextOrder

function UI.AttachButtonFx(button, maid, baseColor, hoverColor, onState)
	local scale = Utils.New("UIScale", { Parent = button })
	local hovering = false
	local pressed = false
	local touchOnly = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

	local function refresh()
		if baseColor and hoverColor then
			Anim.Tween(button, { BackgroundColor3 = (hovering or pressed) and hoverColor or baseColor }, "Fast")
		end
		if onState then
			Utils.SafeCall(onState, hovering, pressed)
		end
	end

	local function release()
		pressed = false
		if touchOnly then
			hovering = false
		end
		Anim.Tween(scale, { Scale = 1 }, "Fast")
		refresh()
	end

	maid:Give(button.MouseEnter:Connect(function()
		hovering = true
		refresh()
	end))
	maid:Give(button.MouseLeave:Connect(function()
		hovering = false
		release()
	end))
	maid:Give(button.MouseButton1Down:Connect(function()
		pressed = true
		Anim.Tween(scale, { Scale = 0.97 }, "Fast")
		refresh()
	end))
	maid:Give(button.InputEnded:Connect(function(input)
		local t = input.UserInputType
		if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
			release()
		end
	end))
	return scale
end

function UI.CreateSection(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateSection")
	Utils.Require(opts, "Title", "string", "CreateSection")
	local section = Utils.New("Frame", {
		Name = "Section_" .. opts.Title,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = nextOrder(opts.Parent),
		Parent = opts.Parent,
	})
	Utils.List(section, 8)
	Utils.Label({
		Parent = section,
		Name = "Title",
		Text = opts.Title,
		Font = Theme.FontBold,
		Size = 11,
		Color = Theme.SecondaryText,
		Frame = UDim2.new(1, 0, 0, 16),
		LayoutOrder = -2,
	})
	Utils.New("Frame", {
		Name = "Divider",
		BackgroundColor3 = Theme.Border,
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		LayoutOrder = -1,
		Parent = section,
	})
	return section
end

function UI.CreateCard(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateCard")
	local maid = opts.Maid or RootMaid
	local clickable = opts.Clickable == true
	local rightWidth = opts.RightWidth or 0

	local card = Utils.New(clickable and "TextButton" or "Frame", {
		Name = "Card",
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = nextOrder(opts.Parent),
		Parent = opts.Parent,
	})
	if clickable then
		card.AutoButtonColor = false
		card.Text = ""
	end
	Utils.Corner(card, Theme.CornerMedium)
	local stroke = Utils.Stroke(card)
	Utils.Padding(card, 12, 10, 12, 10)
	Utils.List(card, 10)

	local header = Utils.New("Frame", {
		Name = "Header",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		Parent = card,
	})
	Utils.New("UISizeConstraint", { MinSize = Vector2.new(0, 34), Parent = header })

	local gap = rightWidth > 0 and (rightWidth + 12) or 0
	local textColumn = Utils.New("Frame", {
		Name = "Text",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -gap, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = header,
	})
	Utils.List(textColumn, 2)

	Utils.Label({
		Parent = textColumn,
		Name = "Title",
		Text = opts.Title or "",
		Font = Theme.FontMedium,
		Size = 13,
		Color = Theme.PrimaryText,
		Frame = UDim2.new(1, 0, 0, 0),
		AutoSize = Enum.AutomaticSize.Y,
		Wrapped = true,
		LayoutOrder = 1,
	})
	if opts.Description and opts.Description ~= "" then
		Utils.Label({
			Parent = textColumn,
			Name = "Description",
			Text = opts.Description,
			Font = Theme.FontRegular,
			Size = 11,
			Color = Theme.SecondaryText,
			Frame = UDim2.new(1, 0, 0, 0),
			AutoSize = Enum.AutomaticSize.Y,
			Wrapped = true,
			LayoutOrder = 2,
		})
	end

	local right = Utils.New("Frame", {
		Name = "Right",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, rightWidth, 0, 34),
		Parent = header,
	})

	if clickable then
		UI.AttachButtonFx(card, maid, Theme.Surface, Theme.SurfaceHover)
	end

	return card, right, stroke
end

function UI.CreateToggle(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateToggle")
	Utils.Require(opts, "Title", "string", "CreateToggle")
	if opts.Key ~= nil and Defaults[opts.Key] == nil then
		error("[NUU7 HUB] CreateToggle: clave desconocida '" .. tostring(opts.Key) .. "'", 2)
	end
	local maid = opts.Maid or RootMaid

	local card, right = UI.CreateCard({
		Parent = opts.Parent,
		Title = opts.Title,
		Description = opts.Description,
		RightWidth = 46,
		Clickable = true,
		Maid = maid,
	})

	local track = Utils.New("Frame", {
		Name = "Track",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(44, 24),
		BackgroundColor3 = Theme.ToggleOff,
		BorderSizePixel = 0,
		Parent = right,
	})
	Utils.Corner(track, 12)
	local knob = Utils.New("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 3, 0.5, 0),
		Size = UDim2.fromOffset(18, 18),
		BackgroundColor3 = Theme.Knob,
		BorderSizePixel = 0,
		Parent = track,
	})
	Utils.Corner(knob, 9)

	local value = false
	local initialized = false

	local function render(v, animate)
		local position = UDim2.new(0, v and 23 or 3, 0.5, 0)
		local color = v and Theme.Accent or Theme.ToggleOff
		if animate then
			Anim.Tween(knob, { Position = position }, "Normal")
			Anim.Tween(track, { BackgroundColor3 = color }, "Normal")
		else
			Anim.Stop(knob)
			Anim.Stop(track)
			knob.Position = position
			track.BackgroundColor3 = color
		end
	end

	if opts.Key then
		Store.Bind(opts.Key, function(v)
			local changed = (v ~= value)
			value = v
			render(v, initialized and changed)
		end, maid)
	else
		value = opts.Default == true
		render(value, false)
	end
	initialized = true

	UI.OnAccent(maid, function()
		render(value, false)
	end)

	maid:Give(card.Activated:Connect(function()
		local newValue = not value
		if opts.Key then
			Store.Set(opts.Key, newValue)
		else
			value = newValue
			render(newValue, true)
		end
		Utils.SafeCall(opts.Callback, newValue)
	end))

	local api = { Instance = card }
	function api.Get()
		return value
	end
	function api.Set(v)
		v = v == true
		if opts.Key then
			Store.Set(opts.Key, v)
		else
			value = v
			render(v, true)
		end
	end
	return api
end

function UI.CreateTrack(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateTrack")
	Utils.Require(opts, "Min", "number", "CreateTrack")
	Utils.Require(opts, "Max", "number", "CreateTrack")
	local maid = opts.Maid or RootMaid
	local min, max = opts.Min, opts.Max
	local step = opts.Step or 1

	local hit = Utils.New("Frame", {
		Name = "SliderTrack",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true,
		Size = UDim2.new(1, 0, 0, 24),
		LayoutOrder = opts.LayoutOrder or 2,
		Parent = opts.Parent,
	})
	local bar = Utils.New("Frame", {
		Name = "Bar",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 0, 4),
		BackgroundColor3 = Theme.TrackBar,
		BorderSizePixel = 0,
		Parent = hit,
	})
	Utils.Corner(bar, 2)
	local fill = Utils.New("Frame", {
		Name = "Fill",
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Parent = bar,
	})
	Utils.Corner(fill, 2)
	local knob = Utils.New("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = Theme.Knob,
		BorderSizePixel = 0,
		Parent = hit,
	})
	Utils.Corner(knob, 9)

	local value = min
	local dragging = false

	local function render(v, animate)
		local alpha = (max > min) and ((v - min) / (max - min)) or 0
		if animate then
			Anim.Tween(fill, { Size = UDim2.new(alpha, 0, 1, 0) }, "Fast")
			Anim.Tween(knob, { Position = UDim2.new(alpha, 0, 0.5, 0) }, "Fast")
		else
			Anim.Stop(fill)
			Anim.Stop(knob)
			fill.Size = UDim2.new(alpha, 0, 1, 0)
			knob.Position = UDim2.new(alpha, 0, 0.5, 0)
		end
	end

	UI.OnAccent(maid, function(color)
		fill.BackgroundColor3 = color
	end)

	local moveConn, endConn, scroller

	local function stopDrag(silent)
		dragging = false
		if moveConn then
			moveConn:Disconnect()
			moveConn = nil
		end
		if endConn then
			endConn:Disconnect()
			endConn = nil
		end
		if scroller then
			scroller.ScrollingEnabled = true
			scroller = nil
		end
		if not silent then
			Anim.Tween(knob, { Size = UDim2.fromOffset(14, 14) }, "Fast")
		end
	end

	local function fromX(x)
		local width = hit.AbsoluteSize.X
		if width <= 0 then
			return
		end
		local alpha = Utils.Clamp((x - hit.AbsolutePosition.X) / width, 0, 1)
		local v = Utils.Clamp(Utils.Snap(min + alpha * (max - min), step, min), min, max)
		if v ~= value then
			value = v
			render(v, false)
			Utils.SafeCall(opts.OnChanged, v)
		end
	end

	maid:Give(hit.InputBegan:Connect(function(input)
		local t = input.UserInputType
		if t ~= Enum.UserInputType.MouseButton1 and t ~= Enum.UserInputType.Touch then
			return
		end
		stopDrag(true)
		dragging = true
		scroller = hit:FindFirstAncestorOfClass("ScrollingFrame")
		if scroller then
			scroller.ScrollingEnabled = false
		end
		Anim.Tween(knob, { Size = UDim2.fromOffset(18, 18) }, "Fast")
		fromX(input.Position.X)

		moveConn = UserInputService.InputChanged:Connect(function(changed)
			local ct = changed.UserInputType
			if ct == Enum.UserInputType.MouseMovement or ct == Enum.UserInputType.Touch then
				fromX(changed.Position.X)
			end
		end)
		endConn = UserInputService.InputEnded:Connect(function(ended)
			if ended == input or (t == Enum.UserInputType.MouseButton1 and ended.UserInputType == t) then
				stopDrag(false)
			end
		end)
	end))
	maid:Give(function()
		stopDrag(true)
	end)

	local api = { Instance = hit }
	function api.Get()
		return value
	end
	function api.Set(v, instant)
		v = Utils.Clamp(Utils.Snap(Utils.Clamp(v, min, max), step, min), min, max)
		value = v
		render(v, (not dragging) and not instant)
	end
	api.Set(opts.Default or min, true)
	return api
end

function UI.CreateSlider(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateSlider")
	Utils.Require(opts, "Title", "string", "CreateSlider")
	if opts.Key ~= nil and Defaults[opts.Key] == nil then
		error("[NUU7 HUB] CreateSlider: clave desconocida '" .. tostring(opts.Key) .. "'", 2)
	end
	local limit = opts.Key and Limits[opts.Key] or nil
	local min = opts.Min or (limit and limit.Min)
	local max = opts.Max or (limit and limit.Max)
	local step = opts.Step or (limit and limit.Step) or 1
	if typeof(min) ~= "number" or typeof(max) ~= "number" or max <= min then
		error("[NUU7 HUB] CreateSlider: rango inválido", 2)
	end
	local maid = opts.Maid or RootMaid

	local card, right = UI.CreateCard({
		Parent = opts.Parent,
		Title = opts.Title,
		Description = opts.Description,
		RightWidth = 48,
		Maid = maid,
	})
	local valueLabel = Utils.Label({
		Parent = right,
		Name = "Value",
		Text = "",
		Font = Theme.FontMedium,
		Size = 12,
		Color = Theme.SecondaryText,
		AlignX = Enum.TextXAlignment.Right,
		Frame = UDim2.new(1, 0, 0, 18),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
	})

	local function show(v)
		if opts.Format then
			valueLabel.Text = tostring(opts.Format(v))
		else
			valueLabel.Text = tostring(v)
		end
	end

	local track
	local initialized = false
	track = UI.CreateTrack({
		Parent = card,
		Min = min,
		Max = max,
		Step = step,
		Default = opts.Default,
		Maid = maid,
		LayoutOrder = 2,
		OnChanged = function(v)
			show(v)
			if opts.Key then
				Store.Set(opts.Key, v)
			end
			Utils.SafeCall(opts.Callback, v)
		end,
	})

	if opts.Key then
		Store.Bind(opts.Key, function(v)
			track.Set(v, not initialized)
			show(track.Get())
		end, maid)
	else
		track.Set(opts.Default or min, true)
		show(track.Get())
	end
	initialized = true

	local api = { Instance = card }
	function api.Get()
		return track.Get()
	end
	function api.Set(v)
		if opts.Key then
			Store.Set(opts.Key, v)
		else
			track.Set(v)
			show(track.Get())
		end
	end
	return api
end

function UI.CreateButton(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateButton")
	Utils.Require(opts, "Title", "string", "CreateButton")
	local maid = opts.Maid or RootMaid
	local card, right = UI.CreateCard({
		Parent = opts.Parent,
		Title = opts.Title,
		Description = opts.Description,
		RightWidth = 24,
		Clickable = true,
		Maid = maid,
	})
	Utils.Label({
		Parent = right,
		Name = "Chevron",
		Text = opts.Text or "\u{203A}",
		Font = Theme.FontMedium,
		Size = 20,
		Color = Theme.SecondaryText,
		AlignX = Enum.TextXAlignment.Right,
		Frame = UDim2.new(1, 0, 0, 34),
	})
	maid:Give(card.Activated:Connect(function()
		Utils.SafeCall(opts.Callback)
	end))
	return { Instance = card }
end

----------------------------------------------------------------
-- COMPONENTES AVANZADOS
----------------------------------------------------------------
function UI.CreatePillButton(opts)
	Utils.Require(opts, "Parent", "Instance", "CreatePillButton")
	Utils.Require(opts, "Text", "string", "CreatePillButton")
	local maid = opts.Maid or RootMaid
	local base = opts.Primary and Theme.Accent or Theme.SurfaceSecondary
	local hover = opts.Primary and Theme.Accent:Lerp(Color3.new(1, 1, 1), 0.15) or Theme.SurfaceHover
	local button = Utils.New("TextButton", {
		Name = "Pill_" .. opts.Text,
		AutoButtonColor = false,
		BackgroundColor3 = base,
		BorderSizePixel = 0,
		Text = opts.Text,
		Font = Theme.FontMedium,
		TextSize = 12,
		TextColor3 = opts.Primary and Color3.fromRGB(10, 12, 16) or Theme.PrimaryText,
		Size = opts.Size or UDim2.fromOffset(100, 34),
		Position = opts.Position or UDim2.new(),
		AnchorPoint = opts.AnchorPoint or Vector2.new(0, 0),
		LayoutOrder = opts.LayoutOrder or 0,
		Parent = opts.Parent,
	})
	Utils.Corner(button, 8)
	Utils.Stroke(button)
	UI.AttachButtonFx(button, maid, base, hover)
	maid:Give(button.Activated:Connect(function()
		Utils.SafeCall(opts.Callback)
	end))
	return button
end

function UI.CreateModal(opts)
	local overlay = UI.Refs.Overlay
	if not overlay then
		error("[NUU7 HUB] CreateModal: la capa de ventanas no existe", 2)
	end
	local maid = Maid.new()
	RootMaid:Give(maid)
	local viewport = Utils.GetViewport()
	local width = math.min(opts.Width or 360, viewport.X - 24)
	local height = math.min(opts.Height or 300, viewport.Y - 24)
	local closed = false

	local backdrop = Utils.New("TextButton", {
		Name = "Backdrop",
		AutoButtonColor = false,
		Text = "",
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Parent = overlay,
	})
	maid:Give(backdrop)

	local panel = Utils.New("CanvasGroup", {
		Name = "Panel",
		Active = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(width, height),
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Parent = backdrop,
	})
	Utils.Corner(panel, Theme.CornerLarge)
	Utils.Stroke(panel, 0.85)
	local scale = Utils.New("UIScale", { Scale = 0.96, Parent = panel })

	Utils.Label({
		Parent = panel,
		Name = "Title",
		Text = opts.Title or "",
		Font = Theme.FontBold,
		Size = 14,
		Color = Theme.PrimaryText,
		Frame = UDim2.new(1, -64, 0, 44),
		Position = UDim2.fromOffset(16, 0),
		Truncate = Enum.TextTruncate.AtEnd,
	})
	local closeButton = Utils.New("TextButton", {
		Name = "Close",
		AutoButtonColor = false,
		BackgroundColor3 = Theme.SurfaceSecondary,
		BorderSizePixel = 0,
		Text = "X",
		Font = Theme.FontBold,
		TextSize = 13,
		TextColor3 = Theme.PrimaryText,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0, 22),
		Size = UDim2.fromOffset(30, 30),
		Parent = panel,
	})
	Utils.Corner(closeButton, 8)
	UI.AttachButtonFx(closeButton, maid, Theme.SurfaceSecondary, Theme.SurfaceHover)
	Utils.New("Frame", {
		Name = "Divider",
		BackgroundColor3 = Theme.Border,
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 44),
		Size = UDim2.new(1, 0, 0, 1),
		Parent = panel,
	})
	local body = Utils.New("Frame", {
		Name = "Body",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 45),
		Size = UDim2.new(1, 0, 1, -45),
		Parent = panel,
	})

	local modal = { Maid = maid, Panel = panel, Body = body }

	function modal.Close()
		if closed then
			return
		end
		closed = true
		Anim.Tween(backdrop, { BackgroundTransparency = 1 }, "Fast")
		Anim.Tween(panel, { GroupTransparency = 1 }, "Fast")
		Anim.Tween(scale, { Scale = 0.96 }, "Fast")
		Utils.SafeCall(opts.OnClose)
		task.delay(Settings.AnimationsEnabled and 0.15 or 0, function()
			maid:Clean()
		end)
	end

	maid:Give(closeButton.Activated:Connect(modal.Close))
	maid:Give(backdrop.Activated:Connect(modal.Close))

	Anim.Tween(backdrop, { BackgroundTransparency = 0.45 }, "Normal")
	Anim.Tween(panel, { GroupTransparency = 0 }, "Normal")
	Anim.Tween(scale, { Scale = 1 }, "Normal")

	return modal
end

function UI.Confirm(opts)
	local modal = UI.CreateModal({ Title = opts.Title or "Confirmar", Width = 320, Height = 190 })
	Utils.Label({
		Parent = modal.Body,
		Name = "Message",
		Text = opts.Message or "",
		Size = 12,
		Color = Theme.SecondaryText,
		Wrapped = true,
		AlignY = Enum.TextYAlignment.Top,
		Frame = UDim2.new(1, -32, 0, 60),
		Position = UDim2.fromOffset(16, 14),
	})
	UI.CreatePillButton({
		Parent = modal.Body,
		Text = opts.CancelText or "Cancelar",
		Size = UDim2.fromOffset(100, 34),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -126, 1, -14),
		Maid = modal.Maid,
		Callback = modal.Close,
	})
	UI.CreatePillButton({
		Parent = modal.Body,
		Text = opts.ConfirmText or "Confirmar",
		Primary = true,
		Size = UDim2.fromOffset(100, 34),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -16, 1, -14),
		Maid = modal.Maid,
		Callback = function()
			modal.Close()
			Utils.SafeCall(opts.OnConfirm)
		end,
	})
	return modal
end

function UI.CreateNotification(opts)
	local container = UI.Refs.Toasts
	if not container or UIState.Destroyed then
		return nil
	end
	local colors = {
		Info = Theme.Accent,
		Success = Theme.Success,
		Warning = Color3.fromRGB(255, 190, 70),
		Error = Theme.Danger,
	}
	local color = colors[opts.Type or "Info"] or Theme.Accent

	while #UI.Toasts >= 3 do
		local oldest = table.remove(UI.Toasts, 1)
		if oldest and oldest.Parent then
			oldest:Destroy()
		end
	end

	UI.ToastCounter = UI.ToastCounter + 1
	local toast = Utils.New("CanvasGroup", {
		Name = "Toast",
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = UI.ToastCounter,
		Parent = container,
	})
	Utils.Corner(toast, Theme.CornerMedium)
	Utils.Stroke(toast, 0.5, 1, color)
	Utils.Padding(toast, 12, 10, 12, 10)
	Utils.List(toast, 2)
	Utils.Label({
		Parent = toast,
		Name = "Title",
		Text = opts.Title or Config.HubName,
		Font = Theme.FontBold,
		Size = 12,
		Color = Theme.PrimaryText,
		Frame = UDim2.new(1, 0, 0, 0),
		AutoSize = Enum.AutomaticSize.Y,
		Wrapped = true,
		LayoutOrder = 1,
	})
	if opts.Message and opts.Message ~= "" then
		Utils.Label({
			Parent = toast,
			Name = "Message",
			Text = opts.Message,
			Size = 11,
			Color = Theme.SecondaryText,
			Frame = UDim2.new(1, 0, 0, 0),
			AutoSize = Enum.AutomaticSize.Y,
			Wrapped = true,
			LayoutOrder = 2,
		})
	end
	table.insert(UI.Toasts, toast)
	Anim.Tween(toast, { GroupTransparency = 0 }, "Normal")

	task.delay(opts.Duration or 3, function()
		if UIState.Destroyed or not toast.Parent then
			return
		end
		Anim.Tween(toast, { GroupTransparency = 1 }, "Normal")
		task.delay(Settings.AnimationsEnabled and 0.25 or 0, function()
			local index = table.find(UI.Toasts, toast)
			if index then
				table.remove(UI.Toasts, index)
			end
			if toast.Parent then
				toast:Destroy()
			end
		end)
	end)
	return toast
end

function UI.OpenColorPanel(opts)
	local modal = UI.CreateModal({
		Title = opts.Title or "Seleccionar color",
		Width = 330,
		Height = 310,
		OnClose = opts.OnClose,
	})
	local maid, body = modal.Maid, modal.Body
	local start = opts.Color or Color3.new(1, 1, 1)
	local channels = {
		R = math.floor(start.R * 255 + 0.5),
		G = math.floor(start.G * 255 + 0.5),
		B = math.floor(start.B * 255 + 0.5),
	}

	local preview = Utils.New("Frame", {
		Name = "Preview",
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(16, 12),
		Size = UDim2.new(1, -32, 0, 36),
		Parent = body,
	})
	Utils.Corner(preview, 8)
	Utils.Stroke(preview, 0.8)
	local hexLabel = Utils.Label({
		Parent = preview,
		Name = "Hex",
		Font = Theme.FontBold,
		Size = 12,
		AlignX = Enum.TextXAlignment.Center,
		Frame = UDim2.fromScale(1, 1),
	})

	local function current()
		return Color3.fromRGB(channels.R, channels.G, channels.B)
	end
	local function refresh()
		local color = current()
		preview.BackgroundColor3 = color
		hexLabel.Text = Utils.ColorToHex(color)
		local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
		hexLabel.TextColor3 = luminance > 0.6 and Color3.fromRGB(10, 12, 16) or Color3.new(1, 1, 1)
	end

	local tracks, valueLabels = {}, {}
	for index, name in ipairs({ "R", "G", "B" }) do
		local row = Utils.New("Frame", {
			Name = "Row_" .. name,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(16, 60 + (index - 1) * 34),
			Size = UDim2.new(1, -32, 0, 24),
			Parent = body,
		})
		Utils.Label({
			Parent = row,
			Text = name,
			Font = Theme.FontBold,
			Size = 12,
			Color = Theme.SecondaryText,
			Frame = UDim2.new(0, 16, 1, 0),
		})
		local holder = Utils.New("Frame", {
			Name = "Holder",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(22, 0),
			Size = UDim2.new(1, -64, 1, 0),
			Parent = row,
		})
		local valueLabel = Utils.Label({
			Parent = row,
			Name = "Value",
			Font = Theme.FontMedium,
			Size = 12,
			Color = Theme.SecondaryText,
			AlignX = Enum.TextXAlignment.Right,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			Frame = UDim2.new(0, 34, 1, 0),
		})
		valueLabels[name] = valueLabel
		tracks[name] = UI.CreateTrack({
			Parent = holder,
			Min = 0,
			Max = 255,
			Step = 1,
			Default = channels[name],
			Maid = maid,
			OnChanged = function(v)
				channels[name] = v
				valueLabel.Text = tostring(v)
				refresh()
			end,
		})
		valueLabel.Text = tostring(channels[name])
	end
	refresh()

	local presets = {
		Color3.fromRGB(0, 255, 255),
		Color3.fromRGB(90, 220, 100),
		Color3.fromRGB(90, 170, 255),
		Color3.fromRGB(150, 90, 255),
		Color3.fromRGB(255, 90, 200),
		Color3.fromRGB(255, 90, 90),
		Color3.fromRGB(255, 170, 60),
		Color3.fromRGB(255, 255, 255),
	}
	local presetRow = Utils.New("Frame", {
		Name = "Presets",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(16, 170),
		Size = UDim2.new(1, -32, 0, 28),
		Parent = body,
	})
	Utils.List(presetRow, 6, Enum.FillDirection.Horizontal)
	for index, color in ipairs(presets) do
		local swatch = Utils.New("TextButton", {
			Name = "Preset" .. index,
			AutoButtonColor = false,
			Text = "",
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(28, 28),
			LayoutOrder = index,
			Parent = presetRow,
		})
		Utils.Corner(swatch, 14)
		Utils.Stroke(swatch, 0.75)
		maid:Give(swatch.Activated:Connect(function()
			channels.R = math.floor(color.R * 255 + 0.5)
			channels.G = math.floor(color.G * 255 + 0.5)
			channels.B = math.floor(color.B * 255 + 0.5)
			for name, track in pairs(tracks) do
				track.Set(channels[name])
				valueLabels[name].Text = tostring(channels[name])
			end
			refresh()
		end))
	end

	UI.CreatePillButton({
		Parent = body,
		Text = "Cancelar",
		Size = UDim2.fromOffset(100, 34),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -126, 1, -14),
		Maid = maid,
		Callback = modal.Close,
	})
	UI.CreatePillButton({
		Parent = body,
		Text = "Confirmar",
		Primary = true,
		Size = UDim2.fromOffset(100, 34),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -16, 1, -14),
		Maid = maid,
		Callback = function()
			local color = current()
			modal.Close()
			Utils.SafeCall(opts.OnConfirm, color)
		end,
	})
	return modal
end

function UI.CreateColorPicker(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateColorPicker")
	Utils.Require(opts, "Title", "string", "CreateColorPicker")
	if opts.Key ~= nil and typeof(Defaults[opts.Key]) ~= "Color3" then
		error("[NUU7 HUB] CreateColorPicker: la clave debe ser un Color3", 2)
	end
	local maid = opts.Maid or RootMaid
	local card, right = UI.CreateCard({
		Parent = opts.Parent,
		Title = opts.Title,
		Description = opts.Description,
		RightWidth = 40,
		Clickable = true,
		Maid = maid,
	})
	local swatch = Utils.New("Frame", {
		Name = "Swatch",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(36, 24),
		BorderSizePixel = 0,
		Parent = right,
	})
	Utils.Corner(swatch, 7)
	Utils.Stroke(swatch, 0.7)

	local current = opts.Default or Color3.new(1, 1, 1)
	if opts.Key then
		Store.Bind(opts.Key, function(color)
			current = color
			swatch.BackgroundColor3 = color
		end, maid)
	else
		swatch.BackgroundColor3 = current
	end

	local panelOpen = false
	maid:Give(card.Activated:Connect(function()
		if panelOpen then
			return
		end
		panelOpen = true
		UI.OpenColorPanel({
			Title = opts.Title,
			Color = current,
			OnClose = function()
				panelOpen = false
			end,
			OnConfirm = function(color)
				if opts.Key then
					Store.Set(opts.Key, color)
				else
					current = color
					swatch.BackgroundColor3 = color
				end
				Utils.SafeCall(opts.Callback, color)
			end,
		})
	end))
	return { Instance = card }
end

local function countSelected(set)
	local n = 0
	for _, selected in pairs(set) do
		if selected then
			n = n + 1
		end
	end
	return n
end

function UI.OpenBodyPartModal()
	if UI.BodyModal then
		return UI.BodyModal
	end
	local parts = Utils.GetAvailableBodyParts(LocalPlayer.Character)
	local modal = UI.CreateModal({
		Title = "Seleccionar partes del cuerpo",
		Width = 360,
		Height = 400,
		OnClose = function()
			UI.BodyModal = nil
		end,
	})
	UI.BodyModal = modal
	local maid, body = modal.Maid, modal.Body

	local counter = Utils.Label({
		Parent = body,
		Name = "Counter",
		Font = Theme.FontMedium,
		Size = 12,
		Color = Theme.SecondaryText,
		Frame = UDim2.new(1, -32, 0, 22),
		Position = UDim2.fromOffset(16, 8),
	})

	local list = Utils.New("ScrollingFrame", {
		Name = "List",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(16, 34),
		Size = UDim2.new(1, -32, 1, -132),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Color3.fromRGB(90, 94, 106),
		Parent = body,
	})
	Utils.List(list, 6)
	Utils.Padding(list, 0, 0, 6, 0)

	local rows = {}
	for index, name in ipairs(parts) do
		local row = Utils.New("TextButton", {
			Name = "Row_" .. name,
			AutoButtonColor = false,
			Text = "",
			BackgroundColor3 = Theme.SurfaceSecondary,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 38),
			LayoutOrder = index,
			Parent = list,
		})
		Utils.Corner(row, 8)
		local rowStroke = Utils.Stroke(row)
		UI.AttachButtonFx(row, maid, Theme.SurfaceSecondary, Theme.SurfaceHover)
		local box = Utils.New("Frame", {
			Name = "Box",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 12, 0.5, 0),
			Size = UDim2.fromOffset(20, 20),
			BackgroundColor3 = Theme.Surface,
			BorderSizePixel = 0,
			Parent = row,
		})
		Utils.Corner(box, 5)
		local boxStroke = Utils.Stroke(box, 0.6)
		local check = Utils.New("Frame", {
			Name = "Check",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(10, 10),
			BackgroundColor3 = Theme.Accent,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = box,
		})
		Utils.Corner(check, 3)
		Utils.Label({
			Parent = row,
			Name = "Name",
			Text = name,
			Font = Theme.FontMedium,
			Size = 12,
			Frame = UDim2.new(1, -52, 1, 0),
			Position = UDim2.fromOffset(44, 0),
		})
		rows[name] = function(selected)
			check.BackgroundColor3 = Theme.Accent
			Anim.Tween(check, { BackgroundTransparency = selected and 0 or 1 }, "Fast")
			boxStroke.Color = selected and Theme.Accent or Theme.Border
			boxStroke.Transparency = selected and 0 or 0.6
			rowStroke.Color = selected and Theme.Accent or Theme.Border
			rowStroke.Transparency = selected and 0.55 or Theme.BorderTransparency
		end
		maid:Give(row.Activated:Connect(function()
			local set = Store.Get("SelectedBodyParts")
			if set[name] then
				set[name] = nil
			else
				set[name] = true
			end
			Store.Set("SelectedBodyParts", set)
		end))
	end

	Store.Bind("SelectedBodyParts", function(set)
		counter.Text = ("%d seleccionadas de %d"):format(countSelected(set), #parts)
		for name, render in pairs(rows) do
			render(set[name] == true)
		end
	end, maid)

	local footer = Utils.New("Frame", {
		Name = "Footer",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 16, 1, -12),
		Size = UDim2.new(1, -32, 0, 82),
		Parent = body,
	})
	UI.CreatePillButton({
		Parent = footer,
		Text = "Seleccionar todas",
		Size = UDim2.new(0.5, -4, 0, 36),
		Position = UDim2.fromOffset(0, 0),
		Maid = maid,
		Callback = function()
			local set = Store.Get("SelectedBodyParts")
			for _, name in ipairs(parts) do
				set[name] = true
			end
			Store.Set("SelectedBodyParts", set)
		end,
	})
	UI.CreatePillButton({
		Parent = footer,
		Text = "Limpiar selección",
		Size = UDim2.new(0.5, -4, 0, 36),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Maid = maid,
		Callback = function()
			Store.Set("SelectedBodyParts", {})
		end,
	})
	UI.CreatePillButton({
		Parent = footer,
		Text = "Guardar selección",
		Primary = true,
		Size = UDim2.new(1, 0, 0, 38),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Maid = maid,
		Callback = function()
			local total = countSelected(Store.Get("SelectedBodyParts"))
			modal.Close()
			UI.CreateNotification({
				Title = "Selección guardada",
				Message = total .. " partes del cuerpo seleccionadas.",
				Type = "Success",
			})
		end,
	})
	return modal
end

function UI.CreateBodyPartSelector(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateBodyPartSelector")
	local maid = opts.Maid or RootMaid
	local card, right = UI.CreateCard({
		Parent = opts.Parent,
		Title = "Select Body Parts",
		Description = "Selecciona las partes del cuerpo que deseas incluir.",
		RightWidth = 40,
		Clickable = true,
		Maid = maid,
	})
	local badge = Utils.New("Frame", {
		Name = "Badge",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(34, 24),
		BackgroundColor3 = Theme.SurfaceSecondary,
		BorderSizePixel = 0,
		Parent = right,
	})
	Utils.Corner(badge, 7)
	Utils.Stroke(badge)
	local countLabel = Utils.Label({
		Parent = badge,
		Name = "Count",
		Font = Theme.FontBold,
		Size = 12,
		Color = Theme.Accent,
		AlignX = Enum.TextXAlignment.Center,
		Frame = UDim2.fromScale(1, 1),
	})
	Store.Bind("SelectedBodyParts", function(set)
		countLabel.Text = tostring(countSelected(set))
	end, maid)
	UI.OnAccent(maid, function(color)
		countLabel.TextColor3 = color
	end)
	maid:Give(card.Activated:Connect(function()
		UI.OpenBodyPartModal()
	end))
	return { Instance = card }
end

----------------------------------------------------------------
-- PERFIL DEL JUGADOR
----------------------------------------------------------------
local thumbCache = {}

function UI.LoadThumbnail(label)
	local userId = LocalPlayer.UserId
	if thumbCache[userId] then
		label.Image = thumbCache[userId]
		return
	end
	task.spawn(function()
		for _ = 1, 5 do
			if UIState.Destroyed then
				return
			end
			local ok, content, ready = pcall(
				Players.GetUserThumbnailAsync,
				Players,
				userId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size150x150
			)
			if ok and content and ready then
				thumbCache[userId] = content
				if label.Parent then
					label.Image = content
				end
				return
			end
			task.wait(1)
		end
	end)
end

function UI.ReloadThumbnails()
	thumbCache = {}
	for _, label in ipairs(UI.Thumbs) do
		if label.Parent then
			label.Image = ""
			UI.LoadThumbnail(label)
		end
	end
end

function UI.CreatePlayerProfile(opts)
	Utils.Require(opts, "Parent", "Instance", "CreatePlayerProfile")
	local maid = opts.Maid or RootMaid
	local follow = opts.FollowSettings == true
	local pad = follow and 12 or 8

	local frame = Utils.New("Frame", {
		Name = "PlayerProfile",
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 52),
		LayoutOrder = opts.LayoutOrder or nextOrder(opts.Parent),
		Parent = opts.Parent,
	})
	Utils.Corner(frame, Theme.CornerMedium)
	Utils.Stroke(frame)

	local avatar = Utils.New("ImageLabel", {
		Name = "Avatar",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, pad, 0.5, 0),
		Size = UDim2.fromOffset(36, 36),
		BackgroundColor3 = Theme.SurfaceSecondary,
		BorderSizePixel = 0,
		Image = "",
		ScaleType = Enum.ScaleType.Crop,
		Parent = frame,
	})
	local avatarCorner = Utils.Corner(avatar, 18)
	table.insert(UI.Thumbs, avatar)
	maid:Give(function()
		local index = table.find(UI.Thumbs, avatar)
		if index then
			table.remove(UI.Thumbs, index)
		end
	end)
	UI.LoadThumbnail(avatar)

	local texts = Utils.New("Frame", {
		Name = "Texts",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Parent = frame,
	})
	Utils.List(texts, 1, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
	Utils.Label({
		Parent = texts,
		Name = "DisplayName",
		Text = LocalPlayer.DisplayName,
		Font = Theme.FontBold,
		Size = follow and 14 or 12,
		Frame = UDim2.new(1, 0, 0, follow and 18 or 15),
		Truncate = Enum.TextTruncate.AtEnd,
		LayoutOrder = 1,
	})
	Utils.Label({
		Parent = texts,
		Name = "Username",
		Text = "@" .. LocalPlayer.Name,
		Size = follow and 12 or 10,
		Color = Theme.SecondaryText,
		Frame = UDim2.new(1, 0, 0, follow and 15 or 12),
		Truncate = Enum.TextTruncate.AtEnd,
		LayoutOrder = 2,
	})
	Utils.Label({
		Parent = texts,
		Name = "UserId",
		Text = "ID " .. tostring(LocalPlayer.UserId),
		Size = follow and 11 or 9,
		Color = Theme.SecondaryText,
		Frame = UDim2.new(1, 0, 0, follow and 14 or 11),
		Truncate = Enum.TextTruncate.AtEnd,
		LayoutOrder = 3,
	})

	local shape, size, compact = "Circle", 36, false
	local function layout()
		avatar.Size = UDim2.fromOffset(size, size)
		if shape == "Circle" then
			avatarCorner.CornerRadius = UDim.new(1, 0)
		else
			avatarCorner.CornerRadius = UDim.new(0, math.max(6, math.floor(size * 0.18)))
		end
		if follow then
			frame.Size = UDim2.new(1, 0, 0, size + pad * 2)
		end
		if compact then
			avatar.AnchorPoint = Vector2.new(0.5, 0.5)
			avatar.Position = UDim2.new(0.5, 0, 0.5, 0)
			texts.Visible = false
		else
			avatar.AnchorPoint = Vector2.new(0, 0.5)
			avatar.Position = UDim2.new(0, pad, 0.5, 0)
			texts.Visible = true
			local offset = pad + size + 10
			texts.Position = UDim2.new(0, offset, 0.5, 0)
			texts.Size = UDim2.new(1, -(offset + pad), 0, size)
		end
	end

	if follow then
		Store.Bind("AvatarShape", function(value)
			shape = value
			layout()
		end, maid)
		Store.Bind("AvatarSize", function(value)
			size = value
			layout()
		end, maid)
	else
		layout()
	end

	local api = { Frame = frame }
	function api.SetCompact(value)
		compact = value == true
		layout()
	end
	return api
end

function UI.CreateSegmented(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateSegmented")
	Utils.Require(opts, "Title", "string", "CreateSegmented")
	Utils.Require(opts, "Key", "string", "CreateSegmented")
	if Defaults[opts.Key] == nil then
		error("[NUU7 HUB] CreateSegmented: clave desconocida '" .. opts.Key .. "'", 2)
	end
	local maid = opts.Maid or RootMaid
	local card, right = UI.CreateCard({
		Parent = opts.Parent,
		Title = opts.Title,
		Description = opts.Description,
		RightWidth = 150,
		Maid = maid,
	})
	local container = Utils.New("Frame", {
		Name = "Segments",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(150, 30),
		BackgroundColor3 = Theme.SurfaceSecondary,
		BorderSizePixel = 0,
		Parent = right,
	})
	Utils.Corner(container, 8)
	Utils.Stroke(container)
	Utils.Padding(container, 2)
	Utils.List(container, 0, Enum.FillDirection.Horizontal)

	local buttons = {}
	local count = #opts.Options
	for index, option in ipairs(opts.Options) do
		local button = Utils.New("TextButton", {
			Name = "Option_" .. tostring(option.Value),
			AutoButtonColor = false,
			Text = option.Label,
			Font = Theme.FontMedium,
			TextSize = 11,
			BackgroundColor3 = Theme.Accent,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextColor3 = Theme.SecondaryText,
			Size = UDim2.new(1 / count, 0, 1, 0),
			LayoutOrder = index,
			Parent = container,
		})
		Utils.Corner(button, 6)
		buttons[option.Value] = button
		maid:Give(button.Activated:Connect(function()
			Store.Set(opts.Key, option.Value)
			Utils.SafeCall(opts.Callback, option.Value)
		end))
	end

	local function render(selectedValue)
		for value, button in pairs(buttons) do
			local selected = value == selectedValue
			button.BackgroundColor3 = Theme.Accent
			Anim.Tween(button, { BackgroundTransparency = selected and 0 or 1 }, "Fast")
			Anim.Tween(button, {
				TextColor3 = selected and Color3.fromRGB(10, 12, 16) or Theme.SecondaryText,
			}, "Fast")
		end
	end
	local currentValue = nil
	Store.Bind(opts.Key, function(value)
		currentValue = value
		render(value)
	end, maid)
	UI.OnAccent(maid, function()
		render(currentValue)
	end)
	return { Instance = card }
end

----------------------------------------------------------------
-- VENTANA PRINCIPAL
----------------------------------------------------------------
local HEADER_HEIGHT = 48

function UI.ComputeWindowSize()
	local viewport = Utils.GetViewport()
	local width = math.max(280, math.min(Config.Window.Width, viewport.X - Config.Window.MarginX * 2))
	local height = math.max(200, math.min(Config.Window.Height, viewport.Y - Config.Window.MarginY * 2))
	return Vector2.new(width, height)
end

function UI.ClampPosition(position, size)
	local viewport = Utils.GetViewport()
	local x = Utils.Clamp(position.X.Offset, size.X / 2, math.max(size.X / 2, viewport.X - size.X / 2))
	local y = Utils.Clamp(position.Y.Offset, size.Y / 2, math.max(size.Y / 2, viewport.Y - size.Y / 2))
	return UDim2.fromOffset(x, y)
end

function UI.ApplyLayout()
	local window = UI.Refs.Window
	if not window then
		return
	end
	local size = UI.ComputeWindowSize()
	local compact = size.X < Config.Window.CompactBelow
	UI.Compact = compact
	local height = UIState.Minimized and HEADER_HEIGHT or size.Y
	window.Size = UDim2.fromOffset(size.X, height)

	local sidebarWidth = compact and Config.Window.SidebarCompactWidth or Config.Window.SidebarWidth
	UI.Refs.Sidebar.Size = UDim2.new(0, sidebarWidth, 1, 0)
	UI.Refs.Content.Position = UDim2.fromOffset(sidebarWidth, 0)
	UI.Refs.Content.Size = UDim2.new(1, -sidebarWidth, 1, 0)

	for _, button in pairs(UI.SidebarButtons) do
		button.SetCompact(compact)
	end
	if UI.Refs.Profile then
		UI.Refs.Profile.SetCompact(compact)
	end

	UI.RestPosition = UI.ClampPosition(UI.RestPosition or window.Position, Vector2.new(size.X, height))
	window.Position = UI.RestPosition
end

function UI.MakeDraggable(handle, target, maid, onMoved)
	local state = { Moved = false }
	local moveConn, endConn

	local function stop()
		if moveConn then
			moveConn:Disconnect()
			moveConn = nil
		end
		if endConn then
			endConn:Disconnect()
			endConn = nil
		end
	end

	maid:Give(handle.InputBegan:Connect(function(input)
		local t = input.UserInputType
		if t ~= Enum.UserInputType.MouseButton1 and t ~= Enum.UserInputType.Touch then
			return
		end
		stop()
		state.Moved = false
		local startInput = Vector2.new(input.Position.X, input.Position.Y)
		local startPosition = target.Position

		moveConn = UserInputService.InputChanged:Connect(function(changed)
			local ct = changed.UserInputType
			if ct ~= Enum.UserInputType.MouseMovement and ct ~= Enum.UserInputType.Touch then
				return
			end
			local delta = Vector2.new(changed.Position.X, changed.Position.Y) - startInput
			if not state.Moved and delta.Magnitude > 6 then
				state.Moved = true
			end
			if state.Moved then
				local desired = UDim2.fromOffset(startPosition.X.Offset + delta.X, startPosition.Y.Offset + delta.Y)
				local clamped = UI.ClampPosition(desired, target.AbsoluteSize)
				target.Position = clamped
				if onMoved then
					onMoved(clamped)
				end
			end
		end)
		endConn = UserInputService.InputEnded:Connect(function(ended)
			if ended == input or (t == Enum.UserInputType.MouseButton1 and ended.UserInputType == t) then
				stop()
				task.defer(function()
					state.Moved = false
				end)
			end
		end)
	end))
	maid:Give(stop)
	return state
end

function UI.CreateHeader(parent)
	local maid = RootMaid
	local header = Utils.New("Frame", {
		Name = "Header",
		Active = true,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
		Parent = parent,
	})
	Utils.New("Frame", {
		Name = "Divider",
		BackgroundColor3 = Theme.Border,
		BackgroundTransparency = 0.92,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 1),
		Parent = header,
	})

	local logo = Utils.New("ImageLabel", {
		Name = "Logo",
		BackgroundColor3 = Theme.SurfaceSecondary,
		BorderSizePixel = 0,
		Image = Config.LogoImage,
		ScaleType = Enum.ScaleType.Fit,
		Position = UDim2.fromOffset(14, 10),
		Size = UDim2.fromOffset(28, 28),
		Parent = header,
	})
	Utils.Corner(logo, 7)

	Utils.Label({
		Parent = header,
		Name = "HubName",
		Text = Config.HubName,
		Font = Theme.FontBold,
		Size = 14,
		Frame = UDim2.fromOffset(130, 18),
		Position = UDim2.fromOffset(50, 7),
	})
	local dot = Utils.New("Frame", {
		Name = "StatusDot",
		BackgroundColor3 = Theme.Success,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(50, 29),
		Size = UDim2.fromOffset(6, 6),
		Parent = header,
	})
	Utils.Corner(dot, 3)
	Utils.Label({
		Parent = header,
		Name = "Status",
		Text = "ONLINE",
		Font = Theme.FontBold,
		Size = 9,
		Color = Theme.Success,
		Frame = UDim2.fromOffset(60, 12),
		Position = UDim2.fromOffset(62, 26),
	})

	local controls = Utils.New("Frame", {
		Name = "Controls",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(0, 28),
		AutomaticSize = Enum.AutomaticSize.X,
		Parent = header,
	})
	Utils.List(controls, 6, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)

	local fpsChip = Utils.New("TextLabel", {
		Name = "FPS",
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		Text = "-- FPS",
		Font = Theme.FontMedium,
		TextSize = 11,
		TextColor3 = Theme.SecondaryText,
		Size = UDim2.fromOffset(0, 24),
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = 1,
		Parent = controls,
	})
	Utils.Corner(fpsChip, 8)
	Utils.Stroke(fpsChip)
	Utils.Padding(fpsChip, 8, 0, 8, 0)
	UI.Refs.FPSLabel = fpsChip
	UI.Refs.FPSChip = fpsChip

	local function headerButton(text, order, callback)
		local button = Utils.New("TextButton", {
			Name = "Btn_" .. text,
			AutoButtonColor = false,
			BackgroundColor3 = Theme.Surface,
			BorderSizePixel = 0,
			Text = text,
			Font = Theme.FontBold,
			TextSize = 14,
			TextColor3 = Theme.PrimaryText,
			Size = UDim2.fromOffset(28, 28),
			LayoutOrder = order,
			Parent = controls,
		})
		Utils.Corner(button, 8)
		Utils.Stroke(button)
		UI.AttachButtonFx(button, maid, Theme.Surface, Theme.SurfaceHover)
		maid:Give(button.Activated:Connect(function()
			Utils.SafeCall(callback)
		end))
		return button
	end

	UI.Refs.MinimizeButton = headerButton("-", 2, function()
		UI.SetMinimized(not UIState.Minimized)
	end)
	headerButton("X", 3, function()
		UI.SetOpen(false)
	end)

	UI.MakeDraggable(header, UI.Refs.Window, maid, function(position)
		UI.RestPosition = position
	end)
	return header
end

function UI.CreateSidebarButton(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateSidebarButton")
	Utils.Require(opts, "Page", "table", "CreateSidebarButton")
	local maid = opts.Maid or RootMaid
	local page = opts.Page

	local button = Utils.New("TextButton", {
		Name = "Nav_" .. page.Id,
		AutoButtonColor = false,
		Text = "",
		BackgroundColor3 = Theme.SurfaceSecondary,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 38),
		LayoutOrder = nextOrder(opts.Parent),
		Parent = opts.Parent,
	})
	Utils.Corner(button, 9)

	local indicator = Utils.New("Frame", {
		Name = "Indicator",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(3, 16),
		BackgroundColor3 = Theme.Accent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = button,
	})
	Utils.Corner(indicator, 2)

	local icon, iconProperty
	if page.Icon and page.Icon ~= "" then
		icon = Utils.New("ImageLabel", {
			Name = "Icon",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0, 22, 0.5, 0),
			Size = UDim2.fromOffset(20, 20),
			BackgroundTransparency = 1,
			Image = page.Icon,
			ImageColor3 = Theme.SecondaryText,
			Parent = button,
		})
		iconProperty = "ImageColor3"
	else
		icon = Utils.New("TextLabel", {
			Name = "Icon",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0, 22, 0.5, 0),
			Size = UDim2.fromOffset(22, 22),
			BackgroundColor3 = Theme.Surface,
			BorderSizePixel = 0,
			Text = string.upper(string.sub(page.Title, 1, 1)),
			Font = Theme.FontBold,
			TextSize = 11,
			TextColor3 = Theme.SecondaryText,
			Parent = button,
		})
		Utils.Corner(icon, 6)
		iconProperty = "TextColor3"
	end

	local label = Utils.Label({
		Parent = button,
		Name = "Label",
		Text = page.Title,
		Font = Theme.FontMedium,
		Size = 12,
		Color = Theme.SecondaryText,
		Frame = UDim2.new(1, -46, 1, 0),
		Position = UDim2.fromOffset(42, 0),
		Truncate = Enum.TextTruncate.AtEnd,
	})

	local selected, hovering, compact = false, false, false
	local function render()
		local transparency = selected and 0 or (hovering and 0.5 or 1)
		local color = selected and Theme.SurfaceSecondary or Theme.SurfaceHover
		Anim.Tween(button, { BackgroundTransparency = transparency, BackgroundColor3 = color }, "Fast")
		Anim.Tween(indicator, { BackgroundTransparency = selected and 0 or 1 }, "Fast")
		indicator.BackgroundColor3 = Theme.Accent
		Anim.Tween(label, { TextColor3 = selected and Theme.PrimaryText or Theme.SecondaryText }, "Fast")
		Anim.Tween(icon, { [iconProperty] = selected and Theme.Accent or Theme.SecondaryText }, "Fast")
	end

	UI.AttachButtonFx(button, maid, nil, nil, function(isHovering)
		hovering = isHovering
		render()
	end)
	UI.OnAccent(maid, render)
	maid:Give(button.Activated:Connect(function()
		UI.ShowPage(page.Id)
	end))

	local api = { Id = page.Id, Instance = button }
	function api.SetSelected(value)
		selected = value == true
		render()
	end
	function api.SetCompact(value)
		compact = value == true
		label.Visible = not compact
		if compact then
			icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		else
			icon.Position = UDim2.new(0, 22, 0.5, 0)
		end
	end
	api.SetCompact(UI.Compact)
	UI.SidebarButtons[page.Id] = api
	return api
end

function UI.CreateSidebar(parent)
	local sidebar = Utils.New("Frame", {
		Name = "Sidebar",
		BackgroundColor3 = Theme.Surface,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Size = UDim2.new(0, Config.Window.SidebarWidth, 1, 0),
		Parent = parent,
	})
	Utils.New("Frame", {
		Name = "Divider",
		BackgroundColor3 = Theme.Border,
		BackgroundTransparency = 0.92,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		Parent = sidebar,
	})
	UI.Refs.Sidebar = sidebar

	local scroll = Utils.New("ScrollingFrame", {
		Name = "Buttons",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, -68),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 0,
		Parent = sidebar,
	})
	Utils.Padding(scroll, 8, 8, 9, 8)
	Utils.List(scroll, 4)

	UI.Compact = UI.ComputeWindowSize().X < Config.Window.CompactBelow
	for _, page in ipairs(Config.Pages) do
		UI.CreateSidebarButton({ Parent = scroll, Page = page })
	end

	local profile = UI.CreatePlayerProfile({ Parent = sidebar })
	profile.Frame.AnchorPoint = Vector2.new(0, 1)
	profile.Frame.Position = UDim2.new(0, 8, 1, -8)
	profile.Frame.Size = UDim2.new(1, -17, 0, 52)
	UI.Refs.Profile = profile

	Store.Bind("ShowProfile", function(visible)
		profile.Frame.Visible = visible
		scroll.Size = visible and UDim2.new(1, 0, 1, -68) or UDim2.fromScale(1, 1)
	end, RootMaid)
	return sidebar
end

function UI.CreatePage(opts)
	Utils.Require(opts, "Id", "string", "CreatePage")
	local page = Utils.New("CanvasGroup", {
		Name = "Page_" .. opts.Id,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
		Parent = UI.Refs.Content,
	})
	local scroll = Utils.New("ScrollingFrame", {
		Name = "Scroll",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Color3.fromRGB(90, 94, 106),
		Parent = page,
	})
	Utils.Padding(scroll, 14, 12, 14, 16)
	Utils.List(scroll, 16)

	local titleBlock = Utils.New("Frame", {
		Name = "TitleBlock",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = nextOrder(scroll),
		Parent = scroll,
	})
	Utils.List(titleBlock, 2)
	Utils.Label({
		Parent = titleBlock,
		Name = "Title",
		Text = opts.Title or opts.Id,
		Font = Theme.FontBold,
		Size = 20,
		Frame = UDim2.new(1, 0, 0, 26),
		LayoutOrder = 1,
	})
	Utils.Label({
		Parent = titleBlock,
		Name = "Description",
		Text = opts.Description or "",
		Size = 12,
		Color = Theme.SecondaryText,
		Frame = UDim2.new(1, 0, 0, 0),
		AutoSize = Enum.AutomaticSize.Y,
		Wrapped = true,
		LayoutOrder = 2,
	})

	UI.Pages[opts.Id] = { Page = page, Scroll = scroll }
	return scroll
end

function UI.ShowPage(id, instant)
	local target = UI.Pages[id]
	if not target then
		warn("[NUU7 HUB] Página inexistente: " .. tostring(id))
		return false
	end
	local previousId = UIState.CurrentPage
	if previousId == id and target.Page.Visible and not instant then
		return true
	end
	UI.NavToken = UI.NavToken + 1
	UIState.CurrentPage = id

	for pageId, button in pairs(UI.SidebarButtons) do
		button.SetSelected(pageId == id)
	end

	if previousId ~= id then
		local previous = UI.Pages[previousId]
		if previous and previous.Page.Visible then
			Anim.Tween(previous.Page, { GroupTransparency = 1, Position = UDim2.fromOffset(0, 6) }, "Fast")
			task.delay(Settings.AnimationsEnabled and 0.14 or 0, function()
				if UIState.Destroyed then
					return
				end
				if UIState.CurrentPage ~= previousId and previous.Page.Parent then
					previous.Page.Visible = false
				end
			end)
		end
	end

	target.Scroll.CanvasPosition = Vector2.zero
	target.Page.Visible = true
	if instant then
		Anim.Stop(target.Page)
		target.Page.GroupTransparency = 0
		target.Page.Position = UDim2.fromOffset(0, 0)
	else
		target.Page.GroupTransparency = 1
		target.Page.Position = UDim2.fromOffset(0, 10)
		Anim.Tween(target.Page, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 0) }, "Normal")
	end
	return true
end

function UI.PlayOpen()
	local window, scale = UI.Refs.Window, UI.Refs.WindowScale
	UI.OpenToken = UI.OpenToken + 1
	window.Visible = true
	if UI.Refs.Launcher then
		UI.Refs.Launcher.Visible = false
	end
	local rest = UI.RestPosition or window.Position
	window.Position = rest + UDim2.fromOffset(0, 10)
	scale.Scale = 0.96
	window.GroupTransparency = 1
	Anim.Tween(window, { GroupTransparency = 0, Position = rest }, "Slow")
	Anim.Tween(scale, { Scale = 1 }, "Slow")
end

function UI.PlayClose()
	local window, scale = UI.Refs.Window, UI.Refs.WindowScale
	UI.OpenToken = UI.OpenToken + 1
	local token = UI.OpenToken
	Anim.Tween(window, { GroupTransparency = 1 }, "Normal")
	Anim.Tween(scale, { Scale = 0.96 }, "Normal")
	task.delay(Settings.AnimationsEnabled and 0.22 or 0, function()
		if UIState.Destroyed or token ~= UI.OpenToken then
			return
		end
		window.Visible = false
		if UI.Refs.Launcher then
			UI.Refs.Launcher.Visible = true
		end
	end)
end

function UI.SetOpen(open)
	open = open == true
	if UIState.Open == open then
		return
	end
	UIState.Open = open
	if open then
		UI.PlayOpen()
	else
		UI.PlayClose()
	end
end

function UI.SetMinimized(minimized)
	minimized = minimized == true
	UIState.Minimized = minimized
	local window = UI.Refs.Window
	local size = UI.ComputeWindowSize()
	UI.Refs.MinimizeButton.Text = minimized and "+" or "-"
	if minimized then
		Anim.Tween(window, { Size = UDim2.fromOffset(size.X, HEADER_HEIGHT) }, "Normal")
	else
		Anim.Tween(window, { Size = UDim2.fromOffset(size.X, size.Y) }, "Normal")
	end
end

function UI.CreateWindow()
	local gui = Utils.New("ScreenGui", {
		Name = GUI_NAME,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 100,
		Parent = PlayerGui,
	})
	RootMaid:Give(gui)
	UI.Refs.Gui = gui

	local size = UI.ComputeWindowSize()
	local viewport = Utils.GetViewport()
	UI.RestPosition = UDim2.fromOffset(viewport.X / 2, viewport.Y / 2)

	local window = Utils.New("CanvasGroup", {
		Name = "Window",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UI.RestPosition,
		Size = UDim2.fromOffset(size.X, size.Y),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Parent = gui,
	})
	Utils.Corner(window, 16)
	Utils.Stroke(window, 0.88)
	UI.Refs.Window = window
	UI.Refs.WindowScale = Utils.New("UIScale", { Scale = 0.96, Parent = window })

	UI.CreateHeader(window)

	local body = Utils.New("Frame", {
		Name = "Body",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, HEADER_HEIGHT),
		Size = UDim2.new(1, 0, 1, -HEADER_HEIGHT),
		Parent = window,
	})
	UI.Refs.Body = body
	UI.CreateSidebar(body)

	UI.Refs.Content = Utils.New("Frame", {
		Name = "Content",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(Config.Window.SidebarWidth, 0),
		Size = UDim2.new(1, -Config.Window.SidebarWidth, 1, 0),
		Parent = body,
	})

	UI.Refs.Overlay = Utils.New("Frame", {
		Name = "Overlay",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Parent = gui,
	})
	local toasts = Utils.New("Frame", {
		Name = "Toasts",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 14),
		Size = UDim2.fromOffset(280, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = UI.Refs.Overlay,
	})
	Utils.List(toasts, 6)
	UI.Refs.Toasts = toasts

	local launcher = Utils.New("ImageButton", {
		Name = "Launcher",
		AutoButtonColor = false,
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		Image = Config.LogoImage,
		ScaleType = Enum.ScaleType.Fit,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(40, viewport.Y / 2),
		Size = UDim2.fromOffset(46, 46),
		Visible = false,
		Parent = gui,
	})
	Utils.Corner(launcher, 23)
	Utils.Stroke(launcher, 0.8)
	UI.Refs.Launcher = launcher
	local dragState = UI.MakeDraggable(launcher, launcher, RootMaid)
	RootMaid:Give(launcher.Activated:Connect(function()
		if not dragState.Moved then
			UI.SetOpen(true)
		end
	end))

	UI.CreateSidebarLayoutHook()
	return window
end

function UI.CreateSidebarLayoutHook()
	local connection
	local function hook()
		if connection then
			connection:Disconnect()
			connection = nil
		end
		local camera = workspace.CurrentCamera
		if camera then
			connection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
				UI.ApplyLayout()
			end)
		end
	end
	hook()
	RootMaid:Give(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		hook()
		UI.ApplyLayout()
	end))
	RootMaid:Give(function()
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end)
end

----------------------------------------------------------------
-- ENTORNO, TEMAS Y RESET
----------------------------------------------------------------
local OriginalLighting = {
	ClockTime = Lighting.ClockTime,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	FogColor = Lighting.FogColor,
	FogStart = Lighting.FogStart,
	FogEnd = Lighting.FogEnd,
}
local environmentTouched = false

function UI.ApplyEnvironment(lightingData)
	if not Config.AllowEnvironmentPreview then
		return
	end
	environmentTouched = true
	local data = lightingData or OriginalLighting
	for property, value in pairs(data) do
		if property ~= "ClockTime" then
			Lighting[property] = value
		end
	end
	Lighting.ClockTime = Settings.GameTime
end

function UI.RestoreEnvironment()
	if not environmentTouched then
		return
	end
	for property, value in pairs(OriginalLighting) do
		Lighting[property] = value
	end
end

Store.BindAll(function(key, value)
	if key == "GameTime" and Config.AllowEnvironmentPreview then
		environmentTouched = true
		Lighting.ClockTime = value
	end
end, RootMaid)

function UI.ApplyTheme(name)
	local preset = ThemePresets[name]
	if not preset then
		warn("[NUU7 HUB] Tema inexistente: " .. tostring(name))
		return false
	end
	Store.Set("CurrentTheme", name)
	Store.Set("AccentColor", preset.Accent)
	if preset.Lighting then
		Store.Set("GameTime", preset.Lighting.ClockTime)
	end
	UI.ApplyEnvironment(preset.Lighting)
	UI.CreateNotification({
		Title = "Tema aplicado",
		Message = preset.Label,
		Type = "Success",
		Duration = 2,
	})
	return true
end

function UI.ResetSettings(skipConfirm)
	local function perform()
		Store.ResetAll()
		UI.ApplyEnvironment(nil)
		UI.CreateNotification({
			Title = "Valores restaurados",
			Message = "Se restauró la configuración predeterminada.",
			Type = "Success",
		})
	end
	if skipConfirm then
		perform()
	else
		UI.Confirm({
			Title = "Restablecer configuración",
			Message = "Se restaurarán todas las opciones, la selección de partes y el tema a sus valores predeterminados.",
			ConfirmText = "Restablecer",
			OnConfirm = perform,
		})
	end
end

function UI.ResetVisualSettings()
	Store.ResetVisual()
	UI.CreateNotification({
		Title = "Interfaz restaurada",
		Message = "Se restauró la configuración visual.",
		Type = "Success",
		Duration = 2,
	})
end

local function createThemeCard(parent, id, description)
	local preset = ThemePresets[id]
	local maid = RootMaid
	local card, right, stroke = UI.CreateCard({
		Parent = parent,
		Title = preset.Label,
		Description = description,
		RightWidth = 84,
		Clickable = true,
		Maid = maid,
	})
	local row = Utils.New("Frame", {
		Name = "Preview",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(84, 22),
		Parent = right,
	})
	Utils.List(row, 6, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
	for index, color in ipairs(preset.Preview) do
		local swatch = Utils.New("Frame", {
			Name = "Swatch" .. index,
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(20, 20),
			LayoutOrder = index,
			Parent = row,
		})
		Utils.Corner(swatch, 10)
		Utils.Stroke(swatch, 0.75)
	end

	local function render()
		local selected = Settings.CurrentTheme == id
		stroke.Color = selected and Theme.Accent or Theme.Border
		stroke.Transparency = selected and 0.2 or Theme.BorderTransparency
	end
	Store.Bind("CurrentTheme", render, maid)
	UI.OnAccent(maid, render)
	maid:Give(card.Activated:Connect(function()
		UI.ApplyTheme(id)
	end))
	return card
end

----------------------------------------------------------------
-- PÁGINAS
----------------------------------------------------------------
local PageBuilders = {}

PageBuilders.NuShoot = function(scroll)
	local modeSection = UI.CreateSection({ Parent = scroll, Title = "Modo de disparo" })
	UI.CreateToggle({
		Parent = modeSection,
		Key = "NuShoot",
		Title = "NuShoot",
		Description = "Dispara automáticamente.",
	})
	UI.CreateToggle({
		Parent = modeSection,
		Key = "ClickShot",
		Title = "ClickShot",
		Description = "Activa el disparo al tocar la pantalla o hacer clic izquierdo con el ratón.",
	})

	local configSection = UI.CreateSection({ Parent = scroll, Title = "Configuración" })
	UI.CreateSlider({
		Parent = configSection,
		Key = "DetectionPoints",
		Title = "Punto de detección",
		Description = "Cantidad de puntos de detección que se generan por cada parte del cuerpo.",
	})

	local fovSection = UI.CreateSection({ Parent = scroll, Title = "FOV" })
	UI.CreateToggle({
		Parent = fovSection,
		Key = "FOVEnabled",
		Title = "Activar FOV",
		Description = "Limita la detección a los objetivos que se encuentren dentro del círculo de FOV.",
	})
	UI.CreateSlider({
		Parent = fovSection,
		Key = "FOVSize",
		Title = "Tamaño FOV",
		Description = "Ajusta el tamaño del círculo de FOV.",
	})

	local bodySection = UI.CreateSection({ Parent = scroll, Title = "Partes del cuerpo" })
	UI.CreateBodyPartSelector({ Parent = bodySection })
end

PageBuilders.ESP = function(scroll)
	local wallSection = UI.CreateSection({ Parent = scroll, Title = "Visión a través de paredes" })
	UI.CreateToggle({
		Parent = wallSection,
		Key = "ESPEnabled",
		Title = "ESP Activado",
		Description = "Muestra información visual de los objetivos mediante una representación ESP autorizada.",
	})
	UI.CreateToggle({
		Parent = wallSection,
		Key = "AllyESP",
		Title = "Ally ESP",
		Description = "Permite distinguir visualmente a los aliados.",
	})

	local colorSection = UI.CreateSection({ Parent = scroll, Title = "Colores" })
	UI.CreateColorPicker({
		Parent = colorSection,
		Key = "OutlineColor",
		Title = "Color Outline",
		Description = "Color del contorno principal.",
	})
	UI.CreateColorPicker({
		Parent = colorSection,
		Key = "AllyOutlineColor",
		Title = "Color Ally Outline",
		Description = "Color del contorno de los aliados.",
	})
end

PageBuilders.Hitbox = function(scroll)
	local detectionSection = UI.CreateSection({ Parent = scroll, Title = "Configuración de detección" })
	UI.CreateSlider({
		Parent = detectionSection,
		Key = "DetectionPoints",
		Title = "Punto de detección",
		Description = "Cantidad de puntos de detección por parte del cuerpo.",
	})

	local fovSection = UI.CreateSection({ Parent = scroll, Title = "FOV" })
	UI.CreateToggle({
		Parent = fovSection,
		Key = "FOVEnabled",
		Title = "Activar FOV",
		Description = "Restringe la detección a la zona delimitada por el FOV.",
	})
	UI.CreateSlider({
		Parent = fovSection,
		Key = "FOVSize",
		Title = "Tamaño FOV",
		Description = "Ajusta el tamaño del área de detección.",
	})

	local bodySection = UI.CreateSection({ Parent = scroll, Title = "Partes del cuerpo" })
	UI.CreateBodyPartSelector({ Parent = bodySection })
end

PageBuilders.Settings = function(scroll)
	local themeSection = UI.CreateSection({ Parent = scroll, Title = "Temas" })
	UI.CreateSlider({
		Parent = themeSection,
		Key = "GameTime",
		Title = "Hora del juego",
		Description = "Cambia la hora visual del entorno.",
	})
	createThemeCard(themeSection, "Tokoyami", "Atardecer cálido con neblina.")
	createThemeCard(themeSection, "Night", "Noche estrellada con luces de neón.")
	createThemeCard(themeSection, "Pink", "Estilo synthwave rosa y morado.")
	UI.CreateButton({
		Parent = themeSection,
		Title = "Reset",
		Description = "Restaura los valores predeterminados.",
		Callback = function()
			UI.ResetSettings(false)
		end,
	})

	local interfaceSection = UI.CreateSection({ Parent = scroll, Title = "Interfaz" })
	UI.CreateToggle({
		Parent = interfaceSection,
		Key = "AnimationsEnabled",
		Title = "Animaciones",
		Description = "Activa o desactiva las transiciones de la interfaz.",
	})
	UI.CreateToggle({
		Parent = interfaceSection,
		Key = "ShowProfile",
		Title = "Mini perfil",
		Description = "Muestra u oculta la tarjeta de perfil en la barra lateral.",
	})
	UI.CreateToggle({
		Parent = interfaceSection,
		Key = "ShowFPS",
		Title = "Indicador de FPS",
		Description = "Muestra u oculta los FPS en la cabecera.",
	})
	UI.CreateColorPicker({
		Parent = interfaceSection,
		Key = "AccentColor",
		Title = "Color Accent",
		Description = "Color de acento de la interfaz.",
	})
	UI.CreateButton({
		Parent = interfaceSection,
		Title = "Restaurar configuración visual",
		Description = "Restablece animaciones, perfil, FPS, acento y avatar.",
		Callback = function()
			UI.ResetVisualSettings()
		end,
	})
end

PageBuilders.Avatar = function(scroll)
	local previewSection = UI.CreateSection({ Parent = scroll, Title = "Vista previa" })
	UI.CreatePlayerProfile({ Parent = previewSection, FollowSettings = true })

	local styleSection = UI.CreateSection({ Parent = scroll, Title = "Estilo" })
	UI.CreateSegmented({
		Parent = styleSection,
		Key = "AvatarShape",
		Title = "Forma del avatar",
		Description = "Alterna entre miniatura circular y cuadrada.",
		Options = {
			{ Value = "Circle", Label = "Circular" },
			{ Value = "Square", Label = "Cuadrado" },
		},
	})
	UI.CreateSlider({
		Parent = styleSection,
		Key = "AvatarSize",
		Title = "Tamaño de la miniatura",
		Description = "Cambia el tamaño de la miniatura en la tarjeta.",
	})
	UI.CreateButton({
		Parent = styleSection,
		Title = "Actualizar miniatura",
		Description = "Vuelve a descargar la miniatura del jugador.",
		Callback = function()
			UI.ReloadThumbnails()
			UI.CreateNotification({
				Title = "Miniatura actualizada",
				Type = "Info",
				Duration = 2,
			})
		end,
	})
end

function UI.BuildPages()
	for _, pageConfig in ipairs(Config.Pages) do
		local scroll = UI.CreatePage(pageConfig)
		local builder = PageBuilders[pageConfig.Id]
		if builder then
			builder(scroll)
		end
	end
end

----------------------------------------------------------------
-- EVENTOS, API Y LIMPIEZA
----------------------------------------------------------------
local API = {}

function UI.Destroy()
	if UIState.Destroyed then
		return
	end
	UIState.Destroyed = true
	UI.RestoreEnvironment()
	RootMaid:Clean()
	if shared.NUU7Hub == API then
		shared.NUU7Hub = nil
	end
end

local function startFPSCounter()
	local connection = nil
	local frames, elapsed = 0, 0

	local function setActive(active)
		if active and not connection then
			frames, elapsed = 0, 0
			connection = RunService.Heartbeat:Connect(function(dt)
				frames = frames + 1
				elapsed = elapsed + dt
				if elapsed >= Config.FPSUpdateInterval then
					local fps = math.floor(frames / elapsed + 0.5)
					UI.Refs.FPSLabel.Text = fps .. " FPS"
					frames, elapsed = 0, 0
				end
			end)
		elseif not active and connection then
			connection:Disconnect()
			connection = nil
		end
	end

	Store.Bind("ShowFPS", function(visible)
		UI.Refs.FPSChip.Visible = visible
		setActive(visible)
	end, RootMaid)

	RootMaid:Give(function()
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end)
end

local function bindInput()
	RootMaid:Give(UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end
		if input.KeyCode == Config.ToggleKey then
			UI.SetOpen(not UIState.Open)
		end
	end))
end

API.Settings = Store
API.Config = Config
API.Open = function()
	UI.SetOpen(true)
end
API.Close = function()
	UI.SetOpen(false)
end
API.Toggle = function()
	UI.SetOpen(not UIState.Open)
end
API.Notify = function(title, message, kind)
	return UI.CreateNotification({ Title = title, Message = message, Type = kind })
end
API.Destroy = function()
	UI.Destroy()
end

----------------------------------------------------------------
-- INICIALIZACIÓN
----------------------------------------------------------------
local function init()
	local defaultFound = false
	for _, page in ipairs(Config.Pages) do
		if page.Id == Config.DefaultPage then
			defaultFound = true
			break
		end
	end
	if not defaultFound then
		Config.DefaultPage = Config.Pages[1].Id
		UIState.CurrentPage = Config.DefaultPage
	end

	UI.CreateWindow()
	UI.BuildPages()
	UI.ApplyLayout()
	UI.ShowPage(Config.DefaultPage, true)
	startFPSCounter()
	bindInput()
	UI.PlayOpen()

	shared.NUU7Hub = API
end

local ok, err = pcall(init)
if not ok then
	warn("[NUU7 HUB] Error al iniciar: " .. tostring(err))
	UI.Destroy()
end
