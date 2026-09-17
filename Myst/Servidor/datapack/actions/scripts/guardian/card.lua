-- Criado por Thalles Vitor --
-- Biblioteca localizada na lib --
-- Guardian System -- 1 min

function onUse(cid, item, frompos, item2, topos)
	local tabela = AVAIABLES_GUARDIANS[item.itemid]
	if not tabela then
		--print("Not found in table.")
		return true
	end

	if getTileInfo(getCreaturePosition(cid)).protection then
		doPlayerSendTextMessage(cid, 25, "Não pode usar o card em PZ.")
		return true
	end

	local storage = GUARDIANS_INDIVIDUAL_USE_CARD[tabela.name].storage
	local cooldown = GUARDIANS_INDIVIDUAL_USE_CARD[tabela.name].timeToUseAgain
	if getPlayerStorageValue(cid, storage) - os.time() > 0 then
		doPlayerSendCancel(cid, "Aguarde.")
		return true
	end

	createGuardian(cid, item) -- function da biblioteca
	setPlayerStorageValue(cid, storage, os.time()+cooldown)
	return true
end