------------------------------------------ Configuracion: By Jake Williams -----------------------------------------------
local pvp = {x=2550, y=1519, z=7} --- Esta es la pos donde esta configurada PvP (TownID nill)
------------------------------------------------End Config-------------------------------------------------
function onStepIn(cid, item, fromPosition, itemEx, toPosition)
	if getPlayerStorageValue(cid, 20000) == 1 then 
		doTeleportThing(cid, fromPosition)
	elseif getPlayerStorageValue(cid, 17000) >= 1 or getPlayerStorageValue(cid, 17001) >= 1 or getPlayerStorageValue(cid, 63215) >= 1 then
		doTeleportThing(cid, fromPosition)
	elseif isCreature(cid) then
		doTeleportThing(cid, fromPosition)
	return true 
	end
	
	 doTeleportThing(cid, pvp)
	 setPlayerStorageValue(cid,7002,1)
	 doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "You now are on pvp.")
	return true
end