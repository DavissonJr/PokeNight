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

---------------------- Configs --------------------------- 
local clanNpcs = {
["Seed Trainer"] = {
                       task1 = {
                             ["Seed Trainer"] = {{"Graveler", 20}, {"Starmie", 20}, {"Onix", 25}},
                       },                     
                       task2 = {
                             ["Seed Trainer"] = {{"Marowak", 20}, {"Blastoise", 20}, {"Golem", 25}},
                       },
                       itens = {{12163, 20}, {12202, 5}, {12183, 10}},
                       poke = "Tangela",
                       level = 90,
                       prevRank = 1,
                       nextRank = 2,
},
["Sprout Trainer"] = {
                       task1 = {
                             ["Sprout Trainer"] = {{"Graveler", 20}, {"Starmie", 20}, {"Onix", 25}},
                       },                     
                       task2 = {
                             ["Sprout Trainer"] = {{"Marowak", 20}, {"Blastoise", 20}, {"Golem", 25}},
                       },
                       itens = {{12163, 20}, {12202, 5}, {12183, 10}},
                       poke = "Pinsir",
                       level = 100,
                       prevRank = 2,
                       nextRank = 3,
},
["Webhead Trainer"] = {
                       task1 = {
                             ["Webhead Trainer"] = {{"Graveler", 20}, {"Starmie", 20}, {"Onix", 25}},
                       },                     
                       task2 = {
                             ["Webhead Trainer"] = {{"Marowak", 20}, {"Blastoise", 20}, {"Golem", 25}},
                       },
                       itens = {{12163, 20}, {12202, 5}, {12183, 10}},
                       poke = "Scyther",
                       level = 110,
                       prevRank = 3,
                       nextRank = 4,
},
["Woodtrunk Trainer"] = {
                       task1 = {
                             ["Woodtrunk Trainer"] = {{"Graveler", 20}, {"Starmie", 20}, {"Onix", 25}},
                       },                     
                       task2 = {
                             ["Woodtrunk Trainer"] = {{"Marowak", 20}, {"Blastoise", 20}, {"Golem", 25}},
                       },
                       itens = {{12163, 20}, {12202, 5}, {12183, 10}},
                       poke = "Venusaur",
                       level = 120,
                       prevRank = 4,
                       nextRank = 5,
},
}
------------------------------------------------------------------------------
local npc = clanNpcs[getNpcName()]
       
         if msgcontains(msg, 'help') or msgcontains(msg, 'Help') then
            if getPlayerLevel(cid) < npc.level or getPlayerClanName(cid) ~= 'Naturia' or getPlayerClanRank(cid) ~= npc.prevRank then
               selfSay("I don't need your help!", cid)
               talkState[talkUser] = 0 
               return true
            elseif getPlayerStorageValue(cid, 854789) <= -1 then
               selfSay("So you want to move up of rank on our clan... So, you need to bring some items to me... Do you wanna do it?", cid)
               talkState[talkUser] = 1 
               return true
            elseif getPlayerStorageValue(cid, 854789) == 1 then
               selfSay("So you brought to me the items what i asked for?", cid)
               talkState[talkUser] = 1 
               return true
            elseif getPlayerStorageValue(cid, 854789) == 2 then
               selfSay("The next step is you caught a pokemon to me... Do you wanna do it?", cid)
               talkState[talkUser] = 1 
               return true
            elseif getPlayerStorageValue(cid, 854789) == 3 then
               selfSay("So you caught the pokemon what i asked for?", cid)
               talkState[talkUser] = 1 
               return true 
            elseif getPlayerStorageValue(cid, 854789) == 4 then
               selfSay("Now you need to do some tasks for me... Do you wanna do it?", cid)
               talkState[talkUser] = 1 
               return true 
            elseif getPlayerStorageValue(cid, 854789) == 5 then
               selfSay("So you finished the first task what i asked for?", cid)
               talkState[talkUser] = 1 
               return true
            elseif getPlayerStorageValue(cid, 854789) == 6 then
               selfSay("And now comes the last task... Do you wanna to begin it?", cid)
               talkState[talkUser] = 1 
               return true
            elseif getPlayerStorageValue(cid, 854789) == 7 then
               selfSay("So you finished the last task what i asked for?", cid)
               talkState[talkUser] = 1 
               return true
            end      
         elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'Yes')) and talkState[talkUser] == 1 then 
            if getPlayerStorageValue(cid, 854789) <= -1 then
               local str = "Ok then, you need bring to me: "
               for a = 1, #npc.itens do
                   str = str..(a == #npc.itens and " and " or a ~= 1 and ", " or "{")..(npc.itens[a][2]).." "..(getItemNameById(npc.itens[a][1]))
               end 
               str = str.."}, come back when you join those items!"   
               selfSay(str, cid)
               setPlayerStorageValue(cid, 854789, 1)
               talkState[talkUser] = 0 
               return true 
            elseif getPlayerStorageValue(cid, 854789) == 1 then
               local check = checkItensForTask(cid, npc.itens)
               if check == 0 then
                  selfSay("Ok then, you completed the mission, talk to me again when you want to continue!", cid)
                  setPlayerStorageValue(cid, 854789, 2)
                  talkState[talkUser] = 0 
                  return true
               else
                  selfSay(check, cid)
                  talkState[talkUser] = 0 
                  return true
               end
            elseif getPlayerStorageValue(cid, 854789) == 2 then
               selfSay("Ok then, you need to caught a {"..(npc.poke).."}, and bring it to me... Come back when you do that!", cid)
               setPlayerStorageValue(cid, 854789, 3)
               setPlayerStorageValue(cid, 854788, npc.poke)
               talkState[talkUser] = 0 
               return true
            elseif getPlayerStorageValue(cid, 854789) == 3 then 
               if getPlayerStorageValue(cid, 854788) == 'done' then
                  selfSay("Very well, talk to me again when you want to continue!", cid)
                  setPlayerStorageValue(cid, 854789, 4)
                  setPlayerStorageValue(cid, 854788, -1)
                  setPlayerStorageValue(cid, 854787, npc.poke)
                  talkState[talkUser] = 0 
                  return true
               else
                  selfSay("You didn't caught the pokemon what i asked for! Go do it!", cid)
                  talkState[talkUser] = 0 
                  return true
               end
            elseif getPlayerStorageValue(cid, 854789) == 4 then 
               local sto = getFreeTaskStorage(cid)
               local c = 0
               if sto == -1 then 
                  selfSay("You can't get more tasks! You are already with the maximum of "..(maxTasks).." tasks!", cid)
                  talkState[talkUser] = 0
                  return true
               end
               
               local str = "Ok then, now you need to kill: {"
               for e, f in pairs(npc.task1) do
                   for a = 1, #f do
                       str = str..((a == #f and c ~= 0) and " and " or a ~= 1 and ", " or "")..f[a][2].." "..f[a][1]
                       c = c+1
                   end
               end
               str = str.."} with the {"..(npc.poke).."} which you caught!"
               selfSay(str, cid)
               setPlayerStorageValue(cid, 854789, 5)
               setStorageArray(cid, sto, npc.task1)
               talkState[talkUser] = 0 
               return true
            elseif getPlayerStorageValue(cid, 854789) == 5 then 
               if isMyTaskComplete(cid, getNpcCid()) then
                  selfSay("Very well, you have done my first task... Talk to me again when you want to continue!", cid) 
                  local sto = getMyTaskSto(cid, getNpcCid())
                  setPlayerStorageValue(cid, sto, -1)
                  setPlayerStorageValue(cid, 854789, 6)
                  talkState[talkUser] = 0
                  return true
               else
                  selfSay("You didn't complete my task yet... Go end it!", cid)
                  talkState[talkUser] = 0
                  return true
               end
            elseif getPlayerStorageValue(cid, 854789) == 6 then 
               local sto = getFreeTaskStorage(cid)
               local c = 0
               if sto == -1 then 
                  selfSay("You can't catch more tasks! You are already with the maximum of "..(maxTasks).." tasks!", cid)
                  talkState[talkUser] = 0
                  return true
               end
               
               local str = "Ok then, now for your last task you need to kill: {"
               for e, f in pairs(npc.task2) do
                   for a = 1, #f do
                       str = str..((a == #f and c ~= 0) and " and " or a ~= 1 and ", " or "")..f[a][2].." "..f[a][1]
                       c = c+1
                   end
               end
               str = str.."} with the {"..(npc.poke).."} which you caught!"
               selfSay(str, cid)
               setPlayerStorageValue(cid, 854789, 7)
               setStorageArray(cid, sto, npc.task2)
               talkState[talkUser] = 0 
               return true
            elseif getPlayerStorageValue(cid, 854789) == 7 then
               if isMyTaskComplete(cid, getNpcCid()) then
                  ---
                  local storages = {17000, 63215, 17001, 13008, 5700}     --alterado v1.8
                  for s = 1, #storages do
                      if getPlayerStorageValue(cid, storages[s]) >= 1 then
                         selfSay("You can't do that while is Flying, Riding, Surfing, Diving or mount a bike!", cid) 
                         talkState[talkUser] = 0
                         return true
                      end
                  end
                  if #getCreatureSummons(cid) >= 1 then     --alterado v1.8
                     selfSay("Return your pokemon!", cid) 
                     talkState[talkUser] = 0
                     return true
                  end  
                  ---
                  if checkPokemonForTask(cid, npc.poke) then
                     setPlayerClanRank(cid, npc.nextRank)
                     selfSay("So you complete my last task! Congradulations! Now you move up of rank and become {"..lookClans[getPlayerClanNum(cid)][getPlayerClanRank(cid)].."}!", cid)
                     setPlayerStorageValue(cid, 854789, -1)
                     setPlayerStorageValue(cid, 854787, -1)
                     local sto = getMyTaskSto(cid, getNpcCid())
                     setPlayerStorageValue(cid, sto, -1)
                     talkState[talkUser] = 0
                     return true
                  else
                     selfSay("You aren't with the "..(npc.poke).." which you caught before in your pokebag! Go get it!", cid)
                     talkState[talkUser] = 0
                     return true
                  end   
               else
                  selfSay("You didn't complete my task yet... Go end it!", cid)
                  talkState[talkUser] = 0
                  return true
               end        
            end
         end
              
return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())             