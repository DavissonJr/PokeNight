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
if msgcontains(msg, 'torneio') then
selfSay('Para entrar no torneio tem que pagar 20 hundred dollars, vai entrar?', cid)
talkState[talkUser] = 2
elseif talkState[talkUser] == 2 then
if msgcontains(msg, 'yes') or msgcontains(msg, 'sim') then
if os.date("%X") < torneioglobal.startHour4global or os.date("%X") > torneioglobal.endHour4global then
if os.date("%X") < torneioglobal.startHour4global or os.date("%X") > torneioglobal.endHour4global then
if os.date("%X") < torneioglobal.startHour4global or os.date("%X") > torneioglobal.endHour4global then
if os.date("%X") < torneioglobal.startHour4global or os.date("%X") > torneioglobal.endHour4global then
selfSay('Não está na hora do torneio...', cid)
return true
         
         end
      end
   end
end
if  getPlayerFreeCap(cid) >= 3 then
selfSay('Você não pode entrar no torneio global com mais de dois pokemons.', cid)
talkState[talkUser] = 0
return true
end
if doPlayerRemoveMoney(cid, torneioglobal.price) then
doTeleportThing(cid, torneioglobal.waitPlacemary)
if getGlobalStorageValue(844564) < 0 then
atualPremio = 0
else
atualPremio = getGlobalStorageValue(844564)
end
setGlobalStorageValue(844564, atualPremio + 1)
doSendMagicEffect(getPlayerPosition(cid), 21)
else
selfSay('Você não tem dinheiro suficiente.', cid)
end
else
selfSay('Até mais.', cid)
talkState[talkUser] = 0
end
end

if msgcontains(msg, 'yes') or msgcontains(msg, 'sim') then
if os.date("%X") < torneioglobal.startHour4global or os.date("%X") > torneioglobal.endHour4global then
if os.date("%X") < torneioglobal.startHour4global or os.date("%X") > torneioglobal.endHour4global then
if os.date("%X") < torneioglobal.startHour4global or os.date("%X") > torneioglobal.endHour4global then
if os.date("%X") < torneioglobal.startHour4global or os.date("%X") > torneioglobal.endHour4global then
selfSay('Não está na hora do torneio...', cid)
return true
         
         end
      end
   end
end
if  getPlayerFreeCap(cid) >= 3 then
selfSay('Você não pode entrar no torneio global com mais de dois pokemons.', cid)
talkState[talkUser] = 0
return true
end
if doPlayerRemoveMoney(cid, torneioglobal.price) then
doTeleportThing(cid, torneioglobal.waitPlacemary)
if getGlobalStorageValue(844565) < 0 then
atualPremio = 0
else
atualPremio = getGlobalStorageValue(844565)
end
setGlobalStorageValue(844565, atualPremio + 1)
doSendMagicEffect(getPlayerPosition(cid), 21)
else
selfSay('Você não tem dinheiro suficiente.', cid)

end
end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())