local QBCore = exports[Config.Framework]:GetCoreObject()

-----------------------------------------------------
-- In config set the trigger name and continue event == "NameOfTrigger"

function SummonBoxEvent(Trigger)
    local event = Trigger

    if event == 'Test' then
        QBCore.Functions.Notify('Now it works.', 'success', 7500)

    elseif event == 'Test2' then
        QBCore.Functions.Notify('Now it works 2 :Wink:.', 'success', 7500)

    --[[ 
    elseif event == 'Example' then
        --Whatever you want 
    ]]
    end
end