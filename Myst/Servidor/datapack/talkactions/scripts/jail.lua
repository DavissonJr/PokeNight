-- Tempo em segundos que alguém ficará na prisão --
default_jail = 50
-- O group ID da permissão para alguém manda o outro para a cadeia. --
grouprequired = 2
-- StorageValue that the player gets --
jailedstoragevalue_time = 1338
jailedstoragevalue_bool = 1339
-- POSICAO DA CADEIA: --
jailpos = {x = 1867, y = 1387, z = 4}
-- POSICAO DO LUGAR QUE ELE VOLTARÁ (RECOMENDADO TEMPO): --
unjailpos = {x = 1036, y = 1036, z = 7}
-- auto kicker, dont edit
jail_list = {}
jail_list_work = 0

function checkJailList(param)
addEvent(checkJailList, 1000, {})
for targetID,player in ipairs(jail_list) do
if isPlayer(player) == TRUE then
if getPlayerStorageValue(player, jailedstoragevalue_time) < os.time() then
doTeleportThing(player, unjailpos, TRUE)
setPlayerStorageValue(player, jailedstoragevalue_time, 0)
setPlayerStorageValue(player, jailedstoragevalue_bool, 0)
table.remove(jail_list,targetID)
doPlayerSendTextMessage(player,25,'Você está na prisão, aguarde o tempo para você sair')
end
else
table.remove(jail_list,targetID)
end
end
end

function onSay(cid, words, param)
if jail_list_work == 0 then
jail_list_work = addEvent(checkJailList, 1000, {})
end
if param == '' and (words == '!unjail' or words == '/unjail') then
if getPlayerStorageValue(cid, jailedstoragevalue_time) > os.time() then
doPlayerSendTextMessage ( cid, MESSAGE_INFO_DESCR, 'Você está preso até ' .. os.date("%H:%M:%S", getPlayerStorageValue(cid, jailedstoragevalue_time)) .. '')
else
if getPlayerStorageValue(cid, jailedstoragevalue_bool) == 1 then
table.insert(jail_list,cid)
doPlayerSendTextMessage ( cid, MESSAGE_INFO_DESCR, 'Você vai ser expulso da prisão em um segundo.')
else
doPlayerSendTextMessage ( cid, MESSAGE_INFO_DESCR, 'Você não está preso.')
end
end
return true
end
local jail_time = -1
for word in string.gmatch(tostring(param), "(%w+)") do
if tostring(tonumber(word)) == word then
jail_time = tonumber(word)
end
end
local isplayer = getPlayerByName(param)
if isPlayer(isplayer) ~= TRUE then
isplayer = getPlayerByName(string.sub(param, string.len(jail_time)+1))
if isPlayer(isplayer) ~= TRUE then
isplayer = getPlayerByName(string.sub(param, string.len(jail_time)+2))
if isPlayer(isplayer) ~= TRUE then
isplayer = getPlayerByName(string.sub(param, string.len(jail_time)+3))
end
end
end
if jail_time ~= -1 then
jail_time = jail_time * 60
else
jail_time = default_jail
end
if words == '!jail' or words == '/jail' then
if getPlayerGroupId ( cid ) >= grouprequired then
if isPlayer(isplayer) == TRUE then
if getCreatureName(isplayer) == getCreatureName(cid) then
    doPlayerSendTextMessage(cid, 25, "Não pode prender a si mesmo.")
    return true
end

if getPlayerGroupId(cid) < 5 then
    if getPlayerGroupId(isplayer) == 2 or getPlayerGroupId(isplayer) == 3 then
        doBroadcastMessage(getCreatureName(cid) .. " está tentando prender um HELP/TUTOR.")
        return true
    end

    if getPlayerGroupId(isplayer) >= 5 then
        doBroadcastMessage(getCreatureName(cid) .. " está tentando prender um ADM/GM.")
        return true
    end
end

doTeleportThing(isplayer, jailpos, TRUE)
setPlayerStorageValue(isplayer, jailedstoragevalue_time, os.time()+jail_time)
setPlayerStorageValue(isplayer, jailedstoragevalue_bool, 1)
table.insert(jail_list,isplayer)
doPlayerSendTextMessage ( cid, MESSAGE_INFO_DESCR, 'Você prendeu '.. getCreatureName(isplayer) ..' até ' .. os.date("%H:%M:%S", getPlayerStorageValue(isplayer, jailedstoragevalue_time)) .. '')
doPlayerSendTextMessage ( isplayer, MESSAGE_INFO_DESCR, 'Você foi preso por '.. getCreatureName(cid) ..' até ' .. os.date("%H:%M:%S", getPlayerStorageValue(isplayer, jailedstoragevalue_time)) .. '')
return true
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "O player com este nome não existe ou está offline.")
return true
end
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você não pode libertar outros jogadores.")
return true
end
elseif words == '!unjail' or words == '/unjail' then
if getPlayerGroupId ( cid ) >= grouprequired then
if isPlayer(isplayer) == TRUE then
doTeleportThing(isplayer, unjailpos, TRUE)
setPlayerStorageValue(isplayer, jailedstoragevalue_time, 0)
setPlayerStorageValue(isplayer, jailedstoragevalue_bool, 0)
table.remove(jail_list,targetID)
doPlayerSendTextMessage(isplayer,25,getCreatureName(cid) .. 'vou deixar você sair da prisão!')
doPlayerSendTextMessage ( cid, MESSAGE_INFO_DESCR, 'Voce está solto '.. getCreatureName(isplayer) ..'.')
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "O player com este nome não existe ou está offline.")
return true
end
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você não pode libertar outros jogadores.")
return true
end
end
return true
end