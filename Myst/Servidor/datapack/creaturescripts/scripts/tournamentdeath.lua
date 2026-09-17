local cfg = {
leftPos = {x = 1216, y = 1806, z = 7},
rightPos = {x = 1030, y = 1781, z = 7},
}

function onPrepareDeath(cid, lastHitKiller, mostDamageKiller)
if isInRange(getCreaturePosition(pid), cfg.leftPos, cfg.rightPos) then
doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
doCreatureAddHealth(cid, getCreatureMaxHealth(cid), 65535, 256, true)
doCreatureAddMana(cid, getCreatureMaxMana(cid))
doRemoveConditions(cid, false)
return false
end
return true
end