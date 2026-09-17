conds = {
["Slow"] = 3890,
["Confusion"] = 3891,  
["Burn"] = 3892,
["Poison"] = 3893,
["Fear"] = 3894,
["Stun"] = 3895,
["Paralyze"] = 3896,                               --alterado v2.6 \/ peguem o script todo!
["Leech"] = 3897,
["Buff1"] = 3898,
["Buff2"] = 3899,
["Buff3"] = 3900,
["Miss"] = 32659,   
["Silence"] = 32698,     
["Sleep"] = 98271,
}

injuries2 = {
[1] = {n = "slow", m = 3890},
[2] = {n = "confuse", m = 3891},  
[3] = {n = "burn", m = 3892},
[4] = {n = "poison", m = 3893},
[5] = {n = "fear", m = 3894},
[6] = {n = "stun", m = 3895},
[7] = {n = "paralyze", m = 3896},
[8] = {n = "leech", m = 3897},
[9] = {n = "Buff1", m = 3898},
[10] = {n = "Buff2", m = 3899},
[11] = {n = "Buff3", m = 3900},
[12] = {n = "miss", m = 32659},   
[13] = {n = "silence", m = 32698},     
[14] = {n = "sleep", m = 98271},
}

Buffs = {
[1] = {"Buff1", 3898},
[2] = {"Buff2", 3899},
[3] = {"Buff3", 3900},
}

paralizeArea2 = createConditionObject(CONDITION_PARALYZE)
setConditionParam(paralizeArea2, CONDITION_PARAM_TICKS, 50000)
setConditionFormula(paralizeArea2, -0.63, -0.63, -0.63, -0.63)

local roardirections = {
[NORTH] = {SOUTH},
[SOUTH] = {NORTH},
[WEST] = {EAST},           --edited sistema de roar
[EAST] = {WEST}}

function doSendSleepEffect(cid)
	if not isCreature(cid) or not isSleeping(cid) then return true end
	doSendMagicEffect(getThingPos(cid), 32)
	addEvent(doSendSleepEffect, 1500, cid)
end

local outFurys = {
["Shiny Charizard"] = {outFury = 1073},  
["Shiny Blastoise"] = {outFury = 1074},    
}

local outImune = {
["Camouflage"] = 1445,
["Acid Armor"] = 1453,
["Iron Defense"] = 1401,
["Minimize"] = 1455,
["Future Sight"] = 1446,
}
            
local function transBack(cid)
if isCreature(cid) then
   if getPlayerStorageValue(cid, 974848) >= 1 then
      setPlayerStorageValue(cid, 974848, 0)
      doRemoveCondition(cid, CONDITION_OUTFIT)
   end
end
end

function doCondition2(ret)
--
function doMiss2(cid, cd, eff, check, spell)
local stg = conds["Miss"]
end 

function doSilence2(cid, cd, eff, check)
local stg = conds["Silence"]
    if not isCreature(cid) then return true end  --is creature?
	if isPlayer(cid) then return true end  --is creature?	
    if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
       setPlayerStorageValue(cid, stg, cd)    --allterado v2.8
       return true 
    end
    
    if not check and getPlayerStorageValue(cid, stg) >= 1 then
       setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
    else
       setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
    end
           
    local a = getPlayerStorageValue(cid, stg)
           
    if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
       local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
       doItemSetAttribute(item.uid, "silence", a)
       doItemSetAttribute(item.uid, "silenceEff", eff)
    end
	
    if a <= -1 then 
      setPlayerStorageValue(cid, stg, -1)
      return true 
    end
        
    doSendMagicEffect(getThingPos(cid), eff)
    addEvent(doSilence2, 1000, cid, -1, eff, a)   
end       

function doSlow2(cid, cd, eff, check, first)
local stg = conds["Slow"]
end    

