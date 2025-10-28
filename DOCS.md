# Docs

## Table of Contents
- [LithiumWM](#lithiumwm)
    - [Overview](#lithiumwm-overview)
    - [Types](#lithiumwm-types)
        - [LithiumButton](#lithiumwm-types-lithiumbutton)
        - [LithiumMenuToolbar](#lithiumwm-types-lithiummenutoolbar)
        - [LithiumWindow](#lithiumwm-types-lithiumwindow)
    - [Implementation Details](#lithiumwm-implementation_details)
    - [Usage](#lithiumwm-usage)
- [Log](#log)
    - [Overview](#log-overview)
    - [Error Inspector](#log-error_inspector)

- [Documentation Links](#documentation_links)

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

<h3 id="lithiumwm-implementation_details">Implementation Details</h3>

<h4 id="lithiumwm-implementation_details-ui">UI</h4>

Any UI elements included in LithiumWM are converted into code using the `Gui2Lua` plugin to make the script a simple drag and drop implementation.

To generate the UI, edit the `.Parent` property of the generated object to where you want the UI to be created, then paste the code into your console (most commonly placed at the very bottom of your studio tab), and run the code.

<h4 id="lithiumwm-implementation_details-lithiumscriptsignal">LithiumScriptSignal</h4>

LithiumScriptSignal is a loose replica of [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal) used in event-like functions in LithiumWM.

It's most commonly used in `LithiumWindow` where we use it to create `onOpen`, `onMinimize` and `onMaximize`.

LithiumScriptSignal, unlike RBXScriptSignal, does not support returning arguments, so in those cases we just use `function` type syntax to let the user know we expect a return type. Here is an example with the `onClose` function:

```lua
-- This is placed in the LithiumWindow type
onClose: () -> (boolean),

-- And the user can define this
myWindow.onClose = function()
    return true -- let the window close (return false to keep it open)
end,
```

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

HelloWorld.onClose = function()
    -- Functions that return arguments cannot use LithiumScriptSignal, so just assign a single function for them
    local allowToClose = true
    return allowToClose -- return false to cancel the close
end
```

<h2 id="log">Log</h2>

<h3 id="log-overview">Overview</h3>

The log displays logs from the console very nicely, assigning icons and other details to each error, which you can see by just clicking it.

It includes a message counter, an [error inspector](#log-error_inspector), and allows you to clear the console when you're done.

<h3 id="log-error_inspector">Error Inspector</h3>

The error inspector's job is to:
- show error information nicely and helpfully
- de-clutter the log itself so only real messages are presented there
- try to help fix the error if it can detect the problem.

You can open the error inspector by clicking on an error message in the Log.

<h2 id="documentation_links">Documentation Links</h2>
The docs make it easy to create a hyperlink for a certain section without checking the docs yourself.

To link the documentation for `Log` where it shows the `Overview`, you can append this to the URL:
```
#log-overview
```
For a subpage (eg. `Overview` or `Types`) of a certain section, seperate the section name and subpage with a dash `-`, as well as any subpages following that.

```
#section-bigsubpage-littlesubpage
```

For names with spaces like the `Error Inspector`, use underscores to replace the spaces.
```
#log-error_inspector
```