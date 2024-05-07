local Translations = {
    doors = {
        unlock = "[E] Odemknout ",
        lock = "[E] Zamknout ",
        NotAuthorized = 'Na tohle jsi krátky.',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})