local items = {13089, 13091, 13092, 13394, 13098, 13099, 13106, 27990, 27993, 27996, 13391, 13393, 13264, 13326, 13251, 27995, 28003, 28001, 27988, 28000, 28004, 13426, 27991, 27997, 27998}
local chancenada = 10

function onUse(cid, item)
doPlayerAddItem(cid, items[math.random(1, #items)], 1)
-- doBroadcastMessage("O "..getCreatureName(cid).." acabou de ganha um addon parabens!",19)
doRemoveItem(item.uid, 1)
return true
end 