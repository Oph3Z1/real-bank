frameworkObject = nil
GetSQLTable = {}
StatusThing = nil
PlayerSource = 0

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    local data = ExecuteSql("SELECT * FROM `real_bank`")
    for k, v in pairs(data) do
        if v.transaction == nil then
            v.transaction = {}
        else
            v.transaction = json.decode(v.transaction)
        end
        if v.credit == nil then
            v.credit = {}
        else
            v.credit = json.decode(v.credit)
        end
        if v.info == nil then
            v.info = {}
        else
            v.info = json.decode(v.info)
        end
        if v.AccountUsed == nil then
            v.AccountUsed = {}
        else
            v.AccountUsed = json.decode(v.AccountUsed)
        end
    end
    GetSQLTable = data
end)

Citizen.CreateThread(function()
    RegisterCallback("real-bank:GetPlayerData", function(source, cb)
        local src = source
        PlayerSource = src
        local PlayerIdent = GetIdentifier(src)
        local PlayerMoney = GetPlayerMoneyOnline("bank", src)
        local PlayersCash = GetPlayerMoneyOnline("cash", src)
        local dcpfp = GetDiscordAvatar(src)
        local data = ExecuteSql("SELECT * FROM `real_bank` WHERE `identifier` = '"..PlayerIdent.."'")
        local accountusedtable = json.decode(data[1].AccountUsed)
        local transferplayersdata = GetPlayers()
        
        local getcredittable = json.decode(data[1].credit)
        local getdatefromdata = getcredittable.creditlastdate
        local currenttime = GetCurrentDate()

        if #data > 0 then
            if accountusedtable.loginlimit > 0 then
                if accountusedtable.withdrawlimit > 0 then
                    if Config.CreditSystem == true then
                        if getcredittable.debt > 0 then
                            if getdatefromdata ~= 0 or getdatefromdata ~= '' or getdatefromdata ~= "" or getdatefromdata ~= nil then
                                if tostring(currenttime) > tostring(getdatefromdata) then
                                    TriggerEvent('real-bank:PayCreditDebts')
                                    Citizen.Wait(100)
                                    if StatusThing == true then
                                        local a = json.decode(data[1].info)
                                        local b = json.decode(data[1].credit)
                                        data[1].info = a
                                        data[1].credit = b
                                        if tostring(a.playerpfp) ~= tostring(dcpfp) then
                                            a.playerpfp = dcpfp
                                            ExecuteSql("UPDATE `real_bank` SET `info` = '"..json.encode(data[1].info).."' WHERE `identifier` = '"..PlayerIdent.."' ")
                                        end
                                        DataTable = {
                                            data = data,
                                            PlayerMoney = tonumber(PlayerMoney),
                                            PlayerCash = tonumber(PlayersCash),
                                            transferlist = transferplayersdata
                                        }
                                        cb(DataTable)
                                    end
                                else
                                    local a = json.decode(data[1].info)
                                    local b = json.decode(data[1].credit)
                                    data[1].info = a
                                    data[1].credit = b
                                    if tostring(a.playerpfp) ~= tostring(dcpfp) then
                                        a.playerpfp = dcpfp
                                        ExecuteSql("UPDATE `real_bank` SET `info` = '"..json.encode(data[1].info).."' WHERE `identifier` = '"..PlayerIdent.."' ")
                                    end
                                    DataTable = {
                                        data = data,
                                        PlayerMoney = tonumber(PlayerMoney),
                                        PlayerCash = tonumber(PlayersCash),
                                        transferlist = transferplayersdata
                                    }
                                    cb(DataTable)
                                end
                            end
                        else
                            local a = json.decode(data[1].info)
                            local b = json.decode(data[1].credit)
                            data[1].info = a
                            data[1].credit = b
                            if tostring(a.playerpfp) ~= tostring(dcpfp) then
                                a.playerpfp = dcpfp
                                ExecuteSql("UPDATE `real_bank` SET `info` = '"..json.encode(data[1].info).."' WHERE `identifier` = '"..PlayerIdent.."' ")
                            end
                            DataTable = {
                                data = data,
                                PlayerMoney = tonumber(PlayerMoney),
                                PlayerCash = tonumber(PlayersCash),
                                transferlist = transferplayersdata
                            }
                            cb(DataTable)
                        end
                    else
                        local a = json.decode(data[1].info)
                        local b = json.decode(data[1].credit)
                        data[1].info = a
                        data[1].credit = b
        
                        if tostring(a.playerpfp) ~= tostring(dcpfp) then
                            a.playerpfp = dcpfp
                            ExecuteSql("UPDATE `real_bank` SET `info` = '"..json.encode(data[1].info).."' WHERE `identifier` = '"..PlayerIdent.."' ")
                        end
        
                        DataTable = {
                            data = data,
                            PlayerMoney = tonumber(PlayerMoney),
                            PlayerCash = tonumber(PlayersCash),
                            transferlist = transferplayersdata
                        }
                        cb(DataTable)
                    end
                else
                    Config.Notification(Config.Language['change_password_to_access'], 'error', true, src)
                end
            else
                Config.Notification(Config.Language['change_password_to_access'], 'error', true, src)
            end
        end
    end)

    RegisterCallback("real-bank:GetBills", function(source, cb)
        local src = source
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            local identity = GetIdentifier(src)
            local data = ExecuteSql("SELECT * FROM `phone_invoices` WHERE `citizenid` = '"..identity.."'")
            if next(data) then
                cb(data)
            else
                cb(false)
            end
        else
            local identity = GetIdentifier(src)
            local data = ExecuteSql("SELECT * FROM `billing` WHERE `identifier` = '" .. identity .. "'")
            if next(data) then
                cb(data)
            else
                cb(false)
            end
        end
    end)

    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        frameworkObject.Functions.CreateCallback("real-bank:ATMLoginAnotherAccount", function(source, cb, getdata)
            local src = source
            local PlayerIdent = GetIdentifier(src)
            local targetiban = getdata.iban
            local data = ExecuteSql("SELECT * FROM `real_bank` WHERE `iban` = '"..targetiban.."'")
            if data and data[1] then
                local targetidentity = data[1].identifier
                local targetinfo = json.decode(data[1].info)
                local targettransaction = json.decode(data[1].transaction)
                local accountusedtable = json.decode(data[1].AccountUsed)
                local targetaccountmoney = GetPlayerMoneyOffline(targetidentity)
                
                if tonumber(getdata.password) == tonumber(data[1].password) then
                    if accountusedtable.loginlimit ~= 0 then
                        DataTable = {
                            infodata = targetinfo,
                            targetmoney = targetaccountmoney,
                            transaction = targettransaction,
                            loginlimit = accountusedtable.loginlimit,
                            withdrawlimit = accountusedtable.withdrawlimit,
                            iban = targetiban
                        }
                        cb(DataTable)
                        accountusedtable.loginlimit = accountusedtable.loginlimit - 1
                        ExecuteSql("UPDATE `real_bank` SET `AccountUsed` = '"..json.encode(accountusedtable).."' WHERE `identifier` = '"..targetidentity.."'")
                    else
                        Config.Notification(Config.Language['cant_hack_anymore'], 'error', true, src)
                    end
                else
                    TriggerClientEvent('real-bank:Close', src)
                    Config.Notification(Config.Language['wrong_password'], 'error', true, src)
                end
            else
                TriggerClientEvent('real-bank:Close', src)
                Config.Notification(Config.Language['wrong_password'], 'error', true, src)
            end
        end)
    else
        frameworkObject.RegisterServerCallback("real-bank:ESX:ATMLoginAnotherAccount", function(source, cb, getdata)
            local src = source
            local PlayerIdent = GetIdentifier(src)
            local targetiban = getdata.iban
            local data = ExecuteSql("SELECT * FROM `real_bank` WHERE `iban` = '"..targetiban.."'")
            if data and data[1] then
                local targetidentity = data[1].identifier
                local targetinfo = json.decode(data[1].info)
                local targettransaction = json.decode(data[1].transaction)
                local accountusedtable = json.decode(data[1].AccountUsed)
                local targetaccountmoney = GetPlayerMoneyOffline(targetidentity)
                
                if tonumber(getdata.password) == tonumber(data[1].password) then
                    if accountusedtable.loginlimit ~= 0 then
                        DataTable = {
                            infodata = targetinfo,
                            targetmoney = targetaccountmoney,
                            transaction = targettransaction,
                            loginlimit = accountusedtable.loginlimit,
                            withdrawlimit = accountusedtable.withdrawlimit,
                            iban = targetiban
                        }
                        cb(DataTable)
                        accountusedtable.loginlimit = accountusedtable.loginlimit - 1
                        ExecuteSql("UPDATE `real_bank` SET `AccountUsed` = '"..json.encode(accountusedtable).."' WHERE `identifier` = '"..targetidentity.."'")
                    else
                        TriggerClientEvent('real-bank:Close', src)
                        Config.Notification(Config.Language['cant_hack_anymore'], 'error', true, src)
                    end
                else
                    TriggerClientEvent('real-bank:Close', src)
                    Config.Notification(Config.Language['wrong_password'], 'error', true, src)
                end
            else
                TriggerClientEvent('real-bank:Close', src)
                Config.Notification(Config.Language['wrong_password'], 'error', true, src)
            end
        end)
    end
end)

