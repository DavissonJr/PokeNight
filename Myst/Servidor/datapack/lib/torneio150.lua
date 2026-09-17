torneiomary = {
awardTournamentmary = 2152,
awardAmountmary = 150,
playerTemplemary = {x = 1227, y = 1755, z = 7},
tournamentFightmary = {x = 931, y = 1723, z = 7},
areamary = {fromx = 1206, tox = 1249, fromy = 1743, toy = 1783, fromz = 7, toz = 7},
waitPlacemary = {x = 925, y = 1760, z = 7},  
waitAreamary = {fromx = 1206, tox = 1249, fromy = 1743, toy = 1783, fromz = 7, toz = 7},
startHour1mary = "08:45:00",
endHour1mary = "09:01:00",
startHour2mary = "12:15:00",
endHour2mary = "12:31:00",
startHour3mary = "18:45:00",
endHour3mary = "19:01:00",
startHour4mary = "22:45:00",
endHour4mary = "23:01:00",
pricemary = 200000,
revivePokemary = 12344,
}
function getPlayersInArea(areamary)
local players = {}
for x = areamary.fromx,areamary.tox do
for y = areamary.fromy,areamary.toy do
for z = areamary.fromz,areamary.toz do
local m = getTopCreature({x=x, y=y, z=z}).uid
if m ~= 1 and isPlayer(m) then
table.insert(players, m)
end
end
end
end
return players
end