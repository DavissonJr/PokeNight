-- Criado por Thalles Vitor --
-- Auto Correr --
local storage = 9979
event = {}

function autocorrer(cid)
	if not isPlayer(cid) then
		return true
	end

	if getPlayerStorageValue(cid, storage) <= 0 then
		if event[cid] ~= nil then
			stopEvent(event[cid])
			event[cid] = nil
		end

		return true
	end
	
	doCreatureExecuteTalkAction(cid, "correr")
	addEvent(autocorrer, 4000, cid)
	return true
end

function onSay(cid, words, param)
	if getPlayerStorageValue(cid, storage) <= 0 then
		doPlayerSendTextMessage(cid, 25, "Você ativou o auto correr.")
		setPlayerStorageValue(cid, storage, 1)

		autocorrer(cid)
	else
		doPlayerSendTextMessage(cid, 25, "Você desativou o auto correr.")
		setPlayerStorageValue(cid, storage, 0)
	end
	return true
end