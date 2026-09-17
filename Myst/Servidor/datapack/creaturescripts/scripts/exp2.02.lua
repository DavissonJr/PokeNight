local combats = {          
	[PSYCHICDAMAGE] = {cor = COLOR_PSYCHIC},
	[GRASSDAMAGE] = {cor = COLOR_GRASS},
	[POISONEDDAMAGE] = {cor = COLOR_GRASS},
	[FIREDAMAGE] = {cor = COLOR_FIRE2},                         
	[BURNEDDAMAGE] = {cor = COLOR_BURN},
	[WATERDAMAGE] = {cor = COLOR_WATER},
	[ICEDAMAGE] = {cor = COLOR_ICE},
	[NORMALDAMAGE] = {cor = COLOR_NORMAL},
	[FLYDAMAGE] = {cor = COLOR_FLYING},           
	[GHOSTDAMAGE] = {cor = COLOR_GHOST},
	[GROUNDDAMAGE] = {cor = COLOR_GROUND},
	[ELECTRICDAMAGE] = {cor = COLOR_ELECTRIC},
	[ROCKDAMAGE] = {cor = COLOR_ROCK},
	[BUGDAMAGE] = {cor = COLOR_BUG},
	[FIGHTDAMAGE] = {cor = COLOR_FIGHTING},
	[DRAGONDAMAGE] = {cor = COLOR_DRAGON},
	[POISONDAMAGE] = {cor = COLOR_POISON},
	[DARKDAMAGE] = {cor = COLOR_DARK},               
	[STEELDAMAGE] = {cor = COLOR_STEEL},
	[MIRACLEDAMAGE] = {cor = COLOR_PSYCHIC},  
	[DARK_EYEDAMAGE] = {cor = COLOR_GHOST},
	[SEED_BOMBDAMAGE] = {cor = COLOR_GRASS},
	[SACREDDAMAGE] = {cor = COLOR_FIRE2}, 
	[MUDBOMBDAMAGE] = {cor = COLOR_GROUND}, --alterado v1.9
}

local function sendPlayerDmgMsg(cid, text)
	if not isCreature(cid) then return true end
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, text)
end

local races = {
[4] = {cor = COLOR_FIRE2},
[6] = {cor = COLOR_WATER},
[7] = {cor = COLOR_NORMAL},
[8] = {cor = COLOR_FIRE2},
[9] = {cor = COLOR_FIGHTING},
[10] = {cor = COLOR_FLYING},
[11] = {cor = COLOR_GRASS},
[12] = {cor = COLOR_POISON},
[13] = {cor = COLOR_ELECTRIC},
[14] = {cor = COLOR_GROUND},
[15] = {cor = COLOR_PSYCHIC},
[16] = {cor = COLOR_ROCK},
[17] = {cor = COLOR_ICE},
[18] = {cor = COLOR_BUG},
[19] = {cor = COLOR_DRAGON},
[20] = {cor = COLOR_GHOST},
[21] = {cor = COLOR_STEEL},
[22] = {cor = COLOR_DARK},
[1] = {cor = 180},
[2] = {cor = 180},
[3] = {cor = 180},
[5] = {cor = 180},
}

local damages = {GROUNDDAMAGE, ELECTRICDAMAGE, ROCKDAMAGE, FLYDAMAGE, BUGDAMAGE, FIGHTINGDAMAGE, DRAGONDAMAGE, POISONDAMAGE, DARKDAMAGE, STEELDAMAGE}
local fixdmgs = {PSYCHICDAMAGE, COMBAT_PHYSICALDAMAGE, GRASSDAMAGE, FIREDAMAGE, WATERDAMAGE, ICEDAMAGE, NORMALDAMAGE, GHOSTDAMAGE}
local ignored = {POISONEDDAMAGE, BURNEDDAMAGE}                
local cannotkill = {BURNEDDAMAGE, POISONEDDAMAGE}

function onStatsChange(cid, attacker, type, combat, value)
if not isCreature(attacker) then  
	if not isInArray(fixdamages, combat) and combats[combat] then
		doSendAnimatedText(getThingPos(cid), value, combats[combat].cor)
	end
return true
end

-- Thalles Vitor - Horder --
if isMonster(attacker) and isSummon(cid) then
	onSpawnHorderLeaderToPlayer(attacker, getCreatureMaster(cid))
end

if isMonster(attacker) and isPlayer(cid) then
	onSpawnHorderLeaderToPlayer(attacker, cid)
end

if isSummon(attacker) and isMonster(cid) then
	onSpawnHorderLeaderToPlayer(cid, getCreatureMaster(attacker))
end

