	local function doCheckPokemon(cid)
		if not isCreature(cid) then return true end
		if #getCreatureSummons(cid) <= 0 then return true end
	local a = getCreatureSummons(cid)[1]
	local b = getPlayerStorageValue(a, 1008)
	local c = getHappinessRate(a)
	local effect = 0
		for d = 1, 5 do
			if c == happinessRate[d].rate then
				effect = happinessRate[d].effect
			end
		end
	if effect ~= 0 then
		doSendMagicEffect(getThingPos(a), effect)
	end
	end


local function doCheckHunger(cid)
	if not isCreature(cid) then return true end
	if getPlayerStorageValue(cid, 1009) >= 300 then
		doSendMagicEffect(getThingPos(cid), 174)
	end
end

function onSay(cid, words, param)

	if param ~= "" then
	return false
	end

	if string.len(words) ~= 6 then
	return false
	end

	if #getCreatureSummons(cid) <= 0 then
		doPlayerSendCancel(cid, "You need a pokemon to use this command.")
	return true
	end

	if getCreatureCondition(cid, CONDITION_EXHAUST) then return true end

	doCreatureAddCondition(cid, playerexhaust)
	addEvent(doCheckPokemon, 600, cid)
	addEvent(doCheckHunger, 1500, getCreatureSummons(cid)[1])

return true
end