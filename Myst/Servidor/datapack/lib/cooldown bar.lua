function getPlayerPokeballs(cid)                                   --alterado v1.9 \/
local ret = {}
local container = 0

if isCreature(cid) then
   container = getPlayerSlotItem(cid, 3).uid
   local myball = getPlayerSlotItem(cid, 8)
   if myball.uid > 0 then
      table.insert(ret, myball)
   end
else
   container = cid
end

if isContainer(container) and getContainerSize(container) > 0 then
   for slot = 0, (getContainerSize(container) - 1) do
       local item = getContainerItem(container, slot)
       if isContainer(item.uid) then
          local itemsbag = getPlayerPokeballs(item.uid)
          if itemsbag and #itemsbag > 0 then
             for i = 0, #itemsbag do
                 table.insert(ret, itemsbag[i])
             end
          end
       elseif isPokeball(item.itemid) then
          table.insert(ret, item)
       end
   end
end
return ret
end

function doUpdatePokemonsBar(cid)
if not isCreature(cid) then return true end
if getPlayerStorageValue(cid, 656494) > 0 then
return true
end
setPlayerStorageValue(cid, 656494, 1000)
addEvent(setPlayerStorageValue, 100, cid, 656494, -1)

local ret = {}
table.insert(ret, "p#,")
local balls = getPlayerPokeballs(cid)
local times = 0
for a = 1, #balls do
    local item = balls[a]
    local hp = math.ceil(getItemAttribute(item.uid, "hp") * 100)
    local name = getItemAttribute(item.uid, "poke")
    local port = getPlayerSlotItem(cid, CONST_SLOT_LEGS) 
    if fotos[name] >= 11137 and fotos[name] <= 11387 then
       times = times + 1
       local foto = fotos[name] - 911
       doItemSetAttribute(item.uid, "ballorder", times)
       table.insert(ret, foto..","..name..""..times..","..hp..",")                
    elseif fotos[name] >= 12605 then                                           
       times = times + 1                                                      
       local foto = fotos[name] - 1178  --alterado v1.9 
       doItemSetAttribute(item.uid, "ballorder", times)
       table.insert(ret, foto..","..name..""..times..","..hp..",")
    else
       times = times + 1
       local foto = fotos[name] - 928
       doItemSetAttribute(item.uid, "ballorder", times)
       table.insert(ret, foto..","..name..""..times..","..hp..",")
	   doUpdatePokemonsLifeBar(cid)
    end
end
doPlayerSendCancel(cid, table.concat(ret))
end

function getNewMoveTable(table, n)
if table == nil or not n then return false end

local moves = {table.move1, table.move2, table.move3, table.move4, table.move5, table.move6, table.move7, table.move8, table.move9,
table.move10, table.move11, table.move12}

return moves[n] or false
end


function doUpdateMoves(cid)
if not isCreature(cid) then return true end
local summon = getCreatureSummons(cid)[1]
local ret = {}
table.insert(ret, "12&,")
if not summon then
   for a = 1, 12 do
       table.insert(ret, "n/n,")
   end
   doPlayerSendCancel(cid, table.concat(ret))
   addEvent(doUpdateCooldowns, 100, cid)
return true
end
if isTransformed(summon) then  --alterado v1.9
   moves = movestable[getPlayerStorageValue(summon, 1010)]
else                                                       
   moves = movestable[getCreatureName(summon)]
end

for a = 1, 12 do
   local b = getNewMoveTable(moves, a)
   local slot = getPlayerSlotItem(cid, 8)
   local atributo = getItemAttribute(slot.uid, "movename"..a) or "none"

   if atributo ~= "none" then
      table.insert(ret, atributo..",")
   end

   if atributo == "none" then
      if b then
         table.insert(ret, b.name..",")
      else
         table.insert(ret, "n/n,")
      end
   end
end

doPlayerSendCancel(cid, table.concat(ret))
addEvent(doUpdateCooldowns, 100, cid)
end

function doUpdateCooldowns(cid)
if not isCreature(cid) then return true end
local a = getPlayerSlotItem(cid, 8)
local ret = {}
table.insert(ret, "12|,")
if a.uid <= 0 or #getCreatureSummons(cid) <= 0 then
   for cds = 1, 12 do
       if useOTClient then table.insert(ret, "-1|0,") else table.insert(ret, "-1,") end  
   end
   doPlayerSendCancel(cid, table.concat(ret))