RegisterNetEvent("real-bank:CreateAccount", function(password)
    local src = source
    local DiscordAvatar = GetDiscordAvatar(src)
    local CreditTable = {}

    if Config.CreditSystem == true then
        CreditTable = {
            playercreditpoint = Config.StartCreditPoint,
            activecredit = '',
            creditlastdate = 0,
            debt = 0,
        }
    end

    if Config.Framework == 'newesx' or Config.Framework == 'oldesx' then
        local Player = frameworkObject.GetPlayerFromId(src)
        CreateAccount = {
            identifier = GetIdentifier(src),
            info = {
                playername = Player.getName(),
                playerpfp = DiscordAvatar
            },
            credit = CreditTable,
            transaction = {},
            iban = math.random(1000, 9999),
            password = password,
            AccountUsed = {
                loginlimit = Config.LoginLimit,
                withdrawlimit = Config.WithdrawLimit
            }
        }
    else
        local Player = frameworkObject.Functions.GetPlayer(src)
        local identity = GetIdentifier(src)
        CreateAccount = {
            identifier = GetIdentifier(src),
            info = {
                playername = GetName(src),
                playerpfp = DiscordAvatar
            },
            credit = CreditTable,
            transaction = {},
            iban = math.random(1000, 9999),
            password = password,
            AccountUsed = {
                loginlimit = Config.LoginLimit,
                withdrawlimit = Config.WithdrawLimit
            }
        }
    end
    ExecuteSql("INSERT INTO `real_bank` (`identifier`, `info`, `credit`, `transaction`, `iban`, `password`, `AccountUsed`) VALUES ('"..CreateAccount.identifier.."', '"..json.encode(CreateAccount.info).."', '"..json.encode(CreateAccount.credit).."', '"..json.encode(CreateAccount.transaction).."', '"..CreateAccount.iban.."', '"..CreateAccount.password.."', '"..json.encode(CreateAccount.AccountUsed).."')")
    Config.Notification(Config.Language['successfully_created_account'], 'success', true, src)
    Citizen.Wait(200)
    table.insert(GetSQLTable, CreateAccount)
    Citizen.Wait(100)
end)

