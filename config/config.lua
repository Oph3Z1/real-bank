Config = {}

Config.Framework = 'autodetect' -- newesx, oldesx, newqb, oldqb, autodetect
Config.MySQL = 'oxmysql' -- oxmysql, ghamattimysql, mysql-async | Don't forget to edit fxmanifest.lua
Config.Drawtext = 'drawtext' -- bt-target, qb-target, drawtext, qtarget

Config.CardStyle = 1 -- '1' => 'img/FirstCard.png' | '2' => 'img/SecondCard.png'
Config.InvoiceTheme = 'blue' -- 'blue', 'lightblue', 'red', 'yellow'

Config.LoginLimit = 3 -- This number indicates the limit to which players can access other accounts.
Config.WithdrawLimit = 5000 -- The maximum amount of money a player can withdraw from another account.

Config.CreditSystem = true -- If 'true' players can use the credit system
Config.RequireCreditPoint = true -- If 'true' system will require credit point to withdraw money
Config.StartCreditPoint = 1000 -- Amount of creditpoint players will get at the beginning
Config.AvailableCredits = {
    {id = 'home1', type = 'Home', label = 'Cartfs Home Credit',  description = 'This is a normal loan and the amount is low',      price = 100000,  requiredcreditpoint = 300, paybacktime = 1, paybackpercent = 1.2}, -- paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks          
    {id = 'home2', type = 'Home', label = 'Premium Home Credit', description = 'This is a premium loan and the amount is high',    price = 1000000, requiredcreditpoint = 600, paybacktime = 2, paybackpercent = 1.4}, -- paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
    {id = 'home3', type = 'Home', label = 'Ultra Home Credit',   description = 'This is a ultra loan and the amount is very high', price = 2500000, requiredcreditpoint = 900, paybacktime = 4, paybackpercent = 1.6}, -- paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
    {id = 'car1',  type = 'Car',  label = 'Normal Car Credit',   description = 'This is a normal loan and the amount is low',      price = 50000,   requiredcreditpoint = 300, paybacktime = 1, paybackpercent = 1.2}, -- paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
    {id = 'car2',  type = 'Car',  label = 'Premium Car Credit',  description = 'This is a premium loan and the amount is high',    price = 150000,  requiredcreditpoint = 600, paybacktime = 2, paybackpercent = 1.4}, -- paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
    {id = 'car3',  type = 'Car',  label = 'Ultra Car Credit',    description = 'This is a ultra loan and the amount is very high', price = 400000,  requiredcreditpoint = 900, paybacktime = 4, paybackpercent = 1.6}, -- paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
    {id = 'open1', type = 'Open', label = 'Normal Open Credit',  description = 'This is a normal loan and the amount is low',      price = 25000,   requiredcreditpoint = 300, paybacktime = 1, paybackpercent = 1.2}, -- paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
    {id = 'open2', type = 'Open', label = 'Premium Open Credit', description = 'This is a premium loan and the amount is high',    price = 90000,   requiredcreditpoint = 600, paybacktime = 2, paybackpercent = 1.4}, -- paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
    {id = 'open3', type = 'Open', label = 'Ultra Open Credit',   description = 'This is a ultra loan and the amount is very high', price = 130000,  requiredcreditpoint = 900, paybacktime = 4, paybackpercent = 1.6}, -- paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
}

-- Fast Actions
Config.FirstFastAction = {type = 'withdraw', amount = 100}
Config.SecondFastAction = {type = 'deposit', amount = 500}
Config.ThirdFastAction = {type = 'withdraw', amount = 1000}

-- Discord Settings
Config.DiscordBotToken = 'OTMwODI3Mzg1MzI5MzA3NzMx.GQPatL.q0qjstbgFANq6d21rMjZK7A4v__UmNNxF0dti8' -- Discord bot token

Config.GetCreditCard = vector3(247.49, 223.2, 106.29)

Config.BankLocations = {
    [1] = {
        Coords = vector3(149.9, -1040.46, 29.37),
        Blipname = 'Bank',
        BlipType = 108,
        BlipColor = 2,
        BlipScale = 0.55
    },
    [2] = {
        Coords = vector3(314.23, -278.83, 54.17),
        Blipname = 'Bank',
        BlipType = 108,
        BlipColor = 2,
        BlipScale = 0.55
    },
    [3] = {
        Coords = vector3(-350.8, -49.57, 49.04),
        Blipname = 'Bank',
        BlipType = 108,
        BlipColor = 2,
        BlipScale = 0.55
    },
    [4] = {
        Coords = vector3(-1213.0, -330.39, 37.79),
        Blipname = 'Bank',
        BlipType = 108,
        BlipColor = 2,
        BlipScale = 0.55
    },
    [5] = {
        Coords = vector3(-2962.71, 483.0, 15.7),
        Blipname = 'Bank',
        BlipType = 108,
        BlipColor = 2,
        BlipScale = 0.55
    },
    [6] = {
        Coords = vector3(1175.07, 2706.41, 38.09),
        Blipname = 'Bank',
        BlipType = 108,
        BlipColor = 2,
        BlipScale = 0.55
    },
    [7] = {
        Coords = vector3(242.23, 225.06, 106.29),
        Blipname = 'Bank',
        BlipType = 108,
        BlipColor = 2,
        BlipScale = 0.55
    },
    [8] = {
        Coords = vector3(-113.22, 6470.03, 31.63),
        Blipname = 'Bank',
        BlipType = 108,
        BlipColor = 2,
        BlipScale = 0.55
    },
}

Config.ATMs = {
    "prop_atm_01",
    "prop_atm_02",
    "prop_atm_03",
    "prop_fleeca_atm"
}