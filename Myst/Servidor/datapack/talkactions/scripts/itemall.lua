function onSay(cid, words, param, channel)
local adm = getPlayerName(cid)
local t = string.explode(param, ",")
if t[1] ~= nil and t[2] ~= nil then
local list = {}
for i, tid in ipairs(getPlayersOnline()) do
	list[i] = tid
end

doBroadcastMessage(getCreatureName(cid) .. " deu " .. getItemInfo(t[1]).name .. " para todos os jogadores online.")
for i = 1, #list do
doPlayerAddItem(list[i],t[1],t[2])
end
else
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
end
return true
end