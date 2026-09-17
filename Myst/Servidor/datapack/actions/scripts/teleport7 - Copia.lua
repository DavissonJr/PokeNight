local level = 400
local storage = 4343243244111231
local teleport = {x=1036, y=1034, z=7}

function onUse(cid, item, fromPosition, item2, toPosition)

location = {
{x=992, y=366, z=15}, -- Adicione uma coordenada
{x=992, y=366, z=15}, -- Adicione uma coordenada
{x=992, y=366, z=15}, -- Adicione uma coordenada
}
	
if getPlayerLevel(cid) >= level then
doPlayerSendTextMessage(cid, 25, "Bem vindo ao vale dos gengar :D!")
doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
return doTeleportThing(cid, location[math.random(#location)])
elseif getPlayerLevel(cid) < level then
doPlayerSendTextMessage(cid, 22, "Sem level suficiente.")
doTeleportThing(cid, teleport)
end
end