local btype = "normal"
local pokemon = "shiny glaceon"
 
local storage = 24365432131242 -- storage
 
 
function onUse(cid, item, frompos, item2, topos)
if getPlayerGroupId(cid) >= 5 then
doBroadcastMessage("o "..getCreatureName(cid).." esta tentando fazer a quest Legend Water ilegalmente")
return true
end
if pokemon == "" then return true end
if getPlayerStorageValue(cid, storage) <= 0 then
addPokeToPlayer(cid, pokemon, 0, nil, btype)
doPlayerAddItem(cid, 2392, 100) -- Não mecha.
doPlayerAddItem(cid, 11453, 1) -- Não mecha.
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Parabéns, você terminou a quest Legend Water!")
doSendMagicEffect(getThingPos(cid), 29)
doSendMagicEffect(getThingPos(cid), 27)
doSendMagicEffect(getThingPos(cid), 29)
doTeleportThing(cid,{x=953,y=1506,z=6})
setPlayerStorageValue(cid, storage, 1)
else
doPlayerSendCancel(cid, "Você já pegou seu prêmio rapaz.")
end
return TRUE
end