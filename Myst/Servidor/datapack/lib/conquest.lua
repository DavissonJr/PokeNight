conqu = {
playerTempleiq = {x = 1208, y = 1573, z = 9},
tournamentFightiq = {x = 1199, y = 1573, z = 9},
areaiq = {fromx = 1194, fromy = 1569, fromz = 9, tox = 1206, toy = 1577, toz= 9},
waitPlaceiq = {x = 1200, y = 1572, z = 9},  
}


function getMonstersInAreai(areaiq)
local playersi = {}
for x = areaiq.fromx,areaiq.tox do
for y = areaiq.fromy,areaiq.toy do
for z = areaiq.fromz,areaiq.toz do
local m = getTopCreature({x=x, y=y, z=z}).uid
if m ~= 4 and isMonster(m) then
table.insert(playersi, m)
end
end
end
end
return playersi
end
