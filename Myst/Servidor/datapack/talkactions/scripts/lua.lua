function onSay(cid, words, param)

-- if not isInArray(adminServer, getCreatureName(cid)) then
-- doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Only the server owner can run this command.")
-- return true
-- end

    _G.cid = cid
	local f , err = loadstring(param)
	if f then
		local ret,err = pcall(f)
		if not ret then
			doPlayerSendTextMessage(cid, 25,'Lua error:\n'..err)
		end
	else
		doPlayerSendTextMessage(cid, 25,'Lua error:\n'..err)
	end
	return true
end