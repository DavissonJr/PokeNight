local msgs = {"use ", ""}

function doAlertReady(cid, id, movename, n, cd)
	if not isCreature(cid) then return true end
	local myball = getPlayerSlotItem(cid, 8)
	if myball.itemid > 0 and getItemAttribute(myball.uid, cd) == "cd:"..id.."" then
	return true
	end
	local p = getPokeballsInContainer(getPlayerSlotItem(cid, 3).uid)
	if not p or #p <= 0 then return true end
	for a = 1, #p do
		if getItemAttribute(p[a], cd) == "cd:"..id.."" then
		return true
		end
	end
end

function defaultMovementNotTM(cid, it, mypoke, name, level, cooldown, target, distance, cdzin)
	if getPlayerLevel(cid) < level then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você precisa ser level "..level.." para usar este move.")
		return true
	 end
 
	 if getCD(getPlayerSlotItem(cid, 8).uid, cdzin) > 0 and getCD(getPlayerSlotItem(cid, 8).uid, cdzin) < (cooldown + 2) then
		-- doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você tem que esperar "..getCD(getPlayerSlotItem(cid, 8).uid, cdzin).." segundos para usar "..name.." novamente.")
	 	return true
	 end
 
	 if getTileInfo(getThingPos(mypoke)).protection then
		 --doPlayerSendCancel(cid, "Você não pode atacar em PZ.")
	 	return true
	 end
									   --alterado v1.6                  
	 if (name == "Team Slice" or name == "Team Claw") and #getCreatureSummons(cid) < 2 then       
		 --doPlayerSendCancel(cid, "Os seus pokemon precisa estar em uma equipe para usar este move!")
	 	return true
	 end

	 if target == 1 then
		if not isCreature(getCreatureTarget(cid)) then
			--doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não tem um alvo.")
			return 0
		end
	
		if getCreatureCondition(getCreatureTarget(cid), CONDITION_INVISIBLE) then
			return 0
		end
	
		if getCreatureHealth(getCreatureTarget(cid)) <= 0 then
			--doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você já derrotou o seu alvo.")
			return 0
		end
	
		if not isCreature(getCreatureSummons(cid)[1]) then
			return true
		end
	
		if getDistanceBetween(getThingPos(getCreatureSummons(cid)[1]), getThingPos(getCreatureTarget(cid))) > distance then
			--doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Aproxime-se o alvo de usar este move.")
			return 0
		end
	
		if not isSightClear(getThingPos(getCreatureSummons(cid)[1]), getThingPos(getCreatureTarget(cid)), false) then
			return 0
		end
	end

	local newid = 0

	if getPlayerStorageValue(mypoke, 212123) >= 1 then
		cdzin = "cm_move"..it..""
	end
	
	cdzin = "move"..it..""       --alterado v1.5

	--[[ if getPlayerGroupId(cid) >= 5 then
		cooldown = 0
	end ]]
	
	if isSleeping(mypoke) or isSilence(mypoke) then  --alterado v1.5
		--doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Sorry you can't do that right now.")
		return 0
	else
		newid = setCD(getPlayerSlotItem(cid, 8).uid, cdzin, cooldown)
	end
		
	docastspell(mypoke, name)
	doCreatureSay(cid, ""..getCreatureName(mypoke)..", "..msgs[math.random(#msgs)]..""..name.."!", 19)
	
    local summons = getCreatureSummons(cid)
	addEvent(doAlertReady, cooldown * 1000, cid, newid, name, it, cdzin)

	for i = 2, #summons do
		if isCreature(summons[i]) and getPlayerStorageValue(cid, 637501) >= 1 then
		   docastspell(summons[i], name)        --alterado v1.6
		end
	 end

	doUpdateCooldowns(cid)
	return true
end

function MovementTMSystem(cid, movename, summon, cdzin, it)
	local summonName = getCreatureName(summon)

	local v = movestable[summonName]
	if not v then
		print("pokemon with name: " .. summonName .. " not found in list.")
		return false
	end

	if getTileInfo(getThingPos(summon)).protection then
		--doPlayerSendCancel(cid, "Você não pode atacar em PZ.")
		return true
	end

	if isInArray(movesTarget, movename) and not isCreature(getCreatureTarget(cid)) then
		--doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não tem um alvo.")
		return false
	end

	if not canUseSpell(cid, movename) then
		--doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não tem um alvo.")
		return false
	end

	local slot = getPlayerSlotItem(cid, 8)
	if slot.uid <= 0 then
		return false
	end
		
	local valueCd = getItemAttribute(slot.uid, "movecooldown"..it)
	cdzin = "move"..it..""       --alterado v1.5

	if getCD(getPlayerSlotItem(cid, 8).uid, cdzin) > 0 and getCD(getPlayerSlotItem(cid, 8).uid, cdzin) < (valueCd + 2) then
		--doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você tem que esperar "..getCD(getPlayerSlotItem(cid, 8).uid, cdzin).." segundos para usar "..movename.." novamente.")
	return true
	end

	local newid = 0
	--[[ if getPlayerGroupId(cid) >= 5 then
		valueCd = 0
	end ]]

	if isSleeping(mypoke) or isSilence(mypoke) then  --alterado v1.5
		--doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Sorry you can't do that right now.")
		return 0
	else
		newid = setCD(getPlayerSlotItem(cid, 8).uid, cdzin, valueCd)
	end

	docastspell(summon, movename) -- se caso a spell nao estiver dentro da lista de target
	doCreatureSay(cid, ""..getCreatureName(summon)..", "..msgs[math.random(#msgs)]..""..movename.."!", 19)
	addEvent(doAlertReady, valueCd * 1000, cid, newid, movename, it, cdzin)

	doUpdateCooldowns(cid)
	return true
end

function onSay(cid, words, param, channel)
	if param ~= "" then 
		return true 
	end

	if string.len(words) > 3 then 
		return true 
	end

	local it = string.sub(words, 2, 3)
	if #getCreatureSummons(cid) <= 0 then
		if getGuardianUserData(cid) ~= nil then
			if getCreatureName(getGuardianUserData(cid)) == "Arceus" then
				if tonumber(it) == 1 then
					if getPlayerStorageValue(cid, 9595) - os.time() > 0 then
				--		doPlayerSendCancel(cid, "Aguarde: " .. getPlayerStorageValue(cid, 9595) - os.time() .. " segundos para usar.")
						return true
					end
	
					docastspell(getGuardianUserData(cid), "Uproar")
					setPlayerStorageValue(cid, 9595, os.time()+7)
				end
			end
		end

		--doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você precisa de um pokémon para usar moves.")
		return 0
	end

	local slot = getPlayerSlotItem(cid, 8)
	if slot.uid <= 0 then
		return false
	end

	local mypoke = getCreatureSummons(cid)[1]
	if getCreatureName(mypoke) == "Ditto" or getCreatureName(mypoke) == "Shiny Ditto" then
		name = getPlayerStorageValue(mypoke, 1010)   --edited
	else
		name = getCreatureName(mypoke)
	end

	if not movestable[name] then
		return true
	end

	local move = movestable[name].move1
	if not move then
		return true
	end

	if getPlayerStorageValue(mypoke, 212123) >= 1 then
		cdzin = "cm_move"..it..""
	end
	
	cdzin = "move"..it..""       --alterado v1.5
	
	if it == "2" then
		move = movestable[name].move2
	elseif it == "3" then
		move = movestable[name].move3
	elseif it == "4" then
		move = movestable[name].move4
	elseif it == "5" then
		move = movestable[name].move5
	elseif it == "6" then
		move = movestable[name].move6
	elseif it == "7" then
		move = movestable[name].move7
	elseif it == "8" then
		move = movestable[name].move8
	elseif it == "9" then
		move = movestable[name].move9
	elseif it == "10" then
		move = movestable[name].move10
	elseif it == "11" then
		move = movestable[name].move11
	elseif it == "12" then
		move = movestable[name].move12
	elseif it == "13" then
		move = movestable[name].move13
	end

	if not move then
		--doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Seu pokémon não reconhece esse move.")
	return true
	end

	if getItemAttribute(slot.uid, "movename"..tonumber(it)) ~= nil then
		local movename = getItemAttribute(slot.uid, "movename"..tonumber(it))
		MovementTMSystem(cid, movename, mypoke, cdzin, it)
	end

	if getItemAttribute(slot.uid, "movename"..tonumber(it)) == nil then
		defaultMovementNotTM(cid, it, mypoke, move.name, move.level, move.cd, move.target, move.dist, cdzin)
	end

	if getGuardianUserData(cid) ~= nil then
		if getCreatureName(getGuardianUserData(cid)) == "Arceus" then
			if tonumber(it) then
				if getPlayerStorageValue(cid, 9595) - os.time() > 0 then
				--	doPlayerSendCancel(cid, "Aguarde: " .. getPlayerStorageValue(cid, 9595) - os.time() .. " segundos para usar.")
					return true
				end

				docastspell(getGuardianUserData(cid), "Uproar")
				setPlayerStorageValue(cid, 9595, os.time()+7)
			end
		end
	end

	doUpdateCooldowns(cid)
	return true
end