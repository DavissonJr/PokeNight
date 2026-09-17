function getPlayerPoints(cid)
	if not isPlayer(cid) then
		return 0
	end

	local pontos = 0
	local resultado = db.getResult("SELECT `premium_points` FROM `accounts` WHERE `id` = " .. getPlayerAccountId(cid) .. ";")
	if resultado:getID() ~= -1 then
		pontos = resultado:getDataInt("premium_points")
	end
	return pontos
end

function doPlayerAddPoints(cid, points)
	if not isPlayer(cid) then
		return true
	end

	local accountId = getPlayerAccountId(cid)
	local points2 = getPlayerPoints(cid)+points
	db.executeQuery("UPDATE `accounts` SET `premium_points` = " .. points2 .. " WHERE `id` = " .. getPlayerAccountId(cid) .. ";")
end


function onSay(cid, words, param)
	local split = param:explode(",")
	if split[1] == "" then
		doPlayerSendTextMessage(cid, 25, "Digite um nome válido.")
		return true
	end

	if split[2] == "" then
		doPlayerSendTextMessage(cid, 25, "Digite pontos válidos.")
		return true
	end

	local name = tostring(split[1])
	local points = tonumber(split[2]) or 1

	for k, v in pairs(getPlayersOnline()) do
		if string.lower(getCreatureName(v)) == string.lower(name) then
			doPlayerAddPoints(v, tonumber(points))
			doPlayerSendTextMessage(cid, 25, "Você deu: " .. points .. " pontos para: " .. name .. ".")
			doPlayerSendTextMessage(v, 25, getCreatureName(cid) .. " te deu: " .. points .. " pontos.")
		end
	end
	return true
end















