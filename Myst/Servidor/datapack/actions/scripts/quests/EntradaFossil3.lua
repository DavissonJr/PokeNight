function onUse(cid, item, fromposition, toPos)
local pos = {x=1246, y=2367, z=8}
if getPlayerStorageValue(cid, 454545) <= 1 then
doTeleportThing(cid, pos)
doPlayerSendTextMessage(cid, 25, "Bem-vindo.")
doSendMagicEffect(getPlayerPosition(cid), 21)
return true
else
doPlayerSendTextMessage(cid, 26, "A porta est� trancada")
return true
end
end