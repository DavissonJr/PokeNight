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
selfSay('Eu compro ice orb, imam e thunder stone, tem algum?.', cid) 
elseif(msgcontains(msg, 'ice orb') or msgcontains(msg, 'ice orb')) then
selfSay('Eu pago 1 tina argentina por 100 ice orb vai querer?', cid) 
talkState[talkUser] = 1 
elseif(msgcontains(msg, 'imam') or msgcontains(msg, 'imam')) then
selfSay('Eu pago 1 tina brasil em 100 imam vai querer?', cid) 
talkState[talkUser] = 2 
elseif(msgcontains(msg, 'thunder stone') or msgcontains(msg, 'thunder stone')) then
selfSay('Eu pago uma tina box por 25 thunder stone vai querer?', cid) 
talkState[talkUser] = 3 
  
 
-- Confirmação da Compra  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then  
if(doPlayerRemoveItem(cid, 12201, 100) == true) then 
selfSay('Obrigado!', cid) 
doPlayerAddItem(cid, 13618, 1) 
talkState[talkUser] = 0 
else  
selfSay('Você não tem  ice orb suficiente.', cid) 
talkState[talkUser] = 0  
end  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 2) then  
if(doPlayerRemoveItem(cid, 12198, 100) == true) then 
selfSay('Obrigado!', cid) 
doPlayerAddItem(cid, 13619, 1)
talkState[talkUser] = 0
else
selfSay('Você não tem imam suficiente.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 3) then  
if(doPlayerRemoveItem(cid, 2159, 100) == true) then  
selfSay('Obrigado!', cid) 
doPlayerAddItem(cid, 13394, 1)
talkState[talkUser] = 0 
else  
selfSay('Você não tem scarab suficientes.', cid) 
talkState[talkUser] = 0  
end 
end
return TRUE
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback) 
npcHandler:addModule(FocusModule:new())