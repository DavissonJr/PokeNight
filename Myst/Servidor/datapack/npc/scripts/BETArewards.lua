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

premio = {      --id box / qntdade / id balls
[-1] = {premio = {11449, {10, 2391}}, level = 25}, --box +1
[0] = {premio = {11640, {15, 2392}}, level = 40}, --box +2
}

if msgcontains(string.lower(msg), 'recompensas') or msgcontains(string.lower(msg), 'recompensa') then
    if premio[getPlayerStorageValue(cid, 85499)] then
       reward = premio[getPlayerStorageValue(cid, 85499)]
       if getPlayerLevel(cid) >= reward.level then
          selfSay("Parabéns você chegou ao level "..reward.level..". Leve sua recompensa!", cid)
          doPlayerAddItem(cid, reward.premio[1], 1)
          doPlayerAddItem(cid, reward.premio[2][2], reward.premio[2][1])
          setPlayerStorageValue(cid, 85499, getPlayerStorageValue(cid, 85499)+1)
       else
          selfSay("Você ainda não tem level "..reward.level.." para pegar sua recompensa!", cid) 
          return true
       end
    else      
       selfSay("Você já pegou todas suas recompensas!", cid)
       return true
    end
end

return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())