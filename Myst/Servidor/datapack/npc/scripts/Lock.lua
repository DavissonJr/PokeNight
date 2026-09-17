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

       
        if msgcontains(msg, 'lock') or msgcontains(msg, 'Lock') then
           selfSay("So you want to lock your pokemon... Ok then, put your pokemon in the pokeball slot and say how many days you want to lock, say a number between 1 and 90!", cid)
           talkState[talkUser] = 1
           return true
           
        elseif tonumber(msg) ~= nil and talkState[talkUser] == 1 then
           local number = tonumber(msg)
           local ball = getPlayerSlotItem(cid, 8)
           if number <= 0 or number >= 91 then
              selfSay("I told you to say a number between 1 and 90, say again how many days do you want?", cid)
              return true
           elseif not isPokeball(ball.itemid) then
              selfSay("Put a pokemon in the correct slot and say again how many days do you want!", cid)
              return true
           elseif getItemAttribute(ball.uid, "lock") and getItemAttribute(ball.uid, "lock") > 0 then
              selfSay("This pokeball already is locked!", cid)
              talkState[talkUser] = 0
              return true  
           elseif getItemAttribute(ball.uid, "unique") then
              selfSay("This pokeball already is a unique item!", cid)
              talkState[talkUser] = 0
              return true     
           else 
              local days = number * 24 * 60 * 60
              doItemSetAttribute(ball.uid, "lock", os.time()+days)
              doItemSetAttribute(ball.uid, "unique", getCreatureName(cid))
              
              selfSay("There is it, good luck!", cid)
              talkState[talkUser] = 0
              return true
           end
        end

return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())             