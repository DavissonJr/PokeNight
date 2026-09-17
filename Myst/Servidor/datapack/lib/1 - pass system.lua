-- Criado por Thalles Vitor --
-- Sistema de Passe de BATALHA --

PASS_OPENWINDOW_OPCODE = 230   -- enviar para o cliente que ele deve abrir o passe (basico)
PASS_OPENWINDOW_OPCODE2 = 232  -- enviar para o cliente que ele deve abrir o passe (vip)
PASS_COLLECT_OPCODE = 231      -- enviar para o cliente que ele pode resgatar uma recompensa
PASS_MONSTERSPASS_OPCODE = 240 -- enviar para o cliente a lista de monstros do passe
PASS_DESTROYINFO = 241         -- enviar para o cliente que ele deve destruir alguma informacao antiga
PASS_ITEMS = {
	-- todos os meses aqui: 01, 02, 03, 04 assim por diante
	[12] =
	{
		items = { 2160, 2152},    -- lista de items
		count = { 10, 15},        -- quantidade de items
		level = { 1, 2},          -- nivel necessario para resgatar

		types = { "Basic", "Elite"}, -- ranking necessario para desbloquear a recompensa
		storagesUnlock = { 4922, 4923}, -- storages usadas para desbloquear o item
	},
}

PASS_MONSTERS = {
	[1] = { name = "Gyarados", type = "kill", storage = 8894, completed_storage = 9998, count = 1, points = 50, image =
	"images/monsters/gyarados.png", text = "Derrote 50 Gyarados" },
	[2] = { name = "Charizard", type = "kill", storage = 8895, completed_storage = 9999, count = 35, points = 50, image =
	"images/monsters/charizard.png", text = "Derrote 35 Charizards" },
	[3] = { name = "Magikarp", type = "catch", storage = 15000, completed_storage = 9997, count = 3, points = 25, image =
	"images/monsters/magikarp.png", text = "Capture 3 Magikarps" },
	[4] = { name = "Ditto", type = "use", storage = 8897, completed_storage = 10001, count = 1, points = 45, image =
	"images/monsters/ditto.png", text = "Use o Ditto 1 vez" },
	[5] = { name = "Pesque", type = "fishing", storage = 8898, completed_storage = 10002, count = 50, points = 65, image =
	"images/monsters/pesque.png", text = "Pesque 50 vezes" },
	[6] = { name = "Venda PokÈmon", type = "selling", storage = 8899, completed_storage = 10003, count = 1, points = 25, image =
	"images/monsters/sell_poke.png", text = "Venda um PokÈmon" },
}

PASS_STARTDAY = 20 -- dia que inicia

PASS_STARTWEEK = 11 -- mes que inicia

PASS_STARTYEAR = 2023 -- ano que inicia

PASS_ENDDAY = 10      -- dia que vai acabar o pass
PASS_ENDWEEK = 12      -- mes que vai acabar o pass

PASS_ENDYEAR = 2024 -- ano que vai acabar

PASS_ENDHOUR = 24 -- hora que vai acabar

PASS_FINISH = "Acaba em: " .. PASS_ENDDAY .. "/" .. PASS_ENDWEEK .. "/" .. PASS_ENDYEAR

PASS_BUYCOIN = 2160    -- moeda usada no passe (atualizar passe, dar de presente, comprar level)
PASS_BUYLEVELPRICE = 10 -- quantidade de item que vai precisar pra comprar 1 nivel (diamond, sei la, a moeda que voce configurou acima)
PASS_BUYMAXLEVEL = 5    -- maximo de niveis que posso comprar
PASS_BUYPASSPRICE = 35  -- quantidade de item que vai precisar pra comprar o passe de elite (se for mexer aqui, mexe no texto do cliente tambem, pq lù ta 35)

