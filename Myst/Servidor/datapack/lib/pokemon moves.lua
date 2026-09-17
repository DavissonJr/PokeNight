const_distance_delay = 0

RollOuts = {
    ["Voltorb"] = {lookType = 638},
    ["Electrode"] = {lookType = 637},
    ["Sandshrew"] = {lookType = 635},
    ["Sandslash"] = {lookType = 636},
    ["Phanpy"] = {lookType = 1005},
    ["Donphan"] = {lookType = 1456},
    ["Miltank"] = {lookType = 1006},                
    ["Golem"] = {lookType = 639},
    ["Shiny Electrode"] = {lookType = 1387},
    ["Shiny Golem"] = {lookType = 1403},
    ["Shiny Voltorb"] = {lookType = 1388}
}

local function getSubName(cid, target)
if not isCreature(cid) then return "" end
if getCreatureName(cid) == "Ditto" and pokes[getPlayerStorageValue(cid, 1010)] and getPlayerStorageValue(cid, 1010) ~= "Ditto" then
   return getPlayerStorageValue(cid, 1010)
elseif pokeHaveReflect(cid) and isCreature(target) then
   return getCreatureName(target)
else                                                                --alterado v1.6.1
   return getCreatureName(cid)
end
end

local function getThingName(cid)
if not isCreature(cid) then return "" end   --alterado v1.6
return getCreatureName(cid)
end

function getTableMove(cid, move)
local backup = {f = 0, t = ""}

if getThingName(cid) == "Ditto" and pokes[getPlayerStorageValue(cid, 1010)] and getPlayerStorageValue(cid, 1010) ~= "Ditto" then
   name = getPlayerStorageValue(cid, 1010)
else
   name = getThingName(cid)
end

if not isCreature(cid) or name == "" or not move then 
    return backup 
end

local x = movestable[name]
if not x then 
    return "" 
end   

local z = {x.move1, x.move2, x.move3, x.move4, x.move5, x.move6, x.move7, x.move8, x.move9, x.move10, x.move11, x.move12, x.passive1, x.passive2, x.passive3}
if getPlayerStorageValue(cid, 21103) ~= -1 then
   local sto = getPlayerStorageValue(cid, 21103) 
   setPlayerStorageValue(cid, 21103, -1) 
   return {f = sto, t = ""} 
end

for j = 1, 15 do
  if z[j] and z[j].name == move then
     return z[j]
  end
end

return movesinfo[move]
end

function getMasterTarget(cid)
if isCreature(cid) and getPlayerStorageValue(cid, 21101) ~= -1 then
   return getPlayerStorageValue(cid, 21101)     --alterado v1.6
end
    if isSummon(cid) then
	    return getCreatureTarget(getCreatureMaster(cid))
	else
	    return getCreatureTarget(cid)
    end
end

function docastspell(cid, spell, mina, maxa)
if not isCreature(cid) or getCreatureHealth(cid) <= 0 then 
    return false 
end

if isSummon(cid) and isInArray({"Restore", "Healarea", "Rest", "Selfheal", "Polish Rock", "Roost", "Synthesis"}, spell) then
    for i = 1,2 do
        addEvent(function()
            if isPlayer(getCreatureMaster(cid)) then
                updateLifeBarPokemon(getCreatureMaster(cid)) -- Thalles
                    
                local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
                if item.uid <= 0 then return true end
                sendGoPokemonInfo(getCreatureMaster(cid), item, cid)
            end
        end, i * 250)
    end
end

local target = 0
local getDistDelay = 0

if isSleeping(cid) and getPlayerStorageValue(cid, 21100) <= -1 then 
    return true 
end

if isCreature(getMasterTarget(cid)) then
	target = getMasterTarget(cid)
	getDistDelay = getDistanceBetween(getThingPosWithDebug(cid), getThingPosWithDebug(target)) * const_distance_delay
end

local mydir = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local table = getTableMove(cid, spell) --alterado v1.6

local min = 0
local max = 0                                                                                                                                                                                                                                                                     

if (isWithFear(cid) or isSilence(cid)) and getPlayerStorageValue(cid, 21100) <= -1 then
    return true                                      --alterado v1.6!!
end
	
if mina and maxa then
min = math.abs(mina)
max = math.abs(maxa)
elseif not isPlayer(cid) then
	if table ~= "" then
        if isSummon(cid) then
            min = getSpecialAttack(cid)
            max = min + (isSummon(cid) and getMasterLevel(cid) or getMasterLevel(cid))
        
            if spell == "Selfdestruct" then
            min = getCreatureHealth(cid)
            max = getCreatureHealth(cid)
            end

            if isNpcSummon(cid) then
                local mnn = {" use ", " "}
                local use = mnn[math.random(#mnn)]
                doCreatureSay(getCreatureMaster(cid), getPlayerStorageValue(cid, 1007)..","..use..""..doCorrectString(spell).."!", 1)
            end
        else
            min = getSpecialAttack(cid)
            max = min * 2.0
        end
	else
	    --print("Error trying to use move "..spell..", move not specified in the pokemon table.")
	end	
end

ghostDmg = GHOSTDAMAGE
psyDmg = PSYCHICDAMAGE

setPlayerStorageValue(cid, 21100, -1)
setPlayerStorageValue(cid, 21101, -1)
setPlayerStorageValue(cid, 21102, spell)

if spell == "Reflect" or spell == "Magic Coat" then

    if spell == "Magic Coat" then
      eff = 11
    else
      eff = 135
    end

	doSendMagicEffect(getThingPosWithDebug(cid), eff)
	setPlayerStorageValue(cid, 21099, 1)         
	
elseif spell == "Quick Attack" then
    if not isCreature(target) then
        return true
    end

    doSendMagicEffect(getThingPosWithDebug(cid), 211)
	local x = getClosestFreeTile(cid, getThingPosWithDebug(target))
	doTeleportThing(cid, x, false)
	doFaceCreature(cid, getThingPosWithDebug(target))
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 3)
	
elseif spell == "Razor Leaf" then                      

local eff = spell == "Razor Leaf" and 8 or 21

local function throw(cid, target)
if not isCreature(cid) or not isCreature(target) then return false end
    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), eff)
	doDanoInTargetWithDelay(cid, target, GRASSDAMAGE, min, max, 245)  --alterado v1.7
end

throw(cid, target)
throw(cid, target)

		
elseif spell == "Vine Whip" then

local area = getThingPosWithDebug(cid)
local dano = {}
local effect = 255

	if mydir == 0 then
		area.x = area.x + 1
		area.y = area.y - 1
		dano = whipn
		effect = 80
	elseif mydir == 1 then
		area.x = area.x + 2
		area.y = area.y + 1
		dano = whipe
		effect = 83
	elseif mydir == 2 then
		area.x = area.x + 1
		area.y = area.y + 2		
		dano = whips
		effect = 81
	elseif mydir == 3 then
		area.x = area.x - 1
		area.y = area.y + 1
		dano = whipw
		effect = 82
	end

		doSendMagicEffect(area, effect)
		doAreaCombatHealth(cid, GRASSDAMAGE, getThingPosWithDebug(cid), dano, -min, -max, 255)
		
elseif spell == "Headbutt" then
       
       doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 118)
       
elseif spell == "Leech Seed" then

    local ret = {}
    ret.id = target
    ret.attacker = cid
    ret.cd = 5
    ret.check = getPlayerStorageValue(target, conds["Leech"])
    ret.damage = isSummon(cid) and getMasterLevel(cid) * 7 +getPokemonBoost(cid)
    ret.cond = "Leech"
    
	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 1)
	doMoveDano2(cid, target, GRASSDAMAGE, 0, 0, ret, spell)
	
elseif spell == "Solar Beam" then
	
local function useSolarBeam(cid)
		if not isCreature(cid) then
		return true
		end
		if isSleeping(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
		return true
		end
		if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
		return true
		end
			local effect1 = 255
			local effect2 = 255
			local effect3 = 255
			local effect4 = 255
			local effect5 = 255
			local area = {}
			local pos1 = getThingPosWithDebug(cid)
			local pos2 = getThingPosWithDebug(cid)
			local pos3 = getThingPosWithDebug(cid)
			local pos4 = getThingPosWithDebug(cid)
			local pos5 = getThingPosWithDebug(cid)
		if getCreatureLookDir(cid) == 1 then
			effect1 = 4
			effect2 = 89
			effect3 = 89
			effect4 = 89
			effect5 = 26
			pos1.x = pos1.x + 2
			pos1.y = pos1.y + 1
			pos2.x = pos2.x + 3
			pos2.y = pos2.y + 1
			pos3.x = pos3.x + 4
			pos3.y = pos3.y + 1
			pos4.x = pos4.x + 5
			pos4.y = pos4.y + 1
			pos5.x = pos5.x + 6
			pos5.y = pos5.y + 1
			area = solare
		elseif getCreatureLookDir(cid) == 0 then
			effect1 = 36
			effect2 = 37
			effect3 = 37
			effect4 = 38
			pos1.x = pos1.x + 1
			pos1.y = pos1.y - 1
			pos2.x = pos2.x + 1
			pos2.y = pos2.y - 3
			pos3.x = pos3.x + 1
			pos3.y = pos3.y - 4
			pos4.x = pos4.x + 1
			pos4.y = pos4.y - 5
			area = solarn
		elseif getCreatureLookDir(cid) == 2 then
			effect1 = 46
			effect2 = 50
			effect3 = 50
			effect4 = 59
			pos1.x = pos1.x + 1
			pos1.y = pos1.y + 2
			pos2.x = pos2.x + 1
			pos2.y = pos2.y + 3
			pos3.x = pos3.x + 1
			pos3.y = pos3.y + 4
			pos4.x = pos4.x + 1
			pos4.y = pos4.y + 5
			area = solars
		elseif getCreatureLookDir(cid) == 3 then
			effect1 = 115
			effect2 = 162
			effect3 = 162
			effect4 = 162
			effect5 = 163
			pos1.x = pos1.x - 1
			pos1.y = pos1.y + 1
			pos2.x = pos2.x - 3
			pos2.y = pos2.y + 1
			pos3.x = pos3.x - 4
			pos3.y = pos3.y + 1
			pos4.x = pos4.x - 5
			pos4.y = pos4.y + 1
			pos5.x = pos5.x - 6
			pos5.y = pos5.y + 1
			area = solarw
		end

		if effect1 ~= 255 then
			doSendMagicEffect(pos1, effect1)
		end
		if effect2 ~= 255 then
			doSendMagicEffect(pos2, effect2)
		end
		if effect3 ~= 255 then
			doSendMagicEffect(pos3, effect3)
		end
		if effect4 ~= 255 then
			doSendMagicEffect(pos4, effect4)
		end
		if effect5 ~= 255 then
			doSendMagicEffect(pos5, effect5)
		end
	
		doAreaCombatHealth(cid, GRASSDAMAGE, getThingPosWithDebug(cid), area, -min, -max, 255)	
		doRegainSpeed(cid)
		setPlayerStorageValue(cid, 3644587, -1)
	end

	local function ChargingBeam(cid)
		if not isCreature(cid) then
		return true
		end
		if isSleeping(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
		return true
		end
		if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
		return true
		end
		local tab = {}

		for x = -2, 2 do
			for y = -2, 2 do
				local pos = getThingPosWithDebug(cid)
				pos.x = pos.x + x
				pos.y = pos.y + y
					if pos.x ~= getThingPosWithDebug(cid).x and pos.y ~= getThingPosWithDebug(cid).y then
					table.insert(tab, pos)
					end
			end
		end
	doSendDistanceShoot(tab[math.random(#tab)], getThingPosWithDebug(cid), 37)
	end

doChangeSpeed(cid, -getCreatureSpeed(cid))
setPlayerStorageValue(cid, 3644587, 1)          --alterado v1.6  n sei pq mas tava dando debug o.O

doSendMagicEffect(getThingPosWithDebug(cid), 132) 
useSolarBeam(cid)

elseif spell == "Sleep Powder" then

local ret = {}
ret.id = 0
ret.cd = math.random(6, 9)
ret.check = 0
ret.first = true                        --alterado v1.6
ret.cond = "Sleep"
	
doMoveInArea2(cid, 0, confusion, NORMALDAMAGE, 0, 0, spell, ret)

elseif spell == "Stun Spore" then
        
    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.eff = 0
    ret.check = 0
    ret.spell = spell
    
    
    doMoveInArea2(cid, 335, confusion, GRASSDAMAGE, 0, 0, spell, ret)

	
	elseif spell == "Ancestral Attack" then
        
    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.eff = 0
    ret.check = 0
    ret.spell = spell
    
    
    doMoveInArea2(cid, 18, confusion, GRASSDAMAGE, min, max, spell, ret)

    elseif spell == "Stone EdgeBACKUP" then
        
    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.eff = 0
    ret.check = 0
    ret.spell = spell
    
    
    doMoveInArea2(cid, 102, confusion, GRASSDAMAGE, min, max, spell, ret)

elseif spell == "Poison Powder" then                              

local ret = {}
ret.id = 0
ret.cd = math.random(6, 15)              --alterado v1.6
ret.check = 0
local lvl = isSummon(cid) and getMasterLevel(cid)
ret.damage = lvl
ret.cond = "Poison"                              

doMoveInArea2(cid, 324, confusion, NORMALDAMAGE, 0, 0, spell, ret)
	
elseif spell == "Bullet Seed" then
               --cid, effDist, effDano, areaEff, areaDano, element, min, max
doMoveInAreaMulti(cid, 1, 45, bullet, bulletDano, GRASSDAMAGE, min, max)

elseif spell == "Body Slam" then
	
	doBodyPush(cid, target, true)
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 3)
    
elseif spell == "Leaf Storm" then

	doDanoWithProtect(cid, GRASSDAMAGE, getThingPosWithDebug(cid), grassarea, -min, -max, 0)

	local pos = getThingPosWithDebug(cid)

	local function doSendLeafStorm(cid, pos)              --alterado!!
		if not isCreature(cid) then return true end
	    doSendDistanceShoot(getThingPosWithDebug(cid), pos, 4)
	end

	for a = 1, 100 do
		local lugar = {x = pos.x + math.random(-6, 6), y = pos.y + math.random(-5, 5), z = pos.z}
		doSendLeafStorm(cid, lugar)
	end
	
elseif spell == "Dazzling Gleam" then

    doMoveInArea2(cid, 39, dazzling, dano, min, max, spell, ret)
	doDanoWithProtect(cid, GRASSDAMAGE, getThingPosWithDebug(cid), grassarea, -min, -max, 0)

	local pos = getThingPosWithDebug(cid)

	local function doSendLeafStorm(cid, pos)              --alterado!!
		if not isCreature(cid) then return true end
	    doSendDistanceShoot(getThingPosWithDebug(cid), pos, 37)
	end

	for a = 1, 100 do
		local lugar = {x = pos.x + math.random(-3, 3), y = pos.y + math.random(-2, 2), z = pos.z}
		doSendLeafStorm(cid, lugar)
	end

elseif spell == "Incinerate" then

    doMoveInArea2(cid, 267, dazzling, dano, min, max, spell, ret)
	doDanoWithProtect(cid, GRASSDAMAGE, getThingPosWithDebug(cid), grassarea, -min, -max, 0)

	local pos = getThingPosWithDebug(cid)

	local function doSendLeafStorm(cid, pos)              --alterado!!
		if not isCreature(cid) then return true end
	    doSendDistanceShoot(getThingPosWithDebug(cid), pos, 3)
	end
	
	elseif spell == "Zoroark Gleam" then

   	 doMoveInArea2(cid, 242, dazzling, dano, min, max, spell, ret)
	 doDanoWithProtect(cid, GRASSDAMAGE, getThingPosWithDebug(cid), grassarea, -min, -max, 0)
    
    elseif spell == "Spiritomb Gleam" then

   	 doMoveInArea2(cid, 242, dazzling, dano, min, max, spell, ret)
	 doDanoWithProtect(cid, GRASSDAMAGE, getThingPosWithDebug(cid), grassarea, -min, -max, 0)
    
    elseif spell == "Honchkrow Gleam" then

   	 doMoveInArea2(cid, 242, dazzling, dano, min, max, spell, ret)
	 doDanoWithProtect(cid, GRASSDAMAGE, getThingPosWithDebug(cid), grassarea, -min, -max, 0)

    elseif spell == "Phantom Gleam" then

   	 doMoveInArea2(cid, 242, dazzling, dano, min, max, spell, ret)
	 doDanoWithProtect(cid, GRASSDAMAGE, getThingPosWithDebug(cid), grassarea, -min, -max, 0)

	local pos = getThingPosWithDebug(cid)

	local function doSendLeafStorm(cid, pos)              --alterado!!
		if not isCreature(cid) then return true end
	    doSendDistanceShoot(getThingPosWithDebug(cid), pos, 28)
	end

	for a = 242, 100 do
		local lugar = {x = pos.x + math.random(-3, 3), y = pos.y + math.random(-2, 2), z = pos.z}
		doSendLeafStorm(cid, lugar)
	end

elseif spell == "Stone Edge" then

    local pos = getThingPosWithDebug(cid)
    local areas = {rock1}

    for i = 1, #areas do
        addEvent(doMoveInArea2, i*120, cid, 102, areas[i], ROCKDAMAGE, min, max, spell)
    end

elseif spell == "Overheat" then

    local pos = getThingPosWithDebug(cid)
    local areas = {overheat}

    for i = 1, #areas do
        addEvent(doMoveInArea2, i*120, cid, 287, areas[i], ROCKDAMAGE, min, max, spell)
    end

elseif spell == "Wave Punch" then

    local pos = getThingPosWithDebug(cid)
    local areas = {rock1, rock2, rock3, rock4, rock5, rock4, rock3, rock2, rock1}

    for i = 1, #areas do
        addEvent(doMoveInArea2, i*120, cid, 218, areas[i], FIGHTDAMAGE, min, max, spell)
    end

elseif spell == "Shock Wave" then

    local pos = getThingPosWithDebug(cid)
    local areas = {rock1, rock2, rock3, rock4, rock5, rock4, rock3, rock2, rock1}

    for i = 1, #areas do
        addEvent(doMoveInArea2, i*120, cid, 320, areas[i], ELETRICDAMAGE, min, max, spell)
    end

elseif spell == "Hurricane" then

    local pos = getThingPosWithDebug(cid)
    local areas = {rock1, rock2, rock3, rock4, rock5, rock4, rock3, rock2, rock1}

    for i = 1, #areas do
        addEvent(doMoveInArea2, i*120, cid, 42, areas[i], ELETRICDAMAGE, min, max, spell)
    end

elseif spell == "Scizor Attack" then

   	doMoveInArea2(cid, 240, dazzling, dano, min, max, spell, ret)
	doDanoWithProtect(cid, GRASSDAMAGE, getThingPosWithDebug(cid), grassarea, -min, -max, 0)

	local pos = getThingPosWithDebug(cid)

	local function doSendLeafStorm(cid, pos)              --alterado!!
		if not isCreature(cid) then return true end
	    doSendDistanceShoot(getThingPosWithDebug(cid), pos, 28)
	end

	for a = 253, 100 do
		local lugar = {x = pos.x + math.random(-3, 3), y = pos.y + math.random(-2, 2), z = pos.z}
		doSendLeafStorm(cid, lugar)
	end
    
elseif spell == "Scratch" then

	doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 142)
	
elseif spell == "Scratching Dragon" then

	doDanoWithProtect(cid, DRAGONDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 219)
	
elseif spell == "Scratching Ice" then

	doDanoWithProtect(cid, ICEDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 238)
	
elseif spell == "Scratching Fire" then

	doDanoWithProtect(cid, FIREDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 207)
	
elseif spell == "Punch Fly" then

	doDanoWithProtect(cid, FIREDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 222)
	
elseif spell == "Eternal Punch" then

	doDanoWithProtect(cid, FIREDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 99)
	
elseif spell == "Punch Right" then

	doDanoWithProtect(cid, FIREDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 90)
    
elseif spell == "Petal Dance" then

    doMoveInArea2(cid, 245, dazzling, dano, min, max, spell, ret)
	doDanoWithProtect(cid, GRASSDAMAGE, getThingPosWithDebug(cid), grassarea, -min, -max, 0)

	local pos = getThingPosWithDebug(cid)

	local function doSendLeafStorm(cid, pos)              --alterado!!
		if not isCreature(cid) then return true end
	    doSendDistanceShoot(getThingPosWithDebug(cid), pos, 28)
	end

	for a = 1, 100 do
		local lugar = {x = pos.x + math.random(-3, 3), y = pos.y + math.random(-2, 2), z = pos.z}
		doSendLeafStorm(cid, lugar)
	end
    
elseif spell == "Scratch" then

	doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 142)
    
elseif spell == "Ember" then

		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 3)
		doDanoInTargetWithDelay(cid, target, FIREDAMAGE, min, max, 15)  --alterado v1.7

elseif spell == "Flamethrower" then

	local flamepos = getThingPosWithDebug(cid)
    local effect = 255
    local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

	if a == 0 then
		flamepos.x = flamepos.x+1
		flamepos.y = flamepos.y-1
		effect = 106
	elseif a == 1 then
		flamepos.x = flamepos.x+3
		flamepos.y = flamepos.y+1
		effect = 109
	elseif a == 2 then
		flamepos.x = flamepos.x+1
		flamepos.y = flamepos.y+3
		effect = 107
	elseif a == 3 then
		flamepos.x = flamepos.x-1
		flamepos.y = flamepos.y+1
		effect = 108
	end

        doMoveInArea2(cid, 0, flamek, FIREDAMAGE, min, max, spell)
		doSendMagicEffect(flamepos, effect)  
     

elseif spell == "Fireball" then

	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 248)
	doDanoWithProtect(cid, FIREDAMAGE, getThingPosWithDebug(target), waba, min, max, 5)
	
