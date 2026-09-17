local level = 150
local storage = 4343243244
local teleport = {x=1038, y=1038, z=7}

function onUse(cid, item, fromPosition, item2, toPosition)

location = {
{x=1030, y=926, z=15}, -- Adicione uma coordenada
{x=1039, y=926, z=15}, -- Adicione uma coordenada
{x=1048, y=926, z=15}, -- Adicione uma coordenada
}
	
if getPlayerLevel(cid) >= level then
doPlayerSendTextMessage(cid, 25, "Você passou, agora vamos ver se terá sorte!")
doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
return doTeleportThing(cid, location[math.random(#location)])
elseif getPlayerLevel(cid) < level then
doPlayerSendTextMessage(cid, 22, "Você não tem level suficiente.")
doTeleportThing(cid, teleport)
end
end