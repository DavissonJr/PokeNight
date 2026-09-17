function onUse(cid, item, frompos, topos)

if getPlayerStorageValue(cid, 181656) >= 1 then
doTeleportThing(cid,{x=979, y=852, z=7})
doSendMagicEffect(getPlayerPosition(cid), 21)
doPlayerSendTextMessage(cid, 25, "Até mais.")
return true
else
doPlayerSendTextMessage(cid, 22, "Você precisa completar a Quest da Policial Jenny.")
return true
end
end