RegisterNetEvent('real-bank:ATMLoginOwnAccount', function(password)
    local src = source
    local PlayerIdent = GetIdentifier(src)
    local data = ExecuteSql("SELECT `password` FROM `real_bank` WHERE `identifier` = '"..PlayerIdent.."'")
    if data[1] then
        if tonumber(password) == tonumber(data[1].password) then
            TriggerClientEvent('real-bank:OpenBank', src)
        else
            Config.Notification(Config.Language['wrong_password'], 'error', true, src)
        end
    end
end)

RegisterNetEvent('real-bank:ChangePassword', function(newpassword)
    local ident = GetIdentifier(source)
    local data = ExecuteSql("SELECT `identifier` FROM `real_bank` WHERE `identifier` = '" .. ident .. "'")
    
    if data[1] then
        ExecuteSql("UPDATE `real_bank` SET `password` = '" .. newpassword .. "' WHERE `identifier` = '" .. ident .. "'")
    else
        print('No data found for identifier')
    end
end)

RegisterNetEvent('real-bank:CheckAccountExistens', function(data)
    local ident = GetIdentifier(source)
    local Account = GetPlayerAccount(ident)

    if Account then
        if data then
            TriggerClientEvent('real-bank:CheckAccountExistensResult', source, true, data)
        else
            TriggerClientEvent('real-bank:CheckAccountExistensResult', source, true, nil)
        end
    else 
        if data then
            TriggerClientEvent('real-bank:CheckAccountExistensResult', source, false, data)
        else
            TriggerClientEvent('real-bank:CheckAccountExistensResult', source, false, nil)
        end
    end
end)

