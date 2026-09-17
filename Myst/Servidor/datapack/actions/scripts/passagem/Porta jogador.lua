function onUse(cid, item, fromPosition, item2, toPosition)

	local teleport = {x=807, y=2685, z=5}-- Coordenadas para onde o player irá ser teleportado.
	local item1 = 2092 -- ID do item1 que o player precisa para ser teleportado.

	
	if getPlayerItemCount(cid,item1) >= 1 then
 doPlayerRemoveItem(cid, item1, 1)
				doTeleportThing(cid, teleport)
				doSendMagicEffect(getPlayerPosition(cid), 21)
			else
				doPlayerSendTextMessage(cid, 25, "Você não tem a chave")
				doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
				return true
			end
end