function onUse(cid, item, fromPosition, itemEx, toPosition)

if getGlobalStorageValue(22549) ~= -1 then
   s = string.explode(getGlobalStorageValue(22549), ",")
   for i = 1, #s do
       if getCreatureName(cid) == s[i] then
          doPlayerSendTextMessage(cid, 20, "You are already registered in the Golden Arena!")
          return true
       end                                                              
   end
   if #s > 15 then
      doPlayerSendTextMessage(cid, 20, "Sorry, but we have reached the limit of players for the Golden Arena!")
      return true
   end
end
                          --alterado v1.3
   doPlayerSendTextMessage(cid, 20, "You spent a Meowth coin! Now attend the next event of the 'Golden Survival Arena'.") 
   doPlayerSendTextMessage(cid, 20, "Check the time for the next event in the billboard on the CP or say /golden horarios.")
   doRemoveItem(item.uid, 1)                                           --alterado v1.2
   
   if getGlobalStorageValue(22549) == -1 then
      setGlobalStorageValue(22549, getCreatureName(cid)..",")
   else                                                                            
      setGlobalStorageValue(22549, getGlobalStorageValue(22549)..""..getCreatureName(cid)..",")
   end
end