-- Storages
PASS_TYPE = 93929   -- storage para sinalizar se o passe ù Basico ou Elite
PASS_POINTS = 93930 -- storage para sinalizar quantos pontos eu tenho no passe (exp)
PASS_LEVEL = 93931  -- storage para sinalizar que nivel ù o meu passe

PASS_VERSION = 3 -- Thalles
PASS_VERSIONS = {
	[1] = {storage = 4445},
	[2] = {storage = 4446},
	[3] = {storage = 4447},
	[4] = {storage = 4448},
	[5] = {storage = 4449},
	[6] = {storage = 4450},
	[7] = {storage = 4451},
	[8] = {storage = 4452},
	[9] = {storage = 4453},
	[10] = {storage = 4454},
}

function getPlayerPass(cid)
	if not isPlayer(cid) then
		return true
	end

	local storage = getPlayerStorageValue(cid, PASS_TYPE)
	if storage == nil or storage == -1 then
		setPlayerStorageValue(cid, PASS_TYPE, "Basic")
	end

	return tostring(getPlayerStorageValue(cid, PASS_TYPE)) or "Basic"
end

function setPlayerPass(cid, pass)
	if not isPlayer(cid) then
		return true
	end

	setPlayerStorageValue(cid, PASS_TYPE, pass)
	return true
end

function addPlayerPassPoints(cid, points)
	if not isPlayer(cid) then
		return true
	end

	local storage = getPlayerStorageValue(cid, PASS_POINTS)
	setPlayerStorageValue(cid, PASS_POINTS, storage + points)
	return true
end

function setPlayerPassPoints(cid, points)
	if not isPlayer(cid) then
		return true
	end

	setPlayerStorageValue(cid, PASS_POINTS, points)
	return true
end

function getPlayerPassPoints(cid)
	if not isPlayer(cid) then
		return true
	end

	local storage = getPlayerStorageValue(cid, PASS_POINTS)
	if storage == nil or storage <= 0 then
		setPlayerStorageValue(cid, PASS_POINTS, 0)
	end

	return tonumber(getPlayerStorageValue(cid, PASS_POINTS)) or 0
end

function setPlayerPassLevel(cid, level)
	if not isPlayer(cid) then
		return true
	end

	local storage = getPlayerStorageValue(cid, PASS_LEVEL)
	setPlayerStorageValue(cid, PASS_LEVEL, level)
	return true
end

function addPlayerPassLevel(cid, level)
	if not isPlayer(cid) then
		return true
	end

	local storage = getPlayerStorageValue(cid, PASS_LEVEL)
	setPlayerStorageValue(cid, PASS_LEVEL, storage + level)
	return true
end

function getPlayerPassLevel(cid)
	if not isPlayer(cid) then
		return true
	end

	local storage = getPlayerStorageValue(cid, PASS_LEVEL)
	if storage == nil or storage <= 0 then
		setPlayerStorageValue(cid, PASS_LEVEL, 0)
	end

	return tonumber(getPlayerStorageValue(cid, PASS_LEVEL)) or 0
end

