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
		doRemoveCondition(cid, CONDITION_OUTFIT)
end
