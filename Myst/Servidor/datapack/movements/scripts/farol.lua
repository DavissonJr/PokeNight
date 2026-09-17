-- Criado por Thalles Vitor --

function onStepIn(cid, item, position, fromPosition)
    if not isPlayer(cid) then return true end
    if getPlayerStorageValue(cid, 9876543) <= 0 then
        doPlayerSendTextMessage(cid, 25, "Você precisa entregar todos os items primeiro.")
        doTeleportThing(cid, fromPosition)
        return true
    end
    return true
end