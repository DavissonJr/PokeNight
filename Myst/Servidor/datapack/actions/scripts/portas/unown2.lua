function onUse(cid, item, fromPosition, item2, toPosition)

	local teleport = {x = 771, y = 2827, z = 8}-- Coordenadas para onde o player irá ser teleportado.
	local item1 = 2086 -- ID do item1 que o player precisa para ser teleportado.

	
	if getPlayerItemCount(cid,item1) >= 1 then
		doPlayerRemoveItem(cid,2086,1)
				doTeleportThing(cid, teleport)
				doPlayerSendTextMessage(cid, 25, "Aceito.")
				doSendMagicEffect(getPlayerPosition(cid), 21)
			else
				doPlayerSendTextMessage(cid, 25, "Ainda falta alguma coisa.")
				doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
				return true
			end

end