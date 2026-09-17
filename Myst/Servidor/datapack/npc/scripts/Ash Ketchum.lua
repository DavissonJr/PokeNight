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
   if getPlayerStorageValue(cid, 748513) == 1 then 
      selfSay("Então você tem alguma mensagem da minha mãe?", cid)
      talkState[talkUser] = 1
   else
      selfSay("Eu não preciso de nenhuma ajuda!", cid)
      return true
   end
elseif (msgcontains(string.lower(msg), 'yes') or msgcontains(string.lower(msg), 'sim')) and talkState[talkUser] == 1 then 
   selfSay("Nossa minha mãe está me esperando... eu tinha esquecido o que iria ajudá-la hoje... Muito obrigado, pegue essa recompensa!", cid)
   setPlayerStorageValue(cid, 748513, 2) 
   doPlayerAddExp(cid, 1000)
   doPlayerAddItem(cid, 2394, 20)
   talkState[talkUser] = 0  
end

return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())