function onSay(cid, words, param, channel)
if(param == '') then
doPlayerSendTextMessage(cid, 21, "Digite o comando correto.")
return true
end

local t = string.explode(param, ",")
player = getPlayerByName(t[1])
local condition = createConditionObject(CONDITION_MUTED)

if(not t[2] or t[2] == '') then
doPlayerSendTextMessage(cid, 21, "Digite o comando correto.")
end

if t[2] then
time = tonumber(t[2]*60000) -- 10*1000 is 10 seconds.
if(isPlayer(player) == TRUE and getPlayerGroupId(cid) > getPlayerGroupId(player) and getPlayerFlagValue(player, PLAYERFLAG_CANNOTBEMUTED) == false) then
setConditionParam(condition, CONDITION_PARAM_TICKS, time)
setConditionParam(condition, CONDITION_PARAM_SUBID, 4)
doAddCondition(player, condition)
doPlayerSendTextMessage(player, MESSAGE_STATUS_WARNING, "Voce foi calado pelo "Help", "Tutor", "GM", "ADM" " .. getPlayerName(cid) .. " por " .. t[2] .. " minuto(s).")
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, getCreatureName(player) .. " foi silenciado no Help-Channel por " .. t[2] .. " minuto(s).")
else
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Jogador " .. t[1] .. " não existe ou não está online.")
end
end

return true
end