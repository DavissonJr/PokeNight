local tempo = 10 --tempo em segundos

function onLogin(cid)
	query = db.getResult("SELECT `name`, `level` FROM `players` WHERE `group_id` < 2 ORDER BY `level` DESC LIMIT 1")
	if (query:getID() ~= -1) then
		name = query:getDataString("name")
		if getPlayerName(cid) == name then
			TopEffect(cid)
		end
	end
	return true
end

function TopEffect(cid)
	if isPlayer(cid) then
		doSendAnimatedText(getCreaturePosition(cid), "[TOP]", TEXTCOLOR_LIGHTBLUE)
		doSendMagicEffect(getCreaturePosition(cid), 6)
		addEvent(TopEffect, tempo*1000, cid)
	end
	return true
end
