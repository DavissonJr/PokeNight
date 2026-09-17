local function ChangeBalls(cid, param, cancelequal)
	local balls = getPlayerPokeballs(cid)
	for a = 1, #balls do
		local item = balls[a]
		if not getItemAttribute(item.uid, "ballorder") then return doPlayerSendTextMessage(cid, 27, "Do update your pokemon bar!") end --alterado v1.6
        local name = getItemAttribute(item.uid, "poke") .. getItemAttribute(item.uid, "ballorder")
		if name == param then
			if cancelequal and item.uid == getPlayerSlotItem(cid, 8).uid then return true end
			doChangeBalls(cid, getPlayerSlotItem(cid, 8), item)
			return 0
		end
	end
end

function onSay(cid, words, param)

	if not useKpdoDlls then return true end

	if words == "!code64" then
	return 0
	end

	if words == "/pokeread" then
		if #getCreatureSummons(cid) >= 1 and getPlayerStorageValue(cid, 212124) <= 0 then   --alterado v1.6
			local pokemon = getCreatureSummons(cid)[1]
			local pokelife = (getCreatureHealth(pokemon) / getCreatureMaxHealth(pokemon))
			doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "hp", pokelife)
		end
		doUpdatePokemonsBar(cid)
	end

	if words == "/goaction" then
		if param == "null" then return 0 end
		if exhaustion.get(cid, 6666) and exhaustion.get(cid, 6666) > 0 then return true end
		if getPlayerStorageValue(cid, 17000) >= 1 or getPlayerStorageValue(cid, 17001) >= 1 or getPlayerStorageValue(cid, 63215) >= 1 then return true end
		
        if #getCreatureSummons(cid) >= 1 then
			if not getItemAttribute(getPlayerSlotItem(cid, 8).uid, "ballorder") then return doPlayerSendTextMessage(cid, 27, "Do update your pokemon bar!") end 
            --alterado v1.6
            addEvent(doReturnPokemon, 100, cid, getCreatureSummons(cid)[1], false, pokeballs[getPokeballType(getPlayerSlotItem(cid, 8).itemid)].effect)
			if param ~= getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke") .. getItemAttribute(getPlayerSlotItem(cid, 8).uid, "ballorder") then
				addEvent(ChangeBalls, 1200, cid, param, true)
			end
		else
			addEvent(ChangeBalls, 100, cid, param)
		end
		exhaustion.set(cid, 6666, 2)
	return 0
	end
	
	if words == "/reloadCDs" then   --alterado v1.7
	   doUpdateMoves(cid)
	   return true
    end

return 0
end