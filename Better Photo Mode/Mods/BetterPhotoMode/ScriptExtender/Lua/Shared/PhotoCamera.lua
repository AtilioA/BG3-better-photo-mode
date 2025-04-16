-- PhotoCamera module for Better Photo Mode
BPM.PhotoCamera = {}

-- Variables to track key states
BPM.PhotoCamera.FastModeActive = false
BPM.PhotoCamera.SlowModeActive = false
BPM.PhotoCamera.OriginalMovementSpeed = nil

-- Apply camera settings from MCM to the game
function BPM.PhotoCamera.ApplyCameraSettings()
    local settings = MCM.GetMod("Better Photo Mode").GetSettings()
    local statsManager = Ext.Stats.GetStatsManager()

    -- Check if mod is enabled
    if settings.mod_enabled then
        BPMPrint(1, "Applying camera settings from MCM")

        -- Apply settings
        statsManager.ExtraData.PhotoModeCameraFloorDistance = settings.camera_floor_distance
        statsManager.ExtraData.PhotoModeCameraLookAtSmoothing = settings.camera_lookat_smoothing
        statsManager.ExtraData.PhotoModeCameraMovementSpeed = settings.camera_movement_speed
        statsManager.ExtraData.PhotoModeCameraRotationSpeed = settings.camera_rotation_speed
        statsManager.ExtraData.PhotoModeCameraRange = settings.camera_range

        BPMPrint(2, "Applied camera settings: " ..
            "Floor Distance=" .. tostring(settings.camera_floor_distance) ..
            ", Look-At Smoothing=" .. tostring(settings.camera_lookat_smoothing) ..
            ", Movement Speed=" .. tostring(settings.camera_movement_speed) ..
            ", Rotation Speed=" .. tostring(settings.camera_rotation_speed) ..
            ", Range=" .. tostring(settings.camera_range))
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
    statsManager.ExtraData.PhotoModeCameraRange = defaults.PhotoModeCameraRange

    BPMPrint(2, "Applied default camera settings")
end

-- Toggle fast camera mode (when Shift is pressed)
function BPM.PhotoCamera.ToggleFastMode()
    local settings = MCM.GetMod("Better Photo Mode").GetSettings()
    local statsManager = Ext.Stats.GetStatsManager()

    -- Only proceed if mod is enabled
    if not settings.mod_enabled then
        return
    end

    -- Toggle fast mode
    BPM.PhotoCamera.FastModeActive = not BPM.PhotoCamera.FastModeActive

    if BPM.PhotoCamera.FastModeActive then
        -- Store original speed and apply fast mode
        BPM.PhotoCamera.OriginalMovementSpeed = statsManager.ExtraData.PhotoModeCameraMovementSpeed
        statsManager.ExtraData.PhotoModeCameraMovementSpeed = settings.fast_mode_speed
        BPMPrint(1, "Fast mode activated. Speed: " .. statsManager.ExtraData.PhotoModeCameraMovementSpeed)
    else
        -- Restore original speed
        if BPM.PhotoCamera.OriginalMovementSpeed then
            statsManager.ExtraData.PhotoModeCameraMovementSpeed = BPM.PhotoCamera.OriginalMovementSpeed
            BPM.PhotoCamera.OriginalMovementSpeed = nil
            BPMPrint(1,
                "Fast mode deactivated. Speed restored to: " .. statsManager.ExtraData.PhotoModeCameraMovementSpeed)
        end
    end
end

-- Toggle slow camera mode (when Ctrl is pressed)
function BPM.PhotoCamera.ToggleSlowMode()
    local settings = MCM.GetMod("Better Photo Mode").GetSettings()
    local statsManager = Ext.Stats.GetStatsManager()

    -- Only proceed if mod is enabled
    if not settings.mod_enabled then
        return
    end

    -- Toggle slow mode
    BPM.PhotoCamera.SlowModeActive = not BPM.PhotoCamera.SlowModeActive

    if BPM.PhotoCamera.SlowModeActive then
        -- Store original speed and apply slow mode
        BPM.PhotoCamera.OriginalMovementSpeed = statsManager.ExtraData.PhotoModeCameraMovementSpeed
        statsManager.ExtraData.PhotoModeCameraMovementSpeed = settings.slow_mode_speed
        BPMPrint(1, "Slow mode activated. Speed: " .. statsManager.ExtraData.PhotoModeCameraMovementSpeed)
    else
        -- Restore original speed
        if BPM.PhotoCamera.OriginalMovementSpeed then
            statsManager.ExtraData.PhotoModeCameraMovementSpeed = BPM.PhotoCamera.OriginalMovementSpeed
            BPM.PhotoCamera.OriginalMovementSpeed = nil
            BPMPrint(1,
                "Slow mode deactivated. Speed restored to: " .. statsManager.ExtraData.PhotoModeCameraMovementSpeed)
        end
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