elseif spell == "Fire Fang" then

	doSendMagicEffect(getThingPosWithDebug(target), 138) 
    doDanoInTargetWithDelay(cid, target, FIREDAMAGE, min, max, 15) --alterado v1.7
	
elseif spell == "Fire Blast" then

local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area, eff)
if isCreature(cid) then
   if not isSightClear(p, area, false) then return true end 
   doAreaCombatHealth(cid, FIREDAMAGE, area, 0, 0, 0, eff)
   doAreaCombatHealth(cid, FIREDAMAGE, area, whirl3, -min, -max, 35)
end
end

for a = 0, 4 do

local t = {
[0] = {60, {x=p.x, y=p.y-(a+1), z=p.z}},           --alterado v1.4
[1] = {61, {x=p.x+(a+1), y=p.y, z=p.z}},
[2] = {62, {x=p.x, y=p.y+(a+1), z=p.z}},
[3] = {63, {x=p.x-(a+1), y=p.y, z=p.z}}
}   
addEvent(sendAtk, 300*a, cid, t[d][2], t[d][1])
end
	
elseif spell == "Rage" then

   local ret = {}
   ret.id = cid
   ret.cd = 15
   ret.eff = 13
   ret.check = 0
   ret.buff = spell
   ret.first = true
   
   doCondition2(ret)
      
elseif spell == "Raging Blast" then

                 --cid, effDist, effDano, areaEff, areaDano, element, min, max
       doMoveInAreaMulti(cid, 3, 6, bullet, bulletDano, FIREDAMAGE, min, max) 
       
elseif spell == "Dragon Claw" then

       doDanoWithProtect(cid, DRAGONDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 141)
       
elseif spell == "Wing Attack" or spell == "Steel Wing" then

local effectpos = getThingPosWithDebug(cid)
local effect = 255
local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

	if a == 0 then
		effect = spell == "Steel Wing" and 251 or 128
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y - 1                   --alterado v1.4
	elseif a == 1 then
		effectpos.x = effectpos.x + 2
		effectpos.y = effectpos.y + 1
		effect = spell == "Steel Wing" and 253 or 129
	elseif a == 2 then
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y + 2
		effect = spell == "Steel Wing" and 252 or 131
	elseif a == 3 then
		effectpos.x = effectpos.x - 1
		effectpos.y = effectpos.y + 1
		effect = spell == "Steel Wing" and 254 or 130
	end

		doSendMagicEffect(effectpos, effect)
		doMoveInArea2(cid, 0, wingatk, FLYINGDAMAGE, min, max, spell)
		
elseif spell == "Revenge" then

local eff = {111, 112, 113, 111}
local area = {flames1, flames2, flames3, flames4}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIGHTINGDAMAGE, min, max, spell)
end

elseif spell == "Revenge Zoroark" then

local eff = {103, 104, 103, 104}
local area = {flames1, flames2, flames3, flames4}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIGHTINGDAMAGE, min, max, spell)
end

elseif spell == "Mystic Darkness" then

    local eff = {322, 322, 322, 322}
    local area = {flames1, flames2, flames3, flames4}
    
    for i = 1, #area do
        addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], DARKDAMAGE, min, max, spell)
    end

elseif spell == "Fire Ondur" then

local eff = {103, 104, 103, 104}
local area = {flames1, flames2, flames3, flames4}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIGHTINGDAMAGE, min, max, spell)
end


elseif spell == "Revenge Toxic" then

local eff = {274, 274, 274, 274}
local area = {flames1, flames2, flames3, flames4}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIGHTINGDAMAGE, min, max, spell)
end

elseif spell == "High Dream" then

local eff = {248, 248, 248, 248}
local area = {flames1, flames2, flames3, flames4}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIGHTINGDAMAGE, min, max, spell)
end

elseif spell == "Magma Storm" then

local eff = {6, 35, 35, 6}
local area = {flames1, flames2, flames3, flames4}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIREDAMAGE, min, max, spell)
end

elseif spell == "Zoroark Storm" then

local eff = {238, 238, 238, 238}
local area = {flames1, flames2, flames3, flames4}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], DARKDAMAGE, min, max, spell)
end

elseif spell == "Water Explosion" then

local eff = {53, 53, 53, 53}
local area = {wat1, wat2, wat4, wat5}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], WATERDAMAGE, min, max, spell)
end

elseif spell == "Grass Pledge" then

local eff = {275, 275, 275, 275}
local area = {rock2, rock3, rock4, rock5}

for i = 1, #area do
    addEvent(doSendMagicEffect, i*120, getThingPos(cid), 275)
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], GRASSDAMAGE, min, max, spell)
end

elseif spell == "Bubbles" then

	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 2)
	doDanoInTargetWithDelay(cid, target, WATERDAMAGE, min, max, 25) --alterado v1.7
	
elseif spell == "Clamp" then

	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 2)
	doDanoInTargetWithDelay(cid, target, WATERDAMAGE, min, max, 53)  --alterado v1.7

elseif spell == "Water Gun" then

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local p = getThingPosWithDebug(cid)
local t = {
[0] = {69, {x=p.x, y=p.y-1, z=p.z}},
[1] = {70, {x=p.x+6, y=p.y, z=p.z}},      --alterado v1.8
[2] = {71, {x=p.x, y=p.y+6, z=p.z}},
[3] = {72, {x=p.x-1, y=p.y, z=p.z}},
}

doMoveInArea2(cid, 0, triplo6, WATERDAMAGE, min, max, spell)
doSendMagicEffect(t[a][2], t[a][1])
	
elseif spell == "Waterball" then
		             
    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 2)
    doDanoWithProtectWithDelay(cid, target, WATERDAMAGE, min, max, 68, waba)
	
elseif spell == "Aqua Tail" then

	local function rebackSpd(cid, sss)
		if not isCreature(cid) then return true end
		doChangeSpeed(cid, sss)
		setPlayerStorageValue(cid, 446, -1)
	end

	local x = getCreatureSpeed(cid)
	doFaceOpposite(cid)
	setPlayerStorageValue(cid, 446, 1)
	doAreaCombatHealth(cid, WATERDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 68)
	
elseif spell == "Hydro Cannon" then

local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area, eff)
if isCreature(cid) then
   if not isSightClear(p, area, false) then return true end
   doAreaCombatHealth(cid, WATERDAMAGE, area, 0, 0, 0, eff)
   doAreaCombatHealth(cid, WATERDAMAGE, area, whirl3, -min, -max, 68)
end
end

for a = 0, 4 do

local t = {                                     --alterado v1.4
[0] = {64, {x=p.x, y=p.y-(a+1), z=p.z}},
[1] = {65, {x=p.x+(a+1), y=p.y, z=p.z}},
[2] = {66, {x=p.x, y=p.y+(a+1), z=p.z}},
[3] = {67, {x=p.x-(a+1), y=p.y, z=p.z}}
}   
addEvent(sendAtk, 300*a, cid, t[d][2], t[d][1])
end
	
elseif spell == "Harden" or spell == "Calm Mind" or spell == "Defense Curl" or spell == "Charm" then	
                                                                    --alterado v1.4
    if spell == "Calm Mind" then
       eff = 133

    elseif spell == "Charm" then
       eff = 147    
    else                             
       eff = 144
    end
    
    local ret = {}
    ret.id = cid
    ret.cd = 8
    ret.eff = eff
    ret.check = 0
    ret.buff = spell
    ret.first = true
   
    doCondition2(ret)

elseif spell == "Bubble Blast" then

                 --cid, effDist, effDano, areaEff, areaDano, element, min, max
       doMoveInAreaMulti(cid, 2, 68, bullet, bulletDano, WATERDAMAGE, min, max)
      
elseif spell == "Skull Bash" then

		doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(cid), skullb, min, max, 208) 	

elseif spell == "Hydropump" then

local pos = getThingPosWithDebug(cid)

	local function doSendBubble(cid, pos)
		if not isCreature(cid) then return true end
		doSendDistanceShoot(getThingPosWithDebug(cid), pos, 2)
		doSendMagicEffect(pos, 53)
	end
	                                                          --alterado!!
	for a = 1, 20 do
	    local lugar = {x = pos.x + math.random(-4, 4), y = pos.y + math.random(-3, 3), z = pos.z}
	    doSendBubble(cid, lugar)
	end
	doDanoWithProtect(cid, WATERDAMAGE, pos, waterarea, -min, -max, 0)

elseif spell == "String Shot" then

   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 23)
   
   local ret = {}
   ret.id = target
   ret.cd = 6
   ret.eff = 137
   ret.check = getPlayerStorageValue(target, conds["Stun"])
   ret.spell = spell
   
   
   doMoveDano2(cid, target, BUGDAMAGE, 0, 0, ret, spell)

elseif spell == "Bug Bite" then

	doSendMagicEffect(getThingPosWithDebug(target), 244)
    doDanoInTargetWithDelay(cid, target, BUGDAMAGE, min, max, 8) --alterado v1.7

elseif spell == "Super Sonic" then

	local rounds = math.random(4, 7)
	rounds = rounds + math.floor(getMasterLevel(cid) / 35)

	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 32)
	local ret = {}
	ret.id = target
	ret.cd = rounds
	ret.check = getPlayerStorageValue(target, conds["Confusion"])
	
	
	doMoveDano2(cid, target, NORMALDAMAGE, 0, 0, ret, spell)

elseif spell == "Whirlwind" then

area = {SL1, SL2, SL3, SL4}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, 42, area[i], FLYINGDAMAGE, min, max, spell)
end
	
elseif spell == "Psybeam" then

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local t = {
[0] = 58,       --alterado v1.6
[1] = 234,
[2] = 58,
[3] = 209,
}

doMoveInArea2(cid, t[a], reto4, psyDmg, min, max, spell)     --alterado v1.4

elseif spell == "Confusion" or spell == "Night Shade" then

    local rounds = math.random(4, 7)       --rever area...
    rounds = rounds + math.floor(getMasterLevel(cid) / 35)
    
    if spell == "Confusion" then
       dano = psyDmg             --alterado v1.4
    else
       dano = ghostDmg
    end

	local ret = {}
    ret.id = 0
    ret.check = 0
    ret.cd = rounds
    

    doMoveInArea2(cid, 136, selfArea1, dano, min, max, spell, ret)
	
elseif spell == "Horn Attack" then
       
       doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 15)
       doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 3) --alterado v1.7

elseif spell == "Poison Sting" then
       
       doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 15)
       doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 8) --alterado v1.7
		
elseif spell == "Fury Cutter" or spell == "Red Fury" then

       local effectpos = getThingPosWithDebug(cid)
       local effect = 255
       local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

	if a == 0 then
	    if getSubName(cid, target) == "Scizor" then  --alterado v1.6.1
	       effect = 236
	    else
		   effect = 128
	    end
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y - 1
	elseif a == 1 then
		effectpos.x = effectpos.x + 2
		effectpos.y = effectpos.y + 1
		if getSubName(cid, target) == "Scizor" then   --alterado v1.6.1
	       effect = 232
	    else
		   effect = 129
	    end
	elseif a == 2 then
		effectpos.x = effectpos.x + 1
		effectpos.y = effectpos.y + 2
		if getSubName(cid, target) == "Scizor" then   --alterado v1.6.1
	       effect = 233
	    else
		   effect = 131
	    end
	elseif a == 3 then
		effectpos.x = effectpos.x - 1
		effectpos.y = effectpos.y + 1
		if getSubName(cid, target) == "Scizor" then   --alterado v1.6.1
	       effect = 224
	    else
		   effect = 130
	    end
	end
        local function doFury(cid, effect)
        if not isCreature(cid)  then return true end
		   doSendMagicEffect(effectpos, effect)
		   doMoveInArea2(cid, 2, wingatk, BUGDAMAGE, min, max, spell)
        end                               
        
        doFury(cid, effect)
        
elseif spell == "Pin Missile" then

       doMoveInAreaMulti(cid, 13, 7, bullet, bulletDano, BUGDAMAGE, min, max)
       
elseif spell == "Strafe" or spell == "Agility" then

   local ret = {}
   ret.id = cid
   ret.cd = 15
   ret.eff = 14
   ret.check = 0
   ret.buff = spell
   ret.first = true
   
   doCondition2(ret)
    
elseif spell == "Gust" then

       doMoveInArea2(cid, 42, reto5, FLYINGDAMAGE, min, max, spell) 
       
elseif spell == "Drill Peck" then
	
doDanoWithProtect(cid, FLYINGDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 148)

elseif spell == "Tornado" then

    local pos = getThingPosWithDebug(cid)

	local function doSendTornado(cid, pos)
		if not isCreature(cid) then return true end
		doSendDistanceShoot(getThingPosWithDebug(cid), pos, 22)
		doSendMagicEffect(pos, 42)
	end

	for b = 1, 3 do
		for a = 1, 20 do
			local lugar = {x = pos.x + math.random(-4, 4), y = pos.y + math.random(-3, 3), z = pos.z}
			addEvent(doSendTornado, a * 75, cid, lugar)
		end
	end
	doDanoWithProtect(cid, FLYINGDAMAGE, pos, waterarea, -min, -max, 0)

elseif spell == "Windstorm" then

local eff = {273, 273, 273, 273}
local area = {windstorm1, windstorm2, windstorm1, windstorm2}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FLYINGDAMAGE, min, max, spell)
end
	
elseif spell == "Bite" or tonumber(spell) == 5 then

	doDanoWithProtect(cid, DARKDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 146)
	
elseif spell == "Super Fang" then

	doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 244)
	
elseif spell == "Poison Fang" then

	doSendMagicEffect(getThingPosWithDebug(target), 244)
    doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 114) --alterado v1.7
	
elseif spell == "Sting Gun" then
       
       local function doGun(cid, target)
       if not isCreature(cid) or not isCreature(target) then return true end    --alterado v1.7
          doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 13)
          doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 8)  --alterado v1.7
       end

       doGun(cid, target)
       doGun(cid, target)
       
elseif spell == "Acid" then

	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 14)
	doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 20)    --alterado v1.7
	
elseif spell == "Fear" or spell == "Roar" then

    local ret = {}
    ret.id = 0
    ret.cd = 5
    ret.check = 0
    ret.skill = spell
    ret.cond = "Fear"
    
    doMoveInArea2(cid, 0, confusion, DARKDAMAGE, 0, 0, spell, ret)
    
elseif spell == "Iron Tail" then

	local function rebackSpd(cid, sss)
		if not isCreature(cid) then return true end
		doChangeSpeed(cid, sss)
		setPlayerStorageValue(cid, 446, -1)
	end

	local x = getCreatureSpeed(cid)
	doFaceOpposite(cid)
	setPlayerStorageValue(cid, 446, 1)
	doDanoWithProtect(cid, STEELDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 160)
	
elseif spell == "Thunder Shock" then
                                     
	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 40)
	doDanoInTargetWithDelay(cid, target, ELECTRICDAMAGE, min, max, 48)   --alterado v1.7

elseif spell == "Thunder Bolt" then

        --alterado v1.7
		local function doThunderFall(cid, frompos, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		local pos = getThingPosWithDebug(target)
		local ry = math.abs(frompos.y - pos.y)
		doSendDistanceShoot(frompos, getThingPosWithDebug(target), 41)
		doDanoInTarget(cid, target, ELECTRICDAMAGE, min, max, 48) --alterado v1.7
		end

		local function doThunderUp(cid, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		local pos = getThingPosWithDebug(target)
		local mps = getThingPosWithDebug(cid)
		local xrg = math.floor((pos.x - mps.x) / 2)
		local topos = mps
		topos.x = topos.x + xrg
		local rd =  7
		topos.y = topos.y - rd
		doSendDistanceShoot(getThingPosWithDebug(cid), topos, 41)
		doThunderFall(cid, topos, target)
		end		

    setPlayerStorageValue(cid, 3644587, 1)
    doThunderUp(cid, target)
    doThunderUp(cid, target)
	
elseif spell == "Thunder Wave" then

local eff = {276, 276, 276, 276, 276}
local area = {wat1, wat2, wat3, rock4, rock5}

for i = 1, #area do
   --[[  addEvent(doSendMagicEffect, i*120, getThingPos(cid), 276) ]]
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], WATERDAMAGE, min, max, spell)
end

elseif spell == "Thunder" then

local ret = {}
ret.id = 0
ret.cd = 9
ret.check = 0
ret.eff = 48
ret.spell = spell


doMoveInArea2(cid, 48, thunderr, ELECTRICDAMAGE, min, max, spell, ret)

elseif spell == "Freezing" then

local ret = {}
ret.id = 0
ret.cd = 9
ret.check = 0
ret.eff = 40
ret.spell = spell


doMoveInArea2(cid, 40, thunderr, ICEDAMAGE, min, max, spell, ret)

elseif spell == "Mega Kick" then

    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
	doDanoInTargetWithDelay(cid, target, FIGHTINGDAMAGE, min, max, 113)   --alterado v1.7
	
elseif spell == "Thunder Punch" then

	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
    doSendMagicEffect(getThingPosWithDebug(target), 112)
    doDanoInTargetWithDelay(cid, target, ELECTRICDAMAGE, min, max, 48) --alterado v1.7
	
elseif spell == "Electric Storm" then             

local master = isSummon(cid) and getCreatureMaster(cid) or cid

local function doFall(cid)
    fall(cid, master, ELECTRICDAMAGE, 41, 48)
    fall(cid, master, ELECTRICDAMAGE, 41, 48)
    fall(cid, master, ELECTRICDAMAGE, 41, 48)
    fall(cid, master, ELECTRICDAMAGE, 41, 48)
end

for up = 1, 10 do
    upEffect(cid, 41)
end

doFall(cid)

local ret = {}
ret.id = 0
ret.cd = 9
ret.check = 0
ret.eff = 48
ret.spell = spell


doMoveInArea2(cid, 0, BigArea2, ELECTRICDAMAGE, min, max, spell, ret)

elseif spell == "Mud Shot" or spell == "Mud Slap" then

if isCreature(target) then                                    --alterado v1.8
local contudion = spell == "Mud Shot" or "Stun"                                                   
local ret = {}
ret.id = target
ret.cd = 9
ret.eff = 34
ret.check = getPlayerStorageValue(target, conds[contudion])
ret.spell = spell
ret.cond = contudion

	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 6)
	doMoveDano2(cid, target, GROUNDDAMAGE, -min, -max, ret, spell)
end
 
elseif spell == "Rollout" then

    local function setOutfit(cid, outfit)
          if isCreature(cid) and getCreatureCondition(cid, CONDITION_OUTFIT) == true then
             if getCreatureOutfit(cid).lookType == outfit then
                doRemoveCondition(cid, CONDITION_OUTFIT)
             end
          end
    end
    
	if RollOuts[getSubName(cid, target)] then
		doSetCreatureOutfit(cid, RollOuts[getSubName(cid, target)], -1)   --alterado v1.6.1
    end 

	local outfit = getCreatureOutfit(cid).lookType

    local function roll(cid, outfit)
    if not isCreature(cid) then return true end
    if isSleeping(cid) then return true end
       if RollOuts[getSubName(cid, target)] then
          doSetCreatureOutfit(cid, RollOuts[getSubName(cid, target)], -1)   --alterado v1.6.1
       end
       doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 0)
    end

    roll(cid, outfit)
    addEvent(setOutfit, 20, cid, outfit)
    
elseif spell == "Shockwave" then

local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area, areaEff, eff)
if isCreature(cid) then
   if not isSightClear(p, area, false) then return true end                                             --testar o atk!!
   doAreaCombatHealth(cid, GROUNDDAMAGE, areaEff, 0, 0, 0, eff)    
   doAreaCombatHealth(cid, GROUNDDAMAGE, area, whirl3, -min, -max, 255)     
end
end

for a = 0, 5 do

