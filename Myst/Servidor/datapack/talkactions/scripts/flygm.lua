function flyAtivar(cid)  --alterado v1.8 \/
if getPlayerStorageValue(cid, 151542) > 0 then
		doPlayerSendTextMessage(cid, 27, "Type \"up\" or \"h1\" to fly higher and \"down\" or \"h2\" to fly lower.")
		local speed = 500 + 600 + 1200 * 6 * 2
		doChangeSpeed(cid, speed)
		setPlayerStorageValue(cid, 54844, speed)
		doSetCreatureOutfit(cid, {lookType = 1693 + 351}, -1)
		if #getCreatureSummons(cid) > 0 then
		doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "hp", getCreatureHealth(getCreatureSummons(cid)[1]) / getCreatureMaxHealth(getCreatureSummons(cid)[1]))
		doRemoveCreature(getCreatureSummons(cid)[1])
		end
		setPlayerStorageValue(cid, 17000, 1)
           sendMovementEffectGM(cid, 21, getThingPos(cid))     --edited efeito quando anda com o porygon
		  					doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Parece que ocorreu um erro, tente novamente.")
	end
end

function flyDesativar(cid)
if getPlayerStorageValue(cid, 151542) > 0 then
	if isInArray({460, 11675, 11676, 11677}, getTileInfo(getThingPos(cid)).itemid) then
        doPlayerSendCancel(cid, "You can\'t stop flying at this height!")
        return true
        end
        if getTileInfo(getThingPos(cid)).itemid >= 4820 and getTileInfo(getThingPos(cid)).itemid <= 4825 then
        doPlayerSendCancel(cid, "You can\'t stop flying above the water!")
        return true
        end
		doRemoveCondition(cid, CONDITION_OUTFIT)
	setPlayerStorageValue(cid, 17000, -1)
	setPlayerStorageValue(cid, 17001, -1)
	setPlayerStorageValue(cid, 151542, -1)
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Fly GM desativado.")
		if(not isPlayerGhost(cid)) then
					doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
		end
		else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Voce nao esta com o Fly GM Ativado.")
end
end

function onSay(cid, words, param, channel)
	if(param == '') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "digite /fly 1 para ativar e /fly 0 para desativar.")
		return true
	end
	
	

		if(param == '1') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Fly GM Ativado, digite /fly 0 para desativar.")
		setPlayerStorageValue(cid, 151542, 1)
		flyAtivar(cid)
		return true
	end
	
			if(param == '0') then
		flyDesativar(cid)
		return true
	end

	return true
end
