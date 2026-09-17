local config = {
MaxPlayer = 10,
fight_skills = {
['fist'] = 0,
['club'] = 1,
['sword'] = 2,
['axe'] = 3,
['distance'] = 4,
['shielding'] = 5,
['fishing'] = 6,
['dist'] = 4,
['shield'] = 5,
['fish'] = 6,
},
other_skills = {
[''] = "level",
['level'] = "level",
['magic'] = "maglevel",
['health'] = "healthmax",
['mana'] = "manamax"
},
vocations = {
['sorcerer'] = {1,5},
['druid'] = {2,6},
['paladin'] = {3,7},
['knight'] = {4,8}
},
storages = {
['frags'] = 824544
}
}
function onSay(cid, words, param)
local store,exausted = 156201,30
local param,str = string.lower(param),""
if not config.fight_skills[param] and not config.other_skills[param] and not config.vocations[param] and not config.storages[param] then
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "essa classificação não existe.") return true
elseif getPlayerStorageValue(cid, store) >= os.time() then
doPlayerSendCancel(cid, "Espere " .. getPlayerStorageValue(cid, store) - os.time() .. " segundos para usar este comando novamente.") return true
end
str = "Ranking Level "..(param == "" and "Poke Dragons" or string.upper(param)).."\n\n"
query = config.fight_skills[param] and db.getResult("SELECT `player_id`, `value` FROM `player_skills` WHERE `skillid` = "..config.fight_skills[param].." ORDER BY `value` DESC;") or config.other_skills[param] and db.getResult("SELECT `name`, `"..config.other_skills[param].."` FROM `players` WHERE `id` > 6 AND `group_id` < 2 ORDER BY `"..config.other_skills[param].."` DESC, `name` ASC;") or config.storages[param] and db.getResult("SELECT `player_id`, `value` FROM `player_storage` WHERE `key` = "..config.storages[param].." ORDER BY cast(value as INTEGER) DESC;") or db.getResult("SELECT `name`, `level` FROM `players` WHERE `group_id` <= 2 AND `vocation` = "..config.vocations[param][1].." or `vocation` = "..config.vocations[param][2].." ORDER BY `level` DESC;")
if (query:getID() ~= -1) then
k = 1
while true do
str = str .. "\n " .. k .. ". "..(config.fight_skills[param] and getPlayerNameByGUID(query:getDataString("player_id")) or config.storages[param] and getPlayerNameByGUID(query:getDataString("player_id")) or query:getDataString("name")).." - [" .. query:getDataInt((config.fight_skills[param] and "value" or config.storages[param] and "value" or config.vocations[param] and "level" or config.other_skills[param])) .. "]"
k = k + 1
if not(query:next()) or k > config.MaxPlayer then
break
end
end
query:free()
end
doShowTextDialog(cid,6500, str)
setPlayerStorageValue(cid, store, os.time()+exausted)
return true
end