local t = {
[0] = {126, {x=p.x, y=p.y-(a+1), z=p.z}, {x=p.x+1, y=p.y-(a+1), z=p.z}},           
[1] = {124, {x=p.x+(a+1), y=p.y, z=p.z}, {x=p.x+(a+1), y=p.y+1, z=p.z}},
[2] = {125, {x=p.x, y=p.y+(a+1), z=p.z}, {x=p.x+1, y=p.y+(a+1), z=p.z}},
[3] = {123, {x=p.x-(a+1), y=p.y, z=p.z}, {x=p.x-(a+1), y=p.y+1, z=p.z}}
}   
addEvent(sendAtk, 325*a, cid, t[d][2], t[d][3], t[d][1])
end                          
	
elseif spell == "Sweet Kiss" then                   

local function throw(cid, target)
if not isCreature(cid) or not isCreature(target) then return false end
	doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 147)  
end

throw(cid, target)	
throw(cid, target)

elseif spell == "Dynamic Punch" then                   

local function throw(cid, target)
if not isCreature(cid) or not isCreature(target) then return false end
	doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 90)  
end

elseif spell == "Mean Look" then                   

local function throw(cid, target)
if not isCreature(cid) or not isCreature(target) then return false end
	doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 139)  
end

throw(cid, target)	
throw(cid, target)	
	
elseif spell == "Draining Kiss" then

	local life = getCreatureHealth(target)

	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 14)
    
	local newlife = life - getCreatureHealth(target)

	doSendMagicEffect(getThingPosWithDebug(cid), 132)
	if newlife >= 1 then
	   doCreatureAddHealth(cid, newlife)
       doSendAnimatedText(getThingPosWithDebug(cid), "+"..newlife.."", 32)
	end  	
	
elseif spell == "Earthshock" then

local eff = getSubName(cid, target) == "Shiny Onix" and 179 or 157 --alterado v1.6.1              

	doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 255)

	local sps = getThingPosWithDebug(cid)
	sps.x = sps.x+1
	sps.y = sps.y+1
	doSendMagicEffect(sps, eff)
	
elseif spell == "Earthquake" then

local eff = getSubName(cid, target) == "Shiny Onix" and 263 or 263  --alterado v1.6.1
 
local function doQuake(cid)
if not isCreature(cid) then return false end
   doMoveInArea2(cid, eff, ee, GROUNDDAMAGE, min, max, spell)
end

times = {500, 1000, 1500, 2000, 2500, 0, 0}
for i = 1, #times do                   --alterado v1.4
    addEvent(doQuake, times[i], cid)
end

elseif spell == "Stunning Confusion" then

local eff = 137
 
local function doQuake(cid)
if not isCreature(cid) then return false end
   doMoveInArea2(cid, eff, ee, PSYCHICDAMAGE, min, max, spell)
end

times = {500, 1000, 1500, 2000, 2500, 0, 0}
for i = 1, #times do                   --alterado v1.4
    addEvent(doQuake, times[i], cid)
end

elseif spell == "Psychic Gleam" then

    local eff = 282  --alterado v1.6.1
     
    local function doQuake(cid)
    if not isCreature(cid) then return false end
       doMoveInArea2(cid, eff, ee, GROUNDDAMAGE, min, max, spell)
    end
    
    times = {500, 1000, 1500, 2000, 2500, 0, 0}
    for i = 1, #times do                   --alterado v1.4
        addEvent(doQuake, times[i], cid)
    end

elseif spell == "Water Flames" then

local eff = 278  --alterado v1.6.1
 
local function doQuake(cid)
if not isCreature(cid) then return false end
   doMoveInArea2(cid, eff, ee, GROUNDDAMAGE, min, max, spell)
end

doQuake(cid)

elseif spell == "Assurance" then
doMoveInArea2(cid, 277, ee, DARKDAMAGE, min, max, spell)

elseif spell == "Uproar" then

local effs = {261, 265, 261, 265, 261}
 
local function doQuake(cid)
if not isCreature(cid) then return false end
   for i = 1, #effs do
    --doMoveInArea2(cid, effs[i], selfArea2, GROUNDDAMAGE, min, max, spell)
    doDanoWithProtect(cid, psyDmg, getThingPosWithDebug(cid), selfArea2, min, max, effs[i])
   end
end

times = {500, 1000, 1500, 2000, 2500, 0}
for i = 1, #times do                   --alterado v1.4
    addEvent(doQuake, times[i], cid)
end

elseif spell == "Earth Light" then

    local eff = getSubName(cid, target) == "Shiny Onix" and 45 or 45  --alterado v1.6.1
     
    local function doQuake(cid)
    if not isCreature(cid) then return false end
       doMoveInArea2(cid, eff, ee, GROUNDDAMAGE, min, max, spell)
    end
    
    times = {500, 600, 1500, 1000, 2500, 0, 0}
    for i = 1, #times do                   --alterado v1.4
        addEvent(doQuake, times[i], cid)
    end

elseif spell == "Bulldoze" then

local eff = 284  --alterado v1.6.1
 
local function doQuake(cid)
if not isCreature(cid) then return false end
   doMoveInArea2(cid, eff, ee, GROUNDDAMAGE, min, max, spell)
end

times = {0, 500, 1000, 1500}
for i = 1, #times do                   --alterado v1.4
    addEvent(doQuake, times[i], cid)
end

elseif spell == "Intubate" then

local eff = 193  --alterado v1.6.1
 
local function doQuake(cid)
if not isCreature(cid) then return false end
   doMoveInArea2(cid, eff, ee, GROUNDDAMAGE, min, max, spell)
end

times = {500, 1000, 1500, 2000, 2500, 0, 0}

for i = 1, #times do                   --alterado v1.4
    addEvent(doQuake, times[i], cid)
end

elseif spell == "Seaquake" then

local eff = getSubName(cid, target) == "Shiny Milotic" and 246 or 246  --alterado v1.6.1
 
local function doQuake(cid)
if not isCreature(cid) then return false end
   doMoveInArea2(cid, eff, ee, GROUNDDAMAGE, min, max, spell)
end

times = {500, 1000, 1500, 2000, 0, 0, 0}
for i = 1, #times do                   --alterado v1.4
    addEvent(doQuake, times[i], cid)
end

elseif spell == "Light Quakes" then

local eff = getSubName(cid, target) == "Shinys" and 261 or 261  --alterado v1.6.1
 
local function doQuake(cid)
if not isCreature(cid) then return false end
   doMoveInArea2(cid, eff, ee, GROUNDDAMAGE, min, max, spell)
end

times = {500, 1000, 1500, 1000, 0, 0, 0}
for i = 1, #times do                   --alterado v1.4
    addEvent(doQuake, times[i], cid)
end

	
	
elseif spell == "Stomp" then
    
    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.check = 0
    ret.eff = 34
    ret.spell = spell
       
       
    doMoveInArea2(cid, 102, stomp, GROUNDDAMAGE, min, max, spell, ret)
       
elseif spell == "Toxic Spikes" then
       
       local function doToxic(cid, target)
       if not isCreature(cid) or not isCreature(target) then return true end  --alterado v1.7
          doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 15)
          doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 114) --alterado v1.7
       end

	   doToxic(cid, target)
       doToxic(cid, target)
       
elseif spell == "Horn Drill" then
       
       local function doHorn(cid, target)
       if not isCreature(cid) or not isCreature(target) then return true end   --alterado v1.7
          doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 25)
          doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 3)  --alterado v1.7
       end

       doHorn(cid, target)
       doHorn(cid, target)
       
elseif spell == "Doubleslap" then
       
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 148)
    
elseif spell == "Lovely Kiss" then 
   
	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 16)
	
	local ret = {}
    ret.id = target
    ret.cd = 9
    ret.check = getPlayerStorageValue(target, conds["Stun"])
    ret.eff = 147
    ret.spell = spell
      
    
    doMoveDano2(cid, target, NORMALDAMAGE, min, max, ret, spell)
    
elseif spell == "Sing" then

doMoveInArea2(cid, 22, selfArea1, NORMALDAMAGE, min, max, spell, ret) 
    
elseif spell == "Multislap" then

       doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 3)
       
elseif spell == "Metronome" then

local spells = {"Shadow Storm", "Electric Storm", "Magma Storm", "Blizzard", "Leaf Storm", "Hydropump", "Falling Rocks"}

    local random = math.random(1, #spells)

	local randommove = spells[random]
	local pos = getThingPosWithDebug(cid)
	pos.y = pos.y - 1

	doSendMagicEffect(pos, 161)
	
	local function doMetronome(cid, skill)
	if not isCreature(cid) then return true end
       docastspell(cid, skill)
    end
    
    doMetronome(cid, randommove)
	
elseif spell == "Smeargle Random" then

local spells = {"Shadow Storm", "Electric Storm", "Magma Storm", "Blizzard", "Leaf Storm", "Hydropump", "Falling Rocks", "Earthquake", "Stomp", "Dazzling Gleam", "Leaf Storm", "Selfdestruct", "Blizzard", "Shadow Storm", "Surf", "Inferno", "Fissure", "Last Resort", "Electro Field", "Petal Tornado", "Flame Wheel"}


    local random = math.random(1, #spells)

	local randommove = spells[random]
	local pos = getThingPosWithDebug(cid)
	pos.y = pos.y - 1

	doSendMagicEffect(pos, 161)
	
	local function doMetronome(cid, skill)
	if not isCreature(cid) then return true end
       docastspell(cid, skill)
    end
    
    doMetronome(cid, randommove)
    
elseif spell == "Focus" or spell == "Charge" or spell == "Swords Dance" then
                                                    --alterado v1.4
       if spell == "Charge" then
          doSendAnimatedText(getThingPosWithDebug(cid), "CHARGE", 168)
          doSendMagicEffect(getThingPosWithDebug(cid), 177)
       elseif spell == "Swords Dance" then
           doSendMagicEffect(getThingPosWithDebug(cid), 132) 
       else
           doSendAnimatedText(getThingPosWithDebug(cid), "FOCUS", 144)
           doSendMagicEffect(getThingPosWithDebug(cid), 132)
		   setPlayerStorageValue(getCreatureMaster(cid), 151142, 3)
       end
       setPlayerStorageValue(cid, 253, 1)

    
elseif spell == "Hyper Voice" then

    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.check = 0
    ret.eff = 22
    ret.spell = spell
       
       
    doMoveInArea2(cid, 22, tw1, NORMALDAMAGE, min, max, spell, ret)

elseif spell == "Restore" or spell == "Selfheal" or spell == "Rest" then
	
	local min = (getCreatureMaxHealth(cid) * math.random(20,25)) / 100
	local max = (getCreatureMaxHealth(cid) * math.random(50,75)) / 100
	
	local function doHealArea(cid, min, max)
    local amount = math.random(min, max)
    if (getCreatureHealth(cid) + amount) >= getCreatureMaxHealth(cid) then
        amount = -(getCreatureHealth(cid)-getCreatureMaxHealth(cid))
    end

    if getCreatureHealth(cid) ~= getCreatureMaxHealth(cid) then
       doSendAnimatedText(getThingPosWithDebug(cid), "+"..amount.."", 65)
       doCreatureAddHealth(cid, amount)
    else
        doSendAnimatedText(getThingPosWithDebug(cid), "VIDA CHEIA", 65)
    end
    end
    
	doSendMagicEffect(getThingPosWithDebug(cid), 132)
    doHealArea(cid, min, max)
	
elseif spell == "Wish" then
	
	local function doHealArea(cid, minimo, maximo)
    local amount = math.random(minimo, maximo)
    if (getCreatureHealth(cid) + amount) >= getCreatureMaxHealth(cid) then
        amount = -(getCreatureHealth(cid)-getCreatureMaxHealth(cid))
    end
    if getCreatureHealth(cid) ~= getCreatureMaxHealth(cid) then
       doCreatureAddHealth(cid, amount)
       doSendAnimatedText(getThingPosWithDebug(cid), "+"..amount.."", 65)
    else
        doSendAnimatedText(getThingPosWithDebug(cid), "VIDA CHEIA", 65)
    end
    end

	local function checkHeal(alejadinho)
    if not isPlayer(alejadinho) then return true end
	if #getCreatureSummons(alejadinho) == 1 then
		 doHealArea(getCreatureSummons(alejadinho)[1], ((getCreatureMaxHealth(getCreatureSummons(alejadinho)[1]) * math.random(1,25)) / 100), ((getCreatureMaxHealth(getCreatureSummons(alejadinho)[1]) * math.random(30,50)) / 100))
		 doSendMagicEffect(getThingPosWithDebug(cid), 132)
		 end
    end
    
    doSendMagicEffect(getThingPos(cid), 21)
	addEvent(checkHeal, 3500, getCreatureMaster(cid))
elseif spell == "Polish Rock" then
	
	local min = (getCreatureMaxHealth(cid) * math.random(20,25)) / 100
	local max = (getCreatureMaxHealth(cid) * math.random(50,75)) / 100
	
	local function doHealArea(cid, min, max)
    local amount = math.random(min, max)
    if (getCreatureHealth(cid) + amount) >= getCreatureMaxHealth(cid) then
        amount = -(getCreatureHealth(cid)-getCreatureMaxHealth(cid))
    end
    if getCreatureHealth(cid) ~= getCreatureMaxHealth(cid) then
       doCreatureAddHealth(cid, amount)
       doSendAnimatedText(getThingPosWithDebug(cid), "+"..amount.."", 65)
    else
        doSendAnimatedText(getThingPosWithDebug(cid), "VIDA CHEIA", 65)
    end
    end
    
	doSendMagicEffect(getThingPosWithDebug(cid), 157)
    doHealArea(cid, min, max)
    
	
elseif spell == "Healarea" then
	
	local min = (getCreatureMaxHealth(cid) * math.random(20,25)) / 100
	local max = (getCreatureMaxHealth(cid) * math.random(50,75)) / 100
    
    local function doHealArea(cid, minimo, maximo)
    local amount = math.random(minimo, maximo)
    if (getCreatureHealth(cid) + amount) >= getCreatureMaxHealth(cid) then
        amount = -(getCreatureHealth(cid)-getCreatureMaxHealth(cid))
    end
    if getCreatureHealth(cid) ~= getCreatureMaxHealth(cid) then
       doCreatureAddHealth(cid, amount)
       doSendAnimatedText(getThingPosWithDebug(cid), "+"..amount.."", 65)
    end
    end
    
    local pos = getPosfromArea(cid, heal)
    local n = 0
    doHealArea(cid, min, max)
    
    while n < #pos do
    n = n+1
    thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}
    local pid = getThingFromPosWithProtect(thing)
    
    doSendMagicEffect(pos[n], 12)
	
	if isPlayer(pid) then
		if isSummon(cid) then
		if getCreatureMaster(cid) == pid then
		doHealArea(pid, min, max)
		end
		end
		end
    if isCreature(pid) then
       if isSummon(cid) and (isSummon(pid) or isPlayer(pid)) then
          if canAttackOther(cid, pid) == "Cant" then
             doHealArea(pid, min, max)
          end 
       elseif ehMonstro(cid) and ehMonstro(pid) then
          doHealArea(pid, min, max)
       end
    end 
    end
	
elseif spell == "Toxic1" then

  doMoveInArea2(cid, 113, reto5, POISONDAMAGE, min, max, spell)
  
       
elseif spell == "Absorb" then
    if not isCreature(target) then
        return true
    end

	local life = math.random(1, 50)
    local health = math.random(1, 70)
    if isCreature(target) then
        life = getCreatureHealth(cid)
        health = getCreatureHealth(target)
    end

    if isCreature(target) then
	    doAreaCombatHealth(cid, GRASSDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 14)
    end
    
	local newlife = tonumber(life) - health

	doSendMagicEffect(getThingPosWithDebug(cid), 14)
	if newlife >= 1 then
	   doCreatureAddHealth(cid, newlife)
       doSendAnimatedText(getThingPosWithDebug(cid), "+"..newlife.."", 32)
	end  
	
elseif spell == "Poison Bomb" then

    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 14)
    doDanoWithProtectWithDelay(cid, target, POISONDAMAGE, min, max, 20, bombWee2)

elseif spell == "Poison Gas" then 

local dmg = isSummon(cid) and getMasterLevel(cid)+getPokemonBoost(cid) or getPokemonLevel(cid)

local ret = {id = 0, cd = 13, eff = 334, check = 0, spell = spell, cond = "Miss"} 
  
local function gas(cid)
    if not isCreature(cid) then return true end
    doMoveInArea2(cid, 334, poisong, POISONDAMAGE, -min, -max, spell, ret)
end
    	
times = {0, 500, 1000, 1500, 2300, 2800, 3300}

for i = 1, #times do
    addEvent(gas, times[i], cid)                            
end
	
elseif spell == "X-Scissor" then

local a = getThingPosWithDebug(cid)
 
local X = {
{{x = a.x+1, y = a.y, z = a.z}, 16}, --norte
{{x = a.x+2, y = a.y+1, z = a.z}, 221}, --leste
{{x = a.x+1, y = a.y+2, z = a.z}, 223}, --sul
{{x = a.x, y = a.y+1, z = a.z}, 243}, --oeste
}

local pos = X[mydir+1]

for b = 1, 3 do
    addEvent(doSendMagicEffect, b * 70, pos[1], pos[2])
end
	
doMoveInArea2(cid, 2, xScissor, BUGDAMAGE, min, max, spell)
	
elseif spell == "Psychic" then
                                    
	doDanoWithProtect(cid, psyDmg, getThingPosWithDebug(cid), selfArea2, min, max, 133)


elseif spell == "Water Spout" then
                                    
	doDanoWithProtect(cid, WATERDAMAGE, getThingPosWithDebug(cid), wtt, min, max, 68) 	
	
