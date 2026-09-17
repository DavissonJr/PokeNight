function onUse(cid,item,frompos,item2,topos)

if getPlayerStorageValue(cid,181647) >= 1 then
doTeleportThing(cid,{x=596,y=3032,z=7})
doSendMagicEffect(getPlayerPosition(cid), 21)
return true
else
doPlayerSendTextMessage(cid, 26, "Você precisa da roupa de esquiador para passar.")
end
return true
end