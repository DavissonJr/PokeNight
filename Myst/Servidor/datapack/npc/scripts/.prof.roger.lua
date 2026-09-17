local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function doBuyPokemonWithCasinoCoins(cid, poke) npcHandler:onSellpokemon(cid) end
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

function creatureSayCallback(cid, type, msg)

if(not npcHandler:isFocused(cid)) then
return false
end


local function givePokemon(cid)
local pokemon = "Aerodactyl"
local gender = getRandomGenderByName(pokemon)
local btype = "normal"
local happy = 220

if getPlayerFreeCap(cid) >= 6 or not hasSpaceInContainer(getPlayerSlotItem(cid, 3).uid) then
   item = doCreateItemEx(11826)
else
    item = doAddContainerItem(getPlayerSlotItem(cid, 3).uid, 11826, 1) 
end

doItemSetAttribute(item, "poke", pokemon)
doItemSetAttribute(item, "hp", 1)
doItemSetAttribute(item, "happy", happy)
doItemSetAttribute(item, "gender", gender)
doItemSetAttribute(item, "description", "Contains a "..pokemon..".")
doItemSetAttribute(item, "fakedesc", "Contains a "..pokemon..".")

if getPlayerFreeCap(cid) >= 6 or not hasSpaceInContainer(getPlayerSlotItem(cid, 3).uid) then
   doPlayerSendMailByName(getCreatureName(cid), item, 1)
end
doPlayerRemoveItem(cid, rock, 100)   --aki tira as rocks
doPlayerRemoveItem(cid, old, 1)      --aki tira o old
selfSay("So there is it! Take this pokemon, I think he will be better with you!", cid)
setPlayerStorageValue(cid, 345965, 2)   --storage da quest
end

rock = 11445    --id da rock stone
old = 12581         --id do old amber.. 

if msgcontains(string.lower(msg), 'help') or msgcontains(string.lower(msg), 'ajuda') then
    selfSay("Hum... Preciso de alguns itens para minhas pesquisas... Você pode me trazer um Old Amber e 100x Rock stones?", cid)
    talkState[talkUser] = 1
elseif (msgcontains(string.lower(msg), 'yes') or msgcontains(string.lower(msg), 'sim')) and talkState[talkUser] == 1 then
    if getPlayerStorageValue(cid, 345965) <= 0 then
       selfSay("Ok, então vá e traga esses itens para mim e talvez possamos reviver um Pokémon antigo e raro!", cid)
       setPlayerStorageValue(cid, 345965, 1)
       talkState[talkUser] = 0
       return true
    elseif getPlayerStorageValue(cid, 345965) == 1 then
       if getPlayerItemCount(cid, rock) >= 100 and getPlayerItemCount(cid, old) >= 1 then   --ta pedindo 100Rocks e 1 Old amber...
          selfSay("Uau, então você conseguiu os itens! Deixe-me ver se consigo reviver aquele pokémon!", cid)
          addEvent(givePokemon, 2000, cid)
          talkState[talkUser] = 0
          return true
       else
          selfSay("Você ainda não tem meus itens... Volte quando pegá-los!!", cid)
          talkState[talkUser] = 0
          return true
       end
    elseif getPlayerStorageValue(cid, 345965) == 2 then                        --no caso soh da pra fazer isso 1x por char...
       selfSay("Hummm.. Você já me ajuda, não é? Obrigado mais uma vez.. mas agora não posso falar com você...", cid)
       talkState[talkUser] = 0
       return true
    end     
end

return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())