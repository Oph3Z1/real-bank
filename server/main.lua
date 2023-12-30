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
        local checkdebts = CheckDebts()
        local dcpfp = GetDiscordAvatar(src)
        local data = ExecuteSql("SELECT * FROM `real_bank` WHERE `identifier` = '"..PlayerIdent.."'")
        local transferplayersdata = GetPlayers()

        if #data > 0 then
            if Config.CreditSystem == true then
                if StatusThing == 'donthave' then
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
                else
                    if checkdebts then
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
                    else
                        print("You do not have access to the bank because your debts have not been paid. Pay you'r debts and you get access to the bank system.")
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
                    PlayerCash = tonumber(PlayersCash)
                }
                cb(DataTable)
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
                    print('This account has been hacked so many times that it cannot be hacked anymore.')
                end
            else
                TriggerClientEvent('real-bank:Close', src)
                print('Wrong password')
            end
        else
            TriggerClientEvent('real-bank:Close', src)
            print('Wrong iban')
        end
    end)

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
                    print('This account has been hacked so many times that it cannot be hacked anymore.')
                end
            else
                TriggerClientEvent('real-bank:Close', src)
                print('Wrong password')
            end
        else
            TriggerClientEvent('real-bank:Close', src)
            print('Wrong iban')
        end
    end)
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
    Citizen.Wait(200)
    table.insert(GetSQLTable, CreateAccount)
end)

RegisterNetEvent('real-bank:ATMLoginOwnAccount', function(password)
    local src = source
    local PlayerIdent = GetIdentifier(src)
    local data = ExecuteSql("SELECT `password` FROM `real_bank` WHERE `identifier` = '"..PlayerIdent.."'")
    if data[1] then
        if tonumber(password) == tonumber(data[1].password) then
            TriggerClientEvent('real-bank:OpenBank', src)
        else
            print('Incorrect password')
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
                print('Player does not have enough credit points to get this credit')
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
        print('You already have active credit plan, you need to pay that first before you can get another credit')
    end
end)

RegisterNetEvent('real-bank:PayCreditDebts', function()
    print("kjasndkljaskjldnlaksjd")
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
            print("You don't have enough money to pay you'r debts")
        end
    elseif a.debt <= 0 or a.debt == 0 then
        print("You don't have enough money to pay you'r debts")
        StatusThing = 'donthave'
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
            print("You don't have enough money to pay you'r bills")
        end
    else
    end
end)

function CheckDebts()
    local ident = GetIdentifier(PlayerSource) 
    local data = ExecuteSql("SELECT `credit` FROM `real_bank` WHERE `identifier` = '"..ident.."'")
    local getdata = json.decode(data[1].credit)
    local getdatefromdata = getdata.creditlastdate
    local currenttime = GetCurrentDate()
    if getdata.debt > 0 then
        if getdatefromdata ~= 0 or getdatefromdata ~= '' or getdatefromdata ~= "" or getdatefromdata ~= nil then
            if tostring(currenttime) < tostring(getdatefromdata) then
                TriggerEvent('real-bank:PayCreditDebts')
                if StatusThing == true then
                    print('All your debts have been paid automatically because the due date has passed.')
                    return true
                elseif StatusThing == false then
                    return false
                elseif StatusThing == 'donthave' then
                    return true
                end
            else
                return true
            end
        else
            return true
        end
    else
        StatusThing = 'donthave'
    end
end

RegisterNetEvent('real-bank:SendLog', function(received, sendedto, type, amount, pp)
    local source = source
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
            else
                print('Not enough money on player')
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
            else
                print('Not enough money on you')
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
            else
                print('Not enough money on player')
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
            else
                print('Not enough money on you')
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
            else
                print('Not enough money on player')
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
            else
                print('Not enough money on you')
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
            else
                print('Not enough money on player')
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
            else
                print('Not enough money on you')
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
                print("Not enough money on the account")
            end
        else
            print("Amount must be higher than 0")
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
                local getplayeraccount = GetPlayerAccount(Player.PlayerData.citizenid)
                local gettargetplayer = frameworkObject.Functions.GetPlayerByCitizenId(v.identifier)
                local targetplayersource = frameworkObject.Functions.GetPlayer(gettargetplayer.PlayerData.source)
                
                if tonumber(playermoney) >= tonumber(amount) then
                    if gettargetplayer then
                        Player.Functions.RemoveMoney('bank', tonumber(amount))
                        targetplayersource.Functions.AddMoney('bank', tonumber(amount))
                    else
                        Player.Functions.RemoveMoney('bank', tonumber(amount))
                        local targetplayermoney = ExecuteSql("SELECT `money` FROM `players` WHERE `citizenid` = '"..v.identifier.."'")
                        local targetplayerbankmoney = json.decode(targetplayermoney[1].money)
                        targetplayerbankmoney.bank = tonumber(targetplayerbankmoney.bank) + tonumber(amount)
                        ExecuteSql("UPDATE `players` SET `money` = '"..json.encode(targetplayerbankmoney).."' WHERE  `citizenid` = '"..v.identifier.."'")
                    end
                end
            else
                local Player = frameworkObject.GetPlayerFromId(src)
                local playermoney = Player.getAccount('bank').money
                local getplayeraccount = GetPlayerAccount(Player.identifier)
                local gettargetplayer = frameworkObject.GetPlayerFromIdentifier(v.identifier)
                local targetplayersource = frameworkObject.GetPlayerFromId(gettargetplayer.source)
                
                if tonumber(playermoney) >= tonumber(amount) then
                    if gettargetplayer then
                        Player.removeAccountMoney('bank', tonumber(amount))
                        Citizen.Wait(100)
                        targetplayersource.addAccountMoney('bank', tonumber(amount))
                    else
                        Player.removeAccountMoney('bank', tonumber(amount))
                        local targetplayermoney = ExecuteSql("SELECT * FROM `users` WHERE `iban` = '"..iban.."'")
                        local targetplayerbankmoney = json.decode(targetplayermoney[1].accounts)
                        targetplayerbankmoney.bank = tonumber(targetplayerbankmoney.bank) + tonumber(amount)
                        ExecuteSql("UPDATE `users` SET `accounts` = '"..json.encode(targetplayerbankmoney).."' WHERE `identifier` = '"..v.identifier.."'")
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
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local Players = frameworkObject.Functions.GetPlayers()
        local resulttable = {}
        for k, v in pairs(Players) do
            GetPlayer = frameworkObject.Functions.GetPlayer(v)
            local PlayerCitizenid = GetPlayer.PlayerData.citizenid
            local data = ExecuteSql("SELECT * FROM `real_bank` WHERE `identifier` = '"..PlayerCitizenid.."'")
            if data or data[1] then
                local a = json.decode(data[1].info)
                table.insert(resulttable, {
                    id = #data + 1,
                    pp = a.playerpfp,
                    playername = a.playername,
                    iban = data[1].iban
                })
            end
        end
        return resulttable
    else
        local Players = frameworkObject.GetPlayers()
        local resulttable = {}
        for k, v in pairs(Players) do
            GetPlayer = frameworkObject.GetPlayerFromId(v)
            local PlayerIdentifier = GetPlayer.getIdentifier()
            local data = ExecuteSql("SELECT * FROM `real_bank` WHERE `identifier` = '"..PlayerIdentifier.."'")
            if data or data[1] then
                local a = json.decode(data[1].info)
                table.insert(resulttable, {
                    id = #data + 1,
                    pp = a.playerpfp,
                    playername = a.playername,
                    iban = data[1].iban
                })
            end
        end
        return resulttable
    end
end

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