elseif spell == "Pay Day" then

        --alterado v1.7
		local function doThunderFall(cid, frompos, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		local pos = getThingPosWithDebug(target)
		local ry = math.abs(frompos.y - pos.y)
		doSendDistanceShoot(frompos, getThingPosWithDebug(target), 39)
		doDanoInTarget(cid, target, NORMALDAMAGE, min, max, 28)  --alterado v1.7
		end

		local function doThunderUp(cid, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		local pos = getThingPosWithDebug(target)
		local mps = getThingPosWithDebug(cid)
		local xrg = math.floor((pos.x - mps.x) / 2)
		local topos = mps
		topos.x = topos.x + xrg
		local rd =  7
		topos.y = topos.y - rd
		doSendDistanceShoot(getThingPosWithDebug(cid), topos, 39)
		doThunderFall(cid, topos, target)
		end		
    
        doThunderUp(cid, target)
        doThunderUp(cid, target)
    
elseif spell == "Psywave" then

doMoveInArea2(cid, 133, db1, psyDmg, min, max, spell)      

elseif spell == "Triple Kick" or spell == "Triple Kick Lee" then

	doDanoWithProtect(cid, FIGHTINGDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 110)
	
elseif spell == "Karate Chop" then
    
    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
	doDanoInTargetWithDelay(cid, target, FIGHTINGDAMAGE, -min, -max, 113)  --alterado v1.7
	
elseif spell == "Ground Chop" then

local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area, area2, eff)  --alterado v1.6
if isCreature(cid) then
   if not isSightClear(p, area, false) then return true end
   doAreaCombatHealth(cid, FIGHTINGDAMAGE, area, 0, 0, 0, eff)    
   doAreaCombatHealth(cid, FIGHTINGDAMAGE, area2, whirl3, -min, -max, 255)  --alterado v1.6   
end
end

for a = 0, 4 do

local t = {
[0] = {99, {x=p.x+1, y=p.y-(a+1), z=p.z}, {x=p.x, y=p.y-(a+1), z=p.z}},           --alterado v1.6
[1] = {99, {x=p.x+(a+2), y=p.y+1, z=p.z}, {x=p.x+(a+1), y=p.y, z=p.z}},
[2] = {99, {x=p.x+1, y=p.y+(a+2), z=p.z}, {x=p.x, y=p.y+(a+1), z=p.z}},
[3] = {99, {x=p.x-(a+1), y=p.y+1, z=p.z}, {x=p.x-(a+1), y=p.y, z=p.z}}
}   
addEvent(sendAtk, 270*a, cid, t[d][2], t[d][3], t[d][1]) --alterado v1.6
end    

elseif spell == "Imbued in Darkness" then

local pos = getThingPosWithDebug(cid)
local areas = {rock1, rock2, rock3, rock4, rock5, rock4, rock3, rock2, rock1}
local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 283
ret.check = 0
ret.spell = spell

local effs = {283, 286}
for i = 1, #areas do
    for it = 1, #effs do
        addEvent(doMoveInArea2, i*120, cid, effs[it], areas[i], NORMALDAMAGE, min, max, spell, ret)
    end
end

elseif spell == "Ultra Sonic" then

    local pos = getThingPosWithDebug(cid)
    local areas = {rock1, rock2, rock3, rock4, rock5, rock4, rock3, rock2, rock1}
    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.eff = 222
    ret.check = 0
    ret.spell = spell
    
    local effs = {222, 222, 211, 211}
    for i = 1, #areas do
        for it = 1, #effs do
            addEvent(doMoveInArea2, i*120, cid, effs[it], areas[i], NORMALDAMAGE, min, max, spell, ret)
        end
    end

elseif spell == "Electric Volts" then

    local pos = getThingPosWithDebug(cid)
    local areas = {rock1, rock2, rock3, rock4, rock5, rock4, rock3, rock2, rock1}
    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.eff = 329
    ret.check = 0
    ret.spell = spell
    
    local effs = {329, 329}
    for i = 1, #areas do
        for it = 1, #effs do
            addEvent(doMoveInArea2, i*120, cid, effs[it], areas[i], NORMALDAMAGE, min, max, spell, ret)
        end
    end

elseif spell == "Water Pulse" then

    local pos = getThingPosWithDebug(cid)
    local areas = {rock1, rock2, rock3}
    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.eff = 53
    ret.check = 0
    ret.spell = spell
    
    local effs = {53, 53}
    for i = 1, #areas do
        for it = 1, #effs do
            addEvent(doMoveInArea2, i*120, cid, effs[it], areas[i], WATERDAMAGE, min, max, spell, ret)
        end
    end

elseif spell == "Surf" then

    local pos = getThingPosWithDebug(cid)
    local areas = {rock1, rock2, rock3, rock4, rock5, rock4, rock3, rock2, rock1}
    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.eff = 246
    ret.check = 0
    ret.spell = spell
    
    local effs = {246, 246}
    for i = 1, #areas do
        for it = 1, #effs do
            addEvent(doMoveInArea2, i*120, cid, effs[it], areas[i], NORMALDAMAGE, min, max, spell, ret)
        end
    end
    
elseif spell == "Poison Bubbles" then

    local pos = getThingPosWithDebug(cid)
    local areas = {rock1, rock2, rock3, rock4, rock5, rock4, rock3, rock2, rock1}
    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.eff = 360
    ret.check = 0
    ret.spell = spell
    
    local effs = {360, 360}
    for i = 1, #areas do
        for it = 1, #effs do
            addEvent(doMoveInArea2, i*120, cid, effs[it], areas[i], NORMALDAMAGE, min, max, spell, ret)
        end
    end

elseif spell == "Leaf Power" then

    local pos = getThingPosWithDebug(cid)
    local areas = {rock1, rock2, rock3, rock4, rock5, rock4, rock3, rock2, rock1}
    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.eff = 301
    ret.check = 0
    ret.spell = spell
    
    local effs = {301, 301}
    for i = 1, #areas do
        for it = 1, #effs do
            addEvent(doMoveInArea2, i*120, cid, effs[it], areas[i], NORMALDAMAGE, min, max, spell, ret)
        end
    end

elseif spell == "Infinite Love" then

    local pos = getThingPosWithDebug(cid)
    local areas = {rock1, rock2, rock3, rock4, rock5, rock4, rock3, rock2, rock1}
    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.eff = 242
    ret.check = 0
    ret.spell = spell
    
    local effs = {180, 147}
    for i = 1, #areas do
        for it = 1, #effs do
            addEvent(doMoveInArea2, i*120, cid, effs[it], areas[i], NORMALDAMAGE, min, max, spell, ret)
        end
    end
    
elseif spell == "Aura Sphere" then

local pos = getThingPosWithDebug(cid)
local areas = {rock1, rock2, rock3, rock4, rock5}

for i = 1, #areas do
    addEvent(doMoveInArea2, i*120, cid, 247, areas[i], NORMALDAMAGE, min, max, spell)
end

elseif spell == "Spikes Absolute" then

local pos = getThingPosWithDebug(cid)
local areas = {rock1, rock2, rock3, rock4, rock5}

for i = 1, #areas do
    addEvent(doMoveInArea2, i*120, cid, 317, areas[i], NORMALDAMAGE, min, max, spell)
end

elseif spell == "King of Darkness" then

local pos = getThingPosWithDebug(cid)
local areas = {rock1, rock2, rock3, rock4, rock5}

for i = 1, #areas do
    addEvent(doMoveInArea2, i*120, cid, 336, areas[i], NORMALDAMAGE, min, max, spell)
end

elseif spell == "Fury Thunder" then

local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area, area2, eff)  --alterado v1.6
if isCreature(cid) then
   if not isSightClear(p, area, false) then return true end
   doAreaCombatHealth(cid, FIGHTINGDAMAGE, area, 0, 0, 0, eff)    
   doAreaCombatHealth(cid, FIGHTINGDAMAGE, area2, whirl3, -min, -max, 255)  --alterado v1.6   
end
end

for a = 0, 4 do

local t = {
[0] = {254, {x=p.x+1, y=p.y-(a+1), z=p.z}, {x=p.x, y=p.y-(a+1), z=p.z}},           --alterado v1.6
[1] = {254, {x=p.x+(a+1), y=p.y+1, z=p.z}, {x=p.x+(a+1), y=p.y, z=p.z}},
[2] = {254, {x=p.x+1, y=p.y+(a+1), z=p.z}, {x=p.x, y=p.y+(a+1), z=p.z}},
[3] = {254, {x=p.x-(a+1), y=p.y+1, z=p.z}, {x=p.x-(a+1), y=p.y, z=p.z}}
}   
addEvent(sendAtk, 270*a, cid, t[d][2], t[d][3], t[d][1]) --alterado v1.6
end 

elseif spell == "Soccer Aura" then

local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area, area2, eff)  --alterado v1.6
if isCreature(cid) then
   if not isSightClear(p, area, false) then return true end
   doAreaCombatHealth(cid, FIGHTINGDAMAGE, area, 0, 0, 0, eff)    
   doAreaCombatHealth(cid, FIGHTINGDAMAGE, area2, whirl3, -min, -max, 255)  --alterado v1.6   
end
end

for a = 0, 4 do

local t = {
[0] = {251, {x=p.x+1, y=p.y-(a+1), z=p.z}, {x=p.x, y=p.y-(a+1), z=p.z}},           --alterado v1.6
[1] = {251, {x=p.x+(a+1), y=p.y+1, z=p.z}, {x=p.x+(a+1), y=p.y, z=p.z}},
[2] = {251, {x=p.x+1, y=p.y+(a+1), z=p.z}, {x=p.x, y=p.y+(a+1), z=p.z}},
[3] = {251, {x=p.x-(a+1), y=p.y+1, z=p.z}, {x=p.x-(a+1), y=p.y, z=p.z}}
}   
addEvent(sendAtk, 270*a, cid, t[d][2], t[d][3], t[d][1]) --alterado v1.6
end 
      
elseif spell == "Mega Punch" then

	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
	doDanoInTargetWithDelay(cid, target, FIGHTINGDAMAGE, -min, -max, 112)  --alterado v1.7
    
elseif spell == "Tri Flames" then

       doMoveInArea2(cid, 6, triflames, FIREDAMAGE, min, max, spell)
       
elseif spell == "War Dog" then

   local ret = {}
   ret.id = cid
   ret.cd = 15
   ret.eff = 28
   ret.check = 0
   ret.buff = spell
   ret.first = true
   
   doCondition2(ret)
   
elseif spell == "WarDog" then

   local ret = {}
   ret.id = cid
   ret.cd = 15
   ret.eff = 28
   ret.check = 0
   ret.buff = spell
   ret.first = true
   
   doCondition2(ret)
            
elseif spell == "Hypnosis" then
    if not isCreature(target) then return true end

    local ret = {}
    ret.id = target
    ret.cd = math.random(6, 9)
    ret.check = getPlayerStorageValue(target, conds["Sleep"])
    ret.first = true                                                --alterado v1.6
    ret.cond = "Sleep"

   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 24)
   doSendMagicEffect(getThingPos(target), 311)
   doMoveDano2(cid, target, PSYCHICDAMAGE, 0, 0, ret, spell)

elseif spell == "Dizzy Punch" then

   local rounds = getMasterLevel(cid) / 12
   rounds = rounds + 2
   
   local ret = {}
   ret.id = target
   ret.check = getPlayerStorageValue(target, conds["Confusion"])
   ret.cd = rounds
   
   
   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 26)
   doDanoWithProtect(cid, FIGHTINGDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 112)	
   doMoveDano2(cid, target, NORMALDAMAGE, 0, 0, ret, spell)

elseif spell == "Ice Punch" then
                   
local ret = {}
ret.id = target
ret.cd = 9
ret.eff = 43
ret.check = getPlayerStorageValue(target, conds["Slow"])
ret.first = true
ret.cond = "Slow"

    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 28)
    doSendMagicEffect(getThingPosWithDebug(target), 112)
    doDanoWithProtectWithDelay(cid, target, ICEDAMAGE, min, max, 43)
    doMoveDano2(cid, target, ICEDAMAGE, 0, 0, ret, spell)
	
elseif spell == "Ice Beam" then

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local p = getThingPosWithDebug(cid)
local t = {
[0] = {97, {x=p.x+1, y=p.y-1, z=p.z}},
[1] = {96, {x=p.x+6, y=p.y+1, z=p.z}}, 
[2] = {97, {x=p.x+1, y=p.y+6, z=p.z}},
[3] = {96, {x=p.x-1, y=p.y+1, z=p.z}},
}

local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 43
ret.check = 0
ret.first = true
ret.cond = "Slow"

doMoveInArea2(cid, 0, triplo6, ICEDAMAGE, min, max, spell, ret)
doSendMagicEffect(t[a][2], t[a][1])
	
	
elseif spell == "Psy Pulse" or spell == "Cyber Pulse" or spell == "Dark Pulse" then

damage = skill == "Dark Pulse" and DARKDAMAGE or psyDmg

local function doPulse(cid, eff)
if not isCreature(cid) then return true end
   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 3)
   doDanoInTargetWithDelay(cid, target, damage, min, max, eff)      --alterado v1.7
end

   if spell == "Cyber Pulse" then
      eff = 11
   elseif spell == "Dark Pulse" then
      eff = 47  --efeito n eh esse mas... ;p
   else
      eff = 133
   end 
   
   doPulse(cid, eff)
   doPulse(cid, eff)
    
elseif spell == "Moonblast" then

damage = skill == "Dark Pulse" and DARKDAMAGE or psyDmg

local function doPulse(cid, eff)
if not isCreature(cid) then return true end
   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 3)
   doDanoInTargetWithDelay(cid, target, damage, min, max, eff)      --alterado v1.7
end

   if spell == "Moonblast" then
      eff = 242
   end 
   
   doPulse(cid, eff)
   doPulse(cid, eff)
   
elseif spell == "Psyusion" then

       local rounds = math.random(4, 7)
       rounds = rounds + math.floor(getMasterLevel(cid) / 35)
       local eff = {136, 133, 136, 133, 137}
       local area = {psy1, psy2, psy3, psy4, psy5}

       local ret = {}
       ret.id = 0
       ret.check = 0
       ret.cd = rounds
       

       for i = 1, #area do
           addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], psyDmg, min, max, spell, ret)
       end
       
elseif spell == "Triple Punch" then

	doDanoWithProtect(cid, FIGHTINGDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 110)
	
elseif spell == "Fist Machine" then

	local mpos = getThingPosWithDebug(cid)
	local b = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
	local effect = 0
	local xvar = 0
	local yvar = 0

	if b == SOUTH then
		effect = 218
		yvar = 2
	elseif b == NORTH then
		effect = 217
	elseif b == WEST then
		effect = 216
	elseif b == EAST then
		effect = 215
		xvar = 2
	end

	mpos.x = mpos.x + xvar
	mpos.y = mpos.y + yvar         

	doSendMagicEffect(mpos, effect)
	doMoveInArea2(cid, 0, machine, FIGHTINGDAMAGE, min, max, spell)
	
elseif spell == "Destroyer Hand" then

       doMoveInAreaMulti(cid, 26, 111, bullet, bulletDano, FIGHTINGDAMAGE, min, max)
       
elseif spell == "Rock Throw" then

local effD = getSubName(cid, target) == "Shiny Onix" and 0 or 11
local eff = getSubName(cid, target) == "Shiny Onix" and 176 or 44  --alterado v1.6.1

	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), effD)
	doDanoInTargetWithDelay(cid, target, ROCKDAMAGE, min, max, eff) --alterado v1.7
		
elseif spell == "Dragon Spit" then                   

local function throw(cid, target)
if not isCreature(cid) or not isCreature(target) then return false end
	doDanoInTargetWithDelay(cid, target, DRAGONDAMAGE, min, max, 35)  
end

throw(cid, target)	
throw(cid, target)	
	
elseif spell == "Falling Rocks" then

local effD = getSubName(cid, target) == "Shiny Onix" and 0 or 11
local eff = getSubName(cid, target) == "Shiny Onix" and 176 or 44  --alterado v1.6.1

local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------

local function doFall(cid)
for rocks = 1, 62 do
    addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
end
end

for up = 1, 10 do                                                            
    addEvent(upEffect, up*75, cid, effD)
end

doFall(cid)
doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Falling Fire" then

    local effD = getSubName(cid, target) == "Shiny Hitmonchan" and 57 or 57 -- 13 � o efeito da "pedrinha" no caso � "missile"
    local eff = getSubName(cid, target) == "Shiny Hitmonchan" and 35 or 35 -- 100 � o efeito "Meteor" - no caso � "effect"
    
    local master = isSummon(cid) and getCreatureMaster(cid) or cid
    ------------
    
    local function doFall(cid)
    for rocks = 1, 62 do
        addEvent(fall, rocks*70, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*70, cid, master, ROCKDAMAGE, effD, 35)
        addEvent(fall, rocks*70, cid, master, ROCKDAMAGE, effD, 35)
    end
    end
    
    for up = 1, 10 do                                                            
        addEvent(upEffect, up*40, cid, effD)
    end
    
    doFall(cid)
    doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Princess Attack" then

    local effD = getSubName(cid, target) == "Shiny Hitmonchan" and 57 or 57 -- 13 � o efeito da "pedrinha" no caso � "missile"
    local eff = getSubName(cid, target) == "Shiny Hitmonchan" and 848 or 848 -- 848 � o efeito "Meteor" - no caso � "effect"
    
    local master = isSummon(cid) and getCreatureMaster(cid) or cid
    ------------
    
    local function doFall(cid)
    for rocks = 1, 62 do
        addEvent(fall, rocks*70, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*70, cid, master, ROCKDAMAGE, effD, 848)
        addEvent(fall, rocks*70, cid, master, ROCKDAMAGE, effD, 848)
    end
    end
    
    for up = 1, 10 do                                                            
        addEvent(upEffect, up*40, cid, effD)
    end

    doFall(cid)
    doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Selfdestruct" then
                                         
		local function death(cid)
			if isCreature(cid) then
			   if pokeHaveReflect(cid) then return true end    --alterado v1.6
			   doCreatureAddHealth(cid, -getCreatureMaxHealth(cid))
			end
		end

        doMoveInArea2(cid, 5, selfArea1, NORMALDAMAGE, min, max, spell)    --alterado v1.6
        death(cid)
		
elseif spell == "Crusher Stomp" then
       
local pL = getThingPosWithDebug(cid)
pL.x = pL.x+5
pL.y = pL.y+1 
-----------------
local pO = getThingPosWithDebug(cid)
pO.x = pO.x-3
pO.y = pO.y+1 
------------------
local pN = getThingPosWithDebug(cid)
pN.x = pN.x+1
pN.y = pN.y+5 
-----------------
local pS = getThingPosWithDebug(cid)
pS.x = pS.x+1
pS.y = pS.y-3 

local po = {pL, pO, pN, pS}
local po2 = {
{x = pL.x, y = pL.y-1, z = pL.z},
{x = pO.x, y = pO.y-1, z = pO.z},
{x = pN.x-1, y = pN.y, z = pN.z},
{x = pS.x-1, y = pS.y, z = pS.z},
}

local ret = {}
ret.id = 0
ret.cd = 9
ret.check = 0
ret.eff = 34
ret.spell = spell


for i = 1, 4 do
    doSendMagicEffect(po[i], 127)
    doAreaCombatHealth(cid, GROUNDDAMAGE, po2[i], crusher, -min, -max, 255)
end
doMoveInArea2(cid, 118, stomp, GROUNDDAMAGE, min, max, spell, ret)  
       
elseif spell == "Sonicboom" then

local function doBoom(cid)
if not isCreature(cid) then return true end
   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 33)
   doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 3)   --alterado v1.7
end

doBoom(cid)
   
elseif spell == "Stickmerang" then   

   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 34)
   doDanoInTargetWithDelay(cid, target, FLYINGDAMAGE, min, max, 212)  --alterado v1.7

elseif spell == "Stickslash" then

    local function sendStickEff(cid, dir)
    if not isCreature(cid) then return true end
       doAreaCombatHealth(cid, FLYINGDAMAGE, getPosByDir(getThingPosWithDebug(cid), dir), 0, -min, -max, 212)
	end

	local function doStick(cid)
	if not isCreature(cid) then return true end
	local t = {
	      [1] = SOUTHWEST,
	      [2] = SOUTH,
	      [3] = SOUTHEAST,
	      [4] = EAST,
	      [5] = NORTHEAST,
	      [6] = NORTH,
	      [7] = NORTHWEST,
	      [8] = WEST,
	      [9] = SOUTHWEST,
		}
		for a = 1, 9 do
            sendStickEff(cid, t[a])
		end
	end

	doStick(cid, false, cid)
    
elseif spell == "Stick Throw" then

   stopNow(cid, 2000)
   doMoveInArea2(cid, 212, reto4, FLYINGDAMAGE, min, max, spell)
       
elseif spell == "Pluck" then

   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
   doDanoInTargetWithDelay(cid, target, FLYINGDAMAGE, min, max, 111)  --alterado v1.7

elseif spell == "Tri-Attack" then

   --alterado v1.7
   setPlayerStorageValue(cid, 3644587, 1)
   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 42)  --alterado v1.6
   for i = 0, 2 do
        doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 238)      --alterado v1.7
   end 
    
elseif spell == "Fury Attack" then

    --alterado v1.7
    setPlayerStorageValue(cid, 3644587, 1)
    for i = 0, 2 do
        doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 110)    --alterado v1.7
    end  
   
elseif spell == "Ice Shards" then

    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 28)
    doDanoInTargetWithDelay(cid, target, ICEDAMAGE, min, max, 43)  --alterado v1.7
    
elseif spell == "Icy Wind" then                   

local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 43
ret.check = 0
ret.first = true
ret.cond = "Slow"
	
  doMoveInArea2(cid, 17, tw1, ICEDAMAGE, min, max, spell, ret)
  
elseif spell == "Aurora Beam" then

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local p = getThingPosWithDebug(cid)
local t = {
[0] = {186, {x=p.x+1, y=p.y-1, z=p.z}},
[1] = {57, {x=p.x+6, y=p.y+1, z=p.z}},   --alterado v1.6
[2] = {186, {x=p.x+1, y=p.y+6, z=p.z}},
[3] = {57, {x=p.x-1, y=p.y+1, z=p.z}},  --alterado v1.6
}

local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 43
ret.check = 0
ret.first = true
ret.cond = "Slow"

doMoveInArea2(cid, 0, triplo6, ICEDAMAGE, min, max, spell, ret)
doSendMagicEffect(t[a][2], t[a][1])
	
elseif spell == "Sludge" then 

        --alterado v1.7
		local function doSludgeFall(cid, frompos, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		local pos = getThingPosWithDebug(target)
		local ry = math.abs(frompos.y - pos.y)
		doSendDistanceShoot(frompos, getThingPosWithDebug(target), 6)
		doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 116) --alterado v1.7
		end

		local function doSludgeUp(cid, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		local pos = getThingPosWithDebug(target)
		local mps = getThingPosWithDebug(cid)
		local xrg = math.floor((pos.x - mps.x) / 2)
		local topos = mps
		topos.x = topos.x + xrg
		local rd =  7
		topos.y = topos.y - rd
		doSendDistanceShoot(getThingPosWithDebug(cid), topos, 6)
		doSludgeFall(cid, topos, target)
		end		

	for thnds = 1, 2 do
		doSludgeUp(cid, target)
	end                                               --alterado v1.5

elseif spell == "Mud Bomb" then

   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 6)  --alterado v1.8
   doDanoWithProtectWithDelay(cid, target, MUDBOMBDAMAGE, min, max, 116, bombWee2)
    
elseif spell == "Mortal Gas" then 

local dmg = isSummon(cid) and getMasterLevel(cid)+getPokemonBoost(cid) or getPokemonLevel(cid)

local ret = {id = 0, cd = 13, eff = 334, check = 0, spell = spell, cond = "Miss"}
local ret2 = {id = 0, cd = 13, check = 0, damage = dmg, cond = "Poison"}                          --rever isso ainda!!
  
	local function gas(cid)
           doMoveInArea2(cid, 334, mortal, POISONDAMAGE, 0, 0, spell, ret)
		   doMoveInArea2(cid, 334, mortal, POISONDAMAGE, min, max, spell)
	end
    	
times = {0, 500, 1000, 1500, 2300, 2800, 3300, 3800, 4600, 5100}

for i = 1, #times do
    addEvent(gas, times[i], cid)                            
end
    
elseif spell == "Rock Drill" or spell == "Megahorn" or spell == "Rock Blast" then

