function onUse(cid, item, frompos, item2, topos)
 
if getPlayerStorageValue(cid, 990) >= 1 then
doPlayerSendCancel(cid, "You can't use revive during gym battles.")
return true
end
 
if getPlayerStorageValue(cid, 52481) >= 1 then
  return doPlayerSendCancel(cid, "You can't do that while a duel.") --alterado v1.6
    end
                 --
if item2.itemid <= 0 or not isPokeball(item2.itemid) then
doPlayerSendCancel(cid, "Please, use revive only on pokeballs.")
return true
end

doTransformItem(item2.uid, pokeballs[getPokeballType(item2.itemid)].on)
doSetItemAttribute(item2.uid, "hp", 1)
for c = 1, 15 do
    local str = "move"..c
    setCD(item2.uid, str, 0)
end

setCD(item2.uid, "control", 0)
setCD(item2.uid, "blink", 0)  --alterado v1.6

doSendMagicEffect(getThingPos(cid), 13)
doRemoveItem(item.uid, 1)
doCureBallStatus(item2.uid, "all")
cleanBuffs2(item2.uid)  
updateLifeBarRevive(cid, item2.uid)
 
return true
end