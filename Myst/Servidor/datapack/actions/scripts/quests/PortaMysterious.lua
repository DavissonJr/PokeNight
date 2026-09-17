function onUse(cid, item, frompos, item2, topos)

if item.itemid == 1435 or item.itemid == 1437 then

player1pos = {x = 1994, y = 1794, z = 5,  stackpos=253}

player1 = getThingfromPos(player1pos)

player2pos = {x = 1995, y = 1794, z = 5, stackpos=253}

player2 = getThingfromPos(player2pos)

player3pos = {x = 1997, y = 1794, z = 5, stackpos=253}

player3 = getThingfromPos(player3pos)


if player1.itemid <= 4852 and player2.itemid <= 4852 and player3.itemid <= 4852 and player1.itemid <= 4852 and  player1.itemid <= 2142 and player2.itemid <= 2142 and player3.itemid <= 2142 then

queststatus1 = getPlayerStorageValue(player1.uid,6027)

queststatus2 = getPlayerStorageValue(player2.uid,6027)

queststatus3 = getPlayerStorageValue(player3.uid,6027)

if queststatus1 == -1 and queststatus2 == -1 and queststatus3 == -1 then

nplayer1pos = {x = 940, y = 3773, z = 7}

nplayer2pos = {x = 941, y = 3773, z = 7}

nplayer3pos = {x = 942, y = 3773, z = 7}


doSendMagicEffect(player1pos,2)

doSendMagicEffect(player2pos,2)

doSendMagicEffect(player3pos,2)




doTeleportThing(player1.uid,nplayer1pos)

doTeleportThing(player2.uid,nplayer2pos)

doTeleportThing(player3.uid,nplayer3pos)


doSendMagicEffect(nplayer1pos,10)

doSendMagicEffect(nplayer2pos,10)

doSendMagicEffect(nplayer3pos,10)


doTransformItem(item.uid,item.itemid+0)

else

doPlayerSendTextMessage(cid,25, "Ainda falta alguma coisa.")

end


else

doPlayerSendTextMessage(cid,25, "Ainda falta alguma coisa.")

end

elseif item.itemid == 1437 then

if getPlayerAccess(cid) == 3 then

doTransformItem(item.uid,item.itemid-1)

else


end

end


return true

end
