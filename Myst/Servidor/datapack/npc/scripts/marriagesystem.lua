domodlib('marry_func')
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function creatureSayCallback(cid, type, msg)
if(not npcHandler:isFocused(cid)) then
return false
end
local talkUser = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid
msg,players = string.lower(msg), {getPlayerGUID(cid)}
if msgcontains(msg, 'marry') or msgcontains(msg, 'marriage') then
if isMarried(cid) then
npcHandler:say("Sorry, You already is wedded.", cid)
elseif getPlayerStorageValue(cid, marry_config.storage3) >= 1 then
npcHandler:say("you must sign the {divorce}.", cid)
elseif getPlayerStorageValue(cid, marry_config.storage1) >= os.time() then
local pid = getPlayerStorageValue(cid, marry_config.storage2)
npcHandler:say(getPlayerNameByGUID(pid).." has set a wedding date with you. Do you want to {proceed} or {cancel} the wedding?", cid)
talkState[talkUser] = 2
else
npcHandler:say("Would you like to get married?", cid)
talkState[talkUser] = 1
end
elseif msgcontains(msg, "yes") and talkState[talkUser] == 1 then
npcHandler:say("And what\'s the name of your future partner?", cid)
talkState[talkUser] = 3
elseif talkState[talkUser] == 3 then
local player = getPlayerByNameWildcard(msg)
if(not player)then
npcHandler:say(msg.." is offline or does not exist.", cid) return true
elseif isMarried(player) then
npcHandler:say("He already is wedded.", cid) return true
elseif getPlayerStorageValue(cid, marry_config.storage3) >= 1 or getPlayerStorageValue(player, marry_config.storage3) >= 1 then
npcHandler:say((getPlayerStorageValue(cid, marry_config.storage1) >= 1 and "You" or "He").." must sign the divorce.", cid) return true
elseif getPlayerLevel(cid) < marry_config.Level or getPlayerLevel(player) < marry_config.Level then
npcHandler:say("players must to be level "..marry_config.Level, cid) return true
elseif getPlayerStorageValue(player, marry_config.storage1) >= os.time() then
npcHandler:say(msg.." already have a wedding invitation, wait.", cid) return true
elseif getDistanceBetween(getCreaturePosition(cid), getCreaturePosition(player)) > marry_config.MaxSqm then
npcHandler:say("you are far away from each other to get married.", cid) return true
elseif marry_config.OnlyDifferentSex and getPlayerSex(cid) == getPlayerSex(player) then
npcHandler:say("you can only marry the opposite sex", cid) return true
elseif not doPlayerRemoveMoney(cid, marry_config.Marry_Price) then
npcHandler:say("Sorry, but you do not have "..marry_config.Marry_Price.." gp(s) to ask "..msg.." in marriage.", cid) return true
end
setPlayerStorageValue(player, marry_config.storage1,os.time()+marry_config.TimeAccept)
setPlayerStorageValue(player, marry_config.storage2, getPlayerGUID(cid))
npcHandler:say("you asked "..msg.." in marriage, wait a answer!", cid)
doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_ORANGE,getCreatureName(cid).." asked you in marriage.")
talkState[talkUser] = 0
elseif msgcontains(msg, "proceed") and talkState[talkUser] == 2 then
player = getPlayerStorageValue(cid, marry_config.storage2)
if getPlayerStorageValue(cid, marry_config.storage1) >= os.time() then
if not isMarried(cid) then
if Ponline(player) then
x = getPlayerByNameWildcard(getPlayerNameByGUID(player))
if getDistanceBetween(getCreaturePosition(cid), getCreaturePosition(x)) <= marry_config.MaxSqm then
table.insert(players, player)
doMarry(cid, player)
for i = 1, #players do
local ring = doPlayerAddItem(getPlayerByNameWildcard(getPlayerNameByGUID(players)), marry_config.RingID, 1)
doItemSetAttribute(ring, "description", getCreatureName(cid) .. " & " .. getPartner(cid) .. " forever - married on " ..getMarryDate(cid).. ".")
doCreatureSay(getPlayerByNameWildcard(getPlayerNameByGUID(players)), marry_config.Text[math.random(1,#marry_config.Text)], TALKTYPE_ORANGE_1)
doSendMagicEffect(getCreaturePosition(getPlayerByNameWildcard(getPlayerNameByGUID(players))), 35)
setPlayerStorageValue(getPlayerByNameWildcard(getPlayerNameByGUID(players)), marry_config.storage3, 1)
setPlayerStorageValue(getPlayerByNameWildcard(getPlayerNameByGUID(players)), 150420, 1)
end
npcHandler:say("Congratulations! Now you may kiss your partner! to see the status of marriage enter !marriage status", cid)
talkState[talkUser] = 0
else
npcHandler:say("you're far away from her suitor.", cid)
end
else
npcHandler:say("suitor offline.", cid)
end
else
npcHandler:say("you are not married.", cid)
talkState[talkUser] = 0
end
else
npcHandler:say("you do not received none wedding invitation.", cid)
talkState[talkUser] = 0
end
elseif msgcontains(msg, "cancel") and talkState[talkUser] == 2 then
player = getPlayerStorageValue(cid, marry_config.storage2)
if getPlayerStorageValue(cid, marry_config.storage1) >= os.time() then
if not isMarried(cid) then
setPlayerStorageValue(cid, marry_config.storage1, -1)
npcHandler:say("You just refuse the wedding invitation from player "..getPlayerNameByGUID(player), cid)
if Ponline(player) then
doPlayerSendTextMessage(getPlayerByNameWildcard(getPlayerNameByGUID(player)), MESSAGE_STATUS_CONSOLE_ORANGE,getCreatureName(cid).." rejected his marriage proposal.")
end
else
npcHandler:say("you are already married.", cid)
talkState[talkUser] = 0
end
else
npcHandler:say("you do not received none wedding invitation.", cid)
talkState[talkUser] = 0
end
elseif msgcontains(msg, "divorce") then
if isMarried(cid) then
npcHandler:say("Would you like to divorce of your partner for "..marry_config.Divorce_Price.." gp(s) ? {yes}", cid)
talkState[talkUser] = 6
elseif getPlayerStorageValue(cid, marry_config.storage3) >= 1 then
npcHandler:say("you must sign here to end your marriage, ok? {yes}", cid)
talkState[talkUser] = 7
else
npcHandler:say("you are not married", cid)
talkState[talkUser] = 0
end
elseif msgcontains(msg, "yes") and talkState[talkUser] == 6 then
if isMarried(cid) then
if doPlayerRemoveMoney(cid, marry_config.Divorce_Price) then
npcHandler:say("Congratulations, you end up divorcing from player: "..getPartner(cid), cid)
setPlayerStorageValue(cid, 150420, -1)
setPlayerStorageValue(cid, marry_config.storage3, -1)
pguid = getPlayerGUIDByName(getPartner(cid))
if Ponline(pguid) then
setPlayerStorageValue(getPlayerByNameWildcard(getPlayerNameByGUID(pguid)), 150420, -1)
else
db.executeQuery("DELETE FROM `player_storage` WHERE `player_id` = " .. pguid .. " AND `key` = 150420;")
end
doDivorcePlayer(cid)
else
npcHandler:say("Sorry, you do not have "..marry_config.Divorce_Price.." gp(s).", cid)
end
else
npcHandler:say("you are not married.", cid)
end
elseif msgcontains(msg, "yes") and talkState[talkUser] == 7 then
npcHandler:say("Congratulations, you end up divorcing.", cid)
setPlayerStorageValue(cid, marry_config.storage3, -1)
elseif msg == "no" and talkState[talkUser] >= 1 then
selfSay("tudo bem então.", cid)
talkState[talkUser] = 0
npcHandler:releaseFocus(cid)
end
return TRUE
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())