function doConfusion2(cid, cd, check)
local stg = conds["Confusion"]
    if not isCreature(cid) then 
      return true
    end

    if isPlayer(cid) then 
      return true 
    end	

    if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
       setPlayerStorageValue(cid, stg, cd)
       return true 
    end
    
    if not check and getPlayerStorageValue(cid, stg) >= 1 then
       setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
    else
       setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
    end
           
    local a = getPlayerStorageValue(cid, stg)   
    if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
       local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
       doItemSetAttribute(item.uid, "confuse", a)
    end
	
    if a <= -1 then 
    if getCreatureCondition(cid, CONDITION_PARALYZE) == true then
       doRemoveCondition(cid, CONDITION_PARALYZE)
	    doAddCondition(cid, paralizeArea2)            
    end

    if not isSleeping(cid) and not isParalyze(cid) then
       doRegainSpeed(cid)            --alterado 
    end

    setPlayerStorageValue(cid, stg, -1)
    return true 
    end
    
    if math.random(1, 6) >= 4 then
		doSendMagicEffect(getThingPos(cid), 31)
	 end

    local isTarget = isSummon(cid) and getCreatureTarget(getCreatureMaster(cid)) or getCreatureTarget(cid)
    if isCreature(isTarget) and not isSleeping(cid) and not isParalyze(cid) and getPlayerStorageValue(cid, 654878) <= 0 then --alterado v2.6
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, 100)
      doPushCreature(cid, math.random(0, 3), 1, 0)    --alterado v2.6
		doChangeSpeed(cid, -100)
	end

	local pos = getThingPos(cid)
	addEvent(doSendMagicEffect, math.random(0, 450), pos, 31)
   addEvent(doConfusion2, 1000, cid, -1, a)   
end           

function doBurn2(cid, cd, check, damage)
local stg = conds["Burn"]
    if not isCreature(cid) then 
      return true 
    end

    if isPlayer(cid) then 
      return true 
    end

    if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
       setPlayerStorageValue(cid, stg, cd)
       return true 
    end
    
    if not check and getPlayerStorageValue(cid, stg) >= 1 then
       setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
    else
       setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
    end
           
    local a = getPlayerStorageValue(cid, stg) 
    if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
       local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
       doItemSetAttribute(item.uid, "burn", a)
       doItemSetAttribute(item.uid, "burndmg", damage)
    end
	
    if a <= -1 then 
      setPlayerStorageValue(cid, stg, -1)
      return true 
    end
    
    doCreatureAddHealth(cid, -damage, 15, COLOR_BURN)  
    addEvent(doBurn2, 3500, cid, -1, a, damage)   
end 

function doPoison2(cid, cd, check, damage)
   local stg = conds["Poison"]
   if not isCreature(cid) then 
      return true 
   end

   if isPlayer(cid) then 
      return true 
   end

   if isSummon(cid) or ehMonstro(cid) and pokes[getCreatureName(cid)] then --alterado v2.6
       local type = pokes[getCreatureName(cid)].type
       local type2 = pokes[getCreatureName(cid)].type2
       if isInArray({"poison", "steel"}, type) or isInArray({"poison", "steel"}, type2) then
          return true
       end
   end

   if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
      setPlayerStorageValue(cid, stg, cd)    --allterado v2.8
      return true 
   end
    
   if not check and getPlayerStorageValue(cid, stg) >= 1 then
      setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
   else
      setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
   end
           
   local a = getPlayerStorageValue(cid, stg)      
   if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
      local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
      doItemSetAttribute(item.uid, "poison", a)
      doItemSetAttribute(item.uid, "poisondmg", damage)
   end
	
   if a <= -1 or getCreatureHealth(cid) == 1 then 
      setPlayerStorageValue(cid, stg, -1)
      return true 
   end
   
	if damage == nil then
	   damage = 2000
	end

   local dano = getCreatureHealth(cid)-damage <= 0 and getCreatureHealth(cid)-1 or damage 
   doCreatureAddHealth(cid, -dano, 8, COLOR_GRASS)  
    
   addEvent(doPoison2, 1500, cid, -1, a, damage)   
end       

