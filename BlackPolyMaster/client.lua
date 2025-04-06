local isPzMode = false
local lastCoords = nil
local isPolyMode = false
local polyPoints = {}

RegisterCommand("pz", function()
    isPzMode = not isPzMode
    SetNuiFocus(isPzMode, isPzMode)

    if isPzMode then
        updateTextUI()
    else
        lib.hideTextUI()
    end

    lib.notify({
        title = "PZ Mode",
        description = isPzMode and "✅ Activated - Use mouse + hotkeys" or "❌ Deactivated",
        type = isPzMode and "success" or "error"
    })
end)

function updateTextUI()
    if not isPzMode then return end

    if isPolyMode then
        lib.showTextUI('[Z] Add Point | [G] Undo Last Point | [L] Exit Poly Mode | [E] Save PolyZone', {
            position = "left-center",
            icon = 'map-pin',
            style = {
                borderRadius = 8,
                backgroundColor = '#000000cc',
                color = 'white'
            }
        })
    else
        lib.showTextUI('[G] Copy vec4 | [Z] Copy vec3 | [E] Save Point | [L] Enter Poly Mode', {
            position = "left-center",
            icon = 'hand-pointer',
            style = {
                borderRadius = 8,
                backgroundColor = '#000000cc',
                color = 'white'
            }
        })
    end
end

function RotationToDirection(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

function RayCastFromScreen()
    local camRot = GetGameplayCamRot(2)
    local camPos = GetGameplayCamCoord()
    local dir = RotationToDirection(camRot)
    local dist = 1000.0
    local dest = camPos + dir * dist

    local ray = StartShapeTestRay(camPos.x, camPos.y, camPos.z, dest.x, dest.y, dest.z, -1, -1, 1)
    local _, hit, coords = GetShapeTestResult(ray)
    return hit, coords
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if isPzMode then
            local hit, coords = RayCastFromScreen()
            if hit then
                lastCoords = coords

                DrawMarker(28, coords.x, coords.y, coords.z + 0.05, 0, 0, 0, 0, 0, 0,
                    0.1, 0.1, 0.1, 255, 255, 255, 120, false, true, 2, nil, nil, false)

                local ped = PlayerPedId()
                local pedCoords = GetEntityCoords(ped)
                local pedMidZ = pedCoords.z + 0.3

                DrawLine(pedCoords.x, pedCoords.y, pedMidZ, coords.x, coords.y, coords.z, 255, 255, 255, 120)
            end

            -- G: Copy vec4 or Undo Poly Point
            if IsControlJustPressed(0, 47) then -- G
                if isPolyMode then
                    if #polyPoints > 0 then
                        local removed = table.remove(polyPoints)
                        lib.notify({
                            title = "↩️ Point Undone",
                            description = string.format("Removed: vector3(%.2f, %.2f, %.2f)", removed.x, removed.y, removed.z),
                            type = "inform"
                        })
                    else
                        lib.notify({
                            title = "⚠️ No Points to Undo",
                            type = "error"
                        })
                    end
                elseif lastCoords then
                    local heading = GetEntityHeading(PlayerPedId())
                    local vec4Text = string.format("vector4(%.2f, %.2f, %.2f, %.2f)",
                        lastCoords.x, lastCoords.y, lastCoords.z, heading)
                    lib.setClipboard(vec4Text)
                    lib.notify({ title = "✅ vec4 Copied", description = vec4Text, type = "inform" })
                    print("[PZ] vec4 copied:", vec4Text)
                end
            end

            -- Z: Copy vec3 or Add Poly Point
            if IsControlJustPressed(0, 20) and lastCoords then
                if isPolyMode then
                    table.insert(polyPoints, vector3(lastCoords.x, lastCoords.y, lastCoords.z))
                    lib.notify({
                        title = "📍 Poly Point Added",
                        description = string.format("vector3(%.2f, %.2f, %.2f)", lastCoords.x, lastCoords.y, lastCoords.z),
                        type = "inform"
                    })
                else
                    local vec3Text = string.format("vector3(%.2f, %.2f, %.2f)", lastCoords.x, lastCoords.y, lastCoords.z)
                    lib.setClipboard(vec3Text)
                    lib.notify({ title = "📌 vec3 Copied", description = vec3Text, type = "inform" })
                    print("[PZ] vec3 copied:", vec3Text)
                end
            end

            -- E: Save Point or Save PolyZone
            if IsControlJustPressed(0, 38) and lastCoords then
                local heading = GetEntityHeading(PlayerPedId())

                if isPolyMode then
                    if #polyPoints < 4 then
                        lib.notify({
                            title = "⚠️ Not Enough Points",
                            description = "You need at least 4 points to create a PolyZone",
                            type = "error"
                        })
                    else
                        local minZ, maxZ = polyPoints[1].z, polyPoints[1].z
                        for _, pt in pairs(polyPoints) do
                            if pt.z < minZ then minZ = pt.z end
                            if pt.z > maxZ then maxZ = pt.z end
                        end
                        minZ = minZ - 1.0
                        maxZ = maxZ + 1.0

                        TriggerServerEvent("pz:savePolyZone", {
                            name = "poly_zone_" .. tostring(math.random(1000, 9999)),
                            points = polyPoints,
                            minZ = minZ,
                            maxZ = maxZ
                        })

                        lib.notify({
                            title = "✅ PolyZone Saved",
                            description = "Saved to list.lua",
                            type = "success"
                        })

                        polyPoints = {}
                    end
                else
                    local data = {
                        name = "default_point",
                        vec4 = vector4(lastCoords.x, lastCoords.y, lastCoords.z, heading),
                        vec3 = vector3(lastCoords.x, lastCoords.y, lastCoords.z),
                        vec2 = vector2(lastCoords.x, lastCoords.y),
                        heading = heading,
                        minZ = lastCoords.z - 1.0,
                        maxZ = lastCoords.z + 1.0
                    }

                    TriggerServerEvent("pz:saveToList", data)

                    lib.notify({
                        title = "📌 Point Saved",
                        description = "Saved to list.lua",
                        type = "success"
                    })
                end
            end

            -- L: Toggle Poly Mode
            if IsControlJustPressed(0, 182) then -- L
                isPolyMode = not isPolyMode
                polyPoints = {}
                updateTextUI()

                lib.notify({
                    title = "PolyZone Mode",
                    description = isPolyMode and "✅ Enabled - Z to Add / E to Save" or "❌ Disabled",
                    type = isPolyMode and "success" or "inform"
                })
            end

            -- Visualize Poly Points
            if isPolyMode and #polyPoints > 0 then
                for i = 1, #polyPoints do
                    local point = polyPoints[i]
                    DrawMarker(28, point.x, point.y, point.z + 0.05,
                        0, 0, 0, 0, 0, 0,
                        0.15, 0.15, 0.15,
                        0, 255, 255, 180, false, true, 2, nil, nil, false)

                    if i > 1 then
                        local prev = polyPoints[i - 1]
                        DrawLine(prev.x, prev.y, prev.z + 0.05, point.x, point.y, point.z + 0.05, 0, 255, 255, 180)
                    end
                end

                -- Connect first and last
                if #polyPoints >= 3 then
                    local first = polyPoints[1]
                    local last = polyPoints[#polyPoints]
                    DrawLine(last.x, last.y, last.z + 0.05, first.x, first.y, first.z + 0.05, 255, 0, 0, 180)
                end
            end
        else
            Wait(200)
        end
    end
end)

lib.hideTextUI()
