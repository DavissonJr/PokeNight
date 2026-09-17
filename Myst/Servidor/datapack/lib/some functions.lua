happinessRate = {
	[5] = {rate = 1.5, effect = 183, n = getConfigValue(PokemonStageVeryHappy)},
	[4] = {rate = 1.2, effect = 170, n = getConfigValue(PokemonStageHappy)},
	[3] = {rate = 1.0, effect = 182, n = getConfigValue(PokemonStageOK)},
	[2] = {rate = 0.7, effect = 169, n = getConfigValue(PokemonStageSad)},
	[1] = {rate = 0.4, effect = 168, n = getConfigValue(PokemonStageMad)}
}

function getPokemonLook(thing)
	  local iname = getItemInfo(thing.itemid)
	  local pokename = getItemAttribute(thing.uid, "poke")
      local boost = getItemAttribute(thing.uid, "boost") or 0

      local strPokemon = {}
      table.insert(strPokemon, "Você vê uma "..iname.name.." com um " .. pokename .. ".\n")  
      
      if tonumber(getItemAttribute(thing.uid, "gender")) == SEX_MALE then
         table.insert(strPokemon, "Gênero: Male.\n")
      elseif tonumber(getItemAttribute(thing.uid, "gender")) == SEX_FEMALE then
         table.insert(strPokemon, "Gênero:: Female.\n")
      else
         table.insert(strPokemon, "Gênero:: Indefinido.\n")
      end
      
      if getItemAttribute(thing.uid, "nick") then
         table.insert(strPokemon, "Nickname: "..getItemAttribute(thing.uid, "nick")..".\n")
      end

      if boost > 0 then
         table.insert(strPokemon, "Boost: +"..boost..".\n")
      end
      
      -- Thalles Vitor - Nature System --
         local nature = getItemAttribute(thing.uid, "nature")
         if nature then
            table.insert(strPokemon, "Nature: " ..nature..".\n")
         end
       --

      local level = getItemAttribute(thing.uid, "level")
      if level and level > 0 then
         table.insert(strPokemon, "Level: " .. level .. ".\n")
      end
         
      -- Sistema de Addon - Thalles Vitor
         local count = getItemAttribute(thing.uid, "addonCount") or 0
         for i = 1, count do
            local addon = getItemAttribute(thing.uid, "addonName"..i)
            if addon then
               table.insert(strPokemon, "Addon: "..addon..".\n")
            end
         end

         if count > 0 then
            table.insert(strPokemon, "Addons: "..count..".\n")
         end
      --
	return table.concat(strPokemon)
end

function getPlayerPokemons(cid)
	if not isPlayer(cid) then
		return 0
	end

	return getTotalBalls(cid)
end

function doSetPlayerSpeedLevel(cid)
	if not isPlayer(cid) then
		return true
	end

	local speed = 220
	local spood = getCreatureSpeed(cid)
	local level = getPlayerLevel(cid)
	doChangeSpeed(cid, -spood)
	doChangeSpeed(cid, speed + (level * 3)) 
end

local genders = {
	["male"] = 4,
	["female"] = 3,
	["indefinido"] = 1,
	["genderless"] = 1,
	[1] = 4,
	[0] = 3,
	[4] = 4,
	[3] = 3,
}

