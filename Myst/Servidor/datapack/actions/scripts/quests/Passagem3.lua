function onUse(cid, item, fromPosition, item2, toPosition)

	local teleport = {x=839, y=2781, z=8}-- Coordenadas para onde o player irá ser teleportado.
	local item1 = 4852 -- ID do item1 que o player precisa para ser teleportado.
	local item2 = 2142 -- ID do item2 que o player precisa para ser teleportado.
	
	if getPlayerItemCount(cid,item1) >= 0 then
		if getPlayerItemCount(cid,item2) >= 0 then
				doTeleportThing(cid, teleport)
								doSendMagicEffect(getPlayerPosition(cid), 21)

				doPlayerSendTextMessage(cid, 25, "biiii")
			else
				doPlayerSendTextMessage(cid, 25, "Ainda falta alguma coisa.")
				doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
				return true
			end
		else
			doPlayerSendTextMessage(cid, 25, "Ainda falta alguma coisa.")
			doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
			return true
		end
end