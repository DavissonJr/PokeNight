local level = 330
local storage = 4343243244111
local teleport = {x=1036, y=1034, z=7}

function onUse(cid, item, fromPosition, item2, toPosition)

location = {
{x=1154, y=359, z=15}, -- Adicione uma coordenada
{x=1154, y=359, z=15}, -- Adicione uma coordenada
{x=1154, y=359, z=15}, -- Adicione uma coordenada
}
	
if getPlayerLevel(cid) >= level then
doPlayerSendTextMessage(cid, 25, "Bem vindo ao inferno ehheeheh!")
doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
return doTeleportThing(cid, location[math.random(#location)])
elseif getPlayerLevel(cid) < level then
doPlayerSendTextMessage(cid, 22, "Sem level suficiente.")
doTeleportThing(cid, teleport)
end
end