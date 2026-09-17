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
selfSay('Eu troco 1 dia de vip em troca de 6 strange symbol, caso tiver interessado diga {sim}.', cid) 
elseif(msgcontains(msg, 'sim') or msgcontains(msg, 'sim')) then
selfSay('Tem certeza que deseja trocar comigo ? {yes}', cid) 
talkState[talkUser] = 1 

 
-- Confirmação da Compra  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then  
if(doPlayerRemoveItem(cid, 2174, 6) == true) then 
selfSay('Obrigado te amo.', cid) 
doPlayerAddItem(cid, 10503, 1) 
talkState[talkUser] = 0 
else  
selfSay('Você não tem strange symbol suficiente.', cid) 
talkState[talkUser] = 0  
end  
end
return TRUE
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback) 
npcHandler:addModule(FocusModule:new())