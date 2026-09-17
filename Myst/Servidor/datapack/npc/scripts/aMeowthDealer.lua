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


if msgcontains(msg, 'meowth coin') or msgcontains(msg, 'Meowth Coin') then
    selfSay("Tenho uma boa oferta para você, 2 moedas meowth por 1.000 dólares, o que você acha?", cid)
    talkState[cid] = 1
elseif msgcontains(msg, 'yes') or msgcontains(msg, 'Yes') and talkState[cid] == 1 then
    if doPlayerRemoveMoney(cid, 100000) then --1k 
       selfSay("So there is it! Good luck at the event!", cid)
       doPlayerAddItem(cid, 6527, 2)                              --alterado v1.2
       talkState[cid] = 0
       return true
    else
       selfSay("Você não tem dinheiro suficiente!", cid)
       talkState[cid] = 0
       return true
    end
end

return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())