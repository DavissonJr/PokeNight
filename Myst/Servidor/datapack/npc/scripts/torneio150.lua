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

if not isPlayer(cid) then return true end
local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

if msgcontains(msg, 'torneio') then

if getPlayerItemCount(cid, torneio.revivePoke) >= 1 then
selfSay('Você não pode entrar no torneio portando revives.', cid)
return true
end

if getTopt(cid) >= 300 then
selfSay('Desculpa, você já atingiu o máximo de torneios ganhos!', cid)
return true
end
-- if getPlayerLevel(cid) >= 150 then
-- selfSay('Desculpa, apenas players level 150- podem ir no torneio de kanto!', cid)
-- return true
-- end

selfSay('Para entrar no torneio tem que pagar 20 hundred dollars, vai entrar?', cid)
talkState[talkUser] = 2

elseif talkState[talkUser] == 2 then

if msgcontains(msg, 'yes') or msgcontains(msg, 'sim') then
if os.date("%X") < torneiokanto.startHour1kanto or os.date("%X") > torneiokanto.endHour1kanto then
if os.date("%X") < torneiokanto.startHour2kanto or os.date("%X") > torneiokanto.endHour2kanto then
if os.date("%X") < torneiokanto.startHour3kanto or os.date("%X") > torneiokanto.endHour3kanto then
if os.date("%X") < torneiokanto.startHour4kanto or os.date("%X") > torneiokanto.endHour4kanto then

selfSay('Não está na hora do torneio...', cid)
return true
         
      end
   end
end
end

if getPlayerMoney(cid) < torneiokanto.pricekanto then
   selfSay('Você não tem dinheiro suficiente.', cid)
   return true
end

doPlayerRemoveMoney(cid, torneiokanto.pricekanto)
doTeleportThing(cid, torneiokanto.waitPlackanto)
if getGlobalStorageValue(5778415) < 0 then
atualPremio = 0
else
atualPremio = getGlobalStorageValue(5778415)
end
setGlobalStorageValue(5778415, atualPremio + 1)
doSendMagicEffect(getPlayerPosition(cid), 21)
else
selfSay('Você não tem dinheiro suficiente.', cid)
end
else
selfSay('Até mais.', cid)
talkState[talkUser] = 0
end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())