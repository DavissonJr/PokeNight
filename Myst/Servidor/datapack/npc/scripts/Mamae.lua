local keywordHandler = KeywordHandler:new() 
local npcHandler = NpcHandler:new(keywordHandler) 
NpcSystem.parseParameters(npcHandler) 
local talkState = {} 
 
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end 
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end 
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end 
function onThink() npcHandler:onThink() end 
 
function creatureSayCallback(cid, type, msg) 
if(not npcHandler:isFocused(cid)) then 
return false  
end  
 
local talkUser = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid  
 
-- Conversa Jogador/NPC  
if(msgcontains(msg, 'presente') or msgcontains(msg, 'presente')) then
selfSay('Eu vendo Shiny Stone, Bike Box, Vip 30 days. Diga qual voce quer adquirir.', cid) 
elseif(msgcontains(msg, 'Shiny Stone') or msgcontains(msg, 'Shiny stone')) then
selfSay('A Shiny Stone custa 500 Diamantes, Você vai querer?', cid) 
talkState[talkUser] = 1 
elseif(msgcontains(msg, 'Bike Box') or msgcontains(msg, 'Bike Box')) then
selfSay('A Bike Box Custa 400 Diamantes, Você vai querer?', cid) 
talkState[talkUser] = 2 
elseif(msgcontains(msg, 'Vip 30 Days') or msgcontains(msg, 'Vip 30 Days')) then
selfSay('O Vip 30 days custa 600 Diamantes, Você vai querer?', cid) 
talkState[talkUser] = 3 
  
 
-- Confirmação da Compra  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then  
if(doPlayerRemoveItem(cid, 2145, 500) == true) then 
selfSay('Thanks!', cid) 
doPlayerAddItem(cid, 13088, 1) 
talkState[talkUser] = 0 
else  
selfSay('Voce nao tem  diamantes suficiente.', cid) 
talkState[talkUser] = 0  
end  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 2) then  
if(doPlayerRemoveItem(cid, 2145, 400) == true) then 
selfSay('Thanks!', cid) 
doPlayerAddItem(cid, 12939, 1)
talkState[talkUser] = 0
else
selfSay('Voce nao tem diamantes suficiente.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 3) then  
if(doPlayerRemoveItem(cid, 2145, 600) == true) then  
selfSay('Thanks!', cid) 
doPlayerAddItem(cid, 2345, 1)
talkState[talkUser] = 0 
else  
selfSay('Voce nao tem  diamantes suficiente.', cid) 
talkState[talkUser] = 0  
end 
end
return TRUE
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback) 
npcHandler:addModule(FocusModule:new())