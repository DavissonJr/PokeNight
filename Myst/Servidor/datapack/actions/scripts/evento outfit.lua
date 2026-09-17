local level = 100
local storage = 43432432441
local teleport = {x=1036, y=1034, z=7}

function onUse(cid, item, fromPosition, item2, toPosition)

location = {
{x=1100, y=697, z=15}, -- Adicione uma coordenada
{x=1112, y=697, z=15}, -- Adicione uma coordenada
}
	
if getPlayerLevel(cid) >= level then
doPlayerSendTextMessage(cid, 25, "Voce passou, agora vamos ver se tera sorte!")
doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
return doTeleportThing(cid, location[math.random(#location)])
elseif getPlayerLevel(cid) < level then
doPlayerSendTextMessage(cid, 22, "Sem level suficiente.")
doTeleportThing(cid, teleport)
end
end