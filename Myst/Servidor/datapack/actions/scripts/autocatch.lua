-- Criado por Thalles Vitor --
-- Auto Catch --

function onUse(cid, item)
    doPlayerSendTextMessage(cid, 25, "Você ativou o auto catch.")
    setPlayerStorageValue(cid, 9483, 1)

    doRemoveItem(item.uid, 1)
    doSendMagicEffect(getThingPos(cid), 47)
    return true
end