RegisterNetEvent('real-bank:CreditConfirm', function(data)
    local src = source
    local ident = GetIdentifier(src)
    local sqldata = ExecuteSql("SELECT `credit` FROM `real_bank` WHERE `identifier` = '"..ident.."'")
    local a = json.decode(sqldata[1].credit)
    if a.credid == '' or a.cerdid == "" or a.credid == nil then
        if Config.RequireCreditPoint then
            if a.playercreditpoint > data.credreq then
                a.playercreditpoint = a.playercreditpoint - data.credreq
                NewCreditTable = {
                    playercreditpoint = a.playercreditpoint,
                    debt = data.credprice*data.credpaybackpercent,
                    activecredit = data.credid,
                    creditlastdate = os.date('%d.%m.%Y', os.time() + tonumber(data.creddate) * 7 * 24 * 60 * 60)
                }
                ExecuteSql("UPDATE `real_bank` SET `credit` = '"..json.encode(NewCreditTable).."' WHERE `identifier` = '"..ident.."'")
                RemoveAddBankMoneyOnline('add', tonumber(data.credprice), src)
            else
                Config.Notification(Config.Language['not_enough_cp'], 'error', true, src)
            end
        else
            a.playercreditpoint = a.playercreditpoint - data.credreq
            NewCreditTable = {
                playercreditpoint = a.playercreditpoint,
                debt = data.credprice*data.credpaybackpercent,
                activecredit = data.credid,
                creditlastdate = os.date('%d.%m.%Y', os.time() + tonumber(data.creddate) * 7 * 24 * 60 * 60)
            }
            ExecuteSql("UPDATE `real_bank` SET `credit` = '"..json.encode(NewCreditTable).."' WHERE `identifier` = '"..ident.."'")
            RemoveAddBankMoneyOnline('add', tonumber(data.credprice), src)
        end
    else
        Config.Notification(Config.Language['already_active_cp'], 'error', true, src)
    end
end)

RegisterNetEvent('real-bank:PayCreditDebts', function()
    local ident = GetIdentifier(PlayerSource)
    local data = ExecuteSql("SELECT `credit` FROM `real_bank` WHERE `identifier` = '"..ident.."'")
    local GetPlayerMoney = GetPlayerMoneyOnline('bank', PlayerSource)
    local a = json.decode(data[1].credit)
    if a.debt > 0 then
        if GetPlayerMoney > tonumber(a.debt) then
            NewCreditTable = {
                playercreditpoint =  a.playercreditpoint,
                activecredit = '',
                creditlastdate = 0,
                debt = 0,
            }
            ExecuteSql("UPDATE `real_bank` SET `credit` = '"..json.encode(NewCreditTable).."' WHERE `identifier` = '"..ident.."'")
            RemoveAddBankMoneyOnline('remove', tonumber(a.debt), PlayerSource)
            StatusThing = true
        else
            StatusThing = false
            Config.Notification(Config.Language['no_money_to_pay_debts'], 'error', true, source)
        end
    end
end)

RegisterNetEvent('real-bank:PayBills', function(id, amount)
    local src = source
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local Player = frameworkObject.Functions.GetPlayer(src)
        local playermoney = Player.PlayerData.money.bank
        if tonumber(playermoney) >= tonumber(amount) then
            Player.Functions.RemoveMoney('bank', tonumber(amount))
            ExecuteSql("DELETE FROM `phone_invoices` WHERE `id` = '"..id.."'")
            TriggerClientEvent('real-bank:RefreshBillsUI', src)
        else
            Config.Notification(Config.Language['no_money_to_pay_bills'], 'error', true, src)
        end
    else
    end
end)

RegisterNetEvent('real-bank:DepositMoney', function(amount)
    local src = source
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local Player = frameworkObject.Functions.GetPlayer(src)
        local playermoney = Player.PlayerData.money.cash
        if tonumber(amount) > 0 then
            if tonumber(playermoney) >= tonumber(amount) then
                Player.Functions.AddMoney('bank', tonumber(amount))
                Player.Functions.RemoveMoney('cash', tonumber(amount))
                SendLog(src, nil, nil, 'Deposit', tonumber(amount), 'discord')
            else
                Config.Notification(Config.Language['not_enough_money'], 'error', true, src)
            end
        else
            return
        end
    else
        local Player = frameworkObject.GetPlayerFromId(src)
        local playermoney = Player.getMoney()
        if tonumber(amount) > 0 then
            if tonumber(playermoney) >= tonumber(amount) then
                Player.addAccountMoney('bank', tonumber(amount))
                Player.RemoveMoney(tonumber(amount))
                SendLog(src, nil, nil, 'Deposit', tonumber(amount), 'discord')
            else
                Config.Notification(Config.Language['not_enough_money'], 'error', true, src)
            end
        else
            return
        end
    end
end)

