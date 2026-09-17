local waters = {11756, 4614, 4615, 4616, 4617, 4618, 4619, 4608, 4609, 4610, 4611, 4612, 4613, 7236, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625, 4665, 4666, 4820, 4821, 4822, 4823, 4824, 4825}                                                                   
local flie = {'4820', '4821', '4822', '4823', '4824', '4825'}
                                                                   --alterado v1.6 tabelas agora em configuration.lua!
local premium = false

function onStepIn(cid, item, position, fromPosition)
if not isPlayer(cid) then 
	return true 
end

if (getPlayerStorageValue(cid, 63215) >= 1 or getPlayerStorageValue(cid, 17000) >= 1) then
	return true
end

if #getCreatureSummons(cid) == 0 then
   doPlayerSendCancel(cid, "You need a pokemon to surf.")
   doTeleportThing(cid, fromPosition, false)
   return true
end
                       --alterado v1.6
if (not isInArray(specialabilities["surf"], getPokemonName(getCreatureSummons(cid)[1]))) then 
   doPlayerSendCancel(cid, "This pokemon cannot surf.")
   doTeleportThing(cid, fromPosition, false)
   return true
end
                                        --alterado v1.6
if surfs[getPokemonName(getCreatureSummons(cid)[1])] and surfs[getPokemonName(getCreatureSummons(cid)[1])].lookType then
   doSetCreatureOutfit(cid, {lookType = surfs[getPokemonName(getCreatureSummons(cid)[1])].lookType + 351}, -1) 
end

-- Thalles Vitor
local pball = getPlayerSlotItem(cid, 8)
local surfAddon = tonumber(getItemAttribute(pball.uid, "addonSurf")) or 0
if surfAddon > 0 then
    doSetCreatureOutfit(cid, {lookType = surfAddon}, -1)
end

--doCreatureSay(cid, ""..getPokeName(getCreatureSummons(cid)[1])..", lets surf!", 1)

local pct = getCreatureHealth(getCreatureSummons(cid)[1]) / getCreatureMaxHealth(getCreatureSummons(cid)[1])
doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "hp", pct)
doRemoveCreature(getCreatureSummons(cid)[1])

setPlayerStorageValue(cid, 63215, 1)
doPlayerSendCancel(cid, '12//,hide')
doUpdateMoves(cid)

return false
end

local direffects = {9, 9, 9, 9}
function onStepOut(cid, item, position, fromPosition)

	local checkpos = fromPosition
	checkpos.stackpos = 0

	if not isInArray(waters, getTileInfo(getThingPos(cid)).itemid) then

		if getPlayerStorageValue(cid, 17000) >= 1 then 
			return false 
		end

		if getPlayerStorageValue(cid, 63215) <= 0 then 
			return false 
		end

		doRemoveCondition(cid, CONDITION_OUTFIT)
		setPlayerStorageValue(cid, 63215, -1)

		local item = getPlayerSlotItem(cid, 8)
		if item.uid <= 0 then 
			return false 
		end

		local pokemon = getItemAttribute(item.uid, "poke")
		local x = pokes[pokemon]

		if not x then 
			return false 
		end

		if getItemAttribute(item.uid, "nick") then
		--	doCreatureSay(cid, getItemAttribute(item.uid, "nick")..", I'm tired of surfing!", 1)
		else
		--	doCreatureSay(cid, getItemAttribute(item.uid, "poke")..", I'm tired of surfing!", 1)
		end

		doSummonMonster(cid, pokemon)
		local pk = getCreatureSummons(cid)[1]        

		if not isCreature(pk) then
			pk = doCreateMonster(pokemon, backupPos)
			if not isCreature(pk) then
				doPlayerSendCancel(cid, "You can't stop surfing here.")
				doTeleportThing(cid, fromPosition, false)
				return false
			end

			doConvinceCreature(cid, pk)
		end
        
		doTeleportThing(pk, getThingPos(cid), true)
		doCreatureSetLookDir(pk, getCreatureLookDir(cid))

		adjustStatus(pk, item.uid, true, false, true)

		-- Thalles Vitor
		local surfAddon = tonumber(getItemAttribute(item.uid, "lastAddon")) or 0

		if surfAddon > 0 then
			doSetCreatureOutfit(pk, {lookType = surfAddon}, -1)
			doRemoveCondition(cid, CONDITION_OUTFIT)
		end

		-- Thalles Vitor - Outfits --
			if tonumber(getPlayerStorageValue(cid, 9494)) >= 1 then
				doSetCreatureOutfit(cid, {lookType = 6}, -1)
			end

			if tonumber(getPlayerStorageValue(cid, 9495)) >= 1 then
				doSetCreatureOutfit(cid, {lookType = 10}, -1)
			end
		--

		-- Thalles Vitor - Auto Spell --
			--[[ addEvent(autospell, 10, cid) ]]
		--

		doPlayerSendCancel(cid, '12//,show') --alterado v1.8
		doUpdateMoves(cid)
	end

return true
end