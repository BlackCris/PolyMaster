-- ✅ If you're using ESX/QB, the json module is built-in. Otherwise, comment this line out.
local json = require("json")

-- ✅ Save a single point (vector2/3/4)
RegisterServerEvent("pz:saveToList", function(data)
    local path = "data/list.lua"

    -- Load current list.lua content
    local raw = LoadResourceFile(GetCurrentResourceName(), path)
    local existingContent = ""

    if raw and raw ~= "" then
        raw = raw:gsub("return%s*{", ""):gsub("}%s*$", "")
        existingContent = raw .. ",\n"
    end

    -- Format point entry
    local pointText = string.format([[
    {
        type = "point",
        name = "%s",
        vec4 = vector4(%.2f, %.2f, %.2f, %.2f),
        vec3 = vector3(%.2f, %.2f, %.2f),
        vec2 = vector2(%.2f, %.2f),
        heading = %.2f,
        minZ = %.2f,
        maxZ = %.2f
    }]],
        data.name or "default_point",
        data.vec4.x, data.vec4.y, data.vec4.z, data.vec4.w,
        data.vec3.x, data.vec3.y, data.vec3.z,
        data.vec2.x, data.vec2.y,
        data.heading,
        data.minZ,
        data.maxZ
    )

    -- Combine and save final result
    local final = "return {\n" .. existingContent .. pointText .. "\n}"
    SaveResourceFile(GetCurrentResourceName(), path, final, -1)
    print("[PZ] ✅ Point saved to list.lua")
end)

-- ✅ Save PolyZone (vector3 points + minZ/maxZ)
RegisterServerEvent("pz:savePolyZone", function(data)
    local path = "data/list.lua"

    -- Load current list.lua content
    local raw = LoadResourceFile(GetCurrentResourceName(), path)
    local existingContent = ""

    if raw and raw ~= "" then
        raw = raw:gsub("return%s*{", ""):gsub("}%s*$", "")
        existingContent = raw .. ",\n"
    end

    -- Build PolyZone block
    local zoneText = string.format([[
    {
        type = "polyzone",
        name = "%s",
        minZ = %.2f,
        maxZ = %.2f,
        points = {
]], data.name or "polyzone", data.minZ, data.maxZ)

    for _, pt in ipairs(data.points) do
        zoneText = zoneText .. string.format("            vector3(%.2f, %.2f, %.2f),\n", pt.x, pt.y, pt.z)
    end

    zoneText = zoneText .. "        }\n    }"

    -- Combine and save final result
    local finalText = "return {\n" .. existingContent .. zoneText .. "\n}"
    SaveResourceFile(GetCurrentResourceName(), path, finalText, -1)
    print("[PZ] ✅ PolyZone saved to list.lua")
end)
