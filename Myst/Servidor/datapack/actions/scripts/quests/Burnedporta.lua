function onUse(cid, item, fromPosition, item2, toPosition)

	local teleport = {x=858, y=2493, z=6}-- Coordenadas para onde o player irá ser teleportado.
	local item1 = 2159 -- ID do item1 que o player precisa para ser teleportado.
	local item2 = 2318 -- ID do item1 que o player precisa para ser teleportado.
	local item3 = 2174 -- ID do item1 que o player precisa para ser teleportado.
	
	if getPlayerItemCount(cid,item1) >= 200 then
	if getPlayerItemCount(cid,item2) >= 200 then
	if getPlayerItemCount(cid,item3) >= 200 then
				doTeleportThing(cid, teleport)
				doSendMagicEffect(getPlayerPosition(cid), 21)
				doPlayerSendTextMessage(cid, 25, "Bem-vindo. Você foi digno de passar!")
				return true
			else
				doPlayerSendTextMessage(cid, 25, "Você ainda não e digno de passar.")
				doPlayerSendTextMessage(cid, 26, "Você ainda não merece passar.")
				doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
				return true
			end
else
				doPlayerSendTextMessage(cid, 25, "Você ainda não e digno de passar.")
				doPlayerSendTextMessage(cid, 26, "Você ainda não merece passar.")
				doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
				return true
			end
			else
				doPlayerSendTextMessage(cid, 25, "Parece que essa porta esta selada conta entrada de intrusos")
				doPlayerSendTextMessage(cid, 26, "Você ainda não merece passar.")
				doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
				return true
			end
end