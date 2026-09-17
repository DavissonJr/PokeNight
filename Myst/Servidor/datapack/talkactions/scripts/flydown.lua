local lower = {'460', '11675', '11676'}
local houses = {'919', '1015', '1590', '1591', '1592', '1593', '1582', '1584', '1586', '1588', '5248', '5189'}
local waters = {4614, 4615, 4616, 4617, 4618, 4619, 4608, 4609, 4610, 4611, 4612, 4613, 7236, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625, 4665, 4666, 4820, 4821, 4822, 4823, 4824, 4825}

function onSay(cid, words, param)

if param ~= "" then
return false
end

if getPlayerStorageValue(cid, 17000) <= 0 then
   doPlayerSendCancel(cid, "Você não está voando.")
   return true
end

if getThingPos(cid).z == 7 then
   doPlayerSendCancel(cid, "Você não pode ir mais baixo!")
   return true
end

if getTileInfo(getThingPos(cid)).itemid == 11677 then
   doPlayerSendCancel(cid, "Desculpe, não é possível ir mais baixo.")
   return true
end

local pos = getThingPos(cid)
pos.z = pos.z+1
pos.stackpos = 0

if not isInArray(lower, getTileInfo(getThingPos(cid)).itemid) and getTileInfo(getThingPos(cid)).itemid >= 2 then
   doPlayerSendCancel(cid, "Você não pode ir mais baixo!")
   return true
end

if isInArray(waters, getTileThingByPos(pos).itemid) then
   doPlayerSendCancel(cid, "Você não pode descer sobre a água.")
   return true
end

if getTileThingByPos(pos).itemid >= 1 then

if getTilePzInfo(pos) == true then
   doPlayerSendCancel(cid, "You can\'t go down here.")
   return true
end

if not canWalkOnPos(pos, true, true, false, false, true) then
   doPlayerSendCancel(cid, "You can't go down here.")
   return true
end

local posR = getThingPos(cid)
posR.stackpos = 0
doTeleportThing(cid, pos)
else
doCombatAreaHealth(cid, 0, pos, 0, 0, 0, CONST_ME_NONE)

local posR = getThingPos(cid)
posR.stackpos = 0

if getTileThingByPos(posR).itemid == 460 or getTileThingByPos(posR).itemid == 11676 or getTileThingByPos(posR).itemid == 11675 or getTileThingByPos(posR).itemid == 11677 then
doRemoveItem(getTileThingByPos(posR).uid, 1)
end

doCreateItem(460, 1, pos)
doTeleportThing(cid, pos)
doSendMagicEffect(pos, 377)
return true
end
return true
end