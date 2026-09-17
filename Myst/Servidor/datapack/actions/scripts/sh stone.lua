local effect = 173

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if not isCreature(itemEx.uid) and isPokeball(itemEx.itemid) then
		local pokename = doCorrectString(getItemAttribute(itemEx.uid, "poke"))
		if getPlayerSlotItem(cid, 8).uid == itemEx.uid then
			if #getCreatureSummons(cid) <= 0 then
				if PokemonShinys[pokename] then
					quant = PokemonShinys[pokename].quant
					if getPlayerItemCount(cid, item.itemid) >= quant then
						onSendEvolveWindow(cid, pokename, 13088)
					else
						onSendEvolveWindow(cid, pokename, 13088)
						doPlayerSendCancel(cid,  "You don't have "..quant.." shiny stones to evolve this ".. pokename .."!")
					end
				else
					doPlayerSendCancel(cid,  pokename.." don't have a shiny evolution!")
				end
			else
				doPlayerSendCancel(cid,  "You need call your pokemon!")
			end
		else
			doPlayerSendCancel(cid,  "You need put "..pokename.." in the principal slot!")
		end
	else
		doPlayerSendCancel(cid,  "You need use shiny stone in pokeball!")
	end
	return true
end