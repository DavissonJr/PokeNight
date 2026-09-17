local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local pos = {x=152,y=58,z=7} -------------- POS DA ARENA
local hundred = 2152 ----------------- ID DO HUNDRED

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)

if(not npcHandler:isFocused(cid)) then
return false
end

if msgcontains(msg, "hi") then
selfSay("Bem-vindo, eu sou o responsável pelo Torneio. Se você quiser participar, diga 'torneio' para entrar", cid)
talkState[cid] = 0
elseif msgcontains(msg, 'torneio') or msgcontains(msg, 'yes') then
if doPlayerRemoveItem(cid, hundred, 3) then
selfSay("Boa sorte.", cid)
doTeleportThing(cid, pos)
else
selfSay("Você não tem dinheiro para se inscrever no Torneio.", cid)
end
end
return TRUE
end


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
