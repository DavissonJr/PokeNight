function onLogout(cid)
    if not isCreature(cid) then
      return true
    end

   if #getCreatureSummons(cid) >= 1 then
      local ball = getPlayerSlotItem(cid, 8)
      local btype = getPokeballType(ball.itemid)
      local effect = pokeballs[btype] and pokeballs[btype].effect or false
      if not effect then
         effect = 21
      end

      doReturnPokemon(cid, getCreatureSummons(cid)[1], ball, effect)
      --doPlayerSendCancel(cid, "Voc no pode deslogar com poke fora da ball")
      return false
   end

   -- Thalles Vitor - Online Reward --
   resetOnlineTime(cid)
   doSetPlayerSpeedLevel(cid)
   return true
end

local deathtexts = {"Oh no! POKENAME, come back!", "Come back, POKENAME!", "That's enough, POKENAME!", "You did well, POKENAME!",
		    "You need to rest, POKENAME!", "Nice job, POKENAME!", "POKENAME, you are too hurt!"}

function onDeath(cid, deathList)
   if not isCreature(cid) then
      return true
   end

   -- Thalles Vitor - Guardian --
      local stor1 = tonumber(getPlayerStorageValue(cid, GUARDIAN_STORAGE_ISGUARDIAN)) or 0
      if stor1 > 0 then
         doRemoveCreature(cid)
         return false
      end
   --

    local owner = getCreatureMaster(cid)  
    if not isPlayer(owner) then return true end
   
	local thisball = getPlayerSlotItem(owner, 8)
	local ballName = getItemAttribute(thisball.uid, "poke")
	
    local btype = getPokeballType(thisball.itemid)
	if pokeballs[btype] then
		doSendMagicEffect(getThingPos(cid), pokeballs[btype].effect)
		doTransformItem(thisball.uid, pokeballs[btype].off)
	end
	
	doPlayerSendTextMessage(owner, 22, "Seu pokémon desmaiou.")

	--local say = deathtexts[math.random(1, #deathtexts)]
	--local texto = string.gsub(say, "POKENAME", getCreatureName(cid))
	--doCreatureSay(owner, texto)

	doItemSetAttribute(thisball.uid, "hp", 0)
	doItemSetAttribute(thisball.uid, "hunger", getPlayerStorageValue(cid, 1009))

    if useOTClient then
       doPlayerSendCancel(owner, '12//,hide')      --alterado v1.7
    end
	
	-- Thalles Vitor - PokeBar --
		doItemSetAttribute(thisball.uid, POKEMON_ATTRIBUTE_HEALTH, 0)
		updateBarStatus(owner, "death") -- Thalles
	--

	doRemoveCreature(cid)
   return false
end