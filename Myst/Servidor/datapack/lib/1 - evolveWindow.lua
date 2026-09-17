-- Criado por Thalles Vitor --
-- Janela de Evolucao --

-- Opcodes - Servidor
evolutionWINDOW_OPCODE = 23


-- Stones
leaf = 11441
grass = 11441
water = 11442
venom = 11443
thunder = 11444
rock = 11445
punch = 11446
fire = 11447
coccon = 11448
crystal = 11449
dark = 11450
earth = 11451
enigma = 11452
heart = 11453
ice = 11454
boostStone = 12618

metal = 12232
sun = 12242
king = 12244
magma = 12245

sfire = 12401
swater = 12402
sleaf = 12403
sheart = 12404
senigma = 12405
srock = 12406
svenom = 12407
sice = 12408
sthunder = 12409
scrystal = 12410
scoccon = 12411
sdarkness = 12412
spunch = 12413
searth = 12414
dragon = 12417
upgrade = 12419
greena = 13229

local special = specialevo                  --alterado v1.9 \/ peguem ele todo!

local types = {
[leaf] = {"Bulbasaur", "Ivysaur", "Oddish", "Gloom", "Bellsprout", "Weepinbell", "Exeggcute", "Chikorita", "Bayleef", "Hoppip", "Skiploom", "Sunkern"},
[water] = {"Squirtle", "Wartortle", "Horsea", "Goldeen", "Magikarp", "Psyduck", "Poliwag", "Poliwhirl", "Tentacool", "Krabby", "Staryu", "Omanyte", "Eevee", "Totodile", "Croconow", "Chinchou", "Marill", "Wooper", "Slowpoke", "Remoraid", "Seadra"},
[venom] = {"Zubat", "Ekans", "Nidoran male", "Nidoran female", "Nidorino", "Nidorina", "Gloom", "Venonat", "Tentacool", "Grimer", "Koffing", "Spinarak", "Golbat"},
[thunder] = {"Magnemite", "Pikachu", "Voltorb", "Eevee", "Chinchou", "Pichu", "Mareep", "Flaaffy", "Elekid"},
[rock] = {"Geodude", "Graveler", "Rhyhorn", "Kabuto", "Slugma", "Pupitar"},
[punch] = {"Machop", "Machoke", "Mankey", "Poliwhirl", "Tyrogue"},
[fire] = {"Charmander", "Charmeleon", "Vulpix", "Growlithe", "Ponyta", "Eevee", "Cyndaquil", "Quilava", "Slugma", "Houndour", "Magby"},
[coccon] = {"Caterpie", "Metapod", "Weedle", "Kakuna", "Paras", "Venonat", "Scyther", "Ledyba", "Spinarak", "Pineco"},
[crystal] = {"Dratini", "Dragonair", "Magikarp", "Omanyte", "Kabuto", "Seadra"},
[dark] = {"Gastly", "Haunter", "Eevee", "Houndour", "Pupitar"},
[earth] = {"Cubone", "Sandshrew", "Nidorino", "Nidorina", "Diglett", "Onix", "Rhyhorn", "Wooper", "Swinub", "Phanpy", "Larvitar"},
[enigma] = {"Abra", "Kadabra", "Psyduck", "Slowpoke", "Drowzee", "Eevee", "Natu", "Smoochum"},
[heart] = {"Rattata", "Pidgey", "Pidgeotto", "Spearow", "Clefairy", "Jigglypuff", "Meowth", "Doduo", "Porygon", "Chansey", "Sentret", "Hoothoot", "Cleffa", "Igglybuff", "Togepi", "Snubull", "Teddiursa"},
[ice] = {"Seel", "Shellder", "Smoochum", "Swinub"},
[king] = {"Slowpoke", "Poliwhirl"},
[metal] = {"Onix", "Scyther"},
[dragon] = {"Seadra"},
[upgrade] = {"Porygon", "Nosepass", "Probopass"},
[sun] = {"Sunkern", "Gloom"},
[sfire] = {"Shiny Charmander", "Shiny Charmeleon", "Shiny Vulpix", "Shiny Growlithe", "Shiny Ponyta", "Shiny Eevee"},
[swater] = {"Shiny Squirtle", "Shiny Wartortle", "Shiny Horsea", "Shiny Goldeen", "Shiny Magikarp", "Shiny Psyduck", "Shiny Poliwag", "Shiny Poliwhirl", "Shiny Tentacool", "Shiny Krabby", "Shiny Staryu", "Shiny Omanyte", "Shiny Eevee"},
[sleaf] = {"Shiny Bulbasaur", "Shiny Ivysaur", "Shiny Oddish", "Shiny Gloom", "Shiny Bellsprout", "Shiny Weepinbell", "Shiny Exeggcute"},
[sheart] = {"Shiny Rattata", "Shiny Pidgey", "Shiny Pidgeotto", "Shiny Spearow", "Shiny Clefairy", "Shiny Jigglypuff", "Shiny Meowth", "Shiny Doduo", "Shiny Porygon", "Shiny Chansey"},
[senigma] = {"Shiny Abra", "Shiny Kadabra", "Shiny Psyduck", "Shiny Slowpoke", "Shiny Drowzee", "Shiny Eevee"},
[srock] = {"Shiny Geodude", "Shiny Graveler", "Shiny Rhyhorn", "Shiny Kabuto"},
[svenom] = {"Shiny Zubat", "Shiny Ekans", "Shiny Nidoran male", "Shiny Nidoran female", "Shiny Nidorino", "Shiny Nidorina", "Shiny Gloom", "Shiny Venonat", "Shiny Tentacool", "Shiny Grimer", "Shiny Koffing"},
[sice] = {"Shiny Seel", "Shiny Shellder"},
[sthunder] = {"Shiny Magnemite", "Shiny Pikachu", "Shiny Voltorb", "Shiny Eevee"},
[scrystal] = {"Shiny Dratini", "Shiny Dragonair", "Shiny Magikarp", "Shiny Omanyte", "Shiny Kabuto"},
[scoccon] = {"Shiny Caterpie", "Shiny Metapod", "Shiny Weedle", "Shiny Kakuna", "Shiny Paras", "Shiny Venonat", "Shiny Scyther"},
[sdarkness] = {"Shiny Gastly", "Shiny Haunter", "Shiny Eevee"},
[spunch] = {"Shiny Machop", "Shiny Machoke", "Shiny Mankey", "Shiny Poliwhirl"},
[searth] = {"Shiny Cubone", "Shiny Sandshrew", "Shiny Nidorino", "Shiny Nidorina", "Shiny Diglett", "Shiny Onix", "Shiny Rhyhorn"},
[greena] = {"Tangela,", "Tangrowth"},
[magma] = {"Magmar"}

}

