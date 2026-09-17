function onUse(cid, item, frompos, item2, topos)

	if getPlayerStorageValue(cid, 99284) == 1 then
		doPlayerSendCancel(cid, "You can't watch TV while recording.")
	return true
	end

	local a = getThingPos(cid)

	if item.itemid >= 11416 and item.itemid <= 11418 then
		if a.y <= topos.y then
			doPlayerSendCancel(cid, "Please, stay in front of the television.")
			doPlayerSetVocation(cid, 1)
		return true
		end
	end

	if item.itemid == 11418 then
		if a.x < topos.x then
			doPlayerSendCancel(cid, "Please, stay in front of the television.")
			doPlayerSetVocation(cid, 1)
		return true
		end
	elseif item.itemid == 11416 then
		if a.x > topos.x then
			doPlayerSendCancel(cid, "Please, stay in front of the television.")
			doPlayerSetVocation(cid, 1)
		return true
		end
	end

	doPlayerSetVocation(cid, 2)

	if not checkChannelsList(cid) then
		doPlayerSendCancel(cid, "There aren't any channels on air right now.")
		doPlayerSetVocation(cid, 1)
	return true
	end

	if #getCreatureSummons(cid) >= 1 then
		doReturnPokemon(cid, getCreatureSummons(cid)[1], getPlayerSlotItem(cid, 8), pokeballs[getPokeballType(getPlayerSlotItem(cid, 8).itemid)].effect)
	end

	openChannelDialog(cid)	

return true
end