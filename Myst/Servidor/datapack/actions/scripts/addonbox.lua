local items = {13090, 13253, 13252, 13390, 13392, 13380, 13395, 13093, 13095, 13096, 13094, 13101, 13097, 13102, 13100, 13103, 13104, 13296, 13297, 13298, 13108, 13109, 13110, 13111, 13112, 13113, 13114, 13115, 13408, 13410, 13407, 13409}
local chancenada = 10

function onUse(cid, item)
doPlayerAddItem(cid, items[math.random(1, #items)], 1)
-- doBroadcastMessage("O "..getCreatureName(cid).." acabou de ganha um addon parabens!",19)
doRemoveItem(item.uid, 1)
return true
end 