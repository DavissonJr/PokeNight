local level = 1000
local teleport = {x=1036, y=1034, z=7}
 
function onUse(cid, item, frompos, topos)

if getPlayerLevel(cid) >= level then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Que azar, voce foi teleportado para a sala sem premio!")
doTeleportThing(cid, teleport)
elseif getPlayerLevel(cid) < level then
doPlayerSendTextMessage(cid,22,"Voce nao tem o level necessario")
end
return true
end