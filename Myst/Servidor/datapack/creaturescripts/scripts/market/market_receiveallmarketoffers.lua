-- Criado por Thalles Vitor --
-- Market send all items offers to client again --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 117 then
		local param = buffer:explode("@")
		local type = tostring(param[1])

		doSendPlayerExtendedOpcode(cid, 114, "destroy".."@")
 		addEvent(sendMarketAllOffers, 1500, cid) -- source function
		addEvent(sendMarketMyOffers, 1000, cid)
	end
	return true
end