frameworkObject = false
response = false

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
    while not response do
        Citizen.Wait(0)
    end
    Citizen.Wait(1500)
    SendNUIMessage({
        action = 'Setup',
        first = Config.FirstFastAction,
        second = Config.SecondFastAction,
        third = Config.ThirdFastAction,
        language = Config.Language,
        invoicetheme = Config.InvoiceTheme,
        cardstyle = Config.CardStyle,
        credittable = Config.AvailableCredits,
        requirecreditpoint = Config.RequireCreditPoint,
        creditsystem = Config.CreditSystem,
    })
    Citizen.Wait(1500)
    OpenBank()
    CreateBlips()
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

function CreateBlips()
    for k, v in pairs(Config.BankLocations) do
        blip = AddBlipForCoord(v.Coords.x, v.Coords.y, v.Coords.z)
        SetBlipSprite(blip, v.BlipType)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, v.BlipScale)
        SetBlipColour(blip, v.BlipColor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.Blipname)
        EndTextCommandSetBlipName(blip)
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
                if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
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
                else
                    local elements = {
                        {label = "Get Credit Card", value = "GetCard"},
                        {label = "Change Password", value = "ChangePassword"},
                    }
                    frameworkObject.UI.Menu.Open('default', GetCurrentResourceName(), 'bank', {
                        title = 'Bank Settings',
                        align = 'top-left',
                        elements = elements
                    }, function(data, menu)
                        if data.current.value == 'GetCard' then
                            TriggerEvent('real-bank:BankSettings', 'Get')
                        elseif data.current.value == 'ChangePassword' then
                            TriggerEvent('real-bank:BankSettings', 'Change')
                        end
                    end, function(data, menu)
                        menu.close()
                    end)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('real-bank:CheckAccountExistensResult', function(result, data)
    if data then
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            if data.value == 'Get' then
                if not result then
                    SendNUIMessage({
                        action = 'OpenCreatePasswordScreen'
                    })
                    SetNuiFocus(true, true)
                else
                    Config.Notification(Config.Language['already_have_account'], 'error', false)
                end
            elseif data.value == 'Change' then
                if result then
                    SendNUIMessage({
                        action = 'OpenChangePasswordScreen'
                    })
                    SetNuiFocus(true, true)
                else
                    Config.Notification(Config.Language['no_account'], 'error', false)
                end
            end
        else
            if data == 'Get' then
                if not result then
                    SendNUIMessage({
                        action = 'OpenCreatePasswordScreen'
                    })
                    SetNuiFocus(true, true)
                else
                    Config.Notification(Config.Language['already_have_account'], 'error', false)
                end
            elseif data == 'Change' then
                if result then
                    SendNUIMessage({
                        action = 'OpenChangePasswordScreen'
                    })
                    SetNuiFocus(true, true)
                else
                    Config.Notification(Config.Language['no_account'], 'error', false)
                end
            end
        end
    else
        if result then
            OpenBankUI()
        else
            Config.Notification(Config.Language['no_account'], 'error', false)
        end
    end
end)

function OpenATM()
    SendNUIMessage({
        action = 'OpenATM'
    })
    SetNuiFocus(true, true)
end

function OpenBankUI()
    local data = Callback('real-bank:GetPlayerData')
    local billsdata = Callback('real-bank:GetBills')
    getframe = nil
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        getframe = 'qb'
    else
        getframe = 'esx'
    end
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'OpenBank',
        data = data.data,
        playermoney = data.PlayerMoney,
        playercash = data.PlayerCash,
        billsframe = getframe,
        billsdata = billsdata,
        transferlist = data.transferlist
    })
end

function OpenBankAnotherAccount(pidata)
    local data

    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        data = Callback('real-bank:ATMLoginAnotherAccount', pidata)
    else
        data = Callback('real-bank:ESX:ATMLoginAnotherAccount', pidata)
    end

    if data then
        SendNUIMessage({
            action = 'OpenAnotherAccount',
            infodata = data.infodata,
            targetmoney = data.targetmoney,
            transaction = data.transaction,
            iban = data.iban,
            loginlimit = data.loginlimit,
            withdrawlimit = data.withdrawlimit,
        })
        SetNuiFocus(true, true)
    end
