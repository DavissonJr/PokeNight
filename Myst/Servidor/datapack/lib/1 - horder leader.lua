-- Criado por Thalles Vitor --
-- Sistema de Horder Leader --

horders = {
    ["Blastoise"] = {name = "Horder Blastoise"},
    ["Charizard"] = {name = "Horder Charizard"},
    ["Flygon"] = {name = "Horder Flygon"},
    ["Gengar"] = {name = "Horder Gengar"},
    ["Electabuzz"] = {name = "Horder Electabuzz"},
    ["Alakazam"] = {name = "Horder Alakazam"},
}

horders2 = {
    ["Horder Blastoise"] = {name = "Blastoise"},
    ["Horder Charizard"] = {name = "Charizard"},
    ["Horder Flygon"] = {name = "Flygon"},
    ["Horder Gengar"] = {name = "Gengar"},
    ["Horder Electabuzz"] = {name = "Electabuzz"},
    ["Horder Alakazam"] = {name = "Alakazam"},
}

horders_addon = {
    [2010] = {horder = "Horder Alakazam", name = "Grey hat addon", fly = 0, ride = 0, surf = 0},
    [1108] = {horder = "Horder Flygon", name = "Cowboy hat addon", fly = 2111, ride = 0, surf = 0},
    [2073] = {horder = "Horder Charizard", name = "Halloween Addon", fly = 2071, ride = 0, surf = 0},
    [2183] = {horder = "Horder Electabuzz", name = "Guitar Addon", fly = 0, ride = 0, surf = 0},
    [2116] = {horder = "Horder Gengar", name = "Dracula Addon", fly = 2118, ride = 0, surf = 0},
    [2079] = {horder = "Horder Blastoise", name = "Red ninja pack addon", fly = 2079, ride = 0, surf = 0},
}

HORDER_STORAGE_SPAWN = 8482 -- storage para spawnar 10 pokemons so 1x

-- Funcao de spawnar o horder leader
function onSpawnHorderLeader(cid)
    if not isCreature(cid) then
        return true
    end

    local horder_table = horders[getCreatureName(cid)]
    if not horder_table then
        --print("Horder com o nome: " .. getCreatureName(cid) .. " nao existe na tabela de horders.")
        return true
    end

    if math.random(1, 500) == 50 then
        local pos = getCreaturePosition(cid)
        doRemoveCreature(cid)

        local monstro = doCreateMonster(horder_table.name, pos, false)
        --doSetCreatureOutfit(getTopCreature(pos).uid, horder_table.outfits[math.random(1, horder_table.max_outfits)])
    end
    return true
end

-- Funcao de spawnar o horder leader (para o player)
function onSpawnHorderLeaderToPlayer(cid, player)
    if not isCreature(cid) then
        return true
    end

    if not isPlayer(player) then
        return true
    end

    local horder_table = horders2[getCreatureName(cid)]
    if not horder_table then
        --print("Horder com o nome: " .. getCreatureName(cid) .. " nao existe na tabela de horders.")
        return true
    end

    -- Se ja tiver spawnado 10
    if getPlayerStorageValue(cid, HORDER_STORAGE_SPAWN) >= 1 then
        return true
    end

    for i = 1, 5 do
        doCreateMonster(horder_table.name, getCreaturePosition(cid), false)
        setPlayerStorageValue(cid, HORDER_STORAGE_SPAWN, 1)
    end
    return true
end