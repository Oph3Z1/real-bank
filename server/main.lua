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
    end
    GetSQLTable = data
end)

RegisterNetEvent("real-bank:CreateAccount", function(password)
    local CreateAccount = {
        identifier = GetIdentifier(source),
        credit = {},
        transaction = {},
        iban = math.random(1000, 9999),
        password = password,
        AccountUsed = 0
    }
    ExecuteSql("INSERT INTO `real_bank` (`identifier`, `credit`, `transaction`, `iban`, `password`, `AccountUsed`) VALUES ('"..CreateAccount.identifier.."', '"..json.encode(CreateAccount.credit).."', '"..json.encode(CreateAccount.transaction).."', '"..CreateAccount.iban.."', '"..CreateAccount.password.."', '"..CreateAccount.AccountUsed.."')")
    Citizen.Wait(200)
    table.insert(GetSQLTable, CreateAccount)
end)

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
    local identifier = identifier
    for k, v in pairs(GetSQLTable) do
        if v.identifier == identifier then
            return k, v
        end
    end
    return false
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