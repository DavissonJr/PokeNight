local config = {
[1] = {remove_id = 7353, remove_quantidade = 115}
}
function onUse(cid, item, frompos, item2, topos)
for i = 1, #config do
if doPlayerRemoveItem(cid, config .remove_id, config.remove_quantidade) then
doTeleportThing(cid, {x=1024, y=544, z=7})
doSendMagicEffect(getPlayerPosition(cid), 21)
doPlayerSendTextMessage(cid, 25,"Parabéns, clique no baú para receber seu prêmio!") 
return true

else
return true
end
end
end
return true