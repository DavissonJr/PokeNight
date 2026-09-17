local coins = 23254

function onUse(cid, item, frompos, item2, topos)
if getPlayerStorageValue(cid, coins) >= 1 then
   doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have "..getPlayerStorageValue(cid, coins).." cassino coins left.")
   return true
end

doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You don't have any cassino coins. To buy coins, order at celadon's cassino.")
return true
end
