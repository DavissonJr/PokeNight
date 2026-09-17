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

local item,pos = 2123,{x = 1037, y = 1036, z = 7}

if (msgcontains(msg, 'quero') or msgcontains(msg, 'sim'))then
npcHandler:say("Você quer ir mesmo para Saffron? diga {yes}", cid)
talkState[talkUser] = 1
elseif msgcontains(msg, 'yes') and talkState[talkUser] == 1 then
if getPlayerItemCount(cid, item) >= 0 then 
doTeleportThing(cid, pos)
doSendMagicEffect(getPlayerPosition(cid),21)
else
npcHandler:say("Você não tem o item!", cid)
end
elseif msg == "no" then 
selfSay("Then not", cid) 
talkState[talkUser] = 0 
npcHandler:releaseFocus(cid) 
end
return TRUE
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())