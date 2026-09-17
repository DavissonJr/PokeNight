local fishing = {
["Magikarp"] = {skill = 1, level = -2},
["Poliwag"] = {skill = 10, level = 6},
["Goldeen"] = {skill = 10, level = 5},
["Krabby"] = {skill = 10, level = 2},
["Horsea"] = {skill = 10, level = 3},
["Corphish"] = {skill = 20, level = 11},
["Wooper"] = {skill = 20, level = 20},
["Mantyke"] = {skill = 20, level = 20},
["Chinchou"] = {skill = 20, level = 6},
["Tentacool"] = {skill = 20, level = 14},
["Seaking"] = {skill = 40, level = 9},
["Clamperl"] = {skill = 40, level = 15},
["Barboach"] = {skill = 40, level = 15},
["Finneon"] = {skill = 40, level = 15},
["Staryu"] = {skill = 40, level = 15},
["Psyduck"] = {skill = 40, level = 35},
["Sharpedo"] = {skill = 60, level = 15},
["Kingler"] = {skill = 60, level = 20},
["Lumineon"] = {skill = 60, level = 20},
["Crawdaunt"] = {skill = 60, level = 20},
["Seadra"] = {skill = 60, level = 20},
["Gorebyss"] = {skill = 60, level = 25},
["Huntail"] = {skill = 60, level = 25},
["Starmie"] = {skill = 80, level = 30},
["Mantine"] = {skill = 80, level = 80},
["Qwilfish"] = {skill = 80, level = 80},
["Remoraid"] = {skill = 80, level = 80},
["Poliwhirl"] = {skill = 80, level = 80},
["Whiscash"] = {skill = 80, level = 80},
["Tentacruel"] = {skill = 80, level = 80},
["Lanturn"] = {skill = 100, level = 100},
["Quagsire"] = {skill = 100, level = 100},
["Gyarados"] = {skill = 120, level = 120},
["Lapras"] = {skill = 120, level = 120},
["Golduck"] = {skill = 80, level = 140},
["Blastoise"] = {skill = 120, level = 160},
["Feraligatr"] = {skill = 120, level = 160},
["Azumarill"] = {skill = 120, level = 120},
["Politoed"] = {skill = 120, level = 120},
["Kingdra"] = {skill = 120, level = 120},
["Prinplup"] = {skill = 120, level = 120},
["Empoleon"] = {skill = 120, level = 120},
["Floatzel"] = {skill = 120, level = 120},
["Wailord"] = {skill = 120, level = 120},
["Wailmer"] = {skill = 120, level = 120},
}

local fishing2 = {
   ["Charmander"] = {skill = 1, level = -2},
   ["Charmeleon"] = {skill = 10, level = 10},
   ["Vulpix"] = {skill = 10, level = 10},
   ["Torchic"] = {skill = 10, level = 10},
   ["Growlithe"] = {skill = 20, level = 20},
   ["Ponyta"] = {skill = 20, level = 20},
   ["Cyndaquil"] = {skill = 30, level = 30},
   ["Quilava"] = {skill = 35, level = 35},
   ["Slugma"] = {skill = 40, level = 40},
   ["Numel"] = {skill = 40, level = 40},
   ["Torkoal"] = {skill = 50, level = 40},
   ["Chimchar"] = {skill = 50, level = 50},
   ["Tyhplosion"] = {skill = 60, level = 60},
   ["Arcanine"] = {skill = 60, level = 60},
   ["Magcargo"] = {skill = 70, level = 70},
   ["Magmar"] = {skill = 70, level = 70},
}

local storage = 15458
local bonus = 2.5
local limite = 120