function sendOpenPassWindow(cid)
	if not isPlayer(cid) then
		return true
	end

	local day = tonumber(os.date("%d"))
	local week = tonumber(os.date("%m"))
	local year = tonumber(os.date("%Y"))
	
	local cdt = os.date('*t')
	if os.time{year=cdt.year, month=cdt.month, day=cdt.day, hour=cdt.hour} >= os.time{year=PASS_STARTYEAR, month=PASS_STARTWEEK, day=PASS_STARTDAY} and os.time{year=cdt.year, month=cdt.month, day=cdt.day, hour=cdt.hour} < os.time{year=PASS_ENDYEAR, month=PASS_ENDWEEK, day=PASS_ENDDAY, hour=PASS_ENDHOUR} then
		local tabela = PASS_ITEMS[week]
		if tabela then
			doSendPlayerExtendedOpcode(cid, PASS_DESTROYINFO, "rewards" .. "@")
			for i = 1, #tabela.items do -- sobre o tempo: enviar um g_game.getProtocolGame():sendExtendedOpcode do cliente para setar uma storage global com o tempo atual para nao ficar resetando
				if getPlayerStorageValue(cid, tabela.storagesUnlock[i]) == nil or getPlayerStorageValue(cid, tabela.storagesUnlock[i]) == -1 then
					setPlayerStorageValue(cid, tabela.storagesUnlock[i], 0)
				end

				if tabela.types[i] == "Basic" then
					if getPlayerStorageValue(cid, tabela.storagesUnlock[i]) >= 1 then
						doSendPlayerExtendedOpcode(cid, PASS_OPENWINDOW_OPCODE,
							getItemInfo(tabela.items[i]).clientId ..
							"@" ..
							tabela.count[i] ..
							"@" ..
							PASS_FINISH ..
							"@" ..
							"unlocked" ..
							"@" .. getPlayerPassPoints(cid) .. "@" ..
							getPlayerPassLevel(cid) .. "@" .. getPlayerPass(cid) .. "@")
					else
						doSendPlayerExtendedOpcode(cid, PASS_OPENWINDOW_OPCODE,
							getItemInfo(tabela.items[i]).clientId ..
							"@" ..
							tabela.count[i] ..
							"@" ..
							PASS_FINISH ..
							"@" ..
							"locked" ..
							"@" .. getPlayerPassPoints(cid) .. "@" ..
							getPlayerPassLevel(cid) .. "@" .. getPlayerPass(cid) .. "@")
					end
				end

				if tabela.types[i] == "Elite" then
					if getPlayerStorageValue(cid, tabela.storagesUnlock[i]) >= 1 then
						doSendPlayerExtendedOpcode(cid, PASS_OPENWINDOW_OPCODE2,
							getItemInfo(tabela.items[i]).clientId ..
							"@" ..
							tabela.count[i] ..
							"@" ..
							PASS_FINISH ..
							"@" ..
							"unlocked" ..
							"@" .. getPlayerPassPoints(cid) .. "@" ..
							getPlayerPassLevel(cid) .. "@" .. getPlayerPass(cid) .. "@")
					else
						doSendPlayerExtendedOpcode(cid, PASS_OPENWINDOW_OPCODE2,
							getItemInfo(tabela.items[i]).clientId ..
							"@" ..
							tabela.count[i] ..
							"@" ..
							PASS_FINISH ..
							"@" ..
							"locked" ..
							"@" .. getPlayerPassPoints(cid) .. "@" ..
							getPlayerPassLevel(cid) .. "@" .. getPlayerPass(cid) .. "@")
					end
				end

				if getPlayerStorageValue(cid, tabela.storagesUnlock[i]) <= 0 and getPlayerPassLevel(cid) >= tabela.level[i] and getPlayerPass(cid) == tabela.types[i] then
					doSendPlayerExtendedOpcode(cid, PASS_COLLECT_OPCODE, "collect" .. "@")
				end
			end
		else
			doPlayerPopupFYI(cid, "Nùo existem meses para o passe de batalha.")
		end
	else
		doPlayerPopupFYI(cid, "Vocù ainda nùo pode fazer o passe por quù ele nùo comeùou ou jù acabou.")
	end
	return true
end

