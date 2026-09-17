function onSay(cid, words, param)

	if not tonumber(param) then
	doPlayerSendCancel(cid, "Escreva quantos dias quer de vip.")
	return true
	end

	doPlayerAddPremiumDays(cid, tonumber(param))


return true
end















