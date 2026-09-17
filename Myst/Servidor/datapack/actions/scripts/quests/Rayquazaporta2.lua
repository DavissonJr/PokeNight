function onUse(cid, item, frompos, item2, topos)

local pos = {x = 2305, y = 1593, z = 5}

if getPlayerItemCount(cid, 2090, -1) >= 1 then
doTeleportThing(cid , pos)
doSendMagicEffect(getPlayerPosition(cid), 21)
doPlayerSendTextMessage(cid, 25 ,"Bem-vindo.")
setPlayerStorageValue(cid, 54893, 1)
doPlayerRemoveItem(cid, 2090, 1)
return true
else
doPlayerSendTextMessage(cid, 25, "Você não tem a chave!")
return true
end
end