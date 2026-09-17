anel = {
playerTemplei = {x = 1144, y = 2638, z = 8},
tournamentFighti = {x = 1145, y = 2676, z = 8},
areai = {fromx = 1111, fromy = 2643, fromz = 8, tox = 1182, toy = 2709, toz= 8},
waitPlacei = {x = 1116, y = 2646, z = 8},  
}


function getMonstersInAreai(areai)
local playersi = {}
for x = areai.fromx,areai.tox do
for y = areai.fromy,areai.toy do
for z = areai.fromz,areai.toz do
local m = getTopCreature({x=x, y=y, z=z}).uid
if m ~= 4 and isMonster(m) then
table.insert(playersi, m)
end
end
end
end
return playersi
end
