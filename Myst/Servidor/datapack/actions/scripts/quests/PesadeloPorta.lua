function onUse(cid)
local pssxxx = {x = 1088, y = 2420, z = 8} --pra onde o player vai ao clicar na porta ?---

if getPlayerLevel(cid) > 200 then
doTeleportThing(cid, pssxxx)
doSendMagicEffect(getPlayerPosition(cid), 21)
doPlayerSendTextMessage(cid, 25, "Foi avisado para não passar agora ter que passar pelo seu maior presadelo.")
return true
else
doPlayerSendTextMessage(cid, 26, "Somente merecedores do level 200+ podem passar por aqui.")
return true
end 
end