local damage = spell == "Megahorn" and BUGDAMAGE or ROCKDAMAGE
local eff = spell == "Megahorn" and 8 or 44 
local effD = spell == "Rock Blast" and 11 or 25                    
                --cid, effDist, effDano, areaEff, areaDano, element, min, max
doMoveInAreaMulti(cid, effD, eff, bullet, bulletDano, damage, min, max)

elseif spell == "Egg Bomb" then

	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 12)
	doDanoWithProtectWithDelay(cid, target, NORMALDAMAGE, min, max, 5, crusher)
    
elseif spell == "Super Vines" then

    stopNow(cid, 200)           --alterado v1.6
    doCreatureSetLookDir(cid, 2)

	local effect = 0
	local pos = getThingPosWithDebug(cid)
	pos.x = pos.x + 1
	pos.y = pos.y + 1
	
    local effect = getSubName(cid, target) == "Tangela" and 213 or 229  --alterado v1.6.1

	doSendMagicEffect(pos, effect)
	doDanoWithProtect(cid, GRASSDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 0)
    
elseif spell == "Epicenter" then -- biel att

local eff = {2, 151, 102, 157, 151, 157}
local area = {epicenter1, epicenter1, epicenter1, epicenter2, epicenter2}

for i = 1, #area do
    addEvent(doMoveInArea2, i*450, cid, eff[i], area[i], GROUNDDAMAGE, min, max, spell)
end

elseif spell == "Ice Break" then -- biel att

local eff = {2, 179, 179, 179, 179, 179}
local area = {epicenter1, epicenter1, epicenter1, epicenter2, epicenter2}

for i = 1, #area do
    addEvent(doMoveInArea2, i*450, cid, eff[i], area[i], GROUNDDAMAGE, min, max, spell)
end
        
elseif spell == "Ice Crash" then

local eff = {2, 52, 39, 52, 52}
local area = {epicenter1, epicenter1, epicenter1, epicenter2, epicenter2}

for i = 1, #area do
    addEvent(doMoveInArea2, i*20, cid, eff[i], area[i], ICEDAMAGE, min, max, spell)
end
     
	 
elseif spell == "Selfdrain" then

local eff = {2, 255, 255, 255, 255}
local area = {epicenter1, epicenter1, epicenter1, epicenter2, epicenter2}

for i = 1, #area do
    addEvent(doMoveInArea2, i*20, cid, eff[i], area[i], GRASSDAMAGE, min, max, spell)
end

elseif spell == "Bubblebeam" then

local function sendBubbles(cid)
if not isCreature(cid) or not isCreature(target) then return true end
   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 2)
   doDanoInTargetWithDelay(cid, target, WATERDAMAGE, min, max, 25)  --alterado v1.7
end

sendBubbles(cid)
sendBubbles(cid)

elseif spell == "Thunder Attack" then

local eff = {2, 276, 276, 276, 276}
local area = {flames0, wat1, wat2, wat4, wat5}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], WATERDAMAGE, min, max, spell)
end

elseif spell == "Torment" then

local eff = {103, 103, 103, 103, 103}
local area = {psy1, psy2, psy3, psy4, psy5}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], GHOSTDAMAGE, min, max, spell)
end

elseif spell == "Electral Burning" then

local pos = getThingPosWithDebug(cid)
local areas = {hurri1, hurri2, hurri3, hurri4, hurri5, hurri6, hurri7, hurri8, hurri9}
local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 54
ret.check = 0
ret.spell = spell
ret.cond = "Miss"

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, 54, areas[i], ELECTRICDAMAGE, min, max, spell, ret)
end

elseif spell == "Leaf Rage" then

local eff = {2, 105, 105, 105, 105}
local area = {dragondance, dragondance2, dragondance1, dragondance, dragondance2, dragondance1, dragondance, dragondance2}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], GRASSDAMAGE, min, max, spell)
end

elseif spell == "Fire Crash" then

local eff = {270, 270, 270, 270, 270}
local area = {dragondance, dragondance2, dragondance1, dragondance, dragondance2, dragondance1, dragondance, dragondance2}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIREDAMAGE, min, max, spell)
end

elseif spell == "Leaf Crash" then

local eff = {275, 275, 275, 275}
local area = {dragondance2, dragondance1, dragondance, dragondance2, dragondance1, dragondance, dragondance2}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], GRASSDAMAGE, min, max, spell)
end


elseif spell == "Disarming Voice" then

local eff = {265, 265, 265, 265}
local area = {dragondance2, dragondance1, dragondance, dragondance2, dragondance1, dragondance, dragondance2}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], DRAGONDAMAGE, min, max, spell)
end

elseif spell == "Mortal Eyes" then

    local eff = {314, 314, 314, 314}
    local area = {dragondance2, dragondance1, dragondance, dragondance2, dragondance1, dragondance, dragondance2}
    
    for i = 1, #area do
        addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], DARKDAMAGE, min, max, spell)
    end

elseif spell == "Disarming Psychic" then

    local eff = {271, 271, 271, 271}
    local area = {dragondance2, dragondance1, dragondance, dragondance2, dragondance1, dragondance, dragondance2}
    
    for i = 1, #area do
        addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], PSYCHICDAMAGE, min, max, spell)
    end

elseif spell == "Damange Stom" then

local eff = {100}
local area = {dragondance2}

    doMoveInArea2(cid, 2, dragondance, DRAGONDAMAGE, min, max, spell)
    doMoveInArea2(cid, 100, dragondance2, DRAGONDAMAGE, min, max, spell)


elseif spell == "Aero Crash" then

local eff = {2, 42, 42, 42, 42}
local area = {dragondance, dragondance2, dragondance1, dragondance, dragondance2, dragondance1, dragondance, dragondance2}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], GROUNDDAMAGE, min, max, spell)
end

elseif spell == "Wind Rage" then

local eff = {2, 42, 42, 42, 42}
local area = {wind1, wind1, wind2, wind3, wind4}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], DRAGONDAMAGE, min, max, spell)
end

elseif  spell == "Swift" then

local function sendSwift(cid, target)
if not isCreature(cid) or not isCreature(target) then return true end
   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 32)
   doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 3)   --alterado v1.7
end

sendSwift(cid)
sendSwift(Cid)

elseif spell == "Spark" then
       
   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 32)
   doDanoInTargetWithDelay(cid, target, ELECTRICDAMAGE, min, max, 48)    --alterado v1.7
    
elseif spell == "Blizzard" then

    local effD = 28 -- 13 � o efeito da "pedrinha" no caso � "missile"
    local eff = 269 -- 91 � o efeito "Meteor" - no caso � "effect"
    
    local master = isSummon(cid) and getCreatureMaster(cid) or cid
    ------------
    
    local function doFall(cid)
    for rocks = 1, 65 do
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
    end
    end
    
    for up = 1, 10 do                                                            
        addEvent(upEffect, up*75, cid, effD)
    end

    doFall(cid)
    doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)


elseif spell == "Royalty Swords" then

    local master = isSummon(cid) and getCreatureMaster(cid) or cid
    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.eff = 580
    ret.check = 0
    ret.first = true
    ret.cond = "Paralyze"
    
    local function doFall(cid)
    for rocks = 1, 42 do
        addEvent(fall, rocks*35, cid, master, ICEDAMAGE, 28, 580)
    end
    end
    
    for up = 1, 10 do
        addEvent(upEffect, up*75, cid, 28)
    end       
                                      --alterado v1.4
    doFall(cid)
    doMoveInArea2(cid, 0, BigArea2, ICEDAMAGE, min, max, spell, ret)

elseif spell == "Great Love" then

        doMoveInArea2(cid, 180, greatlove, NORMALDAMAGE, min, max, spell)
		
elseif spell == "New World" then

        doMoveInArea2(cid, 11, greatlove, NORMALDAMAGE, min, max, spell)		
		
elseif spell == "Dragon Dance" then

        doMoveInArea2(cid, 249, greatlove, DRAGONDAMAGE, min, max, spell)

elseif spell == "Leaf Dance" then

        doMoveInArea2(cid, 281, greatlove, GRASSDAMAGE, min, max, spell)
		
elseif spell == "TM-1" then

        doMoveInArea2(cid, 267, greatlove, FIREDAMAGE, min, max, spell)

elseif spell == "Fire Punch" then

	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
    doSendMagicEffect(getThingPosWithDebug(target), 112)
    doDanoInTargetWithDelay(cid, target, FIREDAMAGE, min, max, 35) --alterado v1.7
    
elseif spell == "Guillotine" then

doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 146)

elseif spell ==  "Hyper Beam" then  --alterado v1.7 \/

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local p = getThingPosWithDebug(cid)
local t = {
[0] = {149, {x=p.x+1, y=p.y-1, z=p.z}},
[1] = {150, {x=p.x+6, y=p.y+1, z=p.z}},   
[2] = {149, {x=p.x+1, y=p.y+6, z=p.z}},
[3] = {150, {x=p.x-1, y=p.y+1, z=p.z}},  
}

doMoveInArea2(cid, 0, triplo6, NORMALDAMAGE, min, max, spell)
doSendMagicEffect(t[a][2], t[a][1])

elseif spell ==  "Furia do Dragao" then  --alterado v1.7 \/

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local p = getThingPosWithDebug(cid)
local t = {
[0] = {120, {x=p.x+1, y=p.y-1, z=p.z}},
[1] = {121, {x=p.x+6, y=p.y+1, z=p.z}},   
[2] = {122, {x=p.x+1, y=p.y+6, z=p.z}},
[3] = {119, {x=p.x-1, y=p.y+1, z=p.z}},  
}

doMoveInArea2(cid, 0, triplo6, NORMALDAMAGE, min, max, spell)
doSendMagicEffect(t[a][2], t[a][1])
    
elseif spell == "Thrash" then

                --cid, effDist, effDano, areaEff, areaDano, element, min, max
doMoveInAreaMulti(cid, 0, 157, bullet, bulletDano, NORMALDAMAGE, min, max) 

elseif spell == "Splash" or tonumber(spell) == 7 then

	doAreaCombatHealth(cid, WATERDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 155)
	doSendMagicEffect(getThingPosWithDebug(cid), 53)
    
elseif spell == "Dragon Breath" then     

    doMoveInArea2(cid, 143, db1, DRAGONDAMAGE, min, max, spell) 
       
elseif spell == "Muddy Water" then

local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 34
ret.check = 0
ret.spell = spell

   doMoveInArea2(cid, 116, muddy, WATERDAMAGE, min, max, spell, ret)
       
       
elseif spell == "Venom Motion" then

local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 34
ret.check = 0
ret.spell = spell

   doMoveInArea2(cid, 114, muddy, POISONDAMAGE, min, max, spell, ret)
       
elseif spell == "Thunder Fang" then

	doSendMagicEffect(getThingPosWithDebug(target), 146)
    doDanoInTargetWithDelay(cid, target, ELECTRICDAMAGE, min, max, 48)  --alterado v1.7
    
elseif spell == "Zap Cannon" then

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local p = getThingPosWithDebug(cid)
local t = {
[0] = {73, {x=p.x, y=p.y-1, z=p.z}},
[1] = {74, {x=p.x+6, y=p.y, z=p.z}},      --alterado v1.8
[2] = {75, {x=p.x, y=p.y+6, z=p.z}},
[3] = {76, {x=p.x-1, y=p.y, z=p.z}},
}

doMoveInArea2(cid, 0, triplo6, ELECTRICDAMAGE, min, max, spell)
doMoveInArea2(cid, 177, reto6, ELECTRICDAMAGE, 0, 0, "Zap Cannon Eff")
doSendMagicEffect(t[a][2], t[a][1])
    
elseif spell == "Charge Beam" then

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local p = getThingPosWithDebug(cid)
local t = {
[0] = {73, {x=p.x, y=p.y-1, z=p.z}},
[1] = {74, {x=p.x+6, y=p.y, z=p.z}},      --alterado v1.8
[2] = {75, {x=p.x, y=p.y+6, z=p.z}},
[3] = {76, {x=p.x-1, y=p.y, z=p.z}},
}

doMoveInArea2(cid, 0, triplo6, ELECTRICDAMAGE, min, max, spell)
doSendMagicEffect(t[a][2], t[a][1])
	
elseif spell == "Sacred Fire" then

     doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 3)
     doDanoWithProtectWithDelay(cid, target, SACREDDAMAGE, min, max, 143, sacred)    --alterado v1.6
            
elseif spell == "Blaze Kick" then

doMoveInArea2(cid, 6, blaze, FIREDAMAGE, min, max, spell) 
doMoveInArea2(cid, 6, kick, FIREDAMAGE, min, max, spell) 

elseif spell == "Cross Chop" then

doMoveInArea2(cid, 118, blaze, FIGHTINGDAMAGE, min, max, spell) 
doMoveInArea2(cid, 118, kick, FIGHTINGDAMAGE, min, max, spell) 

elseif spell == "Fire Pledge" then
	doDanoWithProtect(cid, FIREDAMAGE, getThingPosWithDebug(cid), selfArea2, min, max, 287)

elseif spell == "Giga Drain" then

    local pos = getThingPosWithDebug(cid)
    local areas = {rock1}

    for i = 1, #areas do
        addEvent(doMoveInArea2, i*120, cid, 911, areas[i], GRASSDAMAGE, min, max, spell)
    end

elseif spell == "Psychic Power" then
	doDanoWithProtect(cid, PSYCHICDAMAGE, getThingPosWithDebug(cid), selfArea2, min, max, 271)
   
elseif spell == "Ancient Power" then

local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area, eff)
if isCreature(cid) then
   if not isSightClear(p, area, false) then return true end
   doAreaCombatHealth(cid, ROCKDAMAGE, area, 0, 0, 0, eff)
   doAreaCombatHealth(cid, ROCKDAMAGE, area, whirl3, -min, -max, 137)
end
end

for a = 0, 4 do

local t = {
[0] = {18, {x=p.x, y=p.y-(a+1), z=p.z}},           --alterado v1.4
[1] = {18, {x=p.x+(a+1), y=p.y, z=p.z}},
[2] = {18, {x=p.x, y=p.y+(a+1), z=p.z}},
[3] = {18, {x=p.x-(a+1), y=p.y, z=p.z}}
}   
addEvent(sendAtk, 300*a, cid, t[d][2], t[d][1])
end
    
elseif spell == "Twister" then

doMoveInAreaMulti(cid, 28, 41, bullet, bulletDano, DRAGONDAMAGE, min, max)

elseif spell == "Multi-Kick" then

doMoveInAreaMulti(cid, 39, 113, multi, multiDano, FIGHTINGDAMAGE, min, max)

elseif spell == "Multi-Punch" then

doMoveInAreaMulti(cid, 39, 112, multi, multiDano, FIGHTINGDAMAGE, min, max) 

elseif spell == "Lick" then

local ret = {}
ret.id = target
ret.cd = 9
ret.check = getPlayerStorageValue(target, conds["Stun"])
ret.eff = 0
ret.spell = spell


   doSendMagicEffect(getThingPosWithDebug(target), 145)      --alterado v1.4!
   doMoveDano2(cid, target, NORMALDAMAGE, 0, 0, ret, spell)

elseif spell == "Bonemerang" then

   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 7)
   doDanoInTargetWithDelay(cid, target, GROUNDDAMAGE, min, max, 227)  --alterado v1.7
   doSendDistanceShoot(getThingPosWithDebug(target), getThingPosWithDebug(cid), 7)

elseif spell == "Bone Club" then

  doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 7)
  doDanoInTargetWithDelay(cid, target, GROUNDDAMAGE, min, max, 118)  --alterado v1.7
	
elseif spell == "Bone Slash" then

local function sendStickEff(cid, dir)
    if not isCreature(cid) then return true end
       doAreaCombatHealth(cid, GROUNDDAMAGE, getPosByDir(getThingPosWithDebug(cid), dir), 0, -min, -max, 227)
	end

	local function doStick(cid)
	if not isCreature(cid) then return true end
	local t = {
	      [1] = SOUTHWEST,
	      [2] = SOUTH,
	      [3] = SOUTHEAST,
	      [4] = EAST,
	      [5] = NORTHEAST,
	      [6] = NORTH,
	      [7] = NORTHWEST,
	      [8] = WEST,
	      [9] = SOUTHWEST,
		}
		for a = 1, 9 do
            sendStickEff(cid, t[a])
		end
	end

	doStick(cid, false, cid)
                                                                            --alterado v1.4
elseif spell == "Furious Legs" or spell == "Ultimate Champion" or spell == "Fighter Spirit" then

   local ret = {}
   ret.id = cid
   ret.cd = 15
   ret.eff = 13
   ret.check = 0
   ret.buff = spell
   ret.first = true
   
   doCondition2(ret)      
            
elseif spell == "Sludge Rain" then

local master = isSummon(cid) and getCreatureMaster(cid) or cid
local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 34
ret.check = 0
ret.spell = spell

local function doFall(cid)
for rocks = 1, 42 do
    addEvent(fall, rocks*35, cid, master, POISONDAMAGE, 6, 116)
end
end

for up = 1, 10 do
    addEvent(upEffect, up*75, cid, 6)
end         
                               
doFall(cid)
doMoveInArea2(cid, 0, BigArea2, POISONDAMAGE, min, max, spell, ret)  

elseif spell == "Shadow Ball" then

    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 18)

    local function doDamageWithDelay(cid, target)
    if not isCreature(cid) or not isCreature(target) then return true end
    if isSleeping(cid) then return false end
    if getPlayerStorageValue(cid, conds["Fear"]) >= 1 then return true end
	   doAreaCombatHealth(cid, ghostDmg, getThingPosWithDebug(target), 0, -min, -max, 255)
	   local pos = getThingPosWithDebug(target)
	   pos.x = pos.x + 1
	   doSendMagicEffect(pos, 140)
	end

	doDamageWithDelay(cid, target)
	
	elseif spell == "Shadow zoroark" then

    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 18)

    local function doDamageWithDelay(cid, target)
    if not isCreature(cid) or not isCreature(target) then return true end
    if isSleeping(cid) then return false end
    if getPlayerStorageValue(cid, conds["Fear"]) >= 1 then return true end
	   doAreaCombatHealth(cid, ghostDmg, getThingPosWithDebug(target), 0, -min, -max, 255)
	   local pos = getThingPosWithDebug(target)
	   pos.x = pos.x + 1
	   doSendMagicEffect(pos, 208)
	end

	doDamageWithDelay(cid, target)
	
elseif spell == "Shadow Punch" then

	local pos = getThingPosWithDebug(target)
	doSendMagicEffect(pos, 112)

		local function doPunch(cid, target)
			if not isCreature(cid) or not isCreature(target) then return true end
		       doAreaCombatHealth(cid, ghostDmg, getThingPosWithDebug(target), 0, -min, -max, 255)
		       pos.x = pos.x + 1
		       doSendMagicEffect(pos, 140)
        end

	doPunch(cid, target)
	
elseif spell == "Punch Darkness" then

	local pos = getThingPosWithDebug(target)
	doSendMagicEffect(pos, 112)

		local function doPunch(cid, target)
			if not isCreature(cid) or not isCreature(target) then return true end
		       doAreaCombatHealth(cid, ghostDmg, getThingPosWithDebug(target), 0, -min, -max, 255)
		       pos.x = pos.x + 1
		       doSendMagicEffect(pos, 103)
        end

        doPunch(cid, target)

elseif spell == "Shadow Storm" then

local master = isSummon(cid) and getCreatureMaster(cid) or cid

local function doFall(cid)
for rocks = 1, 42 do   --62
    addEvent(fall, rocks*35, cid, master, ghostDmg, 18, 140)
end
end

for up = 1, 10 do
    addEvent(upEffect, up*75, cid, 18)
end

doFall(cid)
doMoveInArea2(cid, 2, BigArea2, ghostDmg, min, max, spell)

elseif spell == "Water Storm" then

    local master = isSummon(cid) and getCreatureMaster(cid) or cid
    
    local function doFall(cid)
    for rocks = 1, 42 do   --62
        addEvent(fall, rocks*35, cid, master, ghostDmg, 255, 255)
    end
    end
    
    for up = 1, 10 do
        addEvent(upEffect, up*75, cid, 18)
    end
    
    doFall(cid)
    doMoveInArea2(cid, 255, BigArea2, ghostDmg, min, max, spell)

elseif spell == "Invisible" then

doDisapear(cid)
doSendMagicEffect(getThingPosWithDebug(cid), 134)
if isMonster(cid) then
  local pos = getThingPosWithDebug(cid)                           --alterei!
  doTeleportThing(cid, {x=4, y=3, z=10}, false)
  doTeleportThing(cid, pos, false)
end
addEvent(doAppear, 4000, cid)
        
elseif spell == "Nightmare" then

    if not isSleeping(target) then
		doSendMagicEffect(getThingPosWithDebug(target), 3)
		doSendAnimatedText(getThingPosWithDebug(target), "FAIL", 155)
	return true
	end
	
