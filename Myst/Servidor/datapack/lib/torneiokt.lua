torneiokanto = {
awardTournamentkanto = 2152,
awardAmountkanto = 150,
playerTemplekanto = {x = 1227, y = 1755, z = 7},
tournamentFightkanto = {x = 932, y = 1726, z = 5},
areakanto = {fromx = 897, fromy = 1705, fromz = 5, tox = 962, toy = 1752, toz= 5},
waitPlackanto = {x = 1228, y = 1797, z = 7},  
waitAreakanto = {fromx = 1206, tox = 1249, fromy = 1743, toy = 1783, fromz = 7, toz = 7},
startHour1kanto = "08:45:00",
endHour1kanto = "08:59:00",
startHour2kanto = "12:15:00",
endHour2kanto = "12:29:00",
startHour3kanto = "18:45:00",
endHour3kanto = "18:59:00",
startHour4kanto = "22:45:00",
endHour4kanto = "22:59:00",
pricekanto = 200000,
revivePokekanto = 12344,
}
function getPlayersInArea(areakanto)
local players = {}
for x = areakanto.fromx,areakanto.tox do
for y = areakanto.fromy,areakanto.toy do
for z = areakanto.fromz,areakanto.toz do
local m = getTopCreature({x=x, y=y, z=z}).uid
if m ~= 1 and isPlayer(m) then
table.insert(players, m)
end
end
end
end
return players
end