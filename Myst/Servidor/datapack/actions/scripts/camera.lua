function onUse(cid, item, frompos, item2, topos)

	if getPlayerStorageValue(cid, 99284) == 2 then
		doPlayerSendCancel(cid, "You have to close your private chat to create a TV channel.")
	return true
	end

	if getPlayerStorageValue(cid, 99284) == 1 then
		doPlayerSendCancel(cid, "You are already on air! Currently on channel: "..getPlayerStorageValue(cid, 99285).."")
		doPlayerSendChannel(cid, getPlayerChannelId(cid), getPlayerStorageValue(cid, 99285))
	return true
	end

if not isPremium(cid) then
doPlayerSendCancel(cid, "Only premium members are allowed to record videos.")
return true
end

	doPlayerPopupFYI(cid, "Choose a channel name")

end