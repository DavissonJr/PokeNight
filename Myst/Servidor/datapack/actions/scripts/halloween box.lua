local items = {13105,13107,13249,13251}
local chancenada = 10

function onUse(cid, item)
if math.random(1,500) > 400 then
addPokeToPlayer(cid, "Shiny Gengar", 0, 1, "ultra", false)    
end
doPlayerAddItem(cid, items[math.random(1, #items)], 1)
doRemoveItem(item.uid, 1)
return true
end 