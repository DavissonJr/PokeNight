-- Criado por Thalles Vitor --
-- Outfit Box - Roupa --
local items = {
    [27445] = {storage = 44223},
    [27446] = {storage = 44224},
    [10561] = {storage = 44225},
    [11189] = {storage = 44226},
    [12335] = {storage = 44227},
    [9942] = {storage = 44228},
    [7897] = {storage = 44229},
}

function onUse(cid, item)
    local tabela = items[item.itemid]
    if not tabela then
        print("Registre a outfit: " .. item.itemid)
        return true
    end

    doSendMagicEffect(getThingPos(cid), 13)
    setPlayerStorageValue(cid, tabela.storage, 1)
    doRemoveItem(item.uid, 1)
    return true
end