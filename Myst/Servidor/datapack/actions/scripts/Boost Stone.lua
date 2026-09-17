local meuovo = {
    qnt = 1,      
    maxi = 30,      
    chance = 60,  
    boost_fail = 7,  
	falhar = 4,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if item.itemid == 12618 then
        doPlayerSendTextMessage(cid, 25, "Use novamente.")
        doTransformItem(item.uid, 28201)
        return true
    end

    --[[ if itemEx.uid == getPlayerSlotItem(cid, 8).uid then
        doPlayerSendTextMessage(cid, 25, "Não pode usar a boost com pokémon no slot.")
        return true
    end ]]

    if not getItemAttribute(itemEx.uid, "poke") then
        doPlayerSendTextMessage(cid, 25, "Use em uma pokebola.")
        return true
    end
    
    local boost = tonumber(getItemAttribute(itemEx.uid, "boost")) or 0
    if boost >= meuovo.maxi then
        return doPlayerSendCancel(cid, "Seu pokémon já se encontra no nível máximo de boost!")
    end
    
    if boost >= meuovo.boost_fail then
        if math.random(1, 100) <= meuovo.chance then
            doItemSetAttribute(itemEx.uid, "boost", (boost + meuovo.qnt))
            doSendMagicEffect(fromPosition, 173)
            doRemoveItem(item.uid, 1)
        else
            doPlayerSendCancel(cid,"Falhou!")
			doItemSetAttribute(itemEx.uid, "boost", (meuovo.falhar))
            doRemoveItem(item.uid, 1)
        end
    else
        doItemSetAttribute(itemEx.uid, "boost", (boost + meuovo.qnt))
		doSendMagicEffect(fromPosition, 173)
        doRemoveItem(item.uid, 1)
    end
    return true
end