-- Thalles Vitor - Buffs --
	if isSummon(attacker) and isPlayer(getCreatureMaster(attacker)) and isCreature(cid) then
		local player = getCreatureMaster(attacker)
		if isInArray({2031, 2032}, getCreatureOutfit(player).lookType) and combat == WATERDAMAGE then
			value = value * 1.2
			doSendAnimatedText(getThingPos(attacker), "+BUFF WATER BIKE", COLOR_WATER)
		end

		if isInArray({2029, 2030}, getCreatureOutfit(player).lookType) and combat == ELECTRICDAMAGE then
			value = value * 1.2
			doSendAnimatedText(getThingPos(attacker), "+BUFF ELECTRIC BIKE", COLOR_YELLOW)
		end

		if isInArray({2035, 2036}, getCreatureOutfit(player).lookType) and combat == FIREDAMAGE then
			value = value * 1.2
			doSendAnimatedText(getThingPos(attacker), "+BUFF ELECTRIC BIKE", COLOR_FIRE2)
		end
	end
--

-- Thalles Vitor - Guardian --
if isMonster(attacker) and tonumber(getPlayerStorageValue(attacker, GUARDIAN_STORAGE_ISGUARDIAN)) >= 1 then
	local stor2 = tonumber(getPlayerStorageValue(attacker, GUARDIAN_STORAGE_ISGUARDIAN)) or 0
	doSendAnimatedText(getThingPos(cid), value, math.random(0, 255))
	doCreatureAddHealth(cid, -value)
end
--

local damageCombat = combat
--------------------------------------------------
if type == STATSCHANGE_HEALTHGAIN then
	if cid == attacker then
		return true
	end
	if isSummon(cid) and isSummon(attacker) and canAttackOther(cid, attacker) == "Cant" then
		return false
	end
	return true
end

if isPlayer(attacker) then
	local valor = value
	if valor > getCreatureHealth(cid) then
		valor = getCreatureHealth(cid)
	end

	if combat == COMBAT_PHYSICALDAMAGE then
		return false
	end

	if combat == PHYSICALDAMAGE then
		doSendMagicEffect(getThingPos(cid), 3)
		doSendAnimatedText(getThingPos(cid), valor, races[getMonsterInfo(getCreatureName(cid)).race].cor)
	end

	if combats[damageCombat] and not isInArray(fixdmgs, damageCombat) then
		doSendAnimatedText(getThingPos(cid), valor, combats[damageCombat].cor)
	end

	if #getCreatureSummons(attacker) >= 1 and not isInArray({POISONEDDAMAGE, BURNEDDAMAGE}, combat) then
		doPlayerSendTextMessage(attacker, MESSAGE_STATUS_DEFAULT, "Your "..getPokeName(getCreatureSummons(attacker)[1]).." dealt "..valor.." damage to "..getSomeoneDescription(cid)..".")
	end
	return true
end

if isPlayer(cid) and #getCreatureSummons(cid) >= 1 and type == STATSCHANGE_HEALTHLOSS then
	return false                                                                           
end

if isPlayer(cid) and #getCreatureSummons(cid) <= 0 and type == STATSCHANGE_HEALTHLOSS then

	if isSummon(attacker) or isPlayer(attacker) then
		if canAttackOther(cid, attacker) == "Cant" then 
			return false 
		end
	end

	local valor = 0
	if combat == COMBAT_PHYSICALDAMAGE then
		valor = getOffense(attacker)
	else
		valor = getSpecialAttack(attacker)
	end

	valor = valor * playerDamageReduction
	valor = valor * math.random(83, 117) / 100
	valor = valor / math.ceil(getPlayerLevel(cid) / 55)

	if getTileInfo(getCreaturePosition(cid)).pvp then
		valor = valor / 5
	end

	if valor >= getCreatureHealth(cid) then
		valor = getCreatureHealth(cid)
	end

	valor = math.floor(valor)

    if valor >= getCreatureHealth(cid) then
       if getPlayerStorageValue(cid, 6598754) >= 1 or getPlayerStorageValue(cid, 6598755) >= 1 then
          setPlayerStorageValue(cid, 6598754, -1)
          setPlayerStorageValue(cid, 6598755, -1)
          doRemoveCondition(cid, CONDITION_OUTFIT)             
          doTeleportThing(cid, posBackPVP, false)
          doCreatureAddHealth(cid, getCreatureMaxHealth(cid))
          return false --alterado v1.8
       end

       if getPlayerStorageValue(cid, 98796) >= 1 then
          setPlayerStorageValue(cid, 98796, -1) 
          setPlayerStorageValue(cid, 98797, -1)                      --alterado v1.8
          doTeleportThing(cid, SafariOut, false)
          doSendMagicEffect(getThingPos(cid), 21)
          doPlayerSendTextMessage(cid, 27, "You die in the saffari... Best luck in the next time!")
          return false --alterado v1.8
	   end

	   if getPlayerSex(cid) == 0 then
		doSendMagicEffect(getThingPos(cid), 366)
	   else
		doSendMagicEffect(getThingPos(cid), 367)
	   end
    end

	doCreatureAddHealth(cid, -valor, 3, 180)
	if not isPlayer(cid) then
	   sendPlayerDmgMsg(cid, "You lost "..valor.." hitpoints due to an attack from "..getSomeoneDescription(attacker)..".")
	end
	return false
