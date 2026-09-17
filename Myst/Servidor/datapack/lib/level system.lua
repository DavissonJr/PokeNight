function adjustWildPoke(cid, optionalLevel)
if isMonster(cid) and pokes[getCreatureName(cid)] then

	-- Lembretes:
	-- Colocar para funcionar os status pelo gender

    local level = (optionalLevel and optionalLevel >= 1) and optionalLevel or getPokemonLevel(cid)  --alterado v1.8
	
	setPlayerStorageValue(cid, 1000, level) --alterado v1.8
    setPlayerStorageValue(cid, 1001, pokes[getCreatureName(cid)].offense * level)
	setPlayerStorageValue(cid, 1002, pokes[getCreatureName(cid)].defense)
	setPlayerStorageValue(cid, 1003, pokes[getCreatureName(cid)].agility)                                  
	setPlayerStorageValue(cid, 1004, pokes[getCreatureName(cid)].vitality * level * 3)
	setPlayerStorageValue(cid, 1005, pokes[getCreatureName(cid)].specialattack * level * 9)
	
    doRegainSpeed(cid)	     --alterado!
    setCreatureMaxHealth(cid, (getVitality(cid) * HPperVITwild)) 
    doCreatureAddHealth(cid,  getCreatureMaxHealth(cid))

	-- Thalles Vitor - Ganho de Velocidade Selvagens --
	doChangeSpeed(cid, getCreatureSpeed(cid)+35)
	--
   
    if pokes[getCreatureName(cid)].exp then
       local exp = pokes[getCreatureName(cid)].exp * baseExpRate + pokes[getCreatureName(cid)].vitality * pokemonExpPerLevelRate
       setPlayerStorageValue(cid, 1006, (exp * generalExpRate/2)*28.0)
       if getPlayerStorageValue(cid, 22546) == 1 then
          setPlayerStorageValue(cid, 1006, 750)
          doSetCreatureDropLoot(cid, false)      
       end   
	end
end
end       

function getPokemonXMLOutfit(name)                --alterado v1.9 \/
local path = "data/monster/pokes/Shiny/"..name..".xml"
local tpw = io.type(io.open(path))

if not tpw then
   path = "data/monster/pokes/geracao 2/"..name..".xml"
   tpw = io.type(io.open(path))
end
if not tpw then
   path = "data/monster/pokes/geracao 1/"..name..".xml"
   tpw = io.type(io.open(path))
end
if not tpw then
   path = "data/monster/pokes/"..name..".xml"
   tpw = io.type(io.open(path))
end   
if not tpw then
   return print("[getPokemonXMLOutfit] Poke with name: "..name.." ins't in any paste on monster/pokes/") and 2
end
   local arq = io.open(path, "a+")
   local txt = arq:read("*all")
   arq:close()
   local a, b = txt:find('look type="(.-)"')
   txt = string.sub(txt, a + 11, b - 1)
return tonumber(txt)
end 

function doEvolutionOutfit(cid, oldout, outfit)
	if not isCreature(cid) then return true end
		if getCreatureOutfit(cid).lookType == oldout then
			doSetCreatureOutfit(cid, {lookType = outfit}, -1)
		else
			doSetCreatureOutfit(cid, {lookType = oldout}, -1)
		end
end

function doSendEvolutionEffect(cid, pos, evolution, turn, ssj, evolve, f, h)
	if not isCreature(cid) then
		doSendAnimatedText(pos, "CANCEL", 215)
	    return true 
    end
	if evolve then
		doEvolvePokemon(getCreatureMaster(cid), {uid = cid}, evolution, 0, 0)
	return true
	end
	doSendMagicEffect(pos, 18)
		if ssj then
			sendSSJEffect(evo)
		end
	doEvolutionOutfit(cid, f, h)
	addEvent(doSendEvolutionEffect, math.pow(1900, turn/20), cid, getThingPos(cid), evolution, turn - 1, turn == 19, turn == 2, f, h)
end

function sendSSJEffect(cid)
	if not isCreature(cid) then return true end
	local pos1 = getThingPos(cid)
	local pos2 = getThingPos(cid)
	pos2.x = pos2.x + math.random(-1, 1)
	pos2.y = pos2.y - math.random(1, 2)
	doSendDistanceShoot(pos1, pos2, 37)
	addEvent(sendSSJEffect, 45, cid)
