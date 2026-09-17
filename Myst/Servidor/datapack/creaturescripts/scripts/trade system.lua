function onTradeRequest(cid, target, item)
	if not isPlayer(cid) then
		return true
	end

	if not isPlayer(target) then
		return true
	end
	
	--if getPlayerSlotItem(cid, 13).uid <= 0 then
	--    doPlayerAddItem(cid, 28146, 1)
	--end

	--if getPlayerSlotItem(target, 13).uid <= 0 then
	--    doPlayerAddItem(target, 28146, 1)
	--end

	--doPlayerSave(cid)
	--doPlayerSave(target)
	return true
end

function onTradeAccept(cid, target, item, targetItem)
	if not isPlayer(cid) then
		return true
	end

	if not isPlayer(target) then
		return true
	end

	if doConvertIntegerToIp(getPlayerIp(cid)) == doConvertIntegerToIp(getPlayerIp(target)) then
		doPlayerSendTextMessage(cid, 25, "Trade não completado!")
		doPlayerSendTextMessage(target, 25, "Trade não completado!")
		return false
	end

	if getItemAttribute(item.uid, "using") or getItemAttribute(targetItem.uid, "using") then
		doPlayerSendTextMessage(cid, 25, "Trade não completado! Desative a outfit primeiro.")
		doPlayerSendTextMessage(target, 25, "Trade não completado! Desative a outfit primeiro.")
		return false
	end
	
	--[[ doPlayerSave(cid)
	doPlayerSave(target) ]]

	sendPokemonsBarPokemon(cid)
	sendPokemonsBarPokemon(target)
	return true
end