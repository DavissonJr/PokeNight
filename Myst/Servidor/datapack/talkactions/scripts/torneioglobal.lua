function onSay(cid, words, param, channel)

	local DBexecute = db.getResult("SELECT `torneioglobal` FROM `players` WHERE `id` = '" .. getPlayerGUID(cid) .. "' ORDER BY `torneioglobal` DESC;")
	local DBresult = DBexecute:getDataInt("torneioglobal")
	local DBexecute1 = db.getResult("SELECT `fim`,`season` FROM `torneioglobal` WHERE `id` = 1;")
	local DBresult1 = DBexecute1:getDataInt("fim")
	local DBresult2 = DBexecute1:getDataInt("season")
	doPlayerSendTextMessage(cid, 19, "Você está com " .. DBresult .. " pontos no Torneio Global." )
	doPlayerSendTextMessage(cid, 19, "A Temporada termina em " .. DBresult1 .. " dias, estamos na " .. DBresult2 .. "º temporada.")
	return true
end
