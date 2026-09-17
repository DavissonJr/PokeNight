-- Criado por Thalles Vitor --
-- Outfit Box --
local items = {10561, 11189, 27445, 27446}

function onUse(cid, item)
    doPlayerAddItem(cid, items[math.random(1, #items)], 1)
    doTransformItem(item.uid, 27450)
    return true
end