function doFear2(cid, cd, check, skill)
   local stg = conds["Fear"]
   if not isCreature(cid) then 
      return true 
   end

   if isPlayer(cid) then 
      return true 
   end

   if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
      setPlayerStorageValue(cid, stg, cd)    --allterado v2.8
      return true 
   end
    
   if not check and getPlayerStorageValue(cid, stg) >= 1 then
      setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
   else
      setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
   end
           
   local a = getPlayerStorageValue(cid, stg)      
   if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
       local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
       doItemSetAttribute(item.uid, "fear", a)
       doItemSetAttribute(item.uid, "fearSkill", skill)
   end
	
   if a <= -1 then 
    if getCreatureCondition(cid, CONDITION_PARALYZE) == true then
       doRemoveCondition(cid, CONDITION_PARALYZE)
	    doAddCondition(cid, paralizeArea2)            
    end
    
    if not isSleeping(cid) and not isParalyze(cid) then
       doRegainSpeed(cid) 
    end

    setPlayerStorageValue(cid, stg, -1)
    return true 
   end
    
   if skill == "Roar" then
      eff = 244
   else
      eff = 139
   end
    
   if math.random(1, 6) >= 4 then
		doSendMagicEffect(getThingPos(cid), eff)
	end

   local isTarget = isSummon(cid) and getCreatureTarget(getCreatureMaster(cid)) or getCreatureTarget(cid)
   if isCreature(isTarget) and not isSleeping(cid) and not isParalyze(cid) and getPlayerStorageValue(cid, 654878) <= 0 then --alterado v2.6
		local dir = getCreatureDirectionToTarget(cid, isTarget)
      doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, 100)
      doPushCreature(cid, roardirections[dir][1], 1, 0)  --alterado v2.6
		doChangeSpeed(cid, -100)
	end

	local pos = getThingPos(cid)
	addEvent(doSendMagicEffect, math.random(0, 450), pos, eff)
   addEvent(doFear2, 1000, cid, -1, a, skill)   
end      

function doStun2(cid, cd, eff, check, spell)
local stg = conds["Stun"]
end 

function doParalyze2(cid, cd, eff, check, first)
local stg = conds["Paralyze"]
end       

function doSleep2(cid, cd, check, first)        
   local stg = conds["Sleep"]
   if not isCreature(cid) then 
      return true 
   end

   if isPlayer(cid) then 
      return true 
   end

   if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
      setPlayerStorageValue(cid, stg, cd)    --allterado v2.8
      return true 
   end
    
   if not isSleeping(cid) then
		addEvent(doSendSleepEffect, 500, cid)
	end
	
   if not check and getPlayerStorageValue(cid, stg) >= 1 then
      setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
   else
      setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
   end
           
   local a = getPlayerStorageValue(cid, stg)      
   if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
      local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
      doItemSetAttribute(item.uid, "sleep", a)
   end
	
   if a <= -1 then 
      if getCreatureCondition(cid, CONDITION_PARALYZE) == true then
         doRemoveCondition(cid, CONDITION_PARALYZE)
         doAddCondition(cid, paralizeArea2)            
      end
      
      if not isParalyze(cid) then
         doRegainSpeed(cid)
      end
      setPlayerStorageValue(cid, stg, -1)
    return true 
   end
                                      --alterado v2.6
   doChangeSpeed(cid, -getCreatureSpeed(cid))
   addEvent(doSleep2, 1000, cid, -1, a, false)
end   

function doLeech2(cid, attacker, cd, check, damage)
   local stg = conds["Leech"]
   if not isCreature(cid) then 
      return true 
   end

   if isPlayer(cid) then 
      return true 
   end

   if attacker ~= 0 and not isCreature(attacker) then 
      return true 
   end

   if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
      setPlayerStorageValue(cid, stg, cd)    --allterado v2.8
      return true 
   end
    
   if not check and getPlayerStorageValue(cid, stg) >= 1 then
      setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
   else
      setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
   end
           
   local a = getPlayerStorageValue(cid, stg)       
   if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
      local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
      doItemSetAttribute(item.uid, "leech", a)
      doItemSetAttribute(item.uid, "leechdmg", damage)
   end
	
   if a <= -1 then 
    setPlayerStorageValue(cid, stg, -1)
    return true 
   end

   if damage == nil or not damage then
      damage = 100
   end
    
   local life = getCreatureHealth(cid)
   doCreatureAddHealth(cid, -damage)
   doSendAnimatedText(getThingPos(cid), "-"..damage.."", 144)
   doSendMagicEffect(getThingPos(cid), 45)

   local newlife = life - getCreatureHealth(cid)
   if newlife >= 1 and attacker ~= 0 then
      doSendMagicEffect(getThingPos(attacker), 14)
      doCreatureAddHealth(attacker, newlife)
      doSendAnimatedText(getThingPos(attacker), "+"..newlife.."", 32)
   end

   addEvent(doLeech2, 2000, cid, attacker, -1, a, damage)   
