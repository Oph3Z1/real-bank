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
                        Config.DrawText3D("~INPUT_PICKUP~ - Open ATM", vector3(GetATMCoords.x, GetATMCoords.y, GetATMCoords.z + 1.0))
                        if IsControlJustReleased(0, 38) then
                            SendNUIMessage({
                                action = 'OpenBank'
                            })
                            SetNuiFocus(true, true)
                        end
                    end
                end

                for k, v in pairs(Config.BankLocations) do
                    local DistanceToBanks = #(PlayerCoords - v.Coords)
                    if DistanceToBanks < 1.5 then
                        sleep = 4
                        Config.DrawText3D("~INPUT_PICKUP~ - Open Bank", vector3(v.Coords.x, v.Coords.y, v.Coords.z))
                        if IsControlJustReleased(0, 38) then
                            OpenBankUI()
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
            Config.DrawText3D("~INPUT_PICKUP~ - Open Bank Settings", Config.GetCreditCard)
            if IsControlJustReleased(0, 38) then
                local QBMenu = {
                    {
                        header = ' Bank Settings',
                        icon = 'fa-solid fa-building-columns',
                        isMenuHeader = true,
                    },
                    {
                        header = 'Get Credit Card',
                        text = 'Get your first credit card',
                        icon = 'fa-solid fa-credit-card',
                        params = {
                            event = 'real-bank:BankSettings',
                            args = {
                                value = 'Get'
                            }   
                        }
                    },
                    {
                        header = 'Change Password',
                        text = 'Change your password asap if your credit card is stolen',
                        icon = 'fa-solid fa-credit-card',
                        params = {
                            event = 'real-bank:BankSettings',
                            args = {
                                value = 'Change'
                            }   
                        }
                    },
                }
                exports['qb-menu']:openMenu(QBMenu)
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('real-bank:CheckAccountExistensResult', function(result, data)
    if data.value == 'Get' then
        if not result then
            SendNUIMessage({
                action = 'OpenCreatePasswordScreen'
            })
            SetNuiFocus(true, true)
        else
            print('You already have an account')
        end
    elseif data.value == 'Change' then
        if result then
            SendNUIMessage({
                action = 'OpenChangePasswordScreen'
            })
            SetNuiFocus(true, true)
        else
            print("You don't have an account. Please create one first.")
        end
    end
end)

function OpenBankUI()
    local data = Callback('real-bank:GetPlayerData')
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'OpenBank',
        data = data
    })
end

function Callback(name, payload)
    if Config.Framework == "newesx" or Config.Framework == "oldesx" then
        local data = nil
        if frameworkObject then
            frameworkObject.TriggerServerCallback(name, function(returndata)
                data = returndata
            end, payload)
            while data == nil do
                Citizen.Wait(0)
            end
        end
        return data
    else
        local data = nil
        if frameworkObject then
            frameworkObject.Functions.TriggerCallback(name, function(returndata)
                data = returndata
            end, payload)
            while data == nil do
                Citizen.Wait(0)
            end
        end
        return data
    end
end

function SendLog(received, sendedto, type, amount, pp)
    TriggerServerEvent('real-bank:SendLog', received, sendedto, type, amount, pp)
end

RegisterNetEvent('real-bank:SendLog')
AddEventHandler('real-bank:SendLog', function(received, sendedto, type, amount, pp)
    SendLog(received, sendedto, type, amount, pp)
end)

RegisterNetEvent('real-bank:BankSettings')
AddEventHandler('real-bank:BankSettings', function(data)
    if data.value == 'Get' or data.value == 'Change' then
        TriggerServerEvent('real-bank:CheckAccountExistens', data)
    end
end)

RegisterNUICallback('CreatePassword', function(data, cb)
    TriggerServerEvent("real-bank:CreateAccount", data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ChangePassword', function(data, cb)
    TriggerServerEvent("real-bank:ChangePassword", data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('Logout', function(data, cb)
    SetNuiFocus(false, false)
end)