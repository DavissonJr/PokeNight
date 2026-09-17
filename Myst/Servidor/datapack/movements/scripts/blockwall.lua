local a = {"Misdreavus", "Gengar", "Shiny Gengar"}

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
if not isCreature(cid) then 
    return true 
end

if isSummon(cid) and isInArray(a, getCreatureName(cid)) then
    return true
else
    doTeleportThing(cid, fromPosition, true)
end

return true
end