end

function sendFinishEvolutionEffect(cid, alternate)
	if not isCreature(cid) then return true end
	local pos1 = getThingPos(cid)

	if alternate then
		local pos = {
		[1] = {-2, 0},
		[2] = {-1, -1},
		[3] = {0, -2},
		[4] = {1, -1},
		[5] = {2, 0},
		[6] = {1, 1},
		[7] = {0, 2},
		[8] = {-1, 1}}
		for a = 1, 8 do
			local pos2 = getThingPos(cid)
			pos2.x = pos2.x + pos[a][1]
			pos2.y = pos2.y + pos[a][2]
			local pos = getThingPos(cid)
			doSendDistanceShoot(pos2, pos, 37)
			addEvent(doSendDistanceShoot, 300, pos, pos2, 37)
		end
	else
		for a = 0, 3 do
			doSendDistanceShoot(pos1, getPosByDir(pos1, a), 37)
		end
		for a = 4, 7 do
			addEvent(doSendDistanceShoot, 600, pos1, getPosByDir(pos1, a), 37)
		end
	end
end

function doEvolvePokemon(cid, item2, theevo, stone1, stone2)

	if not isCreature(cid) then return true end

	if not pokes[theevo] or not pokes[theevo].offense then
	doReturnPokemon(cid, item2.uid, getPlayerSlotItem(cid, 8), pokeballs[getPokeballType(getPlayerSlotItem(cid, 8).itemid)].effect, false, true)
	return true
	end

	local owner = getCreatureMaster(item2.uid)
	local pokeball = getPlayerSlotItem(cid, 8)
	local description = "Contains a "..theevo.."."
	local pct = getCreatureHealth(item2.uid) / getCreatureMaxHealth(item2.uid)

	doItemSetAttribute(pokeball.uid, "hp", pct)

	doItemSetAttribute(pokeball.uid, "poke", theevo)
	doItemSetAttribute(pokeball.uid, "description", "Contains a "..theevo..".")
	doPlayerSendTextMessage(cid, 27, "Congratulations! Your "..getPokeName(item2.uid).." evolved into a "..theevo.."!")		

	doSendMagicEffect(getThingPos(item2.uid), 18)
	doTransformItem(getPlayerSlotItem(cid, 7).uid, fotos[theevo])
	doSendMagicEffect(getThingPos(cid), 173)

	local oldpos = getThingPos(item2.uid)
	local oldlod = getCreatureLookDir(item2.uid)
	doRemoveCreature(item2.uid)

	doSummonMonster(cid, theevo)
	local pk = getCreatureSummons(cid)[1]

	doTeleportThing(pk, oldpos, false)
	doCreatureSetLookDir(pk, oldlod)

	sendFinishEvolutionEffect(pk, true)
	sendFinishEvolutionEffect(pk)
		
	doPlayerRemoveItem(cid, stone1, 1)
	doPlayerRemoveItem(cid, stone2, 1)

	doAddPokemonInOwnList(cid, theevo)

	local happy = getItemAttribute(pokeball.uid, "happy")
	doItemSetAttribute(pokeball.uid, "happy", happy + happyGainedOnEvolution)

	if happy + happyGainedOnEvolution > 255 then
		doItemSetAttribute(pokeball.uid, "happy", 255)
	end

	adjustStatus(pk, pokeball.uid, true, false)

	if useKpdoDlls then
		doUpdateMoves(cid)
	end

	sendPokemonsBarPokemon(cid)
	updateBarStatus(cid, "on")
end

