function onUse(cid, item, frompos, item2, topos)
 
local level = 150 -- coloque o Level aqui
 
if getPlayerLevel(cid) >= level then
doTeleportThing(cid, {x=1038, y=1030, z=4})
doSendMagicEffect(getPlayerPosition(cid), 21)
else
doPlayerSendTextMessage(cid, 25, "Proibida a entrada de fly,ride e player -150")
end
 
return TRUE
end