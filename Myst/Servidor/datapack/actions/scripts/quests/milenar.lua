local config = {
	questStorage = 724877,
	bossStorage = 724800,
	item = {2091, 1}, -- itemid, amount
	level = 200,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if getPlayerLevel(cid) >= config.level then
	if getPlayerStorageValue(cid, config.bossStorage) >= 1 then
		if getPlayerStorageValue(cid, config.questStorage) >= 1 then
			doPlayerSendTextMessage(cid, 25, "Desculpe, mas voce ja completou essa quest!")
			return false
		
	end
		doPlayerAddItem(cid, config.item[1], config.item[2])
		setPlayerStorageValue(cid, config.questStorage, 1)
		doPlayerSendTextMessage(cid, 25, "Parabens! Voce recebeu "..config.item[2].." "..getItemNameById(config.item[1])..".")
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_HOLYDAMAGE)
		return true
	else
		doPlayerSendTextMessage(cid, 25, "Você precisa achar o Dragonite Milenar")
	
	return false
end

end
doPlayerSendTextMessage(cid, 19 ,"Você precisa de level 200 para completar a Milenar.")
return false
end