function onSay(cid, words, param)

if param == '' then
   sendMsgToPlayer(cid, 20, "Param required.\n!task [name npc] or !task npcs")
   return true
end

if param == "npcs" or param == "Npcs" then
   local str = "Name of npcs of task: \n\n"
   local send = false
   for i = 91001, (91000+maxTaGhosting) do
       if getPlayerStorageValue(cid, i) ~= -1 and tostring(getPlayerStorageValue(cid, i)) then
          local array = getArrayFromStorage(cid, i)
          if arrayHasContent(array) then
             for e, f in pairs(array) do
                 local j = e
                 if string.find(e, "Trainer") then
                    if getPlayerStorageValue(cid, 854789) == 5 then
                       j = j.."_1"
                    elseif getPlayerStorageValue(cid, 854789) == 7 then
                       j = j.."_2"
                    end
                 end
                 if npcsTask[j] then
                    str = str..e.."\n"
                    send = true
                 end
             end
          end
       end
   end
if send then
   doShowTextDialog(cid, 2395, str)
else
   doShowTextDialog(cid, 2395, "You don't have any task at the moment!")
end
return true
end   

local npc = doCorrectString(tostring(param))
local npc2 = npc
local sto = getMyTaGhostingto(cid, npc)
local str = "Name: "..npc..".\n"

if npcsTask[npc.."_1"] then
   if getPlayerStorageValue(cid, 854789) == 5 then
      npc2 = npc2.."_1"
   elseif getPlayerStorageValue(cid, 854789) == 7 then
      npc2 = npc2.."_2"
   end
end

if sto == -1 or not npcsTask[npc2] then
   doShowTextDialog(cid, 2395, "You don't have any task from this npc!")
   return true
end
 
if isMyTaskComplete(cid, npc) then
   str = str.."Task: "..npcsTask[npc2][2]..".\n"
   str = str.."Status: Completed.\n"
   str = str.."City: "..npcsTask[npc2][1]..".\n"
   str = str.."Reward: "..npcsTask[npc2][3].."."
else
   str = str.."Task: "..npcsTask[npc2][2]..".\n"
   str = str.."Status: Not Completed.\n"
   str = str.."Have to Kill: "..getStingOfTask(cid, npc)
   str = str.."City: "..npcsTask[npc2][1]..".\n"
   str = str.."Reward: "..npcsTask[npc2][3].."."
end
doShowTextDialog(cid, 2395, str)
return true
end