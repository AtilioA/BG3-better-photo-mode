-- Listen for settings changes using ModEvents (modern approach)
Ext.Events.SessionLoaded:Subscribe(function()
    Ext.ModEvents.BG3MCM["MCM_Setting_Saved"]:Subscribe(BPM.HandleSettingChange)
end)

-- Register keybinding callbacks for fast and slow modes
MCM.SetKeybindingCallback("key_fast_mode", function()
    if MCM.Get("mod_enabled") then
        BPM.PhotoCamera.ToggleFastMode()
    end
end)

MCM.SetKeybindingCallback("key_slow_mode", function()
    if MCM.Get("mod_enabled") then
        BPM.PhotoCamera.ToggleSlowMode()
    end
end)

-- Initialize PhotoCamera module
BPM.PhotoCamera.Initialize()