local specEvos = {   --alterado v1.9 \/
["Eevee"] = {
               [thunder] = "Jolteon",
               [water] = "Vaporeon",
               [fire] = "Flareon",
               [enigma] = "Espeon",
               [dark] = "Umbreon",
               [leaf] = "Leafeon",
               [ice] = "Glaceon",
            },

["Kirlia"] = {
   [punch] = "Galade",
   [enigma] = "Gardevoir",
},
}

function onSendEvolveWindow(cid, name, stoneId)
    if not isPlayer(cid) then
        return true
    end

    if stoneId == 13088 then
        local isTwoStone = "no"
        local needText = "Você precisa de " .. PokemonShinys[name].quant .. " shiny stones."
        doSendPlayerExtendedOpcode(cid, evolutionWINDOW_OPCODE, getItemInfo(fotos[name]).clientId.."@"..getItemInfo(fotos[PokemonShinys[name].name]).clientId.."@"..name.."@"..PokemonShinys[name].name.."@"..needText.."@"..isTwoStone.."@")
        return true
    end

    local tabela = poevo[name]
    if tabela then
        if tabela.stoneid2 > 0 then
            local isTwoStone = "no"
            local needText = "Você precisa de " .. tabela.count .. " " .. getItemInfo(tabela.stoneid).name .. " \ne de " .. tabela.count .. " " .. getItemInfo(tabela.stoneid2).name .. " para evoluir."
            doSendPlayerExtendedOpcode(cid, evolutionWINDOW_OPCODE, getItemInfo(fotos[name]).clientId.."@"..getItemInfo(fotos[tabela.evolution]).clientId.."@"..name.."@"..tabela.evolution.."@"..needText.."@"..isTwoStone.."@")
        else
            local isTwoStone = "no"
            local needText = "Você precisa de " .. tabela.count .. " " .. getItemInfo(tabela.stoneid).name .. "."
            doSendPlayerExtendedOpcode(cid, evolutionWINDOW_OPCODE, getItemInfo(fotos[name]).clientId.."@"..getItemInfo(fotos[tabela.evolution]).clientId.."@"..name.."@"..tabela.evolution.."@"..needText.."@"..isTwoStone.."@")
        end
    end

    local tabela2 = spcevo[name]
    if tabela2 then
        for k, v in pairs(tabela2) do
            local isTwoStone = "no"
            if v.stoneid == stoneId or v.stoneid2 == stoneId then
                local needText = "Você precisa de " .. v.count .. " " .. getItemInfo(v.stoneid).name .. "."
                if v.stoneid2 ~= 0 then
                    needText = "Você precisa de " .. v.count .. " " .. getItemInfo(v.stoneid).name .. " e " .. v.count .. " " .. getItemInfo(v.stoneid2).name .. "."
                    isTwoStone = "yes"
                end
                
                doSendPlayerExtendedOpcode(cid, evolutionWINDOW_OPCODE, getItemInfo(fotos[name]).clientId.."@"..getItemInfo(fotos[v.evolution]).clientId.."@"..name.."@"..v.evolution.."@"..needText.."@"..isTwoStone.."@")
            end
        end
    end
    return true
