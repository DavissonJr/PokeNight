torneio = {
awardTournament = 2152,
awardAmount = 150,
playerTemple = {x = 1227, y = 1755, z = 7},
tournamentFight = {x = 931, y = 1724, z = 6},
area = {fromx = 896, fromy = 1704, fromz = 6, tox = 961, toy = 1751, toz= 6},
waitPlace = {x = 1228, y = 1797, z = 7},  
waitArea = {fromx = 1206, tox = 1249, fromy = 1743, toy = 1783, fromz = 7, toz = 7},
startHour1 = "08:45:00",
endHour1 = "09:00:00",
startHour2 = "12:15:00",
endHour2 = "12:30:00",
startHour3 = "18:45:00",
endHour3 = "19:00:00",
startHour4 = "22:45:00",
endHour4 = "23:00:00",

price = 200000,
revivePoke = 12344,
}
function getPlayersInArea(area)
local players = {}
for x = area.fromx,area.tox do
for y = area.fromy,area.toy do
for z = area.fromz,area.toz do
local m = getTopCreature({x=x, y=y, z=z}).uid
if m ~= 1 and isPlayer(m) then
table.insert(players, m)
end
end
end
end
return players
end