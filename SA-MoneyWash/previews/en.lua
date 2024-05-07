if Config.Language == 'en' then
    local Translations = {
        menu = {
            header = "Illegal Money Laundering",

            showInventory = 'Offer Goods',

            PayoutTicket = 'Show Payout Ticket',

            Close = 'Close Menu',

        },

        InventoryMenu = {
            header = "List of Tickets",

            NewTicket = 'New Ticket',
            Ticket = 'Ticket # %{value}',
            Payout = 'Payout Ticket # %{value}',
            PayoutInfo = 'Value: %{value} $',

            Back = 'Go Back',

        },

        TargetAndBox = {
            open = 'Discuss illegal business',
        },

        Notify = {
            NotTicket = 'You have no tickets',
            InvalidTicket = 'Invalid ticket',
            NotMyTicket = 'Are you trying to fool me? This is not my ticket!',
            NotEnoughSpace = 'You do not have enough space for the payout ticket',
            TooMuchWork = 'I have too much work to clean up your mess and erase the traces',
            Nothing4U = 'I have nothing for you. You have to wait.',
        },

    }


    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true
    })
end