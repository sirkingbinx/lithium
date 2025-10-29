--// Title: LithiumCore.luau
--// Description: Regular lithium stuff used for all applications
--// Author: SirKingBinx
--// For more information including licensing details, see https://github.com/sirkingbinx/lithium

local Lithium = {}
Lithium.WM = require(script.Parent.LithiumWM)

Lithium.Version = {
    Version = "1.0",
    Codename = "Parrot",
    HumanName = "Lithium 1.0 (Parrot)",
    LicenseText = "(C) Copyright 2024 - 2026 SirKingBinx. MIT License",
    GitRepository = "https://github.com/sirkingbinx/Lithium"
}

return function()
    -- init function
    setmetatable(Lithium.Version, {
        __tostring = function()
            return string.format("Lithium %s (%s)\n%s\nGit: %s", Lithium.Version.Version, Lithium.Version.Codename, Lithium.Version.Copyright, Lithium.Version.GitRepository)
        end,

        __equ = function(t1, t2)
            return t1.Version == t2.Version
        end,
    })

    print(tostring(Lithium.Version))

    return Lithium
end