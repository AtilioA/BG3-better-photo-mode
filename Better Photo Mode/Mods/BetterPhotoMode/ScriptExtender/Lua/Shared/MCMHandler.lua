BPM = BPM or {}
BPM.MCM = {}

local CAMERA_SETTINGS = {
    -- General settings
    "mod_enabled",

    -- Camera movement settings
    "camera_movement_speed",
    "camera_rotation_speed",
    "fast_mode_speed",
    "slow_mode_speed",

    -- Camera distance settings
    "unlimited_camera_range",
    "camera_range",
    "camera_floor_distance",

    -- Camera behavior settings
    "camera_lookat_smoothing"
}

function BPM.MCM.HandleSettingChange(payload)
    if not payload or payload.modUUID ~= ModuleUUID then
        return
    end

    -- Check if the changed setting is one of our camera settings
    for _, settingId in ipairs(CAMERA_SETTINGS) do
        if payload.settingId == settingId then
            -- Apply only the changed setting
            BPM.PhotoCamera.ApplyCameraSettings(payload.settingId)
            return
        end
    end
end
