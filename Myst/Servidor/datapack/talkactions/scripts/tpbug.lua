local tempo = 3600
local storage, exhaust = 94360, 900
function onSay(cid, words, param, condition, channel)
if not getCreatureCondition(cid, CONDITION_INFIGHT) then
if (getPlayerStorageValue(cid, storage) <= os.time()) then
doPlayerSendTextMessage(cid,25,"Personagem Desbugado(a)!")
doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
doSendMagicEffect(getCreaturePosition(cid),21)
   setPlayerStorageValue(cid, storage, os.time()+exhaust)
else
   doPlayerSendCancel(cid, "Você só pode utilizar esse comando a cada uma hora.")
end
else
   doPlayerSendCancel(cid, "Você está em batalha.")
end
   return true
end