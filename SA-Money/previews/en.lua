local Translations = {
    notifications = {
        enoughmoney = "You don't have enough money.",
        FullInventory = "Your inventory is full, your money has been deposited into the bank - %{money}$",
        recieved = "You recieved %{money}$",
        paid = "You've paid %{money}$"
    },
    migration = {
        info = 'Cash to bank account migration tool. (God)',
        done = 'Migration completed',
        error = 'Migration has failed',
        progress = '%{progress} / %{accounts} users are being migrated',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
