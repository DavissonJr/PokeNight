function onStepIn(cid, item, frompos, item2, topos)

	local playerteleportpos = {x = 1051, y = 1726, z = 6}
	local storage = 17001

if getPlayerStorageValue(cid, storage) >= 1 then

addEvent(function()
     if isCreature(cid) then
          doTeleportThing(cid, playerteleportpos)
     end
end, 800)
end
end