-------------------
function doEvolvePokemon2(cid, item2, theevo, stone1, stone2)

	if not isCreature(cid) then return true end

	if not pokes[theevo] or not pokes[theevo].offense then
	doReturnPokemon(cid, item2, getPlayerSlotItem(cid, 8), pokeballs[getPokeballType(getPlayerSlotItem(cid, 8).itemid)].effect, false, true)
	return true
	end

	local owner = getCreatureMaster(item2)
	local pokeball = getPlayerSlotItem(cid, 8)
	local description = "Contains a "..theevo.."."
	local pct = getCreatureHealth(item2) / getCreatureMaxHealth(item2)

	doItemSetAttribute(pokeball.uid, "hp", pct)

	doItemSetAttribute(pokeball.uid, "poke", theevo)
	doItemSetAttribute(pokeball.uid, "description", "Contains a "..theevo..".")
	doPlayerSendTextMessage(cid, 27, "Congratulations! Your "..getPokeName(item2).." evolved into a "..theevo.."!")		

	doSendMagicEffect(getThingPos(item2), 18)
	doTransformItem(getPlayerSlotItem(cid, 7).uid, fotos[theevo])
	doSendMagicEffect(getThingPos(cid), 173)

	local oldpos = getThingPos(item2)
	local oldlod = getCreatureLookDir(item2)
	doRemoveCreature(item2)

	doSummonMonster(cid, theevo)
	local pk = getCreatureSummons(cid)[1]

	doTeleportThing(pk, oldpos, false)
	doCreatureSetLookDir(pk, oldlod)

	sendFinishEvolutionEffect(pk, true)
	sendFinishEvolutionEffect(pk)

	doAddPokemonInOwnList(cid, theevo)

	local happy = getItemAttribute(pokeball.uid, "happy")
	doItemSetAttribute(pokeball.uid, "happy", happy + happyGainedOnEvolution)

	if happy + happyGainedOnEvolution > 255 then
		doItemSetAttribute(pokeball.uid, "happy", 255)
	end

	adjustStatus(pk, pokeball.uid, true, false)

	if useKpdoDlls then
		doUpdateMoves(cid)
	end

	sendPokemonsBarPokemon(cid)
	updateBarStatus(cid, "on")
end

function doMathDecimal(number, casas)

	if math.floor(number) == number then return number end

	local c = casas and casas + 1 or 3

	for a = 0, 10 do
		if math.floor(number) < math.pow(10, a) then
			local str = string.sub(""..number.."", 1, a + c)
			return tonumber(str)	
		end
	end

return number
end

function doAdjustWithDelay(cid, pk, health, vit, status)
if isCreature(cid) then                                   
   adjustStatus(pk, getPlayerSlotItem(cid, 8).uid, health, vir, status)
end
end

