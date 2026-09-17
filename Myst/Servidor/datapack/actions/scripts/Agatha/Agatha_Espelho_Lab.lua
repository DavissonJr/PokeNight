local posis = {
{{x = 1511, y = 1153, z = 10}, 1847},  --posiçoes q o espelho pode aparecer, id do espelho(virado para direita/baixo)
{{x = 1566, y = 1092, z = 10}, 1846},
{{x = 1525, y = 1155, z = 10}, 1847},              
{{x = 1585, y = 1108, z = 10}, 1846},
{{x = 1528, y = 1155, z = 10}, 1847},
}

local function randPos(iniPos, posis)
for i = 1, #posis do
    local newPos = posis[math.random(#posis)]
    if not isPosEqual(newPos[1], iniPos) then
       return newPos
    end
end
return posis[math.random(#posis)]
end

function onUse(cid, item, fromPosition, itemEx, toPosition)

if getPlayerStorageValue(cid, Agatha.stoIni) ~= 10 then
return true
end

doSendMagicEffect(getThingPos(item.uid), 19)
doRemoveItem(item.uid, 1)
doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)), false)
doSendMagicEffect(getThingPos(cid), 21)
local newPos = randPos(fromPosition, posis)
local mirror = doCreateItem(newPos[2], 1, newPos[1])
doSetItemAttribute(mirror, "aid", 6657)  --ver isso aki
doSendMagicEffect(newPos[1], 19)
setPlayerStorageValue(cid, Agatha.stoIni, 50)

return true
end  

--<action actionid="xxxx" event="script" value="Agatha_Espelho_Lab.lua"/>  