end 

function doBuff2(cid, cd, eff, check, buff, first, attr)
    if not isCreature(cid) then 
      return true 
   end

   if isPlayer(cid) then 
      return true 
   end 

   local atributo = attr and attr or ""
   if atributo == "" then 
      return true 
   end

   if ehMonstro(cid) then 
      atributo = "Buff1" 
   end


   local stg = conds[atributo]
   if getPlayerStorageValue(cid, stg) >= 1 and cd ~= -1 then 
      return true 
   end

   if not check and getPlayerStorageValue(cid, stg) >= 1 then
      setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd - 1)
   else
      setPlayerStorageValue(cid, stg, getPlayerStorageValue(cid, stg) + cd)
   end
           
   local a = getPlayerStorageValue(cid, stg)      
   if isSummon(cid) and getPlayerStorageValue(cid, 212123) <= 0 then
      local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
      doItemSetAttribute(item.uid, atributo, a)
      doItemSetAttribute(item.uid, atributo.."eff", eff)
      doItemSetAttribute(item.uid, atributo.."skill", buff)
   end
	
   if a <= -1 then               --alterado v2.6                                      
    setPlayerStorageValue(cid, stg, -1)      
    return true 
   end
     
   doSendMagicEffect(getThingPos(cid), eff)    
   if first then
      if buff == "Strafe" or buff == "Agility" then
         setPlayerStorageValue(cid, 374896, 1) --velo atk --alterado v2.6
         doRaiseStatus(cid, 0, 0, 100, a)
      elseif buff == "Tailwind" then
         doRaiseStatus(cid, 0, 0, 200, a)
      elseif buff == "Rage" then
         doRaiseStatus(cid, 2, 0, 0, a)
      elseif buff == "Harden" then
         doRaiseStatus(cid, 0, 2, 0, a)
      elseif buff == "Calm Mind" then
         doRaiseStatus(cid, 0, 2, 0, a)
      elseif buff == "Ancient Fury" then
         if outFurys[getCreatureName(cid)] then
         doSetCreatureOutfit(cid, {lookType = outFurys[getCreatureName(cid)].outFury}, a*1000)
         end
         setPlayerStorageValue(cid, 374896, 1)  --velo atk
         if getCreatureName(cid) == "Shiny Charizard" then 
            doRaiseStatus(cid, 2, 0, 0, a)    --atk melee     --alterado v2.6
         else
            doRaiseStatus(cid, 0, 2, 0, a)    --def
         end   
         setPlayerStorageValue(cid, 625877, outFurys[getCreatureName(cid)].outFury)     --alterado v2.6
      elseif buff == "War Dog" then
         doRaiseStatus(cid, 1.5, 1.5, 0, a)
         setPlayerStorageValue(cid, 374896, 1)  --velo atk
      elseif buff == "Rest" then
         doSleep2(cid, cd, getPlayerStorageValue(cid, conds["Sleep"]), true) 
         doCreatureAddHealth(cid, getCreatureMaxHealth(cid))
      elseif isInArray({"Fighter Spirit", "Furious Legs", "Ultimate Champion"}, buff) then
         doRaiseStatus(cid, 1.5, 0, 0, a)    --atk melee    --alterado v2.6
         setPlayerStorageValue(cid, 374896, 1)  --velo atk 
         addEvent(setPlayerStorageValue, a*1000, cid, 465987, -1)                                              
      elseif isInArray({"Future Sight", "Camouflage", "Acid Armor", "Iron Defense", "Minimize"}, buff) then
         doSetCreatureOutfit(cid, {lookType = outImune[buff]}, -1)
         setPlayerStorageValue(cid, 9658783, 1)  
         setPlayerStorageValue(cid, 625877, outImune[buff]) --alterado v2.6                             
      elseif buff == "Bug Fighter" then
         setPlayerStorageValue(cid, 374896, 1)  --velo atk  --alterado v2.6
         doRaiseStatus(cid, 1.5, 1.5, 100, a)
         doSetCreatureOutfit(cid, {lookType = 1448}, a*1000)
         setPlayerStorageValue(cid, 625877, 1448)  --alterado v2.6
      end                                                                            
    end

    addEvent(doBuff2, 1000, cid, -1, eff, a, buff, false, atributo)   
