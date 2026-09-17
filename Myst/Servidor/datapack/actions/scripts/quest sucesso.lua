local items = {27445,27441,27436,27446,27444,27443,27442,27440,27439,}
local level = 100
local teleport = {x=1038, y=1038, z=7}
--local random_item = items[math.random(#items)]
 
function onUse(cid, item, frompos, topos)

if getPlayerLevel(cid) >= level then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Que sorte, voce foi teleportado para sala do premio, como recompensa ganhou essa outfit!")
doTeleportThing(cid, teleport)
return doPlayerAddItem(cid, items[math.random(#items)])
elseif getPlayerLevel(cid) < level then
doPlayerSendTextMessage(cid,22,"Voce nao tem o level necessario")
end
return true
end