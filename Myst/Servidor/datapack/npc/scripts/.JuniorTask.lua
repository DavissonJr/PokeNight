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

local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
 
local task = {
["Junior"] = {{"Abra", 20}, {"Kadabra", 20}, {"Alakazam", 25}, {"Hypno", 20}},
}
local stoFinal = 9659448
local tFinal = string.explode(getPlayerStorageValue(cid, stoFinal), ",") or {}
       
        if msgcontains(msg, 'task') or msgcontains(msg, 'Task') then
           if getPlayerStorageValue(cid, stoFinal) ~= -1 and isInArray(tFinal, getNpcName()) then
              selfSay("Você já completou minha tarefa!", cid)
              talkState[talkUser] = 0
              return true
           elseif isMyTaskComplete(cid, getNpcCid()) then
              selfSay("Uau, você já completou minha tarefa! Ok, então receba sua recompensa!", cid)
              doPlayerAddItem(cid, 2152, 5)  --premio
              local sto = getMyTaskSto(cid, getNpcCid())
              setPlayerStorageValue(cid, sto, -1)
              local SF = getPlayerStorageValue(cid, stoFinal)
              setPlayerStorageValue(cid, stoFinal, SF == -1 and getNpcName().."," or SF.. getNpcName()..",")
              talkState[talkUser] = 0
              return true
           else
              selfSay("Então, é uma tarefa simples, quero que você mate {20 Abras, 20 Kadabras, 20 Hypnos e 25 Alakazams}, você aceita a tarefa?", cid)
              talkState[talkUser] = 2  
           end   
        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'Yes')) and talkState[talkUser] == 2 then
           if getMyTaskSto(cid, getNpcCid()) ~= -1 then
              selfSay("Você já está fazendo minha tarefa! vá acabar com isso!", cid)
              talkState[talkUser] = 0
              return true
           end
           local sto = getFreeTaskStorage(cid)
           if sto == -1 then 
              selfSay("Você não pode pegar mais tarefas! Você já está com o máximo de tarefas "..(maxTasks).."!", cid)
              talkState[talkUser] = 0
              return true
           end
                  
           selfSay("OK então... Vá matar seus alvos!", cid)
           setStorageArray(cid, sto, task)
           talkState[talkUser] = 0
           return true
        end

return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())             