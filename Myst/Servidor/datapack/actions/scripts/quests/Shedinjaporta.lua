function onUse(cid, item, fromPosition, item2, toPosition)

	local teleport = {x=717, y=2546, z=8}-- Coordenadas para onde o player irá ser teleportado.
	local item1 = 11449 -- ID do item1 que o player precisa para ser teleportado.
	local item2 = 13088 -- ID do item1 que o player precisa para ser teleportado.
	
	if getPlayerItemCount(cid,item1) >= 50 then
	if getPlayerItemCount(cid,item2) >= 1 then
				doTeleportThing(cid, teleport)
				doSendMagicEffect(getPlayerPosition(cid), 21)
				doPlayerRemoveItem(cid, item1, 50)
				doPlayerRemoveItem(cid, item2, 1)
			else
				doPlayerSendTextMessage(cid, 26, "Você precisa dos itens para fazer o ritual")
				doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
				return true
			end
else
				doPlayerSendTextMessage(cid, 26, "Você precisa dos itens para fazer o ritual")
				doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
				return true
			end
end