function onSay(cid, words, param)

if param ~= "" then
return false
end

if getPlayerStorageValue(cid, 17000) <= 0 then
return true
end

if getThingPos(cid).z == 0 then
doPlayerSendCancel(cid, "Você não pode ir mais alto!")
return true
end

local actuallyPos = getThingPos(cid)
local pos = getThingPos(cid)
pos.z = pos.z-1
pos.stackpos = 0

local removed = false
if getTileThingByPos(pos) ~= false and getTileThingByPos(pos).itemid >= 1 or getTileItemById(getThingPos(cid), 1386).itemid >= 1 then
if getTileThingByPos(pos).itemid == 460 or getTileThingByPos(pos).itemid == 11675 or getTileThingByPos(pos).itemid == 11676 or getTileThingByPos(pos).itemid == 1023 or getTileThingByPos(pos).itemid == 1022 then
    doCombatAreaHealth(cid, 0, pos, 0, 0, 0, CONST_ME_NONE)
    doRemoveItem(getTileThingByPos(pos).uid, 1)
    removed = true
end

doPlayerSendCancel(cid, "Você não pode voar através de construções.")
if not removed then
    return true
end
end

doCombatAreaHealth(cid, 0, pos, 0, 0, 0, CONST_ME_NONE)
--[[ doCreateItem(460, 1, actuallyPos) ]]
doCreateItem(460, 1, pos)
doTeleportThing(cid, pos)
return true
end