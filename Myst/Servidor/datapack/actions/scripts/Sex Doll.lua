function onUse(cid, item, itemex, toposition)

local pos = getCreaturePosition(cid)

if(getPlayerSex(cid) == 1) then
doRemoveItem(item.uid,1)
doPlayerSendTextMessage(cid, 19, "Voce agora e do sexo feminino")
doSendMagicEffect(pos, 18)
doPlayerSetSex(cid, 0)

else

doRemoveItem(item.uid, 1)
doPlayerSendTextMessage(cid, 19, "Voce agora e do sexo masculino")
doSendMagicEffect(pos, 18)
doPlayerSetSex(cid, 1)
end 
return true
end