function adjustStatus(pk, item, health, vite, conditions)

	if not isCreature(pk) then return true end

	local name = getCreatureName(pk)
	if not pokes[name] then
		print("Pokemon: " .. name .. " n�o registrado.")
		return true
	end

	local gender = getItemAttribute(item, "gender") and getItemAttribute(item, "gender") or 0
	doCreatureSetSkullType(pk, gender)

	-- Thalles Vitor - Ditto
	if getItemAttribute(item, "transName") and getItemAttribute(item, "transName") ~= nil then
		if pokes[getItemAttribute(item, "transName")] then
			name = getItemAttribute(item, "transName")
		end
	end
	
	-- Thalles Vitor
	local level = tonumber(getItemAttribute(item, "level")) or 1
    local buff = 1 + level * 0.02 -- Poke nível 1 = 1.02 | Poke nível 100 = 3

    setPlayerStorageValue(pk, 1001, pokes[name].offense * (getMasterLevel(pk) + getPokemonBoost(pk)))
	setPlayerStorageValue(pk, 1002, pokes[name].defense)             
	setPlayerStorageValue(pk, 1003, pokes[name].agility)
	setPlayerStorageValue(pk, 1004, pokes[name].vitality * 75)

	setPlayerStorageValue(pk, 1005, pokes[name].specialattack * (getMasterLevel(pk) + getPokemonBoost(pk) )*9 * buff)
	
	for i = 1, 5 do
		if NATURE_TABLE_SYSTEM[nature] and NATURE_TABLE_SYSTEM[nature].list_operator[i] == "+" then
			setPlayerStorageValue(pk, 1000 + i, getPlayerStorageValue(pk, 1000 + i) + NATURE_TABLE_SYSTEM[nature].list[i])
		elseif NATURE_TABLE_SYSTEM[nature] and NATURE_TABLE_SYSTEM[nature].list_operator[i] == "-" then
			setPlayerStorageValue(pk, 1000 + i, getPlayerStorageValue(pk, 1000 + i) - NATURE_TABLE_SYSTEM[nature].list[i])
		elseif NATURE_TABLE_SYSTEM[nature] and NATURE_TABLE_SYSTEM[nature].list_operator[i] == "*" then
			setPlayerStorageValue(pk, 1000 + i, getPlayerStorageValue(pk, 1000 + i) * NATURE_TABLE_SYSTEM[nature].list[i])
		end
	end

	if gender == SEX_MALE then
		setPlayerStorageValue(pk, 1005, getPlayerStorageValue(pk, 1005) * 1.4)
	elseif gender == SEX_FEMALE then
		setPlayerStorageValue(pk, 1004, getPlayerStorageValue(pk, 1004) * 1.2)
	else
		setPlayerStorageValue(pk, 1004, getPlayerStorageValue(pk, 1004) * 0.5)
		setPlayerStorageValue(pk, 1005, getPlayerStorageValue(pk, 1005) * 0.5)
	end

	if vite == true then
		local pct = getCreatureHealth(pk) / getCreatureMaxHealth(pk)
		local vit = getVitality(pk)
		setCreatureMaxHealth(pk, ( vit * HPperVITsummon ))
		doCreatureAddHealth(pk, pct * vit * HPperVITsummon)
	end
                                                                      
	doRegainSpeed(pk)  

	local nick = getItemAttribute(item, "poke")
	if getItemAttribute(item, "nick") then
		nick = getItemAttribute(item, "nick")
	end

	setPlayerStorageValue(pk, 1007, nick)
	
	local lvl = getItemAttribute(item, "level") or 1
	nick = nick .. " [" .. lvl .. "]"
	
	doCreatureSetNick(pk, nick)
	doChangeSpeed(pk, getCreatureSpeed(pk)+150) -- Aumento de Velocidade

	if health == true then
		local mh = HPperVITsummon * getVitality(pk)
		local rd = 1 - (tonumber(getItemAttribute(item, "hp")))
		setCreatureMaxHealth(pk, mh)                                  
		doCreatureAddHealth(pk, getCreatureMaxHealth(pk))
		doCreatureAddHealth(pk, -(getCreatureMaxHealth(pk) * rd))
	end

	-- Thalles Vitor - Boost --
	local boost = tonumber(getItemAttribute(item, "boost")) or 0
	if boost > 0 then
		local newHp = 1000 * boost
		local theHp = getItemAttribute(item, "hp")

		addEvent(function()
			if not isCreature(pk) then
				return true
			end

			setCreatureMaxHealth(pk, getCreatureMaxHealth(pk)+newHp)
			doCreatureAddHealth(pk, getCreatureMaxHealth(pk))

			addEvent(function()
				if not isCreature(pk) then
					return true
				end

				local rd = 1 - (tonumber(theHp))
				doCreatureAddHealth(pk, -(getCreatureMaxHealth(pk) * rd))
			end, 250)
		end, 150)
	end

	if isSummon(pk) and conditions then
		local burn = getItemAttribute(item, "burn")   
		if burn and burn >= 0 then
		   local ret = {id = pk, cd = burn, check = false, damage = getItemAttribute(item, "burndmg"), cond = "Burn"}
		   addEvent(doCondition2, 1500, ret)
		end

		local poison = getItemAttribute(item, "poison")
		if poison and poison >= 0 then
		   local ret = {id = pk, cd = poison, check = false, damage = getItemAttribute(item, "poisondmg"), cond = "Poison"}
		   addEvent(doCondition2, 1500, ret)
		end

        local confuse = getItemAttribute(item, "confuse")
		if confuse and confuse >= 0 then
		   local ret = {id = pk, cd = confuse, check = false, cond = "Confusion"}
		   addEvent(doCondition2, 1200, ret)                                                
		end

        local sleep = getItemAttribute(item, "sleep")
		if sleep and sleep >= 0 then
		   local ret = {id = pk, cd = sleep, check = false, first = true, cond = "Sleep"}
		   doCondition2(ret)
		end
		
		local miss = getItemAttribute(item, "miss")     
		if miss and miss >= 0 then      
          local ret = {id = pk, cd = miss, eff = getItemAttribute(item, "missEff"), check = false, spell = getItemAttribute(item, "missSpell"), cond = "Miss"}
          doCondition2(ret)
        end
        
        local fear = getItemAttribute(item, "fear")
        if fear and fear >= 0 then
           local ret = {id = pk, cd = fear, check = false, skill = getItemAttribute(item, "fearSkill"), cond = "Fear"}
           doCondition2(ret)
        end
        
        local silence = getItemAttribute(item, "silence")
        if silence and silence >= 0 then      
           local ret = {id = pk, cd = silence, eff = getItemAttribute(item, "silenceEff"), check = false, cond = "Silence"}
           doCondition2(ret)
        end                                     
        
        local stun = getItemAttribute(item, "stun")
        if stun and stun >= 0 then
           local ret = {id = pk, cd = stun, eff = getItemAttribute(item, "stunEff"), check = false, spell = getItemAttribute(item, "stunSpell"), cond = "Stun"}
           doCondition2(ret)
        end 
                                                       
        local paralyze = getItemAttribute(item, "paralyze")
        if paralyze and paralyze >= 0 then
           local ret = {id = pk, cd = paralyze, eff = getItemAttribute(item, "paralyzeEff"), check = false, first = true, cond = "Paralyze"}
           doCondition2(ret)
        end  
                                                     
        local slow = getItemAttribute(item, "slow")
        if slow and slow >= 0 then
           local ret = {id = pk, cd = slow, eff = getItemAttribute(item, "slowEff"), check = false, first = true, cond = "Slow"}
           doCondition2(ret)
        end                                              
        
        local leech = getItemAttribute(item, "leech")
        if leech and leech >= 0 then
           local ret = {id = pk, cd = leech, attacker = 0, check = false, damage = getItemAttribute(item, "leechdmg"), cond = "Leech"}
           doCondition2(ret)
        end                               
        
        for i = 1, 3 do
            local buff = getItemAttribute(item, "Buff"..i)
            if buff and buff >= 0 then
               local ret = {id = pk, cd = buff, eff = getItemAttribute(item, "Buff"..i.."eff"), check = false, 
               buff = getItemAttribute(item, "Buff"..i.."skill"), first = true, attr = "Buff"..i}
               doCondition2(ret)
            end
        end       
	end
