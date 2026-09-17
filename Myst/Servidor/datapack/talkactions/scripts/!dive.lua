function onSay(cid, words, param, channel)

if getPlayerStorageValue(cid,63215) >=1 then

pos = getCreaturePosition(cid)
if pos.z ~= 7 then return false end

npos = {x=pos.x, y=pos.y, z=pos.z + 1}
local grounds = {5405, 5406, 5407, 5408, 5409, 5410}
if (not isInArray(grounds, getTileThingByPos(npos).itemid)) then
return doPlayerSendCancel(cid, "You cannot dive here.")
end

if doTeleportThing(cid, npos) then

doSendMagicEffect(npos, 14)
if getPlayerSex(cid) == 1 then
doSetCreatureOutfit(cid, {lookType = 1034, lookHead = 0, lookAddons = 0, lookLegs = 0, lookBody = 0, lookFeet = 0}, -1)
else
doSetCreatureOutfit(cid, {lookType = 1035, lookHead = 0, lookAddons = 0, lookLegs = 0, lookBody = 0, lookFeet = 0}, -1)
end
setPlayerStorageValue(cid, 63215, 0)
setPlayerStorageValue(cid, 13008, 1)
local item = getPlayerSlotItem(cid, 8)
local pokemon = getItemAttribute(item.uid, "poke")
local x = pokes[pokemon]

if getItemAttribute(item.uid, "nick") then
doCreatureSay(cid, "".."Good job "..getItemAttribute(item.uid, "nick").." !", 1)
else
doCreatureSay(cid, "".."Good job "..getItemAttribute(item.uid, "poke").." !", 1)
end


local pk = getCreatureSummons(cid)[1]

doChangeSpeed(pk, getCreatureSpeed(cid)+300)
doChangeSpeed(cid, -getCreatureSpeed(cid))
doChangeSpeed(cid, PlayerSpeed+300)

doTeleportThing(pk, getThingPos(cid), true)
doCreatureSetLookDir(pk, getCreatureLookDir(cid))

adjustStatus(pk, item.uid, true, false, true)

end
else
return doPlayerSendCancel(cid, "You cannot dive here.")
end
return TRUE
end