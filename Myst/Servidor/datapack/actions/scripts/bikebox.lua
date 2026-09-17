function onUse(cid, item, frompos, item2, topos)

lucas = math.random(1,5)

if getPlayerLevel(cid) >= 1 then

if doPlayerRemoveItem(cid,12939,1) == TRUE then

if lucas == 1 then

doPlayerSendTextMessage(cid,22,"Você ganhou uma Bike Thunder.")

doPlayerAddItem(cid,12935,1)

elseif lucas == 2 then

doPlayerSendTextMessage(cid,22,"Você ganhou uma Bike Leaf.")

doPlayerAddItem(cid,12937,1)

elseif lucas == 3 then

doPlayerSendTextMessage(cid,22,"Você ganhou uma Bike Fire.")

doPlayerAddItem(cid,12938,1)

elseif lucas == 4 then

doPlayerSendTextMessage(cid,22,"Você ganhou uma Bike Water.")

doPlayerAddItem(cid,12936,1)

elseif lucas == 5 then

doPlayerSendTextMessage(cid,22,"Você ganhou uma Bike OLD.")

doPlayerAddItem(cid,12774,1)
elseif lucas == 6 then

end

end

end

end