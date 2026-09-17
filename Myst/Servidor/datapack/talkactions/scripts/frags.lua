local looktype = 2092
local addons = 3


function onSay(cid, words, param)
	local msg = "Você nessecita colocar o nome do player."
	if param ~= '' and isPlayer(param) then
		local c = getPlayerByName(param)
		doPlayerAddOutfit(cid, looktype, addons)
		msg = "Comando exxecutado com sucesso"
	end
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, msg)
end