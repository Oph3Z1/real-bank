frameworkObject = nil
GetSQLTable = {}

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
    end
    GetSQLTable = data
end)

Citizen.CreateThread(function()
    RegisterCallback("real-bank:GetPlayerData", function(source, cb)
        local src = source
        local PlayerIdent = GetIdentifier(src)
        local PlayerMoney = GetPlayerMoneyOnline("bank", src)
        local data = ExecuteSql("SELECT * FROM `real_bank` WHERE `identifier` = '"..PlayerIdent.."'")
        if #data > 0 then
            local a = json.decode(data[1].info)
            local b = json.decode(data[1].credit)
            data[1].info = a
            data[1].credit = b
            DataTable = {
                data = data,
                PlayerMoney = tonumber(PlayerMoney)
            }
            cb(DataTable)
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
            AccountUsed = 0
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
            AccountUsed = 0
        }
    end
    ExecuteSql("INSERT INTO `real_bank` (`identifier`, `info`, `credit`, `transaction`, `iban`, `password`, `AccountUsed`) VALUES ('"..CreateAccount.identifier.."', '"..json.encode(CreateAccount.info).."', '"..json.encode(CreateAccount.credit).."', '"..json.encode(CreateAccount.transaction).."', '"..CreateAccount.iban.."', '"..CreateAccount.password.."', '"..CreateAccount.AccountUsed.."')")
    Citizen.Wait(200)
    table.insert(GetSQLTable, CreateAccount)
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
    local src =  source
    local ident = GetIdentifier(src)
    local data = ExecuteSql("SELECT `credit` FROM `real_bank` WHERE `identifier` = '"..ident.."'")
    local GetPlayerMoney = GetPlayerMoneyOnline('bank', src)
    local a = json.decode(data[1].credit)
    
    if GetPlayerMoney > a.debt then
        NewCreditTable = {
            playercreditpoint =  a.playercreditpoint,
            activecredit = '',
            creditlastdate = 0,
            debt = 0,
        }
        ExecuteSql("UPDATE `real_bank` SET `credit` = '"..json.encode(NewCreditTable).."' WHERE `identifier` = '"..ident.."'")
        RemoveAddBankMoneyOnline('remove', tonumber(a.debt), src)
    else
        print("You don't have enough money to pay you'r debts")
    end
end)

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
            return k, v
        else
            return false
        end
    end
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
        local Player = frameworkObject.Functions.GetPlayer(id)
        if type == 'bank' then
            return tonumber(Player.PlayerData.money.bank)
        elseif type == 'cash' then
            return tonumber(Player.PlayerData.money.cash)
        end
    elseif Config.Framework == 'newesx' or Config.Framework == 'oldesx' then
        local Player = frameworkObject.GetPlayerFromId(id)
        if type == 'bank' then
            return tonumber(Player.getAccount('bank').money)
        elseif type == 'cash' then
            return tonumber(Player.getMoney())
        end
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