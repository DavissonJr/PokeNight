function onKill(cid, target)
 if isSummon(target) then
   return true
 end

 if isNpcSummon(target) then
   return true
 end

 local posss = getCreaturePosition(cid)
 local feet = getPlayerSlotItem(cid, CONST_SLOT_FEET)
 if feet.uid <= 0 then
    return true
 end

 local chck = tonumber(getItemAttribute(feet.uid, "exp")) or 0
 local chckc = tonumber(getItemAttribute(feet.uid, "level")) or 0
 local summons = getCreatureSummons(cid)
 local xpGain = math.random(1000, 1700)

 if #summons <= 0 then
    return true
 end
 
 if chckc == 100 then 
    return true
 end
 
 if getTileInfo(getThingPos(cid)).pvp then 
    return true
 end
 
 local stor = tonumber(getPlayerStorageValue(cid, 990)) or 0
 if stor > 0 then
    return true
 end
 
 local level = tonumber(getItemAttribute(feet.uid, "level")) or 1
 local exp = tonumber(getItemAttribute(feet.uid, "exp")) or 0
 local pk = getCreatureSummons(cid)[1]
 
 if tonumber(getPlayerStorageValue(pk, 15000)) >= 1 then
	return true
 end

 if not isPlayer(target) and level < 100 and exp >= 0 and (xpGain + exp) < (level * 5000) then
    doItemSetAttribute(feet.uid, "exp", chck +xpGain) 
    doPlayerSendCancel(cid, "Seu "..getPokeName(getCreatureSummons(cid)[1]).." ganhou ".. xpGain.." de experiência por derrotar "..getCreatureName(target)..".")
    --sendGoPokemonInfo(cid, feet, pk)
    sendGoPokemonInfo(cid, feet, pk)
 end

 if not isPlayer(target) and level < 100 and (xpGain + exp) >= (level * 5000) then

    doPlayerSendCancel(cid, "Seu "..getCreatureName(getCreatureSummons(cid)[1]).." avançou do nível "..level.." para o nível "..level + 1 ..".")
    doItemSetAttribute(feet.uid, "level", level +1) 
    doItemSetAttribute(feet.uid, "exp", 0)
    doSendMagicEffect(getThingPos(getCreatureSummons(cid)[1]), 370)

    sendPokemonsBarPokemon(cid)


    doCreatureSetNick(getCreatureSummons(cid)[1], getPokeName(pk) .. " [" .. tonumber(getItemAttribute(feet.uid, "level")) .. "]")
    --sendGoPokemonInfo(cid, feet, pk)
    sendGoPokemonInfo(cid, feet, pk)

    doCreatureAddHealth(pk, getCreatureMaxHealth(pk))
    doItemSetAttribute(feet.uid, "hp", -1)
 end

 setPlayerStorageValue(target, 15000, 1)
 return true
end