end
 
if ret.buff and ret.buff ~= "" then
   doBuff2(ret.id, ret.cd, ret.eff, ret.check, ret.buff, ret.first, (ret.attr and ret.attr or false))
end

if isSummon(ret.id) and getPokemonBoost(ret.id) ~= 0 and math.random(1, 100) <= getPokemonBoost(ret.id) then   --sistema "pegou no boost"
   if ret.cond and not isInArray({"Poison", "Burn", "Leech", "Fear"}, ret.cond) then   --alterado v2.6
      doSendAnimatedText(getThingPosWithDebug(ret.id), "BOOST", 215)   --alterado v2.8 
      return true
   end
end

if ret.cond and ret.cond == "Miss" then
	doMiss2(ret.id, ret.cd, ret.eff, ret.check, ret.spell)
elseif ret.cond and ret.cond == "Silence" then
	doSilence2(ret.id, ret.cd, ret.eff, ret.check)
elseif ret.cond and ret.cond == "Slow" then
	doSlow2(ret.id, ret.cd, ret.eff, ret.check, ret.first)
elseif ret.cond and ret.cond == "Confusion" then
	doConfusion2(ret.id, ret.cd, ret.check)
elseif ret.cond and ret.cond == "Burn" then
	doBurn2(ret.id, ret.cd, ret.check, ret.damage)
elseif ret.cond and ret.cond == "Poison" then
	doPoison2(ret.id, ret.cd, ret.check, ret.damage)
elseif ret.cond and ret.cond == "Fear" then
	doFear2(ret.id, ret.cd, ret.check, ret.skill)
elseif ret.cond and ret.cond == "Stun" then
	doStun2(ret.id, ret.cd, ret.eff, ret.check, ret.spell)
elseif ret.cond and ret.cond == "Paralyze" then
	doParalyze2(ret.id, ret.cd, ret.eff, ret.check, ret.first)
elseif ret.cond and ret.cond == "Sleep" then
	doSleep2(ret.id, ret.cd, ret.check, ret.first)
elseif ret.cond and ret.cond == "Leech" then
	doLeech2(ret.id, ret.attacker, ret.cd, ret.check, ret.damage)
end
end

--------------------------------
function cleanBuffs2(item)
   if item ~= 0 then
      for i = 1, 3 do
         doItemEraseAttribute(item, Buffs[i][1])
         doItemEraseAttribute(item, Buffs[i][1].."eff")
         doItemEraseAttribute(item, Buffs[i][1].."skill")
      end   
   end
end 

function doCureStatus(cid, type, playerballs)
	if not isCreature(cid) then return true end
	if playerballs and isPlayer(cid) then
		local bp = getPlayerSlotItem(cid, CONST_SLOT_BACKPACK)
		local mb = getPlayerSlotItem(cid, 8)
		local balls = getPokeballsInContainer(bp.uid)
		if isPokeball(mb.itemid) then
			if not type or type == "all" then
				for b = 1, #injuries2 do
				    doItemSetAttribute(mb.uid, ""..injuries2[b].n.."", -1)
				end
			else
				doItemSetAttribute(mb.uid, ""..type.."", -1)
			end
		end
		if #balls >= 1 then
		   for _, uid in ipairs(balls) do
		       if not type or type == "all" then
					for b = 1, #injuries2 do
					doItemSetAttribute(uid, ""..injuries2[b].n.."", -1)
					end
				else
					doItemSetAttribute(uid, ""..type.."", -1)
				end
            end
        end    
	end
	if type == "all" then
		for a = 1, #injuries2 do
			setPlayerStorageValue(cid, injuries2[a].m, -1)
		end
	return true
	end
	for a, b in pairs (injuries2) do
		if b.n == type then
		setPlayerStorageValue(cid, b.m, -1)
		end
	end
end 

function isWithCondition(cid)
for i = 1, #injuries2 do 
   if getPlayerStorageValue(cid, injuries2[i].m) >= 1 then
      return true
   end
end
return false
end

function doCureBallStatus(item, type)
	if not type or type == "all" then
		for b = 1, #injuries2 do
		doItemSetAttribute(item, ""..injuries2[b].n.."", -1)
		end
	else
		doItemSetAttribute(item, ""..type.."", -1)
	end
