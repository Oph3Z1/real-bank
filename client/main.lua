frameworkObject = false
response = false

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
    while not response do
        Citizen.Wait(0)
    end
    OpenBank()
end)

RegisterNUICallback('GetResponse', function(data, cb)
    response = true
    if cb then
        cb("ok")
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        SendNUIMessage({
            action = "SendResponse",
        })
        if response then
            return
        end
    end
end)

function OpenBank()
    if Config.Drawtext == 'qb-target' then
    elseif Config.Drawtext == 'bt-target' then
    elseif Config.Drawtext == 'qtarget' then
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
                        Config.DrawText3D("~INPUT_PICKUP~ - Open Bank", vector3(GetATMCoords.x, GetATMCoords.y, GetATMCoords.z))
                        if IsControlJustReleased(0, 38) then
                            SendNUIMessage({
                                action = 'OpenBank'
                            })
                        end
                    end
                end

                for k, v in pairs(Config.BankLocations) do
                    local DistanceToBanks = #(PlayerCoords - v.Coords)
                    if DistanceToBanks < 1.5 then
                        sleep = 4
                        Config.DrawText3D("~INPUT_PICKUP~ - Open Bank", vector3(v.Coords.x, v.Coords.y, v.Coords.z))
                        if IsControlJustReleased(0, 38) then
                            SendNUIMessage({
                                action = 'OpenBank'
                            })
                        end
                    end
                end
                Citizen.Wait(sleep)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        local Player = PlayerPedId()
        local PlayerCoords = GetEntityCoords(Player)
        local Distance = #(PlayerCoords - Config.GetCreditCard)

        if Distance < 1.5 then
            sleep = 4
            Config.DrawText3D("~INPUT_PICKUP~ - Get Credit Card", Config.GetCreditCard)
            if IsControlJustReleased(0, 38) then
                SendNUIMessage({
                    action = 'OpenCreatePasswordScreen'
                })
                SetNuiFocus(true, true)
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNUICallback('CreatePassword', function(data, cb)
    TriggerServerEvent("real-bank:CreateAccount", data)
    SetNuiFocus(false, false)
end)