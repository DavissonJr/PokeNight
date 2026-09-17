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
 
       
        if (msgcontains(msg, 'clan') or msgcontains(msg, 'Clan')) then   --alterado v1.7
           if getPlayerClanName(cid) == 'Gardestrike' then       --alterado v1.7
              selfSay("You already are of the clan Gardestrike!", cid)
              talkState[talkUser] = 0
              return true
           elseif getPlayerClanNum(cid) ~= -1 then            --alterado v1.7
              selfSay("You already are of another clan!", cid)
              talkState[talkUser] = 0
              return true    
           end
              selfSay("So you want to join in my clan... Are you sure that?", cid)
              talkState[talkUser] = 2  
        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'Yes')) and talkState[talkUser] == 2 then
           if getPlayerLevel(cid) < 80 then
              selfSay("You are too weak yet... You need to be atleast level 80 to enter in the clan!", cid)
              talkState[talkUser] = 0
              return true
           end
           selfSay("OK then... Now you are a great member of de clan Gardestrike!", cid)
           setPlayerClan(cid, 'Gardestrike')  --alterado v1.7
           talkState[talkUser] = 0
           
           
        elseif (msgcontains(msg, 'leave') or msgcontains(msg, 'Leave')) then  --alterado v1.7  \/
           if getPlayerClanName(cid) ~= 'Gardestrike' then 
              selfSay("You aren't of the clan, get out of here!", cid)
              talkState[talkUser] = 0
              return true
           else
              selfSay("So you want to leave the clan... Are you sure that?", cid)
              talkState[talkUser] = 3
           end
        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'Yes')) and talkState[talkUser] == 3 then 
           if removePlayerClan(cid) then
              selfSay("Ok then, good luck!", cid)
              talkState[talkUser] = 0
              return true
           else
              selfSay("You have some task to finish of one trainer! Go finish it!", cid)
              talkState[talkUser] = 0
              return true
           end
           
           
        elseif (msgcontains(msg, 'shiny') or msgcontains(msg, 'Shiny')) then    --alterado v1.7
           if getPlayerSlotItem(cid, 8).uid <= 0 then
              selfSay("Sorry, you don't have a pokemon in the main slot!", cid)
              talkState[talkUser] = 0
		      return true
	       end                                       --alterado v1.4
	       
	       ball = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke")
	       if not isInArray({"Hitmonlee", "Hitmonchan", "Hitmontop"}, ball) then
	          selfSay("Put a Hitmonchan's pokeball or a Hitmonlee's pokeball or a Hitmontop's pokeball atleast +20 in main slot!", cid)
              talkState[talkUser] = 0
              return true
           end                                        --alterado v1.4
           
           if getPlayerClanName(cid) ~= 'Gardestrike' and ball == "Hitmontop" then  --alterado v1.7
              selfSay("You aren't of the clan Gardestrike! Get out of here!", cid)
              talkState[talkUser] = 0
              return true
           else
              selfSay("So you want to transform your "..ball.." in a Shiny "..ball.."? It will cost 200k!", cid)
              talkState[talkUser] = 4
           end
        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'Yes')) and talkState[talkUser] == 4 then
           if getPlayerSlotItem(cid, 8).uid <= 0 then
              selfSay("Sorry, you don't have a pokemon in the main slot!", cid)
              talkState[talkUser] = 0
		      return true
	       end 
	                                                                             --alterado v1.2
	       if #getCreatureSummons(cid) >= 1 then
	          selfSay("Go back your pokemon!", cid)
              talkState[talkUser] = 0
              return true
           end
	       
	       local pb = getPlayerSlotItem(cid, 8).uid
	       
	       if not isInArray({"Hitmonlee", "Hitmonchan", "Hitmontop"}, getItemAttribute(pb, "poke")) then
	          selfSay("Put a Hitmonchan's pokeball or a Hitmonlee's pokeball or a Hitmontop's pokeball atleast +20 in main slot!", cid)
              talkState[talkUser] = 0
              return true
           end                                                                       --alterado v1.4
           
           if getPlayerClanName(cid) ~= 'Gardestrike' and getItemAttribute(pb, "poke") == "Hitmontop" then --alterado v1.7
              selfSay("You aren't of the clan Gardestrike! Get out of here!", cid)
              talkState[talkUser] = 0
              return true 
           end  
              
           if not getItemAttribute(pb, "boost") or getItemAttribute(pb, "boost") < 20 then
              selfSay("Sorry, your "..getItemAttribute(pb, "poke").." is not boosted +20!", cid)
              talkState[talkUser] = 0
              return true
           end
                                          --100000 = 1k, 1000000 = 10k, 10000000 = 100k
           if doPlayerRemoveMoney(cid, 20000000) == true then
              selfSay("So there is it! Enjoy!", cid)
              local name = getItemAttribute(pb, "poke")
              doItemSetAttribute(pb, "hp", 1)
              doItemSetAttribute(pb, "poke", "Shiny "..getItemAttribute(pb, "poke"))
		      doItemSetAttribute(pb, "description", "Contains a Shiny "..getItemAttribute(pb, "poke")..".")
		      doItemEraseAttribute(pb, "boost")
		      doTransformItem(getPlayerSlotItem(cid, 7).uid, fotos["Shiny "..name])
		      if useKpdoDlls then
		        doCreatureExecuteTalkAction(cid, "/pokeread")
	          end
		      talkState[talkUser] = 0
		      return true
	      else
	          selfSay("You don't have enough money!", cid)
	          talkState[talkUser] = 0
	          return true
          end
        end

return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())             