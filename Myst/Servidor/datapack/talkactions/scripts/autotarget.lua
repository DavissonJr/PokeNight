-- Criado por Thalles Vitor --
-- Sistema de Auto Target --
local storage = 55555

function onSay(cid, words, param, channel)
	local stor = tonumber(getPlayerStorageValue(cid, storage)) or 0
	if stor > 0 then
		doPlayerSendTextMessage(cid, 25, "Você desativou o auto target.")
		setPlayerStorageValue(cid, storage, 0)
	else
		doPlayerSendTextMessage(cid, 25, "Você ativou o auto target.")
		setPlayerStorageValue(cid, storage, 1)
	end
	return true
end