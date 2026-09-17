local config = {
storage = 242354234, -- storage em que será salvo o tempo
cor = "green", -- de acordo com o constant.lua da lib
tempo = 5, -- em minutos
itemid = 2160,
price = 3, -- quantidade de dinheiro que irá custar
level = 150 -- level pra poder utilizar o broadcast
}
 
 
function onSay(cid, words, param, channel)
if(param == '') then
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você precisa escrever algo.")
return true
end
 
 
if getPlayerLevel(cid) >= config.level then
if getPlayerStorageValue(cid, config.storage) - os.time() <= 0 then
if doPlayerRemoveItem(cid, config.itemid, config.price) then
setPlayerStorageValue(cid, config.storage, os.time() + (config.tempo*1)) 
doBroadcastMessage(""..getCreatureName(cid).." [ANUNCIO]: "..param.."", config.cor)
doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "Você enviou com sucesso um Anuncio, agora você vai ter que esperar " ..config.tempo.. " second(s) until you broadcast again.")
return true
else
doPlayerSendCancel(cid, "Você não tem 300 HDS para anunciar.")
return true
end
else
doPlayerSendCancel(cid, "Você tem que esperar " ..(getPlayerStorageValue(cid, config.storage) - os.time()).. " segundos para anunciar novamente.")
return true
end
else
doPlayerSendCancel(cid, "Você precisa de level 150 para anunciar.")
end
end