local function doFish(cid, pos, ppos, chance, interval, number)
      if not isCreature(cid) then return false end
      if getThingPos(cid).x ~= ppos.x or getThingPos(cid).y ~= ppos.y then
         return false 
      end

      if event ~= nil and getCreaturePosition(cid).x ~= ppos.x then
         stopEvent(event)
         event = nil
      end

      if event ~= nil and getCreaturePosition(cid).y ~= ppos.y then
         stopEvent(event)
         event = nil
      end

      if getPlayerStorageValue(cid, storage) ~= number then return false end
      
      doSendMagicEffect(pos, CONST_ME_LOSEENERGY)

      local peixe = 0
      local playerpos = getClosestFreeTile(cid, getThingPos(cid))
      local fishes = {}
      local randomfish = ""

      for a, b in pairs (fishing) do
	      if getPlayerSkillLevel(cid, 6) >= b.skill then
		     table.insert(fishes, a)
          end
      end

	  if math.random(1, 100) <= chance then
      if getPlayerSkillLevel(cid, 6) < limite then 
	     doPlayerAddSkillTry(cid, 6, bonus)
      end

		 local randomfish = fishes[math.random(#fishes)]
	    local peixe = doCreateMonster(randomfish, playerpos, false)
		 doSendMagicEffect(pos, CONST_ME_WATERSPLASH)
		 if not isCreature(peixe) then
		    return true
		 end

		 doSendMagicEffect(getThingPos(cid), 173)
      end

      event = addEvent(doFish, 1000, cid, pos, ppos, chance, interval, number)
return true
end

local function doFish2(cid, pos, ppos, chance, interval, number)
   if not isCreature(cid) then return false end
   if getThingPos(cid).x ~= ppos.x or getThingPos(cid).y ~= ppos.y then
      return false 
   end

   if event ~= nil and getCreaturePosition(cid).x ~= ppos.x then
      stopEvent(event)
      event = nil
   end

   if event ~= nil and getCreaturePosition(cid).y ~= ppos.y then
      stopEvent(event)
      event = nil
   end

   if getPlayerStorageValue(cid, storage) ~= number then return false end
   
   doSendMagicEffect(pos, CONST_ME_LOSEENERGY)

   local peixe = 0
   local playerpos = getClosestFreeTile(cid, getThingPos(cid))
   local fishes2 = {}
   local randomfish = ""

   for a, b in pairs (fishing2) do
      if getPlayerSkillLevel(cid, 6) >= b.skill then
        table.insert(fishes2, a)
       end
   end

  if math.random(1, 100) <= chance then
   if getPlayerSkillLevel(cid, 6) < limite then 
     doPlayerAddSkillTry(cid, 6, bonus)
   end

    local randomfish = fishes2[math.random(#fishes2)]
    local peixe = doCreateMonster(randomfish, playerpos, false)
    doSendMagicEffect(pos, CONST_ME_WATERSPLASH)
    if not isCreature(peixe) then
       return true
    end

    doSendMagicEffect(getThingPos(cid), 173)
   end

   event = addEvent(doFish2, 1000, cid, pos, ppos, chance, interval, number)
return true
end

local waters = {4614, 4615, 4616, 4617, 4618, 4619, 4608, 4609, 4610, 4611, 4612, 4613, 7236, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625, 4665, 4666, 4820, 4821, 4822, 4823, 4824, 4825}
local radius = 0

 
function onUse(cid, item, fromPos, itemEx, toPos)
local checkPos = toPos
checkPos.stackpos = 0

if getTileThingByPos(checkPos).itemid <= 0 then
   doPlayerSendCancel(cid, '!')
   return true
end

if getTileInfo(toPos).itemid ~= 598 then
   if not isInArray(waters, getTileInfo(toPos).itemid) then
      return true
   end
end

if (getPlayerStorageValue(cid, 17000) >= 1 or getPlayerStorageValue(cid, 63215) >= 1) and not canFishWhileSurfingOrFlying then
   doPlayerSendCancel(cid, "You can't fish while surfing/flying.")
   return true
end

if isInArray(waters, getTileInfo(getThingPos(cid)).itemid) then
   doPlayerSendCancel(cid, "You can\'t fish while surfing neither flying above water.")
   return true
end

if getTileInfo(getThingPos(getCreatureSummons(cid)[1] or cid)).protection then
	doPlayerSendCancel(cid, "You can't fish pokémons if you or your pokémon is in protection zone.")
return true
end

setPlayerStorageValue(cid, storage, getPlayerStorageValue(cid, storage) + 1)

local delay = 15000 - getPlayerSkillLevel(cid, 6) * 105
local chance = 18 + getPlayerSkillLevel(cid, 6) / 4.20

if itemEx.itemid == 598 then
   doFish2(cid, toPos, getThingPos(cid), chance, delay, getPlayerStorageValue(cid, storage))
else
   doFish(cid, toPos, getThingPos(cid), chance, delay, getPlayerStorageValue(cid, storage))
end
return true
end