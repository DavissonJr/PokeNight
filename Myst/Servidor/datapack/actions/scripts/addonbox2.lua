local items = {13264, 13619, 13394, 13617, 13620, 13616, 13618}
local chancenada = 10

function onUse(cid, item)
doPlayerAddItem(cid, items[math.random(1, #items)], 1)
doBroadcastMessage("O "..getCreatureName(cid).." acabou de ganhar um addon parabéns!",19)
doRemoveItem(item.uid, 1)
return true
end 