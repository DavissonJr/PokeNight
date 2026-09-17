-- Criado por Thalles Vitor --
-- Mudar nome no SHOP --

function onSay(cid, words, param, channel)
	if param == "" then
		doPlayerSendTextMessage(cid, 22, "Nickname invalido.")
		return true
	end

	if getPlayerStorageValue(cid, 15001) <= 0 then
		doPlayerSendTextMessage(cid, 25, "Você não tem nenhum nick para trocar.")
		return true
	end

	setPlayerStorageValue(cid, 15001, 0)
	
	local acc = getPlayerGUID(cid)

	doRemoveCreature(cid)
	--addEvent(function()
		db.executeQuery("UPDATE `players` SET `name` = '"..param.."' WHERE `id` = '"..acc.."';")
	--end, 500)
	return true
end