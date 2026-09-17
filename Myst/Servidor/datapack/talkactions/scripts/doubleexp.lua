function onSay(cid, words, param, channel)
local rate = 20 -- 100 %
local calc = rate * 10 / 100
local aberto = "fechado"
if (param == 'closeevent') then
	if getPlayerAccess(cid) > 4 then
	db.executeQuery("UPDATE `player_storage` SET  `value` =  '0' WHERE `key` ='102590';")
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Voce cancelou o Evento Double EXP.")
return true
	end
	return true
elseif (param == 'openevent') then
	if getPlayerAccess(cid) > 4 then
	db.executeQuery("UPDATE `player_storage` SET  `value` =  '0' WHERE `key` ='102590';")
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Voce abriu o Evento Double EXP.")
aberto = "aberto"
return true
	end
	return true
end
if getPlayerStorageValue(cid, 102590) < 1 then
doPlayerSetExperienceRate(cid, rate)
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Agora você possui " .. calc .. "% de EXP a mais.")
doPlayerPopupFYI(cid, "Agora você possui " .. calc .. "% de EXP a mais.")
setPlayerStorageValue(cid, 102590, 1)
return true
else
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Voce ja esta com " .. calc .. "% de EXP a mais, aguarde o evento acabar.")
return true
end
return true
end