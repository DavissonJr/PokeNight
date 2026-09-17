--------------------------------------------------------------------------------------------------------------
local celadon = {x= 1232, y= 1221, z= 6} --- Storage: 7000, ActionId: 12347
--------------------------------------------------------------------------------------------------------------
local saffron = {x= 1346, y= 1164, z= 6} --- Storage: 7001, ActionId: 12348
--------------------------------------------------------------------------------------------------------------
local cerulean = {x= 1350, y= 996, z= 7} --- Storage: 7002, ActionId: 12349
--------------------------------------------------------------------------------------------------------------
local lavender = {x= 1505, y= 1177, z= 7} --- Storage: 7003, ActionId: 12350
--------------------------------------------------------------------------------------------------------------
local vermilion = {x= 1358, y= 1322, z= 7} --- Storage: 7004, ActionId: 12351
--------------------------------------------------------------------------------------------------------------
local fuchsia = {x= 1361, y= 1468, z= 7} --- Storage: 7005, ActionId: 12352
--------------------------------------------------------------------------------------------------------------
local cinnabar = {x= 891, y= 1671, z= 6} --- Storage: 7006, ActionId: 12353
--------------------------------------------------------------------------------------------------------------
local viridian = {x= 930, y= 1303, z= 7} --- Storage: 7007, ActionId: 12354
--------------------------------------------------------------------------------------------------------------
local pewter = {x= 950, y= 999, z= 7} --- Storage: 7008, ActionId: 12355
--------------------------------------------------------------------------------------------------------------
local pvp = {x= 863, y= 1972, z= 7} --- Storage: 7008, ActionId: 12355
--------------------------------------------------------------------------------------------------------------
local storage = {7000, 7001, 7002, 7003, 7004, 7005, 7006, 7007, 7008}
--------------------------------------------------------------------------------------------------------------
function onStepIn(cid, item, position, fromPosition)
	if getPlayerStorageValue(cid, 20000) == 1 then 
		doTeleportThing(cid, fromPosition)
	elseif getPlayerStorageValue(cid, 17000) >= 1 or getPlayerStorageValue(cid, 17001) >= 1 or getPlayerStorageValue(cid, 63215) >= 1 then
		doTeleportThing(cid, fromPosition)
	elseif isCreature(cid) then
		doTeleportThing(cid, fromPosition)
	return true 
	end
	
	if (getPlayerStorageValue(cid, 7000) == 1) == true then
		doTeleportThing(cid, celadon)
		setPlayerStorageValue(cid, 7000, -1)
--------------------------------------------------------------------------------------------------------------
	elseif getPlayerStorageValue(cid, 7001) == 1 then
		doTeleportThing(cid, saffron)
		setPlayerStorageValue(cid, 7001, -1)
--------------------------------------------------------------------------------------------------------------
	elseif getPlayerStorageValue(cid, 7002) == 1 then
		doTeleportThing(cid, cerulean)
		setPlayerStorageValue(cid, 7002, -1)
--------------------------------------------------------------------------------------------------------------
	elseif getPlayerStorageValue(cid, 7003) == 1 then
		doTeleportThing(cid, lavender)
		setPlayerStorageValue(cid, 7003, -1)
--------------------------------------------------------------------------------------------------------------
	elseif getPlayerStorageValue(cid, 7004) == 1 then
		doTeleportThing(cid, vermilion)
		setPlayerStorageValue(cid, 7004, -1)
--------------------------------------------------------------------------------------------------------------
	elseif getPlayerStorageValue(cid, 7005) == 1 then
		doTeleportThing(cid, fuchsia)
		setPlayerStorageValue(cid, 7005, -1)
--------------------------------------------------------------------------------------------------------------
	elseif getPlayerStorageValue(cid, 7006) == 1 then
		doTeleportThing(cid, cinnabar)
		setPlayerStorageValue(cid, 7006, -1)
--------------------------------------------------------------------------------------------------------------
	elseif getPlayerStorageValue(cid, 7007) == 1 then
		doTeleportThing(cid, viridian)
		setPlayerStorageValue(cid, 7007, -1)
--------------------------------------------------------------------------------------------------------------
	elseif getPlayerStorageValue(cid, 7008) == 1 then
		doTeleportThing(cid, pewter)
		setPlayerStorageValue(cid, 7008, -1)
	end
--------------------------------------------------------------------------------------------------------------
return true
end