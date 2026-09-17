local btype = "normal"
local pokemon = "Drapion"
 local storage = 314164
 
 
function onUse(cid, item, frompos, item2, topos)

if getPlayerGroupId(cid) >= 5 then
doBroadcastMessage("o "..getCreatureName(cid).." esta tentando fazer a quest Fossil ilegalmente")
return true
end

if pokemon == "" then return true end
if getPlayerStorageValue(cid, storage) <= 0 then
addPokeToPlayer(cid, pokemon, 0, nil, btype)
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você terminou a Quest Fossil!")
doTeleportThing(cid,{x=1225, y=2415, z=8})
setPlayerStorageValue(cid, storage, 1)
else
doPlayerSendCancel(cid, "Você já fez está quest")
end
return TRUE
end