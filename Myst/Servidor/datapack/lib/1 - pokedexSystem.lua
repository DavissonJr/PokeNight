-- Criado por Thalles Vitor --
-- Pokedex System --

POKEDEX_DESTROYOPCODE = 32 -- destruir os paneis
POKEDEX_OPCODE = 33 -- enviar a dex do respectivo pokemon
POKEDEX_EVOLVESOPCODE = 34 -- enviar as evolucoes de pokemon
POKEDEX_MOVESOPCODE = 35 -- enviar os moves dos pokemons
POKEDEX_TYPESOPCODE = 36 -- enviar os types de pokemons (weak / super)

elements =
{
    ["water"] = WATERDAMAGE,
    ["normal"] = NORMALDAMAGE,
    ["fighting"] = FIGHTDAMAGE,
    ["flying"] = FLYINGDAMAGE,
    ["poison"] = POISONDAMAGE,
    ["groudon"] = GROUNDDAMAGE,
    ["rock"] = ROCKDAMAGE,
    ["bug"] = BUGDAMAGE,
    ["ghost"] = GHOSTDAMAGE,
    ["steel"] = STEELDAMAGE,
    ["fire"] = FIREDAMAGE,
    ["grass"] = GRASSDAMAGE,
    ["electric"] = ELECTRICDAMAGE,
    ["psychic"] = PSYCHICDAMAGE,
    ["ice"] = ICEDAMAGE,
    ["dragon"] = DRAGONDAMAGE,
    ["dark"] = DARKDAMAGE,
}

