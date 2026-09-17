function onUse(cid, item, fromposition)

if getPlayerStorageValue(cid, 144451) <= 0 then
doTeleportThing(cid, {x=1044, y=883, z=7})
doSendMagicEffect(getPlayerPosition(cid), 21)
return true
else
doPlayerSendTextMessage(cid, 19, "Nada.")
return true
end
end