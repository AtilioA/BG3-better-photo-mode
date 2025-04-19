BPM = BPM or {}

-- BPM constants
BPM.Constants = {
    DefaultValues = {
        PhotoModeCameraFloorDistance = 0.050000000745058,
        PhotoModeCameraLookAtSmoothing = 20.0,
        PhotoModeCameraMovementSpeed = 6.0,
        PhotoModeCameraRange = 25.0,
        PhotoModeCameraRotationSpeed = 1.2000000476837
    }
}

---Ext.Require files at the path
---@param path string
---@param files string[]
function RequireFiles(path, files)
    for _, file in pairs(files) do
        Ext.Require(string.format("%s%s.lua", path, file))
    end
end

RequireFiles("Shared/", {
    "MCMHandler",
    "Helpers/_Init",
    "CameraRange",
    "PhotoCamera",
})
