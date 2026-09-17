function onUse(cid, item, fromPosition, itemEx, toPosition)

if #getMonstersInAreai(anel.areai) > 30 then
doPlayerSendTextMessage(cid, 20 ,"Prcisa derrotar todas as Maquinas de Magmar.") 

return true 
end
doTeleportThing(cid, anel.playerTemplei)
doSendMagicEffect(getPlayerPosition(cid), 21)
return true
end