RegisterNetEvent('real-bank:WithdrawMoney', function(amount)
    local src = source
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local Player = frameworkObject.Functions.GetPlayer(src)
        local playermoney = Player.PlayerData.money.bank
        if tonumber(amount) > 0 then
            if tonumber(playermoney) >= tonumber(amount) then
                Player.Functions.RemoveMoney('bank', tonumber(amount))
                Player.Functions.AddMoney('cash', tonumber(amount))
                SendLog(src, nil, nil, 'Withdraw', tonumber(amount), 'discord')
            else
                Config.Notification(Config.Language['not_enough_money'], 'error', true, src)
            end
        else
            return
        end
    else
        local Player = frameworkObject.GetPlayerFromId(src)
        local playermoney = Player.getAccount("bank").money
        if tonumber(amount) > 0 then
            if tonumber(playermoney) >= tonumber(amount) then
                Player.removeAccountMoney('bank', tonumber(amount))
                Player.addMoney(tonumber(amount))
                SendLog(src, nil, nil, 'Withdraw', tonumber(amount), 'discord')
            else
                Config.Notification(Config.Language['not_enough_money'], 'error', true, src)
            end
        else
            return
        end
    end
end)

RegisterNetEvent('real-bank:WithdrawFastAction', function(amount)
    local src = source
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local Player = frameworkObject.Functions.GetPlayer(src)
        local playermoney = Player.PlayerData.money.bank
        if tonumber(amount) > 0 then
            if tonumber(playermoney) >= tonumber(amount) then
                Player.Functions.RemoveMoney('bank', tonumber(amount))
                Player.Functions.AddMoney('cash', tonumber(amount))
                SendLog(src, nil, nil, 'Withdraw', tonumber(amount), 'discord')
            else
                Config.Notification(Config.Language['not_enough_money'], 'error', true, src)
            end
        else
            return
        end
    else
        local Player = frameworkObject.GetPlayerFromId(src)
        local playermoney = Player.getAccount("bank").money
        if tonumber(amount) > 0 then
            if tonumber(playermoney) >= tonumber(amount) then
                Player.removeAccountMoney('bank', tonumber(amount))
                Player.addMoney(tonumber(amount))
                SendLog(src, nil, nil, 'Withdraw', tonumber(amount), 'discord')
            else
                Config.Notification(Config.Language['not_enough_money'], 'error', true, src)
            end
        else
            return
        end
    end
end)

RegisterNetEvent('real-bank:DepositFastAction', function(amount)
    local src = source
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local Player = frameworkObject.Functions.GetPlayer(src)
        local playermoney = Player.PlayerData.money.cash
        if tonumber(amount) > 0 then
            if tonumber(playermoney) >= tonumber(amount) then
                Player.Functions.AddMoney('bank', tonumber(amount))
                Player.Functions.RemoveMoney('cash', tonumber(amount))
                SendLog(src, nil, nil, 'Deposit', tonumber(amount), 'discord')
            else
                Config.Notification(Config.Language['not_enough_money'], 'error', true, src)
            end
        else
            return
        end
    else
        local Player = frameworkObject.GetPlayerFromId(src)
        local playermoney = Player.getMoney()
        if tonumber(amount) > 0 then
            if tonumber(playermoney) >= tonumber(amount) then
                Player.addAccountMoney('bank', tonumber(amount))
                Player.RemoveMoney(tonumber(amount))
                SendLog(src, nil, nil, 'Deposit', tonumber(amount), 'discord')
            else
                Config.Notification(Config.Language['not_enough_money'], 'error', true, src)
            end
        else
            return
        end
    end
end)

RegisterNetEvent('real-bank:WithdrawHackedAccount', function(getdata)
    local src = source
    local targetiban = getdata.iban
    local data = ExecuteSql("SELECT * FROM `real_bank` WHERE `iban` = '"..targetiban.."'")
    if data and data[1] then
        local targetidentity = data[1].identifier
        local accountusedtable = json.decode(data[1].AccountUsed)
        local targetplayermoney = GetPlayerMoneyOffline(targetidentity)
        if tonumber(getdata.amount) > 0 then
            if tonumber(targetplayermoney) >= tonumber(getdata.amount) then
                RemoveBankMoneyOffline(targetidentity, tonumber(getdata.amount))
                if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
                    local Player = frameworkObject.Functions.GetPlayer(src)
                    Player.Functions.AddMoney("cash", tonumber(getdata.amount))
                else
                    local Player = frameworkObject.GetPlayerFromId(src)
                    Player.addMoney(tonumber(getdata.amount))
                end
                accountusedtable.withdrawlimit = accountusedtable.withdrawlimit - getdata.amount
                ExecuteSql("UPDATE `real_bank` SET `AccountUsed` = '"..json.encode(accountusedtable).."' WHERE `identifier` = '"..targetidentity.."'")
            else
                Config.Notification(Config.Language['not_enough_money'], 'error', true, src)
            end
        end
    else
        print("IBAN not found")
    end
end)

