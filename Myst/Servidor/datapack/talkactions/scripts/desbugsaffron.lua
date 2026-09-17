function onSay(cid, words, param, channel)
if (isPlayerPzLocked(cid)) then
doTeleportThing(cid, {x=1037, y=1037, z=7})
doPlayerSendTextMessage(cid,22, "Voce foi teleportado para o CP")
else
 return doPlayerSendCancel(cid, "Voce nao pode usar o comando agora!")
end
return true
end