local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function doBuyPokemonWithCasinoCoins(cid, poke) npcHandler:onSellpokemon(cid) end
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)

if(not npcHandler:isFocused(cid)) then
return false
end

local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

if msgcontains(string.lower(msg), 'help') or msgcontains(string.lower(msg), 'ajuda') then
   if getPlayerStorageValue(cid, 748513) <= 0 then 
      selfSay("Wow can you help me? I need which you talk with my son, Ash, and tell him to come home, he is in somewhere in Viridian City...", cid)
      talkState[talkUser] = 1
   elseif getPlayerStorageValue(cid, 748513) == 1 then
      selfSay("What are you doing here yet? Please, go talk to my son...", cid)
      return true
   else
      selfSay("Thanks so much for talk with my son!", cid)
      return true
   end
elseif (msgcontains(string.lower(msg), 'yes') or msgcontains(string.lower(msg), 'sim')) and talkState[talkUser] == 1 then 
   selfSay("So, thanks go find my son, he will give to you a reward for you have helped me...", cid)
   setPlayerStorageValue(cid, 748513, 1) 
   talkState[talkUser] = 0  
end

return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())