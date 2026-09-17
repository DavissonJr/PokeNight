local tpId = 1387
local tps = {
        ["Ho-oh"] = {pos = {x = 502, y = 2041, z = 7}, toPos = {x = 502, y = 2047, z = 7}, time = 60},
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
                        doCreatureSay(cid, "o teleport irá sumir em 1 minuto!", TALKTYPE_ORANGE_1)
                        addEvent(removeTp, tp.time*1000, tp)
                end
        end
        return true
end