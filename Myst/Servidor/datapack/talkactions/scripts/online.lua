function onSay(cid, words, param, channel)
	if getPlayerGroupId(cid) < 6 then
		local total = #getPlayersOnline()
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Player(s) Online: " .. total)
	else
		local str = {}
		for k, v in pairs(getPlayersOnline()) do
			table.insert(str, getCreatureName(v) .. " [" .. getPlayerLevel(v) .. "]\n")
		end

		local total = #getPlayersOnline()
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Player(s) Online: " .. total .. "\n --> " .. table.concat(str))
	end
	return true
end
