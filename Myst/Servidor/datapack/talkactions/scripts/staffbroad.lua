function getNameGroup(group)
	local groups = {"Player", "Teste", "Help", "Tutor", "Senior Tutor", "Gamemaster", "Administrador"}
	return groups[group]
end

function onSay(cid, words, param, channel)
local gbb = 82389239

	if getPlayerStorageValue(cid, gbb) - os.time() > 0 then
		doPlayerSendTextMessage(cid, 27, "O comando só pode ser executado de 15 em 15 minutos.")
	return true
	end

	doBroadcastMessage("O "..getNameGroup(getPlayerGroupId(cid)).." "..getPlayerName(cid).." está no Help respondendo duvidas.")
	setPlayerStorageValue(cid, gbb, os.time() + 15 * 60)
	
	return true
end