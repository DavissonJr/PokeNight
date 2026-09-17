function onStepIn(cid, item, position, fromPosition)
if isPlayer(cid) and getPlayerStorageValue(cid, 314164) > 1 then ---- coloca aqui a storage que vc quer (cid, 89745)
doTeleportThing(cid, fromPosition)
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,"Voce ja fez essa quest")

end
return true
end