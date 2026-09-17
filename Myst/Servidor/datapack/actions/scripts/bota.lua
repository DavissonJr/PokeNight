local velocidade = 5000
local storage = 22032

function onUse(cid, item, itemEx, fromPosition, toPosition)
	if item.uid ~= getPlayerSlotItem(cid, CONST_SLOT_RING).uid then
		doPlayerSendCancel(cid, "Você deve colocar a bota no local correto.") 
	    return true
    end

    local sto = tonumber(getPlayerStorageValue(cid, storage)) or 0
    if sto >= 1 then
        doChangeSpeed(cid, -getCreatureSpeed(cid))
        doSetPlayerSpeedLevel(cid)
        setPlayerStorageValue(cid, storage, 0)
        doItemEraseAttribute(item.uid, "using")
    else
        doChangeSpeed(cid, -getCreatureSpeed(cid))
        doChangeSpeed(cid, velocidade)
        setPlayerStorageValue(cid, storage, 1)
        doItemSetAttribute(item.uid, "using", 1)
    end
    return true
end