end

function doEvolve(cid, name, evoname)
    if not isPlayer(cid) then
        return true
    end

    if string.find(evoname, "Shiny") then
        if not PokemonShinys[name] then
            return true
        end

        local newpoke = PokemonShinys[name].name
        local itemEx = getPlayerSlotItem(cid, 8)
        if itemEx.uid <= 0 then
            return true
        end

        if getPlayerItemCount(cid, 13088) < PokemonShinys[name].quant then
            return true
        end

		doItemSetAttribute(itemEx.uid, "poke", newpoke)
		doItemSetAttribute(itemEx.uid, "description", "Contains a "..newpoke..".")
		doTransformItem(getPlayerSlotItem(cid, 7).uid, fotos[newpoke])
		doSendMagicEffect(getThingPos(cid), effect)
		doPlayerRemoveItem(cid, 13088, PokemonShinys[name].quant)
		doItemSetAttribute(itemEx.uid, "offense", pokes[newpoke].offense)
		doItemSetAttribute(itemEx.uid, "defense", pokes[newpoke].defense)
		doItemSetAttribute(itemEx.uid, "speed", pokes[newpoke].agility)
	    doItemSetAttribute(itemEx.uid, "specialattack", pokes[newpoke].specialattack)
		doItemSetAttribute(itemEx.uid, "vitality", pokes[newpoke].vitality)
        return true
    end

    if #getCreatureSummons(cid) <= 0 then
        return true
    end

    local summon = getCreatureSummons(cid)[1]
    if getCreatureName(summon) ~= name then
        return true
    end
    
    local pokeball = getPlayerSlotItem(cid, 8)
    if getCreatureCondition(summon, CONDITION_INVISIBLE) then 
        return true 
    end

    local pevo = nil
    if not spcevo[name] then
        pevo = poevo[name]
    else
        pevo = spcevo[name]
    end

    local itemid = pevo.stoneid

    if not spcevo[getCreatureName(summon)] then
        if not pevo then
            doPlayerSendCancel(cid, "This pokemon can't evolve.")
            return true
        end
        if pevo.stoneid ~= itemid and pevo.stoneid2 ~= itemid then 
            doPlayerSendCancel(cid, "This isn't the needed stone to evolve this pokemon.")
            return true
        end
    end

    local minlevel = 0

    local count = 1
    local stnid = 0
    local stnid2 = 0
    local evo = ""

    if spcevo[name] then
        local tabela = spcevo[name]
        for i = 1, #tabela do
            count = tabela[i].count
            stnid = tabela[i].stoneid
            stnid2 = tabela[i].stoneid2

            if stnid2 > 0 and getPlayerItemCount(cid, stnid2, -1) >= 1 and getPlayerItemCount(cid, stnid, -1) >= 1 then
                evo = tabela[i].evolution

                minlevel = pokes[evo].level
                if getPlayerLevel(cid) < minlevel then
                    doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
                    return true
                end

                doPlayerRemoveItem(cid, stnid, 1)
                if stnid2 > 0 then
                    doPlayerRemoveItem(cid, stnid2, 1)
                end

                doEvolvePokemon2(cid, summon, evo, stnid, stnid2)
                return true
            end

            if stnid2 <= 0 and getPlayerItemCount(cid, stnid, -1) >= 1 then
                evo = tabela[i].evolution

                minlevel = pokes[evo].level
                if getPlayerLevel(cid) < minlevel then
                    doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
                    return true
                end

                doPlayerRemoveItem(cid, stnid, 1)
                doEvolvePokemon2(cid, summon, evo, stnid, stnid2)
                return true
            end


        end
    else
        count = poevo[getPokemonName(summon)].count
        stnid = poevo[getPokemonName(summon)].stoneid
        stnid2 = poevo[getPokemonName(summon)].stoneid2
        evo = poevo[getPokemonName(summon)].evolution

        minlevel = poevo[getPokemonName(summon)].level
        if getPlayerLevel(cid) < minlevel then
            doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
            return true
        end

        if getPlayerItemCount(cid, stnid) <= 0 then
            doPlayerSendCancel(cid, "This isn't the needed stone to evolve this pokemon.")
            return true
        end

        if stnid2 > 0 and getPlayerItemCount(cid, stnid2) <= 0 then
            doPlayerSendCancel(cid, "This isn't the needed stone to evolve this pokemon.")
            return true
        end

        doPlayerRemoveItem(cid, stnid, 1)
        if stnid2 > 0 then
            doPlayerRemoveItem(cid, stnid2, 1)
        end

        doEvolvePokemon2(cid, summon, evo, stnid, stnid2)
    end
    return true
end