RegisterNetEvent('real-bank:TransferMoney', function(iban, amount)
    local src = source
    local data = ExecuteSql("SELECT * FROM `real_bank` WHERE `iban` = '"..iban.."'")

    for k, v in pairs(data) do
        if v.iban == iban then
            if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
                local Player = frameworkObject.Functions.GetPlayer(src)
                local playermoney = Player.PlayerData.money.bank
                local targetplayersource = frameworkObject.Functions.GetSource(v.identifier)
                local targetplayername = GetName(targetplayersource)
                local senderplayername = GetName(src)
                
                if tonumber(playermoney) >= tonumber(amount) then
                    if tonumber(targetplayersource) ~= 0 then
                        Player.Functions.RemoveMoney('bank', tonumber(amount))
                        targetplayersource.Functions.AddMoney('bank', tonumber(amount))
                        SendLog(src, nil, targetplayername, 'Transfer', tonumber(amount), 'discord')
                        SendLog(targetplayersource, senderplayername, nil, 'Received', tonumber(amount), 'discord')
                    else
                        local getplayersname = ExecuteSql("SELECT `charinfo` FROM `players` WHERE `citizenid` = '"..v.identifier.."'")
                        local b = json.decode(getplayersname[1].charinfo)
                        Player.Functions.RemoveMoney('bank', tonumber(amount))
                        AddBankMoneyOffline(v.identifier, tonumber(amount))
                        SendLog(src, nil, b.firstname .. " " .. b.lastname, 'Transfer', tonumber(amount), 'discord')
                        SendOfflineLog(src, v.identifier, b.firstname .. " " .. b.lastname, senderplayername, nil, 'Received', tonumber(amount), 'discord')
                    end
                end
            else
                local Player = frameworkObject.GetPlayerFromId(src)
                local playermoney = Player.getAccount("bank").amount
                local targetplayersource = frameworkObject.GetPlayerFromIdentifier(v.identifier)
                local targetplayername = GetName(targetplayersource)
                local senderplayername = GetName(src)

                if tonumber(playermoney) >= tonumber(amount) then
                    if tonumber(targetplayersource) ~= 0 then
                        Player.removeAccountMoney("bank", tonumber(amount))
                        targetplayersource.addAccountMoney("bank", tonumber(amount))
                        SendLog(src, nil, targetplayername, 'Transfer', tonumber(amount), 'discord')
                        SendLog(targetplayersource, senderplayername, nil, 'Received', tonumber(amount), 'discord')
                    else
                        local getplayersname =  ExecuteSql("SELECT `firstname`, `lastname` FROM `users` WHERE `identifier` = '"..v.identifier.."'")
                        local targetfirstname = getplayersname[1].firstname
                        local targetlastname = getplayersname[1].lastname
                        Player.removeAccountMoney("bank", tonumber(amount))
                        AddBankMoneyOffline(v.identifier, tonumber(amount))
                        SendLog(src, nil, b.firstname .. " " .. b.lastname, 'Transfer', tonumber(amount), 'discord')
                        SendOfflineLog(src, v.identifier, targetfirstname .. " " .. targetlastname, senderplayername, nil, 'Received', tonumber(amount), 'discord')
                    end
                end
            end
        end
    end
end)

function GetCurrentDate()
    local currentTime = os.time()
    local formattedDate = os.date("%d.%m.%Y", currentTime)
    return formattedDate
end

function GetIdentifier(source)
    if Config.Framework == "newesx" or Config.Framework == "oldesx" then
        local xPlayer = frameworkObject.GetPlayerFromId(tonumber(source))

        if xPlayer then
            return xPlayer.getIdentifier()
        else
            return "0"
        end
    else
        local Player = frameworkObject.Functions.GetPlayer(tonumber(source))
        if Player then
            return Player.PlayerData.citizenid
        else
            return "0"
        end
    end
end

function GetName(source)
    if Config.Framework == "newesx" or Config.Framework == "oldesx" then
        local xPlayer = frameworkObject.GetPlayerFromId(tonumber(source))
        if xPlayer then
            return xPlayer.getName()
        else
            return "0"
        end
    else
        local Player = frameworkObject.Functions.GetPlayer(tonumber(source))
        if Player then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        else
            return "0"
        end
    end
end

function GetPlayerAccount(identifier)
    local ident = identifier
    for k, v in pairs(GetSQLTable) do
        if v.identifier == ident then
            return v, k
        end
    end
    return false
