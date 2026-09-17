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
["Agatha"] = {{"Shiny Abra", 100}},
}
local stoFinal = 9659448     
local tFinal = getPlayerStorageValue(cid, stoFinal) ~= -1 and string.explode(getPlayerStorageValue(cid, stoFinal), ",") or {}
local msg = msg:lower()
       
        if msgcontains(msg, 'help') or msgcontains(msg, 'yes') and (not talkState[talkUser] or talkState[talkUser] == 0) then
           if getPlayerStorageValue(cid, stoFinal) ~= -1 and isInArray(tFinal, getNpcName()) then
              selfSay("Você já completou minha missão!", cid)
              talkState[talkUser] = 0
              return true
           elseif isMyTaskComplete(cid, getNpcCid()) then
              selfSay("Então você completou minha missão... Receba esta recompensa e boa sorte em sua jornada!", cid)
              
              doPlayerAddItem(cid, 12618, 2)  --premio  
              setPlayerStorageValue(cid, Agatha.stoIni, 100) 
              doPlayerAddExp(cid, 250000)
              
              local sto = getMyTaskSto(cid, getNpcCid())
              setPlayerStorageValue(cid, sto, -1)
              local SF = getPlayerStorageValue(cid, stoFinal)
              setPlayerStorageValue(cid, stoFinal, SF == -1 and getNpcName().."," or SF.. getNpcName()..",")
              talkState[talkUser] = 0
              return true
           elseif getMyTaskSto(cid, getNpcCid()) ~= -1 then
              selfSay("Você já está fazendo minha tarefa! Vá acabar com isso!", cid)
              talkState[talkUser] = 0
              return true
           elseif getPlayerStorageValue(cid, Agatha.stoIni) ~= 50 or getPlayerLevel(cid) < 100 then
              selfSay("I don't wanna talk with you!", cid)
              talkState[talkUser] = 0
              return true
           else
              selfSay("Então, é uma tarefa simples, quero que você mate {100 Shiny Abras}, você aceita a tarefa?", cid)
              talkState[talkUser] = 2  
           end   
        elseif msgcontains(msg, 'yes') and talkState[talkUser] == 2 then
           if getMyTaskSto(cid, getNpcCid()) ~= -1 then
              selfSay("Você já está fazendo minha tarefa! Vá acabar com isso!", cid)
              talkState[talkUser] = 0
              return true
           end
           local sto = getFreeTaskStorage(cid)
           if sto == -1 then 
              selfSay("Você não pode pegar mais tarefas! Você já está com o máximo de tarefas "..(maxTasks).."!", cid)
              talkState[talkUser] = 0
              return true
           end
                  
           selfSay("Ok, então vá até as pirâmides e encontre a entrada do santuário dos Dark Abras!", cid)
           setStorageArray(cid, sto, task)
           setPlayerStorageValue(cid, Agatha.stoIni, 75) 
           talkState[talkUser] = 0
           return true
        end

return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())             