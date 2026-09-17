local btype = "normal"
local pokemon = "Shiny Dragonair"
 local storage = 314150
 
 
function onUse(cid, item, frompos, item2, topos)

if getPlayerGroupId(cid) >= 5 then
doBroadcastMessage("o "..getCreatureName(cid).." esta tentando fazer a quest Misterious ilegalmente")
return true
end

if pokemon == "" then return true end
if getPlayerStorageValue(cid, storage) <= 0 then
addPokeToPlayer(cid, pokemon, 0, nil, btype)
doPlayerSendTextMessage(cid, 22, "Parabens voce desvendou com SUCESSO o misterio dos Sabios, como recompensa voce ganhou um "..pokemon..", cuide dele e treine ele, faça por merecer.")
setPlayerStorageValue(cid, storage, 1)
else
doPlayerSendCancel(cid, "Você já fez está quest")
end
return TRUE
end