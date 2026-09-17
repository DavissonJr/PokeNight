-- Criado por Thalles Vitor --
-- PokeBar --
function isInSituationSpecial(cid)
  if not isPlayer(cid) then
    return true
  end

  local storages = {17000, 17001, 63215}
  for i = 1, #storages do
    local storage = tonumber(getPlayerStorageValue(cid, storages[i])) or 0
    if storage >= 1 then
      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Não pode mover item em uma situação especial.")
      return true
    end
  end
  return false
end

function onMoveItem(cid, item, count, toContainer, fromContainer, fromPos, toPos)
  if not isPlayer(cid) then
    return true
  end

  if isInSituationSpecial(cid) then
    return false
  end

  if getPlayerSlotItem(cid, 7).uid == item.uid then
    return false
  end

  if item.itemid == 1740 then
    return false
  end

  -- Thalles Vitor - Catch Bag
  if fromContainer.itemid == 28146 or fromContainer.y == 13 then
    if not getTileInfo(getCreaturePosition(cid)).protection then
      doPlayerSendTextMessage(cid, 22, "Só pode mexer na catch bag em uma Protection Zone.")
      return false
    end
  end

  if toContainer.itemid == 28146 or toPos.y == 13 then
    if fromPos.x == 65535 then
      if not getTileInfo(getCreaturePosition(cid)).protection then
        doPlayerSendTextMessage(cid, 22, "Só pode mexer na catch bag em uma Protection Zone.")
        return false
      end
    end
  end

  if toContainer.itemid == 28204 and not getItemAttribute(item.uid, "poke") then
    return false
  end

  if toPos.y == 1 and not getItemAttribute(item.uid, "poke") then
    return false
  end 
  --

  -- Thalles Vitor - Bike --
    if toPos.y == 9 and getPlayerSlotItem(cid, 9).uid > 0 and getItemAttribute(getPlayerSlotItem(cid, 9).uid, "using") then
      return false
    end

    if fromPos.y == 9 and getItemAttribute(item.uid, "using") then
      return false
    end
  --

  -- Thalles Vitor - Catch Bag --
    if toContainer.itemid == 28146 and not getItemAttribute(item.uid, "poke") then -- Nao mandar nada para catch bag que nï¿½o seja pokemon
      return false
    end

    if toPos.y == 13 and not getItemAttribute(item.uid, "poke") then
      return false
    end 

    if fromContainer.itemid == 28146 and (toContainer.itemid == 1987 or toContainer.itemid == 2547) then -- Nao deixar mover da catch bag para a backpack principal/coins
      if getPlayerPokemons(cid) >= 6 then
        return false
      end
    end

    if fromPos.x ~= 65535 and toContainer.itemid == 28146 then
      return true
    end
  --

  if getItemAttribute(item.uid, POKEMON_ATTRIBUTE_NAME) then
    if getItemAttribute(item.uid, "description") and string.find(tostring(getItemAttribute(item.uid, "description")), "Contains") then
      doItemSetAttribute(item.uid, "description", getPokemonLook(item))
    end

    if not getItemAttribute(item.uid, "level") then
      doItemSetAttribute(item.uid, "level", 1)
    end

    if not getItemAttribute(item.uid, "portrait") then
      if fotos[getItemAttribute(item.uid, "poke")] then
        doItemSetAttribute(item, "portrait", fotos[getItemAttribute(item.uid, "poke")])
      end
    end

    if getPlayerSlotItem(cid, 8).uid > 0 then
      if item.uid == getPlayerSlotItem(cid, 8).uid and #getCreatureSummons(cid) > 0 then
        return false
      end

      if toPos.y == 8 and #getCreatureSummons(cid) > 0 then
        return false
      end

      if toPos.y == 8 and getPlayerStorageValue(cid, 17000) >= 1 then
        return false
      end

      if toPos.y == 8 and getPlayerStorageValue(cid, 17001) >= 1 then
        return false
      end

      if toPos.y == 8 and getPlayerStorageValue(cid, 63215) >= 1 then
        return false
      end

      --
      if fromPos.y == 8 and getPlayerStorageValue(cid, 17000) >= 1 then
        return false
      end

      if fromPos.y == 8 and getPlayerStorageValue(cid, 17001) >= 1 then
        return false
      end

      if fromPos.y == 8 and getPlayerStorageValue(cid, 63215) >= 1 then
        return false
      end
    end

	addEvent(function()
    -- Thalles Vitor - Health Info --
		doSendPlayerExtendedOpcode(cid, 102, getPlayerPokemons(cid).."@")
    --

		sendPokemonsBarPokemon(cid)
	end, 100)
  end
  return true
end