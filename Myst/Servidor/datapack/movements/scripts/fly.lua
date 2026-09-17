local del = {'460', '1022', '1023'}
local updown = {'1', '3'}
local waters = {4614, 4615, 4616, 4617, 4618, 4619, 4608, 4609, 4610, 4611, 4612, 4613, 7236, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625, 4665, 4666, 4820, 4821, 4822, 4823, 4824, 4825}

function onStepIn(cid, item, frompos, item2, topos)
if not isPlayer(cid) then
	return true
end

if getPlayerStorageValue(cid, 17000) <= 0 then
	doTeleportThing(cid, topos, false)
	doRemoveItem(getTileThingByPos(frompos).uid, 1)
	doPlayerSendCancel(cid, "Voc� n�o pode voar.")
	return true
end

local posCheck = topos
posCheck.stackpos = 0
if getTileThingByPos(posCheck) ~= false and getPlayerStorageValue(cid, 17000) >= 1 and isInArray(waters, getTileThingByPos(posCheck).itemid) then
	doTeleportThing(cid, frompos, false)
	return false
end

for x=-1,1 do
	for y=-1,1 do
		posa = {x=topos.x+x,y=topos.y+y,z=topos.z}
		--[[ if isInArray(del, getTileThingByPos(posa).itemid) then
			doRemoveItem(getTileThingByPos(posa).uid, 1)
		end ]]
	end
end

for x=-1,1 do
	for y=-1,1 do
		pose = {x=frompos.x+x,y=frompos.y+y,z=frompos.z}
		if getTileThingByPos(pose) ~= false and getTileThingByPos(pose).itemid == 0 then
			doCombatAreaHealth(cid, 0, pose, 0, 0, 0, CONST_ME_NONE)
			doCreateItem(460, 1, pose)
		end
	end
end

doCombatAreaHealth(cid, 0, topos, 0, 0, 0, CONST_ME_NONE)
--[[ doCreateItem(460, 1, topos) ]]

--[[ if topos.z > frompos.z then
	doCreateItem(460, 1, frompos)
	doTransformItem(getTileThingByPos(frompos).uid, 460)
elseif topos.z < frompos.z then
	doCreateItem(460, 1, frompos)
	doTransformItem(getTileThingByPos(frompos).uid, 460)
end ]]

return true
end    