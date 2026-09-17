function doSendPokeBall(cid, catchinfo, showmsg, fullmsg, typeee)

	local name = catchinfo.name
	local pos = catchinfo.topos
	local topos = {}
	topos.x = pos.x
	topos.y = pos.y
	topos.z = pos.z
	
	local newid = catchinfo.newid
	local catch = catchinfo.catch
	local fail = catchinfo.fail
	local rate = catchinfo.rate * 2.2

	if string.find(tostring(name), "Horder") then
		rate = catchinfo.rate / 1.1
	end
	
	local basechance = catchinfo.chance

	-- Thalles Vitor - Double Catch --
		if getGlobalStorageValue(5552) >= 1 then
			rate = rate * getGlobalStorageValue(5552)
			doSendAnimatedText(getThingPos(cid), "+".. rate .. " (DOUBLE CATCH)", math.random(0, 255))
		end
	--
	
	if pokes[getPlayerStorageValue(cid, 854788)] and name == getPlayerStorageValue(cid, 854788) then 
	   rate = 15
    end

	local corpse = getTopCorpse(topos).uid
	--[[ if getItemInfo(corpse) == nil or getItemInfo(corpse) == false then
		doPlayerSendTextMessage(cid, 25, "Não é possível capturar: " .. name .. " relate ao administrador.")
		return true
	end ]]

	if not isCreature(cid) then
		doSendMagicEffect(topos, CONST_ME_POFF)
	return true
	end

	doItemSetAttribute(corpse, "catching", 1)

	local levelChance = 2 * 0.02

	local totalChance = math.ceil(basechance * (1.2 + levelChance))
	local thisChance = math.random(0, totalChance)
	local myChance = math.random(0, totalChance)
	local chance = (1 * rate + 1) / totalChance
	chance = doMathDecimal(chance * 100)
		
	local gender = tonumber(getItemAttribute(corpse, "gender")) or math.random(3, 4)
	if gender <= 0 then
		gender = math.random(3, 4)
	end

	local level = tonumber(getItemAttribute(corpse, "level")) or 1
	if level <= 0 then
		level = 1
	end

	local horderLookType = tonumber(getItemAttribute(corpse, "addonLookType")) or 0
	local isHorder = tonumber(getItemAttribute(corpse, "isHorder")) or 0
	if rate >= totalChance then

		local status = {}
		status.gender = gender
		status.level = level
		status.isHorder = isHorder -- Thalles Vitor - Horder
		status.horderLookType = horderLookType-- Thalles Vitor - Horder
		status.happy = 160

		doRemoveItem(corpse, 1)
		doSendMagicEffect(topos, catch)
		addEvent(doCapturePokemon, 3000, cid, name, newid, status, typeee)  
		return true
	end

	if totalChance <= 1 then 
		totalChance = 1 
	end

	local myChances = {}
	local catchChances = {}
	for cC = 0, totalChance do
		table.insert(catchChances, cC)
	end

	for mM = 1, rate do
		local element = catchChances[math.random(1, #catchChances)]
		table.insert(myChances, element)
		catchChances = doRemoveElementFromTable(catchChances, element)
	end

	local status = {}
	status.gender = gender
	status.level = level
	status.isHorder = isHorder
	status.horderLookType = horderLookType-- Thalles Vitor - Horder
	status.happy = 160
	status.happy = 70

	doRemoveItem(corpse, 1)

	local doCatch = false
	for check = 1, #myChances do
		if thisChance == myChances[check] then
			doCatch = true
		end
	end

	if getPlayerGroupId(cid) >= 6 then
		doCatch = true
	end

	if typeee == "master" then
		doCatch = true
	end

	if doCatch then
		doSendMagicEffect(topos, catch)
		addEvent(doCapturePokemon, 3000, cid, name, newid, status, typeee) 
	else
		addEvent(doNotCapturePokemon, 3000, cid, name, typeee) 
		doSendMagicEffect(topos, fail)
	end
end

function doCapturePokemon(cid, poke, ballid, status, typeee)  

	if not isCreature(cid) then
		return true
	end

	doAddPokemonInOwnList(cid, poke)
	doAddPokemonInCatchList(cid, poke)

	local description = "Contains a "..poke.."."
	local gender = status.gender
	local happy = 250
                 
    addPokeToPlayer2(cid, poke, 0, status.level, gender, status.isHorder, status.horderLookType, typeee, false)   
	doPlayerSendTextMessage(cid, 27, "Você capturou um pokémon! ("..poke..")!")
	doSendMagicEffect(getThingPos(cid), 173) 

	local catch = tonumber(getPlayerStorageValue(cid, 22235)) or 0
	if catch <= 0 then
		setPlayerStorageValue(cid, 22235, 0)
	end

	setPlayerStorageValue(cid, 22235, getPlayerStorageValue(cid, 22235)+1)
	doSendPlayerExtendedOpcode(cid, 104, tonumber(getPlayerStorageValue(cid, 22235)).."@")

	-- Thalles Vitor - Task
	local category = getPlayerStorageValue(cid, TASK_SAVECATEGORY2)
    if category == "monsters" then
        local index = tonumber(getPlayerStorageValue(cid, TASK_SAVEMONSTERS2_INDEX)) or 0
        if index <= 0 then index = 1 end

        for k, v in pairs(monsters) do
            if k == index then
                if v.pokemon == poke and v.type == "catch" then
                    local valor = tonumber(getPlayerStorageValue(cid, v.countStorage)) or 0
                    setPlayerStorageValue(cid, v.countStorage, valor+1)
					if tonumber(getPlayerStorageValue(cid, v.countStorage)) >= v.count then
                        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Task completada!")
                        onEndMission(cid)
                        return true
                    end

                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Continue para completar a TASK!")
                end
            end
        end
    end
end

function doNotCapturePokemon(cid, poke, typeee)  

	if not isCreature(cid) then
		return true
	end

	if #getCreatureSummons(cid) >= 1 then
		doSendMagicEffect(getThingPos(getCreatureSummons(cid)[1]), 166)
	else
		doSendMagicEffect(getThingPos(cid), 166)
	end
end

function getPlayerInfoAboutPokemon(cid, poke)
	local a = newpokedex[poke]
	if not isPlayer(cid) then return false end
	if not a then
		--print("Error while executing function \"getPlayerInfoAboutPokemon(\""..getCreatureName(cid)..", "..poke..")\", "..poke.." doesn't exist.")
		return false
	end

	local b = getPlayerStorageValue(cid, a.storage)
	if b == -1 then
		setPlayerStorageValue(cid, a.storage, poke..":")
	end

	local ret = {}
	if string.find(b, "catch,") then
		ret.catch = true
	else
		ret.catch = false
	end

	if string.find(b, "dex,") then
		ret.dex = true
	else
		ret.dex = false
	end

	if string.find(b, "use,") then
		ret.use = true
	else
		ret.use = false
	end
	return ret
end

function doAddPokemonInOwnList(cid, poke)

	if getPlayerInfoAboutPokemon(cid, poke).use then 
		return true 
	end

	local a = newpokedex[poke]
	local b = getPlayerStorageValue(cid, a.storage)
	setPlayerStorageValue(cid, a.storage, b.." use,")
end

function isPokemonInOwnList(cid, poke)
	if getPlayerInfoAboutPokemon(cid, poke).use then
		 return true 
	end

	return false
end

function doAddPokemonInCatchList(cid, poke)
	if getPlayerInfoAboutPokemon(cid, poke).catch then
		 return true 
	end

	local a = newpokedex[poke]
	local b = getPlayerStorageValue(cid, a.storage)

	setPlayerStorageValue(cid, a.storage, b.." catch,")
end

function getCatchList(cid)
local ret = {}

for a = 1000, 1251 do
	local b = getPlayerStorageValue(cid, a)
	if b ~= 1 and string.find(b, "catch,") then
		table.insert(ret, oldpokedex[a-1000][1])
	end
end

return ret
end