function onUse(cid, item, fromPosition, itemEx, toPosition)

if getPlayerItemCount(cid, Agatha.colar) <= 0 then
   return true
elseif getPlayerStorageValue(cid, Agatha.stoIni) ~= 1 then
   return true
elseif getPlayerStorageValue(cid, Agatha.stoPergs[1]) ~= -1 then
   local t = {}
   for i = 1, #Agatha.stoPergs do
       table.insert(t, getPlayerStorageValue(cid, Agatha.stoPergs[i]))
   end
   return doShowTextDialog(cid, item.itemid, table.concat(t, "\n")) and true
end

return true
end  

--<action actionid="6654" event="script" value="Agatha_Receita.lua"/>  