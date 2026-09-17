local pokes = {

["Poliwag"] = {lookType=629, speed = 320},
["Poliwhirl"] = {lookType=488, speed = 480},
["Seaking"] = {lookType=620, speed = 520},
["Dewgong"] = {lookType=534, speed = 700},
["Blastoise"] = {lookType=535, speed = 850},
["Tentacruel"] = {lookType=536, speed = 750},
["Lapras"] = {lookType=537, speed = 960},
["Gyarados"] = {lookType=538, speed = 1050},
["Omastar"] = {lookType=539, speed = 680},
["Kabutops"] = {lookType=540, speed = 840},
["Poliwrath"] = {lookType=541, speed = 680},
["Vaporeon"] = {lookType=542, speed = 800},
["Staryu"] = {lookType=617, speed = 385},
["Starmie"] = {lookType=618, speed = 685},
["Goldeen"] = {lookType=619, speed = 355},
["Seadra"] = {lookType=621, speed = 655},
["Golduck"] = {lookType=622, speed = 760},
["Squirtle"] = {lookType=624, speed = 365},
["Wartortle"] = {lookType=626, speed = 605},
["Tentacool"] = {lookType=628, speed = 340},
["Snorlax"] = {lookType=651, speed = 500},
["Piplup"] = {lookType=1562, speed = 350},
["Prinplup"] = {lookType=1561, speed = 400},
["Empoleon"] = {lookType=1564, speed = 550},
["Shiny Blastoise"] = {lookType=1009, speed = 935},
["Shiny Tentacruel"] = {lookType=1365, speed = 825},
["Shiny Gyarados"] = {lookType=1381, speed = 1155},
["Shiny Vaporeon"] = {lookType=1032, speed = 880},      
["Shiny Seadra"] = {lookType=1383, speed = 720.5},
["Shiny Tentacool"] = {lookType=1364, speed = 374},
["Shiny Snorlax"] = {lookType=1386, speed = 550},
["Milotic"] = {lookType=1843, speed = 1200},
["Shiny Milotic"] = {lookType=2050, speed = 1200},
["Mantine"] = {lookType=987, speed = 820},
["Totodile"] = {lookType=988, speed = 360},
["Croconow"] = {lookType=989, speed = 590},
["Feraligatr"] = {lookType=996, speed = 900},
["Marill"] = {lookType=990, speed = 340},
["Azumarill"] = {lookType=993, speed = 680},
["Quagsire"] = {lookType=994, speed = 740},
["Kingdra"] = {lookType=995, speed = 1020},
["Octillery"] = {lookType=992, speed = 600},
["Wooper"] = {lookType=991, speed = 315},
["Buizel"] = {lookType=1511, speed = 315},
["Floatzel"] = {lookType=1509, speed = 350},
["Gastrodon east"] = {lookType=1573, speed = 200},
["Gastrodon"] = {lookType=1572, speed = 200},
["Finneon"] = {lookType=1544, speed = 120},
["Lumineon"] = {lookType=1543, speed = 120},
["Walrein"] = {lookType=1757, speed = 120},
["Wingull"] = {lookType=1751, speed = 120},
["Wailmer"] = {lookType=1750, speed = 120},
["Swampert"] = {lookType=1746, speed = 120},
["Ludicolo"] = {lookType=1743, speed = 120},
["Sharpedo"] = {lookType=1739, speed = 120},
["Gorebys"] = {lookType=1734, speed = 120},
["Huntail"] = {lookType=1733, speed = 120},
["Relicanth"] = {lookType=1753, speed = 120},
["Linoone"] = {lookType=1730, speed = 120},
["Spheal"] = {lookType=1729, speed = 120},
["Mudkip"] = {lookType=1728, speed = 120},
["Whiscash"] = {lookType=1727, speed = 120},
["Marshtomp"] = {lookType=1726, speed = 120},
["Luvdisc"] = {lookType=1725, speed = 120},
["Lombre"] = {lookType=1724, speed = 120},
["Barboach"] = {lookType=1723, speed = 120},
["Finneon"] = {lookType=1544, speed = 120},
["Shiny Lapras"] = {lookType=2060, speed = 1200},
}
local configs = {
[4647] = {x = -2, y = 0},
[4645] = {x = 2, y = 0},
[4646] = {x = 0, y = 2},
[4644] = {x = 0, y = -2},
}
function onUse(cid, item, fromPosition, itemEx, toPosition)
local playerpos = getCreaturePosition(cid)
if #getCreatureSummons(cid) <= 0 and getPlayerStorageValue(cid, 63215) <= 0 then
return doPlayerSendCancel(cid, "Desculpe, esse pokémon não possue abilidade de surf.")
end
local l = false
for i,x in pairs(pokes) do
if getPlayerStorageValue(cid, 63215) <= 0 and i:lower() == getCreatureName(getCreatureSummons(cid)[1]):lower() then
l = true
end
end
if not l and getPlayerStorageValue(cid, 63215) <= 0 then
return doPlayerSendCancel(cid, "This pokemon can't surf.")
end
if getPlayerStorageValue(cid, 63215) <= 0 then
local item = getPlayerSlotItem(cid, 8)
local poke = getItemAttribute(item.uid, "poke")

doTeleportThing(cid, {x=playerpos.x+configs[itemEx.itemid].x, y=playerpos.y+configs[itemEx.itemid].y, z=playerpos.z})
setPlayerStorageValue(cid, 63215, 1)
doSetCreatureOutfit(cid, {lookType = pokes[poke].lookType}, -1)
doCreatureSay(cid, "Let's surf, "..poke, 1)
doChangeSpeed(cid, pokes[poke].speed)

if #getCreatureSummons(cid) > 0 then
    doRemoveCreature(getCreatureSummons(cid)[1])
end
else
doTeleportThing(cid, {x=playerpos.x-configs[itemEx.itemid].x, y=playerpos.y-configs[itemEx.itemid].y, z=playerpos.z})
setPlayerStorageValue(cid, 63215, 0)
doRemoveCondition(cid, CONDITION_OUTFIT)
local item = getPlayerSlotItem(cid, 8)
doSummonMonster(cid, getItemAttribute(item.uid, "poke"))
doCreatureSay(cid, "" .. getItemAttribute(item.uid, "poke")..", Im tired of surfing!", 1)
registerCreatureEvent(getCreatureSummons(cid)[1], "DiePoke")
registerCreatureEvent(getCreatureSummons(cid)[1], "Exp")
doChangeSpeed(cid, getCreatureBaseSpeed(cid)-getCreatureSpeed(cid))
adjustStatus(getCreatureSummons(cid)[1], item.uid, true, true)
end
return true
end