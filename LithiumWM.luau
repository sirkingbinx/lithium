--// Title: LithiumWM.luau
--// Description: Lithium window manager
--// Author: SirKingBinx
--// For more information including licensing details, see https://github.com/sirkingbinx/lithium

local LithiumWM = {}

local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")

--[[
MIT License

Copyright (c) 2014-2025 James Onnen (Quenty)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

--- Lua-side duplication of the API of events on Roblox objects.
-- Signals are needed for to ensure that for local events objects are passed by
-- reference rather than by value where possible, as the BindableEvent objects
-- always pass signal arguments by value, meaning tables will be deep copied.
-- Roblox's deep copy method parses to a non-lua table compatable format.
-- @classmod Signal

local Signal = {}
Signal.__index = Signal
Signal.ClassName = "Signal"

--- Constructs a new signal.
-- @constructor Signal.new()
-- @treturn Signal
function Signal.new()
	local self = setmetatable({}, Signal)

	self._bindableEvent = Instance.new("BindableEvent")
	self._argData = nil
	self._argCount = nil -- Prevent edge case of :Fire("A", nil) --> "A" instead of "A", nil

	return self
end

--- Fire the event with the given arguments. All handlers will be invoked. Handlers follow
-- Roblox signal conventions.
-- @param ... Variable arguments to pass to handler
-- @treturn nil
function Signal:Fire(...)
	self._argData = {...}
	self._argCount = select("#", ...)
	self._bindableEvent:Fire()
	self._argData = nil
	self._argCount = nil
end

--- Connect a new handler to the event. Returns a connection object that can be disconnected.
-- @tparam function handler Function handler called with arguments passed when `:Fire(...)` is called
-- @treturn Connection Connection object that can be disconnected
function Signal:Connect(handler)
	if not (type(handler) == "function") then
		error(("connect(%s)"):format(typeof(handler)), 2)
	end

	return self._bindableEvent.Event:Connect(function()
		handler(unpack(self._argData, 1, self._argCount))
	end)
end

--- Wait for fire to be called, and return the arguments it was given.
-- @treturn ... Variable arguments from connection
function Signal:Wait()
	self._bindableEvent.Event:Wait()
	assert(self._argData, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
	return unpack(self._argData, 1, self._argCount)
end

--- Disconnects all connected events to the signal. Voids the signal as unusable.
-- @treturn nil
function Signal:Destroy()
	if self._bindableEvent then
		self._bindableEvent:Destroy()
		self._bindableEvent = nil
	end

	self._argData = nil
	self._argCount = nil
end

local CreateWMAssets = {
	MenuButton = function()
		-- gui2lua 3.2
		local MenuButton = Instance.new("TextButton")
		local ItemsHolder = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")

		MenuButton.Name = "MenuButton"
		MenuButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		MenuButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MenuButton.BorderSizePixel = 0
		MenuButton.Size = UDim2.new(0, 60, 0, 30)
		MenuButton.Font = Enum.Font.Roboto
		MenuButton.Text = "File"
		MenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		MenuButton.TextSize = 14.000

		ItemsHolder.Name = "ItemsHolder"
		ItemsHolder.Parent = MenuButton
		ItemsHolder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		ItemsHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ItemsHolder.BorderSizePixel = 0
		ItemsHolder.Position = UDim2.new(0, 0, 0, 30)
		ItemsHolder.Size = UDim2.new(0, 250, 0, 30)
		ItemsHolder.Visible = false

		UIListLayout.Parent = ItemsHolder
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		return MenuButton
	end,

	MenuItemSlot = function()
		local MenuItemSlot = Instance.new("TextButton")
		local ItemText = Instance.new("TextLabel")
		local ItemKeybinds = Instance.new("TextLabel")

		MenuItemSlot.Name = "MenuItemSlot"
		MenuItemSlot.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		MenuItemSlot.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MenuItemSlot.BorderSizePixel = 0
		MenuItemSlot.Size = UDim2.new(1, 0, 0, 30)
		MenuItemSlot.Font = Enum.Font.SourceSans
		MenuItemSlot.Text = "No snooping!"
		MenuItemSlot.TextColor3 = Color3.fromRGB(15, 15, 15)
		MenuItemSlot.TextSize = 1.000
		MenuItemSlot.TextTransparency = 1.000

		ItemText.Name = "ItemText"
		ItemText.Parent = MenuItemSlot
		ItemText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ItemText.BackgroundTransparency = 1.000
		ItemText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ItemText.BorderSizePixel = 0
		ItemText.Position = UDim2.new(0, 10, 0, 0)
		ItemText.Size = UDim2.new(1, -90, 0, 30)
		ItemText.Font = Enum.Font.Roboto
		ItemText.Text = "Menu Option"
		ItemText.TextColor3 = Color3.fromRGB(255, 255, 255)
		ItemText.TextSize = 14
		ItemText.TextStrokeTransparency = 0.750
		ItemText.TextXAlignment = Enum.TextXAlignment.Left

		ItemKeybinds.Name = "ItemKeybinds"
		ItemKeybinds.Parent = MenuItemSlot
		ItemKeybinds.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ItemKeybinds.BackgroundTransparency = 1.000
		ItemKeybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ItemKeybinds.BorderSizePixel = 0
		ItemKeybinds.Position = UDim2.new(1, -80, 0, 0)
		ItemKeybinds.Size = UDim2.new(0, 75, 0, 30)
		ItemKeybinds.Font = Enum.Font.Roboto
		ItemKeybinds.Text = "CTRL + C"
		ItemKeybinds.TextColor3 = Color3.fromRGB(175, 175, 175)
		ItemKeybinds.TextSize = 14
		ItemKeybinds.TextStrokeTransparency = 0.750
		ItemKeybinds.TextXAlignment = Enum.TextXAlignment.Right

		return MenuItemSlot
	end,

	LithiumWindow = function()
		local LithiumWindow = Instance.new("Frame")
		local Scaling = Instance.new("Frame")
		local CornerScalePoint = Instance.new("Frame")
		local XScale = Instance.new("Frame")
		local YScale = Instance.new("Frame")
		local Content = Instance.new("Frame")
		local Topbar = Instance.new("Frame")
		local CloseBtn = Instance.new("TextButton")
		local MaxBtn = Instance.new("TextButton")
		local MinBtn = Instance.new("TextButton")
		local MenuButtons = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local WindowTitle = Instance.new("TextLabel")

		local TopbarMove = Instance.new("UIDragDetector")
		TopbarMove.Parent = LithiumWindow
		TopbarMove.Name = "TopbarMove"
		TopbarMove.BoundingUI = Topbar

		LithiumWindow.Name = "LithiumWindow"
		LithiumWindow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		LithiumWindow.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LithiumWindow.BorderSizePixel = 0
		LithiumWindow.Position = UDim2.new(0, 300, 0, 80)
		LithiumWindow.Size = UDim2.new(0, 450, 0, 525)

		Scaling.Name = "Scaling"
		Scaling.Parent = LithiumWindow
		Scaling.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Scaling.BackgroundTransparency = 1.000
		Scaling.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Scaling.BorderSizePixel = 0
		Scaling.Size = UDim2.new(1, 0, 1, 0)

		CornerScalePoint.Name = "CornerScalePoint"
		CornerScalePoint.Parent = Scaling
		CornerScalePoint.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		CornerScalePoint.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CornerScalePoint.BorderSizePixel = 0
		CornerScalePoint.Position = UDim2.new(1, -5, 1, -5)
		CornerScalePoint.Size = UDim2.new(0, 5, 0, 5)

		XScale.Name = "XScale"
		XScale.Parent = Scaling
		XScale.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		XScale.BorderColor3 = Color3.fromRGB(0, 0, 0)
		XScale.BorderSizePixel = 0
		XScale.Position = UDim2.new(1, -5, 0, 30)
		XScale.Size = UDim2.new(0, 5, 1, -35)

		YScale.Name = "YScale"
		YScale.Parent = Scaling
		YScale.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		YScale.BorderColor3 = Color3.fromRGB(0, 0, 0)
		YScale.BorderSizePixel = 0
		YScale.Position = UDim2.new(0, 0, 1, -5)
		YScale.Size = UDim2.new(1, -5, 0, 5)

		local csp = Instance.new("UIDragDetector")
		csp.Parent = CornerScalePoint
		csp.Name = "CornerScale"
		csp.BoundingUI = LithiumWindow
		csp.DragStyle = Enum.UIDragDetectorDragStyle.Scriptable

		local dd = Instance.new("UIDragDetector")
		dd.Parent = XScale
		dd.Name = "Scaler"
		dd.BoundingUI = LithiumWindow
		dd.DragStyle = Enum.UIDragDetectorDragStyle.Scriptable

		local dd2 = Instance.new("UIDragDetector")
		dd2.Parent = YScale
		dd2.Name = "Scaler"
		dd2.BoundingUI = LithiumWindow
		dd2.DragStyle = Enum.UIDragDetectorDragStyle.Scriptable

		Content.Name = "Content"
		Content.Parent = LithiumWindow
		Content.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Content.BorderSizePixel = 0
		Content.Position = UDim2.new(0, 5, 0, 35)
		Content.Size = UDim2.new(1, -10, 1, -40)

		Topbar.Name = "Topbar"
		Topbar.Parent = LithiumWindow
		Topbar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		Topbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Topbar.BorderSizePixel = 0
		Topbar.Size = UDim2.new(1, 0, 0, 30)
		Topbar.ZIndex = 2

		CloseBtn.Name = "CloseBtn"
		CloseBtn.Parent = Topbar
		CloseBtn.BackgroundColor3 = Color3.fromRGB(161, 26, 33)
		CloseBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CloseBtn.BorderSizePixel = 0
		CloseBtn.Position = UDim2.new(1, -30, 0, 0)
		CloseBtn.Size = UDim2.new(0, 30, 0, 30)
		CloseBtn.Font = Enum.Font.Roboto
		CloseBtn.Text = "X"
		CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		CloseBtn.TextSize = 20.000

		MaxBtn.Name = "MaxBtn"
		MaxBtn.Parent = Topbar
		MaxBtn.BackgroundColor3 = Color3.fromRGB(46, 41, 118)
		MaxBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MaxBtn.BorderSizePixel = 0
		MaxBtn.Position = UDim2.new(1, -60, 0, 0)
		MaxBtn.Size = UDim2.new(0, 30, 0, 30)
		MaxBtn.Font = Enum.Font.Roboto
		MaxBtn.Text = "[  ]"
		MaxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		MaxBtn.TextSize = 15.000

		MinBtn.Name = "MinBtn"
		MinBtn.Parent = Topbar
		MinBtn.BackgroundColor3 = Color3.fromRGB(46, 41, 118)
		MinBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MinBtn.BorderSizePixel = 0
		MinBtn.Position = UDim2.new(1, -90, 0, 0)
		MinBtn.Size = UDim2.new(0, 30, 0, 30)
		MinBtn.Font = Enum.Font.Roboto
		MinBtn.Text = "--"
		MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		MinBtn.TextSize = 15.000

		MenuButtons.Name = "MenuButtons"
		MenuButtons.Parent = Topbar
		MenuButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MenuButtons.BackgroundTransparency = 1.000
		MenuButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MenuButtons.BorderSizePixel = 0
		MenuButtons.Position = UDim2.new(0, 70, 0, 0)
		MenuButtons.Size = UDim2.new(1, -160, 0, 30)

		UIListLayout.Parent = MenuButtons
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

		WindowTitle.Name = "WindowTitle"
		WindowTitle.Parent = Topbar
		WindowTitle.BackgroundColor3 = Color3.fromRGB(46, 41, 118)
		WindowTitle.BackgroundTransparency = 1.000
		WindowTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		WindowTitle.BorderSizePixel = 0
		WindowTitle.Position = UDim2.new(0, 10, 0, 0)
		WindowTitle.Size = UDim2.new(0, 55, 0, 30)
		WindowTitle.Font = Enum.Font.Roboto
		WindowTitle.Text = "Title"
		WindowTitle.TextColor3 = Color3.fromRGB(170, 170, 170)
		WindowTitle.TextSize = 14
		WindowTitle.TextXAlignment = Enum.TextXAlignment.Left

		return LithiumWindow
	end,

	Tab = function()
		local Tab = Instance.new("TextButton")
		local TitleText = Instance.new("TextLabel")

		Tab.Name = "Tab"
		Tab.Active = false
		Tab.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab.BorderSizePixel = 0
		Tab.Selectable = false
		Tab.Size = UDim2.new(0, 200, 0, 30)
		Tab.ZIndex = 2
		Tab.Text = ""

		TitleText.Name = "TitleText"
		TitleText.Parent = Tab
		TitleText.BackgroundColor3 = Color3.fromRGB(46, 41, 118)
		TitleText.BackgroundTransparency = 1.000
		TitleText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TitleText.BorderSizePixel = 0
		TitleText.Position = UDim2.new(0, 10, 0, 0)
		TitleText.Size = UDim2.new(1, -10, 0, 30)
		TitleText.Font = Enum.Font.Roboto
		TitleText.Text = "Lithium"
		TitleText.TextColor3 = Color3.fromRGB(170, 170, 170)
		TitleText.TextSize = 16.000
		TitleText.TextXAlignment = Enum.TextXAlignment.Left

		return Tab
	end,
}

export type LithiumButton = {
	-- data
	name: string,
	keybinds: { Enum.KeyCode },

	-- events
	onClick: () -> (),

	-- local
	__KEYBINDS: {},
}

export type LithiumMenuToolbar = {
	-- data
	name: string,
	buttons: { LithiumButton },
	associatedFrame: Frame,

	-- methods
	AddButton: (name: string, callback: () -> (), keybinds: { InputObject? }) -> LithiumButton,
}

export type LithiumWindow = {
	title: string,
	frame: Frame,
	open: boolean,

	onOpen: Signal,
	onMinimized: Signal,
	onMaximized: Signal,
	onClose: () -> (boolean),

	SetContent: (f: Frame) -> (Frame),

	Open: () -> (),
	Close: () -> (),

	Minimize: () -> (),
	Maximize: () -> (),

	Resize: (size: UDim2) -> (),

	allowMinimizing: boolean,
	allowMaximizing: boolean,
	allowResizing: boolean,
	allowUserClose: boolean,

	toolbars: { LithiumMenuToolbar },

	__LITHIUMDATA: {},

	CreateToolbar: (toolbarName: string) -> LithiumMenuToolbar,
}

local function CreateLithiumMenuToolbar(name: string): LithiumMenuToolbar
	local toolbar: LithiumMenuToolbar = {
		name = name,
		buttons = {},
		associatedFrame = nil,
	}

	toolbar.AddButton = function(name: string, callback: () -> (), keybinds: { Enum.KeyCode? }): LithiumButton
		local buttonUI = CreateWMAssets.MenuItemSlot()
		local buttonObj: LithiumButton = {}

		buttonObj.name = name
		buttonObj.keybinds = keybinds or { }

		buttonObj.value = callback
		buttonObj.onClick = function()
			if toolbar.associatedFrame.Visible then
				toolbar.associatedFrame.Visible = false
			end

			callback()
		end

		buttonUI.Name = name
		buttonUI.ItemText.Text = name
		buttonUI.Parent = toolbar.associatedFrame

		-- grab text size and fix scaling
		local TextSizing: Vector2 = TextService:GetTextSize(buttonUI.ItemText.Text .. "    " .. buttonUI.ItemKeybinds.Text, buttonUI.ItemText.TextSize, buttonUI.ItemText.Font, buttonUI.AbsoluteSize)

		if TextSizing.X > toolbar.associatedFrame.Size.X.Offset then
			toolbar.associatedFrame.Size = UDim2.fromOffset(TextSizing.X + 20, (#toolbar.associatedFrame:GetChildren() - 2) * 30)
		else
			toolbar.associatedFrame.Size = UDim2.fromOffset(toolbar.associatedFrame.Size.X.Offset or 250, (#toolbar.associatedFrame:GetChildren() - 2) * 30)
		end

		if #buttonObj.keybinds > 0 then
			buttonObj.__KEYBINDS = {}
			buttonUI.ItemKeybinds.Text = ""

			for i, keybind: Enum.KeyCode in buttonObj.keybinds do
				local str = UserInputService:GetStringForKeyCode(keybind)

				if str == "" then
					str = keybind.Name:gsub("Left", "L"):gsub("Right", "R"):gsub("Control", "Ctrl"):gsub("Shift", "Shft")
				end

				if buttonUI.ItemKeybinds.Text ~= "" then
					buttonUI.ItemKeybinds.Text = buttonUI.ItemKeybinds.Text .. " + " .. str
				else
					buttonUI.ItemKeybinds.Text = str
				end
			end

			UserInputService.InputBegan:Connect(function(input: InputObject, gpe: boolean)
				if gpe then return nil end

				if table.find(buttonObj.keybinds, input.KeyCode) then
					buttonObj.__KEYBINDS[input.KeyCode] = true

					for _, kb in buttonObj.keybinds do
						if (not buttonObj.__KEYBINDS[kb]) or (buttonObj.__KEYBINDS[kb] == false) then
							return
						end
					end

					buttonObj.onClick()
				end
			end)

			UserInputService.InputEnded:Connect(function(input: InputObject, gpe: boolean)
				if gpe then return nil end

				if table.find(buttonObj.keybinds, input.KeyCode) then
					buttonObj.__KEYBINDS[input.KeyCode] = false
				end
			end)
		else
			buttonUI.ItemKeybinds.Text = ""
		end

		buttonUI.MouseButton1Click:Connect(function()
			buttonObj.onClick()
		end)

		return buttonObj
	end

	return toolbar
end

local function CreateTablist()
	local TabFrame = Instance.new("Frame", script.Parent)

	TabFrame.Size = UDim2.new(1, 0, 0, 30)
	TabFrame.Position = UDim2.new(0, 0, 1, -30)
	TabFrame.Transparency = 1

	local UIListLayout = Instance.new("UIListLayout", TabFrame)
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal

	return TabFrame
end

local function Minimize(window: LithiumWindow)
	local data = window.__LITHIUMDATA

	if data.minimized or (not window.allowMinimizing) then return end

	window.onMinimized:Fire()

	local tab = CreateWMAssets.Tab()
	tab.TitleText.Text = window.title

	window.__LITHIUMDATA.minTab = tab

	local txtSize = TextService:GetTextSize(window.title, tab.TitleText.TextSize, Enum.Font.Roboto, tab.TitleText.AbsoluteSize)
	tab.Size = UDim2.fromOffset(txtSize.X + 20, 30)

	tab.Parent = script.Parent:FindFirstChild("Tabs") or CreateTablist()
	if tab.Parent.Name == "Frame" then tab.Parent.Name = "Tabs" end
	tab.MouseButton1Click:Connect(window.Open)

	window.__LITHIUMDATA.window.Visible = false
end

local function Maximize(window: LithiumWindow)
	if (not window.allowMaximizing) then return end

	window.onMaximized:Fire()

	if window.__LITHIUMDATA.maximized then
		if window.__LITHIUMDATA.fpos and window.__LITHIUMDATA.fscale then
			window.__LITHIUMDATA.window.Size = window.__LITHIUMDATA.fscale
			window.__LITHIUMDATA.window.Position = window.__LITHIUMDATA.fpos

			window.__LITHIUMDATA.maximized = false
		else
			window.__LITHIUMDATA.window.Size = UDim2.fromOffset(400, 300)
			window.__LITHIUMDATA.window.Position = UDim2.fromOffset(75, 75)

			window.__LITHIUMDATA.maximized = false
		end
	else
		window.__LITHIUMDATA.maximized = true

		window.__LITHIUMDATA.fscale = window.__LITHIUMDATA.window.Size
		window.__LITHIUMDATA.fpos = window.__LITHIUMDATA.window.Position

		window.__LITHIUMDATA.window.Size = UDim2.fromScale(1, 1)
		window.__LITHIUMDATA.window.Position = UDim2.fromScale(0, 0)
	end
end

local function FixScalersPosition(windowObj: Frame)
	windowObj.Scaling.CornerScalePoint.Position = UDim2.new(1, -5, 1, -5)
	windowObj.Scaling.XScale.Position = UDim2.new(1, -5, 0, 30)
	windowObj.Scaling.YScale.Position = UDim2.new(0, 0, 1, -5)
end

function LithiumWM.CreateWindow(windowTitle: string, openByDefault: boolean?, initWindowSize: UDim2?): LithiumWindow
	local windowObj = CreateWMAssets.LithiumWindow()

	local window: LithiumWindow = {}

	window.title = windowTitle
	window.open = if openByDefault ~= nil then openByDefault else true

	window.__LITHIUMDATA = {}
	window.__LITHIUMDATA.window = windowObj

	window.__LITHIUMDATA.minimized = false
	window.__LITHIUMDATA.maximized = false
	window.__LITHIUMDATA.minTab = nil

	window.frame = windowObj.Content

	window.allowMinimizing = true
	window.allowMaximizing = true
	window.allowResizing = true
	window.allowUserClose = true
	
	window.onMinimized = Signal.new()
	window.onMaximized = Signal.new()
	window.onOpen      = Signal.new()
	window.onClose     = function() return true end -- placeholder fn

	window.toolbars = {}

	window.Open = function()
		window.__LITHIUMDATA.window.Visible = true
		window.onOpen:Fire()

		if window.__LITHIUMDATA.minTab then
			window.__LITHIUMDATA.minTab:Destroy()
		end
	end

	if not window.open then
		Minimize(window)
	end

	window.Minimize = function()
		Minimize(window)
	end

	window.Maximize = function()
		Maximize(window)
	end

	window.Close = function()
		if (not window.onClose) or window.onClose() ~= false then
			return
		end

		-- unbind events to stop script failures
		window.onMinimized:Destroy()
		window.onMaximized:Destroy()
		window.onOpen:Destroy()

		windowObj:Destroy()
	end

	window.Resize = function(size: UDim2)
		windowObj.Size = UDim2.new(
			0, size.X.Offset or windowObj.Size.X.Offset,
			0, size.Y.Offset or windowObj.Size.Y.Offset
		)

		FixScalersPosition(windowObj)
	end

	windowObj.MouseEnter:Connect(function()
		local quit = false
		local focusIt = false

		local c1 = windowObj.MouseLeave:Once(function()
			quit = true
			windowObj.ZIndex = 1
		end)

		local c2 = UserInputService.InputBegan:Connect(function(i: InputObject, gpe: boolean)
			if i.UserInputType == Enum.UserInputType.MouseButton1 and not gpe then
				focusIt = true
			end
		end)

		while not quit do
			if focusIt then
				windowObj.ZIndex = 2
				c1:Disconnect()
				c2:Disconnect()

				break
			end

			if quit then break end

			task.wait(0.05)
		end
	end)

	local updateBtns = coroutine.create(function()
		local function disable(tb: TextButton)
			tb.BackgroundTransparency = 0.75
			tb.TextTransparency = 0.75
			tb.Interactable = false
		end

		local function enable(tb: TextButton)
			tb.BackgroundTransparency = 0
			tb.TextTransparency = 0
			tb.Interactable = true
		end

		while task.wait(0.1) do
			if window.allowMinimizing then
				enable(windowObj.Topbar.MinBtn)
			else
				disable(windowObj.Topbar.MinBtn)
			end

			if window.allowMaximizing then
				enable(windowObj.Topbar.MaxBtn)
			else
				disable(windowObj.Topbar.MaxBtn)
			end

			if window.allowUserClose then
				enable(windowObj.Topbar.CloseBtn)
			else
				disable(windowObj.Topbar.CloseBtn)
			end
		end
	end)

	coroutine.resume(updateBtns)
	windowObj.Destroying:Once(function()
		coroutine.close(updateBtns)
	end)

	-- resizing stuff
	windowObj.Scaling.CornerScalePoint.CornerScale.DragContinue:Connect(function(inputPos: Vector2)
		if window.allowResizing then
			local sc = UDim2.fromOffset(inputPos.X - windowObj.Position.X.Offset, inputPos.Y - windowObj.Position.Y.Offset)
			window.Resize(sc)
		end
	end)

	windowObj.Scaling.XScale.Scaler.DragContinue:Connect(function(inputPos: Vector2)
		if window.allowResizing then
			local sc = UDim2.fromOffset(inputPos.X - windowObj.Position.X.Offset, windowObj.Size.Y.Offset)
			window.Resize(sc)
		end
	end)

	windowObj.Scaling.YScale.Scaler.DragContinue:Connect(function(inputPos: Vector2)
		if window.allowResizing then
			local sc = UDim2.fromOffset(windowObj.Size.X.Offset, inputPos.Y - windowObj.Position.Y.Offset)
			window.Resize(sc)
		end
	end)

	window.CreateToolbar = function(name: string): nil
		if name:gsub(" ", "") == "" then -- invalid
			return
		end

		local toolbar = CreateLithiumMenuToolbar(name)

		local MenuButton = CreateWMAssets.MenuButton()
		MenuButton.Name = name
		MenuButton.Text = name
		MenuButton.ItemsHolder.Size = UDim2.fromOffset(250, 0)
		MenuButton.Parent = windowObj.Topbar.MenuButtons

		local TextSize: Vector2 = TextService:GetTextSize(MenuButton.Text, MenuButton.TextSize, MenuButton.Font, MenuButton.AbsoluteSize)
		MenuButton.Size = UDim2.fromOffset(TextSize.X + 20, 30)

		if window.toolbars == nil then
			window.toolbars = {}
		end		

		table.insert(window.toolbars, toolbar)

		toolbar.associatedFrame = MenuButton.ItemsHolder

		MenuButton.MouseButton1Click:Connect(function()
			-- close the other menu button things
			if not MenuButton.ItemsHolder.Visible then
				for _, p: LithiumMenuToolbar in window.toolbars do
					p.associatedFrame.Visible = false
				end

				MenuButton.ItemsHolder.Visible = true
			else
				MenuButton.ItemsHolder.Visible = false
			end
		end)

		return toolbar
	end

	window.SetContent = function(f: Frame)
		f.Parent = windowObj.Content
		return f
	end

	windowObj.Topbar.WindowTitle.Text = window.title

	local ts = TextService:GetTextSize(window.title, windowObj.Topbar.WindowTitle.TextSize, Enum.Font.Roboto, windowObj.Topbar.AbsoluteSize)
	local tsXsize = ts.X + 15

	windowObj.Topbar.WindowTitle.Size = UDim2.fromOffset(tsXsize, 30)
	windowObj.Topbar.MenuButtons.Position = UDim2.fromOffset(tsXsize, 0)
	windowObj.Topbar.MenuButtons.Size = UDim2.new(1, -(tsXsize + 90), 0, 30)

	windowObj.Size = initWindowSize or UDim2.fromOffset(400, 300)

	windowObj.Topbar.MinBtn.MouseButton1Click:Connect(window.Minimize)
	windowObj.Topbar.MaxBtn.MouseButton1Click:Connect(window.Maximize)
	windowObj.Topbar.CloseBtn.MouseButton1Click:Connect(window.Close)

	windowObj.Parent = script.Parent

	return window
end

return LithiumWM
