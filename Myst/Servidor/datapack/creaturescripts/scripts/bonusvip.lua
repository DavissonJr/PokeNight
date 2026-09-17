function onLogin(cid)

	local rating = 1.2 -- 50%
	local config = 
	{
		welvip = "[Account VIP] Você é um membro VIP, e por isso você tem um Bônus de EXP.",
		not_vip = "[Account Free] Torne-se VIP e tenha beneficios exclusivos.",
	}

	if isPremium(cid) then
		doPlayerSetExperienceRate(cid, rating)
		doPlayerSendTextMessage(cid, 26, config.welvip)
	else
		doPlayerSendTextMessage(cid, 26, config.not_vip)
	end
	
	return true
end