-- PhotoCamera module for Better Photo Mode
BPM.PhotoCamera = {}

-- Variables to track key states
BPM.PhotoCamera.FastModeActive = false
BPM.PhotoCamera.SlowModeActive = false
BPM.PhotoCamera.OriginalMovementSpeed = nil

-- Apply camera settings from MCM to the game
function BPM.PhotoCamera.ApplyCameraSettings()
    -- Check if mod is enabled
    if MCM.Get("mod_enabled") then
        BPMPrint(1, "Applying camera settings from MCM")

        local statsManager = Ext.Stats.GetStatsManager()

        -- Apply settings
        statsManager.ExtraData.PhotoModeCameraFloorDistance = MCM.Get("camera_floor_distance")
        statsManager.ExtraData.PhotoModeCameraLookAtSmoothing = MCM.Get("camera_lookat_smoothing")
        statsManager.ExtraData.PhotoModeCameraMovementSpeed = MCM.Get("camera_movement_speed")
        statsManager.ExtraData.PhotoModeCameraRotationSpeed = MCM.Get("camera_rotation_speed")

        -- Apply camera range using CameraRange module
        BPM.CameraRange.ApplyRange()

        BPMPrint(2, "Applied camera settings: " ..
            "Floor Distance=" .. tostring(MCM.Get("camera_floor_distance")) ..
            ", Look-At Smoothing=" .. tostring(MCM.Get("camera_lookat_smoothing")) ..
            ", Movement Speed=" .. tostring(MCM.Get("camera_movement_speed")) ..
            ", Rotation Speed=" .. tostring(MCM.Get("camera_rotation_speed")) ..
            ", Range=" .. tostring(BPM.CameraRange.GetEffectiveRange()))
    else
        BPM.PhotoCamera.ApplyDefaultSettings()
    end
end

-- Apply default settings
function BPM.PhotoCamera.ApplyDefaultSettings()
    local statsManager = Ext.Stats.GetStatsManager()
    local defaults = BPM.Constants.DefaultValues

    BPMPrint(1, "Applying default camera settings")

    -- Apply default settings
    statsManager.ExtraData.PhotoModeCameraFloorDistance = defaults.PhotoModeCameraFloorDistance
    statsManager.ExtraData.PhotoModeCameraLookAtSmoothing = defaults.PhotoModeCameraLookAtSmoothing
    statsManager.ExtraData.PhotoModeCameraMovementSpeed = defaults.PhotoModeCameraMovementSpeed
    statsManager.ExtraData.PhotoModeCameraRotationSpeed = defaults.PhotoModeCameraRotationSpeed

    -- Apply camera range using CameraRange module
    BPM.CameraRange.ApplyRange()

    BPMPrint(2, "Applied default camera settings")
end

-- Helper function to restore original movement speed
function BPM.PhotoCamera.RestoreOriginalSpeed()
    local statsManager = Ext.Stats.GetStatsManager()
    if BPM.PhotoCamera.OriginalMovementSpeed then
        statsManager.ExtraData.PhotoModeCameraMovementSpeed = BPM.PhotoCamera.OriginalMovementSpeed
        BPM.PhotoCamera.OriginalMovementSpeed = nil
        BPMPrint(2, "Restored original speed: " .. statsManager.ExtraData.PhotoModeCameraMovementSpeed)
    end
end

-- Toggle fast camera mode
function BPM.PhotoCamera.ToggleFastMode()
    -- Only proceed if mod is enabled
    if not MCM.Get("mod_enabled") then
        return
    end

    local statsManager = Ext.Stats.GetStatsManager()

    -- If slow mode is active, deactivate it first
    if BPM.PhotoCamera.SlowModeActive then
        BPMPrint(1, "Deactivating slow mode before toggling fast mode")
        BPM.PhotoCamera.SlowModeActive = false
        BPM.PhotoCamera.RestoreOriginalSpeed()
    end

    -- Toggle fast mode
    BPM.PhotoCamera.FastModeActive = not BPM.PhotoCamera.FastModeActive

    if BPM.PhotoCamera.FastModeActive then
        -- Store original speed and apply fast mode
        BPM.PhotoCamera.OriginalMovementSpeed = statsManager.ExtraData.PhotoModeCameraMovementSpeed
        statsManager.ExtraData.PhotoModeCameraMovementSpeed = MCM.Get("fast_mode_speed")
        BPMPrint(1, "Fast mode activated. Speed: " .. statsManager.ExtraData.PhotoModeCameraMovementSpeed)
    else
        -- Restore original speed
        BPM.PhotoCamera.RestoreOriginalSpeed()
        BPMPrint(1, "Fast mode deactivated.")
    end
end

-- Toggle slow camera mode
function BPM.PhotoCamera.ToggleSlowMode()
    -- Only proceed if mod is enabled
    if not MCM.Get("mod_enabled") then
        return
    end

    local statsManager = Ext.Stats.GetStatsManager()

    -- If fast mode is active, deactivate it first
    if BPM.PhotoCamera.FastModeActive then
        BPMPrint(1, "Deactivating fast mode before toggling slow mode")
        BPM.PhotoCamera.FastModeActive = false
        BPM.PhotoCamera.RestoreOriginalSpeed()
    end

    -- Toggle slow mode
    BPM.PhotoCamera.SlowModeActive = not BPM.PhotoCamera.SlowModeActive

    if BPM.PhotoCamera.SlowModeActive then
        -- Store original speed and apply slow mode
        BPM.PhotoCamera.OriginalMovementSpeed = statsManager.ExtraData.PhotoModeCameraMovementSpeed
        statsManager.ExtraData.PhotoModeCameraMovementSpeed = MCM.Get("slow_mode_speed")
        BPMPrint(1, "Slow mode activated. Speed: " .. statsManager.ExtraData.PhotoModeCameraMovementSpeed)
    else
        -- Restore original speed
        BPM.PhotoCamera.RestoreOriginalSpeed()
        BPMPrint(1, "Slow mode deactivated.")
    end
end

-- Initialize the PhotoCamera module
function BPM.PhotoCamera.Initialize()
    BPMPrint(0, "Initializing PhotoCamera module")

    -- Register for StatsLoaded event to set initial values
    Ext.Events.StatsLoaded:Subscribe(function()
        BPM.PhotoCamera.ApplyCameraSettings()
    end)
end
