function onSay(cid, words, param)
if #getCreatureSummons(cid) == 0 then
return doPlayerSendCancel(cid, "You don't have any pokemon.")
end


local summons = getCreatureSummons(cid)[1]
local mon = getCreatureName(summons)

if getCreatureSpeed(summons) >= 1 then
	doChangeSpeed(summons, -getCreatureSpeed(summons))
	doCreatureSay(cid, ""..mon..", hold position!", TALKTYPE_SAY)
else
	doRegainSpeed(summons)
	doCreatureSay(cid, ""..mon..", stop holding!", TALKTYPE_SAY)
end
return 0
end