end
--------------------------------------------------
if isMonster(attacker) and getPlayerStorageValue(attacker, 201) ~= -1 then
	if isPlayer(cid) then
		return false
	end

	if getPlayerStorageValue(getCreatureMaster(cid), ginasios[getPlayerStorageValue(attacker, 201)].storage) ~= 1 then
		return false
	end
end

--------------------------------------------------
if isMonster(cid) and getPlayerStorageValue(cid, 201) ~= -1 then
	if getPlayerStorageValue(getCreatureMaster(attacker), ginasios[getPlayerStorageValue(cid, 201)].storage) ~= 1 then
		return false
	end
end


if ehMonstro(cid) and ehMonstro(attacker) and not isSummon(cid) and not isSummon(attacker) then 
	return false                                          --alterado v1.9 /\
end

--------------------------------------------------
--------------------REFLECT-----------------------
if isCreature(cid) and getPlayerStorageValue(cid, 21099) >= 1 and combat ~= COMBAT_PHYSICALDAMAGE then
   if not isInArray({"Team Claw", "Team Slice"}, getPlayerStorageValue(attacker, 21102)) then
      doSendMagicEffect(getThingPosWithDebug(cid), 135)
      doSendAnimatedText(getThingPosWithDebug(cid), "REFLECT", COLOR_GRASS)
      docastspell(cid, getPlayerStorageValue(attacker, 21102))
      if getCreatureName(cid) == "Wobbuffet" then
         doRemoveCondition(cid, CONDITION_OUTFIT)    
      end
      setPlayerStorageValue(cid, 21099, -1)                    
      setPlayerStorageValue(cid, 21100, 1)
      setPlayerStorageValue(cid, 21101, attacker)

	  if getTableMove(attacker, getPlayerStorageValue(attacker, 21102)) and getTableMove(attacker, getPlayerStorageValue(attacker, 21102)).f then
      	setPlayerStorageValue(cid, 21103, getTableMove(attacker, getPlayerStorageValue(attacker, 21102)).f)
      else
		setPlayerStorageValue(cid, 21103, getTableMove(attacker, math.random(50, 100)))
	  end

	  setPlayerStorageValue(cid, 21104, getCreatureOutfit(attacker).lookType)
      return false
   end
end
-------------------------------------------------

local multiplier = 1
if isMonster(cid) and isMonster(attacker) then
	local type1 = pokes[getCreatureName(cid)] and pokes[getCreatureName(cid)].type and pokes[getCreatureName(cid)].type or "no type"
	local type2 = pokes[getCreatureName(cid)].type2 and pokes[getCreatureName(cid)].type2 and pokes[getCreatureName(cid)].type2 or "no type"

	if combats[damageCombat] then
		if isInArray(effectiveness[damageCombat].super, type1) then
			value = value * 1.5
			doSendAnimatedText(getThingPos(cid), "SUPER", combats[damageCombat].cor)
		end

		if isInArray(effectiveness[damageCombat].super, type2) then
			value = value * 1.5
			doSendAnimatedText(getThingPos(cid), "SUPER", combats[damageCombat].cor)
		end

		if isInArray(effectiveness[damageCombat].weak, type1) then
			value = value / 1.2
			doSendAnimatedText(getThingPos(cid), "WEAK", combats[damageCombat].cor)
		end

		if isInArray(effectiveness[damageCombat].weak, type2) then
			value = value / 1.2
			doSendAnimatedText(getThingPos(cid), "WEAK", combats[damageCombat].cor)
		end

		if isInArray(effectiveness[damageCombat].non, type1) then
			value = 0
			doSendAnimatedText(getThingPos(cid), "NULL", combats[damageCombat].cor)
		end

		if isInArray(effectiveness[damageCombat].non, type2) then
			value = 0
			doSendAnimatedText(getThingPos(cid), "NULL", combats[damageCombat].cor)
		end
	else
		--print(damageCombat .. " nao registrado na tabela.")
	end
end
   
if getCreatureCondition(cid, CONDITION_INVISIBLE) then
	return false
end

