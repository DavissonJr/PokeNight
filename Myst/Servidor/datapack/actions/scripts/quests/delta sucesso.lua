local items = {11115,26849,27027,27071,2183,2392,2152,2183,13129,27987,12618}
local level = 150
local teleport = {x=1038, y=1038, z=7}
--local random_item = items[math.random(#items)]
 
function onUse(cid, item, frompos, topos)

if getPlayerLevel(cid) >= level then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Que sorte, como recompensa ganhou esse prêmio!")
doTeleportThing(cid, teleport)
return doPlayerAddItem(cid, items[math.random(#items)])
elseif getPlayerLevel(cid) < level then
doPlayerSendTextMessage(cid,22,"Você não tem o nível necessário")
end
return true
end