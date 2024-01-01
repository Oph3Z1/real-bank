Config = {}

Config.Framework = 'autodetect' -- newesx, oldesx, newqb, oldqb, autodetect
Config.MySQL = 'oxmysql' -- oxmysql, ghamattimysql, mysql-async | Don't forget to edit fxmanifest.lua
Config.Drawtext = 'qb-target' -- qb-target, drawtext

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

Config.Language = {
    -- UI
    ['confirm'] = 'Confirm',
    ['login_with_iban'] = 'Want to login with iban?',
    ['login_with_normal'] = 'Want to login with your account?',
    ['welcome'] = 'Welcome to the City Bank!',
    ['dashboard'] = 'Dashboard',
    ['invoices'] = 'Invoices',
    ['credits'] = 'Credits',
    ['send'] = 'Send',
    ['withdraw'] = 'Withdraw',
    ['deposit'] = 'Deposit',
    ['logout'] = 'Log Out',
    ['fast_actions'] = 'Fast Actions',
    ['send_money'] = 'Send Money',
    ['send_money_desc'] = 'You can send money to others in this section!',
    ['user'] = 'User',
    ['select'] = 'Select',
    ['your_invoices'] = 'Your Invoices',
    ['invoices_desc'] = 'You can check and pay your bills in this section!',
    ['pay'] = 'Pay',
    ['no_invoices'] = "You don't have an invoice",
    ['get_credit'] = 'Get Credit',
    ['get_credit_desc'] = 'Unlock financial possibilities with our hassle-free loan options. Borrow the money you need and repay it later.',
    ['select_credit'] = 'Select Credit',
    ['accept'] = 'Accept',
    ['get_money'] = 'Get Money',
    ['home_credit'] = 'Home Credit',
    ['home_credit_desc'] = 'Different types of mortgage loans if you want to buy a house',
    ['car_credit'] = 'Car Credit',
    ['car_credit_desc'] = 'Different types of car/installment loans if you want to buy a vehicle',
    ['open_credit'] = 'Open Credit',
    ['open_credit_desc'] = 'Different types of open credit where you can do anything',
    ['credit_mini_desc'] = 'Select the loan that suits you below. And please look twice before you approve everything. There is no turning back.',
    ['credit_warning_text'] = 'Read everything and think carefully before you approve. Once you approve, there is no going back!',
    ['withdrawed_money'] = 'Withdrawed Money!',
    ['already_have_credit'] = 'You already have a credit plan',
    ['active_credit_information_text'] = 'Here you can take a look at information about your current credit plan.',
    ['general_information'] = 'GENERAL INFORMATION: If you do not pay your credit on time, your account will be blocked and you will not be able to log in until you pay your credit. If you have enough money, it will pay automatically when you log in.',
    ['personal_balance'] = 'Personal Balance',
    ['debts'] = 'Debts',
    ['credit_point'] = 'Credit Point',
    ['monthly'] = 'Monthly',
    ['last_transactions'] = 'Last Transactions',
    ['withdrawed'] = 'Withdrawed',
    ['deposited'] = 'Deposited',
    ['shopping'] = 'Shopping',
    ['twofactorauth'] = 'Two-Factor Authentication',
    ['create_password'] = 'Create Password',
    ['change_password'] = 'Change Password',
    ['enter_eightdigit'] = 'Please enter your 8-digit password',

    -- UI Notification Translate
    ['not_enough_creditpoint'] = "You don't have enough credit point to withdraw money. Required Credit Point: ",
    ['debts_paid'] = 'Congrats! You paid your debts!',
    ['no_money_to_pay_debts'] = "You don't have enough money to pay your debts!",
    ['enter_amount'] = 'You need to enter a amount!',
    ['cant_see_invoices'] = 'You cant see Invoices because you are not the owner of this account',
    ['successfully_deposited'] = 'You successfully deposited money',
    ['successfylly_withdrawed'] = 'You successfully withdrawed money',
    ['no_money'] = "You don't have enough money",
    ['cant_deposit_hackedaccount'] = "You can't deposit money into a hacked account",
    ['successfylly_withdrawed_hackedaccount'] = 'You successfully withdrawed money from this account',
    ['hackedaccount_no_money'] = 'The account has not enough money',
    ['successfully_transfered'] = 'You successfully transfered money',
    ['transfer_no_money'] = "You don't have enough money to transfer",

    -- Client/Server - Notify
    ['already_have_account'] = 'You already have an account',
    ['no_account'] = "You don't have an account. Please create one first",
    ['cant_access_to_the_bank_debts'] = "You do not have access to the bank because your debts have not been paid. Pay you'r debts and you get access to the bank system.",
    ['change_password_to_access'] = 'Your account has been hacked! You need to change your password to log in again.',
    ['cant_hack_anymore'] = 'This account has been hacked so many times that it cannot be hacked anymore',
    ['wrong_password'] = 'Wrong password!',
    ['wrong_iban'] = 'Wrong IBAN!',
    ['not_enough_cp'] = 'Player does not have enough credit points to get this credit',
    ['already_active_cp'] = 'You already have active credit plan, you need to pay that first before you can get another credit',
    ['no_money_to_pay_bills'] = "You don't have enough money to pay you'r bills",
    ['paid_your_debts'] = 'All your debts have been paid automatically because the due date has passed.',
    ['not_enough_money'] = 'Not enough money on you',
    ['successfully_created_account'] = "You have successfully created an account",
}

Config.Notification = function(msg, type, server, src)
    if server then
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            TriggerClientEvent('QBCore:Notify', src, msg, type, 3000)
        else
            TriggerClientEvent('esx:showNotification', src, msg)
        end
    else
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            TriggerEvent('QBCore:Notify', msg, type, 3000)
        else
            TriggerEvent('esx:showNotification', msg)
        end
    end
end