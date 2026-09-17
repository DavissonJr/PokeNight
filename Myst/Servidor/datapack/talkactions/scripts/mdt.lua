function onSay(cid, words, param)
local storage = 121212
local staff = getPlayerGroupId(cid)    
local storage1 = getPlayerStorageValue(cid,storage)
if(param == "") then
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
elseif getPlayerGroupId(cid) >= 2 and param == "off" then
setPlayerStorageValue(cid,storage,staff) 
doPlayerSetGroupId(cid,1)
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você entrou em modo de JOGO.")
elseif storage1 >= 2 and param == "on" then
doPlayerSetGroupId(cid,storage1) 
doPlayerSetStorageValue(cid,storage,1)
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você entrou em modo de TRABALHO.")
elseif (getPlayerGroupId(cid) >= 2 and param == "on") or (storage1 >= 2 and param == "off") then
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você já está nesse modo de jogo.")
else
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não pertence a staff.")
end
end