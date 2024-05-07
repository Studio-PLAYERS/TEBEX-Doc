local Translations = {
    doors = {
        unlock = "[E] To Unlock ",
        lock = "[E] To Lock ",
        NotAuthorized = 'You are not authorized to do that.',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})