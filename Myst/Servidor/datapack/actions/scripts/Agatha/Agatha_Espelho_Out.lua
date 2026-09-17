local posis = {
{{x = 1057, y = 1044, z = 7}, 1846},  --posiçoes q o espelho pode aparecer, id do espelho
{{x = 1063, y = 908, z = 7}, 1846},
{{x = 720, y = 845, z = 7}, 1846},              
{{x = 699, y = 1086, z = 7}, 1847},
{{x = 729, y = 1191, z = 6}, 1846},
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

if getPlayerLevel(cid) < 100 then
   return true
elseif getPlayerStorageValue(cid, Agatha.stoIni) ~= -1 then
   return true
end  

doSendMagicEffect(getThingPos(item.uid), 19)--mudar eff
doRemoveItem(item.uid, 1)
doTeleportThing(cid, Agatha.posQuest, false)
doSendMagicEffect(getThingPos(cid), 21)
setPlayerStorageValue(cid, Agatha.stoIni, 1)
local newPos = randPos(fromPosition, posis)
local mirror = doCreateItem(newPos[2], 1, newPos[1])
doSetItemAttribute(mirror, "aid", 6658)  
doSendMagicEffect(newPos[1], 19)  --mudar eff

return true
end  

--<action actionid="xxxx" event="script" value="Agatha_Espelho_Out.lua"/>  