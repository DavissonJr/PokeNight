local level = 50
local teleport = {x=1037, y=1037, z=7}
 
function onUse(cid, item, frompos, topos)

if getPlayerLevel(cid) >= level then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Que azar, você foi teletransportado para a sala sem prêmio!")
doTeleportThing(cid, teleport)
elseif getPlayerLevel(cid) < level then
doPlayerSendTextMessage(cid,22,"Você não tem o nível necessário")
end
return true
end