end

function SendLog(received, sendedto, type, amount, pp)
    TriggerServerEvent('real-bank:SendLog', received, sendedto, type, amount, pp)
end

RegisterNetEvent('real-bank:OpenATMFunction')
AddEventHandler('real-bank:OpenATMFunction', function()
    OpenATM()
end)

RegisterNetEvent('real-bank:OpenNormalBank')
AddEventHandler('real-bank:OpenNormalBank', function()
    TriggerServerEvent('real-bank:CheckAccountExistens', nil)
end)

RegisterNetEvent('real-bank:UpdateUITransaction')
AddEventHandler('real-bank:UpdateUITransaction', function()
    local data = Callback('real-bank:GetPlayerData')
    SendNUIMessage({
        action = 'UpdateTransaction',
        data = data.data
    })
end)

RegisterNetEvent('real-bank:BankSettings')
AddEventHandler('real-bank:BankSettings', function(data)
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        if data.value == 'Get' or data.value == 'Change' then
            TriggerServerEvent('real-bank:CheckAccountExistens', data)
        end
    else
        if data == 'Get' or data == 'Change' then
            TriggerServerEvent('real-bank:CheckAccountExistens', data)
        end
    end
end)

RegisterNetEvent('real-bank:RefreshBillsUI')
AddEventHandler('real-bank:RefreshBillsUI', function()
    local billsdata = Callback('real-bank:GetBills')
    getframe = null
    playercurrentmoney = 0
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        playerdata = frameworkObject.Functions.GetPlayerData()
        playercurrentmoney = playerdata.money.bank
        getframe = 'qb'
    else
        getframe = 'esx'
    end
    SendNUIMessage({
        action = 'RefreshBills',
        billsframe = getframe,
        billsdata = billsdata,
        playermoney = playercurrentmoney,
    })
end)

RegisterNetEvent('real-bank:OpenBank')
AddEventHandler('real-bank:OpenBank', function()
    OpenBankUI()
end)

RegisterNetEvent('real-bank:Close')
AddEventHandler('real-bank:Close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('CreatePassword', function(data, cb)
    TriggerServerEvent("real-bank:CreateAccount", data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ChangePassword', function(data, cb)
    TriggerServerEvent("real-bank:ChangePassword", data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ConfirmCredit', function(data, cb)
    TriggerServerEvent('real-bank:CreditConfirm', data)
end)

RegisterNUICallback('PayDebts', function(data, cb)
    TriggerServerEvent('real-bank:PayCreditDebts')
end)

RegisterNUICallback('PayBill', function(data, cb)
    TriggerServerEvent('real-bank:PayBills', data.id, data.amount)
end)

RegisterNUICallback('DepositMoney', function(data, cb)
    TriggerServerEvent('real-bank:DepositMoney', data)
end)

RegisterNUICallback('WithdrawMoney', function(data, cb)
    TriggerServerEvent('real-bank:WithdrawMoney', data)
end)

RegisterNUICallback('ATMLoginToOwnAccount', function(data, cb)
    TriggerServerEvent('real-bank:ATMLoginOwnAccount', data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ATMLoginAnotherAccount', function(data, cb)
    SetNuiFocus(false, false)
    OpenBankAnotherAccount(data)
end)

RegisterNUICallback('WithdrawHackedAccount', function(data, cb)
    TriggerServerEvent('real-bank:WithdrawHackedAccount', data)
end)

RegisterNUICallback('WithdrawFastAction', function(data, cb)
    TriggerServerEvent('real-bank:WithdrawFastAction', data)
end)

RegisterNUICallback('DepositFastAction', function(data, cb)
    TriggerServerEvent('real-bank:DepositFastAction', data)
end)

RegisterNUICallback('TransferMoney', function(data, cb)
    TriggerServerEvent('real-bank:TransferMoney', data.iban, data.amount)
end)

RegisterNUICallback('Logout', function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('CloseBankUI', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'CloseBankUI'
    })
end)

RegisterNUICallback('CloseATM', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'CloseATMUI'
    })
end)

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