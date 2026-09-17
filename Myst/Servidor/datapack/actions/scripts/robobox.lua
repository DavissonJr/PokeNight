function onUse(cid, item, frompos, item2, topos)

lucas = math.random(1,5)

if getPlayerLevel(cid) >= 1 then

if doPlayerRemoveItem(cid,13246,1) == TRUE then

if lucas == 1 then

doPlayerSendTextMessage(cid,22,"Você ganhou um Water Robo.")

doPlayerAddItem(cid,13246,1)

elseif lucas == 2 then

doPlayerSendTextMessage(cid,22,"Você ganhou um Dark Robo.")

doPlayerAddItem(cid,13246,1)

elseif lucas == 3 then

doPlayerSendTextMessage(cid,22,"Você ganhou um Leaf robo Robo.")

doPlayerAddItem(cid,13246,1)

elseif lucas == 4 then

doPlayerSendTextMessage(cid,22,"Você ganhou um Dark Robo.")

doPlayerAddItem(cid,13246,1)

elseif lucas == 5 then

doPlayerSendTextMessage(cid,22,"Você ganhou um Robo.")

doPlayerAddItem(cid,13245,1)

end

end

end

end