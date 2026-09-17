function onUse(cid, item, fromPosition, itemEx, toPosition)

if getPlayerItemCount(cid, Agatha.colar) <= 0 then
   return true
elseif getPlayerStorageValue(cid, Agatha.stoIni) ~= 1 then
   return true
elseif getPlayerStorageValue(cid, Agatha.stoRec) == -1 or getPlayerStorageValue(cid, Agatha.stoRec) == 0 then
   return true
end
 
local respostas = string.explode(tostring(getPlayerStorageValue(cid, Agatha.stoRec)), ";")
respostas[1] = respostas[1]:sub(2, #respostas[1])
if item.actionid == tonumber(respostas[1]) then
   table.remove(respostas, 1)
   sendMsgToPlayer(cid, 27, "Voce encontrou o item correto!")
   if not next(respostas) then 
      setPlayerStorageValue(cid, Agatha.stoRec, 0)
      
      local item = doPlayerAddItem(cid, Agatha.pocao, 1)
      doSetItemAttribute(item, "aid", 6660)
      
      sendMsgToPlayer(cid, 20, "Parabens, você completou o primeiro desafio!")
      doSendMagicEffect(getThingPos(cid), 21) --mudar eff
   else
      respostas[1] = " ".. respostas[1] 
      setPlayerStorageValue(cid, Agatha.stoRec, table.concat(respostas, ";"))
   end
else
   setPlayerStorageValue(cid, Agatha.stoRec, -1)
   for i = 1, #Agatha.stoPergs do
       setPlayerStorageValue(cid, Agatha.stoPergs[i], -1)
   end
   sendMsgToPlayer(cid, 27, "Voce nao encontrou o item correto. Volte e pegue a receita novamente!")
end

return true
end  

--<action actionid="6617-6653" event="script" value="Agatha_Items.lua"/>  