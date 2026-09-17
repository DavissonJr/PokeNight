-- Criado por Thalles Vitor --
-- Sistema de Charm --
-- Aumenta a chance de spawn de X monstro em X % --

CHARM_SUCESS_MESSAGE = 25 -- MENSAGEM DE SUCESSO
CHARM_FAIL_MESSAGE = 22 -- MENSAGEM DE FAIL
CHARM_EFFECT_SHOW = 178 -- EFEITO QUE VAI SAIR AO AUMENTAR A CHANCE

CHARM_SHINY_STORAGE_CHANCE = 23231 -- STORAGE PRA GUARDAR A CHANCE DO PLAYER (shiny)
CHARM_BOSS_STORAGE_CHANCE = 23232 -- STORAGE PRA GUARDAR A CHANCE DO PLAYER (boss)

CHARM_SHINY_STORAGE_TIME = 23233 -- TEMPO DE FICAR COM O ITEM (shiny)
CHARM_BOSS_STORAGE_TIME = 23234 -- TEMPO DE FICAR COM O ITEM (boss)

CHARM_RETURN_DEFAULT_VALUE = 0 -- não mexer, valor que vai voltar pra quando acabar
CHARM_RETURN_DEFAULT_ITEM_COUNT = 1 -- não mexer, valor que vai remover de item do player
CHARM_SHINY_ITEM_ID = 12345 -- ID DO CHARM
CHARM_BOSS_ITEM_ID = 123456 -- ID DO BOSS

-- Função principal que irá determinar o tipo, se é shiny ou boss, e enviar a chance pra função da tipagem
function mainFunction(playerId, type, chance, days, item) -- use essa funcao no shop/outros
	if type == "shiny" then
		moreChancesShiny(playerId, type, chance, days, item)
	end

	if type == "boss" then
		moreChancesBoss(playerId, type, chance, days)
	end
	return true
end

-- Função de setar a chance
function setPlayerCharmChance(playerId, type, chance)
	if not isPlayer(playerId) then
		--print("Player não encontrado!")
		return false
	end

	if type == "shiny" then
		setPlayerStorageValue(playerId, CHARM_SHINY_STORAGE_CHANCE, chance)
	end

	if type == "boss" then
		setPlayerStorageValue(playerId, CHARM_BOSS_STORAGE_CHANCE, chance)
	end
	return true
end

-- Função de obter a chance
function getPlayerCharmChance(playerId, type)
	if not isPlayer(playerId) then
		--print("Player não encontrado!")
		return false
	end

	if type == "shiny" then
		return tonumber(getPlayerStorageValue(playerId, CHARM_SHINY_STORAGE_CHANCE)) or 0
	end

	if type == "boss" then
		return tonumber(getPlayerStorageValue(playerId, CHARM_BOSS_STORAGE_CHANCE)) or 0
	end
	return 0
end

-- Determinar a validade do item
function setPlayerCharmDate(playerId, type, days)
	if not isPlayer(playerId) then
		--print("Player não encontrado!")
		return false
	end

	if type == "shiny" then
		if days == 15 then
			setPlayerStorageValue(playerId, CHARM_SHINY_STORAGE_TIME, os.time()+1800) 
		else
			setPlayerStorageValue(playerId, CHARM_SHINY_STORAGE_TIME, os.time()+3600) 
		end
	end

	if type == "boss" then
		setPlayerStorageValue(playerId, CHARM_BOSS_STORAGE_TIME, os.time()+days) -- multiplica 3600*24 (24 horas) e multiplica por dias (formula: 3600*24*dias)
	end
	return true
end

-- Obter a validade do item
function getPlayerCharmDate(playerId, type)
	if not isPlayer(playerId) then
		--print("Player não encontrado!")
		return 0
	end

	if type == "shiny" then
		return tonumber(getPlayerStorageValue(playerId, CHARM_SHINY_STORAGE_TIME)) - os.time() or 0
	end

	if type == "boss" then
		return tonumber(getPlayerStorageValue(playerId, CHARM_BOSS_STORAGE_TIME)) - os.time() or 0
	end
	return 0
end

-- Remover
function removeChance(playerId, type, chance, item)
	if not isPlayer(playerId) then
		--print("Player não encontrado!")
		return false
	end

	-- Mensagem
	doPlayerSendTextMessage(playerId, CHARM_SUCESS_MESSAGE, "[CHARM] - Sua chance de spawnar pokémons shiny diminuiu para: " ..chance.. "%")
	
	-- Efeito
	doSendMagicEffect(getThingPos(playerId), CHARM_EFFECT_SHOW)

	-- Setar a chance do jogador
	setPlayerCharmChance(playerId, type, chance)
	return true
end

-- Função de mais chances para shiny
function moreChancesShiny(playerId, type, chance, days, item)
	if not isPlayer(playerId) then
		--print("Player não encontrado!")
		return false
	end

	local atributo = getItemAttribute(item.uid, "chanceShinyCharm") or 0
	-- Atributo
	if atributo <= 0 then
		doItemSetAttribute(item.uid, "chanceShinyCharm", chance)
	end

	-- Chance Var
	local value = atributo
	if value <= 0 then
		value = chance
	end

	if getPlayerCharmChance(playerId, "shiny") <= 0 then
		-- Mensagem
		
		doPlayerSendTextMessage(playerId, CHARM_SUCESS_MESSAGE, "[CHARM] - Sua chance de spawnar pokémons shiny aumentou para: " ..value.. "% durante " .. days .. " minutos.")
			
		-- Efeito
		doSendMagicEffect(getThingPos(playerId), CHARM_EFFECT_SHOW)

		-- Setar a chance do jogador
		setPlayerCharmChance(playerId, "shiny", value)
	else
		doPlayerSendTextMessage(playerId, 22, "Você já está usando um charm, espere o tempo acabar.")
		--removeChance(playerId, "shiny", 0, item)
	end
	return true
