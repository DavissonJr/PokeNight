local minutes = 15 -- Minutes
 
function onSay(cid, words, param)
if isPlayer(cid) then
doSetCreatureLight(cid, 8, 215, minutes*60*1000)
doSendAnimatedText(getCreaturePosition(cid), "Lanterna!", math.random(1, 255))
end
return true
end