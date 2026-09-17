local level = 300

function onUse(cid, fromPos, toPos)
	return getPlayerLevel(cid) >= level and doTeleportThing(cid, toPos) or doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, 'Only players level '..level..' or higher can open this door.') and false
end