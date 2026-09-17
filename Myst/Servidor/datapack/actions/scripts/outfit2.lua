-- Criado por Thalles Vitor --
-- Transformar Outfit e Dar Speed --
local speed = 25000 -- quanto de speed ganha
local outfit = 10 -- outfit que vai setar no player
local storage = 9495 -- storage do jogador

function onUse(cid, item)
    if getPlayerStorageValue(cid, 17000) >= 1 or getPlayerStorageValue(cid, 17001) >= 1 or getPlayerStorageValue(cid, 63215) >= 1 then
        doPlayerSendTextMessage(cid, 25, "Não pode usar a outfit em uma situação especial.")
        return true
    end

    if getPlayerSlotItem(cid, CONST_SLOT_RING).uid ~= item.uid then
        doPlayerSendCancel(cid, "Você deve colocar sua outfit no local correto.")
        return true
    end

    if getPlayerStorageValue(cid, storage) <= 0 then
        setPlayerStorageValue(cid, storage, 1)
        doSetCreatureOutfit(cid, {lookType = outfit, lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0}, -1)
        doItemSetAttribute(item.uid, "using", 1)

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
        doItemEraseAttribute(item.uid, "using")
    end
    return true
end