function addPokeToPlayer(cid, pokemon, boost, gender, ball, unique)             --alterado v1.9 \/ peguem ele todo...
	if not isCreature(cid) then 
		return false 
	end

	local pokemon = doCorrectString(pokemon)
	if not pokes[pokemon] then 
		return false 
	end

	local GENDER = (gender and genders[gender]) and genders[gender] or getRandomGenderByName(pokemon)
	local btype = (ball and pokeballs[ball]) and ball or "normal"
	local happy = 250

	-- Thalles Vitor - New Cap
	local balls = 0
	local bp = getPlayerSlotItem(cid, 13)
	if bp.uid > 0 then
		if isContainer(bp.uid) then
			for i = 0, getContainerSize(bp.uid)-1 do
				local itembp = getContainerItem(bp.uid, i)
				if itembp and itembp.uid > 0 and getItemAttribute(itembp.uid, "poke") then
					balls = balls + 1
				end
			end
		end
	end

	if balls >= 30 then
		item = doCreateItemEx(pokeballs[btype].on)
	else
		item = doAddContainerItem(getPlayerSlotItem(cid, 13).uid, 10976, 1)
	end

	if not item then 
		return false 
	end

	doItemSetAttribute(item, "poke", pokemon)
	doItemSetAttribute(item, "hp", 1)
	doItemSetAttribute(item, "happy", happy)
	doItemSetAttribute(item, "gender", GENDER)
	doItemSetAttribute(item, "exp", 0)
	doItemSetAttribute(item, "level", 1)
	doItemSetAttribute(item, "nature", NATURE_TABLE_NEWPOKE[math.random(1, #NATURE_TABLE_NEWPOKE)].nature)
	doItemSetAttribute(item, "portrait", fotos[pokemon])

	if boost and tonumber(boost) and tonumber(boost) > 0 and tonumber(boost) <= 50 then
		doItemSetAttribute(item, "boost", boost)
	end
																				
	if (balls >= 30) then 
		doPlayerSendMailByName(getCreatureName(cid), item, 1)
		sendMsgToPlayer(cid, 27, "Não há mais espaço disponível na sua Catch Bag, seu novo pokémon foi enviado ao DP.")
	end

	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "O seu " .. pokemon .. " foi entregue a você, verifique se ele foi para a Catch Bag ou Depósito Pokémon.")
	doTransformItem(item, pokeballs[btype].on)
	sendPokemonsBarPokemon(cid)
	return true
end 

function addPokeToPlayer2(cid, pokemon, boost, level, gender, isHorder, horderLookType, typeee, unique)             --alterado v1.9 \/ peguem ele todo...
	if not isCreature(cid) then 
		return false 
	end

	local pokemon = doCorrectString(pokemon)
	if not pokes[pokemon] then 
		return false 
	end

	local GENDER = gender
	local happy = 250

	-- Thalles Vitor - New Cap
	local balls = 0
	local bp = getPlayerSlotItem(cid, 13)
	if bp.uid > 0 then
		for i = 0, getContainerSize(bp.uid)-1 do
			local itembp = getContainerItem(bp.uid, i)
			if itembp and itembp.uid > 0 and getItemAttribute(itembp.uid, "poke") then
				balls = balls + 1
			end
		end
	end

	--[[ if getPlayerSlotItem(cid, 13).uid <= 0 then
		doPlayerAddItem(cid, 28146, 1)
	end ]]

	if balls >= 30 then
		item = doCreateItemEx(pokeballs[typeee].on)
	else
		item = doAddContainerItem(getPlayerSlotItem(cid, 13).uid, 10976, 1)
	end

	if not item then 
		item = doAddContainerItem(getPlayerSlotItem(cid, 13).uid, 11826, 1)
	end

	if not item then 
		return false 
	end

	-- Thalles Vitor - Horder System --
		if isHorder > 0 then
			local addonCount = tonumber(getItemAttribute(item, "addonCount")) or 0
			if addonCount <= 0 then
				addounCount = 0
			end

			local horder_table = horders_addon[horderLookType]
			if horder_table then
				doItemSetAttribute(item, "addonCount", addonCount+1)

				local newCount = tonumber(getItemAttribute(item, "addonCount")) or 1
				doItemSetAttribute(item, "addonName" .. newCount, horder_table.name)
				doItemSetAttribute(item, "addon" .. newCount, horderLookType)
				doItemSetAttribute(item, "addonFly" .. newCount, horder_table.fly)
				doItemSetAttribute(item, "addonRide" .. newCount, horder_table.ride)
				doItemSetAttribute(item, "addonSurf" .. newCount, horder_table.surf)

				doItemSetAttribute(item, "addonFly", horder_table.fly)
				doItemSetAttribute(item, "addonRide", horder_table.ride)
				doItemSetAttribute(item, "addonSurf", horder_table.surf)

				doItemSetAttribute(item, "lastAddon", horderLookType)
				doItemSetAttribute(item, "lastAddonFly", horder_table.fly)
				doItemSetAttribute(item, "lastAddonRide", horder_table.ride)
				doItemSetAttribute(item, "lastAddonSurf", horder_table.name)
			end

			pokemon = string.gsub(pokemon, "Horder ", "")
		end
	--

	doItemSetAttribute(item, "poke", pokemon)
	doItemSetAttribute(item, "hp", 1)
	doItemSetAttribute(item, "happy", happy)
	doItemSetAttribute(item, "gender", GENDER)
	doItemSetAttribute(item, "exp", 0)
	doItemSetAttribute(item, "level", level)
	doItemSetAttribute(item, "description", "Contains a "..pokemon..".")
	doItemSetAttribute(item, "nature", NATURE_TABLE_NEWPOKE[math.random(1, #NATURE_TABLE_NEWPOKE)].nature)
	doItemSetAttribute(item, "portrait", fotos[pokemon])

	if boost and tonumber(boost) and tonumber(boost) > 0 and tonumber(boost) <= 50 then
		doItemSetAttribute(item, "boost", boost)
	end
																				
	if (balls >= 30) then 
		doPlayerSendMailByName(getCreatureName(cid), item, 1)
		sendMsgToPlayer(cid, 27, "Não há mais espaço disponível na sua Catch Bag, seu novo pokémon foi enviado ao DP.")
	end

	if pokeballs[typeee] then
		doTransformItem(item, pokeballs[typeee].on)
	end
	sendPokemonsBarPokemon(cid)
	return true
end 

function unLock(ball)                                                             
if not ball or ball <= 0 then return false end
if getItemAttribute(ball, "lock") and getItemAttribute(ball, "lock") > 0 then
   local vipTime = getItemAttribute(ball, "lock")
   local timeNow = os.time()
   local days = math.ceil((vipTime - timeNow)/(24 * 60 * 60))
   if days <= 0 then
      doItemEraseAttribute(ball, "lock")    
      doItemEraseAttribute(ball, "unique")
      return true
   end
end
return false
end

function sendMsgToPlayer(cid, tpw, msg)
if not isCreature(cid) or not tpw or not msg then 
	return true 
end

return doPlayerSendTextMessage(cid, tpw, msg)
end

function getPlayerDesc(cid, thing, TV)
	if (not isCreature(cid) or not isCreature(thing)) then 
		return "" 
	end

	local pos = getThingPos(thing)
	local ocup = youAre[getPlayerGroupId(thing)]
	local rank = (getPlayerStorageValue(thing, 86228) <= 0) and getPlayerVocationName(thing).." " or lookClans[getPlayerStorageValue(thing, 86228)][getPlayerStorageValue(thing, 862281)]
	local name = thing == cid and "Você mesmo" or getCreatureName(thing)     
	local art = thing == cid and "Você vê" or (getPlayerSex(thing) == 0 and "Ela é" or "Ele é")
	
	local str = {}
	table.insert(str, "Você vê "..name.." [".. getPlayerLevel(thing) .."]. "..art.." ")
	if youAre[getPlayerGroupId(thing)] then
		table.insert(str, (ocup).." " .. art .. " "..rank.."de ".. getTownName(getPlayerTown(thing))..".\n")       
	else
		table.insert(str, (rank).." de ".. getTownName(getPlayerTown(thing))..".\n")
	end

	local sid = getPlayerMarriage(getPlayerGUID(thing))
	if sid ~= 0 and isPlayer(getPlayerGUID(thing)) then
		local name = getPlayerNameByGUID(getPlayerMarriage(getPlayerGUID(thing)))
		if name ~= nil and name ~= "" then
			local pronome = getPlayerSex(thing) == 0 and "uma treinadora casada" or "um treinador casado"
			table.insert(str, art .. " " .. pronome .. " com " .. name)
		end
	end

	table.insert(str, ((isPlayer(cid) and youAre[getPlayerGroupId(cid)]) and "\nPosition: [X: "..pos.x.."][Y: "..pos.y.."][Z: "..pos.z.."]" or "")) 
	return table.concat(str) 
end

function addItemInFreeBag(container, item, num)
	if not isContainer(container) or not item then 
		return false 
	end  

	if not num or num <= 0 then
		 num = 1 
	end    

	if getContainerSize(container) < getContainerCap(container) then
		return doAddContainerItem(container, item, num)
	else
		for slot = 0, (getContainerSize(container)-1) do
			local container2 = getContainerItem(container, slot)
			if isContainer(container2.uid) and getContainerSize(container2.uid) < getContainerCap(container2.uid) then
				return doAddContainerItem(container2.uid, item, num)
			end
		end
	end

	return false
end

function pokeHaveReflect(cid)
	if not isCreature(cid) then 
		return false
	end

	local table = getTableMove(cid, "Reflect")
	if table and table.name then
		return true 
	end

	return false
end                                                    

function getTimeDiff(timeDiff)
	local dateFormat = {
		{'hour', timeDiff / 60 / 60}, --6%
		{'min', timeDiff / 60 % 60},
	}

	local out = {}                                   
	for k, t in ipairs(dateFormat) do
		local v = math.floor(t[2])
		if(v > -1) then
			table.insert(out, (k < #dateFormat and '' or ' and ') .. v .. '' .. (v <= 1 and t[1] or t[1].."s"))
		end
	end

	if tonumber(dateFormat[1][2]) == 0 and tonumber(dateFormat[2][2]) == 0 then
		return "seconds"
	end

	return table.concat(out)
end

function getTimeDiff2(timeDiff)
	local dateFormat = {
		{'hour', timeDiff / 60 / 60}, --6%
		{'min', timeDiff / 60 % 60},
		{'sec', timeDiff % 60},
	}

	local out = {}                                  
	for k, t in ipairs(dateFormat) do
		local v = math.floor(t[2])
		if(v > 0) then
			table.insert(out, (k < #dateFormat and ' ' or ' and ') .. v .. '' .. (v <= 1 and t[1] or t[1].."s"))
		end
	end

	return table.concat(out)
end 

function showTimeDiff(timeComp)
	local b = string.explode(os.date("%X"), ":")
	local c = string.explode(timeComp, ":")

    local d, m, y = os.date("%d"), os.date("%m"), os.date("%Y")
    local hAtual, mAtual = tonumber(b[1]), tonumber(b[2])
    local hComp, mComp = tonumber(c[1]), tonumber(c[2])
    ---
    local t = os.time{year= y, month= m, day= d, hour= hAtual, min= mAtual}
    local t1 = os.time{year= y, month= m, day= d, hour= hComp, min= mComp}
    ---                                                                       
    comparacao = t1-t
    if hComp < hAtual then
       v = os.time{year= y, month= m, day= d, hour= 24, min= 0}
       v2 = os.time{year= y, month= m, day= d, hour= 0, min= 0}
       comparacao = (v-t)+(t1-v2)
    end

	return getTimeDiff(comparacao)
end

function cleanCMcds(item)
	if item ~= 0 then
		for c = 1, 15 do
			local str = "cm_move"..c
			setCD(item, str, 0)
		end
	end
end

function ehNPC(cid)
return isCreature(cid) and not isPlayer(cid) and not isSummon(cid) and not isMonster(cid)
end

function ehMonstro(cid)
return cid and cid >= AUTOID_MONSTERS and cid < AUTOID_NPCS and getCreatureMaster(cid) == cid
end                                                 

function doAppear(cid) 
	if not isCreature(cid) then 
		return true 
	end

	doRemoveCondition(cid, CONDITION_INVISIBLE)
	doRemoveCondition(cid, CONDITION_OUTFIT)
	doCreatureSetHideHealth(cid, false)

	if isSummon(cid) then
		local slot = getPlayerSlotItem(getCreatureMaster(cid), 8)
		if slot.uid > 0 then
			local addon = tonumber(getItemAttribute(slot.uid, "lastAddon")) or 0
			if addon > 0 then
				doSetCreatureOutfit(cid, {lookType = addon}, -1)
			end
		end
	end
end

function doDisapear(cid)
	if not isCreature(cid) then 
		return true 
	end
	
	doCreatureAddCondition(cid, permanentinvisible)
	doCreatureSetHideHealth(cid, true)
	doSetCreatureOutfit(cid, {lookType = 100}, -1)
end

function hasTile(pos)    --Verifica se tem TILE na pos
	pos.stackpos = 0
	if getTileThingByPos(pos).itemid >= 1 then
		return true
	end

	return false
end

function getThingFromPosWithProtect(pos)
	if hasTile(pos) then
		if isCreature(getRecorderCreature(pos)) then
			return getRecorderCreature(pos)
		else
			pos.stackpos = 253
			pid = getThingfromPos(pos).uid
		end
	else
		pid = getThingfromPos({x=1,y=1,z=10,stackpos=253}).uid
	end

	return pid
end

function getTileThingWithProtect(pos)
	if hasTile(pos) then
		pos.stackpos = 0
		pid = getTileThingByPos(pos)
	else
		pid = getTileThingByPos({x=1,y=1,z=10,stackpos=0})
	end

	return pid
end

function canAttackOther(cid, pid)
	if not isCreature(cid) or not isCreature(pid) then 
		return "Cant" 
	end

	local master1 = isSummon(cid) and getCreatureMaster(cid) or cid
	local master2 = isSummon(pid) and getCreatureMaster(pid) or pid
   
    ---- pvp system
    if getPlayerStorageValue(master1, 6598754) >= 1 and getPlayerStorageValue(master2, 6598755) >= 1 then
       return "Can" 
    end

    if getPlayerStorageValue(master1, 6598755) >= 1 and getPlayerStorageValue(master2, 6598754) >= 1 then  ---estar em times diferentes
       return "Can"
    end

    if getTileInfo(getThingPos(cid)).pvp then
		return "Can"
	end
   
    if ehMonstro(cid) and ehMonstro(pid) then 
      	return "Can"
   	end

    return "Cant"
end
   
      
function stopNow(cid, time)   
	if not isCreature(cid) or not tonumber(time) or isSleeping(cid) then 
		return true 
	end

	local function podeMover(cid)                         
		if isPlayer(cid) then 
			mayNotMove(cid, false) 
		elseif isCreature(cid) then 
			doRegainSpeed(cid) 
		end
	end

	if isPlayer(cid) then 
		mayNotMove(cid, true) 
	else 
		doChangeSpeed(cid, -getCreatureSpeed(cid)) 
	end

	addEvent(podeMover, time, cid)
end

function doReduceStatus(cid, off, def, agi) 
	if not isCreature(cid) then 
		return true 
	end

	local A = getOffense(cid)
	local B = getDefense(cid)
	local C = getSpeed(cid)

	if off > 0 then
		setPlayerStorageValue(cid, 1001, A - off)
	end

	if def > 0 then
		setPlayerStorageValue(cid, 1002, B - def)
	end

	if agi > 0 then
		setPlayerStorageValue(cid, 1003, C - agi)
		if getCreatureSpeed(cid) ~= 0 then
			doRegainSpeed(cid)
		end
	end
end

function doRaiseStatus(cid, off, def, agi, time)  
	if not isCreature(cid) then 
		return true 
	end

	local A = getOffense(cid)
	local B = getDefense(cid)
	local C = getSpeed(cid)

	if off > 0 then
	setPlayerStorageValue(cid, 1001, A * off)
	end
	if def > 0 then
	setPlayerStorageValue(cid, 1002, B * def)
	end
	if agi > 0 then
		setPlayerStorageValue(cid, 1003, C + agi)
		if getCreatureSpeed(cid) ~= 0 then
			doRegainSpeed(cid)
		end
	end

	local D = getOffense(cid)
	local E = getDefense(cid)
	local F = getSpeed(cid)
	---------------------------
	local G = D - A
	local H = E - B
	local I = F - C

	addEvent(doReduceStatus, time*1000, cid, G, H, I)
end


function BackTeam(cid)           
end
    
function choose(...) -- by mock
    local arg = {...}
    return arg[math.random(1,#arg)]
end

function isShiny(cid) 
	return isCreature(cid) and string.find(getCreatureName(cid), "Shiny")
end

function isShinyName(name)        
	return tostring(name) and string.find(doCorrectString(name), "Shiny")
end

function doConvertTypeToStone(type, string)
local t = {
	["fly"] = {heart, "heart"},
	["flying"] = {heart, "heart"},
	["normal"] = {heart, "heart"},
	["fire"] = {fire, "fire"},
	["grass"] = {leaf, "leaf"},
	["leaf"] = {leaf, "leaf"},
	["water"] = {water, "water"},
	["poison"] = {venom, "venom"},
	["venom"] = {venom, "venom"},
	["electric"] = {thunder, "thunder"},
	["thunder"] = {thunder, "thunder"},
	["rock"] = {rock, "rock"},
	["fight"] = {punch, "punch"},
	["fighting"] = {punch, "punch"},
	["bug"] = {coccon, "coccon"},
	["dragon"] = {crystal, "crystal"},
	["dark"] = {dark, "dark"},
	["ghost"] = {dark, "dark"},
	["ground"] = {earth, "earth"},
	["earth"] = {earth, "earth"},
	["psychic"] = {enigma, "enigma"},
	["steel"] = {metal, "metal"},
	["metal"] = {metal, "metal"},
	["ice"] = {ice, "ice"},
	["boost"] = {boostStone, "boost"},
}

if string then
	return t[type][2]
else
	return t[type][1]
end

end

function doConvertStoneIdToString(stoneID)
local t = {
	[11453] = "Heart Stone",
	[11441] = "Leaf Stone",
	[11442] = "Water Stone",
	[11443] = "Venom Stone",
	[11444] = "Thunder Stone",
	[11445] = "Rock Stone",
	[11446] = "Punch Stone", 
	[11447] = "Fire Stone",
	[11448] = "Cocoon Stone", 
	[11449] = "Crystal Stone",
	[11450] = "Darkess Stone", 
	[11451] = "Earth Stone",
	[11452] = "Enigma Stone",
	[11454] = "Ice Stone", 
	[12244] = "King's Rock",
	[12232] = "Metal Stone",
	[12242] = "Sun Stone",
	[12401] = "Shiny Fire Stone",
	[12402] = "Shiny Water Stone",
	[12403] = "Shiny Leaf Stone",
	[12404] = "Shiny Heart Stone",
	[12405] = "Shiny Enigma Stone",
	[12406] = "Shiny Rock Stone",
	[12407] = "Shiny Venom Stone", 
	[12408] = "Shiny Ice Stone",
	[12409] = "Shiny Thunder Stone",
	[12410] = "Shiny Crystal Stone",
	[12411] = "Shiny Cocoon Stone",
	[12412] = "Shiny Darkness Stone",
	[12413] = "Shiny Punch Stone",
	[12414] = "Shiny Earth Stone",
	[12419] = "dubious disc",
	[13381] = "Coursed Souls",
	[13229] = "Green Ambar",
	[12418] = "Soothe Bell",
	[14337] = "Neacle of spirit",
	[boostStone] = "Boost Stone",
}

if t[stoneID] then
	return t[stoneID]
else
	return ""
end

end

function isStone(id)
if id >= leaf and id <= ice then
	return true
end

if id == boostStone then
	return true
end

if id == 12232 or id == 12242 or id == 12244 or id == 12245 then
	return true                                 
end

if (id >= sfire and id <= searth) or id == 12417 or id == 12419 then
	return true 
end

return false
end

function isWater(id)
	return tonumber(id) and id >= 4820 and id <= 4825
end

function getTopCorpse(position)
	local pos = position
	for n = 1, 255 do
		pos.stackpos = n
		local item = getTileThingByPos(pos)
		if item.itemid >= 2 and (string.find(getItemNameById(item.itemid), "fainted ") or string.find(getItemNameById(item.itemid), "defeated ")) then
			return getTileThingByPos(pos)
		end
	end

	return {uid = 0}
end

function getTopItem(position)
local pos = position
for n = 1, 255 do
    pos.stackpos = n
    local item = getTileThingByPos(pos)
    if item.itemid >= 2 and getItemAttribute(item.uid, "poke") then
       return getTileThingByPos(pos)
    end
end
return {uid = 0}
end

function isNpcSummon(cid)
	return isNpc(getCreatureMaster(cid))
end

function getPokemonHappinessDescription(cid)
	if not isCreature(cid) then 
		return true 
	end

	local str = {}
	if getPokemonGender(cid) == SEX_MALE then
		table.insert(str, "He")
	elseif getPokemonGender(cid) == SEX_FEMALE then
		table.insert(str, "She")
	else
		table.insert(str, "It")
	end

	local h = getPlayerStorageValue(cid, 1008)
	if h >= tonumber(getConfigValue('PokemonStageVeryHappy')) then
		table.insert(str, " is very happy with you!")
	elseif h >= tonumber(getConfigValue('PokemonStageHappy')) then
		table.insert(str, " is happy.")
	elseif h >= tonumber(getConfigValue('PokemonStageOK')) then
		table.insert(str, " is unhappy.")
	elseif h >= tonumber(getConfigValue('PokemonStageSad')) then
		table.insert(str, " is sad.")
	elseif h >= tonumber(getConfigValue('PokemonStageMad')) then
		table.insert(str, " is mad.")
	else
		table.insert(str, " is very mad at you!")
	end
	return table.concat(str)
end

function doSetItemAttribute(item, key, value)
	doItemSetAttribute(item, key, value)
end

function deTransform(cid, check)
	if not isCreature(cid) then return true end

	local m = getCreatureMaster(cid)
	local p = getPlayerSlotItem(m, 8)

	if getItemAttribute(p.uid, "transTurn") ~= check then return true end

	setPlayerStorageValue(cid, 1010, getCreatureName(cid) == "Ditto" and "Ditto" or "Shiny Ditto")        --edited
	doRemoveCondition(cid, CONDITION_OUTFIT)
	doSendMagicEffect(getThingPos(cid), 184)
	doCreatureSay(cid, "DITTO!", TALKTYPE_MONSTER)
	doItemSetAttribute(p.uid, "transBegin", 0)
	doItemSetAttribute(p.uid, "transLeft", 0)
	doItemEraseAttribute(p.uid, "transName")
	adjustStatus(cid, p.uid, true, true, true)
end

function isTransformed(cid)
	return isCreature(cid) and not isInArray({-1, "Ditto", "Shiny Ditto"}, getPlayerStorageValue(cid, 1010))  --alterado v1.9
end

function doSendFlareEffect(pos)
	local random = {28, 29, 79}
	doSendMagicEffect(pos, random[math.random(1, 3)])
end

function isDay()
	local a = getWorldTime()
	if a >= 360 and a < 1080 then
		return true
	end
	return false
end

function doPlayerSendTextWindow(cid, p1, p2)
	if not isCreature(cid) then
		 return true
	end

	local item = 460
	local text = ""
	if type(p1) == "string" then
		doShowTextDialog(cid, item, p1)
	else
		doShowTextDialog(cid, p1, p2)
	end
end

function getClockString(tw)
	local a = getWorldTime()
	local b = a / 60
	local hours = math.floor(b)
	local minut = a - (60 * hours)

	if not tw then
		if hours < 10 then
			hours = "0"..hours..""
		end
		if minut < 10 then
			minut = "0"..minut..""
		end
		return hours..":"..minut
	else
		local sm = "a.m"
		if hours >= 12 then
			hours = hours - 12
			sm = "p.m"
		end
		if hours < 10 then
			hours = "0"..hours..""
		end
		if minut < 10 then
			minut = "0"..minut..""
		end
		return hours..":"..minut.." "..sm
	end
end

function doCorrectPokemonName(poke)
	return doCorrectString(poke)
end

function doCorrectString(str)
	local name = str:explode(" ")
	local final = {}
	for _, s in ipairs(name) do
		table.insert(final, s:sub(1, 1):upper()..s:sub(2, #s):lower())
	end

	return table.concat(final, (name[2] and " " or ""))
end   

function getHappinessRate(cid)
	if not isCreature(cid) then return 1 end
	local a = getPlayerStorageValue(cid, 1008)
		if a == -1 then return 1 end
	if a >= getConfigValue('PokemonStageVeryHappy') then
		return happinessRate[5].rate
	elseif a >= getConfigValue('PokemonStageHappy') then
		return happinessRate[4].rate
	elseif a >= getConfigValue('PokemonStageOK') then
		return happinessRate[3].rate
	elseif a >= getConfigValue('PokemonStageSad') then
		return happinessRate[2].rate
	else
		return happinessRate[1].rate
	end
	return 1
end

function doBodyPush(cid, target, go, pos)
	if not isCreature(cid) or not isCreature(target) then
		doRegainSpeed(cid)
		doRegainSpeed(target)
		return true
	end

	if go then
		local a = getThingPos(cid)
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		if not isPlayer(target) then
			doChangeSpeed(target, -getCreatureSpeed(target))
		end

		doChangeSpeed(cid, 800)
		doTeleportThing(cid, getThingPos(target))
		doChangeSpeed(cid, -800)
		addEvent(doBodyPush, 350, cid, target, false, a)
	else
		doChangeSpeed(cid, 800)
		doTeleportThing(cid, pos)
		doRegainSpeed(cid)
		doRegainSpeed(target)
	end
end

function doReturnPokemon(cid, pokemon, pokeball, effect, hideeffects, blockevo)
	if not pokemon then
		pokemon = getCreatureSummons(cid)[1]
	end

	if not isCreature(pokemon) then
		return true
	end
	
	local edit = true
	if not pokeball then
		pokeball = getPlayerSlotItem(cid, 8)
	end

	if blockevo then
		edit = false
		doPlayerSendCancel(cid, "Your pokemon couldn't evolve due to server mistakes, please wait until we fix the problem.")
	end

	local happy = getPlayerStorageValue(pokemon, 1008)
	local hunger = getPlayerStorageValue(pokemon, 1009)
	local pokelife = (getCreatureHealth(pokemon) / getCreatureMaxHealth(pokemon))

	if edit then
		doItemSetAttribute(pokeball.uid, "happy", happy)
		doItemSetAttribute(pokeball.uid, "hunger", hunger)
		doItemSetAttribute(pokeball.uid, "hp", pokelife)
	end

	if getCreatureName(pokemon) == "Ditto" then
		if isTransformed(pokemon) then
			local left = getItemAttribute(pokeball.uid, "transLeft") - (os.clock() - getItemAttribute(pokeball.uid, "transBegin"))
			doItemSetAttribute(pokeball.uid, "transLeft", left)
		end
	end

	if hideeffects then
		doRemoveCreature(pokemon)
		return true
	end

	local pokename = getPokeName(pokemon)
	local mbk = gobackmsgs[math.random(1, #gobackmsgs)].back:gsub("doka", pokename)
	local mbken = gobackmsgsen[math.random(1, #gobackmsgsen)].back:gsub("doka", pokename)
	local mbkes = gobackmsgses[math.random(1, #gobackmsgses)].back:gsub("doka", pokename)

	if getCreatureCondition(cid, CONDITION_INFIGHT) then
		if isCreature(getCreatureTarget(cid)) then
			doItemSetAttribute(pokeball.uid, "happy", happy - 5)
		else
			doItemSetAttribute(pokeball.uid, "happy", happy - 2)
		end
	end

	if pokeballs[getPokeballType(pokeball.itemid-1)] then
		doTransformItem(pokeball.uid, pokeball.itemid-1)
	end

	if getPlayerLanguage(cid) == 2 then
		doCreatureSay(cid, mbken, 19)
	end

	if getPlayerLanguage(cid) == 0 then
		doCreatureSay(cid, mbk, 19)
	end

	if getPlayerLanguage(cid) == 1 then
		doCreatureSay(cid, mbkes, 19)
	end

	doSendMagicEffect(getCreaturePosition(pokemon), effect)

	doRemoveCreature(pokemon)
    
    if useOTClient then
       doPlayerSendCancel(cid, '12//,hide')  --alterado v1.7
    end
    
	if useKpdoDlls then
		doUpdateMoves(cid)
	end
end

function doRegainSpeed(cid)
	if not isCreature(cid) then 
		return true 
	end

   local speed = PlayerSpeed
   if isMonster(cid) then
      speed = getCreatureBaseSpeed(cid)
   elseif isPlayer(cid) and isInArray({4, 5, 6}, getPlayerGroupId(cid)) then
      speed = 200*getPlayerGroupId(cid) 
   end

   doChangeSpeed(cid, -getCreatureSpeed(cid))
   if getCreatureCondition(cid, CONDITION_PARALYZE) == true then
      doRemoveCondition(cid, CONDITION_PARALYZE)
      doAddCondition(cid, paralizeArea2)             
   end

   doChangeSpeed(cid, speed)
   return speed
end

function doRegainSpeedLevel(cid)
	if not isCreature(cid) then
		return true
	end

	local speed = 220
	local spood = getCreatureSpeed(cid)
	local level = getPlayerLevel(cid)

	doChangeSpeed(cid, -spood)
	doChangeSpeed(cid, speed + (level * 3))
	setPlayerStorageValue(cid, 1242343, (speed + (level * 3)))
	return true
end

function isPosEqualPos(pos1, pos2, checkstackpos)
	if pos1.x ~= pos2.x or pos1.y ~= pos2.y and pos1.z ~= pos2.z then
		return false
	end
	if checkstackpos and pos1.stackpos and pos2.stackpos and pos1.stackpos ~= pos2.stackpos then
		return false
	end

	return true
end

function getRandomGenderByName(name)
	local rate = newpokedex[name]
	if not rate then 
		return 0 
	end

	rate = rate.gender
	if rate == 0 then
		gender = 3
	elseif rate == 1000 then
		gender = 4
	elseif rate == -1 then
		gender = 1
	elseif math.random(1, 1000) <= rate then
		gender = 4
	else
		gender = 3
	end
	return gender
end

function getRecorderPlayer(pos, cid)
	local ret = 0
	if cid and isPosEqual(getThingPos(cid), pos) then   --alterado v1.9
	   return cid
	end
	local s = {}
	s.x = pos.x
	s.y = pos.y
	s.z = pos.z
	
	for a = 0, 255 do
		s.stackpos = a
		local b = getTileThingByPos(s).uid
		if b > 1 and isPlayer(b) and getCreatureOutfit(b).lookType ~= 814 then
			ret = b
		end
	end
	return ret
end

function getRecorderCreature(pos, cid)
	local ret = 0
	if cid and isPosEqual(getThingPos(cid), pos) then   --alterado v1.9
	   return cid
	end

	local s = {}
	s.x = pos.x
	s.y = pos.y
	s.z = pos.z
	for a = 0, 255 do
		s.stackpos = a
		local b = getTileThingByPos(s).uid
		if b > 1 and isCreature(b) and getCreatureOutfit(b).lookType ~= 814 then
			ret = b
		end
	end
	return ret
end

function doCreatureSetOutfit(cid, outfit, time)
	doSetCreatureOutfit(cid, outfit, time)
end

function doMagicalFlower(cid, away)
	if not isCreature(cid) then return true end
	for x = -3, 3 do
		for y = -3, 3 do
		local a = getThingPos(cid)
		a.x = a.x + x
		a.y = a.y + y
			if away then
				doSendDistanceShoot(a, getThingPos(cid), 21)
			else
				doSendDistanceShoot(getThingPos(cid), a, 21)
			end
		end
	end
end		

function isItemPokeball(item)
	if not item then 
		return false 
	end

	for a, b in pairs (pokeballs) do
		if isInArray(b.all, item) then return true end
	end

	return false
end

function isPokeball(item)
	return isItemPokeball(item)
end

function getPokeballType(id)
	for a, b in pairs (pokeballs) do
		if isInArray(b.all, id) then
			return a
		end
	end
	return "none"
end

randomdiagonaldir = {
	[NORTHEAST] = {NORTH, EAST},
	[SOUTHEAST] = {SOUTH, EAST},
	[NORTHWEST] = {NORTH, WEST},
	[SOUTHWEST] = {SOUTH, WEST}
}

function doFaceOpposite(cid)
	local a = getCreatureLookDir(cid)
	local d = {
	[NORTH] = SOUTH,
	[SOUTH] = NORTH,
	[EAST] = WEST,
	[WEST] = EAST,
	[NORTHEAST] = SOUTHWEST,
	[NORTHWEST] = SOUTHEAST,
	[SOUTHEAST] = NORTHWEST,
	[SOUTHWEST] = NORTHEAST}
	doCreatureSetLookDir(cid, d[a])
end

function doFaceRandom(cid)
	local a = getCreatureLookDir(cid)
	local d = {
	[NORTH] = {SOUTH, WEST, EAST},
	[SOUTH] = {NORTH, WEST, EAST},
	[WEST] = {SOUTH, NORTH, EAST},
	[EAST] = {SOUTH, WEST, NORTH}}
	doChangeSpeed(cid, 1)
	doCreatureSetLookDir(cid, d[a][math.random(1, 3)])
	doChangeSpeed(cid, -1)
end

function getFaceOpposite(dir)
	local d = {
		[NORTH] = SOUTH,
		[SOUTH] = NORTH,
		[EAST] = WEST,
		[WEST] = EAST,
		[NORTHEAST] = SOUTHWEST,
		[NORTHWEST] = SOUTHEAST,
		[SOUTHEAST] = NORTHWEST,
		[SOUTHWEST] = NORTHEAST
	}
	return d[dir]
end

function getResistance(cid, combat)
	if isPlayer(cid) then 
		return false 
	end

	local poketype1 = pokes[getCreatureName(cid)].type
	local poketype2 = pokes[getCreatureName(cid)].type2
	local multiplier = 1
	if effectiveness[combat].super and isInArray(effectiveness[combat].super, poketype1) then
		multiplier = multiplier * 2
	end
	if poketype2 and effectiveness[combat].super and isInArray(effectiveness[combat].super, poketype2) then
		multiplier = multiplier * 2
	end
	if effectiveness[combat].weak and isInArray(effectiveness[combat].weak, poketype1) then
		multiplier = multiplier * 0.5
	end
	if poketype2 and effectiveness[combat].weak and isInArray(effectiveness[combat].weak, poketype2) then
		multiplier = multiplier * 0.5
	end
	if effectiveness[combat].non and isInArray(effectiveness[combat].non, poketype1) then
		multiplier = multiplier * 0
	end
	if poketype2 and effectiveness[combat].non and isInArray(effectiveness[combat].non, poketype2) then
		multiplier = multiplier * 0
	end

	if multiplier == 0.25 then
		multiplier = 0.5
	elseif multiplier == 4 then
		multiplier = 2
	end
	return multiplier
end

function getCreatureDirectionToTarget(cid, target, ranged)
	if not isCreature(cid) then 
		return true 
	end

	if not isCreature(target) then 
		return getCreatureLookDir(cid) 
	end

	local dirs = {
		[NORTHEAST] = {NORTH, EAST},
		[SOUTHEAST] = {SOUTH, EAST},
		[NORTHWEST] = {NORTH, WEST},
		[SOUTHWEST] = {SOUTH, WEST}
	}

	local x = getDirectionTo(getThingPos(cid), getThingPos(target), false)
	if x <= 3 then 
		return x
	else
		local xdistance = math.abs(getThingPos(cid).x - getThingPos(target).x)
		local ydistance = math.abs(getThingPos(cid).y - getThingPos(target).y)
		if xdistance > ydistance then
			return dirs[x][2]
		elseif ydistance > xdistance then
			return dirs[x][1]
		elseif isInArray(dirs[x], getCreatureLookDir(cid)) then
			return getCreatureLookDir(cid)
		else
			return dirs[x][math.random(1, 2)]
		end
	end
end

function getSomeoneDescription(cid)
	if isPlayer(cid) then 
		return getPlayerNameDescription(cid) 
	end

	if isMonster(cid) and getMonsterInfo(getCreatureName(cid)) ~= false and getMonsterInfo(getCreatureName(cid)).description then
		return getMonsterInfo(getCreatureName(cid)).description
	end
	
	return ""
end
	

function isGhostPokemon(cid)
	if not isCreature(cid) then 
		return false 
	end

	local ghosts = {"Gastly", "Haunter", "Gengar", "Shiny Gengar", "Misdreavus", "Shiny Abra"}
	return isInArray(ghosts, getCreatureName(cid))
end

function updateGhostWalk(cid)
	if not isCreature(cid) then 
		return false 
	end

	local pos = getThingPos(cid)
	pos.x = pos.x + 1
	pos.y = pos.y + 1
	local ret = getThingPos(cid)
	doTeleportThing(cid, pos, false)
	doTeleportThing(cid, ret, false)
	return true
end

function doRemoveElementFromTable(t, e)
	local ret = {}
	for a = 1, #t do
		if t[a] ~= e then
		table.insert(ret, t[a])
		end
	end
	return ret
end

function doFaceCreature(sid, pos)
	if not isCreature(sid) then 
		return true 
	end

	if getThingPos(sid).x == pos.x and getThingPos(sid).y == pos.y then 
		return true 
	end

	local ret = 0

	local ld = getCreatureLookDir(sid)
	local dir = getDirectionTo(getThingPos(sid), pos)
	local al = {
	[NORTHEAST] = {NORTH, EAST},
	[NORTHWEST] = {NORTH, WEST},
	[SOUTHEAST] = {SOUTH, EAST},
	[SOUTHWEST] = {SOUTH, WEST}}

	if dir >= 4 and isInArray(al[dir], ld) then 
		return true 
	end

	doChangeSpeed(sid, 1)
	if dir == 4 then
		ret = math.random(2, 3)
	elseif dir == 5 then
		ret = math.random(1, 2)
	elseif dir == 6 then
		local dirs = {0, 3}
		ret = dirs[math.random(1, 2)]
	elseif dir == 7 then
		ret = math.random(0, 1)
	else
		ret = getDirectionTo(getThingPos(sid), pos)
	end

	doCreatureSetLookDir(sid, ret)
	doChangeSpeed(sid, -1)
	return true
end

function doCreatureAddCondition(cid, condition)
	if not isCreature(cid) then 
		return true 
	end

	doAddCondition(cid, condition)
end

function doCreatureRemoveCondition(cid, condition)
	if not isCreature(cid) then 
		return true 
	end

	doRemoveCondition(cid, condition)
end

function setCD(item, tipo, tempo)
	if not tempo or not tonumber(tempo) then
		doItemEraseAttribute(item, tipo)
		return true
	end

	doItemSetAttribute(item, tipo, "cd:"..(tempo + os.time()).."")
	return tempo + os.time()
end

function getCD(item, tipo, limite)
	if not getItemAttribute(item, tipo) then
		return 0
	end

	local string = getItemAttribute(item, tipo):gsub("cd:", "")
	local number = tonumber(string) - os.time()

	if number <= 0 then
		return 0
	end

	if limite and limite < number then
		return 0
	end
	return number
end

function doSendMoveEffect(cid, target, effect)
	if not isCreature(cid) or not isCreature(target) then 
		return true 
	end

	doSendDistanceShoot(getThingPos(cid), getThingPos(target), effect)
	return true
end

function doSetItemActionId(uid, actionid)
	doItemSetAttribute(uid, "aid", actionid)
	return true
end

function threeNumbers(number)
	if number <= 9 then
		return "00"..number..""
	elseif number <= 99 then
		return "0"..number..""
	end
	return ""..number..""
end

function isBr(cid)
if getPlayerStorageValue(cid, 105505) ~= -1 then
	return true
end

return false
end

function isBeingUsed(ball)            
if not ball then 
	return false 
end

for a, b in pairs (pokeballs) do 
    if b.use == ball then 
		return true 
	end
end
return false
end

function doRemoveTile(pos)
	pos.stackpos = 0
	local sqm = getTileThingByPos(pos)
	doRemoveItem(sqm.uid,1)
end

function doCreateTile(id,pos) -- By mock
	doAreaCombatHealth(0,0,pos,0,0,0,CONST_ME_NONE)
	doCreateItem(id,1,pos)
end

function hasSqm(pos)
local f = getTileThingByPos(pos)
if f.itemid ~= 0 and f.itemid ~= 1 then
	return true
end

return false
end

function getPosDirs(p, dir) -- By MatheusMkalo
	return dir == 1 and {x=p.x-1, y=p.y, z=p.z} or dir == 2 and {x=p.x-1, y=p.y+1, z=p.z} or dir == 3 and {x=p.x, y=p.y+1, z=p.z} or dir == 4 and {x=p.x+1, y=p.y+1, z=p.z} or dir == 5 and {x=p.x+1, y=p.y, z=p.z} or dir == 6 and {x=p.x+1, y=p.y-1, z=p.z} or dir == 7 and {x=p.x, y=p.y-1, z=p.z} or dir == 8 and {x=p.x-1, y=p.y-1, z=p.z}
end

function canWalkOnPos(pos, creature, pz, water, sqm, proj)
if not pos then 
	return false 
end

if not pos.x then 
	return false 
end

if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}) ~= false and getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid <= 1 and sqm then 
	return false 
end

if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}) ~= false and getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 919 then 
	return false 
end

if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}) ~= false and isInArray({4820, 4821, 4822, 4823, 4824, 4825}, getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid) and water then
	 return false 
end

if getTopCreature(pos).uid > 0 and creature then
	return false 
end

--[[ if getTileInfo(pos) ~= false and getTileInfo(pos).protection and pz then 
	return false 
end ]]

local n = not proj and 3 or 2                                    --alterado v1.6
for i = 0, 255 do
    pos.stackpos = i                           
    local tile = getTileThingByPos(pos)        
    if tile ~= false and tile.itemid ~= 0 and i ~= 253 and not isCreature(tile.uid) then     --edited
        if hasProperty(tile.uid, n) or hasProperty(tile.uid, 7) then
            return false
        end
    end
end   
return true
end

function canWalkOnPos2(pos, creature, pz, water, sqm, proj)     --alterado v1.6
if not pos then return false end
if not pos.x then return false end
if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}) ~= false and getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid <= 1 and sqm then return false end
if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}) ~= false and getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 919 then return false end
if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}) ~= false and isInArray({4820, 4821, 4822, 4823, 4824, 4825}, getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid) and water then return false end
if getTopCreature(pos).uid > 0 and creature then return false end
if getTileInfo(pos) ~= false and getTileInfo(pos).protection and pz then return false end
return true
end

function getFreeTile(pos, cid)
	if canWalkOnPos(pos, true, false, true, true, false) then
		return pos
	end

	local positions = {}
	for a = 0, 7 do
		if canWalkOnPos(getPosByDir(pos, a), true, false, true, true, false) then
		table.insert(positions, pos)
		end
	end

	if #positions >= 1 then
		if isCreature(cid) then
			local range = 1000
			local ret = getThingPos(cid)
			for b = 1, #positions do
				if getDistanceBetween(getThingPos(cid), positions[b]) < range then
					ret = positions[b]
					range = getDistanceBetween(getThingPos(cid), positions[b])
				end
			end
			return ret
		else
			return positions[math.random(#positions)]
		end
	end
	return getThingPos(cid)
end

function isWalkable(pos, creature, proj, pz, water)-- by Nord
    if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 0 then return false end
    if isWater(getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid) and water then return false end
    if getTopCreature(pos).uid > 0 and creature then return false end
    if getTileInfo(pos).protection and pz then return false, true end
    local n = not proj and 3 or 2
    for i = 0, 255 do
        pos.stackpos = i
        local tile = getTileThingByPos(pos)
        if tile.itemid ~= 0 and not isCreature(tile.uid) then
            if hasProperty(tile.uid, n) or hasProperty(tile.uid, 7) then
                return false
            end
        end
    end
    return true
end

function isSummon(sid)
	return isCreature(sid) and getCreatureMaster(sid) ~= sid and isPlayer(getCreatureMaster(sid))
end 

function getItemsInContainerById(container, itemid) -- Function By Kydrai
local items = {}
if isContainer(container) and getContainerSize(container) > 0 then
   for slot=0, (getContainerSize(container)-1) do
       local item = getContainerItem(container, slot)
       if isContainer(item.uid) then
          local itemsbag = getItemsInContainerById(item.uid, itemid)
          for i=0, #itemsbag do
              table.insert(items, itemsbag[i])
          end
       else
          if itemid == item.itemid then
             table.insert(items, item.uid)
          end
       end
   end
end
return items
end

function getPokeballsInContainer(container) -- Function By Kydrai
	if not isContainer(container) then return {} end
	local items = {}
	if isContainer(container) and getContainerSize(container) > 0 then
		for slot=0, (getContainerSize(container)-1) do
			local item = getContainerItem(container, slot)
				if isContainer(item.uid) then
					local itemsbag = getPokeballsInContainer(item.uid)
					for i=0, #itemsbag do
						table.insert(items, itemsbag[i])
					end
				elseif isPokeball(item.itemid) then
					table.insert(items, item.uid)
				end
		end
	end
return items
end

function getItensUniquesInContainer(container)    --alterado v1.6
if not isContainer(container) then return {} end
local items = {}
if isContainer(container) and getContainerSize(container) > 0 then
   for slot=0, (getContainerSize(container)-1) do
       local item = getContainerItem(container, slot)
       if isContainer(item.uid) then
          local itemsbag = getItensUniquesInContainer(item.uid)
          for i=0, #itemsbag do
	          table.insert(items, itemsbag[i])
          end
       elseif getItemAttribute(item.uid, "unique") then
          table.insert(items, item)
       end
   end
end
return items
end
function isInHouse(cid)
if getTileHouseInfo(getThingPos(cid)) then
return true
else
return false
end
end

function isHouseTile(item)
local houseTilesId = {11674,414,405,424,1284,406,11667,458,14418,14420,14422,14424,14426,14428,14430,14432,14434,14436,14438,14440,14442,14444,14446}
if isInArray(houseTilesId, item) then
return true
else
return false
end
return true
end

function hasSpaceInContainer(container)                --alterado v1.6
if not isContainer(container) then return false end
if getContainerSize(container) < getContainerCap(container) then return true end

for slot = 0, (getContainerSize(container)-1) do
    local item = getContainerItem(container, slot)
    if isContainer(item.uid) then
       if hasSpaceInContainer(item.uid) then
          return true
       end
    end
end
return false
end
   
function doPlayerAddItemStacking(cid, itemid, quant) -- by mkalo
local item = getItemsInContainerById(getPlayerSlotItem(cid, 3).uid, itemid)
local piles = 0
if #item > 0 then
   for i,x in pairs(item) do
       if getThing(x).type < 100 then
          local it = getThing(x)
          doTransformItem(it.uid, itemid, it.type+quant)
          if it.type+quant > 100 then
             doPlayerAddItem(cid, itemid, it.type+quant-100)
          end
       else
          piles = piles+1
       end
   end
else
   return doPlayerAddItem(cid, itemid, quant)
end
if piles == #item then
   doPlayerAddItem(cid, itemid, quant)
end
end
	  
function getPlayerLanguage(cid) -- By Acubens
	if not isPlayer(cid) then
		return 0
	end

	if getPlayerAccountId(cid) <= 0 then
		return 0
	end

    local Lang = db.getResult("SELECT `language` FROM `accounts` WHERE `id` = " .. getPlayerAccountId(cid) .. " LIMIT 1")
    if Lang:getID() ~= -1 then
        local langid = Lang:getDataInt("language")
        return langid
    end
	
    return LUA_ERROR
end

function doPlayerSetLanguage(cid, new) -- By Drazyn1291
    local acc = getPlayerAccountId(cid)
    if new == 2 then
        db.executeQuery("UPDATE `accounts` SET language = 2 WHERE `id` = " .. acc)
    elseif new == 1 then
        db.executeQuery("UPDATE `accounts` SET language = 1 WHERE `id` = " .. acc)
    else
        db.executeQuery("UPDATE `accounts` SET language = 0 WHERE `id` = " .. acc)
    end  
end