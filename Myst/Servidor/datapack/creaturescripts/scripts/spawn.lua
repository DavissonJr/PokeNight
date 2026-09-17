local shinys = {
"Venusaur", "Charizard", "Blastoise", "Butterfree", "Beedrill", "Pidgeot", "Rattata", "Raticate", "Raichu", "Zubat", "Golbat", "Paras", "Parasect", 
"Venonat", "Venomoth", "Growlithe", "Arcanine", "Abra", "Alakazam", "Tentacool", "Tentacruel", "Farfetch'd", "Grimer", "Muk", "Gengar", "Onix", "Krabby", 
"Kingler", "Voltorb", "Electrode", "Cubone", "Marowak", "Hitmonlee", "Hitmonchan", "Tangela", "Horsea", "Seadra", "Scyther", "Jynx", "Electabuzz", "Pinsir", 
"Magikarp", "Gyarados", "Snorlax", "Dragonair", "Dratini"}
local raros = {"Dragonite"}         

local pokesLvl = {"Regice", "Registeel", "Regirock", "Furious Charizard", "Primal Kyogre", "Cresselia", "Regigigas", "Lugia", "Giratina", "Rayquaza",
"Entei", "Suicune", "Raikou", "Celebi", "Shiny Celebi", "Latios", "Latias", "Shaymin", "Hoopa", "Mew", "Mewtwo", "Palkia", 
"Articuno", "Zapdos", "Moltres", "Kyogre", "Guardian Magmar", "Dialga", "Charizard Halloween", "Giant Gengar", "Marowak Halloween", "Jirachi", "Groudon",
"Darkrai", "Darkrai Nightmare", "Primal Dialga", "Zekrom", "Kyurem", "White Kyurem", "Black Kyurem", "Reshiram",
"Horder Alakazam", "Horder Charizard", "Horder Electabuzz", "Horder Feraligatr", "Horder Gengar", "Horder Lapras", "Horder Nidoking", "Horder Poliwrath", "Horder Steelix", "Horder Tyranitar", "Horder Blastoise", "Horder Flygon"}                      

function setRandomLevel(cid)
    if not isCreature(cid) then return true end
	if tonumber(getPlayerStorageValue(cid, 999)) > 0 then return true end -- Poke House
	if isSummon(cid) then return true end
	
	if isInArray(pokesLvl, getCreatureName(cid)) then
		local level = math.random(90, 100)
		setPlayerStorageValue(cid, 1000, level)
		doCreatureSetNick(cid, getCreatureName(cid) .. " [" .. level .. "]")
	else
		local level = math.random(35, 45)
		setPlayerStorageValue(cid, 1000, level)
		doCreatureSetNick(cid, getCreatureName(cid) .. " [" .. level .. "]")
	end
	return true
end

local onlyMale = {"Glalie"}
local onlyFemale = {"Froslass"}
local function doSetRandomGender(cid)
	if not isCreature(cid) then 
		return true 
	end

	if isSummon(cid) then 
		return true 
	end

	if tonumber(getPlayerStorageValue(cid, 999)) > 0 then return true end -- Poke House
	local gender = 0
	local name = getCreatureName(cid)
	if not newpokedex[name] then 
		return true 
	end

	local rate = newpokedex[name].gender
	if rate == 0 then
		gender = 3
	elseif rate == 1000 then
		gender = 4
	elseif rate == -1 then
		gender = 1
	elseif math.random(1, 1000) <= rate then
		gender = math.random(3, 4)
	elseif gender == 500 then
		gender = math.random(3, 4)
	else
		gender = math.random(3, 4)
	end

	if isInArray(onlyMale, name) then
		gender = 4
	elseif isInArray(onlyFemale, name) then
		gender = 3
	end
		
	doCreatureSetSkullType(cid, gender)
end

local function doShiny(cid)
   if not isCreature(cid) then
	   return true
   end

   if isSummon(cid) then
	   return true 
   end

   if isNpcSummon(cid) then 
	  return true 
   end

   if tonumber(getPlayerStorageValue(cid, 999)) > 0 then return true end -- Poke House
    local chance = 1.1
	if isInArray(shinys, getCreatureName(cid)) then
		chance = 0.1     
	elseif isInArray(raros, getCreatureName(cid)) then
		chance = 0.1   
	end 

    if math.random(1, 1000) <= chance*10 then  
      doSendMagicEffect(getThingPos(cid), 18)               
      local name, pos = "Shiny ".. getCreatureName(cid), getThingPos(cid)
      doRemoveCreature(cid)
      local shi = doCreateMonster(name, pos, false)
	  --print("Um " .. name .. " foi spawnado em X=" .. pos.x .. " Y=" .. pos.y .. " Z=" .. pos.z)
      setPlayerStorageValue(shi, 74469, 1)      
   else
       setPlayerStorageValue(cid, 74469, 1)
   end
end
                                                                
function onSpawn(cid)

    registerCreatureEvent(cid, "Experience")
	registerCreatureEvent(cid, "GeneralConfiguration")
	registerCreatureEvent(cid, "DirectionSystem")
	registerCreatureEvent(cid, "CastSystem")

	-- Thalles Vitor
	registerCreatureEvent(cid, "BossLife")
	
	if isSummon(cid) then
		registerCreatureEvent(cid, "SummonDeath")
		return true
	end

	if getCreatureName(cid) == "Mime Jr." then
		local pos = getCreaturePosition(cid)
		doRemoveCreature(cid)

		doCreateMonster("Mr. Mime", pos, false)
	end
	
	doSetRandomGender(cid)
	doShiny(cid)
	adjustWildPoke(cid)
	setRandomLevel(cid)
	onSpawnHorderLeader(cid)

	return true
end