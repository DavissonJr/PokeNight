function onStepIn(cid, item, position, fromPosition)
if not isPlayer(cid) then return true end
if not isPremium(cid) then
doTeleportThing(cid, fromPosition, true)
doPlayerSendTextMessage(cid, 26, "Você precisa de premium para entrar na area vip.")
doSendMagicEffect(getThingPos(cid), CONST_ME_MAGIC_BLUE)
return true
end
doPlayerSendTextMessage(cid, 25, "Bem-vindo a area vip")
doSendMagicEffect(fromPosition, 12)
return true
end