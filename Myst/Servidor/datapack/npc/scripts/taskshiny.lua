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
if(msgcontains(msg, 'mew') or msgcontains(msg, 'mew')) then
selfSay('Eu troco 1 shiny stone em troca de 10 fragmentos de mew, você tem interesse? diga {tenho}.', cid) 
elseif(msgcontains(msg, 'tenho') or msgcontains(msg, 'tenho')) then
selfSay('Você tem certeza que quer trocar esses belos fragmentos comigo? diga {yes}', cid) 
talkState[talkUser] = 1 

 
-- Confirmação da Compra  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then  
if(doPlayerRemoveItem(cid, 26849, 10) == true) then 
selfSay('Obrigado por trocar comigo, te amo.', cid) 
doPlayerAddItem(cid, 13088, 1) 
talkState[talkUser] = 0 
else  
selfSay('Você não tem Mew Fragment suficiente.', cid) 
talkState[talkUser] = 0  
end  
end
return TRUE
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback) 
npcHandler:addModule(FocusModule:new())