doDanoWithProtectWithDelay(cid, target, ghostDmg, -min, -max, 138)  

elseif spell == "Dream Eater" then

	if not isSleeping(target) then
		doSendMagicEffect(getThingPosWithDebug(target), 3)
		doSendAnimatedText(getThingPosWithDebug(target), "FAIL", 155)
	return true
	end
	                                                          --alterado v1.6
    setPlayerStorageValue(cid, 95487, 1)
    doSendMagicEffect(getThingPosWithDebug(cid), 132)
    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
    doDanoWithProtectWithDelay(cid, target, psyDmg, -min, -max, 138)
    
elseif spell == "Dark Eye" or spell == "Miracle Eye" then

doSendMagicEffect(getThingPosWithDebug(cid), 47)
setPlayerStorageValue(cid, 999457, 1)  

elseif spell == "Elemental Hands" then

if getCreatureOutfit(cid).lookType == 1301 then
print("Error occurred with move 'Elemental Hands', outfit of hitmonchan is wrong")
doPlayerSendTextMessage(getCreatureMaster(cid), MESSAGE_STATUS_CONSOLE_BLUE, "A error are ocurred... A msg is sent to gamemasters!") 
return true
end        --prote�ao pra n usar o move com o shiny hitmonchan com outfit diferente da do elite monchan do PO...

local e = getCreatureMaster(cid)
local name = getItemAttribute(getPlayerSlotItem(e, 8).uid, "poke")
local hands = getItemAttribute(getPlayerSlotItem(e, 8).uid, "hands")

       if hands == 4 then
       doItemSetAttribute(getPlayerSlotItem(e, 8).uid, "hands", 0)
       doSendMagicEffect(getThingPosWithDebug(cid), hitmonchans[name][0].eff)
       doSetCreatureOutfit(cid, {lookType = hitmonchans[name][0].out}, -1)
       else
       doItemSetAttribute(getPlayerSlotItem(e, 8).uid, "hands", hands+1)
       doSendMagicEffect(getThingPosWithDebug(cid), hitmonchans[name][hands+1].eff)
       doSetCreatureOutfit(cid, {lookType = hitmonchans[name][hands+1].out}, -1)
       end
       
elseif spell == "Crabhammer" then

doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 225)

elseif spell == "Ancient Fury" then

   local ret = {}
   ret.id = cid
   ret.cd = 15
   ret.eff = 0
   ret.check = 0
   ret.buff = spell
   ret.first = true
   
   doCondition2(ret)
   
elseif spell == "Divine Punishment" then
    docastspell(cid, "Psyusion")
       
elseif isInArray({"Camouflage", "Acid Armor", "Iron Defense", "Minimize"}, spell) then

   local ret = {}
   ret.id = cid
   ret.cd = 10
   ret.eff = 0
   ret.check = 0
   ret.buff = spell
   ret.first = true
   
   doCondition2(ret)    	

elseif spell == "Future Future" then
doSendMagicEffect(getThingPosWithDebug(cid), 132)
   
elseif spell == "Shadowave" then

doMoveInArea2(cid, 222, db1, DARKDAMAGE, min, max, spell)

elseif spell == "Confuse Ray" then

	local rounds = math.random(4, 7)
	rounds = rounds + math.floor(getMasterLevel(cid) / 35)
	
    local ret = {}
	ret.id = target
	ret.cd = rounds
	ret.check = getPlayerStorageValue(target, conds["Confusion"])
	

    posi = getThingPosWithDebug(target)
         posi.y = posi.y+1
    ---
	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
	addEvent(doSendMagicEffect, 100, posi, 222)
    addEvent(doMoveDano2, 100, cid, target, GHOSTDAMAGE, -min, -max, ret, spell)
	
	elseif spell == "Shadowave Zoroark" then

doMoveInArea2(cid, 103, db1, DARKDAMAGE, min, max, spell)

elseif spell == "Confuse Ray" then

	local rounds = math.random(4, 7)
	rounds = rounds + math.floor(getMasterLevel(cid) / 35)
	
    local ret = {}
	ret.id = target
	ret.cd = rounds
	ret.check = getPlayerStorageValue(target, conds["Confusion"])
	

    posi = getThingPosWithDebug(target)
         posi.y = posi.y+1
    ---
	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
	doSendMagicEffect(posi, 103)
    doMoveDano2(cid, target, GHOSTDAMAGE, -min, -max, ret, spell)

elseif spell == "Leaf Blade" then

local a = getThingPosWithDebug(target)
posi = {x = a.x+1, y = a.y+1, z = a.z}

doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
doSendMagicEffect(posi, 240)
doDanoWithProtectWithDelay(cid, target, GRASSDAMAGE, -min, -max, 0, LeafBlade)

elseif spell == "Eruption" or spell == "Elecball" then

pos = getThingPosWithDebug(cid)
    pos.x = pos.x+1
    pos.y = pos.y+1
    
atk = {
["Eruption"] = {241, FIREDAMAGE},
["Elecball"] = {171, ELECTRICDAMAGE}
}

stopNow(cid, 1000)
doSendMagicEffect(pos, atk[spell][1])
doMoveInArea2(cid, 0, bombWee1, atk[spell][2], min, max, spell) 

elseif spell == "Meteor Smash" then

local effD = getSubName(cid, target) == "Shiny Metagross" and 26 or 26 -- 13 � o efeito da "pedrinha" no caso � "missile"
local eff = getSubName(cid, target) == "Shiny Metagross" and 91 or 91 -- 91 � o efeito "Meteor" - no caso � "effect"

local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------

local function doFall(cid)
for rocks = 1, 62 do
    addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
end
end

for up = 1, 10 do                                                            
    addEvent(upEffect, up*75, cid, effD)
end

doFall(cid)
doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Dragon Rage" then

    local effD = getSubName(cid, target) == "Shiny Metagross" and 26 or 26 -- 13 � o efeito da "pedrinha" no caso � "missile"
    local eff = 231
    
    local master = isSummon(cid) and getCreatureMaster(cid) or cid
    ------------
    
    local function doFall(cid)
    for rocks = 1, 62 do
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
    end
    end
    
    for up = 1, 10 do                                                            
        addEvent(upEffect, up*75, cid, effD)
    end
    
    doFall(cid)
    doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Fire Storm" then

    local effD = 3 -- 13 � o efeito da "pedrinha" no caso � "missile"
    local eff = 248 -- 91 � o efeito "Meteor" - no caso � "effect"
    
    local master = isSummon(cid) and getCreatureMaster(cid) or cid
    ------------
    
    local function doFall(cid)
    for rocks = 1, 65 do
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
    end
    end
    
    for up = 1, 10 do                                                            
        addEvent(upEffect, up*75, cid, effD)
    end

    doFall(cid)
    doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Rock Slide" then

    local effD = 12 -- 13 � o efeito da "pedrinha" no caso � "missile"
    local eff = 44 -- 91 � o efeito "Meteor" - no caso � "effect"
    
    local master = isSummon(cid) and getCreatureMaster(cid) or cid
    ------------
    
    local function doFall(cid)
    for rocks = 1, 65 do
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
    end
    end
    
    for up = 1, 10 do                                                            
        addEvent(upEffect, up*75, cid, effD)
    end

    doFall(cid)
    doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Ice Slide" then

    local effD = 0 -- 13 � o efeito da "pedrinha" no caso � "missile"
    local eff = 176 -- 91 � o efeito "Meteor" - no caso � "effect"
    
    local master = isSummon(cid) and getCreatureMaster(cid) or cid
    ------------
    
    local function doFall(cid)
    for rocks = 1, 65 do
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
    end
    end
    
    for up = 1, 10 do                                                            
        addEvent(upEffect, up*75, cid, effD)
    end

    doFall(cid)
    doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)
    
elseif spell == "Blizzard Fall" then

    local effD = 28 -- 13 � o efeito da "pedrinha" no caso � "missile"
    local eff = 269 -- 91 � o efeito "Meteor" - no caso � "effect"
    
    local master = isSummon(cid) and getCreatureMaster(cid) or cid
    ------------
    
    local function doFall(cid)
    for rocks = 1, 65 do
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
    end
    end
    
    for up = 1, 10 do                                                            
        addEvent(upEffect, up*75, cid, effD)
    end

    doFall(cid)
    doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Draco Metteor" then

local effD = getSubName(cid, target) == "Shiny Dragonite" and 26 or 26 -- 13 � o efeito da "pedrinha" no caso � "missile"
local eff = getSubName(cid, target) == "Shiny Dragonite" and 5 or 5 -- 5 � o efeito "Meteor" - no caso � "effect"

local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------

local function doFall(cid)
for rocks = 1, 62 do
    addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
end
end

for up = 1, 10 do                                                            
    addEvent(upEffect, up*75, cid, effD)
end

doFall(cid)
doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)


elseif spell == "Paranoic Mind" then

local effD = getSubName(cid, target) == "Shiny Metagross" and 24 or 24 -- 13 � o efeito da "pedrinha" no caso � "missile"
local eff = getSubName(cid, target) == "Shiny Metagross" and 239 or 239 -- 100 � o efeito "Meteor" - no caso � "effect"

local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------

local function doFall(cid)
for rocks = 1, 62 do
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, effD, eff)
end
end

for up = 1, 10 do                                                            
    addEvent(upEffect, up*40, cid, effD)
end

doFall(cid)
doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Giant Punch" then

local effD = getSubName(cid, target) == "Shiny Metagross" and 26 or 26 -- 13 � o efeito da "pedrinha" no caso � "missile"
local eff = getSubName(cid, target) == "Shiny Metagross" and 99 or 99 -- 100 � o efeito "Meteor" - no caso � "effect"

local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------

local function doFall(cid)
for rocks = 1, 62 do
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, effD, eff)
end
end

for up = 1, 10 do                                                            
    addEvent(upEffect, up*40, cid, effD)
end

doFall(cid)
doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Poison Rain" then

local effD = getSubName(cid, target) == "Shiny Metagross" and 20 or 20 -- 13 � o efeito da "pedrinha" no caso � "missile"
local eff = getSubName(cid, target) == "Shiny Metagross" and 27 or 114 -- 100 � o efeito "Meteor" - no caso � "effect"

local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------

local function doFall(cid)
for rocks = 1, 62 do
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, effD, eff)
end
end

for up = 1, 10 do                                                            
    addEvent(upEffect, up*40, cid, effD)
end

doFall(cid)
doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Rain Of Hearts" then

local effD = getSubName(cid, target) == "Shiny Metagross" and 16 or 16 -- 13 � o efeito da "pedrinha" no caso � "missile"
local eff = getSubName(cid, target) == "Shiny Metagross" and 180 or 180 -- 100 � o efeito "Meteor" - no caso � "effect"

local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------

local function doFall(cid)
for rocks = 1, 62 do
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, effD, eff)
end
end

for up = 1, 10 do                                                            
    addEvent(upEffect, up*40, cid, effD)
end

doFall(cid)
doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Ilusion" then

local effD = getSubName(cid, target) == "Shiny Metagross" and 24 or 24 -- 13 � o efeito da "pedrinha" no caso � "missile"
local eff = getSubName(cid, target) == "Shiny Metagross" and 253 or 253 -- 100 � o efeito "Meteor" - no caso � "effect"

local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------

local function doFall(cid)
for rocks = 1, 62 do
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, effD, eff)
end
end

for up = 1, 10 do                                                            
    addEvent(upEffect, up*40, cid, effD)
end

doFall(cid)
doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)


elseif spell == "Punch Flames" then

local effD = getSubName(cid, target) == "Shiny Hitmonchan" and 3 or 3 -- 13 � o efeito da "pedrinha" no caso � "missile"
local eff = getSubName(cid, target) == "Shiny Hitmonchan" and 248 or 248 -- 100 � o efeito "Meteor" - no caso � "effect"

local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------

local function doFall(cid)
for rocks = 1, 62 do
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, effD, eff)
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, effD, 0)
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, effD, 0)
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, 10, 248)
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, 10, 248)
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, 10, 248)
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, 10, 248)
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, 10, 248)
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, 10, 248)
    addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, 10, 248)
end
end

for up = 1, 10 do                                                            
    addEvent(upEffect, up*40, cid, effD)
end

doFall(cid)
doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Punch Flamesss" then

    local effD = getSubName(cid, target) == "Shiny Hitmonchan" and 26 or 26 -- 13 � o efeito da "pedrinha" no caso � "missile"
    local eff = getSubName(cid, target) == "Shiny Hitmonchan" and 112 or 35 -- 100 � o efeito "Meteor" - no caso � "effect"
    
    local master = isSummon(cid) and getCreatureMaster(cid) or cid
    ------------
    
    local function doFall(cid)
    for rocks = 1, 62 do
        addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, effD, 35)
        addEvent(fall, rocks*50, cid, master, ROCKDAMAGE, effD, 35)
    end
    end
    
    for up = 1, 10 do                                                            
        addEvent(upEffect, up*40, cid, effD)
    end
    
    doFall(cid)
    doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)

elseif spell == "Magical Leaf" then

    local effD = 31 -- 13 � o efeito da "pedrinha" no caso � "missile"
    local eff = 256 -- 91 � o efeito "Meteor" - no caso � "effect"
    
    local master = isSummon(cid) and getCreatureMaster(cid) or cid
    ------------
    
    local function doFall(cid)
    for rocks = 1, 65 do
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, 0)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, 0)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, 0)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, 0)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, 0)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, 0)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, 0)
        addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, 0)
    end
    end
    
    for up = 1, 10 do                                                            
        addEvent(upEffect, up*75, cid, effD)
    end

    doFall(cid)
    doDanoWithProtect(cid, ROCKDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)


elseif spell == "Ice Falling" then

local effD = 24 -- 13 � o efeito da "pedrinha" no caso � "missile"
local eff = 52 -- 100 � o efeito "Meteor" - no caso � "effect"

local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------

local function doFall(cid)
for rocks = 1, 30 do
    addEvent(fall, rocks*32, cid, master, ICEDAMAGE, effD, eff)
end
end

for up = 1, 10 do                                                            
    addEvent(upEffect, up*10, cid, effD)
end

doFall(cid)
doDanoWithProtect(cid, ICEDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)


elseif spell == "Draco Meteor" then

local effD = getSubName(cid, target) == "Shiny Hitmonchan" and 26 or 26 -- 13 � o efeito da "pedrinha" no caso � "missile"
local eff = getSubName(cid, target) == "Shiny Hitmonchan" and 248 or 248 -- 100 � o efeito "Meteor" - no caso � "effect"

local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------

local function doFall(cid)
for rocks = 1, 62 do
    addEvent(fall, rocks*50, cid, master, DRAGONDAMAGE, effD, eff)
    addEvent(fall, rocks*50, cid, master, DRAGONDAMAGE, effD, 248)
    addEvent(fall, rocks*50, cid, master, DRAGONDAMAGE, effD, 248)
end
end

for up = 1, 10 do                                                            
    addEvent(upEffect, up*40, cid, effD)
end

doFall(cid)
doDanoWithProtect(cid, DRAGONDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)


elseif spell == "Dragon Pulse" then

local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area)
if isCreature(cid) then
   if not isSightClear(p, area, false) then return true end
   doAreaCombatHealth(cid, DRAGONDAMAGE, area, pulse2, -min, -max, 255)
end
end

for a = 0, 3 do

local t = {
[0] = {249, {x=p.x, y=p.y-(a+1), z=p.z}},
[1] = {249, {x=p.x+(a+1), y=p.y, z=p.z}},
[2] = {249, {x=p.x, y=p.y+(a+1), z=p.z}},
[3] = {249, {x=p.x-(a+1), y=p.y, z=p.z}}
}   

sendAtk(cid, t[d][2])
doDanoWithProtect(cid, DRAGONDAMAGE, t[d][2], pulse2, 0, 0, 177)
doDanoWithProtect(cid, DRAGONDAMAGE, t[d][2], pulse1, 0, 0, t[d][1])
end

elseif spell == "Psy Ball" then

   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 3)
   doDanoInTargetWithDelay(cid, target, psyDmg, min, max, 250)  --alterado v1.7

elseif spell == "SmokeScreen" then

local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 34
ret.check = 0
ret.spell = spell

local function smoke(cid)
if not isCreature(cid) then return true end
   doMoveInArea2(cid, 34, confusion, NORMALDAMAGE, 0, 0, spell, ret)
end

for i = 0, 2 do
    addEvent(smoke, i*500, cid)                               
end

elseif spell == "Faint Attack" or spell == "Sucker Punch" then  --alterado v1.5

   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
   doDanoInTargetWithDelay(cid, target, DARKDAMAGE, min, max, 237)  --alterado v1.7

elseif spell == "Scary Face" then

local ret = {}
ret.id = 0
ret.cd = 9
ret.check = 0
ret.eff = 0
ret.spell = spell



local p = getThingPosWithDebug(cid)
doSendMagicEffect({x=p.x+1, y=p.y+1, z=p.z}, 228)
doMoveInArea2(cid, 0, confusion, NORMALDAMAGE, 0, 0, spell, ret)

elseif spell == "Sunny Day" then

local ret = {}
ret.id = 0
ret.cd = 9
ret.check = 0
ret.eff = 39
ret.cond = "Silence"
----
local p = getThingPosWithDebug(cid)
doSendMagicEffect({x=p.x+1, y=p.y, z=p.z}, 181)
---
if isSummon(cid) then 
   doCureBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid, "all")
end
doCureStatus(cid, "all")
setPlayerStorageValue(cid, 253, 1)  --focus
doMoveInArea2(cid, 0, confusion, NORMALDAMAGE, 0, 0, spell, ret)

elseif isInArray({"Pursuit", "ExtremeSpeed", "U-Turn", "Shell Attack"}, spell) then

local atk = {
["Pursuit"] = {17, DARKDAMAGE},
["ExtremeSpeed"] = {50, NORMALDAMAGE, 51},
["U-Turn"] = {19, BUGDAMAGE},
["Shell Attack"] = {45, BUGDAMAGE}      --alterado v1.5
}

local pos = getThingPosWithDebug(cid)
local p = getThingPosWithDebug(target)
local newPos = getClosestFreeTile(target, p)

local eff = getSubName(cid, target) == "Shiny Arcanine" and atk[spell][3] or atk[spell][1] --alterado v1.6.1

local damage = atk[spell][2]
-----------
doDisapear(cid)
doChangeSpeed(cid, -getCreatureSpeed(cid))
-----------
addEvent(doSendMagicEffect, 300, pos, 211)
addEvent(doSendDistanceShoot, 400, pos, p, eff)
addEvent(doSendDistanceShoot, 400, newPos, p, eff)
addEvent(doDanoInTarget, 400, cid, target, damage, -min, -max, 0) --alterado v1.7
addEvent(doSendDistanceShoot, 5500, p, pos, eff)
addEvent(doSendMagicEffect, 850, pos, 211)
addEvent(doRegainSpeed, 1000, cid)
addEvent(doAppear, 1000, cid)

elseif spell == "Egg Rain" then

local effD = 12
local eff = 5
local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------

local function doFall(cid)
for rocks = 1, 62 do
    addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
end
end

for up = 1, 10 do
    addEvent(upEffect, up*75, cid, effD)
end

doFall(cid)
doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)


elseif spell == "Air Cutter" then
local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area)
if isCreature(cid) then
   if not isSightClear(p, area, false) then return true end
   doAreaCombatHealth(cid, FLYINGDAMAGE, area, whirl3, -min, -max, 255)
end
end

for a = 0, 5 do

local t = {
[0] = {128, {x=p.x, y=p.y-(a+1), z=p.z}, {x=p.x+1, y=p.y-(a+1), z=p.z}},
[1] = {129, {x=p.x+(a+1), y=p.y, z=p.z}, {x=p.x+(a+2), y=p.y+1, z=p.z}},
[2] = {131, {x=p.x, y=p.y+(a+1), z=p.z}, {x=p.x+1, y=p.y+(a+2), z=p.z}},
[3] = {130, {x=p.x-(a+1), y=p.y, z=p.z}, {x=p.x-(a+1), y=p.y+1, z=p.z}}
}   
addEvent(doSendMagicEffect, 300*a, t[d][3], t[d][1])
addEvent(sendAtk, 300*a, cid, t[d][2])
end

elseif spell == "Venom Gale" then

local area = {gale1, gale2, gale3, gale4, gale3, gale2, gale1}

for i = 1, #area do
    addEvent(doMoveInArea2, i*120, cid, 138, area[i], POISONDAMAGE, min, max, spell)
end	

elseif spell == "Crunch" then

doMoveInArea2(cid, 146, Crunch1, DARKDAMAGE, min, max, spell)
doMoveInArea2(cid, 146, Crunch2, DARKDAMAGE, min, max, spell)

elseif spell == "Ice Fang" then

doTargetCombatHealth(cid, target, ICEDAMAGE, 0, 0, 146)
doDanoWithProtect(cid, ICEDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 17)

elseif spell == "Psyshock" then