return true
end

function getOffense(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1001))
end

function getDefense(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1002))
end

function getSpeed(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1003))
end

function getVitality(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1004))
end

function getSpecialAttack(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1005))
end

function getHappiness(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1008))
end

function getSpecialDefense(cid)
	if not isCreature(cid) then return 0 end
return getSpecialAttack(cid) * 0.85 + getDefense(cid) * 0.2      
end

function getPokemonLevel(cid, dex)
if not isCreature(cid) then return 0 end 
    if not dex then                      --alterado v1.9
       if ehMonstro(cid) and getPlayerStorageValue(cid, 1000) > 0 then  
          return getPlayerStorageValue(cid, 1000)
       elseif pokes[getCreatureName(cid)] and ehMonstro(cid) then 
          return pokes[getCreatureName(cid)].wildLvl             
       end
    end   
return pokes[getCreatureName(cid)] and pokes[getCreatureName(cid)].level or 1
end

function getPokemonLevelByName(name)
return pokes[name] and pokes[name].level or 0  --alterado v1.9
end

function getMasterLevel(poke)
    if not isSummon(poke) then return 0 end
return getPlayerLevel(getCreatureMaster(poke))
end

function getPokemonBoost(poke)
    if not isSummon(poke) then return 0 end
return getItemAttribute(getPlayerSlotItem(getCreatureMaster(poke), 8).uid, "boost") or 0
end

function getPokeballBoost(ball)
    if not isPokeball(ball.itemid) then return 0 end  --alterado v1.8
return getItemAttribute(ball.uid, "boost") or 0
end

function getPokeName(cid)
	if not isSummon(cid) then return getCreatureName(cid) end
	if getCreatureName(cid) == "Evolution" then return getPlayerStorageValue(cid, 1007) end
	
local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
	if getItemAttribute(item.uid, "nick") then
	   return getItemAttribute(item.uid, "nick")
	end
return getCreatureName(cid)
end

function getPokeballName(item, truename)
if not truename and getItemAttribute(item, "nick") then
return getItemAttribute(item, "nick")
end
return getItemAttribute(item, "poke")
end

function getPokemonName(cid)
return getCreatureName(cid)
end

function getPokemonGender(cid) --alterado v1.9
return getCreatureSkullType(cid)
end

function setPokemonGender(cid, gender)
if isCreature(cid) and gender then        --alterado v1.8
   doCreatureSetSkullType(cid, gender)
   return true
end
return false
end

function getWildPokemonExp(cid)
return getPlayerStorageValue(cid, 1006)
end