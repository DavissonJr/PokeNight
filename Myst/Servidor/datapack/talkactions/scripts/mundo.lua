function onSay(cid, words, param)

	if param == "" then
		return true
	end

	local nparam = string.explode(param, ",")

	if (not nparam[1] or not nparam[2]) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Param required.")
		return true
	end

	local ponline = false
	local worldid = tonumber(nparam[1])
	local pname   = tostring(nparam[2])

	for _, k in ipairs(getPlayersOnline()) do
		if getCreatureName(k) == pname then
			playeronline = true
		end
	end

	local pid = getCreatureByName(pname)

	if playeronline then
		doRemoveCreature(pid)
	end

	addEvent(db.executeQuery, 500, "UPDATE `players` SET `world_id` = "..worldid.." WHERE `name` = '"..pname.."';")
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "O personagem ["..pname.."] foi transferido para o mundo "..worldid..".")
end