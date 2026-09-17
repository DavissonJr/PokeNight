function onSay(cid, words, param)

if param ~= "" then
return false
end

if getPlayerStorageValue(cid, 17000) <= 0 then
return true
end

if getThingPos(cid).z == 0 then
doPlayerSendCancel(cid, "You can\'t go higher!")
return true
end

local pos = getThingPos(cid)
pos.z = pos.z-1
pos.stackpos = 0


if getTileThingByPos(pos).itemid >= 1 or getTileItemById(getThingPos(cid), 1386).itemid >= 1 then
doPlayerSendCancel(cid, "You can\'t fly through constructions.")
return true
end

doCombatAreaHealth(cid, 0, pos, 0, 0, 0, CONST_ME_NONE)
doCreateItem(11676, 1, pos)
doTeleportThing(cid, pos)
if getCreatureOutfit(cid).lookType == 667 or getCreatureOutfit(cid).lookType == 999 then
   markPosEff(cid, getThingPos(cid))                           --edited porygon fly sistem 
end

return true
end