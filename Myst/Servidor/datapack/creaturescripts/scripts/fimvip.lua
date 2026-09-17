function onLogin(cid)
registerCreatureEvent(cid,"FimPremium")
local pos = {x = 1038, y = 1034, z = 7}
if isPremium(cid) then
setPlayerStorageValue(cid, 6787656, 1)
elseif getPlayerStorageValue(cid, 6787656) == 1 and not isPremium(cid) then
doTeleportThing(cid, pos)
doPlayerSetTown(cid,1)
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Sua VIP expirou!\nNão deixe de visitar nosso SHOP www.otpmysterious.net.")
doSendMagicEffect(getPlayerPosition(cid), 21)
setPlayerStorageValue(cid, 6787656, -1)
end
return TRUE
end
