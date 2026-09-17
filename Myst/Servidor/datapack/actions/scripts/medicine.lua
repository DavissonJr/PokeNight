function onUse(cid, item, frompos, item2, topos)  --alterado v1.8 \/ ajeitado!

	if not isSummon(item2.uid) then return doPlayerSendCancel(cid, "This potion can only be used on pokémons.") end
	if getCreatureMaster(item2.uid) ~= cid then return doPlayerSendCancel(cid, "You can only use it in your own pokemon.") end
	if getPlayerStorageValue(cid, 52481) >= 1 then return doPlayerSendCancel(cid, "You can't do that while a duel.") end
	
	local pokeball = getPlayerSlotItem(cid, 8)
    doCureBallStatus(pokeball.uid, "all")
    doCureStatus(item2.uid, "all", false)         
    if (getCreatureCondition(item2.uid, CONDITION_PARALYZE) == true) then
	   doRemoveCondition(item2.uid, CONDITION_PARALYZE)
    end
    if getCreatureSpeed(item2.uid) < getSpeed(item2.uid) then     
       doRegainSpeed(item2.uid)
    end                                                               
	doSendMagicEffect(getThingPos(item2.uid), 14)
	doRemoveItem(item.uid, 1)

return true
end