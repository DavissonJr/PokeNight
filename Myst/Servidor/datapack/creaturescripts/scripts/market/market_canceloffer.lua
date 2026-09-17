-- Criado por Thalles Vitor --
-- Market send items to category seller --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 105 then
		local param = buffer:explode("@")
		local numeration = tonumber(param[1])

		doSendPlayerExtendedOpcode(cid, 114, "destroy2".."@")
		sendMarketCancelOffer(cid, numeration) -- source function
		
		doSendPlayerExtendedOpcode(cid, 114, "destroy".."@")
 		addEvent(sendMarketAllOffers, 1500, cid) -- source function
		addEvent(sendMarketMyOffers, 1000, cid)
	end
	return true
end