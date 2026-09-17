local pos_room = {x=1038,y=576,z=7} 
local radius = 16
local Premio = {x=1024, y=553, z=7}
 
local furious = {fromx = 1016, fromy = 566, fromz = 7, tox = 1081, toy = 597, toz = 7}
function getFuriousArea(area)
local players = {}
for x = area.fromx,area.tox do
for y = area.fromy,area.toy do
for z = area.fromz,area.toz do
local m = getTopCreature({x=x, y=y, z=z}).uid
if m ~= 1 and isMonster(m) and string.find(getCreatureName(m), "Furious") then
table.insert(players, m)
end
end
end
end
return players
end
 
function onUse(cid,item,pos) 
   if #getFuriousArea(furious) <= 0 then 
      doTeleportThing(cid, Premio, true)  
		doSendMagicEffect(getPlayerPosition(cid), 21)
   else
      doPlayerSendTextMessage(cid, 26, "Derrote todos os Furious Charizard para abrir a porta. Não esqueça de recolher todos os pokémon!")
   end
   return true 
end