function sendPassMonsters(cid)
	if not isPlayer(cid) then
		return true
	end

	doSendPlayerExtendedOpcode(cid, PASS_DESTROYINFO, "monsters" .. "@")
	for i = 1, #PASS_MONSTERS do
		if getPlayerStorageValue(cid, PASS_MONSTERS[i].storage) == -1 then
			setPlayerStorageValue(cid, PASS_MONSTERS[i].storage, 0)
		end

		if getPlayerStorageValue(cid, PASS_MONSTERS[i].storage) >= PASS_MONSTERS[i].count then
			doSendPlayerExtendedOpcode(cid, PASS_MONSTERSPASS_OPCODE,
				PASS_MONSTERS[i].name ..
				"@" ..
				PASS_MONSTERS[i].count ..
				"@" ..
				getPlayerStorageValue(cid, PASS_MONSTERS[i].storage) ..
				"@" .. "done" ..
				"@" .. PASS_MONSTERS[i].image .. "@" .. PASS_MONSTERS[i].text .. "@" .. PASS_MONSTERS[i].points .. "@")
		else
			doSendPlayerExtendedOpcode(cid, PASS_MONSTERSPASS_OPCODE,
				PASS_MONSTERS[i].name ..
				"@" ..
				PASS_MONSTERS[i].count ..
				"@" ..
				getPlayerStorageValue(cid, PASS_MONSTERS[i].storage) ..
				"@" ..
				"notdone" .. "@" .. PASS_MONSTERS[i].image ..
				"@" .. PASS_MONSTERS[i].text .. "@" .. PASS_MONSTERS[i].points .. "@")
		end
	end
	return true
end

function collectRecompensePass(cid)
	if not isPlayer(cid) then
		return true
	end

	local week = tonumber(os.date("%m"))
	local tabela = PASS_ITEMS[week]
	if tabela then
		doSendPlayerExtendedOpcode(cid, PASS_DESTROYINFO, "hideAll" .. "@")
		for i = 1, #tabela.items do
			if getPlayerStorageValue(cid, tabela.storagesUnlock[i]) <= 0 and getPlayerPassLevel(cid) >= tabela.level[i] and tabela.types[i] == "Basic" and getPlayerPass(cid) == "Basic" then
				if getItemInfo(tabela.items[i]).stackable then
					doPlayerAddItem(cid, tabela.items[i], tabela.count[i])
				else
					for it = 1, tabela.count[i] do
						doPlayerAddItem(cid, tabela.items[i], tabela.count[i])
					end
				end

				doPlayerPopupFYI(cid, "Vocù resgatou suas recompensas!")
				setPlayerStorageValue(cid, tabela.storagesUnlock[i], 1)

				doSendPlayerExtendedOpcode(cid, PASS_COLLECT_OPCODE, "notcollect" .. "@")
				sendOpenPassWindow(cid)
			end

			if getPlayerStorageValue(cid, tabela.storagesUnlock[i]) <= 0 and getPlayerPassLevel(cid) >= tabela.level[i] and getPlayerPass(cid) == "Elite" then
				if getItemInfo(tabela.items[i]).stackable then
					doPlayerAddItem(cid, tabela.items[i], tabela.count[i])
				else
					for it = 1, tabela.count[i] do
						doPlayerAddItem(cid, tabela.items[i], tabela.count[i])
					end
				end

				doPlayerPopupFYI(cid, "Vocù resgatou suas recompensas!")
				setPlayerStorageValue(cid, tabela.storagesUnlock[i], 1)

				doSendPlayerExtendedOpcode(cid, PASS_COLLECT_OPCODE, "notcollect" .. "@")
				sendOpenPassWindow(cid)
			end
		end
	end
	return true
end

function resetPass(cid)
	if not isPlayer(cid) then
		return true
	end

	local day = tonumber(os.date("%d"))
	local week = tonumber(os.date("%m"))
	local year = tonumber(os.date("%Y"))
	if day >= PASS_ENDDAY and week >= PASS_ENDWEEK and year == PASS_ENDYEAR then
		for i = 1, 12 do
			local tabela = PASS_ITEMS[i]
			if tabela then
				for it = 1, #tabela.storagesUnlock do
					setPlayerStorageValue(cid, tabela.storagesUnlock[it], 0)
				end
			end
		end

		for i = 1, #PASS_MONSTERS do
			setPlayerStorageValue(cid, PASS_MONSTERS[i].storage, 0)
			setPlayerStorageValue(cid, PASS_MONSTERS[i].completed_storage, 0)
		end

		doPlayerSendTextMessage(cid, 25, "O passe de batalha foi resetado!")
		setPlayerPassLevel(cid, 0)
		setPlayerPassPoints(cid, 0)
	end
	return true
