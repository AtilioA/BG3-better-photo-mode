-- Create BPM table
Mods = Mods or {}
Mods.BetterPhotoMode = {}
BPM = Mods.BetterPhotoMode

-- BPM constants
BPM.Constants = {
    DefaultValues = {
        PhotoModeCameraFloorDistance = 0.050000000745058,
        PhotoModeCameraLookAtSmoothing = 20.0,
        PhotoModeCameraMovementSpeed = 6.0,
        PhotoModeCameraRange = 25.0,
        PhotoModeCameraRotationSpeed = 1.2000000476837
    }
}

-- Print function for BPM
function BPMPrint(level, message)
    local debugLevel = MCM.GetMod("Better Photo Mode").GetSettings().debug_level

    if level <= debugLevel then
        Ext.Utils.Print("[BPM] " .. message)
    end
end

-- Load the PhotoCamera module
Ext.Require("Shared/PhotoCamera.lua")
