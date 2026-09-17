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
if(msgcontains(msg, 'natal') or msgcontains(msg, 'natal')) then
selfSay('Hou Hou Hou eai meu filho preciso que você me traga 10 caixas dos presentes dos gallades para conseguir presentear todas as crianças nesse natal {tenho}.', cid) 
elseif(msgcontains(msg, 'tenho') or msgcontains(msg, 'tenho')) then
selfSay('Você tem certeza que deseja me dar esses lindos presentes ? em troca vou te dar uma coisa que irá ser muito util. {yes}', cid) 
talkState[talkUser] = 1 

 
-- Confirmação da Compra  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then  
if(doPlayerRemoveItem(cid, 27027, 10) == true) then 
selfSay('Hou Hou Hou muito obrigado meu filho..', cid) 
doPlayerAddItem(cid, 2092, 1) 
talkState[talkUser] = 0 
else  
selfSay('Voce nao tem present gallade suficiente.', cid) 
talkState[talkUser] = 0  
end  
end
return TRUE
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback) 
npcHandler:addModule(FocusModule:new())