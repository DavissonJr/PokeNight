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
if(msgcontains(msg, 'Demon') or msgcontains(msg, 'demon')) then
selfSay('Eu troco {santa doll addons}, {box vip}, {bike box}, voce tem algum interesse ?.', cid) 
elseif(msgcontains(msg, 'santa doll addons') or msgcontains(msg, 'Santa Doll Addons')) then
selfSay('Eu quero 15 present demon em troca da santa doll, voce vai querer ?', cid) 
talkState[talkUser] = 1 
elseif(msgcontains(msg, 'Box Vip') or msgcontains(msg, 'box vip')) then
selfSay('Eu pago 1 box vip em troca de 2 present demon, vai querer ?', cid) 
talkState[talkUser] = 2 
elseif(msgcontains(msg, 'Bike Box') or msgcontains(msg, 'bike box')) then
selfSay('Eu pago 1 bike box em troca de 6 present demon, vai querer ?', cid) 
talkState[talkUser] = 3 
  
 
-- Confirmação da Compra  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then  
if(doPlayerRemoveItem(cid, 27071, 15) == true) then 
selfSay('Thanks!', cid) 
doPlayerAddItem(cid, 13117, 1) 
talkState[talkUser] = 0 
else  
selfSay('Voce nao present demon suficientes.', cid) 
talkState[talkUser] = 0  
end  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 2) then  
if(doPlayerRemoveItem(cid, 27071, 2) == true) then 
selfSay('Thanks!', cid) 
doPlayerAddItem(cid, 10503, 1)
talkState[talkUser] = 0
else
selfSay('Voce nao tem present demon suficientes.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 3) then  
if(doPlayerRemoveItem(cid, 27071, 6) == true) then  
selfSay('Thanks!', cid) 
doPlayerAddItem(cid, 12939, 1)
talkState[talkUser] = 0 
else  
selfSay('Voce nao tem present demon suficientes.', cid) 
talkState[talkUser] = 0  
end 
end
return TRUE
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback) 
npcHandler:addModule(FocusModule:new())