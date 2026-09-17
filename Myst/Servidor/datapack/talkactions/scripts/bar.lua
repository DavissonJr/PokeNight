-- Criado por Thalles Vitor --
-- PokeBar - Soltar o pokemon --

local EFFECTS = {
	--[OutfitID] = {Effect}
	["Magmar"] = 35, 
	["Shiny Magmar"] = 35,
	["Shiny Magmortar"] = 35,
	["Shiny Electivire"] = 48,
	["Magmortar"] = 35,
	["Electivire"] = 48,	
	["Jynx"] = 17, --alterado v1.5
	["Shiny Jynx"] = 17, 
	["Piloswine"] = 205, --alterado v1.8
	["Swinub"] = 205, 
}

local function goPoke(cid, item)
	if not isPlayer(cid) then
		return true
	end

	if item.uid ~= getPlayerSlotItem(cid, CONST_SLOT_FEET).uid then
		doPlayerSendCancel(cid, "You must put your pokeball in the correct place!")
	return TRUE
	end

	if #getCreatureSummons(cid) >= 1 then
		return true
	end

	if getPlayerStorageValue(cid, 1338) - os.time() > 0 then
		doBroadcastMessage(getCreatureName(cid) .. " está tentando fugir da prisão.")
		doPlayerSendTextMessage(cid, 25, "Um foragido não pode fugir da prisão.")
		return true
	end

	if getPlayerStorageValue(cid, 12005) - os.time() > 0 then
		doPlayerSendCancel(cid, "Aguarde: " .. getPlayerStorageValue(cid, 12005) - os.time() .. " segundos para soltar o pokémon novamente.")
		return true
	end

	local ballName = getItemAttribute(item.uid, "poke")
	local btype = getPokeballType(item.itemid)
	local usando = pokeballs[btype]
	local usando2 = pokeballs[btype]
	if not usando then
		doPlayerSendTextMessage(cid, 27, "Error in your pokeball.")
		--print(getCreatureName(cid).."'s pokeball presented error. Pokeball type: "..btype.." - NOT IN pokeballs TABLE (lib)")
		return true
	end
	usando = usando.use

	local effect = pokeballs[btype].effect
	if not effect then
		effect = 21
	end

	local thishp = getItemAttribute(item.uid, "hp") or 100

	if thishp <= 0 then
		if isInArray(pokeballs[btype].all, item.itemid) then
			doTransformItem(item.uid, pokeballs[btype].off)
			doItemSetAttribute(item.uid, "hp", 0)
			doPlayerSendCancel(cid, "This pokemon is fainted.")
		    return true
		end
	end

	if item.itemid ~= usando2.use and item.itemid ~= usando2.on then
		doPlayerSendCancel(cid, "Pokemon fainted.")
		return true
	end

	local pokemon = getItemAttribute(item.uid, "poke")

	if not pokes[pokemon] then
	return true
	end

	local x = pokes[pokemon]
	local boost = getItemAttribute(item.uid, "boost") or 0

	if getPlayerLevel(cid) < (x.level) then
	doPlayerSendCancel(cid, "You need level "..(x.level).." to use this pokemon.")
	return true
	end

	local nature = getItemAttribute(item.uid, "nature")
	if not nature then
		doItemSetAttribute(item.uid, "nature", NATURE_TABLE_NEWPOKE[math.random(1, #NATURE_TABLE_NEWPOKE)].nature)
	end

	if pokemon == "Ditto" and getItemAttribute(item.uid, "gender") ~= 1 then
		doItemSetAttribute(item.uid, "gender", 1)
	end

	doSummonMonster(cid, pokemon)

	local pk = getCreatureSummons(cid)[1]
	if not isCreature(pk) then return true end

	if getCreatureName(pk) == "Ditto" or getCreatureName(pk) == "Shiny Ditto" then --edited

		local left = getItemAttribute(item.uid, "transLeft")
		local name = getItemAttribute(item.uid, "transName")

		if left and left > 0 then
			setPlayerStorageValue(pk, 1010, name)
			doSetCreatureOutfit(pk, {lookType = getItemAttribute(item.uid, "transOutfit")}, -1)
			addEvent(deTransform, left * 1000, pk, getItemAttribute(item.uid, "transTurn"))
			doItemSetAttribute(item.uid, "transBegin", os.clock())
		else
			setPlayerStorageValue(pk, 1010, getCreatureName(pk) == "Ditto" and "Ditto" or "Shiny Ditto")     --edited
		end
	end

	if isGhostPokemon(pk) then doTeleportThing(pk, getPosByDir(getThingPos(cid), math.random(0, 7)), false) end

	-- Ditto Memory (Soltar Pokemon)
	local ditto1 = getItemAttribute(item.uid, "copyedDitto1") and getItemInfo(getItemAttribute(item.uid, "copyedDitto1")).clientId or getItemInfo(2395).clientId
	local ditto2 = getItemAttribute(item.uid, "copyedDitto2") and getItemInfo(getItemAttribute(item.uid, "copyedDitto2")).clientId or getItemInfo(2395).clientId
	local ditto3 = getItemAttribute(item.uid, "copyedDitto3") and getItemInfo(getItemAttribute(item.uid, "copyedDitto3")).clientId or getItemInfo(2395).clientId

	doSendPlayerExtendedOpcode(cid, 30, "".."@")
	if pokemon:find("Ditto") or getItemAttribute(item.uid, "copyName") then
		doSendPlayerExtendedOpcode(cid, 30, "ditto".."@")
		doSendPlayerExtendedOpcode(cid, 31, "show".."@"..ditto1.."@"..ditto2.."@"..ditto3.."@")
	end

	doCreatureSetLookDir(pk, 2)
	adjustStatus(pk, item.uid, true, true, true)
	setPlayerStorageValue(cid, 12005, os.time()+1.5)

   if pokeballs[getPokeballType(item.itemid+1)] then
  	 doTransformItem(item.uid, item.itemid+1)
   end
   
   updateBarStatus(cid, "on")

   local pokename = getPokeName(pk) --alterado v1.7 
   

	local mgo = gobackmsgs[math.random(1, #gobackmsgs)].go:gsub("doka", pokename)
	doCreatureSay(cid, mgo, TALKTYPE_ORANGE_1)
    
	doSendDistanceShoot(getCreaturePosition(pk), getThingPosWithDebug(cid), 47)
	doSendDistanceShoot(getThingPosWithDebug(cid), getCreaturePosition(pk), 47)   
   doSendMagicEffect(getCreaturePosition(pk), effect)
  		    
    -- Thalles Vitor - Poke Info --
		sendGoPokemonInfo(cid, item, pk)
		sendGoPokemonInfoAddons(cid, pk)
	--

	-- Thalles Vitor - Auto Spell --
		--[[ addEvent(autospell, 10, cid) ]]
	--

	if useOTClient then
	   doPlayerSendCancel(cid, '12//,show') --alterado v1.7
    end

	if useKpdoDlls then
		doUpdateMoves(cid)
	end

	local atributo = getItemAttribute(item.uid, "lastAddon")
	if atributo == nil or atributo == "" then
		--
	else
		doSetCreatureOutfit(pk, {lookType = atributo}, -1)
	end
return true
end

local function voltarPoke(cid, ball, param, numeration)
	if not isPlayer(cid) then
		return true
	end
	
	if getPlayerStorageValue(cid, 1338) - os.time() > 0 then
		doBroadcastMessage(getCreatureName(cid) .. " estï¿½ tentando fugir da prisï¿½o.")
		doPlayerSendTextMessage(cid, 25, "Um foragido nï¿½o pode fugir da prisï¿½o.")
		return true
	end

	local z = getCreatureSummons(cid)[1]
	local btype = getPokeballType(ball.itemid)
	local usando = pokeballs[btype]
	if not usando then
		doPlayerSendTextMessage(cid, 27, "Error in your pokeball.")
		--print(getCreatureName(cid).."'s pokeball presented error. Pokeball type: "..btype.." - NOT IN pokeballs TABLE (lib)")
		return true
	end

	local effect = pokeballs[btype].effect
	if not effect then
		effect = 21
	end

	-- Thalles Vitor - Poke Info --
	sendBackPokemonInfo(cid)
	--

	local pokename = getPokeName(z)
	local mbk = gobackmsgs[math.random(1, #gobackmsgs)].back:gsub("doka", pokename)
	local mbken = gobackmsgsen[math.random(1, #gobackmsgsen)].back:gsub("doka", pokename)
	local mbkes = gobackmsgses[math.random(1, #gobackmsgses)].back:gsub("doka", pokename)

	if getPlayerLanguage(cid) == 2 then
		doCreatureSay(cid, mbken, 19)
	end

	if getPlayerLanguage(cid) == 0 then
		doCreatureSay(cid, mbk, 19)
	end

	if getPlayerLanguage(cid) == 1 then
		doCreatureSay(cid, mbkes, 19)
	end

	local ditto1 = getItemAttribute(ball.uid, "copyedDitto1") and getItemInfo(getItemAttribute(ball.uid, "copyedDitto1")).clientId or getItemInfo(2395).clientId
	local ditto2 = getItemAttribute(ball.uid, "copyedDitto2") and getItemInfo(getItemAttribute(ball.uid, "copyedDitto2")).clientId or getItemInfo(2395).clientId
	local ditto3 = getItemAttribute(ball.uid, "copyedDitto3") and getItemInfo(getItemAttribute(ball.uid, "copyedDitto3")).clientId or getItemInfo(2395).clientId

	if pokename:find("Ditto") or getItemAttribute(ball.uid, "copyName") then
		doSendPlayerExtendedOpcode(cid, 30, "".."@")
		doSendPlayerExtendedOpcode(cid, 31, "hide".."@"..ditto1.."@"..ditto2.."@"..ditto3.."@")
	end
	
	doReturnPokemon(cid, z, ball, effect)
	updateBarStatus(cid, "off")

	doPlayerSendCancel(cid, '12//,hide') --alterado v1.7
	doUpdateMoves(cid)
	
	if param ~= nil and tonumber(param) > 0 and tonumber(param) ~= tonumber(numeration) then
		goPoke(cid, getPlayerSlotItem(cid, 8))
	end
end

function onSay(cid, words, param, channel)
	if getPlayerStorageValue(cid, 17000) >= 1 or getPlayerStorageValue(cid, 17001) >= 1 or getPlayerStorageValue(cid, 63215) >= 1 then
		doPlayerSendTextMessage(cid, 22, "Nï¿½o pode usar pokï¿½mon em situaï¿½ï¿½o especial!")
		return true
	end
	
	if getPlayerStorageValue(cid, 1338) - os.time() > 0 then
		doBroadcastMessage(getCreatureName(cid) .. " estï¿½ tentando fugir da prisï¿½o.")
		doPlayerSendTextMessage(cid, 25, "Um foragido nï¿½o pode fugir da prisï¿½o.")
		return true
	end

    if tonumber(param) <= 0 then return true end

	-- Aqui ele deve voltar o pokemon anterior, salvar as informacoes desse pokemon anterior na pokebola e soltar um outro pokemon
	local backFirstPoke = false
	if getPlayerSlotItem(cid, 8).uid > 0 and isPokeball(getPlayerSlotItem(cid, 8).itemid) then
		local ball = getPlayerSlotItem(cid, 8)
		numeration = getItemAttribute(ball.uid, "numeration")

		if #getCreatureSummons(cid) > 0 then
			local pokemon = getCreatureSummons(cid)
			local happy = getPlayerStorageValue(pokemon[1], 1008)
			local hunger = getPlayerStorageValue(pokemon[1], 1009)
			local pokelife = (getCreatureHealth(pokemon[1]) / getCreatureMaxHealth(pokemon[1]))

			doItemSetAttribute(ball.uid, "happy", happy)
			doItemSetAttribute(ball.uid, "hunger", hunger)
			doItemSetAttribute(ball.uid, "hp", pokelife)

			local pokename = getPokeName(pokemon[1])
			local mbk = gobackmsgs[math.random(1, #gobackmsgs)].back:gsub("doka", pokename)
			local mbken = gobackmsgsen[math.random(1, #gobackmsgsen)].back:gsub("doka", pokename)
			local mbkes = gobackmsgses[math.random(1, #gobackmsgses)].back:gsub("doka", pokename)

			if getPlayerLanguage(cid) == 2 then
				doCreatureSay(cid, mbken, 19)
			end

			if getPlayerLanguage(cid) == 0 then
				doCreatureSay(cid, mbk, 19)
			end

			if getPlayerLanguage(cid) == 1 then
				doCreatureSay(cid, mbkes, 19)
			end

			-- Thalles Vitor - Poke Info --
			sendBackPokemonInfo(cid)
			--

			if pokeballs[getPokeballType(ball.itemid)] then
				doTransformItem(ball.uid, pokeballs[getPokeballType(ball.itemid)].on)
			end

			local ditto1 = getItemAttribute(ball.uid, "copyedDitto1") and getItemInfo(getItemAttribute(ball.uid, "copyedDitto1")).clientId or getItemInfo(2395).clientId
			local ditto2 = getItemAttribute(ball.uid, "copyedDitto2") and getItemInfo(getItemAttribute(ball.uid, "copyedDitto2")).clientId or getItemInfo(2395).clientId
			local ditto3 = getItemAttribute(ball.uid, "copyedDitto3") and getItemInfo(getItemAttribute(ball.uid, "copyedDitto3")).clientId or getItemInfo(2395).clientId

			if pokename:find("Ditto") or getItemAttribute(ball.uid, "copyName") then
				doSendPlayerExtendedOpcode(cid, 30, "".."@")
				doSendPlayerExtendedOpcode(cid, 31, "hide".."@"..ditto1.."@"..ditto2.."@"..ditto3.."@")
			end

			doSendMagicEffect(getThingPos(pokemon[1]), pokeballs[getPokeballType(ball.itemid)].effect)
			doRemoveCreature(pokemon[1])

			doPlayerSendCancel(cid, '12//,hide') --alterado v1.7
			doUpdateMoves(cid)

			updateBarStatus(cid, "off")
			backFirstPoke = true

			local summonSize = #getCreatureSummons(cid)
			addEvent(function()
				if isPlayer(cid) then
					if summonSize >= 1 then
						voltarPoke(cid, getPlayerSlotItem(cid, 8), param, numeration)
					else
						if param ~= nil and tonumber(param) > 0 and tonumber(param) ~= tonumber(numeration) then
							goPoke(cid, getPlayerSlotItem(cid, 8), param)
						end
					end
				end
			end, 0)
		end
	end

    dropPokemon(cid, tonumber(param))
	local ball = getPlayerSlotItem(cid, 8)
	if ball.uid <= 0 then
		return true
	end

	local hp = getItemAttribute(ball.uid, "hp") or 100
	if hp <= 0 then
		doPlayerSendCancel(cid, "Pokemon fainted.")
		return true
	end

	if backFirstPoke == false then -- Apenas soltar caso seja sempre o mesmo pokemon e nï¿½o um pokemon diferente do slot
		local pk = getCreatureSummons(cid)
		if #pk >= 1 then
			voltarPoke(cid, ball, param, param)
		else
			goPoke(cid, ball, param)
		end
	end
	return true
end
