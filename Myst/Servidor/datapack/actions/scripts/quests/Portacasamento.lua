function onUse(cid, item, frompos, topos)

if getPlayerStorageValue(cid, 181656) >= 1 then
doTeleportThing(cid,{x=982, y=853, z=7})
doSendMagicEffect(getPlayerPosition(cid), 21)
doPlayerSendTextMessage(cid, 25, "Bem-vindo.")
return true
else
doPlayerSendTextMessage(cid, 22, "Você precisa completar a Quest Policial Jenny.")
return true
end
end