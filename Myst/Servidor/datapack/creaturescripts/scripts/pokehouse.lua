-- Criado por Thalles Vitor --
-- Sistema de Poke House --
local pokeHOUSEID = 28043 -- id do item do poke house

function onMoveItem(cid, item, count, toContainer, fromContainer, fromPos, toPos)
    if getTileInfo(getCreaturePosition(cid)).house then
        if toContainer.itemid == pokeHOUSEID and fromContainer.itemid ~= pokeHOUSEID then
            local poke = getItemAttribute(item.uid, "poke")
            if poke ~= nil then
                local monster = doCreateMonster(poke, getCreaturePosition(cid), false, true)
                doCreatureSetSkullType(monster, getItemAttribute(item.uid, "gender"))

                local name = getItemAttribute(item.uid, "poke")
                if getItemAttribute(item.uid, "nick") then
                    name = getItemAttribute(item.uid, "nick")
                end

                local lvl = tonumber(getItemAttribute(item.uid, "level")) or 1
                doCreatureSetNick(monster, name .. " [" .. lvl .. "]")

                registerCreatureEvent(monster, "PokeHouseThink")
                setPlayerStorageValue(monster, 999, 1)
            end
            
            return true
        end

        if fromContainer.itemid == pokeHOUSEID and toContainer.itemid ~= pokeHOUSEID then
            local poke = getItemAttribute(item.uid, "poke")
            if poke ~= nil then
                local spectator = getSpectators(getCreaturePosition(cid), 16, 16, false)
                if spectator and #spectator > 0 then
                    for k,v in pairs(spectator) do
                        if isMonster(v) and getCreatureName(v) == poke and getPlayerStorageValue(v, 999) >= 1 then
                            doRemoveCreature(v)
                            break
                        end
                    end
                end
            end
        end
    end
    return true
end