local items = {13394, 13252}
local chancenada = 10

function onUse(cid, item)
doPlayerAddItem(cid, items[math.random(1, #items)], 1)
-- doBroadcastMessage("O "..getCreatureName(cid).." acabou de abrir uma Wr Addon Box!",19)
doRemoveItem(item.uid, 1)
return true
end 