local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area, eff)
if isCreature(cid) then 
   if not isSightClear(p, area, false) then return true end
   doAreaCombatHealth(cid, psyDmg, area, 0, 0, 0, eff)    --alterado v1.4
   doAreaCombatHealth(cid, psyDmg, area, whirl3, -min, -max, 255)     --alterado v1.4
end
end

for a = 0, 4 do

local t = {
[0] = {250, {x=p.x, y=p.y-(a+1), z=p.z}},           --alterado v1.4
[1] = {250, {x=p.x+(a+1), y=p.y, z=p.z}},
[2] = {250, {x=p.x, y=p.y+(a+1), z=p.z}},
[3] = {250, {x=p.x-(a+1), y=p.y, z=p.z}}
}   
addEvent(sendAtk, 370*a, cid, t[d][2], t[d][1])
end


elseif spell == "HurricaneBKP" then

local function hurricane(cid)
		if not isCreature(cid) then return true end
		   doMoveInArea2(cid, 42, bombWee1, FLYINGDAMAGE, min, max, spell)
	end

doSetCreatureOutfit(cid, {lookType = 1398}, 10000)

setPlayerStorageValue(cid, 3644587, 1)   	
for i = 1, 7 do
    addEvent(hurricane, i*400, cid)                                --alterado v1.4
end

elseif spell == "Synthesis" or spell == "Roost" or spell == "Roost Zoroark" or spell == "Emotional" then

	local min = (getCreatureMaxHealth(cid) * math.random(20,25)) / 100
	local max = (getCreatureMaxHealth(cid) * math.random(50,75)) / 100
	
	local function doHealArea(cid, min, max)
    local amount = math.random(min, max)
    if (getCreatureHealth(cid) + amount) >= getCreatureMaxHealth(cid) then
        amount = -(getCreatureHealth(cid)-getCreatureMaxHealth(cid))
    end
    if getCreatureHealth(cid) ~= getCreatureMaxHealth(cid) then
       doCreatureAddHealth(cid, amount)
       doSendAnimatedText(getThingPosWithDebug(cid), "+"..amount.."", 65)
    end
    end
    
	doSendMagicEffect(getThingPosWithDebug(cid), 264)
    doHealArea(cid, min, max) 
    
elseif spell == "Cotton Spore" then

    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.eff = 0
    ret.check = 0
    ret.spell = spell
    
    
    doMoveInArea2(cid, 85, confusion, GRASSDAMAGE, 0, 0, spell, ret)

elseif spell == "Peck" then

sendDistanceShootWithProtect(cid, getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
doDanoInTargetWithDelay(cid, target, FLYINGDAMAGE, min, max, 3)  --alterado v1.7

elseif spell == "Rolling Kick" or spell == "Night Daze" then

local pos = getThingPosWithDebug(cid)
local eff = spell == "Night Daze" and 222 or 113
local dmg = spell == "Night Daze" and DARKDAMAGE or FIGHTINGDAMAGE

local out = getSubName(cid, target) == "Hitmontop" and 1193 or 1451 --alterado v1.6.1

	local function doSendBubble(cid, pos)
		if not isCreature(cid) then return true end
		doSendDistanceShoot(getThingPosWithDebug(cid), pos, 39)
		doSendMagicEffect(pos, eff)
	end
	                                                          --alterado!!
	for a = 1, 20 do
	    local r1 = math.random(-4, 4)
	    local r2 = r1 == 0 and choose(-3, -2, -1, 2, 3) or math.random(-3, 3)
	    --
	    local lugar = {x = pos.x + r1, y = pos.y + r2, z = pos.z}
	    addEvent(doSendBubble, a * 25, cid, lugar)
	end
	if isInArray({"Hitmontop", "Shiny Hitmontop"}, getSubName(cid, target)) then  --alterado v1.6.1
	   doSetCreatureOutfit(cid, {lookType = out}, 400)
    end

	doDanoWithProtect(cid, dmg, pos, waterarea, -min, -max, 0)
	
elseif spell == "Safeguard" then

doSendMagicEffect(getThingPosWithDebug(cid), 133)
if isSummon(cid) then 
   doCureBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid, "all")
end
doCureStatus(cid, "all") 

elseif spell == "Air Slash" then

local p = getThingPosWithDebug(cid)

local t = {
{{128, {x = p.x+1, y = p.y-1, z = p.z}}, {16, {x = p.x+1, y = p.y-1, z = p.z}}},
{{129, {x = p.x+2, y = p.y+1, z = p.z}}, {221, {x = p.x+3, y = p.y+1, z = p.z}}},
{{131, {x = p.x+1, y = p.y+2, z = p.z}}, {223, {x = p.x+1, y = p.y+3, z = p.z}}},
{{130, {x = p.x-1, y = p.y+1, z = p.z}}, {243, {x = p.x-1, y = p.y+1, z = p.z}}},
}

for i = 1, 4 do
    doSendMagicEffect(t[i][2][2], t[i][2][1])
end
doDanoWithProtect(cid, FLYINGDAMAGE, getThingPosWithDebug(cid), airSlash, -min, -max, 0)    

for i = 1, 4 do
    doSendMagicEffect(t[i][1][2], t[i][1][1])
end

doDanoWithProtect(cid, FLYINGDAMAGE, getThingPosWithDebug(cid), bombWee2, -min, -max, 0)

elseif spell == "Feather Dance" then

local function doPulse(cid, eff)
if not isCreature(cid) or not isCreature(target) then return true end
   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 9)
   doDanoInTargetWithDelay(cid, target, FLYINGDAMAGE, -min, -max, eff)   --alterado v1.7
end

doPulse(cid)
doPulse(cid)


elseif spell == "Tailwind" then

   local ret = {}
   ret.id = cid
   ret.cd = 10
   ret.eff = 137
   ret.check = 0
   ret.buff = spell
   ret.first = true
   
   doCondition2(ret)
elseif spell == "Tackle" then

   doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 111)
  
	
elseif spell == "Bug Fighter" then
	
   local ret = {}
   ret.id = cid
   ret.cd = 10
   ret.eff = 0
   ret.check = 0
   ret.buff = spell
   ret.first = true
   
   doCondition2(ret)	
	
elseif spell == "Metal Claw" then

   doDanoWithProtect(cid, STEELDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 160)	
	
elseif spell == "Octazooka" then

local ret = {}
ret.id = 0
ret.cd = 9
ret.check = 0
ret.eff = 34
ret.cond = "Silence"

doMoveInAreaMulti(cid, 6, 116, multi, multiDano, WATERDAMAGE, min, max)
doMoveInArea2(cid, 0, multiDano, WATERDAMAGE, 0, 0, spell, ret)
	
	
elseif spell == "Take Down" then

    doMoveInArea2(cid, 111, reto5, NORMALDAMAGE, min, max, spell)

elseif spell == "Yawn" then

local ret = {}
ret.id = target
ret.cd = math.random(6, 9)
ret.check = getPlayerStorageValue(target, conds["Sleep"])
ret.first = true
ret.cond = "Sleep"

    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 11)
    doMoveDano2(cid, target, NORMALDAMAGE, 0, 0, ret, spell)

elseif spell == "Tongue Hook" then

sendDistanceShootWithProtect(cid, getThingPosWithDebug(cid), getThingPosWithDebug(target), 38)
doTeleportThing(target, getClosestFreeTile(cid, getThingPosWithDebug(cid)), true)
sendDistanceShootWithProtect(cid, getThingPosWithDebug(target), getThingPosWithDebug(cid), 38)


elseif spell == "Tongue Grap" then

local function distEff(cid, target)
if not isCreature(cid) or not isCreature(target) or not isSilence(target) then return true end  --alterado v1.6
   sendDistanceShootWithProtect(cid, getThingPosWithDebug(target), getThingPosWithDebug(cid), 38)
end

local ret = {}
ret.id = target
ret.cd = 10
ret.check = getPlayerStorageValue(target, conds["Silence"])
ret.eff = 185
ret.cond = "Silence"

sendDistanceShootWithProtect(cid, getThingPosWithDebug(cid), getThingPosWithDebug(target), 38)
doMoveDano2(cid, target, NORMALDAMAGE, 0, 0, ret, spell)
 
for i = 1, 10 do
    distEff(cid, target)
end 

elseif spell == "Struggle Bug" then

    local function sendFireEff(cid, dir)
    if not isCreature(cid) then return true end
       doDanoWithProtect(cid, BUGDAMAGE, getPosByDir(getThingPosWithDebug(cid), dir), 0, -min, -max, 105)
	end

	local function doWheel(cid)
	if not isCreature(cid) then return true end
	local t = {
	      [1] = SOUTH,
	      [2] = SOUTHEAST,
	      [3] = EAST,
	      [4] = NORTHEAST,
	      [5] = NORTH,        --alterado v1.5
	      [6] = NORTHWEST,
	      [7] = WEST,
	      [8] = SOUTHWEST,
		}
		for a = 1, 8 do
            sendFireEff(cid, t[a])
		end
	end

	doWheel(cid, false, cid)
	
elseif spell == "Low Kick" then
  
    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
    doDanoInTargetWithDelay(cid, target, FIGHTINGDAMAGE, min, max, 113)	--alterado v1.7

elseif spell == "Present" then

local function sendHeal(cid)
if isCreature(cid) and isCreature(target) then 
   doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), crusher, min, max, 5)
   doSendAnimatedText(getThingPosWithDebug(target), "HEALTH!", 65)
end
end

    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 31)
    if math.random(1, 100) >= 10 then
	   doDanoWithProtectWithDelay(cid, target, NORMALDAMAGE, min, max, 5, crusher) 
    else
        sendHeal(cid) 
    end
	
elseif spell == "Inferno" or spell == "Fissure" then
    
local pos = getThingPosWithDebug(cid)

atk = {
["Inferno"] = {287, FIREDAMAGE},
["Fissure"] = {102, GROUNDDAMAGE}
}

doMoveInArea2(cid, atk[spell][1], inferno1, atk[spell][2], 0, 0, spell)
doDanoWithProtect(cid, atk[spell][2], pos, inferno2, -min, -max, 0)


elseif spell == "Wrap" then

local ret = {}
ret.id = target
ret.cd = 10
ret.check = getPlayerStorageValue(target, conds["Silence"])
ret.eff = 104
ret.cond = "Silence"

doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
doMoveDano2(cid, target, NORMALDAMAGE, 0, 0, ret, spell)

elseif spell == "Rock n'Roll" then

local pos = getThingPosWithDebug(cid)
local areas = {rock1, rock2, rock3, rock4, rock5, rock4, rock3, rock2, rock1}
local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 1
ret.check = 0
ret.spell = spell

for i = 1, #areas do
    addEvent(doMoveInArea2, i*400, cid, 1, areas[i], NORMALDAMAGE, min, max, spell, ret)
end

elseif spell == "Power Wave" then
                                             
local pos = getThingPosWithDebug(cid)
local areas = {rock1, rock2, rock3, rock4, rock5}
local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 103
ret.check = 0
ret.first = true
ret.cond = "Paralyze"

local function sendAtk(cid)
if isCreature(cid) then 
doRemoveCondition(cid, CONDITION_OUTFIT)
setPlayerStorageValue(cid, 9658783, -1)  
for i = 1, #areas do
    addEvent(doMoveInArea2, i*400, cid, 103, areas[i], psyDmg, min, max, spell, ret)
end
end
end

doSetCreatureOutfit(cid, {lookType = 1001}, -1)
setPlayerStorageValue(cid, 9658783, 1)
sendAtk(cid)


elseif spell == "Ground Crusher" then

local pos = getThingPosWithDebug(cid)
local areas = {rock1, rock2, rock3, rock4, rock5}
local ret = {}
    ret.id = 0
    ret.cd = 12
    ret.eff = 0
    ret.check = 0
    ret.spell = spell
    
    
local function endMove(cid)
if isCreature(cid) then
   doRemoveCondition(cid, CONDITION_OUTFIT)   
end
end

doSetCreatureOutfit(cid, {lookType = 1449}, -1)
stopNow(cid, 16*360)
addEvent(endMove, 16*360, cid)
----
for i = 1, #areas do
    addEvent(doMoveInArea2, i*350, cid, 100, areas[i], GROUNDDAMAGE, min, max, spell, ret)
    addEvent(doMoveInArea2, i*360, cid, 100, areas[i], GROUNDDAMAGE, 0, 0, spell, ret)
end

elseif spell == "Psy Impact" then

local master = getCreatureMaster(cid) or 0
local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 0
ret.check = 0
ret.spell = spell
    
for rocks = 1, 42 do
    addEvent(fall, rocks*35, cid, master, psyDmg, -1, 98)
end

doMoveInArea2(cid, 0, BigArea2, psyDmg, min, max, spell, ret) 

elseif spell == "Two Face Shock" then

local atk = {
[1] = {179, ICEDAMAGE},
[2] = {127, GROUNDDAMAGE}
}

    local rand = math.random(1, 2)

	doAreaCombatHealth(cid, atk[rand][2], getThingPosWithDebug(cid), splash, -min, -max, 255)

	local sps = getThingPosWithDebug(cid)
	sps.x = sps.x+1
	sps.y = sps.y+1
	doSendMagicEffect(sps, atk[rand][1])


elseif spell == "Aerial Ace" then

local eff = {16, 221, 223, 243}

for rocks = 1, 32 do
    addEvent(fall, rocks*22, cid, master, FLYINGDAMAGE, -1, eff[math.random(1, 4)])
end

doMoveInArea2(cid, 0, BigArea2, FLYINGDAMAGE, min, max, spell) 

elseif spell == "Echoed Voice" then

local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area)
if isCreature(cid) then
   if not isSightClear(p, area, false) then return true end
   doAreaCombatHealth(cid, NORMALDAMAGE, area, pulse2, -min, -max, 255)
end
end

for a = 0, 5 do

local t = {
[0] = {39, {x=p.x, y=p.y-(a+1), z=p.z}},     
[1] = {39, {x=p.x+(a+1), y=p.y, z=p.z}},
[2] = {39, {x=p.x, y=p.y+(a+1), z=p.z}},
[3] = {39, {x=p.x-(a+1), y=p.y, z=p.z}}                            
}   
addEvent(sendAtk, 400*a, cid, t[d][2])
addEvent(doAreaCombatHealth, 400*a, cid, ROCKDAMAGE, t[d][2], pulse1, 0, 0, t[d][1])
end	

elseif spell == "Water Tornado" or spell == "Electro Field" or spell == "Veneno Mortal" or spell == "Petal Tornado" or spell == "Flame Wheel" or spell == "Fly" or spell == "Whirlpool" or spell == "Outrage" or spell == "Thunder Rage" or spell == "Water Shock" or spell == "Toxic" or spell == "Flare Blitz" then  --alterado v1.8

local p = getThingPos(cid)
local pos1 = {
    --[[ [1] = {{x = 0, y = 4, z = 0}, {x = 1, y = 4, z = 0}, {x = 2, y = 3, z = 0}, {x = 3, y = 2, z = 0}, {x = 4, y = 1, z = 0}, {x = 4, y = 0, z = 0}}, ]]
    [1] = {{x = 0, y = 3, z = 0}, {x = 1, y = 3, z = 0}, {x = 2, y = 2, z = 0}, {x = 3, y = 1, z = 0}, {x = 3, y = 0, z = 0}},
    [2] = {{x = 0, y = 2, z = 0}, {x = 1, y = 2, z = 0}, {x = 2, y = 1, z = 0}, {x = 2, y = 0, z = 0}},
    [3] = {{x = 0, y = 1, z = 0}, {x = 1, y = 1, z = 0}, {x = 1, y = 0, z = 0}},
}

local pos2 = {
   --[[  [1] = {{x = 0, y = -4, z = 0}, {x = -1, y = -4, z = 0}, {x = -2, y = -3, z = 0}, {x = -3, y = -2, z = 0}, {x = -4, y = -1, z = 0}, {x = -4, y = 0, z = 0}}, ]]
    [1] = {{x = 0, y = -3, z = 0}, {x = -1, y = -3, z = 0}, {x = -2, y = -2, z = 0}, {x = -3, y = -1, z = 0}, {x = -3, y = 0, z = 0}},
    [2] = {{x = 0, y = -2, z = 0}, {x = -1, y = -2, z = 0}, {x = -2, y = -1, z = 0}, {x = -2, y = 0, z = 0}},
    [3] = {{x = 0, y = -1, z = 0}, {x = -1, y = -1, z = 0}, {x = -1, y = 0, z = 0}},
}

local pos3 = {
    --[[ [1] = {{x = 4, y = 0, z = 0}, {x = 4, y = -1, z = 0}, {x = 3, y = -2, z = 0}, {x = 2, y = -3, z = 0}, {x = 1, y = -4, z = 0}, {x = 0, y = -4, z = 0}}, ]]
    [1] = {{x = 3, y = 0, z = 0}, {x = 3, y = -1, z = 0}, {x = 2, y = -2, z = 0}, {x = 1, y = -3, z = 0}, {x = 0, y = -3, z = 0}},
    [2] = {{x = 2, y = 0, z = 0}, {x = 2, y = -1, z = 0}, {x = 1, y = -2, z = 0}, {x = 0, y = -2, z = 0}},
    [3] = {{x = 1, y = 0, z = 0}, {x = 1, y = -1, z = 0}, {x = 0, y = -1, z = 0}},
}

local pos4 = {
   --[[  [1] = {{x = -4, y = 0, z = 0}, {x = -4, y = 1, z = 0}, {x = -3, y = 2, z = 0}, {x = -2, y = 3, z = 0}, {x = -1, y = 4, z = 0}, {x = 0, y = 4, z = 0}}, ]]
    [1] = {{x = -3, y = 0, z = 0}, {x = -3, y = 1, z = 0}, {x = -2, y = 2, z = 0}, {x = -1, y = 3, z = 0}, {x = 0, y = 3, z = 0}},
    [2] = {{x = -2, y = 0, z = 0}, {x = -2, y = 1, z = 0}, {x = -1, y = 2, z = 0}, {x = 0, y = 2, z = 0}},
    [3] = {{x = -1, y = 0, z = 0}, {x = -1, y = 1, z = 0}, {x = 0, y = 1, z = 0}},
}

local atk = {
--[atk] = {distance, eff, damage}
["Electro Field"] = {274, 274, ELECTRICDAMAGE},
["Veneno Mortal"] = {10, 275, GRASSDAMAGE},
["Petal Tornado"] = {14, 54, GRASSDAMAGE},
["Fly"] = {-1, 222, FLYINGDAMAGE},
["Water Tornado"] = {-1, 158, WATERDAMAGE},

["Flame Wheel"] = {-1, 6, FIREDAMAGE},
["Whirlpool"] = {-1, 41, FIREDAMAGE},
["Outrage"] = {-1, 11, DRAGONDAMAGE},
["Thunder Rage"] = {-1, 320, ELECTRICDAMAGE},
["Water Shock"] = {-1, 329, WATERDAMAGE},
["Toxic"] = {-1, 274, POISONDAMAGE},
["Flare Blitz"] = {-1, 270, FIREDAMAGE},
}
local ret = {}                 
ret.id = 0
ret.cd = 12
ret.eff = 48
ret.check = 0
ret.spell = spell

if spell == "Flare Blitz" then
	local x = getClosestFreeTile(cid, getThingPosWithDebug(target))
	doTeleportThing(cid, x, false)
	doFaceCreature(cid, getThingPosWithDebug(target))
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 3)
end


local function sendDist(cid, posi1, posi2, eff, delay)
if posi1 and posi2 and isCreature(cid) then
   addEvent(sendDistanceShootWithProtect, delay, cid, posi1, posi2, eff)   --alterado v1.6
end
end
                                                               
local function sendDano(cid, pos, eff, delay, min, max)
if pos and isCreature(cid) then
   addEvent(function()
    if isCreature(cid) and pos ~= nil and pos ~= false then
        pos.x = getCreaturePosition(cid).x+pos.x
        pos.y = getCreaturePosition(cid).y+pos.y
        pos.z = getCreaturePosition(cid).z

        doDanoWithProtect(cid, atk[spell][3], pos, 0, -min, -max, eff)
    end
   end, delay)  --alterado v1.6
end
end