return true
end
for cds = 1, 12 do                                                         
    ----
    local summon = getCreatureSummons(cid)[1]
    if summon and getPlayerStorageValue(summon, 212123) >= 1 then
       cdzin = "cm_move"..cds
    else                       
       cdzin = "move"..cds
    end
    ----
    if isTransformed(summon) then  --alterado v1.9
       moves = movestable[getPlayerStorageValue(summon, 1010)]
    else                                                       
       moves = movestable[getCreatureName(summon)]
    end
    local b = getNewMoveTable(moves, cds)
    if not b then
       for cds = 1, 12 do
           if useOTClient then table.insert(ret, "-1|0,") else table.insert(ret, "-1,") end   --alterado v1.9
       end
       doPlayerSendCancel(cid, table.concat(ret))
    return true
    end
    ----
    if getCD(a.uid, cdzin) > 0 then
       if (useOTClient and b) then table.insert(ret, (getCD(a.uid, cdzin)).."|"..b.level..",") else table.insert(ret, (getCD(a.uid, cdzin))..",") end
    else
       if (useOTClient and b) then table.insert(ret, "0|"..b.level..",") else table.insert(ret, "0,") end  
    end
end
doPlayerSendCancel(cid, table.concat(ret))                                             
end

function getBallsAttributes(item)
local t = {"poke", "gender", "nick", "boost", "happy", "hp", "description", "transBegin", "hunger", "transLeft", "transTurn", "transOutfit", "transName", 
"trans", "light", "blink", "move1", "move2", "move3", "move4", "move5", "move6", "move7", "move8", "move9", "move10", "move11", "move12", "ballorder", 
"hands", "aura", "burn", "burndmg", "poison", "poisondmg", "confuse", "sleep", "miss", "missSpell", "missEff", "fear", "fearSkill", "silence", 
"silenceEff", "stun", "stunEff", "stunSpell", "paralyze", "paralyzeEff", "slow", "slowEff", "leech", "leechdmg", "Buff1", "Buff2", "Buff3", "Buff1skill",
"Buff2skill", "Buff3skill", "control", "unique", "task", "lock"} 
local ret = {}
for a = 1, #t do
if getItemAttribute(item, t[a]) == "hands" then
return
end
ret[t[a]] = getItemAttribute(item, t[a]) or false
end
return ret
end

function doChangeBalls(cid, item1, item2)
if not isCreature(cid) then return true end
if item1.uid == item2.uid then
   if #getCreatureSummons(cid) <= 0 then
      doGoPokemon(cid, getPlayerSlotItem(cid, 8))
   else
      doReturnPokemon(cid, getCreatureSummons(cid)[1], getPlayerSlotItem(cid, 8), pokeballs[getPokeballType(getPlayerSlotItem(cid, 8).itemid)].effect)
   end
return true
end

if item1.uid > 0 and item2.uid > 0 then
   local io = getBallsAttributes(item1.uid)
   local it = getBallsAttributes(item2.uid)
   for a, b in pairs (io) do
       if b then
          doItemSetAttribute(item2.uid, a, b)
       else
          doItemEraseAttribute(item2.uid, a)
       end
   end
   for a, b in pairs (it) do
       if b then
          doItemSetAttribute(item1.uid, a, b)
       else
          doItemEraseAttribute(item1.uid, a)
       end
   end
   local id = item2.itemid
   doTransformItem(item2.uid, item1.itemid)
   doTransformItem(item1.uid, id)
   doGoPokemon(cid, getPlayerSlotItem(cid, 8))
else
   local id = item2.itemid
   local b = getBallsAttributes(item2.uid)
   local a = doPlayerAddItem(cid, 2643, false)
   for c, d in pairs (b) do
       if d then
          doItemSetAttribute(a, c, d)
       else
          doItemEraseAttribute(a, c)
       end
   end
   doRemoveItem(item2.uid, 1)
   doTransformItem(a, id)
   doGoPokemon(cid, getPlayerSlotItem(cid, 8))
end
end