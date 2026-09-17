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
if(msgcontains(msg, 'rochas') or msgcontains(msg, 'rochas')) then
selfSay('Eu compro water stone, fire stone e scarab coins, tem algum?.', cid) 
elseif(msgcontains(msg, 'fire stone') or msgcontains(msg, 'fire stone')) then
selfSay('Eu pago 50 diamantes por 100 fire stones vai querer?', cid) 
talkState[talkUser] = 1 
elseif(msgcontains(msg, 'water stone') or msgcontains(msg, 'water stone')) then
selfSay('Eu pago 1 boost stone em 100 water stone vai querer?', cid) 
talkState[talkUser] = 2 
elseif(msgcontains(msg, 'scarab coins') or msgcontains(msg, 'scarab coins')) then
selfSay('Eu pago um addon especial por 100 scarab coins eae vai querer?', cid) 
talkState[talkUser] = 3 
  
 
-- Confirmação da Compra  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then  
if(doPlayerRemoveItem(cid, 11447, 100) == true) then 
selfSay('Thanks!', cid) 
doPlayerAddItem(cid, 2145, 50) 
talkState[talkUser] = 0 
else  
selfSay('Voce nao tem  fire stone suficiente.', cid) 
talkState[talkUser] = 0  
end  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 2) then  
if(doPlayerRemoveItem(cid, 11442, 100) == true) then 
selfSay('Thanks!', cid) 
doPlayerAddItem(cid, 12618, 1)
talkState[talkUser] = 0
else
selfSay('Voce nao tem water stone suficiente.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 3) then  
if(doPlayerRemoveItem(cid, 2159, 100) == true) then  
selfSay('Thanks!', cid) 
doPlayerAddItem(cid, 13394, 1)
talkState[talkUser] = 0 
else  
selfSay('Voce nao tem  scarabs suficiente.', cid) 
talkState[talkUser] = 0  
end 
end
return TRUE
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback) 
npcHandler:addModule(FocusModule:new())