local btype = "normal"
local pokemon = "Spiritomb"
local pokemon2 = "Dusknoir"
 
local storage = 243654649 -- storage
 
 
function onUse(cid, item, frompos, item2, topos)
if getPlayerGroupId(cid) >= 5 then
doBroadcastMessage("o "..getCreatureName(cid).." esta tentando fazer a quest Pesadelos ilegalmente")
return true
end

if getPlayerStorageValue(cid, 13444) <= 0 then
    addPokeToPlayer(cid, pokemon2, 0, nil, btype)
    setPlayerStorageValue(cid, 13444, 1)
end

if pokemon == "" then return true end
if getPlayerStorageValue(cid, storage) <= 0 then
addPokeToPlayer(cid, pokemon, 0, nil, btype)
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Parabéns, você terminou a Quest Pesadelo!")
doSendMagicEffect(getThingPos(cid), 29)
doSendMagicEffect(getThingPos(cid), 27)
doSendMagicEffect(getThingPos(cid), 29)
setPlayerStorageValue(cid, storage, 1)
else
doPlayerSendCancel(cid, "Você já pegou o seu prêmio")
end
return TRUE
end