end

function RegisterCallback(name, cbFunc, data)
    while not frameworkObject do
        Citizen.Wait(0)
    end
    if Config.Framework == "newesx" or Config.Framework == "oldesx" then
        frameworkObject.RegisterServerCallback(
            name,
            function(source, cb, data)
                cbFunc(source, cb)
            end
        )
    else
        frameworkObject.Functions.CreateCallback(
            name,
            function(source, cb, data)
                cbFunc(source, cb)
            end
        )
    end
end

function GetPlayerMoneyOffline(identifier)
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local result = ExecuteSql("SELECT money FROM players WHERE citizenid = '"..identifier.."'")
        local targetMoney = json.decode(result[1].money)
        return targetMoney.bank
    else
        local result = ExecuteSql("SELECT accounts FROM users WHERE identifier = '"..identifier.."'")
        local targetMoney = json.decode(result[1].accounts)
        return targetMoney.bank
    end
end

function RemoveBankMoneyOffline(identifier, payment)
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local result = ExecuteSql("SELECT money FROM players WHERE citizenid = '"..identifier.."'")
        local targetMoney = json.decode(result[1].money)
        targetMoney.bank = targetMoney.bank - payment
        ExecuteSql("UPDATE players SET money = '"..json.encode(targetMoney).."' WHERE citizenid = '"..identifier.."'")
    else
        local result = ExecuteSql("SELECT accounts FROM users WHERE identifier = '"..identifier.."'")
        local targetMoney = json.decode(result[1].accounts)
        targetMoney.bank = targetMoney.bank - payment
        ExecuteSql("UPDATE users SET accounts = '"..json.encode(targetMoney).."' WHERE identifier = '"..identifier.."'")
    end
end

function AddBankMoneyOffline(identifier, payment)
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local result = ExecuteSql("SELECT money FROM players WHERE citizenid = '"..identifier.."'")
        local targetMoney = json.decode(result[1].money)
        targetMoney.bank = targetMoney.bank + payment
        ExecuteSql("UPDATE players SET money = '"..json.encode(targetMoney).."' WHERE citizenid = '"..identifier.."'")
    else
        local result = ExecuteSql("SELECT accounts FROM users WHERE identifier = '"..identifier.."'")
        local targetMoney = json.decode(result[1].accounts)
        targetMoney.bank = targetMoney.bank + payment
        ExecuteSql("UPDATE users SET accounts = '"..json.encode(targetMoney).."' WHERE identifier = '"..identifier.."'")
    end
end

function RemoveAddBankMoneyOnline(type, amount, id)
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local Player = frameworkObject.Functions.GetPlayer(id)
        if type == 'add' then
            Player.Functions.AddMoney('bank', tonumber(amount))
        elseif type == 'remove' then
            Player.Functions.RemoveMoney('bank', tonumber(amount))
        end
    else
        local Player = frameworkObject.GetPlayerFromId(id)
        if type == 'add' then
            Player.addAccountMoney('bank', tonumber(amount))
        elseif type == 'remove' then
            Player.removeAccountMoney('bank', tonumber(amount))
        end
    end
end

function GetPlayerMoneyOnline(type, id)
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local Player = frameworkObject.Functions.GetPlayer(PlayerSource)
        if type == 'bank' then
            return tonumber(Player.PlayerData.money.bank)
        elseif type == 'cash' then
            return tonumber(Player.PlayerData.money.cash)
        end
    elseif Config.Framework == 'newesx' or Config.Framework == 'oldesx' then
        local Player = frameworkObject.GetPlayerFromId(PlayerSource)
        if type == 'bank' then
            return tonumber(Player.getAccount('bank').money)
        elseif type == 'cash' then
            return tonumber(Player.getMoney())
        end
    end
end

function GetPlayers()
    local resulttable = {}
    local data = ExecuteSql("SELECT * FROM `real_bank`")
    if data or data[1] then 
        for k, v in pairs(data) do
            local a = json.decode(v.info)
            table.insert(resulttable, {
                id = k,
                pp = a.playerpfp,
                playername = a.playername,
                iban = v.iban
            })
        end
        return resulttable
    end
end

function GetPassword(iban)
    local data = ExecuteSql("SELECT `password` FROM `real_bank` WHERE `iban` = '"..iban.."'")
    local Password = json.decode(data[1].password)
    if #data > 0 then
        return Password
    else
        print("Data not found")
    end
end