local valor = value
if isSummon(cid) and isSummon(attacker) then
    if getCreatureMaster(cid) == getCreatureMaster(attacker) then
        return false
    end
	
	if canAttackOther(cid, attacker) == "Cant" then
        return false
    end
end

valor = valor * multiplier
if isSummon(attacker) then
	valor = valor * getHappinessRate(attacker)
else
	valor = valor
end
                                                              
valor = math.floor(valor)                                 
if combat == COMBAT_PHYSICALDAMAGE then
    local value = getOffense(attacker) > 1000 and 3 or 2
    block = 1 - (getDefense(cid) / (getOffense(attacker) + getDefense(cid))) --alterado v1.9 testem essa nova formula plzzz '--'
	valor = (getOffense(attacker)/value) * block
	   
	if valor <= 0 then
	    valor = math.random(5, 10) --alterado v1.9
    end
	   
    valor = valor / getDefense(cid)

    if isCreature(attacker) and getPlayerStorageValue(attacker, conds["Fear"]) >= 1 then         
    	return true
    end

	local p = getThingPos(cid)                     
	if p.x == 1 and p.y == 1 and p.z == 10 then
		return false                                    
	end

	if isCreature(cid) and getPlayerStorageValue(cid, 9658783) == 1 then
		return false
	end
 
	if valor >= getCreatureHealth(cid) then
		if isInArray(cannotKill, combat) and isPlayer(cid) then
			valor = getCreatureHealth(cid) - 1
		else
			valor = getCreatureHealth(cid)
		end
	end

	valor = math.floor(valor)  
end          

if combat == SACREDDAMAGE and not ehNPC(cid) then    
	local ret = {}
	ret.id = cid
	ret.cd = 9
	ret.check = getPlayerStorageValue(cid, conds["Silence"])
	ret.eff = 39
	ret.cond = "Silence"

	doCondition2(ret)
elseif combat == MUDBOMBDAMAGE and not ehNPC(cid) then
	local ret = {}                                        
	ret.id = cid
	ret.cd = 9
	ret.eff = 34
	ret.check = getPlayerStorageValue(cid, conds["Miss"])
	ret.spell = "Mud Bomb"       --alterado v1.9
		
	doCondition2(ret)
end

valor = math.abs(valor)    --alterado v1.9
if isSummon(attacker) then
	if combat == COMBAT_PHYSICALDAMAGE then
		doTargetCombatHealth(getCreatureMaster(attacker), cid, PHYSICALDAMAGE, -valor, -valor, 255)
		doDoubleHit(attacker, cid, valor, races)      
	else
		doTargetCombatHealth(getCreatureMaster(attacker), cid, damageCombat, -valor, -valor, 255)
	end
else
	if combat ~= COMBAT_PHYSICALDAMAGE and combats[damageCombat] then
		doCreatureAddHealth(cid, -valor, 3, combats[damageCombat].cor)  
	else
		if getMonsterInfo(getCreatureName(cid)) ~= false and races[getMonsterInfo(getCreatureName(cid)).race] then
			doCreatureAddHealth(cid, -valor, 3, races[getMonsterInfo(getCreatureName(cid)).race].cor)
		end
				
		doDoubleHit(attacker, cid, valor, races)   
	end

	if isSummon(cid) and valor ~= 0 then
		updateLifeBarPokemon(getCreatureMaster(cid)) -- Thalles
		sendPlayerDmgMsg(getCreatureMaster(cid), "Your "..getCreatureName(cid).." lost "..valor.." hitpoints due to an attack from "..getSomeoneDescription(attacker)..".")
			
		local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
		if item.uid <= 0 then return true end
		sendGoPokemonInfo(getCreatureMaster(cid), item, cid)
	end
end
	
if damageCombat == FIREDAMAGE and not isBurning(cid) then
	local ret = {}
	ret.id = cid
	ret.cd = math.random(5, 12)
	ret.check = getPlayerStorageValue(cid, conds["Burn"])
	ret.damage = isSummon(attacker) and getMasterLevel(attacker)+getPokemonBoost(attacker) or getPokemonLevel(attacker)
	ret.cond = "Burn"
		
	doCondition2(ret)
elseif damageCombat == POISONDAMAGE and not isPoisoned(cid) then
	local ret = {}
	ret.id = cid
	ret.cd = math.random(6, 15)
	ret.check = getPlayerStorageValue(cid, conds["Poison"])
		
	local lvl = isSummon(attacker) and getMasterLevel(attacker) or getPokemonLevel(attacker)
	ret.damage = math.floor((getPokemonLevel(attacker)+lvl)/2)
	ret.cond = "Poison"
		
	doCondition2(ret)
end
return false
end