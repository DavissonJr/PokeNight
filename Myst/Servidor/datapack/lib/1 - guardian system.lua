-- Criado por Thalles Vitor --
-- Biblioteca do SIstema de Guardian --

GUARDIAN_FAIL_MESSAGE = MESSAGE_STATUS_CONSOLE_RED
GUARDIAN_SUCESS_MESSAGE = MESSAGE_STATUS_CONSOLE_BLUE
GAURDIAN_EFFECT = 31
GUARDIAN_STORAGE = 239192931 -- STORAGE DO GUARDIAN

GUARDIAN_NAME_STORAGE = 239192934 -- STORAGE DO NOME DO GUARDIAN
GUARDIAN_STORAGE_ISGUARDIAN = 239192936 -- storage para o guardian, sinalizar que ele é um guardian

-- Como funciona?
-- O id do item precisa estar na tabela
-- time: o tempo que ele vai ficar
-- name: nome do monstro que saira do card
AVAIABLES_GUARDIANS = {
	[28116] = {name = "Arceus", time = 3600, timeToRemove = 3600000, hour = 1},
	[28173] = {name = "Entei", time = 3600, timeToRemove = 3600000, hour = 1},
	[28174] = {name = "Raikou", time = 3600, timeToRemove = 3600000, hour = 1},
	[28175] = {name = "Suicune", time = 3600, timeToRemove = 3600000, hour = 1},
}

GUARDIANS_EVENT_TYPE = {
	["Death"] = {message = "Seu guardian morreu."},
	["TimeUp"] = {message = "Seu tempo para uso do guardian esgotou-se."},
	["Others"] = {message = "Seu guardian foi removido."},
}

GUARDIANS_INDIVIDUAL_USE_CARD = {
	["Arceus"] = {storage = 33000, timeToUseAgain = 3600, timeToRemove = 3600000},
	["Entei"] = {storage = 33000, timeToUseAgain = 3600, timeToRemove = 3600000},
	["Raikou"] = {storage = 33000, timeToUseAgain = 3600, timeToRemove = 3600000},
	["Suicune"] = {storage = 33000, timeToUseAgain = 3600, timeToRemove = 3600000},
}

-- Alterado, tabela de moves dentro do arquivo do xml do monstro

function adjustGuardian(cid, guardianId, guardianName)
	if not isCreature(guardianId) then
		--print("Guardian not found.")
		return true
	end

	if not guardianName then
		--print("Guardian with name '' not found.")
		return true
	end

	if not isMonster(guardianId) then
		--print("Guardian not found.")
		return true
	end

	-- Removi coisas relacionadas a hp, vitality, defense, ja que ele e invencivel

	local level = 55
	local buff = 1
	setPlayerStorageValue(guardianId, 1000, level)
	setPlayerStorageValue(guardianId, 1001, pokes[getCreatureName(guardianId)].offense * (getPlayerLevel(cid)) * buff)
	setPlayerStorageValue(guardianId, 1002, pokes[getCreatureName(guardianId)].defense)             
	setPlayerStorageValue(guardianId, 1003, pokes[getCreatureName(guardianId)].agility)
	setPlayerStorageValue(guardianId, 1004, pokes[getCreatureName(guardianId)].vitality * 75 * buff)

	setPlayerStorageValue(guardianId, 1005, pokes[getCreatureName(guardianId)].specialattack * (getPlayerLevel(cid))*9 * buff)
	return true
end

function getGuardianUserData(playerId)
	if not isPlayer(playerId) then
		--print("Player not found.")
		return true
	end

	local summon = getGuardians(playerId)
	local var = nil

	if #summon > 0 then
		return summon[1]
	end
	return var
end

function getGuardian(playerId)
	if not isPlayer(playerId) then
		--print("Player not found.")
		return true
	end

	return #getCreatureSummons(playerId)
end

function setGuardian(playerId, guardianId, guardianTime) -- set guardian (type: get creature summons)
	if not isPlayer(playerId) then
		--print("Player not found.")
		return true
	end

	if not isCreature(guardianId) then
		--print("Guardian not found.")
		return true
	end

	adjustGuardian(playerId, guardianId, getCreatureName(guardianId)) -- ajustar o guardian
	registerCreatureEvent(guardianId, "Experience")
	registerCreatureEvent(guardianId, "GeneralConfiguration")
	registerCreatureEvent(guardianId, "DirectionSystem")
	registerCreatureEvent(guardianId, "CastSystem")
end

function removeGuardian(playerId, guardianId, type) -- death and others
	if not isPlayer(playerId) then
		--print("Player not found.")
		return true
	end

	if not isCreature(guardianId) then
		--print("Guardian not found.")
		return true
	end

	if not type then
		--print("Type of event not found.")
		return true
	end

	if not GUARDIANS_EVENT_TYPE[type] then
		--print("Um type event com o nome: " .. type .. " não foi encontrado na tabela de tipos do guardian, por favor consulte novamente a tabela.")
		return true
	end

	doPlayerSendTextMessage(playerId, GUARDIAN_FAIL_MESSAGE, GUARDIANS_EVENT_TYPE[type].message)
	setPlayerStorageValue(playerId, GUARDIAN_STORAGE, 0) -- apagar tempo
	setPlayerStorageValue(playerId, GUARDIAN_NAME_STORAGE, "none") -- remover o nome do guardian

	-- Remover do guardian que ele é um guardian
	setPlayerStorageValue(guardianId, GUARDIAN_STORAGE_ISGUARDIAN, 0)

	-- So remover caso tenha
	if isMonster(guardianId) then
		doRemoveCreature(guardianId) -- remover o guardian
	end
	return true
