function onUse(cid, item, fromPosition, itemEx, toPosition)

if getPlayerStorageValue(cid, 326989) <= 0 then
   doPlayerAddItem(cid, 2152, 50)
   doPlayerAddItem(cid, 2392, 10)
   doPlayerAddExp(cid, 2500)
   setPlayerStorageValue(cid, 326989, 1)
   return true
else
   doPlayerSendTextMessage(cid, 20, "You already completed this quest!")
   return true
end
end