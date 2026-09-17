function onUse(cid, item, fromPosition, itemEx, toPosition)

local cfg = {
	pos = {x = 1762 , y = 840 , z = 9},
	

}

if getPlayerStorageValue(cid, 9876545) >= 1 then
doTeleportThing(cid, cfg.pos)
doSendMagicEffect(getPlayerPosition(cid), 21)
doPlayerSendTextMessage(cid, 25, "Boa Sorte")
return true
else
doPlayerSendCancel(cid, "Ainda não e possivel abrir o portal para outra dimenção.")
return true
end
end