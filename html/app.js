const store = Vuex.createStore({
    state: {},
    mutations: {},
    actions: {}
});

const app = Vue.createApp({
    data: () => ({
        show: true,
        CurrentScreen: 'BankScreen', // 'Password' - 'BankScreen'
        CurrentMenu: 'Dashboard',
        CardStyle: 2, // '1' - '2'
        FirstFastAction: {type: 'deposit', amount: 500}, // type --> 'deposit' - 'withdraw'
        SecondFastAction: {type: 'withdraw', amount: 500}, // type --> 'deposit' - 'withdraw'
        ThirdFastAction: {type: 'deposit', amount: 1500}, // type --> 'deposit' - 'withdraw'
        DWPopup: false,
        DWType: null,
        MiddleMenuSection: 'Credit', // 'Main' - 'Transfer' - 'Invoices' - 'Credit'
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
        SelectCreditType: 'Home',
        RequireCreditPoint: true,
        SelectCredit: false,
        AvailableCredits: [
            {id: 1, type: 'Home', label: 'Normal Home Credit', description: 'This is a normal loan and the amount is low', price: 100000, requiredcreditpoint: 300},
            {id: 2, type: 'Home', label: 'Premium Home Credit', description: 'This is a premium loan and the amount is high', price: 1000000, requiredcreditpoint: 600},
            {id: 3, type: 'Home', label: 'Ultra Home Credit', description: 'This is a ultra loan and the amount is very high', price: 2500000, requiredcreditpoint: 900},
            {id: 4, type: 'Car', label: 'Normal Car Credit', description: 'This is a normal loan and the amount is low', price: 100000, requiredcreditpoint: 300},
            {id: 5, type: 'Car', label: 'Premium Car Credit', description: 'This is a premium loan and the amount is high', price: 1000000, requiredcreditpoint: 600},
            {id: 6, type: 'Car', label: 'Ultra Car Credit', description: 'This is a ultra loan and the amount is very high', price: 2500000, requiredcreditpoint: 900},
            {id: 7, type: 'Open', label: 'Normal Open Credit', description: 'This is a normal loan and the amount is low', price: 100000, requiredcreditpoint: 300},
            {id: 8, type: 'Open', label: 'Premium Open Credit', description: 'This is a premium loan and the amount is high', price: 1000000, requiredcreditpoint: 600},
            {id: 9, type: 'Open', label: 'Ultra Open Credit', description: 'This is a ultra loan and the amount is very high', price: 2500000, requiredcreditpoint: 900},
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
        }
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
        }
    },

    watch: {
    
    },

    beforeDestroy() {
        window.removeEventListener('keyup', this.onKeyUp);
    },

    mounted() {
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


