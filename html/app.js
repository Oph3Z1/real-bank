const store = Vuex.createStore({
    state: {},
    mutations: {},
    actions: {}
});

const app = Vue.createApp({
    data: () => ({
        show: true,
        chartData: null,
        CurrentScreen: 'BankScreen', // 'Password' - 'BankScreen'
        CurrentMenu: 'Dashboard',
        CardStyle: 2, // '1' - '2'
        FirstFastAction: {type: 'deposit', amount: 500}, // type --> 'deposit' - 'withdraw'
        SecondFastAction: {type: 'withdraw', amount: 500}, // type --> 'deposit' - 'withdraw'
        ThirdFastAction: {type: 'deposit', amount: 1500}, // type --> 'deposit' - 'withdraw'
        DWPopup: false,
        DWType: null,
        MiddleMenuSection: 'Main', // 'Main' - 'Transfer' - 'Invoices' - 'Credit'
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
        Invoices: [
            {id: 1, invoicename: 'LSPD', price: 100000, description:'You have been fined for driving at high speed', type: 'lspd'},
            {id: 2, invoicename: 'EMS', price: 100000, description:'All your costs in the hospital', type: 'ems'},
            {id: 3, invoicename: 'Yusuf Karaçolak', price: 100000, description:'Sender description', type: 'player'},
            {id: 4, invoicename: 'Mechanic', price: 100000, description:'Fixed your car', type: 'company'},
        ],
        SelectCreditType: null, // Dont Touch
        RequireCreditPoint: true, // true => System will require credit point to withdraw money via credit system | false => System will not check credit point to withdraw money via credit system
        SelectCredit: false, // Dont Touch
        SelectedCreditPrice: 0, // Dont Touch
        SelectedCreditReq: false, // Dont Touch
        ConfirmCredit: false, // Dont Touch
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
        PlayersMoney: 10000000, // Players current money - dont touch
        LastTransactions: [
            {id: 1, name: 'Oph3Z Test', sendedto: 'Yusuf Karaçolak', sendedtoiban: '123456', type: 'Withdraw', amount: 1000,  description: '',  pp: './img/second-example-logo.png', date: '10.07.2023'},
            {id: 2, name: 'Oph3Z Test', sendedto: 'Yusuf Karaçolak', sendedtoiban: '123456', type: 'TransferIn', amount: 1250,  description: '',  pp: './img/second-example-logo.png', date: '10.08.2023'},
            {id: 3, name: 'Oph3Z Test', sendedto: 'Yusuf Karaçolak', sendedtoiban: '123456', type: 'Withdraw', amount: 1200, description: '',  pp: './img/second-example-logo.png', date: '10.01.2023'},
            {id: 4, name: 'Oph3Z Test', sendedto: 'Yusuf Karaçolak', sendedtoiban: '123456', type: 'Withdraw', amount: 890,  description: '',  pp: './img/second-example-logo.png', date: '10.04.2023'},
            {id: 5, name: 'Oph3Z Test', sendedto: 'Yusuf Karaçolak', sendedtoiban: '123456', type: 'Withdraw', amount: 550,  description: '',  pp: './img/second-example-logo.png', date: '10.02.2023'},
            {id: 6, name: 'Oph3Z Test', sendedto: 'Yusuf Karaçolak', sendedtoiban: '123456', type: 'Withdraw', amount: 500,  description: '',  pp: './img/second-example-logo.png', date: '10.01.2023'},
            {id: 6, name: 'Oph3Z Test', sendedto: 'Yusuf Karaçolak', sendedtoiban: '123456', type: 'Withdraw', amount: 500,  description: '',  pp: './img/second-example-logo.png', date: '10.12.2023'},
        ],

    }),

    methods: {
        PE3D(s) {
            s = parseInt(s)
            return s.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
        },
        
        SelectActionMethod(status, type) {
            this.DWPopup = status
            this.DWType = type
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
            const fullName = (player.firstname + ' ' + player.lastname).toLowerCase();
            const iban = player.iban.toString();
        
            return (
                fullName.includes(search) || 
                iban.includes(search) || 
                !isNaN(search) && iban.includes(search)    
            );
        },

        SelectTransferPlayer(id) {
            if (!this.SelectPlayer) {
                this.SelectPlayer = id 
            } else if (this.SelectPlayer == id) {
                this.SelectPlayer = false
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

        SelectCreditFunction(id, price, creditreq) {
            this.SelectCredit = id
            this.SelectedCreditPrice = price
            this.SelectedCreditReq = creditreq
        },

        ConfirmCreditWithdraw() {
            if (this.RequireCreditPoint) {
                if (this.PlayersCreditPoint >= this.SelectedCreditReq) {
                    this.PlayersMoney += this.SelectedCreditPrice
                    this.PlayersCreditPoint -= this.SelectedCreditReq
                    this.ConfirmCredit = true
                } else {
                    console.log("You don't have enough credit point to withdraw money. Required Credit Point: " + this.SelectedCreditReq)
                }
            } else {
                this.PlayersMoney += this.SelectedCreditPrice
                this.PlayersCreditPoint -= this.SelectedCreditReq
                this.ConfirmCredit = true
            }
        }, 

        ClearAll() {
            this.ConfirmCredit = false
            this.SelectCredit = false
            this.SelectedCreditPrice = 0
            this.SelectedCreditReq = false
            this.SelectCreditType = null
            this.MiddleMenuSection = 'Main'
        },
    },  

    computed: {
        SearchBarFunction() {
            if (!this.SearchBar) {
                return this.SearchPlayers;
            }
          
            return this.SearchPlayers.filter((player) => this.CheckSearchBarEquality(player));
        },

        ShowAvailableCredits() {
            return this.AvailableCredits.filter(credit => credit.type === this.SelectCreditType);
        },

        ChartDataFunction() {
            const allMonths = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];

            const monthlyWithdrawals = this.LastTransactions
                .filter(transaction => transaction.type === 'Withdraw')
                .sort((a, b) => {
                const dateA = new Date(a.date.split('.').reverse().join('-'));
                const dateB = new Date(b.date.split('.').reverse().join('-'));
                return dateA - dateB; // Tarihe göre sırala
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
                    label: 'Data',
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
        this.chartData = this.ChartDataFunction;

        var ctx = document.getElementById('chart').getContext('2d');
        new Chart(ctx, {
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

        window.addEventListener("message", event => {
            window.addEventListener('keyup', this.onKeyUp);
            switch (event.data.message) {
                case "OPEN":
                    this.show = true
                break;
                
                case "CLOSE":
                    this.show = false
                break;
            }   
        });
    },
});

app.use(store).mount("#app");

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