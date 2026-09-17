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

------------------------------------------------------------
local function buyPoke(cid, pokemon, price)              --alterado v1.9 \/ tudo!
if not pokes[pokemon] then return false end

local gender = getRandomGenderByName(pokemon)
local btype = "normal"
local happy = 250

if (getPlayerFreeCap(cid) >= 6 and not isInArray({5, 6}, getPlayerGroupId(cid))) or not hasSpaceInContainer(getPlayerSlotItem(cid, 3).uid) then 
   item = doCreateItemEx(11826)
else
    item = addItemInFreeBag(getPlayerSlotItem(cid, 3).uid, 11826, 1)   
end

doItemSetAttribute(item, "poke", pokemon)
doItemSetAttribute(item, "hp", 1)
doItemSetAttribute(item, "happy", happy)
doItemSetAttribute(item, "gender", gender)
doItemSetAttribute(item, "description", "Contains a "..pokemon..".")
doItemSetAttribute(item, "fakedesc", "Contains a "..pokemon..".")
                                                                             
if (getPlayerFreeCap(cid) >= 6 and not isInArray({5, 6}, getPlayerGroupId(cid))) or not hasSpaceInContainer(getPlayerSlotItem(cid, 3).uid) then 
   doPlayerSendMailByName(getCreatureName(cid), item, 1)
   selfSay("Your pokemon was sent to Pokemon Center!", cid)
end
   setPlayerStorageValue(cid, 23254, getPlayerStorageValue(cid, 23254) - price)
   return true
end

local pokes = {
["eevee"] = {poke = "Eevee", price = 6500000},
["porygon"] = {poke = "Porygon", price = 8500000},
["ditto"] = {poke = "Ditto", price = 10000000},
["mr. mime"] = {poke = "Mr. Mime", price = 5000000},
}
local msg = tonumber(msg) and msg or msg:lower()
------------------------------------------------------------------------------

if msgcontains(msg, 'pokemon') or msgcontains(msg, 'prizes') then
   selfSay("I have four Pokemons to choose one among them: {Eevee}, {Porygon}, {Ditto} and {Mr. Mime}, which would you choose? ", cid)
   talkState[cid] = 1
   return true
   
elseif pokes[msg] and talkState[cid] == 1 then
   pokemon = pokes[msg]
   selfSay("Are you sure you want buy an ".. doCorrectString(msg) .." for ".. pokemon.price .." cassino coins?", cid)
   talkState[cid] = 2
   return true
   
elseif (msgcontains(msg, "yes") or msgcontains(msg, "sim")) and talkState[cid] == 2 then
   if getPlayerStorageValue(cid, 23254) >= pokemon.price then
      selfSay("Here you are! You have just bought an "..pokemon.poke.." for "..pokemon.price.." casino coins!", cid)
      buyPoke(cid, pokemon.poke, pokemon.price)
      talkState[cid] = 0
      return true
   else
      selfSay("You don't have enought cassino coins, bye", cid)
      talkState[cid] = 0
      return true 
   end
end

if (msgcontains(msg, "buy coins") or msgcontains(msg, "buy cassino coins")) and (not talkState[cid] or talkState[cid] == 0) then
   selfSay("So... you want to buy coins. How many? Say a number between 1 and 1000!", cid)
   talkState[cid] = 3
   return true
   
elseif tonumber(msg) and tonumber(msg) >= 1 and tonumber(msg) <= 1000 and talkState[cid] == 3 then
   coins = tonumber(msg)
   price = tonumber(msg) / 100
   moneyMsg = price < 1 and price*100 .. " cent(s)" or price .. " dollar(s)" 
   
   selfSay("It will cost ".. moneyMsg ..", are you sure you want this?", cid)
   talkState[cid] = 4
   return true
   
elseif (msgcontains(msg, "yes") or msgcontains(msg, "sim")) and talkState[cid] == 4 then
   if doPlayerRemoveMoney(cid, coins) then
      selfSay("Enjoy it with wisdom...", cid)
      if getPlayerStorageValue(cid, 23254) < 0 then setPlayerStorageValue(cid, 23254, 0) end
      setPlayerStorageValue(cid, 23254, getPlayerStorageValue(cid, 23254) + coins)
      talkState[cid] = 0
      return true
   else
      selfSay("You don't have ".. moneyMsg .."...", cid)
      talkState[cid] = 0
      return true
   end
end

if (msgcontains(msg, "sell coins") or msgcontains(msg, "sell cassino coins")) and (not talkState[cid] or talkState[cid] == 0) then
   selfSay("How many coins you want back to money? Say a number between 1 and 1000!", cid)
   talkState[cid] = 5
   return true
   
elseif tonumber(msg) and tonumber(msg) >= 1 and tonumber(msg) <= 1000 and talkState[cid] == 5 then
   coinsBack = tonumber(msg)
   selfSay("Do you want ".. coinsBack .." coins back to money?", cid)
   talkState[cid] = 6
   return true
  
elseif (msgcontains(msg, "yes") or msgcontains(msg, "sim")) and talkState[cid] == 6 then
   if getPlayerStorageValue(cid, 23254) >= coinsBack then
      setPlayerStorageValue(cid, 23254, getPlayerStorageValue(cid, 23254) - coinsBack)
      doPlayerAddMoney(cid, coinsBack)
      selfSay("Here is your money.", cid)
      talkState[cid] = 0
      return true
   else
      selfSay("You don't have that much of coins!", cid)
      talkState[cid] = 0
      return true
   end
end

if (msgcontains(msg, "no") or msgcontains(msg, "nao")) then
   selfSay("Ok then, come back if you want something...", cid)
   talkState[cid] = 0
   return true     
end

end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())