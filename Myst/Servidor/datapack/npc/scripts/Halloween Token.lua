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
if(msgcontains(msg, 'trocar') or msgcontains(msg, 'trocar')) then
selfSay('Eu pago 1 Shiny Stone em troca de 1 Halloween Token, caso tiver interessado diga {sim}.', cid) 
elseif(msgcontains(msg, 'sim') or msgcontains(msg, 'sim')) then
selfSay('Tem certeza que deseja trocar comigo ? {yes}', cid) 
talkState[talkUser] = 1 

 
-- Confirmação da Compra  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then  
if(doPlayerRemoveItem(cid, 26849, 1) == true) then 
selfSay('Obrigado te amo.', cid) 
doPlayerAddItem(cid, 13088, 3) 
talkState[talkUser] = 0 
else  
selfSay('Voce nao tem Halloween Token suficiente.', cid) 
talkState[talkUser] = 0  
end  
end
return TRUE
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback) 
npcHandler:addModule(FocusModule:new())