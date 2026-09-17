-- Criado por Thalles Vitor --
-- Porta Burned --

function onUse(cid, item, frompos, item2, topos)
	local pos = getCreaturePosition(cid)
	doPlayerSendTextMessage(cid, 25, "Bem-vindo!")
	doTeleportThing(cid, {x=pos.x+2, y=pos.y, z=pos.z})
	doSendMagicEffect(getThingPos(cid), CONST_ME_TELEPORT)
	return true
end