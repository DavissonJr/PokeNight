function onSay(cid, words, param)
local param = param.explode(param, ',')
if param then
if isPlayer(getCreatureByName(param[1])) == TRUE then
doPlayerSendTextMessage(getCreatureByName(param[1]), 22, "[Loja]: Você comprou um item na VIP SHOP, o item já foi entregue.")
doPlayerAddItem(getCreatureByName(param[1]), param[2], param[3])
end
else
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
end
return TRUE
end