function onSay(cid, words, param)
local msg = ("Strong Haste:" .. param .. "") or "Strong Haste"
if(not exhaustion.get(cid, 501)) then
doCreatureSay(cid, msg, TALKTYPE_ORANGE_1)
end
doSetPlayerSpeedLevel(cid)
doSendMagicEffect(getPlayerPosition(cid), 12)
exhaustion.set(cid, 501, 0.1)
return true
end 