end

function createGuardian(playerCid, item)
	if not isPlayer(playerCid) then
		--print("Player not found.")
		return true
	end

	if item.uid <= 0 or item.itemid <= 0 then
		return true
	end

	local id = item.itemid
	local guardian = AVAIABLES_GUARDIANS[id]
	
	if not guardian then
		--print("Um item com o ID: " .. id .. " não foi encontrado na tabela de guardians.")
		return true
	end

	if not guardian.name then
		--print("Não foi possível encontrar um nome na tabela para o guardian.")
		return true
	end

	if not guardian.time then
		--print("Não foi possível encontrar um tempo definido para o guardian.")
		return true
	end

	if not guardian.hour then
		--print("Não foi possível encontrar uma hora definida para o guardian.")
		return true
	end

	if getGuardianUserData(playerCid) then
		doPlayerSendTextMessage(playerCid, 22, "Você já tem um guardian.")
		return true
	end

	--[[ if getTileInfo(getCreaturePosition(playerCid)).protection then
		doPlayerSendTextMessage(playerCid, MESSAGE_STATUS_CONSOLE_BLUE, "[GUARDIAN SYSTEM]: Seu guardião não foi sumonado por quê você está em PZ.")
		return true
	end
  ]]
	-- The default function is: doCreateMonster(guardian.name, getThingPos(playerCid), true)
	local criarGuardian = doCreateMonster(guardian.name, getThingPos(playerCid), false)
	if not criarGuardian then
		return true
	end

	doCreatureSay(playerCid, "Preciso de sua ajuda! " ..guardian.name .. ".", TALKTYPE_MONSTER)
	doPlayerSendTextMessage(playerCid, GUARDIAN_SUCESS_MESSAGE, "Você chamou a ajuda do: "..guardian.name.." por: "..guardian.hour.." hora")
	setPlayerStorageValue(playerCid, GUARDIAN_STORAGE, os.time()+guardian.time) -- adicionar storage por 1 hora
	setPlayerStorageValue(playerCid, GUARDIAN_NAME_STORAGE, guardian.name) -- salvar o nome do guardian

	-- Setar o Summon
	setPlayerStorageValue(criarGuardian, GUARDIAN_STORAGE_ISGUARDIAN, 1)
	doConvinceGuardian(playerCid, criarGuardian)
	setGuardian(playerCid, getGuardianUserData(playerCid))

	doSendMagicEffect(getThingPos(getGuardianUserData(playerCid)), GUARDIAN_EFFECT)
	--doRemoveItem(item.uid, 1)

	addEvent(removeGuardian, os.time()+guardian.timeToRemove, playerCid, getGuardianUserData(playerCid), "TimeUp")
	return true
end

function createGuardianWithStorage(playerCid, value, storageName)
	if not isPlayer(playerCid) then
		--print("Player not found.")
		return true
	end

	if storageName == "" then
		--print("Error: Storage Invalid.")
		return true
	end

	--[[ if getGuardianUserData(playerCid) then
		doPlayerSendTextMessage(playerCid, 22, "Você já tem um guardian.")
		return false
	end ]]

	--[[ if getTileInfo(getCreaturePosition(playerCid)).protection then
		doPlayerSendTextMessage(playerCid, MESSAGE_STATUS_CONSOLE_BLUE, "[GUARDIAN SYSTEM]: Seu guardião não foi sumonado por quê você está em PZ.")
		return true
	end ]]
 
	-- The default function is: doCreateMonster(storageName, getThingPos(playerCid), true)
	local criarGuardian = doCreateMonster(storageName, getThingPos(playerCid), false)
	if not criarGuardian then
		return true
	end

	local tabela = GUARDIANS_INDIVIDUAL_USE_CARD[storageName]
	if tabela then
		doCreatureSay(playerCid, "Preciso de sua ajuda! " ..storageName.. ".", TALKTYPE_MONSTER)
		doPlayerSendTextMessage(playerCid, GUARDIAN_SUCESS_MESSAGE, "Você chamou a ajuda do: "..getPlayerStorageValue(playerCid, GUARDIAN_NAME_STORAGE).." novamente.")
		
		-- Setar o Summon
		setPlayerStorageValue(criarGuardian, GUARDIAN_STORAGE_ISGUARDIAN, 1)
		doConvinceGuardian(playerCid, criarGuardian)
		setGuardian(playerCid, getGuardianUserData(playerCid))

		doSendMagicEffect(getThingPos(getGuardianUserData(playerCid)), GUARDIAN_EFFECT)
		--doRemoveItem(item.uid, 1)

		addEvent(removeGuardian, tabela.timeToRemove, playerCid, getGuardianUserData(playerCid), "TimeUp")
	end
	return true
end

-- Reset Guardian Individual Tieme
function resetTimeToUse(playerId, guardianName)
	if not isPlayer(playerId) then
		--print("Player not found.")
		return true
	end

	if guardianName == "" then
		--print("Error: guardianName Invalid.")
		return true
	end

	local tabela = GUARDIANS_INDIVIDUAL_USE_CARD[guardianName]
	if not tabela then
		print("Error: " .. guardianName .. " not found in table.")
		return true
	end

	doPlayerSendTextMessage(playerId, MESSAGE_STATUS_CONSOLE_BLUE, "[GUARDIAN SYSTEM ] - You reseted a: " .. guardianName .. " individual card.")
	setPlayerStorageValue(playerId, tabela.storage, 0)
	return true
end