function tpRandomON(cid)  --alterado v1.8 \/
if getPlayerStorageValue(cid, 151541) > 0 then
local EventStart = addEvent(tpRandomON, 7000, cid)
	local pos = {x = 0, y = 0, z = 0}

		local list = {}
	for i, tid in ipairs(getPlayersOnline()) do
  list[i] = tid
end

local winner = list[math.random(1, #list)]

		pos = getCreaturePosition(winner)
	if(not pos or isInArray({pos.x, pos.y}, 0)) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player inalcancavel, tentando novamente em alguns segundos...")
		return true
	end

	pos = getClosestFreeTile(cid, pos, true, false)
	if(not pos or isInArray({pos.x, pos.y}, 0)) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player inalcancavel, tentando novamente em alguns segundos...")
		return true
	end
	if(getCreatureName(cid) == getCreatureName(winner)) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player inalcancavel, tentando novamente em alguns segundos...")
		return true
	end
	if(not isPlayerGhost(cid)) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Voce so pode usar o TP Random com ghost, ative o ghost!")
			setPlayerStorageValue(cid, 151541, -1)
		return true
	end

	local tmp = getCreaturePosition(cid)
	if(doTeleportThing(cid, pos, true) and not isPlayerGhost(winner)) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Voce se teleportou para: " .. getCreatureName(winner) .. " se teleportando novamente daqui a 7 segundos...")
	end
	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "TP Random desativado, digite /tprandom ativar para ativar.")
	stopEvent(EventStart);
	return true
	end
end

function onSay(cid, words, param, channel)
	if(param == '') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "digite /tprandom ativar para ativar e /tprandom desativar para desativar.")
		return true
	end

		if(param == 'ativar') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "TP Random ativado, digite /tprandom desativar para desativar.")
		setPlayerStorageValue(cid, 151541, 1)
		tpRandomON(cid)
		return true
	end
	
			if(param == 'desativar') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Estamos desativando o TP Random, aguarde alguns segundos...")
		setPlayerStorageValue(cid, 151541, -1)
		return true
	end

	return true
end