function sendPokedexWindow(cid, pokemon, creature)
    if not isPlayer(cid) then
        return true
    end
    
    doSendPlayerExtendedOpcode(cid, POKEDEX_DESTROYOPCODE, "")
    if isMonster(creature) then
        local pokemonNumber = "#000"
        local pokesTable = {}
        for k, v in pairs(pokes) do
            table.insert(pokesTable, k)
        end

        for i = 1, #pokesTable do
            if string.lower(pokesTable[i]) == string.lower(getCreatureName(creature)) then
                if i > 1 and i <= 9 then
                    pokemonNumber = "#00" .. i
                end

                if i >= 10 and i <= 99 then
                    pokemonNumber = "#0" .. i
                end

                if i >= 100 and i <= 999 then
                    pokemonNumber = "#" .. tostring(i)
                end
            end
        end

        local abilities = {}
        if isInArray(specialabilities["dig"], getCreatureName(creature)) then
            table.insert(abilities, "Dig, ")
        end

        if isInArray(specialabilities["rock smash"], getCreatureName(creature)) then
            table.insert(abilities, "Rock Smash, ")
        end

        if isInArray(specialabilities["fly"], getCreatureName(creature)) then
            table.insert(abilities, "Fly, ")
        end

        if isInArray(specialabilities["levitate"], getCreatureName(creature)) then
            table.insert(abilities, "Levitate, ")
        end

        if isInArray(specialabilities["cut"], getCreatureName(creature)) then
            table.insert(abilities, "Cut, ")
        end

        if isInArray(specialabilities["light"], getCreatureName(creature)) then
            table.insert(abilities, "Light, ")
        end

        if isInArray(specialabilities["dig"], getCreatureName(creature)) then
            table.insert(abilities, "Dig, ")
        end

        if isInArray(specialabilities["ride"], getCreatureName(creature)) then
            table.insert(abilities, "Ride, ")
        end

        if isInArray(specialabilities["blink"], getCreatureName(creature)) then
            table.insert(abilities, "Blink, ")
        end

        if isInArray(specialabilities["teleport"], getCreatureName(creature)) then
            table.insert(abilities, "Teleport, ")
        end

        if isInArray(specialabilities["surf"], getCreatureName(creature)) then
            table.insert(abilities, "Surf, ")
        end

        local abilitieText = table.concat(abilities)
        abilitieText = abilitieText:sub(1, #abilitieText-2)  -- Removes the last character in a string
        abilitieText = abilitieText .. "."

        if abilitieText == "." then
            abilitieText = "Nenhuma."
        end

        local element1 = "none"
        local element2 = "none"
        if pokes[getCreatureName(creature)] then
            element1 = doCorrectString(pokes[getCreatureName(creature)].type)
            element2 = doCorrectString(pokes[getCreatureName(creature)].type2)
        end

        local str = {}
        table.insert(str, "Attack: " .. string.format("%0.f", getOffense(creature)) .. "\n")
        table.insert(str, "Defense: " .. string.format("%0.f", getDefense(creature)) .. "\n")
        table.insert(str, "Sp.Attack: " .. string.format("%0.f", getSpecialAttack(creature)) .. "\n")
        table.insert(str, "Sp.Defense: " .. string.format("%0.f", getSpecialDefense(creature)) .. "\n")
        table.insert(str, "Vitality: " .. string.format("%0.f", getVitality(creature)) .. "\n")
        table.insert(str, "\n\nAbilities: " .. abilitieText .."\n")
        
        if spcevo[getCreatureName(creature)] then
            for i = 1, #spcevo[getCreatureName(creature)] do
                if spcevo[getCreatureName(creature)][i].stoneid2 > 0 then
                    table.insert(str, spcevo[getCreatureName(creature)][i].evolution .. " - Evolve Stone 1: " .. getItemInfo(spcevo[getCreatureName(creature)][i].stoneid).name .. " - Evolve Stone 2: " .. getItemInfo(spcevo[getCreatureName(creature)][i].stoneid2).name .. "\n")
                else
                    table.insert(str, spcevo[getCreatureName(creature)][i].evolution .. " - Evolve Stone: " .. getItemInfo(spcevo[getCreatureName(creature)][i].stoneid).name .. "\n")
                end
            end
        else
            if poevo[getCreatureName(creature)] then
                table.insert(str, "Evolve Stone: " .. getItemInfo(poevo[getCreatureName(creature)].stoneid).name .. "\n")
            end
        end

        if PokemonShinys[getCreatureName(creature)] and PokemonShinys[getCreatureName(creature)].quant then
            table.insert(str, "Evolve Shiny: " .. PokemonShinys[getCreatureName(creature)].name .. " - Count: " .. PokemonShinys[getCreatureName(creature)].quant)
        end

        --[[ "Attack:0\n
        Defense: 0\n
        Sp.Attack: 45.68\n
        Sp.Defense: 40.1\n
        Vitality:0\n\n
        Evolution:\nNenhum.\n\n
        Abilities: Fly, Levitate." 
        ]]

        local evolves = {}
        if spcevo[getCreatureName(creature)] then
            for i = 1, #spcevo[getCreatureName(creature)] do
                table.insert(evolves, spcevo[getCreatureName(creature)][i].evolution)
            end
        else
            for k, v in pairs(poevo) do
                if k == getCreatureName(creature) then
                    table.insert(evolves, v.evolution)

                    if poevo[v.evolution] then
                        table.insert(evolves, poevo[v.evolution].evolution)
                    end
                end
            end
        end

        if PokemonShinys[getCreatureName(creature)] then
            table.insert(evolves, PokemonShinys[getCreatureName(creature)].name)
        end

        doSendPlayerExtendedOpcode(cid, POKEDEX_OPCODE, pokemon.."@"..getMonsterInfo(pokemon).lookType.."@"..pokemonNumber.."@"..table.concat(str).."@"..element1.."@"..element2.."@")
   
        for i = 1, #evolves do
            if getMonsterInfo(evolves[i]) ~= false and getMonsterInfo(evolves[i]) ~= nil then
                doSendPlayerExtendedOpcode(cid, POKEDEX_EVOLVESOPCODE, evolves[i].."@"..getMonsterInfo(evolves[i]).lookType.."@"..i.."@")
            end
        end

        local x = movestable[getCreatureName(creature)]
        if x then
            local moves = {x.move1, x.move2, x.move3, x.move4, x.move5, x.move6,
            x.move7, x.move8, x.move9, x.move10, x.move11, x.move12}
            for i = 1, #moves do
                if moves[i] ~= nil and moves[i].t and moves[i].name and moves[i].f and moves[i].level and moves[i].cd and moves[i].dist then
                    doSendPlayerExtendedOpcode(cid, POKEDEX_MOVESOPCODE, i.."@"..moves[i].t.."@"..moves[i].name.."@"..moves[i].f.."@"..moves[i].level.."@"..moves[i].cd.."@"..moves[i].dist.."@")
                end
            end
        end

        local weak = {}
        local super = {}

        local type1 = pokes[getCreatureName(creature)].type
	    local type2 = pokes[getCreatureName(creature)].type2

        local theElement1 = elements[type1]
        local theElement2 = elements[type2]
        if effectiveness[theElement1] then
            if effectiveness[theElement1].weak then
                for i = 1, #effectiveness[theElement1].weak do
                    table.insert(weak, effectiveness[theElement1].weak[i])
                end
            end

            if effectiveness[theElement1].super then
                for i = 1, #effectiveness[theElement1].super do
                    table.insert(super, effectiveness[theElement1].super[i])
                end
            end
        end

        if effectiveness[theElement2] then
            if effectiveness[theElement2].weak then
                for i = 1, #effectiveness[theElement2].weak do
                    table.insert(weak, effectiveness[theElement2].weak[i])
                end
            end

            if effectiveness[theElement2].super then
                for i = 1, #effectiveness[theElement2].super do
                    table.insert(super, effectiveness[theElement2].super[i])
                end
            end
        end

        for i = 1, #weak do
            doSendPlayerExtendedOpcode(cid, POKEDEX_TYPESOPCODE, "weak".."@"..weak[i].."@")
        end

        for i = 1, #super do
            doSendPlayerExtendedOpcode(cid, POKEDEX_TYPESOPCODE, "super".."@"..super[i].."@")
        end
    end
    return true
end