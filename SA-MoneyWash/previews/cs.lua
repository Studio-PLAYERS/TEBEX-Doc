if Config.Language == 'cs' then
    local Translations = {
        menu = {
            header = "Nelegální praní peněz",

            showInventory = 'Nabídnout zboží',

            PayoutTicket = 'Ukázat výplatní lístek',

            Close = 'Zavřít menu',

        },

        InventoryMenu = {
            header = "Seznam lístků",

            NewTicket = 'Nový lístek',
            Ticket = 'Lístek č. %{value}',
            Payout = 'Vyplatit lístek č. %{value}',
            PayoutInfo = 'V hodnotě: %{value} $',

            Back = 'Jít zpět',

        },

        TargetAndBox = {
            open = 'Promluvit si o nelegálním byznysu',
        },

        Notify = {
            NotTicket = 'Nemáš žádné lístky',
            InvalidTicket = 'Neplatný lístek',
            NotMyTicket = 'Snažíš se mě ojebat? Tohle není lístek ode mě!',
            NotEnoughSpace = 'Nemáš dostatek místa pro výplatní lístek',
            TooMuchWork = 'Mám přiliš mnoho práce s tím, abych přepral ten tvůj bordel a zahladil stopy',
            Nothing4U = 'Nic pro tebe nemám. Musíš vyčkat.',
        },

    }


    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true
    })
end