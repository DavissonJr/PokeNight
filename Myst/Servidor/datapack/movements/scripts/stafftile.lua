function onStepIn(cid, item, position, fromPosition)
if isMonster(cid) then
doTeleportThing(cid, fromPosition, true)
doSendMagicEffect(getThingPos(cid), 2)
return true
end

if getPlayerGroupId(cid) == 1 then
doTeleportThing(cid, fromPosition, true)
doPlayerSendTextMessage(cid, 25, "Você Precisar ser Membro da STAFF Para Entrar Nessa área.")
doSendMagicEffect(getThingPos(cid), 2)
return false
end
doPlayerSendTextMessage(cid, 25, "Bem-Vindo a Area da staff do Poke News!")
doSendMagicEffect(getThingPos(cid), 12)
return true
end