local config = {
	loginMessage = getConfigValue('loginMessage'),
	useFragHandler = getBooleanFromString(getConfigValue('useFragHandler'))
}

local events = {"PokeBar", "PokeLevel", "EmpilharDinheiro", "BikeEffect", "AutoLootReceive", "AutoLootChangeCategory",
"AutoLootAdd", "AutoLootRemove", "AutoLootStatus", "AutoLootSearch", "dropStone",
"PlayerLogout", "WildAttack", "Idle", "EffectOnAdvance", "GeneralConfiguration", "SaveReportBug",
"LookSystem", "UpAbsolute", "Outfit250", "Outfit150", "onlinebonus", "upspeed", "Monster Hunterl",
"Monster Hunter", "TopEffect", "deathTP", "T1", "T2", "PokeHouse", "PointsWindow", "OnlineBall", "AntiMC", "AutoCatch", "AutoCatchCorpse", "AutoTarget"}

function onLogin(cid)
	if getCreatureName(cid) == "Account Manager" then
		return false
	end

	-- Thalles Vitor
	if getPlayerGroupId(cid) >= 6 then
		local textMem = collectgarbage("count")
    	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[Servidor - VPS]: Uso de memória: " .. textMem .. ".")
	end

	-- Thalles Vitor - Ganhar VIP --
		local vipGain = db.getResult("SELECT `vipDays` FROM `accounts` WHERE `id` = " .. getPlayerAccountId(cid))
		if vipGain:getID() ~= -1 then
			local vipDay = vipGain:getDataInt("vipDays")
			if vipDay > 0 then
				doPlayerAddPremiumDays(cid, vipDay)
				db.executeQuery("UPDATE `accounts` SET `vipDays` = 0 WHERE `id` = " .. getPlayerAccountId(cid))
			end
		end
	--

	-- Thalles Vitor
	if getPlayerVocation(cid) == 0 then
		doPlayerSetVocation(cid, 1)
	end

	-- Thalles Vitor - Estrela VIP
	if isPremium(cid) then
		doCreatureSetSkullType(cid, 6)
	end

	-- Thalles Vitor - Catch Bag
 	if getPlayerSlotItem(cid, 13).uid <= 0 then
		doPlayerAddItem(cid, 28146, 1)
	end

	local catchBag = getPlayerSlotItem(cid, 13)
	if catchBag.uid > 0 then
		if isContainer(catchBag.uid) then
			for i = 0, getContainerSize(catchBag.uid)-1 do
				local items = getContainerItem(catchBag.uid, i)
				if items and items.uid > 0 and not getItemAttribute(items.uid, "poke") then
					doRemoveItem(items.uid, items.type)
				end

				if items and items.uid > 0 and items.itemid == 28146 then
					doRemoveItem(items.uid, 1)
				end
			end
		end
	end

	local backpack = getPlayerSlotItem(cid, 3)
	if backpack.uid > 0 then
		if isContainer(backpack.uid) then
			for i = 0, getContainerSize(backpack.uid)-1 do
				local items = getContainerItem(backpack.uid, i)
				if items and items.uid > 0 and items.itemid == 28146 then
					doRemoveItem(items.uid, 1)
				end
			end
		end
	end

	-- Thalles Vitor - Conditions
	if getCreatureCondition(cid, CONDITION_OUTFIT) then
		doRemoveCondition(cid, CONDITION_OUTFIT)
	end

	-- Thalles Vitor - Outfits --
		if tonumber(getPlayerStorageValue(cid, 9494)) >= 1 and getPlayerSlotItem(cid, CONST_SLOT_RING).itemid == 27441 then
			doSetCreatureOutfit(cid, {lookType = 6}, -1)
		end

		if tonumber(getPlayerStorageValue(cid, 9495)) >= 1 and getPlayerSlotItem(cid, CONST_SLOT_RING).itemid == 27444 then
			doSetCreatureOutfit(cid, {lookType = 10}, -1)
		end
	--

	-- Thalles Vitor - Bikes --
		if tonumber(getPlayerStorageValue(cid, 9937)) > 0 and getPlayerSlotItem(cid, CONST_SLOT_RING).uid > 0 then
			local a = {lookType = getPlayerStorageValue(cid, 9937), lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}
        	local b = {lookType = getPlayerStorageValue(cid, 9937), lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}

			local outfitt = getPlayerSex(cid) == 0 and b or a
			doSetCreatureOutfit(cid, outfitt, -1)
		end
	--

	-- Thalles Vitor - Guardian System
	if getPlayerStorageValue(cid, GUARDIAN_NAME_STORAGE) == "" then
		setPlayerStorageValue(cid, GUARDIAN_NAME_STORAGE, "none")
	end

	-- Thalles Vitor - Prevencao de Pokemon Morto Apos Shutdown --
		if getPlayerSlotItem(cid, 8).uid > 0 then
			local ball = getPlayerSlotItem(cid, 8)
			local typee = getPokeballType(ball.itemid)
			local btype = pokeballs[typee]
			if btype then
				local hp = tonumber(getItemAttribute(ball.uid, "hp")) or 0
				if hp > 0 and ball.itemid ~= ball.on then
					doTransformItem(ball.uid, btype.on)
				end
			end
		end
	--

	-- Thalles Vitor - Online Window --
		registerCreatureEvent(cid, "OnlineWindow")
	--

	-- Thalles Vitor - Shop Window --
		registerCreatureEvent(cid, "ShopReceive")
	--

	-- Thalles Vitor - Addon Window --
		registerCreatureEvent(cid, "AddonWindow")
	--

	-- Thalles Vitor - TM System --
		registerCreatureEvent(cid, "TmSystem")
		registerCreatureEvent(cid, "TmSystemConfirm")
		registerCreatureEvent(cid, "TmSystemReset")
		registerCreatureEvent(cid, "TmSystemChange")
		registerCreatureEvent(cid, "TmSystemChange2")
	--

	-- Thalles Vitor - Rope --
		registerCreatureEvent(cid, "PlayerRope")
	--

	-- Proteï¿½ï¿½o Contra Item Indevido no Slot --
		if getPlayerSlotItem(cid, 8).uid > 0 and not isPokeball(getPlayerSlotItem(cid, 8).itemid) then
			doRemoveItem(getPlayerSlotItem(cid, 8).uid, 1)
		end
	--

	addEvent(doSetPlayerSpeedLevel, 10, cid)
	for i = 1, #events do
		registerCreatureEvent(cid, events[i])
	end

	-- Thalles Vitor - Sistema de Task
	registerCreatureEvent(cid, "TaskSystem")
	registerCreatureEvent(cid, "TaskSystemKill")

	-- Thalles Vitor - Evolve Window Confirm
	registerCreatureEvent(cid, "EvolveWindowConfirm")

	-- Thalles Vitor - Market System
		registerCreatureEvent(cid, "MarketRCItem")
		registerCreatureEvent(cid, "MarketSDItem")
		registerCreatureEvent(cid, "MarketISItem")
		registerCreatureEvent(cid, "MarketSCItem")
		registerCreatureEvent(cid, "MarketIMItem")
		registerCreatureEvent(cid, "MarketCLItem")
		registerCreatureEvent(cid, "MarketCPItem")
		registerCreatureEvent(cid, "MarketIBItem")
		registerCreatureEvent(cid, "MarketSBItem")
		registerCreatureEvent(cid, "MarketRBItem")
		registerCreatureEvent(cid, "MarketIHItem")
		registerCreatureEvent(cid, "MarketSHItem")
		registerCreatureEvent(cid, "MarketSMItem")
		registerCreatureEvent(cid, "MarketRMItem")
		registerCreatureEvent(cid, "MarketSMCI")
		registerCreatureEvent(cid, "MarketRUMO")
		registerCreatureEvent(cid, "MarketSMYO")
		registerCreatureEvent(cid, "MarketRMOS")
		registerCreatureEvent(cid, "MarketSOC")
		registerCreatureEvent(cid, "MarketSOCBUYER")
		registerCreatureEvent(cid, "MarketSOTY")
		registerCreatureEvent(cid, "MarketROTY")
		registerCreatureEvent(cid, "MarketSMVOTY")
		registerCreatureEvent(cid, "MarketCMOTME")
		registerCreatureEvent(cid, "MarketRALLMO")
		registerCreatureEvent(cid, "MarketRCO")
		registerCreatureEvent(cid, "MarketRRITP")
		registerCreatureEvent(cid, "MarketSearch")
	--

	-- Thalles Vitor - Sistema de Login Diario --
		--[[ sendPlayerRewardDay(cid) ]]
	--

	-- Thalles Vitor - Health Info --
		doSendPlayerExtendedOpcode(cid, 102, getPlayerPokemons(cid).."@")

		local torneio = tonumber(getPlayerStorageValue(cid, 22234)) or 0
		if torneio <= 0 then
			torneio = 0
		end

		doSendPlayerExtendedOpcode(cid, 103, torneio.."@")

		local catch = tonumber(getPlayerStorageValue(cid, 22235)) or 0
		if catch <= 0 then
			catch = 0
		end

		doSendPlayerExtendedOpcode(cid, 104, catch.."@")
	--

	-- Thalles Vitor - PokeBar --
		sendPokemonsBarPokemon(cid)
	--

	-- Thalles Vitor - Auto Loot System
	onReceiveItemsAdded(cid) -- send items added of the player to the client
	--

	if getPlayerLevel(cid) >= 1 and getPlayerLevel(cid) <= 10 then   --alterado v1.8
		doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, 0)
	else     
		doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, (getPlayerLevel(cid) >= 200 and 100 or math.floor(getPlayerLevel(cid)/2)) )
	end

	doCreatureSetDropLoot(cid, false)

	local lastLogin, str = getPlayerLastLoginSaved(cid), config.loginMessage
	if(lastLogin > 0) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)
		str = "Sua última visita foi em " .. os.date("%a %b %d %X %Y", lastLogin) .. "."
	else
		str = str
	end

	sendMsgToPlayer(cid, 20, "Seja bem-vindo(a) ao Poke Night!")
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)

	if(not isPlayerGhost(cid)) then
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
	end

	if getPlayerStorageValue(cid, 17000) >= 1 then -- fly
		local item = getPlayerSlotItem(cid, 8)
		if item.uid > 0 then
			local poke = getItemAttribute(item.uid, "poke")

			local pos = getCreaturePosition(cid)
			pos.stackpos = 0
			if getTileThingByPos(pos).itemid <= 0 then
				doCreateItem(460, 1, pos)
			end

			if flys[poke] and flys[poke][1] then
				doSetCreatureOutfit(cid, {lookType = flys[poke][1] + 351}, -1)
			else
				doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
			end
			
			local btype = pokeballs[getPokeballType(item.itemid)]
			if btype then
				doTransformItem(item.uid, btype.use)
			end

			-- Thalles Vitor - Fly Module
			doSendPlayerExtendedOpcode(cid, 244, "open".."@")
		end

		for i = 1, 2 do
			addEvent(function()
				-- Thalles Vitor - PokeBar --
					sendPokemonsBarPokemon(cid)
				--
			end, i * 500)
		end

		-- Thalles Vitor - Fly Module
		doSendPlayerExtendedOpcode(cid, 244, "open".."@")

	elseif getPlayerStorageValue(cid, 17001) >= 1 then -- ride
		local item = getPlayerSlotItem(cid, 8)
		local poke = getItemAttribute(item.uid, "poke")

		if item.uid > 0 then
			local btype = pokeballs[getPokeballType(item.itemid)]
			if btype then
				doTransformItem(item.uid, btype.use)
			end
		end

		if rides[poke] then
			doSetCreatureOutfit(cid, {lookType = rides[poke][1] + 351}, -1)
		end

		for i = 1, 2 do
			addEvent(function()
				-- Thalles Vitor - PokeBar --
					sendPokemonsBarPokemon(cid)
				--
			end, i * 500)
		end
	elseif getPlayerStorageValue(cid, 63215) >= 1 then -- surf
		local item = getPlayerSlotItem(cid, 8)
		if item.uid > 0 then
			local poke = getItemAttribute(item.uid, "poke")

			if surfs[poke] and surfs[poke][1] then
				doSetCreatureOutfit(cid, {lookType = surfs[poke][1] + 351}, -1)
			else
				doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
			end

			local btype = pokeballs[getPokeballType(item.itemid)]
			if btype then
				doTransformItem(item.uid, btype.use)
			end
		end

		for i = 1, 2 do
			addEvent(function()
				-- Thalles Vitor - PokeBar --
					sendPokemonsBarPokemon(cid)
				--
			end, i * 500)
		end
	elseif getPlayerStorageValue(cid, 13008) >= 1 then -- dive
		if not isInArray({5405, 5406, 5407, 5408, 5409, 5410}, getTileInfo(getThingPos(cid)).itemid) then
			setPlayerStorageValue(cid, 13008, 0)             
			doRemoveCondition(cid, CONDITION_OUTFIT)
			return true
		end   

		if getPlayerSex(cid) == 1 then
			doSetCreatureOutfit(cid, {lookType = 1034, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}, -1)
		else
			doSetCreatureOutfit(cid, {lookType = 1035, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}, -1)
		end

	elseif getPlayerStorageValue(cid, 5700) > 0 then   --bike
		if getPlayerSex(cid) == 1 then
			doSetCreatureOutfit(cid, {lookType = 1394}, -1)
		else
			doSetCreatureOutfit(cid, {lookType = 1393}, -1)
		end
	end

	if getPlayerLanguage(cid) == 0 then
		doPlayerSendTextMessage(cid, 25,"Bem-vindo(a) ao Poke Night\nDica de segurança: Nunca digite sua senha em nenhum site não oficial!")
	end

	if getPlayerLanguage(cid) == 2 then
		doPlayerSendTextMessage(cid, 25,"Welcome to Poke Night\nSafety Tip: Never enter your password on any unofficial site!")
	end

	if getPlayerLanguage(cid) == 1 then
		doPlayerSendTextMessage(cid, 25, "Bienvenido a Poke Night\nConsejo de seguridad: Nunca introduzca su contrasena en cualquier sitio no oficial!")
	end


	if getPlayerLanguage(cid) == 0 then
		doPlayerSendTextMessage(cid, 27,"Do you speak english? If so, try setting your game language to english. Just say: '!lang en'.")
		doPlayerSendTextMessage(cid, 27,"Tu hablas espanol? si, para mudar la lengua del juego a espanol apenas diga: '!lang es'.")
	end

	if getPlayerLanguage(cid) == 2 then
		doPlayerSendTextMessage(cid, 27, "Você fala português? Se sim, experimente mudar a lí­ngua do jogo para português. Apenas diga '!lang pt'.")
		doPlayerSendTextMessage(cid, 27, "Tu hablas espanol? si, para mudar la lengua del juego a espanol apenas diga: '!lang es'.")
	end

	if getPlayerLanguage(cid) == 1 then
		doPlayerSendTextMessage(cid, 27, "Do you speak english? If so, try setting your game language to english. Just say: '!lang en'.")
		doPlayerSendTextMessage(cid, 27, "Você fala português? Se sim, experimente mudar a língua do jogo para português. Apenas diga '!lang pt'.")
	end

	doPlayerSetMaxCapacity(cid, 600)
	return true
end