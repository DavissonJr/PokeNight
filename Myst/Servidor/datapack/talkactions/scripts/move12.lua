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

function onSay(cid, words, param, channel)
	if param ~= "" then 
		return true 
	end

	if string.len(words) > 3 then 
		return true 
	end

	if #getCreatureSummons(cid) == 0 then
		doPlayerSendTextMessage(cid, 26, "Você precisa de um pokémon para usar moves.")
		return 0
	end

	local mypoke = getCreatureSummons(cid)[1]
    if getCreatureName(mypoke) == "Ditto" or getCreatureName(mypoke) == "Shiny Ditto" then
       name = getPlayerStorageValue(mypoke, 1010)   --edited
    else
       name = getCreatureName(mypoke)
    end  
	
	local it = string.sub(words, 2, 3)
	local move = movestable[name]
	if not move then
		return true
	end

	move = move.move1
	if getPlayerStorageValue(mypoke, 212123) >= 1 then
		cdzin = "cm_move"..it..""
	else
		cdzin = "move"..it..""       --alterado v1.5
	end

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
		doPlayerSendTextMessage(cid, 26, "Seu pokémon não reconhece esse move.")
	return true
	end
	
	if getPlayerLevel(cid) < move.level then
	   doPlayerSendTextMessage(cid, 26, "Você precisa ser level "..move.level.." para usar este move.")
	   return true
    end

	if getCD(getPlayerSlotItem(cid, 8).uid, cdzin) > 0 and getCD(getPlayerSlotItem(cid, 8).uid, cdzin) < (move.cd + 2) then
		doPlayerSendTextMessage(cid, 26, "Você tem que esperar "..getCD(getPlayerSlotItem(cid, 8).uid, cdzin).." segundos para usar "..move.name.." novamente.")
	return true
	end

	if getTileInfo(getThingPos(mypoke)).protection then
		doPlayerSendCancel(cid, "Você não pode atacar em Zona de Proteção.")
	return true
	end
		                              --alterado v1.6                  
	if (move.name == "Team Slice" or move.name == "Team Claw") and #getCreatureSummons(cid) < 2 then       
	    doPlayerSendCancel(cid, "Os seus pokémon precisa estar em uma equipe para usar este move!")
    return true
    end
                                                                     --alterado v1.7 \/\/\/


if move.target == 1 then

	if not isCreature(getCreatureTarget(cid)) then
	doPlayerSendTextMessage(cid, 26, "Você não tem um alvo.")
	return 0
	end

	if getCreatureCondition(getCreatureTarget(cid), CONDITION_INVISIBLE) then
	return 0
	end

	if getCreatureHealth(getCreatureTarget(cid)) <= 0 then
	doPlayerSendTextMessage(cid, 26, "Você já derrotou o seu alvo.")
	return 0
	end

	if not isCreature(getCreatureSummons(cid)[1]) then
	return true
	end

	if getDistanceBetween(getThingPos(getCreatureSummons(cid)[1]), getThingPos(getCreatureTarget(cid))) > move.dist then
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Aproxime-se do alvo para usar este move.")
	return 0
	end

	if not isSightClear(getThingPos(getCreatureSummons(cid)[1]), getThingPos(getCreatureTarget(cid)), false) then
	return 0
	end
end

	local newid = 0
	if isSleeping(mypoke) or isSilence(mypoke) then  --alterado v1.5
		doPlayerSendTextMessage(cid, MESSAGE_ORANGE, "Desculpe, você não pode fazer isso agora.")
		return 0
	else
		newid = setCD(getPlayerSlotItem(cid, 8).uid, cdzin, move.cd)
	end
		
	doCreatureSay(cid, ""..getPokeName(mypoke)..", "..msgs[math.random(#msgs)]..""..move.name.."!", TALKTYPE_MONSTER)
	
    local summons = getCreatureSummons(cid) --alterado v1.6

    docastspell(mypoke, move.name)
	if useKpdoDlls then
		doUpdateCooldowns(cid)
	end

	return 0
end