end

function buyPassLevel(cid)
	if not isPlayer(cid) then
		return true
	end

	if getPlayerPassLevel(cid) >= PASS_BUYMAXLEVEL then
		doPlayerPopupFYI(cid, "Vocù atingiu o nùvel mùximo de nùveis que pode comprar.")
		return true
	end

	if getPlayerItemCount(cid, PASS_BUYCOIN, -1) < PASS_BUYLEVELPRICE then
		doPlayerPopupFYI(cid, "Vocù nùo tem dinheiro suficiente para comprar nùvel de passe.")
		return true
	end

	doSendPlayerExtendedOpcode(cid, PASS_DESTROYINFO, "hideAll" .. "@")
	doPlayerPopupFYI(cid, "Vocù comprou 1 nùvel de passe!")
	doPlayerRemoveItem(cid, PASS_BUYCOIN, PASS_BUYLEVELPRICE)

	addPlayerPassLevel(cid, 1)
	setPlayerPassPoints(cid, 0)
	sendOpenPassWindow(cid)
	return true
end

function buyPassElite(cid)
	if not isPlayer(cid) then
		return true
	end

	if getPlayerPass(cid) == "Elite" then
		doPlayerPopupFYI(cid, "Vocù jù tem o passe de elite.")
		return true
	end

	if getPlayerItemCount(cid, PASS_BUYCOIN, -1) < PASS_BUYPASSPRICE then
		doPlayerPopupFYI(cid, "Vocù nùo tem dinheiro suficiente para comprar nùvel de passe.")
		return true
	end

	doSendPlayerExtendedOpcode(cid, PASS_DESTROYINFO, "hideAll" .. "@")
	doPlayerPopupFYI(cid, "Vocù comprou o passe de elite!")
	doPlayerRemoveItem(cid, PASS_BUYCOIN, PASS_BUYPASSPRICE)

	-- Caso queira que reseta o level e a exp so desmarcar as linhas
	--addPlayerPassLevel(cid, 1)
	--setPlayerPassPoints(cid, 0)

	setPlayerPass(cid, "Elite")
	sendOpenPassWindow(cid)
	return true
end

function buyPassPresent(cid, name)
	if not isPlayer(cid) then
		return true
	end

	if name == getCreatureName(cid) then
		sendOpenPassWindow(cid)
		doPlayerPopupFYI(cid, "Vocù nùo pode dar o passe para si mesmo.")
		return true
	end

	for k, v in pairs(getPlayersOnline()) do
		if (getCreatureName(v) == name) then
			if getPlayerPass(v) == "Elite" then
				doPlayerPopupFYI(cid, "Este jogador jù tem o passe de elite.")
				return true
			end

			if getPlayerItemCount(cid, PASS_BUYCOIN, -1) < PASS_BUYPASSPRICE then
				doPlayerPopupFYI(cid, "Vocù nùo tem dinheiro suficiente para comprar nùvel de passe.")
				return true
			end

			doSendPlayerExtendedOpcode(cid, PASS_DESTROYINFO, "hideAll" .. "@")
			doPlayerPopupFYI(cid, "Vocù comprou o passe de elite para: " .. name .. ".")
			doPlayerRemoveItem(cid, PASS_BUYCOIN, PASS_BUYPASSPRICE)

			-- Caso queira que reseta o level e a exp so desmarcar as linhas
			--addPlayerPassLevel(cid, 1)
			--setPlayerPassPoints(cid, 0)

			doPlayerPopupFYI(v, "Vocù ganhou o passe de elite de presente de: " .. getCreatureName(cid) .. ".")
			setPlayerPass(v, "Elite")
			sendOpenPassWindow(v)
		end
	end
	return true
end
