local MODVERSION = Ext.Mod.GetMod(ModuleUUID).Info.ModVersion

if MODVERSION == nil then
    BPMPrint(0, "Better Photo Mode loaded (version unknown)")
else
    table.remove(MODVERSION)
    local versionNumber = table.concat(MODVERSION, ".")
    BPMPrint(0, "Better Photo Mode (server) version " .. versionNumber .. " loaded")
end

Ext.ModEvents.BG3MCM["MCM_Setting_Saved"]:Subscribe(function(payload)
    if not payload or payload.modUUID ~= ModuleUUID then
        return
    end

    -- If mod_enabled setting changes
    if payload.settingId == "mod_enabled" then
        BPM.PhotoCamera.ApplyCameraSettings()
    end

    -- Update camera settings on relevant changes
    if payload.settingId == "camera_floor_distance" or
        payload.settingId == "camera_lookat_smoothing" or
        payload.settingId == "camera_movement_speed" or
        payload.settingId == "camera_rotation_speed" or
        payload.settingId == "camera_range" then
        BPM.PhotoCamera.ApplyCameraSettings()
    end
end)
