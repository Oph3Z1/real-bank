Config.DrawText3D = function (msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function OpenBank()
    if Config.Drawtext == 'qb-target' then
        for _,v in pairs(Config.BankLocations) do
            exports['qb-target']:AddBoxZone("rbank" .. _, vector3(v.Coords.x, v.Coords.y, v.Coords.z), 1.5, 1.5, {
                name = "rbank" .. _,
                debugPoly = false,
                heading = -20,
                minZ = v.Coords.z - 2,
                maxZ = v.Coords.z + 2,
            }, {
                options = {
                    {
                        type = "client",
                        event = "real-bank:OpenNormalBank",
                        icon = "fas fa-hand-point-up",
                        label = "Open Bank",
                        
                    },
                },
                distance = 8
            })
        end

        Citizen.CreateThread(function()
            while true do
                local sleep = 2000
                local Player = PlayerPedId()
                local PlayerCoords = GetEntityCoords(Player)

                for k, v in pairs(Config.ATMs) do
                    local ATMEntity = GetClosestObjectOfType(PlayerCoords, 2.0, GetHashKey(v))
                    local GetATMCoords = GetEntityCoords(ATMEntity)
                    local DistanceToATMs = #(PlayerCoords - GetATMCoords)

                    if DistanceToATMs < 1.5 then
                        sleep = 4
                        exports['qb-target']:AddBoxZone("real-bankN" .. k, vector3(GetATMCoords.x, GetATMCoords.y, GetATMCoords.z), 1.5, 1.5, {
                            name = "real-bankN" .. k,
                            debugPoly = false,
                            heading = -20,
                            minZ = GetATMCoords.z - 2,
                            maxZ = GetATMCoords.z + 2,
                        }, {
                            options = {
                                {
                                    type = "client",
                                    event = "real-bank:OpenATMFunction",
                                    icon = "fas fa-hand-point-up",
                                    label = "Open Bank",
                                    
                                },
                            },
                            distance = 8
                        })
                    end
                end
                Citizen.Wait(sleep)
            end
        end)
    elseif Config.Drawtext == 'drawtext' then
        Citizen.CreateThread(function()
            while true do
                local sleep = 2000
                local Player = PlayerPedId()
                local PlayerCoords = GetEntityCoords(Player)
                
                for k, v in pairs(Config.ATMs) do
                    local ATMEntity = GetClosestObjectOfType(PlayerCoords, 2.0, GetHashKey(v))
                    local GetATMCoords = GetEntityCoords(ATMEntity)
                    local DistanceToATMs = #(PlayerCoords - GetATMCoords)

                    if DistanceToATMs < 1.5 then
                        sleep = 4
                        Config.DrawText3D("~INPUT_PICKUP~ - Open ATM", vector3(GetATMCoords.x, GetATMCoords.y, GetATMCoords.z + 1.0))
                        if IsControlJustReleased(0, 38) then
                            OpenATM()
                        end
                    end
                end

                for k, v in pairs(Config.BankLocations) do
                    local DistanceToBanks = #(PlayerCoords - v.Coords)
                    if DistanceToBanks < 1.5 then
                        sleep = 4
                        Config.DrawText3D("~INPUT_PICKUP~ - Open Bank", vector3(v.Coords.x, v.Coords.y, v.Coords.z))
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent('real-bank:CheckAccountExistens', nil)
                        end
                    end
                end
                Citizen.Wait(sleep)
            end
        end)
    end
end