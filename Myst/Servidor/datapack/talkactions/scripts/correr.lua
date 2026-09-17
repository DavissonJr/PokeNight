function doSetPlayerSpeedLevel2(cid)
	local speed = 220
	local spood = getCreatureSpeed(cid)
	local level = getPlayerLevel(cid)
	doChangeSpeed(cid, -spood)
	doChangeSpeed(cid, speed + (level * 3) + 50) 

	-- Thalles Vitor - Outfit 1
	if getPlayerStorageValue(cid, 9494) > 0 and getPlayerSlotItem(cid, CONST_SLOT_RING).uid > 0 then
		doChangeSpeed(cid, speed + (level * 3) + 50 + 25000) 
	end

	-- Thalles Vitor - Outfit 2
	if getPlayerStorageValue(cid, 9495) > 0 and getPlayerSlotItem(cid, CONST_SLOT_RING).uid > 0 then
		doChangeSpeed(cid, speed + (level * 3) + 50 + 25000) 
	end

	-- Thalles Vitor - Bota
	if getPlayerStorageValue(cid, 22032) > 0 and getPlayerSlotItem(cid, CONST_SLOT_RING).uid > 0 then
		doChangeSpeed(cid, speed + (level * 3) + 50 + 5000) 
	end

	-- Thalles Vitor - Bike
	if tonumber(getPlayerStorageValue(cid, 9937)) > 0 and getPlayerSlotItem(cid, CONST_SLOT_RING).uid > 0 then
		doChangeSpeed(cid, speed + (level * 3) + 50 + 2500) 
	end

	-- Thalles Vitor - Outfits
	if tonumber(getPlayerStorageValue(cid, 28787)) > 0 and getPlayerSlotItem(cid, CONST_SLOT_RING).uid > 0 then
		doChangeSpeed(cid, speed + (level * 3) + 50 + 3000) 
	end
end


function onSay(cid, words, param, fromPosition, toPosition)
if tonumber(getPlayerStorageValue(cid, 939)) - os.time() > 0 then
    doPlayerSendCancel(cid, "Você está cansado.")
    doSendMagicEffect(getThingPos(cid), CONST_ME_POFF)
    return true
end

doCreatureSay(cid, "Strong Haste", TALKTYPE_MONSTER)
doSendMagicEffect(getCreaturePosition(cid), 12)

doSetPlayerSpeedLevel2(cid)
setPlayerStorageValue(cid, 939, os.time()+1.5)
return true
end