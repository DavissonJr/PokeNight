function onUse(cid, item, fromposition, toPos)
local pos = {x=1245, y=2388, z=8}
if getPlayerStorageValue(cid, 454545) <= 1 then
doTeleportThing(cid, pos)
doPlayerSendTextMessage(cid, 25, "Bem-vindo.")
doSendMagicEffect(getPlayerPosition(cid), 21)
return true
else
doPlayerSendTextMessage(cid, 26, "A porta está trancada")
return true
end
end