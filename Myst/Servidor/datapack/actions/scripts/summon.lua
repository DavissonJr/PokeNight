function onUse(cid, item, fromPosition, itemEx, toPosition)


	 local config = {
 
 [27452] = {fruit = 3610}

 }


local respawn = {"Legendary Venusaur"}


if not isPlayer(cid) then

return true

end

if getPlayerLevel(cid) >= 100 then

pokemon = doCreateMonster(respawn[math.random(1, #respawn)], getCreaturePosition(cid))

doTransformItem(item.uid, 3610, 1)

end

doCreatureSay(cid, "Legendary Venusaur Apareceu.")

doSendMagicEffect(getThingPos(cid), math.random(28, 30))

return true

end