-- Camera Range module for Better Photo Mode
BPM.CameraRange = {}

-- Get the effective camera range based on settings
function BPM.CameraRange.GetEffectiveRange()
    -- Only proceed if mod is enabled
    if not MCM.Get("mod_enabled") then
        return BPM.Constants.DefaultValues.PhotoModeCameraRange
    end

    -- Check if unlimited range is enabled
    if MCM.Get("unlimited_camera_range") then
        BPMPrint(2, "Using unlimited camera range")
        return math.huge
    end

    -- Return the configured range
    local range = MCM.Get("camera_range")
    BPMPrint(2, "Using configured camera range: " .. tostring(range))
    return range
end

-- Apply the current camera range setting
function BPM.CameraRange.ApplyRange()
    local statsManager = Ext.Stats.GetStatsManager()
    local effectiveRange = BPM.CameraRange.GetEffectiveRange()

    statsManager.ExtraData.PhotoModeCameraRange = effectiveRange
    BPMPrint(1, "Applied camera range: " .. tostring(effectiveRange))
end
