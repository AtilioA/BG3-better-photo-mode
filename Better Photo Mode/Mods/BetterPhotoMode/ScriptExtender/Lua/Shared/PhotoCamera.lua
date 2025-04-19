-- PhotoCamera module for Better Photo Mode
BPM.PhotoCamera = {}

-- Variables to track key states
BPM.PhotoCamera.FastModeActive = false
BPM.PhotoCamera.SlowModeActive = false

-- Apply camera settings from MCM to the game
-- @param settingId (optional) Specific setting to apply, or nil to apply all settings
function BPM.PhotoCamera.ApplyCameraSettings(settingId)
    -- Check if mod is enabled
    if MCM.Get("mod_enabled") then
        BPMPrint(1, "Applying camera settings from MCM" .. (settingId and (": " .. settingId) or ""))

        local statsManager = Ext.Stats.GetStatsManager()

        -- Apply floor distance setting if requested or applying all
        if settingId == nil or settingId == "camera_floor_distance" then
            statsManager.ExtraData.PhotoModeCameraFloorDistance = MCM.Get("camera_floor_distance")
            BPMPrint(2, "Applied floor distance: " .. tostring(MCM.Get("camera_floor_distance")))
        end

        -- Apply look-at smoothing setting if requested or applying all
        if settingId == nil or settingId == "camera_lookat_smoothing" then
            statsManager.ExtraData.PhotoModeCameraLookAtSmoothing = MCM.Get("camera_lookat_smoothing")
            BPMPrint(2, "Applied look-at smoothing: " .. tostring(MCM.Get("camera_lookat_smoothing")))
        end

        -- Apply rotation speed setting if requested or applying all
        if settingId == nil or settingId == "camera_rotation_speed" then
            statsManager.ExtraData.PhotoModeCameraRotationSpeed = MCM.Get("camera_rotation_speed")
            BPMPrint(2, "Applied rotation speed: " .. tostring(MCM.Get("camera_rotation_speed")))
        end

        -- Apply camera movement speed if needed
        if settingId == nil or
            settingId == "camera_movement_speed" or
            settingId == "fast_mode_speed" or
            settingId == "slow_mode_speed" then
            -- Only update the movement speed if we need to
            local currentSpeed = BPM.PhotoCamera.GetCurrentSpeedSetting()
            statsManager.ExtraData.PhotoModeCameraMovementSpeed = currentSpeed
            BPMPrint(2, "Applied movement speed: " .. tostring(currentSpeed))
        end

        -- Apply camera range if needed
        if settingId == nil or
            settingId == "unlimited_camera_range" or
            settingId == "camera_range" then
            BPM.CameraRange.ApplyRange()
            BPMPrint(2, "Applied camera range: " .. tostring(BPM.CameraRange.GetEffectiveRange()))
        end
    else
        BPM.PhotoCamera.ApplyDefaultSettings()
    end
end

-- Get the current speed setting based on active mode
function BPM.PhotoCamera.GetCurrentSpeedSetting()
    if BPM.PhotoCamera.FastModeActive then
        return MCM.Get("fast_mode_speed")
    elseif BPM.PhotoCamera.SlowModeActive then
        return MCM.Get("slow_mode_speed")
    else
        return MCM.Get("camera_movement_speed")
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

-- Toggle fast camera mode
function BPM.PhotoCamera.ToggleFastMode()
    -- Only proceed if mod is enabled
    if not MCM.Get("mod_enabled") then
        return
    end

    -- If slow mode is active, deactivate it first
    if BPM.PhotoCamera.SlowModeActive then
        BPMPrint(1, "Deactivating slow mode before toggling fast mode")
        BPM.PhotoCamera.SlowModeActive = false
    end

    -- Toggle fast mode
    BPM.PhotoCamera.FastModeActive = not BPM.PhotoCamera.FastModeActive
    BPMPrint(1, BPM.PhotoCamera.FastModeActive and "Fast mode activated" or "Fast mode deactivated")

    -- Apply only the movement speed setting to reflect the new mode
    BPM.PhotoCamera.ApplyCameraSettings("camera_movement_speed")
end

-- Toggle slow camera mode
function BPM.PhotoCamera.ToggleSlowMode()
    -- Only proceed if mod is enabled
    if not MCM.Get("mod_enabled") then
        return
    end

    -- If fast mode is active, deactivate it first
    if BPM.PhotoCamera.FastModeActive then
        BPMPrint(1, "Deactivating fast mode before toggling slow mode")
        BPM.PhotoCamera.FastModeActive = false
    end

    -- Toggle slow mode
    BPM.PhotoCamera.SlowModeActive = not BPM.PhotoCamera.SlowModeActive
    BPMPrint(1, BPM.PhotoCamera.SlowModeActive and "Slow mode activated" or "Slow mode deactivated")

    -- Apply only the movement speed setting to reflect the new mode
    BPM.PhotoCamera.ApplyCameraSettings("camera_movement_speed")
end

-- Initialize the PhotoCamera module
function BPM.PhotoCamera.Initialize()
    -- Register for StatsLoaded event to set initial values
    Ext.Events.StatsLoaded:Subscribe(function()
        -- When initializing, apply all settings at once
        BPM.PhotoCamera.ApplyCameraSettings()
    end)
end
