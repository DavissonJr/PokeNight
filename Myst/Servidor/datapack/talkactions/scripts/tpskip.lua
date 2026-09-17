local tempo = 99900000000000000000000000
local storage, exhaust = 94360, 900
function onSay(cid, words, param, condition, channel)
if not getCreatureCondition(cid, CONDITION_INFIGHT) then
if (getPlayerStorageValue(cid, storage) <= os.time()) then
pos = {x=1038, y=1027, z=8}
doPlayerSendTextMessage(cid,25,"Você pulou o tutorial.")
doTeleportThing(cid,pos)
doSendMagicEffect(getCreaturePosition(cid),21)
   setPlayerStorageValue(cid, storage, os.time()+exhaust)
else
   doPlayerSendCancel(cid, "Você já pulou o tutorial.")
end
else
   doPlayerSendCancel(cid, "Você precisa sair do modo batalha para pular o tutorial.")
end
   return true
end