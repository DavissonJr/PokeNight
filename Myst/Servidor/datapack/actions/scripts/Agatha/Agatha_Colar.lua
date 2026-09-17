function onUse(cid, item, fromPosition, itemEx, toPosition)

if getPlayerStorageValue(cid, Agatha.stoIni) ~= 1 then
   return true
elseif getPlayerItemCount(cid, Agatha.colar) >= 1 then
   return true
end

doPlayerAddItem(cid, Agatha.colar, 1)

return true
end  

--<action actionid="6616" event="script" value="Agatha_Colar.lua"/>  