end

function isBurning(cid)
	if not isCreature(cid) then 
      return false 
   end

	if getPlayerStorageValue(cid, conds["Burn"]) >= 0 then 
      return true 
   end
   return false
end

function isPoisoned(cid)
	if not isCreature(cid) then 
      return false 
   end

	if getPlayerStorageValue(cid, conds["Poison"]) >= 0 then
       return true 
   end

   return false
end

function isSilence(cid)
   if not isCreature(cid) then 
      return false 
   end

   if getPlayerStorageValue(cid, conds["Silence"]) >= 0 then 
      return true 
   end

   return false
end

function isParalyze(cid)      
   if not isCreature(cid) then 
      return false 
   end

   if getPlayerStorageValue(cid, conds["Paralyze"]) >= 0 then 
      return true 
   end

   return false
end
    
function isSleeping(cid)
   if not isCreature(cid) then 
      return false 
   end

   if getPlayerStorageValue(cid, conds["Sleep"]) >= 0 then 
      return true 
   end

   return false
end

function isWithFear(cid)
   if not isCreature(cid) then 
      return false 
   end

   if getPlayerStorageValue(cid, conds["Fear"]) >= 0 then 
      return true 
   end

   return false
end 

function doMoveInArea2(cid, eff, area, element, min, max, spell, ret)
   if not isCreature(cid) then 
      return true 
   end
   
   local skills = {"Skull Bash", "Gust", "Water Pulse", "Stick Throw", "Overheat", "Toxic", "Take Down", "Gyro Ball"}
   local pos = nil  --alterado v2.8
   if area and area ~= nil then
      pos = getPosfromArea(cid, area)
      if pos == nil or not pos then
         print("A magia: " .. spell .. " está com area invalida.")
         return true
      end
   else
      print("A magia: " .. spell .. " está com area invalida.")
   end

   setPlayerStorageValue(cid, 21101, -1)
   for n = 1, #pos do
      if not isCreature(cid) then 
         return true 
      end 

      thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}
      local pid = getThingFromPosWithProtect(thing)
      if pid ~= cid then
         if spell == "Assurance" then
            if isCreature(pid) and getCreatureHealth(pid) <= (getCreatureMaxHealth(pid)/2) then
               min = min * 1.5
            end
         end

         sendEffWithProtect(cid, pos[n], eff)
         doMoveDano2(cid, pid, element, min, max, ret, spell) 
      end
   end
end

