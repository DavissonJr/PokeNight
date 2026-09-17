function onUse(cid, item, fromPosition, itemEx, toPosition)
local function back(item, pos)
doCreateItem(item.itemid, 1, pos)
end

if itemEx.itemid == 12593 then   --id do item  arvore do sudowoodo
   local item = getTileItemById(toPosition, 12593) --id do item  arvore do sudowoodo
   addEvent(back, choose(5, 10, 15) * 60 * 1000, itemEx, toPosition)  --tempo de resp varia de 5~15min
   doRemoveItem(item.uid, 1)
   doSendMagicEffect(toPosition, 1)
   local poke = doCreateMonster("Sudowoodo", toPosition)
   doSendMagicEffect(getThingPos(poke), 168)
   doSetMonsterPassive(poke)               
   doWildAttackPlayer(poke, cid)
end
return true
end