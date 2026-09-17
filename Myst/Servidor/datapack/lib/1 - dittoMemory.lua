-- Criado por Thalles Vitor --
-- Sistema de Ditto Memory --

-- Function to change to other poke keep in ditto memory
function setPokemonDittoMemory(cid, value)
	local item = getPlayerSlotItem(cid, 8)
	if item.uid <= 0 then
		return false
	end

	local poke = getCreatureSummons(cid)
	if #poke <= 0 then
		return false
	end

	if getPlayerStorageValue(cid, 68482) - os.time() >= 1 then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "[DITTO SYSTEM] - Aguarde: " .. getPlayerStorageValue(cid, 68482) - os.time() .. " segundos para copiar novamente.")
		return false
	end

	local name = getCreatureName(poke[1])
	local pokeCopy = getItemAttribute(item.uid, "copyedDittoName"..value) or "none"
	local pokeOutfit = getItemAttribute(item.uid, "copyedDittoOutfit"..value) or getCreatureOutfit(poke[1]).lookType

	local heath_toDrawPercent = getCreatureMaxHealth(poke[1]) - getCreatureHealth(poke[1])

	if getCreatureName(poke[1]) == pokeCopy then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Seu pokémon já é um: " ..pokeCopy.. ".")
		return false
	end

	-- Se nao for nada no slot
	if pokeCopy == "none" or pokeCopy == "?" then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "Não há nada para copiar.")
		return false
	end

	doRemoveCreature(poke[1])
	doSummonMonster(cid, pokeCopy)

	local summon = getCreatureSummons(cid)[1]
	doPlayerSay(cid, name..", copie o "..pokeCopy..".")
	doCreatureSetLookDir(summon, 2)
	doItemSetAttribute(item.uid, "transName", pokeCopy)
	doItemSetAttribute(item.uid, "transOutfit", pokeOutfit)

	doUpdateMoves(cid)
	adjustStatus(summon, item.uid, true, heath_toDrawPercent, true)

	--doUpdatePokeInfo(cid)
	--doPokeInfoAttr(cid)
	setPlayerStorageValue(cid, 68482, os.time()+3)
	return true
end