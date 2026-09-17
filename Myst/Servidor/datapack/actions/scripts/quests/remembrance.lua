local btype = "Ultra"
local pokemon = "Shiny Metagross"
local pokemon2 = "Shiny Tropius"
local config = {
	questStorage = 44457427,
	bossStorage = 724801,
	item = 13380,
	itemqnt = 1,
	level = 150,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if getPlayerLevel(cid) >= config.level then
	if getPlayerStorageValue(cid, config.bossStorage) >= 1 then
		if getPlayerStorageValue(cid, config.questStorage) >= 1 then
			doPlayerSendTextMessage(cid, 25, "Desculpe, mas você ja completou essa quest!")
			return false
		
	end
	    doPlayerAddItem(cid,config.item, config.itemqnt)
		addPokeToPlayer(cid, pokemon, 0, nil, btype)
        addPokeToPlayer(cid, pokemon2, 0, nil, btype)
		setPlayerStorageValue(cid, config.questStorage, 1)
		doPlayerSendTextMessage(cid, 25, "Parabéns você terminou a Quest Remembrance!")
		doBroadcastMessage("Parabéns o "..getCretureName(cid).." terminou a Quest Remembrance!")
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_HOLYDAMAGE)
		return true
	else
		doPlayerSendTextMessage(cid, 25, "Você precisa matar o giratina")
	
	return false
end

end
doPlayerSendTextMessage(cid, 19 ,"Você precisa de level "..config.level.." para completar a remembrance")
return false
end