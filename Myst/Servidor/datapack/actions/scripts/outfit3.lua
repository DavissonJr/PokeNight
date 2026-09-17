-- Criado por Thalles Vitor --
-- Transformar Outfit e Dar Speed --
local speed = 25000 -- quanto de speed ganha
local outfit = 2242 -- outfit que vai setar no player
local storage = 9494 -- storage do jogador

function onUse(cid, item)
    if getPlayerStorageValue(cid, storage) <= 0 then
        setPlayerStorageValue(cid, storage, 1)
        doSetCreatureOutfit(cid, {lookType = outfit}, -1)

        doChangeSpeed(cid, -getCreatureSpeed(cid))
        doRegainSpeed(cid)

        local player = cid
        addEvent(function()
            doChangeSpeed(player, speed)
        end, 200)
    else
        setPlayerStorageValue(cid, storage, 0)
        doRemoveCondition(cid, CONDITION_OUTFIT)

        doChangeSpeed(cid, -getCreatureSpeed(cid))
        doRegainSpeed(cid)
    end
    return true
end