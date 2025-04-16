BPMPrinter = Printer:New { Prefix = "Better Photo Mode", ApplyColor = true, DebugLevel = MCM.Get("debug_level") }

-- Update the Printer debug level when the setting is changed, since the value is only used during the object's creation
Ext.ModEvents.BG3MCM['MCM_Setting_Saved']:Subscribe(function(payload)
    if not payload or payload.modUUID ~= ModuleUUID or not payload.settingId then
        return
    end

    if payload.settingId == "debug_level" then
        BPMDebug(0, "Setting debug level to " .. payload.value)
        BPMPrinter.DebugLevel = payload.value
    end
end)

function BPMPrint(debugLevel, ...)
    BPMPrinter:SetFontColor(0, 255, 255)
    BPMPrinter:Print(debugLevel, ...)
end

function BPMTest(debugLevel, ...)
    BPMPrinter:SetFontColor(100, 200, 150)
    BPMPrinter:PrintTest(debugLevel, ...)
end

function BPMDebug(debugLevel, ...)
    BPMPrinter:SetFontColor(200, 200, 0)
    BPMPrinter:PrintDebug(debugLevel, ...)
end

function BPMWarn(debugLevel, ...)
    BPMPrinter:SetFontColor(255, 100, 50)
    BPMPrinter:PrintWarning(debugLevel, ...)
end

function BPMDump(debugLevel, ...)
    BPMPrinter:SetFontColor(190, 150, 225)
    BPMPrinter:Dump(debugLevel, ...)
end

function BPMDumpArray(debugLevel, ...)
    BPMPrinter:DumpArray(debugLevel, ...)
end
