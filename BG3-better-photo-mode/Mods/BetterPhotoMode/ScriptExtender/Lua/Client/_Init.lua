-- Initialize BPM client
BPMPrint(0, "Initializing BPM Client")

-- Create keybinding for Shift key (Fast Mode)
MCM.RegisterListener("Better Photo Mode", "settings_changed", function(mod, settings, changed)
    if changed.mod_enabled ~= nil then
        BPM.PhotoCamera.ApplyCameraSettings()
    end

    -- Update camera settings on any change
    if changed.camera_floor_distance ~= nil or
        changed.camera_lookat_smoothing ~= nil or
        changed.camera_movement_speed ~= nil or
        changed.camera_rotation_speed ~= nil or
        changed.camera_range ~= nil then
        BPM.PhotoCamera.ApplyCameraSettings()
    end
end)

-- Initialize PhotoCamera module
BPM.PhotoCamera.Initialize()

-- Handle key presses for fast and slow modes
Ext.RegisterListener("InputEvent", function(event)
    -- Only handle keydown events
    if event.EventType == 1 then -- KeyDown = 1
        local settings = MCM.GetMod("Better Photo Mode").GetSettings()

        -- Only proceed if mod is enabled
        if not settings.mod_enabled then
            return
        end

        -- Check for Shift key (fast mode)
        if event.InputType == 70 then               -- Left Shift = 70
            if Input.Keyboard.IsKeyPressed(70) then -- Verify it's actually pressed
                BPM.PhotoCamera.ToggleFastMode()
            end
        end

        -- Check for Ctrl key (slow mode)
        if event.InputType == 72 then               -- Left Control = 72
            if Input.Keyboard.IsKeyPressed(72) then -- Verify it's actually pressed
                BPM.PhotoCamera.ToggleSlowMode()
            end
        end
    end
end)

local MODVERSION = Ext.Mod.GetMod(ModuleUUID).Info.ModVersion

if MODVERSION == nil then
    BPMPrint(0, "Better Photo Mode loaded (version unknown)")
else
    table.remove(MODVERSION)
    local versionNumber = table.concat(MODVERSION, ".")
    BPMPrint(0, "Better Photo Mode (client) version " .. versionNumber .. " loaded")
end