function doMoveDano2(cid, pid, element, min, max, ret, spell)
if isCreature(pid) and isCreature(cid) and cid ~= pid then
   if isNpcSummon(pid) and getCreatureTarget(pid) ~= cid then
      return true
   end

   if ehNPC(pid) then 
      return true 
   end

   local canAtk = true
   if getPlayerStorageValue(pid, 21099) >= 1 then
      doSendMagicEffect(getThingPosWithDebug(pid), 135)
      doSendAnimatedText(getThingPosWithDebug(pid), "REFLECT", COLOR_GRASS)
      addEvent(docastspell, 100, pid, spell)
      if getCreatureName(pid) == "Wobbuffet" then
         doRemoveCondition(pid, CONDITION_OUTFIT)    
      end
      canAtk = false
      setPlayerStorageValue(pid, 21099, -1)
      setPlayerStorageValue(pid, 21100, 1)
      setPlayerStorageValue(pid, 21101, cid)

      if getTableMove(cid, getPlayerStorageValue(cid, 21102)) and getTableMove(cid, getPlayerStorageValue(cid, 21102)).f then
         setPlayerStorageValue(pid, 21103, getTableMove(cid, getPlayerStorageValue(cid, 21102)).f)
      end
   end

   if isSummon(cid) and (ehMonstro(pid) or (isSummon(pid) and canAttackOther(cid, pid) == "Can") or (isPlayer(pid) and canAttackOther(cid, pid) == "Can" and #getCreatureSummons(pid) <= 0)) and pid ~= cid then
      if canAtk then     --alterado v2.6
         if ret and ret.cond then
            ret.id = pid
            ret.check = getPlayerStorageValue(pid, conds[ret.cond])
            doCondition2(ret)
         end
         
         if spell == "Selfdestruct" then
            if getPlayerStorageValue(pid, 9658783) <= 0 then
               doSendAnimatedText(getThingPosWithDebug(pid), "-"..max.."", COLOR_NORMAL)
               doCreatureAddHealth(pid, -max)
            end
         else
            doTargetCombatHealth(cid, pid, element, -(math.abs(min)), -(math.abs(max)), 255)
         end
      end
      elseif ehMonstro(cid) and (isSummon(pid) or (isPlayer(pid) and #getCreatureSummons(pid) <= 0)) and pid ~= cid then
         if canAtk then
            if ret and ret.cond then
               ret.id = pid
               ret.check = getPlayerStorageValue(pid, conds[ret.cond])
               doCondition2(ret)
            end
            if spell == "Selfdestruct" then
               if getPlayerStorageValue(pid, 9658783) <= 0 then
                  doSendAnimatedText(getThingPosWithDebug(pid), "-"..max.."", COLOR_NORMAL)
                  doCreatureAddHealth(pid, -max)
               end
            else
               doTargetCombatHealth(cid, pid, element, -(math.abs(min)), -(math.abs(max)), 255)
            end
         end
      elseif isPlayer(cid) and ehMonstro(pid) and pid ~= cid then
         if canAtk then
            if ret and ret.cond then
               ret.id = pid
               ret.check = getPlayerStorageValue(pid, conds[ret.cond])
               doCondition2(ret)
            end
            if spell == "Selfdestruct" then
               if getPlayerStorageValue(pid, 9658783) <= 0 then
                  doSendAnimatedText(getThingPosWithDebug(pid), "-"..max.."", COLOR_NORMAL)
                  doCreatureAddHealth(pid, -max)
               end
            else
               doTargetCombatHealth(cid, pid, element, -(math.abs(min)), -(math.abs(max)), 255)
            end
         end
      end
   end
end

function sendEffWithProtect(cid, pos, eff)
   if not isCreature(cid) then
      return true 
   end

   local checkpos = pos
   checkpos.stackpos = 0

   if not hasTile(checkpos) then
      return true
   end

   if not canWalkOnPos2(pos, false, true, false, true, false) then
      return true
   end

   doSendMagicEffect(pos, eff)
end

function getThingPosWithDebug(what)
	if not isCreature(what) or getCreatureHealth(what) <= 0 then
	   return {x = 1, y = 1, z = 10}
	end

   return getThingPos(what)
end

function doDanoWithProtect(cid, element, pos, area, min, max, eff)
   if not isCreature(cid) then 
      return true 
   end

   doAreaCombatHealth(cid, element, pos, area, -(math.abs(min)), -(math.abs(max)), eff)
end

function doDanoWithProtectWithDelay(cid, target, element, min, max, eff, area)
   const_distance_delay = 56
   if not isCreature(cid) then 
      return true 
   end
 
   if target ~= 0 and isCreature(target) and not area then
      delay = getDistanceBetween(getThingPosWithDebug(cid), getThingPosWithDebug(target)) * const_distance_delay
      addEvent(doDanoWithProtect, delay, cid, element, getThingPosWithDebug(target), 0, min, max, eff)
      return true
   end

   addEvent(doDanoWithProtect, 100, cid, element, getThingPosWithDebug(target), area, min, max, eff)
end   

function sendDistanceShootWithProtect(cid, frompos, topos, eff)
   if not isCreature(cid) then 
      return true 
   end

   doSendDistanceShoot(frompos, topos, eff)
end


function sendMoveBack(cid, pos, eff, min, max)
   if not isCreature(cid) then 
      return true 
   end

   local m = #pos+1
   for i = 1, #pos do
      m = m-1
      thing = {x=pos[m].x,y=pos[m].y,z=pos[m].z,stackpos=253}
      local pid = getThingFromPosWithProtect(thing)
      addEvent(doMoveDano2, i*200, cid, pid, FLYINGDAMAGE, min/4, max/4)  
      addEvent(sendEffWithProtect, i*200, cid, pos[m], eff)
   end
end  

function upEffect(cid, effDis)
   if not isCreature(cid) then
       return true 
   end

   pos = getThingPos(cid)
   frompos = {x = pos.x+1, y = pos.y, z = pos.z}
   frompos.x = pos.x - math.random(4, 7)
   frompos.y = pos.y - math.random(5, 8)
   doSendDistanceShoot(getThingPos(cid), frompos, effDis)
end

function fall(cid, master, element, effDis, effArea)
   if not isCreature(cid) then
      return true
   end

   pos = getThingPos(cid)
   pos.x = pos.x + math.random(-4,4)
   pos.y = pos.y + math.random(-4,4)

   if isMonster(cid) or isPlayer(cid) then
      frompos = {x = pos.x+1, y = pos.y, z = pos.z}
   elseif isSummon(cid) then
      frompos = getThingPos(master)
   end

   frompos.x = pos.x - 7
   frompos.y = pos.y - 6
   if effDis ~= -1 then
      doSendDistanceShoot(frompos, pos, effDis)
   end

   doAreaCombatHealth(cid, element, pos, 0, 0, 0, effArea)
end

function canDoMiss(cid, nameAtk)
   local atkTerra = {}
   local atkElectric = {}

   if not isCreature(cid) then 
      return false 
   end

   if isPlayer(cid) then 
      return true 
   end

   if not pokes[getCreatureName(cid)] then 
      return true 
   end

   return false
end

function doMoveInAreaMulti(cid, effDis, effMagic, areaEff, areaDano, element, min, max, ret)   --alterado v2.7
if not isCreature(cid) then return true end                     
local pos = getPosfromArea(cid, areaEff)
local pos2 = getPosfromArea(cid, areaDano)

if pos == nil or not pos then
   print("Magia com o Efeito: " .. effMagic .. " com erro.")
   return true
end

if pos2 == nil or not pos2 then
   print("Magia com o Efeito: " .. effMagic .. " com erro.")
   return true
end

local n = 0

for n = 1, #pos2 do
   if not isCreature(cid) then 
      return true 
   end

   thing = {x=pos2[n].x,y=pos2[n].y,z=pos2[n].z,stackpos=253}
   if n < #pos then
      addEvent(sendDistanceShootWithProtect, 50, cid, getThingPos(cid), pos[n], effDis) --39
      addEvent(sendEffWithProtect, 100, cid, pos[n], effMagic)  -- 112
   ---                                                                                        --alterado v2.6.1
      if math.random(1, 2) == 2 then
         addEvent(sendDistanceShootWithProtect, 450, cid, getThingPos(cid), pos[n], effDis) --550
         addEvent(sendEffWithProtect, 550, cid, pos[n], effMagic)  -- 650
      end
   end 

   local pid = getThingFromPosWithProtect(thing)
   if isCreature(pid) then
      if ret and ret.id == 0 then
         ret.id = pid
         ret.check = getPlayerStorageValue(pid, conds[ret.cond])
      end

      if not ret then ret = {} end 
         doMoveDano2(cid, pid, element, min, max, ret, getPlayerStorageValue(cid, 21102))
      end
   end       
end 

function doDoubleHit(cid, pid, valor, races)
   if isCreature(cid) and isCreature(pid) then
      if getPlayerStorageValue(cid, 374896) >= 1 then
         if getMasterTarget(cid) == pid then
            if isInArray({"Kadabra", "Alakazam", "Mew", "Shiny Abra", "Shiny Alakazam"}, getCreatureName(cid)) then
               doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(pid), 39)
            end

            if isSummon(cid) then
               doTargetCombatHealth(getCreatureMaster(cid), pid, PHYSICALDAMAGE, -math.abs(valor), -math.abs(valor), 255)
            else
               doCreatureAddHealth(pid, -math.abs(valor), 3, races[getMonsterInfo(getCreatureName(pid)).race].cor)
            end
         end
      end
   end
end

function doDanoInTarget(cid, target, combat, min, max, eff)
   if not isCreature(cid) or not isCreature(target) then 
      return true 
   end
   
   doTargetCombatHealth(cid, target, combat, -math.abs(min), -math.abs(max), eff)
end 

function doDanoInTargetWithDelay(cid, target, combat, min, max, eff)
   const_distance_delay = 56
   if not isCreature(cid) or not isCreature(target) then 
      return true 
   end
 
   local delay = getDistanceBetween(getThingPosWithDebug(cid), getThingPosWithDebug(target)) * const_distance_delay
   addEvent(doDanoInTarget, delay, cid, target, combat, min, max, eff)
end 