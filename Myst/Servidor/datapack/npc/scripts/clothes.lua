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
                                                  --alterado v1.8 \/ peguem ele todo!
local outs = {
["jamaican"] = {181601},
["rapper"] = {181602},
["oriental"] = {181603},
["adventurer"] = {181605},
["bussines"] = {181606},
["atletic"] = {181607},
["punk"] = {181608},
["mercenary"] = {181610},
["hiker"] = {181611},
}
msg = string.lower(msg)

        
        if (msgcontains(msg, 'outfit') or msgcontains(msg, 'outfits')) then
           selfSay("I sell this outfits: {Jamaican, Rapper, Oriental, Adventurer, Bussines, Atletic, Punk, Mercenary e Hiker}, which outfit do you want??", cid)
           talkState[talkUser] = 2
        elseif outs[msg] and talkState[talkUser] == 2 then
           selfSay("Are you sure which want buy that outfit?", cid)
           outfit = outs[tostring(msg)]
           talkState[talkUser] = 3
        elseif msgcontains(msg, 'yes') and talkState[talkUser] == 3 then
           if getPlayerStorageValue(cid, outfit[1]) <= 0 then
              if getPlayerPremiumDays(cid) > 0 then
                 if getPlayerMoney(cid) >= 20000 then
                    doPlayerRemoveMoney(cid, 20000)
                    setPlayerStorageValue(cid, outfit[1], 1)
                 else
                     selfSay("You need 200dl to buy this outfit!", cid)
                     talkState[talkUser] = 0
                     return false
                 end
              else
                 selfSay("Need be premium to buy this Outfit.", cid)
                 talkState[talkUser] = 0
                 return false
              end
           else
               selfSay("You already have this outfit, so please, choose another outfit...", cid)
               talkState[talkUser] = 0
               return false
           end
           selfSay("So... Here is.", cid)   
           talkState[talkUser] = 0
           return true
        elseif msgcontains(msg, 'no') and talkState[talkUser] == 3 then
           selfSay("So... Please choose another outfit...", cid)
           talkState[talkUser] = 0                             
        end
return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())             