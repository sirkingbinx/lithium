# Lithium
Lithium is a suite of tools for Roblox game development. It includes: 
- debuggers and log viewers that can suggest fixes for misspelling or common syntax errors
- many types of prompts and configurable gadgets to tweak values during runtime
- inspectors for module scripts

## Table of Contents
- [Projects](#projects)
- [Tools](#tools)
    - [Pentium Ion](#pentium-ion)
    - [Log](#log)

## Projects
Lithium is actually seperated into two projects, which you can see below:
- **Lithium**: The set of tools you see during the game. This manages all of the tools.
- **LithiumWM**: LithiumWM handles GUI creation, including toolbars (`File`, `Edit`, etc.), resizing and repositioning, minimizing / maximizing, and other window events. You can implement this in your own projects without having to modify Lithium itself.

## Tools
### Pentium Ion
**Pentium Ion** is a newer version of the [Pentium](https://github.com/sirkingbinx/Pentium) editor ported to Lithium. Pentium allows you to code Luau scripts while in-game with syntax highlighting, IntelliSense (autocomplete in paths), and line numbers.

### Log
A basic Log viewing utility, with some more special features:
- It may suggest fixes if the error is a common mistake, like a misspelling of a type.
- It assigns errors to icons, making it much easier to scroll through your log.
- It provides metrics for the number of each message type (message, warning, errors).
