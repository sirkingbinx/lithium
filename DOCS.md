# Docs

## Table of Contents
- [LithiumWM](#lithiumwm)
    - [Overview](#lithiumwm-overview)
    - [Types](#lithiumwm-types)
        - [LithiumButton](#lithiumwm-types-lithiumbutton)
        - [LithiumMenuToolbar](#lithiumwm-types-lithiummenutoolbar)
        - [LithiumWindow](#lithiumwm-types-lithiumwindow)
    - [Usage](#lithiumwm-usage)

<h2 id="lithiumwm">LithiumWM</h2>
<h3 id="lithiumwm-overview">Overview</h3>
LithiumWM is the window manager used throughout Lithium to manage displaying and moving all of the windows around. It supports:

- Resizing
- Minimizing (tabs) / Maximizing
- Ordering (through Z-Index)
- Toolbars (eg. `File`, `Edit`)

<h3 id="lithiumwm-types">Types</h3>
<h4 id="lithiumwm-types-lithiumbutton">LithiumButton</h4>

LithiumButton is the controller for toolbar buttons (such as `File` and `Edit`). It allows you to reroute your button's click action to other functions without checking statements inside of the function by setting the `onClick` method to whatever you want.

<h4 id="lithiumwm-types-lithiummenutoolbar">LithiumMenuToolbar</h4>

This type controls the toolbar functionality like the `File` and `Edit` menus, allowing you to add more functionalty without the thought of UI design. You can see this used in most of the default Lithium apps.

<h4 id="lithiumwm-types-lithiumwindow">LithiumWindow</h4>

LithiumWindow is the object that represents your entire window. It is assigned to you when calling `LithiumWM.CreateWindow()` and is used by LithiumWM to manage minimizing, maximizing, resizing, displaying content, and most other functionality, so don't lose it.

<h3 id="lithiumwm-usage">Usage</h3>

Create a window that has a "Hello world":
```lua
local LithiumWM = require(script.LithiumWM)
local HelloWindow = LithiumWM.CreateWindow("Hello", false) -- disable opening the window by default upon creation

local Hello = Instance.new("TextLabel")
Hello.Name = "hello_world"
Hello.Text = "Hello world"

HelloWindow.SetContent(Hello)
HelloWindow.Open()
```

Detect when the window is closed:

```lua
-- Note: this is a continuation of the last sample code

HelloWorld.onClose:Connect(function()
    print("Bye!")
end)
```