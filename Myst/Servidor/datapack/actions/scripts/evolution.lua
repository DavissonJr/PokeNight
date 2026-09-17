-- Criado por Thalles Vitor --

function onUse(cid, item, frompos, item2, topos)
   if not isSummon(item2.uid) then
      return true
   end

   onSendEvolveWindow(cid, getCreatureName(item2.uid), item.itemid)
   return true
end