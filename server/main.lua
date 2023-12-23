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
        local data = ExecuteSql("SELECT * FROM `real_bank` WHERE `identifier` = '"..PlayerIdent.."'")
        if #data > 0 then
            local a = json.decode(data[1].info)
            data[1].info = a
            cb(data)
        end
    end)
end)

RegisterNetEvent("real-bank:CreateAccount", function(password)
    local src = source
    local DiscordAvatar = GetDiscordAvatar(src)
    if Config.Framework == 'newesx' or Config.Framework == 'oldesx' then
        local Player = frameworkObject.GetPlayerFromId(src)
        CreateAccount = {
            identifier = GetIdentifier(src),
            info = {
                playername = Player.getName(),
                playermoney = Player.getAccount("bank").money,
                playerpfp = DiscordAvatar
            },
            credit = {},
            transaction = {},
            iban = math.random(1000, 9999),
            password = password,
            AccountUsed = 0
        }
    else
        local Player = frameworkObject.Functions.GetPlayer(src)
        CreateAccount = {
            identifier = GetIdentifier(src),
            info = {
                playername = GetName(src),
                playermoney = Player.PlayerData.money["bank"],
                playerpfp = DiscordAvatar
            },
            credit = {},
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
        TriggerClientEvent('real-bank:CheckAccountExistensResult', source, true, data)
    else 
        TriggerClientEvent('real-bank:CheckAccountExistensResult', source, false, data)
    end
end)

RegisterNetEvent('real-bank:SendLog', function(received, sendedto, type, amount, pp)
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
        else
            pp = pp
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