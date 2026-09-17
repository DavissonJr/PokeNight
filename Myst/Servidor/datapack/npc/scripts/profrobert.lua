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

local places = {
["saffron"] = 2,
["cerulean"] = 3,
["lavender"] = 4,
["fuchsia"] = 6,
["celadon"] = 1, 
["viridian"] = 9, 
["vermilion"] = 5, 
["pewter"] = 10,                      
["cinnabar"] = 7,
}
       
        if msgcontains(string.lower(msg), 'city') or msgcontains(string.lower(msg), 'citys') then
           if getPlayerStorageValue(cid, 9658754) == 1 then
              selfSay("Você já escolheu sua cidade Inicial!", cid)
              return true
           else
              selfSay("Você escolhe qual cidade para começar?: {Saffron, Cerulean, Lavender, Fuchsia, Celadon, Viridian, Vermilion, Pewter or Cinnabar}.", cid) 
              return true
           end
        elseif places[string.lower(msg)] then
           city = string.lower(msg)
           selfSay("Você tem certeza que quer começar em {".. doCorrectString(msg) .."} como sua cidade Inicial?", cid) 
           talkState[talkUser] = 2
           return true
       elseif msgcontains(msg, "yes") or msgcontains(msg, "Yes") and talkState[talkUser] == 2 then   
           if getPlayerStorageValue(cid, 9658754) == 1 then
              selfSay("Voce ja Escolheu sua cidade Inicial!", cid)
              talkState[talkUser] = 0
              return true
           else
              selfSay("OK Voce agora é um Treinador de ".. doCorrectString(city)..". Boa Sorte na sua Jornada Pokemon!", cid)
              doPlayerSetTown(cid, places[city])
              setPlayerStorageValue(cid, 9658754, 1)
              talkState[talkUser] = 0
              return true
           end
        elseif msgcontains(msg, "no") or msgcontains(msg, "No") and talkState[talkUser] == 2 then  
           selfSay("Ok, me fale novamente onde deseja começar sua jornada pokémon.", cid)
           talkState[talkUser] = 0
           return true 
        end

return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())             