----------------------------------
--      TRAPHOUSE EXPORTS       --
----------------------------------

function AddHouseItem(ticket, slot, itemName, amount, info, _)
    exports['SA-MoneyWash']:AddHouseItem(ticket, slot, itemName, amount, info, _)
end

function RemoveHouseItem(ticket, slot, itemName, amount)
	exports['SA-MoneyWash']:RemoveHouseItem(ticket, slot, itemName, amount)
end

function GetInventoryData(ticket, slot)
    return exports['SA-MoneyWash']:GetInventoryData(ticket, slot)
end

function CanItemBeSaled(item)
    return exports['SA-MoneyWash']:CanItemBeSaled(item)
end

exports("AddHouseItem", AddHouseItem)
exports("RemoveHouseItem", RemoveHouseItem)
exports("GetInventoryData", GetInventoryData)
exports("CanItemBeSaled", CanItemBeSaled)