local function doTornado(cid)
if isCreature(cid) then
for j = 1, 3 do
   for i = 1, 6 do   
       if spell == "Toxic" then
            addEvent(sendDist, 2, cid, pos1[j][i], pos1[j][i], atk[spell][1], i*330)
            addEvent(sendDano, 2, cid, pos1[j][i], atk[spell][2], i*240, min, max)
            addEvent(sendDano, 2, cid, pos1[j][i], atk[spell][2], i*250, 0, 0)
            ---
            addEvent(sendDist, 2, cid, pos2[j][i], pos2[j][i], atk[spell][1], i*330)
            addEvent(sendDano, 2, cid, pos2[j][i], atk[spell][2], i*240, min, max)
            addEvent(sendDano, 2, cid, pos2[j][i], atk[spell][2], i*250, 0, 0)
            ----
            addEvent(sendDist, 2, cid, pos3[j][i], pos3[j][i], atk[spell][1], i*330)
            addEvent(sendDano, 2, cid, pos3[j][i], atk[spell][2], i*240, min, max)
            addEvent(sendDano, 2, cid, pos3[j][i], atk[spell][2], i*250, 0, 0)
            ---
            addEvent(sendDist, 2, cid, pos4[j][i], pos4[j][i], atk[spell][1], i*330)
            addEvent(sendDano, 2, cid, pos4[j][i], atk[spell][2], i*240, min, max)
            addEvent(sendDano, 2, cid, pos4[j][i], atk[spell][2], i*250, 0, 0)
       elseif spell == "Flare Blitz" then
            addEvent(sendDist, 350, cid, pos1[j][i], pos1[j][i], atk[spell][1], i*330)
            addEvent(sendDano, 350, cid, pos1[j][i], atk[spell][2], i*300, min, max)
            addEvent(sendDano, 350, cid, pos1[j][i], atk[spell][2], i*310, 0, 0)
            ---
            addEvent(sendDist, 350, cid, pos2[j][i], pos2[j][i], atk[spell][1], i*330)
            addEvent(sendDano, 350, cid, pos2[j][i], atk[spell][2], i*300, min, max)
            addEvent(sendDano, 350, cid, pos2[j][i], atk[spell][2], i*310, 0, 0)
            ----
            addEvent(sendDist, 800, cid, pos3[j][i], pos3[j][i], atk[spell][1], i*330)
            addEvent(sendDano, 800, cid, pos3[j][i], atk[spell][2], i*300, min, max)
            addEvent(sendDano, 800, cid, pos3[j][i], atk[spell][2], i*310, 0, 0)
            ---
            addEvent(sendDist, 800, cid, pos4[j][i], pos4[j][i], atk[spell][1], i*330)
            addEvent(sendDano, 800, cid, pos4[j][i], atk[spell][2], i*300, min, max)
            addEvent(sendDano, 800, cid, pos4[j][i], atk[spell][2], i*310, 0, 0)
       else
            addEvent(sendDist, 350, cid, pos1[j][i], pos1[j][i], atk[spell][1], i*330)
            addEvent(sendDano, 350, cid, pos1[j][i], atk[spell][2], i*300, min, max)
            addEvent(sendDano, 350, cid, pos1[j][i], atk[spell][2], i*310, 0, 0)
            ---
            addEvent(sendDist, 350, cid, pos2[j][i], pos2[j][i], atk[spell][1], i*330)
            addEvent(sendDano, 350, cid, pos2[j][i], atk[spell][2], i*300, min, max)
            addEvent(sendDano, 350, cid, pos2[j][i], atk[spell][2], i*310, 0, 0)
            ----
            addEvent(sendDist, 800, cid, pos3[j][i], pos3[j][i], atk[spell][1], i*330)
            addEvent(sendDano, 800, cid, pos3[j][i], atk[spell][2], i*300, min, max)
            addEvent(sendDano, 800, cid, pos3[j][i], atk[spell][2], i*310, 0, 0)
            ---
            addEvent(sendDist, 800, cid, pos4[j][i], pos4[j][i], atk[spell][1], i*330)
            addEvent(sendDano, 800, cid, pos4[j][i], atk[spell][2], i*300, min, max)
            addEvent(sendDano, 800, cid, pos4[j][i], atk[spell][2], i*310, 0, 0)
       end
   end
end
end
end

if spell == "Electro Field" then
    doMoveInArea2(cid, 0, electro, ELECTRICDAMAGE, 0, 0, spell, ret)
end

if spell == "Veneno Mortal" then
    doMoveInArea2(cid, 0, electro, ELECTRICDAMAGE, 0, 0, spell, ret)
end


if spell == "Flame Wheel" then   --alterado v1.8
   doTornado(cid)
else
    for b = 0, 2 do
        doTornado(cid)
    end
end

elseif spell == "Seed Bomb" then                  --alterado v1.6

local master = isSummon(cid) and getCreatureMaster(cid) or cid

local function doFall(cid)
for rocks = 1, 42 do   --62
    addEvent(fall, rocks*35, cid, master, SEED_BOMBDAMAGE, 1, 54)
end
end

for up = 1, 10 do
    addEvent(upEffect, up*75, cid, 1)
end

doFall(cid)
doMoveInArea2(cid, 2, BigArea2, SEED_BOMBDAMAGE, min, max, spell)


elseif spell == "Reverse Earthshock" then

local p = getThingPosWithDebug(cid)
p.x = p.x+1
p.y = p.y+1

sendEffWithProtect(cid, p, 151)   --send eff

local function doDano(cid)
local pos = getThingPosWithDebug(cid)

    local function doSendBubble(cid, pos)
		if not isCreature(cid) then return true end
		doSendDistanceShoot(getThingPosWithDebug(cid), pos, 39)
		doSendMagicEffect(pos, 239)
	end
	                                                          --alterado!!
	for a = 1, 20 do
	    local r1 = math.random(-4, 4)
	    local r2 = r1 == 0 and choose(-3, -2, -1, 2, 3) or math.random(-3, 3)
	    --
	    local lugar = {x = pos.x + r1, y = pos.y + r2, z = pos.z}
	    addEvent(doSendBubble, a * 25, cid, lugar)
	end

	doDanoWithProtect(cid, ROCKDAMAGE, pos, waterarea, -min, -max, 0)
end

doDano(cid)


elseif spell == "Fury Swipes" then

    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 23)
	doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 152)  
	
	
elseif spell == "Poison Jab" then

    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 15)
	doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 153) 

                       
elseif spell == "Cross Poison" then

doMoveInArea2(cid, 153, cross, POISONDAMAGE, -min, -max, spell)


elseif spell == "Hydro Dance" then

       local eff = {156, 154, 53, 156, 53}
       local area = {psy1, psy2, psy3, psy4, psy5}

       for i = 1, #area do
           addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], WATERDAMAGE, min, max, spell)
       end
	   
elseif spell == "Primordial Attack" then

       local eff = {103, 104, 103, 104, 10}
       local area = {psy1, psy2, psy3, psy4, psy5}

       for i = 1, #area do
           addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], GHOSTDAMAGE, min, max, spell)
       end

elseif spell == "Frenzy Plant" then

        local eff = {893, 892}
        local area = {frenzyplant1, frenzyplant2}
 
        for i = 1, #area do
            addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], GHOSTDAMAGE, min, max, spell)
        end

elseif spell == "Ominous Wind" then

        local eff = {103, 289}
        local area = {frenzyplant1, frenzyplant2}
 
        for i = 1, #area do
            addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], GHOSTDAMAGE, min, max, spell)
        end

elseif spell == "Sun Blast" then

       local eff = {314, 314, 314, 314, 314}
       local area = {psy1, psy2, psy3, psy4, psy5}

       for i = 1, #area do
           addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIREDAMAGE, min, max, spell)
       end
	   
	   elseif spell == "scratching ghost" then

       local eff = {219, 141, 219, 141, 219}
       local area = {psy1, psy2, psy3, psy4, psy5}

       for i = 1, #area do
           addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIREDAMAGE, min, max, spell)
       end
	
elseif spell == "Infected Cloud" then

       local eff = {114, 114, 116, 114, 114}
       local area = {psy1, psy2, psy3, psy4, psy5}

       for i = 1, #area do
           addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIREDAMAGE, min, max, spell)
       end
	   
elseif spell == "Eletric Claw" then

       local eff = {55, 141, 55, 141, 141}
       local area = {psy1, psy2, psy3, psy4, psy5}

       for i = 1, #area do
           addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIREDAMAGE, min, max, spell)
       end
	   
elseif spell == "Ancestral Power" then

       local eff = {142, 142, 142, 142, 142}
       local area = {psy1, psy2, psy3, psy4, psy5}

       for i = 1, #area do
           addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIREDAMAGE, min, max, spell)
       end
	   
elseif spell == "Last Resort" then

       local eff = {252, 252, 252, 252, 252, 252, 252, 252, 252, 252}
       local area = {psy5, psy4, psy3, psy2, psy1, psy5, psy4, psy3, psy2, psy1}

       for i = 1, #area do
           addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIREDAMAGE, min, max, spell)
       end
	   
elseif spell == "Scorching Meteor" then

       local eff = {248, 248, 248, 248, 248}
       local area = {psy1, psy2, psy3, psy4, psy5}

       for i = 1, #area do
           addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIREDAMAGE, min, max, spell)
       end
	   
elseif spell == "Combined Attack" then

       local eff = {390, 390, 390, 390, 390}
       local area = {psy1, psy2, psy3, psy4, psy5}

       for i = 1, #area do
           addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIREDAMAGE, min, max, spell)
       end
	   
elseif spell == "Flying High" then

       local eff = {42, 222, 42, 222, 222}
       local area = {psy1, psy2, psy3, psy4, psy5}

       for i = 1, #area do
           addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIREDAMAGE, min, max, spell)
       end
	   
elseif spell == "Bug Power" then

       local eff = {240, 240, 240, 240, 98}
       local area = {psy1, psy2, psy3, psy4, psy5}

       for i = 1, #area do
           addEvent(doMoveInArea2, i*120, cid, eff[i], area[i], FIREDAMAGE, min, max, spell)
       end
	
       
elseif spell == "Waterfall" then

local function sendStickEff(cid, dir)
    if not isCreature(cid) then return true end
       doAreaCombatHealth(cid, WATERDAMAGE, getPosByDir(getThingPosWithDebug(cid), dir), 0, -min, -max, 156)
	end

	local function doStick(cid)
	if not isCreature(cid) then return true end
	local t = {
	      [1] = SOUTHWEST,
	      [2] = SOUTH,
	      [3] = SOUTHEAST,
	      [4] = EAST,
	      [5] = NORTHEAST,
	      [6] = NORTH,
	      [7] = NORTHWEST,
	      [8] = WEST,
	      [9] = SOUTHWEST,
		}
		for a = 1, 9 do
            sendStickEff(cid, t[a])
		end
	end
	
    stopNow(cid, 1800) 
	doStick(cid, false, cid)
	
elseif spell == "Gyro Ball" then

local ret = {}
ret.id = 0
ret.cd = 9
ret.check = 0
ret.eff = 0
ret.spell = spell


stopNow(cid, 2000)
doMoveInArea2(cid, 156, reto5, STEELDAMAGE, min, max, spell, ret) 

elseif spell == "Rock Tomb" then

local ret = {}
ret.id = target
ret.cd = 9
ret.eff = 0
ret.check = getPlayerStorageValue(target, conds["Slow"])
ret.first = true
ret.cond = "Slow"

        local function doRockFall(cid, frompos, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		    local pos = getThingPosWithDebug(target)
		    local ry = math.abs(frompos.y - pos.y)
		    doSendDistanceShoot(frompos, pos, 39)
		    doMoveDano2(cid, target, ROCKDAMAGE, min, max, ret, spell)
		    sendEffWithProtect(cid, pos, 157)
        end

		local function doRockUp(cid, target)
			if not isCreature(target) or not isCreature(cid) then return true end
		    local pos = getThingPosWithDebug(target)
		    local mps = getThingPosWithDebug(cid)
		    local xrg = math.floor((pos.x - mps.x) / 2)
		    local topos = mps
		    topos.x = topos.x + xrg
		    local rd =  7
		    topos.y = topos.y - rd
		    doSendDistanceShoot(getThingPosWithDebug(cid), topos, 39)
		    doRockFall(cid, topos, target)
		end		

        doRockUp(cid, target)
    
elseif spell == "Sand Tomb" then

local ret = {}
ret.id = 0
ret.cd = 9
ret.eff = 34
ret.check = 0
ret.spell = spell

doMoveInAreaMulti(cid, 22, 158, bullet, bulletDano, GROUNDDAMAGE, min, max, ret)

elseif spell == "Rain Dance" then

local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------
local ret = {}
ret.id = 0
ret.cd = 9
ret.check = 0
ret.eff = 1
ret.cond = "Silence"
---
local function doFall(cid)
for rocks = 1, 42 do --62
    addEvent(fall, rocks*35, cid, master, WATERDAMAGE, 52, 1)
end
end
---
local function doRain(cid)
if isSummon(cid) then 
   doCureBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid, "all")
end                                                      --cura status
doCureStatus(cid, "all")
---
setPlayerStorageValue(cid, 253, 1)  --focus
doSendMagicEffect(getThingPosWithDebug(cid), 132)
---
doMoveInArea2(cid, 0, confusion, WATERDAMAGE, 0, 0, spell, ret)
end
---
doFall(cid)
addEvent(doRain, 1000, cid)

elseif spell == "Intense Rain" then

local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------
local ret = {}
ret.id = 0
ret.cd = 9
ret.check = 0
ret.eff = 28
---
local function doFall(cid)
for rocks = 1, 42 do --62
    addEvent(fall, rocks*35, cid, master, WATERDAMAGE, 52, 68)
end
end
---
local function doRain(cid)
if isSummon(cid) then 
   doCureBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid, "all")
end                                                      --cura status
doCureStatus(cid, "all")
---
setPlayerStorageValue(cid, 253, 1)  --focus
---
doMoveInArea2(cid, 0, confusion, WATERDAMAGE, 0, 0, spell, ret)
end
---
doFall(cid)
addEvent(doRain, 1200, cid)


elseif spell == "Night Slash" then

local p = getThingPosWithDebug(cid)

local t = {
[1] = {eff = 208, area = {x = p.x+1, y = p.y+1, z = p.z}},
[2] = {eff = 505, area = {x = p.x+1, y = p.y+1, z = p.z}},
}

doDanoWithProtect(cid, DARKDAMAGE, t[1].area, 0, min, max, 208)
addEvent(doDanoWithProtect, 800, cid, DARKDAMAGE, t[2].area, 0, min, max, 505)
--[[ doAreaCombatHealth(cid, DARKDAMAGE, p, nightslash, -min, -max, 208) ]]

elseif spell == "Wild Charge" then

local ret = {}                 
ret.id = 0
ret.cd = 9
ret.eff = 48
ret.check = 0
ret.spell = spell


local pos = getThingPosWithDebug(cid)
local areas = {rock5, rock4, rock3, rock2, rock1, rock5, rock4, rock3, rock2, rock1, rock5, rock4, rock3, rock2, rock1}

for i = 1, #areas do
    addEvent(doMoveInArea2, i*320, cid, 48, areas[i], ELECTRICDAMAGE, min, max, spell, ret)
end

elseif spell == "Jump Kick" then   --ver essa

doMoveInAreaMulti(cid, 42, 113, bullet, bulletDano, FIGHTINGDAMAGE, min, max)

elseif spell == "Lava Plume" then                               --alterado v1.8 \/\/\/

doMoveInArea2(cid, 5, cross, FIREDAMAGE, -min, -max, spell)
doMoveInArea2(cid, 87, cross, FIREDAMAGE, 0, 0, spell)

elseif spell == "Silver Wind" then

doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
doDanoWithProtectWithDelay(cid, target, BUGDAMAGE, min, max, 78, SilverWing)

elseif spell == "Bug Buzz" then 

    local ret = {}
    ret.id = 0
    ret.cd = 9
    ret.eff = 0
    ret.check = 0
    ret.spell = spell
        

doMoveInArea2(cid, 86, db1, BUGDAMAGE, min, max, spell, ret)
doMoveInArea2(cid, 86, db1, BUGDAMAGE, 0, 0, spell)

elseif spell == "Whirlpool" then

local function doDano(cid)
if isSleeping(cid) then return true end
      doDanoWithProtect(cid, WATERDAMAGE, getThingPosWithDebug(cid), splash, min, max, 89)
end

setPlayerStorageValue(cid, 3644587, 1)
for r = 0, 10 do  
    addEvent(doDano, 600 * r, cid)
end

elseif spell == "Iron Head" then

doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
doDanoInTargetWithDelay(cid, target, STEELDAMAGE, -min, -max, 77) 

elseif spell == "Brick Beak" then

local ret = {}
ret.id = 0
ret.cd = 9                        
ret.eff = 88
ret.check = 0
ret.first = true
ret.cond = "Paralyze"

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local p = getThingPosWithDebug(cid)
local t = {
[0] = {90, {x=p.x+1, y=p.y-1, z=p.z}},
[1] = {90, {x=p.x+2, y=p.y+1, z=p.z}},   
[2] = {90, {x=p.x+1, y=p.y+2, z=p.z}},
[3] = {90, {x=p.x-1, y=p.y+1, z=p.z}},  
}

doMoveInArea2(cid, 0, BrickBeak, FIGHTINGDAMAGE, min, max, spell, ret)
doSendMagicEffect(t[a][2], t[a][1])


elseif spell == "Volcano Burst" then

local pos = getThingPosWithDebug(cid)

doMoveInArea2(cid, 91, inferno1, FIREDAMAGE, 0, 0, spell)
doDanoWithProtect(cid, FIREDAMAGE, pos, inferno2, -min, -max, 0)

elseif spell == "Hammer Arm" then

local ret = {}
ret.id = 0
ret.cd = 9                        
ret.eff = 88
ret.check = 0
ret.first = true
ret.cond = "Paralyze"

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local p = getThingPosWithDebug(cid)
local t = {
[0] = {92, {x=p.x, y=p.y-1, z=p.z}},
[1] = {94, {x=p.x+2, y=p.y, z=p.z}},   
[2] = {95, {x=p.x+1, y=p.y+2, z=p.z}},
[3] = {93, {x=p.x-1, y=p.y, z=p.z}},  
}

doMoveInArea2(cid, 0, BrickBeak, FIGHTINGDAMAGE, min, max, spell, ret)
doSendMagicEffect(t[a][2], t[a][1])

elseif spell == "Melody" then

local ret = {}
ret.id = 0
ret.cd = math.random(6, 8)
ret.check = 0
ret.first = true                                    --alterado v1.6
ret.cond = "Sleep"
	
doMoveInArea2(cid, 33, selfArea1, NORMALDAMAGE, 0, 0, "Melody", ret)

elseif spell == "Spores Reaction" then

local random = math.random(1, 3)

   if random == 1 then
      local ret = {}
      ret.id = 0
      ret.cd = math.random(2, 3)
      ret.check = 0                   --alterado v1.6
      ret.first = true
      ret.cond = "Sleep"
	
      doMoveInArea2(cid, 27, selfArea1, NORMALDAMAGE, 0, 0, "Spores Reaction", ret)
   elseif random == 2 then 
      local ret = {}
      ret.id = 0
      ret.cd = 6
      ret.eff = 0
      ret.check = 0
      ret.spell = spell
      
    
      doMoveInArea2(cid, 85, confusion, NORMALDAMAGE, 0, 0, "Spores Reaction", ret)    
   else
      local ret = {}
      ret.id = 0
      ret.cd = math.random(6, 10)
      ret.check = 0
      local lvl = isSummon(cid) and getMasterLevel(cid) or getMasterLevel(cid)     --alterado v1.6
      ret.damage = math.floor((getMasterLevel(cid)+lvl)/2)
      ret.cond = "Poison"                              

      doMoveInArea2(cid, 84, confusion, NORMALDAMAGE, 0, 0, "Spores Reaction", ret) 
   end

elseif spell == "Demon Puncher" then

   local name = getCreatureName(cid)
                                                                                                             --alterado v1.7
if (not hitmonchans[name] and isCreature(target)) or (isCreature(target) and math.random(1, 100) <= passivesChances["Demon Puncher"][name]) then 
                                                        
       if getDistanceBetween(getThingPosWithDebug(cid), getThingPosWithDebug(target)) > 1 then
       return true
       end
       
       if not isSummon(cid) then       --alterado v1.7
         doCreatureSay(cid, string.upper(spell).."!", TALKTYPE_MONSTER)
       end                                 
         
         if ehMonstro(cid) or not hitmonchans[name] then
            hands = 0
         else
            hands = getItemAttribute(getPlayerSlotItem(getCreatureMaster(cid), 8).uid, "hands")
         end
         
         if not hitmonchans[name] then
            tabela = hitmonchans[getCreatureName(target)][hands]
         else
            tabela = hitmonchans[name][hands]
         end
          
         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)

         if tabela then
            doTargetCombatHealth(cid, target, tabela.type, -min, -max, 255)
         end
         
         local alvo = getThingPosWithDebug(target)
         alvo.x = alvo.x + 1                           ---alterado v1.7
         
         if hands == 4 then
            doSendMagicEffect(alvo, tabela.eff)
         else
            doSendMagicEffect(getThingPosWithDebug(target), tabela.eff)
         end
         
         if hands == 3 then
            local ret = {}
            ret.id = target
            ret.cd = 9                     --alterado v1.6
            ret.eff = 43
            ret.check = getPlayerStorageValue(target, conds["Slow"])
            ret.first = true
            ret.cond = "Slow"
         
            doMoveDano2(cid, target, FIGHTINGDAMAGE, 0, 0, ret, spell)
         end  
end


end
return true 
end