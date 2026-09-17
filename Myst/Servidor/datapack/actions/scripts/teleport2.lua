local level = 350
local storage = 43432432441
local teleport = {x=1038, y=1038, z=7}

function onUse(cid, item, fromPosition, item2, toPosition)

location = {
{x=1184, y=890, z=15}, -- Adicione uma coordenada
{x=1184, y=889, z=15}, -- Adicione uma coordenada
{x=1184, y=888, z=15}, -- Adicione uma coordenada
}
	
if getPlayerLevel(cid) >= level then
doPlayerSendTextMessage(cid, 25, "Tenha um bom up.")
doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
return doTeleportThing(cid, location[math.random(#location)])
elseif getPlayerLevel(cid) < level then
doPlayerSendTextMessage(cid, 22, "Sem level suficiente.")
doTeleportThing(cid, teleport)
end
end