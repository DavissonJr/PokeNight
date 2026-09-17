function onAttack(cid, target)
doSendMagicEffect(getThingPos(target), 15)
return true
end

function onThink(cid, interval)

doSendAnimatedText(getThingPos(cid), getPlayerStorageValue(cid, 1008).."/"..getPlayerStorageValue(cid, 1009).."", COLOR_GRASS)

end

function onDirection(cid)

	if isSleeping(cid) or isParalyze(cid) then
	return false
	end

	if getPlayerStorageValue(cid, 446) >= 1 then
	return false 
	end

	if isSummon(cid) and isCreature(getCreatureTarget(cid)) and not isSleeping(cid) and not isParalyze(cid) then
	return true
	end 

	if getCreatureSpeed(cid) == 0 then
	return false
	end
return true
end

function onCast(cid, target)

	if isSleeping(cid) then
	return false
	end

	if getCreatureCondition(cid, CONDITION_INVISIBLE) and not isGhostPokemon(cid) then
	return false
	end

return true
end