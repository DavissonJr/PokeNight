local item1 = "2318"
local item2 = "2159"
local item3 = "2174"
local btype = "normal"   ----Tipo de Pokeball 
local pokemon = "Shiny Drapion"  ----Pokémon que virá no bau

local storage = 90032 -- storage para nao pegar o premio + de 1 vez
 
 
function onUse(cid, item, frompos, topos)
if getPlayerGroupId(cid) >= 5 then
doBroadcastMessage("o "..getCreatureName(cid).." esta tentando fazer a quest Burned ilegalmente")
return true
end
if pokemon == "" then return true end
if getPlayerStorageValue(cid, storage) <= 0 then
addPokeToPlayer(cid, pokemon, 0, nil, btype)
doPlayerRemoveItem(cid, item1, 200)
doPlayerRemoveItem(cid, item2, 200)
doPlayerRemoveItem(cid, item3, 200)
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Voce pegou seu "..pokemon.."!!")    ----Mensagem que o player receberá
doSendMagicEffect(getThingPos(cid), 29)
doSendMagicEffect(getThingPos(cid), 27)
doSendMagicEffect(getThingPos(cid), 29)
doPlayerAddItem(cid, 2160, 0)      -----Items adicionais para vir no bau (no caso 100 Thousand Dolar Notes)
setPlayerStorageValue(cid, storage, 1)
else
doPlayerSendCancel(cid, "Você já pegou seu Pokémon") ---Mensagem q sera enviada quando o player tentar fazer a quest + de 1 vez
end
return true 
end