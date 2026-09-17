local tpId = 1387
local tps = {
["Lugia"] = {pos = {x=694, y=1016, z=11}, toPos = {x=677, y=1044, z=11}, time = 10},
}

function removeTp(tp)
local t = getTileItemById(tp.pos, tpId)
if t then
	doRemoveItem(t.uid, 1)
	doSendMagicEffect(tp.pos, CONST_ME_POFF)
end
end

function onDeath(cid)
local tp = tps[getCreatureName(cid)]
if tp then
	if getTileThingByPos(tp.pos).uid > 0 then
		doCreateTeleport(tpId, tp.toPos, tp.pos)
		doCreatureSay(cid, "O teleport irá sumir em "..tp.time.." segundos.", TALKTYPE_ORANGE_1)
		addEvent(removeTp, tp.time*1000, tp)
	end
end
return TRUE
end