function onSay(cid, words, param)
	local split = param:explode(",")
	if split[1] == "" then
		doPlayerSendTextMessage(cid, 25, "Digite um nome válido.")
		return true
	end

	if split[2] == "" then
		doPlayerSendTextMessage(cid, 25, "Digite dias válidos.")
		return true
	end

	local name = tostring(split[1])
	local vip = tonumber(split[2]) or 1

	for k, v in pairs(getPlayersOnline()) do
		if string.lower(getCreatureName(v)) == string.lower(name) then
			doPlayerAddPremiumDays(v, tonumber(vip))
			doPlayerSendTextMessage(cid, 25, "Você deu: " .. vip .. " dias de vip para: " .. name .. ".")
			doPlayerSendTextMessage(v, 25, getCreatureName(cid) .. " te deu: " .. vip .. " dias de vip.")
		end
	end
	return true
end















