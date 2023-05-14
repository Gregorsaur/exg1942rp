PLUGIN.name = "No vehicle sit"
PLUGIN.desc = "Disallow sitting on vehicle"
PLUGIN.author = "Barata"

hook.Add("CheckValidSit", "noVehSit", function(ply, trace)
    local ent = trace.Entity
    if ent:IsVehicle() then return false end
end)