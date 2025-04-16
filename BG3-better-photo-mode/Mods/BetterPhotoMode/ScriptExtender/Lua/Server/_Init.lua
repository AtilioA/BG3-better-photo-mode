-- Initialize BPM server
BPMPrint(0, "Initializing BPM Server")

local MODVERSION = Ext.Mod.GetMod(ModuleUUID).Info.ModVersion

if MODVERSION == nil then
    BPMPrint(0, "Better Photo Mode loaded (version unknown)")
else
    table.remove(MODVERSION)
    local versionNumber = table.concat(MODVERSION, ".")
    BPMPrint(0, "Better Photo Mode (server) version " .. versionNumber .. " loaded")
end