function GetIBAN(source, identifier, IsSoruce)
    if IsSoruce then
        local source = source
        local ident = GetIdentifier(source)
        local data = ExecuteSql("SELECT `iban` FROM `real_bank` WHERE `identifier` = '"..ident.."'")
        local IBAN = json.decode(data[1].iban)
        return IBAN
    else
        local data = ExecuteSql("SELECT `iban` FROM `real_bank` WHERE `identifier` = '"..identifier.."'")
        local IBAN = json.decode(data[1].iban)
        return IBAN
    end
end

function GiveCredit(playersource, amount)
    local source = playersource
    local ident = GetIdentifier(source)
    local data = ExecuteSql("SELECT `credit` FROM `real_bank` WHERE `identifier` = '"..ident.."'")
    local Credit = json.decode(data[1].credit)

    if #data > 0 then
        Credit.playercreditpoint = Credit.playercreditpoint + amount
        ExecuteSql("UPDATE `real_bank` SET `credit` = '"..json.encode(Credit).."' WHERE `identifier` = '"..ident.."'")
    else
        print("Data not found")
    end
end

function SendLog(playersource, received, sendedto, type, amount, pp)
    local source = playersource
    local ident = GetIdentifier(source)
    local GetPlayerName = GetName(source)
    local DiscordAvatar = GetDiscordAvatar(source)
    local data = ExecuteSql("SELECT `transaction` FROM `real_bank` WHERE `identifier` = '"..ident.."'")
    local Transaction = json.decode(data[1].transaction)

    if #data > 0 then
        if received == nil then
            received = ''
        end
        if sendedto == nil then
            sendedto = ''
        end
        if pp == 'discord' then
            pp = DiscordAvatar
        end

        TableID = #Transaction + 1
        
        table.insert(Transaction, {
            id = TableID,
            name = GetPlayerName,
            received = received,
            sendedto = sendedto,
            type = type,
            amount = amount,
            pp = pp,
            date = GetCurrentDate(),
        })
        ExecuteSql("UPDATE `real_bank` SET `transaction` = '"..json.encode(Transaction).."' WHERE `identifier` = '"..ident.."'")
        TriggerClientEvent('real-bank:UpdateUITransaction', source)
    else
        print("Data not found")
    end
end

function SendOfflineLog(sendersource, identifier, playername, received, sendedto, type, amount, pp)
    local source = sendersource
    local data = ExecuteSql("SELECT `transaction` FROM `real_bank` WHERE `identifier` = '"..identifier.."'")
    local Transaction = json.decode(data[1].transaction)
    local DiscordAvatar = GetDiscordAvatar(source)

    if #data > 0 then
        if received == nil then
            received = ''
        end
        if sendedto == nil then
            sendedto = ''
        end
        if pp == 'discord' and sendersource ~= 0 or sendersource ~= nil then
            pp = DiscordAvatar
        end

        TableID = #Transaction + 1
        
        table.insert(Transaction, {
            id = TableID,
            name = playername,
            received = received,
            sendedto = sendedto,
            type = type,
            amount = amount,
            pp = pp,
            date = GetCurrentDate(),
        })
        ExecuteSql("UPDATE `real_bank` SET `transaction` = '"..json.encode(Transaction).."' WHERE `identifier` = '"..identifier.."'")
    else
        print("Data not found")
    end
end

exports('GiveCredit', function(source, amount)
    GiveCredit(source, amount)
end)

exports('SendLog', function(source, received, sendedto, type, amount, pp)
    SendLog(source, received, sendedto, type, amount, pp)
end)

exports('SendOfflineLog', function(sendersource, identifier, playername, received, sendedto, type, amount, pp)
    SendOfflineLog(sendersource, identifier, playername, received, sendedto, type, amount, pp)
end)

exports('GetPassword', function(iban)
    GetPassword(iban)
end)

exports('GetIBAN', function(source, identifier, IsSoruce)
    GetIBAN(source, identifier, IsSoruce)
end)

function ExecuteSql(query)
    local IsBusy = true
    local result = nil
    if Config.MySQL == "oxmysql" then
        if MySQL == nil then
            exports.oxmysql:execute(
                query,
                function(data)
                    result = data
                    IsBusy = false
                end
            )
        else
            MySQL.query(
                query,
                {},
                function(data)
                    result = data
                    IsBusy = false
                end
            )
        end
    elseif Config.MySQL == "ghmattimysql" then
        exports.ghmattimysql:execute(
            query,
            {},
            function(data)
                result = data
                IsBusy = false
            end
        )
    elseif Config.MySQL == "mysql-async" then
        MySQL.Async.fetchAll(
            query,
            {},
            function(data)
                result = data
                IsBusy = false
            end
        )
    end
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end