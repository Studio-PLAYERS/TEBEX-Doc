local Translations = {
    notifications = {
        enoughmoney = "Nemáš dostatek peněz.",
        FullInventory = "Tvůj inventář byl plný, proto jsme převedli tvé prostředky na bankovní účet - %{money}$",
        recieved = "Obdržel jsi %{money}$",
        paid = "Zaplatil jsi %{money}$"
    },
    migration = {
        info = 'Nástroj pro migraci hotovosti na bankovní účet. (God)',
        done = 'Migrace dokončena',
        error = 'Migrace se nezdařila',
        progress = 'Probíhá migrace uživatelů %{progress} / %{accounts}',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
