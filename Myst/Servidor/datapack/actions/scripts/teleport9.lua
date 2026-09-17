local level = 150
local storage = 43432432441112312
local teleport = {x=1036, y=1034, z=7}

function onUse(cid, item, fromPosition, item2, toPosition)

location = {
{x=862, y=40, z=15}, -- Adicione uma coordenada
{x=862, y=40, z=15}, -- Adicione uma coordenada
{x=862, y=40, z=15}, -- Adicione uma coordenada
}
	
if getPlayerLevel(cid) >= level then
doPlayerSendTextMessage(cid, 25, "Bem vindo a hunt dos Inicial Charizard :D!")
doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
return doTeleportThing(cid, location[math.random(#location)])
elseif getPlayerLevel(cid) < level then
doPlayerSendTextMessage(cid, 22, "Sem level suficiente.")
doTeleportThing(cid, teleport)
end
end