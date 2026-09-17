function onUse(cid, item, fromPosition, itemEx, toPosition)

if getPlayerItemCount(cid, Agatha.colar) <= 0 then
   return true
elseif getPlayerStorageValue(cid, Agatha.stoIni) ~= 1 then
   return true
end

if itemEx.itemid == Agatha.pilar then
   doSendMagicEffect(toPosition, 25) --alterar eff
   doTeleportThing(cid, Agatha.posLab, false)
   doSendMagicEffect(getThingPos(cid), 21)
   
   setPlayerStorageValue(cid, Agatha.stoIni, 10)
   setPlayerStorageValue(cid, Agatha.stoRec, -1)
   setPlayerStorageValue(cid, Agatha.stoEni, -1)
   setPlayerStorageValue(cid, Agatha.stoRes, -1)
   for i = 1, #Agatha.stoPergs do
       setPlayerStorageValue(cid, Agatha.stoPergs[i], -1)
   end
 
   local colar = getItemsInContainerById(getPlayerSlotItem(cid, 3).uid, Agatha.colar)
   local perg = getItemsInContainerById(getPlayerSlotItem(cid, 3).uid, 12638)
   if #colar >= 1 then
      doRemoveItem(colar[1], 1)
   end
   if #perg >= 1 then
      doRemoveItem(perg[1], 1)
   end 
   doRemoveItem(item.uid, 1)
end  
return true
end    

--<action actionid="6661" event="script" value="Agatha_Hammer.lua"/>