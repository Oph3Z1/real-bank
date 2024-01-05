const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : "real-bank";

window.postNUI = async (name, data) => {
    try {
        const response = await fetch(`https://${resourceName}/${name}`, {
            method: "POST",
            mode: "cors",
            cache: "no-cache",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/json"
            },
            redirect: "follow",
            referrerPolicy: "no-referrer",
            body: JSON.stringify(data)
        });
        return !response.ok ? null : response.json();
    } catch (error) {
        // console.log(error)
    }
};

const store = Vuex.createStore({
    state: {},
    mutations: {},
    actions: {}
});

const app = Vue.createApp({
    data: () => ({
        show: false,
        chartData: null,
        GetChart: null,
        CurrentScreen: '', // 'Password' - 'BankScreen' - 'IBAN'
        PasswordScreenType: 'Normal', // 'Normal' - 'Create' - 'Change'
        CurrentMenu: 'Dashboard',
        PinInput: '',
        CardStyle: 1, // '1' - '2'
        FirstFastAction: {type: 'deposit', amount: 500}, // type --> 'deposit' - 'withdraw'
        SecondFastAction: {type: 'withdraw', amount: 500}, // type --> 'deposit' - 'withdraw'
        ThirdFastAction: {type: 'deposit', amount: 1500}, // type --> 'deposit' - 'withdraw'
        DWPopup: false,
        DWType: null,
        MiddleMenuSection: 'Main', // 'Main' - 'Transfer' - 'Invoices' - 'Credit'
        DWInput: '',
        Logintype: '',
        ShowPin: false,
        SearchPlayers: [
            {id: 1,  firstname: 'Oph3Z', lastname: 'Test', iban: 2001,  pp: './img/example-logo.png'},
            {id: 2,  firstname: 'Yusuf', lastname: 'Test', iban: 2002,  pp: './img/second-example-logo.png'},
            {id: 3,  firstname: 'Oph3Z', lastname: 'Test', iban: 2003,  pp: './img/example-logo.png'},
            {id: 4,  firstname: 'Yusuf', lastname: 'Test', iban: 2004,  pp: './img/second-example-logo.png'},
            {id: 5,  firstname: 'Oph3Z', lastname: 'Test', iban: 2005,  pp: './img/example-logo.png'},
            {id: 6,  firstname: 'Yusuf', lastname: 'Test', iban: 2006,  pp: './img/second-example-logo.png'},
            {id: 7,  firstname: 'Oph3Z', lastname: 'Test', iban: 2007,  pp: './img/third-example-logo.png'},
            {id: 8,  firstname: 'Yusuf', lastname: 'Test', iban: 2008,  pp: './img/second-example-logo.png'},
            {id: 9,  firstname: 'Oph3Z', lastname: 'Test', iban: 2009,  pp: './img/example-logo.png'},
            {id: 10, firstname: 'Yusuf', lastname: 'Test', iban: 2010,  pp: './img/second-example-logo.png'},
        ],
        SearchBar: '',
        SelectPlayer: false,
        transferInput: '',
        Invoices: [
            {id: 1, invoicename: 'LSPD', price: 100000, description:'You have been fined for driving at high speed', type: 'lspd'},
            {id: 2, invoicename: 'EMS', price: 100000, description:'All your costs in the hospital', type: 'ems'},
            {id: 3, invoicename: 'Yusuf Karaçolak', price: 100000, description:'Sender description', type: 'player'},
            {id: 4, invoicename: 'Mechanic', price: 100000, description:'Fixed your car', type: 'company'},
        ],
        SelectCreditType: null, // Dont Touch
        RequireCreditPoint: true, // true => System will require credit point to withdraw money via credit system | false => System will not check credit point to withdraw money via credit system
        SelectCredit: null, // Dont Touch
        SelectedCreditPrice: 0, // Dont Touch
        SelectedCreditReq: false, // Dont Touch
        ConfirmCredit: false, // Dont Touch
        CreditLastDate: null, // Dont Touch
        CreditPayback: null,
        CredType: null,
        CurrentActiveCredit: null,
        Billstheme: '',
        Billsframe: '',
        IBANInput: '',
        PasswordInput: '',
        CreditSystem: true,
        HackedAccountWithdrawLimit: 0,
        HackedAccountUsage: 0,
        AvailableCredits: [
            {id: 1, type: 'Home', label: 'Normal Home Credit',  description: 'This is a normal loan and the amount is low',      price: 100000,  requiredcreditpoint: 300, paybacktime: 1, paybackpercent: 1.2}, // paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks          
            {id: 2, type: 'Home', label: 'Premium Home Credit', description: 'This is a premium loan and the amount is high',    price: 1000000, requiredcreditpoint: 600, paybacktime: 2, paybackpercent: 1.4}, // paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
            {id: 3, type: 'Home', label: 'Ultra Home Credit',   description: 'This is a ultra loan and the amount is very high', price: 2500000, requiredcreditpoint: 900, paybacktime: 4, paybackpercent: 1.6}, // paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
            {id: 4, type: 'Car',  label: 'Normal Car Credit',   description: 'This is a normal loan and the amount is low',      price: 50000,   requiredcreditpoint: 300, paybacktime: 1, paybackpercent: 1.2}, // paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
            {id: 5, type: 'Car',  label: 'Premium Car Credit',  description: 'This is a premium loan and the amount is high',    price: 150000,  requiredcreditpoint: 600, paybacktime: 2, paybackpercent: 1.4}, // paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
            {id: 6, type: 'Car',  label: 'Ultra Car Credit',    description: 'This is a ultra loan and the amount is very high', price: 400000,  requiredcreditpoint: 900, paybacktime: 4, paybackpercent: 1.6}, // paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
            {id: 7, type: 'Open', label: 'Normal Open Credit',  description: 'This is a normal loan and the amount is low',      price: 25000,   requiredcreditpoint: 300, paybacktime: 1, paybackpercent: 1.2}, // paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
            {id: 8, type: 'Open', label: 'Premium Open Credit', description: 'This is a premium loan and the amount is high',    price: 90000,   requiredcreditpoint: 600, paybacktime: 2, paybackpercent: 1.4}, // paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
            {id: 9, type: 'Open', label: 'Ultra Open Credit',   description: 'This is a ultra loan and the amount is very high', price: 130000,  requiredcreditpoint: 900, paybacktime: 4, paybackpercent: 1.6}, // paybackpercent --> 1 = 100%, 2 = 200%   ∥    paybacktime --> weeks  
        ],
        PlayersCreditPoint: 1000, // Players current credit point - dont touch
        PlayersMoney: 19500321, // Players current money - dont touch
        Debts: 350000, // Players debts (The amount the player need to pay back due to credit/loan) - dont touch
        PlayersName: '', // Players name and lastname - dont touch
        PlayersProfilePicture: './img/example-logo.png',
        PlayerIBAN: 0,
        PlayerCash: 0,
        LastTransactions: [ // Type => 'Received' - 'Withdraw' - 'Deposit' - 'Transfer' - 'Shopping'
            {id: 1, name: 'Oph3Z Test', received: '', sendedto: 'Yusuf Karaçolak', type: 'Transfer', amount: 1000,  pp: './img/second-example-logo.png', date: '10.07.2023'},
            {id: 2, name: 'Oph3Z Test', received: 'Oph3Z Test2', sendedto: 'Yusuf Karaçolak', type: 'Received', amount: 1250,  pp: './img/second-example-logo.png', date: '10.08.2023'},
            {id: 3, name: 'Oph3Z Test', received: '', sendedto: 'Yusuf Karaçolak', type: 'Withdraw', amount: 1200,  pp: './img/second-example-logo.png', date: '10.01.2023'},
            {id: 4, name: 'Oph3Z Test', received: '', sendedto: 'Yusuf Karaçolak', type: 'Withdraw', amount: 890,   pp: './img/second-example-logo.png', date: '10.04.2023'},
            {id: 5, name: 'Oph3Z Test', received: '', sendedto: 'Yusuf Karaçolak', type: 'Withdraw', amount: 550,   pp: './img/second-example-logo.png', date: '10.02.2023'},
            {id: 6, name: 'Oph3Z Test', received: '', sendedto: 'Yusuf Karaçolak', type: 'Withdraw', amount: 500,   pp: './img/second-example-logo.png', date: '10.01.2023'},
            {id: 6, name: 'Oph3Z Test', received: '', sendedto: 'Yusuf Karaçolak', type: 'Withdraw', amount: 500,   pp: './img/second-example-logo.png', date: '10.12.2023'},
        ],
        NotifyActive: false,
        NotifyBGColor: '',
        NotifyText: '',
        Language: '',
    }),

    methods: {
        PE3D(s) {
            s = parseInt(s)
            return s.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
        },
        
        SelectActionMethod(status, type) {
            this.DWPopup = status
            this.DWType = type
            this.DWInput = ''
        },

        CheckAnimationStatus() {
            if (this.DWPopup) {
                return true
            } else {
                return false
            }
        },

        CheckSearchBarEquality(player) {
            const search = this.SearchBar.toLowerCase();
            const fullName = (player.playername).toLowerCase();
            const iban = player.iban.toString();
        
            return (
                fullName.includes(search) || 
                iban.includes(search) || 
                !isNaN(search) && iban.includes(search)    
            );
        },

        SelectTransferPlayer(id) {
            if (this.SelectPlayer == null || this.SelectPlayer == undefined || this.SelectPlayer == false || this.SelectPlayer < 0) {
                this.SelectPlayer = id;
            } else if (this.SelectPlayer == id) {
                this.SelectPlayer = null;
            }
        },
        

        GetSelectedCreditIMG(type) {
            if (type == 'Home') {
                return `./img/House-icon.png`;
            } else if (type == 'Car') {
                return `./img/Car-icon.png`;
            } else if (type == 'Open') {
                return `./img/Withdraw-icon.png`;
            }
        },

        CalculateCreditPercent(percent) {
            if (percent == 1.1) {
                return '10%';
            } else if (percent == 1.2) {
                return '20%';
            } else if (percent == 1.3) {
                return '30%';
            } else if (percent == 1.4) {
                return '40%';
            } else if (percent == 1.5) {
                return '50%';
            } else if (percent == 1.6) {
                return '60%';
            } else if (percent == 1.7) {
                return '70%';
            } else if (percent == 1.8) {
                return '80%';
            } else if (percent == 1.9) {
                return '90%';
            } else if (percent == 2.0) {
                return '100%';
            }
        }, 

        SelectCreditFunction(id, price, creditreq, date, payback, credid) {
            this.SelectCredit = id
            this.SelectedCreditPrice = price
            this.SelectedCreditReq = creditreq
            this.CreditLastDate = date
            this.CreditPayback = payback
            this.CredType = credid
        },

        ConfirmCreditWithdraw() {
            if (this.RequireCreditPoint) {
                if (this.PlayersCreditPoint >= this.SelectedCreditReq) {
                    postNUI('ConfirmCredit', {
                        credprice: this.SelectedCreditPrice,
                        credreq:  this.SelectedCreditReq,
                        creddate:  this.CreditLastDate,
                        credpaybackpercent: this.CreditPayback,
                        credid: this.CredType
                    })
                    this.PlayersMoney += this.SelectedCreditPrice
                    this.PlayersCreditPoint -= this.SelectedCreditReq
                    this.Debts = this.SelectedCreditPrice * this.CreditPayback
                    this.ConfirmCredit = true
                } else {
                    this.ShowNotify('red', this.Language['not_enough_creditpoint'] + this.SelectedCreditReq, 3000)
                }
            } else {
                postNUI('ConfirmCredit', {
                    credprice: this.SelectedCreditPrice,
                    credreq:  this.SelectedCreditReq,
                    creddate:  this.CreditLastDate,
                    credpaybackpercent: this.CreditPayback,
                    credid: this.CredType
                })
                this.PlayersMoney += this.SelectedCreditPrice
                this.PlayersCreditPoint -= this.SelectedCreditReq
                this.Debts = this.SelectedCreditPrice * this.CreditPayback
                this.ConfirmCredit = true
            }
        }, 

        ClearAll() {
            this.ConfirmCredit = false
            this.SelectCredit = null
            this.SelectedCreditPrice = 0
            this.SelectedCreditReq = false
            this.SelectCreditType = null
            this.CreditLastDate = null
            this.CreditPayback = null
            this.CredType = null
            this.MiddleMenuSection = 'Main'
        },

        DebtsCurrency(value) {
            const formatter = new Intl.NumberFormat('en-US', {
              style: 'currency',
              currency: 'USD',
              minimumFractionDigits: 0,
              maximumFractionDigits: 0
            });
  
            if (value >= 1000000) {
                return (value / 1000000).toFixed(1) + 'M';
            } else if (value >= 1000) {
                return formatter.format(value / 1000) + 'K';
            } else {
                return formatter.format(value);
            }
        },

        PayDebts() {
            if (this.PlayersMoney >= this.Debts) {
                this.PlayersMoney -= this.Debts
                this.Debts = 0
                postNUI('PayDebts')
                this.ShowNotify('green', this.Language['debts_paid'], 3000)
            } else {
                this.ShowNotify('red', this.Language['no_money_to_pay_debts'], 5000)
            }
        },

        PasswordScreenTypeFunction(type) {
            if (type == 'First') {
                if (this.PasswordScreenType == 'Normal') {
                    return this.Language['twofactorauth']
                } else if (this.PasswordScreenType == 'Create') {
                    return this.Language['create_password']
                } else if (this.PasswordScreenType == 'Change') {
                    return this.Language['change_password']
                }
            } else {
                if (this.PasswordScreenType == 'Normal') {
                    return this.Language['enter_eightdigit']
                } else if (this.PasswordScreenType == 'Create') {
                    return this.Language['enter_eightdigit']
                } else if (this.PasswordScreenType == 'Change') {
                    return this.Language['enter_eightdigit']
                }
            }
        },

        GetResponse() {
            postNUI("GetResponse")
        },

        CreateChart() {
            this.chartData = this.ChartDataFunction;

            var ctx = document.getElementById('chart').getContext('2d');
            this.GetChart = new Chart(ctx, {
                type: 'line',
                data: this.chartData,
                options: {
                    scales: {
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                font: {
                                    weight: 'bold',
                                    color: 'black'
                                }
                            }
                        },
                        y: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                font: {
                                    weight: 'bold',
                                    color: 'red'
                                }
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false,
                        }
                    }
                }
            });
        },

        ConfirmPassword() {
            if (this.PasswordScreenType == 'Create') {
                if (this.PinInput.toString().length == 8) {
                    postNUI("CreatePassword", this.PinInput)
                    this.show = false
                    this.CurrentScreen = ''
                    this.PasswordScreenType = ''
                    this.PinInput = ''
                } else {
                    this.ShowNotify('red', this.Language['enter_eightdigit'], 3000)
                }
            } else if (this.PasswordScreenType == 'Change') {
                if (this.PinInput.toString().length == 8) {
                    postNUI("ChangePassword", this.PinInput)
                    this.show = false
                    this.CurrentScreen = ''
                    this.PasswordScreenType = ''
                    this.PinInput = ''
                } else {
                    this.ShowNotify('red', this.Language['enter_eightdigit'], 3000)
                }
            } else if (this.PasswordScreenType == 'Normal') {
                postNUI('ATMLoginToOwnAccount', this.PinInput)
                this.show = false
                this.CurrentScreen = ''
                this.PinInput = ''
            }
        },

        ConfirmLoginAnotherAccount() {
            if (this.IBANInput > 0 && this.PasswordInput > 0) {
                postNUI('ATMLoginAnotherAccount', {
                    iban: this.IBANInput,
                    password: this.PasswordInput
                })
                this.show = false
                this.CurrentScreen = ''
                this.PasswordInput = ''
                this.IBANInput = ''
                this.PasswordScreenType = 'Normal'
            }
        },

        LogOut() {
            postNUI("Logout")
            this.show = false
            this.CurrentScreen = ''
            this.MiddleMenuSection = 'Main'
            this.DWType = null
            this.DWPopup = false
            this.DWInput = ''
            this.PinInput = ''
            this.SelectCreditType = null
            this.SelectCredit = null
            this.SelectedCreditPrice = 0
            this.SelectedCreditReq = false
            this.CreditPayback = null
            this.CreditLastDate = null
            this.ConfirmCredit = false
            this.CredType = null
            this.SearchBar = ''
            this.SelectPlayer = false
            this.Logintype = ''
            this.transferInput = ''
            this.chartData = null
            this.GetChart = null
        },

        DWAction() {
            if (this.DWType == 'deposit') {
                if (this.DWInput.toString().length > 0 ) {
                    postNUI("DepositMoney", this.DWInput)
                } else {
                    this.ShowNotify('red', this.Language['enter_amount'], 3000)
                }
            }
        },

        ChangeMiddleSection(type) { // 'Main' - 'Transfer' - 'Invoices' - 'Credit'
            if (type == 'Main') {
                this.MiddleMenuSection = 'Main'
            } else if (type == 'Transfer') {
                if (this.Logintype != 'hacker') {
                    this.MiddleMenuSection = 'Transfer'
                } else {
                    this.ShowNotify('red', this.Language['cant_see_invoices'], 5000)
                }
            } else if (type == 'Invoices') {
                if (this.Logintype != 'hacker') {
                    this.MiddleMenuSection = 'Invoices'
                }
            } else if (type == 'Credit') {
                if (this.Logintype != 'hacker') {
                    this.MiddleMenuSection = 'Credit'
                } else {
                    this.ShowNotify('red', this.Language['cant_see_invoices'], 5000)
                }
            }
            
            if (type != 'credit') {
                this.SelectCreditType = null
                this.SelectCredit = null
                this.SelectedCreditPrice = 0
                this.SelectedCreditReq = false
            }
        },

        UpdateTransaction(id) {
            this.LastTransactions = id

            if (this.GetChart) {
                this.GetChart.destroy()
            }

            setTimeout(() => {
                this.CreateChart();
            }, 10);
        },

        SelectCreditTypeFunction(type) {
            this.SelectCreditType = type

            this.SelectCredit = null
            this.SelectedCreditPrice = 0
            this.SelectedCreditReq = false
            this.CreditLastDate = null
            this.CreditPayback = null
            this.CredType = null
        },

        FindLabel(value) {
            const filter = this.AvailableCredits.find(data => data.id === value)
            if (filter) {
                return filter.label
            } else {
                return null
            }
        },

        PayBill(id, amount) {
            postNUI('PayBill', {id, amount})
        },

        DepositWithdrawAction() {
            if (this.Logintype != 'hacker') {
                if (this.DWType == 'deposit') {
                    if (this.DWInput > 0) {
                        if (this.PlayerCash >= this.DWInput) {
                            postNUI('DepositMoney', this.DWInput)
                            this.PlayersMoney += this.DWInput
                            this.SelectActionMethod(false, '')
                            this.ShowNotify('green', this.Language['successfully_deposited'], 4000)
                        } else {
                            this.ShowNotify('red', this.Language['no_money'], 4000)
                        }
                    } else {
                        this.ShowNotify('red', "Enter a number", 3000)
                    }
                } else if (this.DWType == 'withdraw') {
                    if (this.DWInput > 0) {
                        if (this.PlayersMoney >= this.DWInput) {
                            postNUI('WithdrawMoney', this.DWInput)
                            this.PlayersMoney -= this.DWInput
                            this.SelectActionMethod(false, '')
                            this.ShowNotify('green', this.Language['successfylly_withdrawed'], 4000)
                        } else {
                            this.ShowNotify('red', this.Language['no_money'], 4000)
                        }
                    } else {
                        this.ShowNotify('red', this.Language['enter_amount'], 3000)
                    }
                }
            } else {
                if (this.DWType == 'deposit') {
                    this.ShowNotify('red', this.Language['cant_deposit_hackedaccount'], 4000)
                } else if (this.DWType == 'withdraw') {
                    if (this.DWInput > 0) {
                        if (this.PlayersMoney >= this.DWInput) {
                            if (this.HackedAccountUsage > 0) {
                                if (this.HackedAccountWithdrawLimit >= this.DWInput) {
                                    postNUI('WithdrawHackedAccount', {
                                        iban: this.PlayerIBAN,
                                        amount: this.DWInput
                                    })
                                    this.PlayersMoney -= this.DWInput
                                    this.HackedAccountWithdrawLimit -= this.DWInput
                                    this.SelectActionMethod(false, '')
                                    this.ShowNotify('green', this.Language['successfylly_withdrawed_hackedaccount'], 4000)
                                }
                            }
                        } else {
                            this.ShowNotify('red', this.Language['hackedaccount_no_money'], 4000)
                        }
                    } else {
                        this.ShowNotify('red', this.Language['enter_amount'], 3000)
                    }
                }
            }
        },

        FastAction(type, amount) {
            if (amount > 0) {
                if (type == 'withdraw') {
                    if (this.PlayersMoney >= amount) {
                        postNUI('WithdrawFastAction', amount)
                        this.PlayersMoney -= amount
                        this.PlayerCash += amount
                        this.ShowNotify('green', this.Language['successfylly_withdrawed'], 4000)
                    } else {
                        this.ShowNotify('red', this.Language['no_money'], 4000)
                    }
                } else if (type == 'deposit') {
                    if (this.PlayerCash >= amount) {
                        postNUI('DepositFastAction', amount)
                        this.PlayersMoney += amount
                        this.PlayerCash -= amount
                        this.ShowNotify('green', this.Language['successfully_deposited'], 4000)
                    } else {
                        this.ShowNotify('red', this.Language['no_money'], 4000)
                    }
                }
            }
        },

        TransferMoney(id, iban) {
            if (this.transferInput > 0) {
                if (this.PlayersMoney > this.transferInput) {
                    postNUI('TransferMoney', {
                        iban: iban,
                        amount: this.transferInput
                    })
                    this.PlayersMoney -= this.transferInput
                    this.transferInput = ''
                    this.SelectTransferPlayer(id)
                    this.ShowNotify('green', this.Language['successfully_transfered'], 4000)
                } else {
                    this.ShowNotify('red', this.Language['transfer_no_money'], 4000)
                }
            } else {
                this.ShowNotify('red', this.Language['enter_amount'], 4000)
            }
        },

        ChangePasswordScreen(type) {
            this.CurrentScreen = type
            this.PinInput = ''
            this.IBANInput = ''
            this.PasswordInput = ''
        },

        ShowNotify(color, text, time) {
            if (color != '' || !color) {
                if (text != '' || !text) {
                    this.NotifyActive = true
                    this.NotifyBGColor = color
                    this.NotifyText = text
                    
                    if (!time || time == 0 || time == '') {
                        time =  4000
                    }

                    setTimeout(() => {
                        this.NotifyActive = false
                        this.NotifyBGColor = ''
                        this.NotifyText = ''
                    }, time)
                } else {
                    console.log("There is a problem with notify text")
                }
            } else {
                console.log("There is a problem with notify color")
            }
        },
    },  

    computed: {
        SearchBarFunction() {
            if (!this.SearchBar) {
                return this.SearchPlayers.filter((player) => player.iban !== this.PlayerIBAN);
            }

            return this.SearchPlayers.filter((player) => player.iban !== this.PlayerIBAN && this.CheckSearchBarEquality(player))
        },

        ShowAvailableCredits() {
            return this.AvailableCredits.filter(credit => credit.type === this.SelectCreditType);
        },

        ChartDataFunction() {
            const allMonths = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];

            const monthlyWithdrawals = this.LastTransactions
            .filter(transaction => transaction.type === 'Withdraw' || transaction.type === 'Transfer')
            .sort((a, b) => {
                const dateA = new Date(a.date.split('.').reverse().join('-'));
                const dateB = new Date(b.date.split('.').reverse().join('-'));
                return dateA - dateB;
            })
            .reduce((acc, transaction) => {
                const month = transaction.date.split('.')[1];
                acc[month] = (acc[month] || 0) + transaction.amount;
                return acc;
            }, {});

            const chartDataValues = allMonths.map(month => monthlyWithdrawals[month] || 0);

            var ctx = document.getElementById('chart').getContext('2d');
            var gradient = ctx.createLinearGradient(0, 0, 0, 400);
            gradient.addColorStop(0, '#9E5EC7');
            gradient.addColorStop(1, 'rgba(158, 94, 199, 0.01)');

            return {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [{
                    label: '$',
                    data: chartDataValues,
                    fill: true,
                    backgroundColor: gradient,
                    borderColor: '#9E5EC7',
                    tension: 0.1
                }],
            }
        },

        FontSize() {
            const length = Math.max(...this.LastTransactions.map(data => data.amount.toString().length));

            if (length <= 3) {
                return { 'font-size': '1.1257vw' };
            } else if (length <= 6) {
                return { 'font-size': '1.0257vw' };
            } else if (length <= 7) {
                return { 'font-size': '1.0257vw' };
            } else if (length >= 8) {
                return { 'font-size': '.9257vw' };
            } else {
                return { 'font-size': 'inherit' };
            }
        },
    },

    watch: {
    
    },

    beforeDestroy() {
        window.removeEventListener('keyup', this.onKeyUp);
    },

    mounted() {
        window.addEventListener("message", event => {
            const data = event.data;
            if (data.action == 'OpenPasswordScreen') {
                this.show = true
                this.CurrentScreen = 'Password'
                this.PasswordScreenType = 'Normal'
            } 

            if (data.action == 'OpenCreatePasswordScreen') {
                this.show = true
                this.CurrentScreen = 'Password'
                this.PasswordScreenType = 'Create'
            } 

            if (data.action == 'OpenChangePasswordScreen') {
                this.show = true
                this.CurrentScreen = 'Password'
                this.PasswordScreenType = 'Change'
            }

            if (data.action == 'OpenBank') {
                const PlayerData = data.data[0]
                const info = PlayerData.info
                const credit = PlayerData.credit

                this.show = true
                this.CurrentScreen = 'BankScreen'
                this.PlayersMoney = data.playermoney
                this.PlayersName = info.playername
                this.PlayerIBAN = PlayerData.iban
                this.PlayersProfilePicture = info.playerpfp
                this.LastTransactions = JSON.parse(PlayerData.transaction)
                this.PlayersCreditPoint = credit.playercreditpoint
                this.Debts = credit.debt
                this.CreditLastDate = credit.creditlastdate
                this.CurrentActiveCredit = credit.activecredit
                this.Billsframe = data.billsframe
                this.PlayerCash = data.playercash
                this.SearchPlayers = data.transferlist
                this.SelectPlayer = -1

                if (data.billsdata == 0 || data.billsdata == null || data.billsdata == false) {
                    this.Invoices = []
                } else {
                    this.Invoices = data.billsdata
                }

                setTimeout(() => {
                    this.CreateChart();
                }, 10);
            }

            if (data.action == 'Setup') {
                this.FirstFastAction = data.first
                this.SecondFastAction = data.second
                this.ThirdFastAction = data.third
                this.Billstheme = data.invoicetheme
                this.AvailableCredits = data.credittable
                this.RequireCreditPoint = data.requirecreditpoint
                this.CardStyle = data.cardstyle
                this.CreditSystem = data.creditsystem
                this.Language = data.language
            }
            
            if (data.action == 'OpenAnotherAccount') {
                const info = data.infodata

                this.show = true
                this.CurrentScreen = 'BankScreen'
                this.PlayersMoney = data.targetmoney
                this.PlayersName = info.playername
                this.PlayerIBAN = data.iban
                this.PlayersProfilePicture = info.playerpfp
                this.LastTransactions = data.transaction
                this.CardStyle = data.cardstyle
                this.Logintype = 'hacker'
                this.CreditSystem = false
                this.HackedAccountWithdrawLimit = data.withdrawlimit
                this.HackedAccountUsage = data.loginlimit

                setTimeout(() => {
                    this.CreateChart();
                }, 10);
            }

            if (data.action == 'UpdateTransaction') {
                const PlayerData = data.data[0]
                this.UpdateTransaction(JSON.parse(PlayerData.transaction))
            }

            if (data.action == 'SendResponse') {
                this.GetResponse(data.ResourceName)
            }

            if (data.action == 'OpenBillsMenu') {
                if (data.data == 0 || data.data == null || data.data == false) {
                    this.Invoices = []
                } else {
                    this.Invoices = data.data
                }
            }

            if (data.action == 'RefreshBills') {
                this.Billsframe = data.billsframe
                if (data.billsdata == 0 || data.billsdata == null || data.billsdata == false) {
                    this.Invoices = []
                } else {
                    this.Invoices = data.billsdata
                }
                this.PlayersMoney = data.playermoney
            }

            if (data.action == 'OpenATM') {
                this.show = true
                this.CurrentScreen = 'Password'
                this.PasswordScreenType = 'Normal'
            }

            if (data.action == 'CloseBankUI') {
                this.LogOut()
            }

            if (data.action == 'CloseATMUI') {
                this.LogOut()
                this.PinInput = ''
                this.PasswordInput = ''
                this.IBANInput = ''
            }
        });

        window.addEventListener('keydown', (event) => {
            if (event.key == 'Escape') {
                if (this.CurrentScreen == 'BankScreen') {
                    postNUI('CloseBankUI')
                    return;
                } else if (this.CurrentScreen == 'Password' || this.CurrentScreen == 'IBAN') {
                    postNUI('CloseATM')
                    return;
                }
            } 
        });
    },
});

app.use(store).mount("#app");