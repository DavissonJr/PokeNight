function onSay(cid, words, param)
local mana = getCreatureMana(cid)
doPlayerSendTextMessage(cid, 25, "vc tem ".. mana .." de mana")
return true
end