end

-- Função de mais chances para boss
function moreChancesBoss(playerId, type, chance, days)
	if not isPlayer(playerId) then
		--print("Player não encontrado!")
		return false
	end

	local atributo = getItemAttribute(item.uid, "chanceBossCharm") or 0
	-- Atributo
	if atributo <= 0 then
		doItemSetAttribute(item.uid, "chanceBossCharm", chance)
	end

	-- Chance Var
	local value = atributo
	if value <= 0 then
		value = chance
	end

	if getPlayerCharmChance(playerId, "boss") <= 0 then
		-- Mensagem
		doPlayerSendTextMessage(playerId, CHARM_SUCESS_MESSAGE, "[CHARM] - Sua chance de spawnar pokémons boss aumentou para: " ..value.. "% durante " .. days .. " dias.")
			
		-- Efeito
		doSendMagicEffect(getThingPos(playerId), CHARM_EFFECT_SHOW)

		-- Setar a chance do jogador
		setPlayerCharmChance(playerId, "boss", value)
	else
		doPlayerSendTextMessage(playerId, 22, "Você já está usando um charm, espere o tempo acabar.")
		--removeChance(playerId, "boss", 0, item)
	end
	return true
end

-- Criar o shiny
function createSpawnShiny(cid, pokemon)
	if isMonster(pokemon) and not isSummon(pokemon) and not string.find(getCreatureName(pokemon), "Shiny") and not string.find(getCreatureName(pokemon), "Horder") then
		local percent1 = math.random(getPlayerCharmChance(cid, "shiny"), 40) -- se aqui for maior que percent 2 fica mais facil
		local percent2 = math.random(getPlayerCharmChance(cid, "shiny"), 100) -- se aqui for maior que percent1 fica dificil

		-- Se o nome do spectator for igual ao nome do poke que sera spawnado e se percent1 for menor que percent2
		if percent1 >= percent2 then
			local name = getCreatureName(pokemon)
			local pos = getCreaturePosition(pokemon)

			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "[CHARM]: Um Shiny " .. name .. " foi spawnado.")
			doCreateMonster("Shiny " .. name, pos, false)
		end
	end

	if isMonster(pokemon) and not isSummon(pokemon) and not string.find(getCreatureName(pokemon), "Shiny") and not string.find(getCreatureName(pokemon), "Horder") then
		local percent1 = math.random(getPlayerCharmChance(cid, "shiny"), 40) -- se aqui for maior que percent 2 fica mais facil
		local percent2 = math.random(getPlayerCharmChance(cid, "shiny"), 100) -- se aqui for maior que percent1 fica dificil

		-- Se o nome do spectator for igual ao nome do poke que sera spawnado e se percent1 for menor que percent2
		if percent1 >= percent2 then
			local name = getCreatureName(pokemon)
			local pos = getCreaturePosition(pokemon)

			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "[CHARM]: Um Horder " .. name .. " foi spawnado.")
			doCreateMonster("Horder " .. name, pos, false)
		end
	end
	return false
end

-- Spawnar o pokemon shiny
function onSpawnShiny(cid, pokemon)
	if not isPlayer(cid) then return true end

	-- Se caso nao for um shiny
	if tonumber(getPlayerCharmChance(cid, "shiny")) > 0 then
		createSpawnShiny(cid, pokemon)
	end
	return false
end

-- Criar o boss
function createSpawnBoss(spectator, pokemon)
	if isMonster(pokemon) then
		local percent1 = math.random(20, 80) -- se aqui for maior que percent 2 fica mais facil
		local percent2 = math.random(20, 90) -- se aqui for maior que percent1 fica dificil

		--print("Porcentagem 1: " .. percent1 .. " - Porcentagem 2: " .. percent2..".")

		-- Se o nome do spectator for igual ao nome do poke que sera spawnado e se percent1 for menor que percent2
		if getCreatureName(spectator) == getCreatureName(pokemon) and percent1 >= percent2 then
			local name = getCreatureName(spectator)
			local pos = getThingPos(spectator)

			if not name:find("Boss") then
				doRemoveCreature(spectator)
				doCreateMonster("Boss " .. name, pos, false)
			end
		end
	end
	return false
end

-- Spawnar o pokemon boss
function onSpawnBoss(pokemon)
	-- Se caso nao for um shiny
	local random = math.random(1, 100) -- valor aleatorio entre 1 e 100

	local spectators
	for _, pid in pairs(getPlayersOnline()) do
		if getPlayerCharmChance(pid, "boss") >= random then
			spectators = getSpectators(getCreaturePosition(pid), 7, 7, false)

			if spectators and #spectators > 0 then
				for i, v in pairs(spectators) do
					createSpawnBoss(v, pokemon)
				end
			end
		end
	end
	return false
end