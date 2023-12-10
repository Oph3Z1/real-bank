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
    }),

    methods: {
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
    },  

    computed: {
        
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


