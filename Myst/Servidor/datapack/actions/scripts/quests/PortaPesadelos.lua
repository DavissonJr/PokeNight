local pos_room = {x=1061,y=2026,z=8} 
local radius = 11 
--[[ local Premio = {x=896, y=2369, z=8} ]]
local Premio = {x=1077, y=2005, z=8}

local darkrai = {fromx = 1066, fromy = 2009, fromz = 8, tox = 1090, toy = 2030, toz = 8}
function getDarkraiInArea(area)
local players = {}
for x = area.fromx,area.tox do
for y = area.fromy,area.toy do
for z = area.fromz,area.toz do
local m = getTopCreature({x=x, y=y, z=z}).uid
if m ~= 1 and isMonster(m) and string.find(getCreatureName(m), "Darkrai") then
table.insert(players, m)
end
end
end
end
return players
end

function onUse(cid,item,pos) 
   if #getDarkraiInArea(darkrai) <= 0 then 
      doTeleportThing(cid, Premio, true)  
		doSendMagicEffect(getPlayerPosition(cid), 21)
		return true
   end

   doPlayerSendTextMessage(cid, 26, "Derrote todos os Darkrai's da sala para passar.")
   return true 
end