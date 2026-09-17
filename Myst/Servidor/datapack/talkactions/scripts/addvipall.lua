function onSay(cid, words, param)

	if not tonumber(param) then
	doPlayerSendCancel(cid, "Escreva quantos dias quer de vip.")
	return true
	end

	for k, v in pairs(getPlayersOnline()) do
		doPlayerAddPremiumDays(v, tonumber(param))
	end

	doBroadcastMessage(getCreatureName(cid) .. " deu " .. param .. " dias de vip para todos os jogadores online.")
return true
end















