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
------------------------------
local function checkDex(cid)
local unlock = 0
	for i = 1, #oldpokedex do
		if getPlayerInfoAboutPokemon(cid, oldpokedex[i][1]).dex then
		   unlock = unlock + 1
		end
	end
return unlock
end
------------------------------
if msgcontains(string.lower(msg), 'help') or msgcontains(string.lower(msg), 'ajuda') then
local check = checkDex(cid)   
   if check >= 15 then
      if getPlayerStorageValue(cid, 748512) <= 0 then 
         selfSay("Wow i see that you have already atleast 15 pokemons in your pokedex! Take this reward!", cid)
         setPlayerStorageValue(cid, 748512, 1)
         doPlayerAddExp(cid, 1000)  --exp
         doPlayerAddItem(cid, 2152, 1)   --100dl
         doPlayerAddItem(cid, 11453, 1)  --heart stone
      else
         selfSay("I already have given a reward to you...", cid)
      end
   else
      selfSay("You must have discovered at least 15 pokemons in your pokedex to take the reward!", cid)
   end    
end

return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())