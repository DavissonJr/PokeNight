local outfit = {lookType = 0, lookHead = 94, lookAddons = 94, lookLegs = 94, lookBody = 94, lookFeet = 94} -- outfit con el que saldra
function onStepIn(cid, item, fromPosition, itemEx, toPosition)
--------------------------------------------------------------------------------------------------------------
--- Extra Script Nuevo
if getPlayerStorageValue(cid, 20000) == 1 then 
		doTeleportThing(cid, fromPosition)
	elseif getPlayerStorageValue(cid, 17000) >= 1 or getPlayerStorageValue(cid, 17001) >= 1 or getPlayerStorageValue(cid, 63215) >= 1 then
		doTeleportThing(cid, fromPosition)
	elseif isCreature(cid) then
		doTeleportThing(cid, fromPosition)
	return true 
	end
--------------------------------------------------------------------------------------------------------------
     local pSex = getPlayerSex(cid)
     outfit.lookType = pSex == PLAYERSEX_FEMALE and 605 or 604
     return isPlayer(cid) and doSetCreatureOutfit(cid, outfit, -1)
end