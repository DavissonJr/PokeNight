-- [
    -- Putero Programmer -- bem que eu gostaria
    --~~ Thalles Vitor ~~--
    --~~ Troca ou Revenda ù proibido ~~-- ent eu posso dar o sistema? pra quem, pra ninguem, so to falandokkkkkkk aksdadaskdka
    --~~ Pedido: Script de Addon System (LUA - 100$) ~~--
--]

local pokemons = {
    -- Shiny Togekiss e Togekiss
    [13392] = {
        ["Togekiss"] = {pokemon = "Togekiss", looktype = 2155, addonName = "Super Man Addon", fly =  2160, ride = 0, surf = 0},
        ["Shiny Togekiss"] = {pokemon = "Shiny Togekiss", looktype = 2161, addonName = "Super Man Addon", fly =  2162, ride = 0, surf = 0},
    },

    [13393] = {
        ["Togekiss"] = {pokemon = "Togekiss", looktype = 2155, addonName = "Super Man Addon", fly =  2160, ride = 0, surf = 0},
        ["Shiny Togekiss"] = {pokemon = "Shiny Togekiss", looktype = 2161, addonName = "Super Man Addon", fly =  2162, ride = 0, surf = 0},
    },

    [13391] = {
        ["Shiny Togekiss"] = {pokemon = "Shiny Togekiss", looktype = 2157, addonName = "Adventurer Addon", fly = 2158, ride = 0, surf = 0},
        ["Togekiss"] = {pokemon = "Togekiss", looktype = 2155, addonName = "Adventurer Addon", fly = 2156, ride = 0, surf = 0},
    },

	-- Shiny Alakazam
	[13089] = {
		["Shiny Alakazam"] = {pokemon = "Shiny Alakazam", looktype = 2013, addonName = "Adventurer addon", fly =  0, ride = 0, surf = 0},
        ["Alakazam"] = {pokemon = "Alakazam", looktype = 2009, addonName = "Adventurer addon", fly =  0, ride = 0, surf = 0},
    },

    [13093] = {
		["Shiny Alakazam"] = {pokemon = "Shiny Alakazam", looktype = 2013, addonName = "Adventurer addon", fly =  0, ride = 0, surf = 0},
        ["Alakazam"] = {pokemon = "Alakazam", looktype = 2009, addonName = "Adventurer addon", fly =  0, ride = 0, surf = 0},
    },

	[13091] = {
		["Shiny Alakazam"] = {pokemon = "Shiny Alakazam", looktype = 2014, addonName = "Grey hat addon", fly =  0, ride = 0, surf = 0},
        ["Alakazam"] = {pokemon = "Alakazam", looktype = 2010, addonName = "Grey hat addon", fly =  0, ride = 0, surf = 0},
    },

    [13095] = {
		["Shiny Alakazam"] = {pokemon = "Shiny Alakazam", looktype = 2014, addonName = "Grey hat addon", fly =  0, ride = 0, surf = 0},
        ["Alakazam"] = {pokemon = "Alakazam", looktype = 2010, addonName = "Grey hat addon", fly =  0, ride = 0, surf = 0},
    },

	[13092] = {
		["Shiny Alakazam"] = {pokemon = "Shiny Alakazam", looktype = 2016, addonName = "Red hat addon", fly =  0, ride = 0, surf = 0},
        ["Alakazam"] = {pokemon = "Alakazam", looktype = 2012, addonName = "Red hat addon", fly =  0, ride = 0, surf = 0},
    },

    [13096] = {
		["Shiny Alakazam"] = {pokemon = "Shiny Alakazam", looktype = 2016, addonName = "Red hat addon", fly =  0, ride = 0, surf = 0},
        ["Alakazam"] = {pokemon = "Alakazam", looktype = 2012, addonName = "Red hat addon", fly =  0, ride = 0, surf = 0},
    },

	[13090] = {
		["Shiny Alakazam"] = {pokemon = "Shiny Alakazam", looktype = 2015, addonName = "Purple hat addon", fly =  0, ride = 0, surf = 0},
        ["Alakazam"] = {pokemon = "Alakazam", looktype = 2011, addonName = "Purple hat addon", fly =  0, ride = 0, surf = 0},
    },

    [13094] = {
		["Shiny Alakazam"] = {pokemon = "Shiny Alakazam", looktype = 2015, addonName = "Purple hat addon", fly =  0, ride = 0, surf = 0},
        ["Alakazam"] = {pokemon = "Alakazam", looktype = 2011, addonName = "Purple hat addon", fly =  0, ride = 0, surf = 0},
    },

	[13394] = {
		["Shiny Alakazam"] = {pokemon = "Shiny Alakazam", looktype = 2165, addonName = "Immortal Shaman addon", fly =  0, ride = 0, surf = 0},
        ["Alakazam"] = {pokemon = "Alakazam", looktype = 2164, addonName = "Immortal Shaman addon", fly =  0, ride = 0, surf = 0},
    },

    [13395] = {
		["Shiny Alakazam"] = {pokemon = "Shiny Alakazam", looktype = 2165, addonName = "Immortal Shaman addon", fly =  0, ride = 0, surf = 0},
        ["Alakazam"] = {pokemon = "Alakazam", looktype = 2164, addonName = "Immortal Shaman addon", fly =  0, ride = 0, surf = 0},
    },

    [13106] = {
        ["Shiny Tropius"] = {pokemon = "Shiny Tropius", looktype = 2069, addonName = "Desert flower addon", fly =  2070, ride = 0, surf = 0},
    },

    [13101] = {
        ["Shiny Tropius"] = {pokemon = "Shiny Tropius", looktype = 2019, addonName = "Sorcerer addon", fly =  2065, ride = 0, surf = 0},
    },

    [13380] = {
        ["Shiny Tropius"] = {pokemon = "Shiny Tropius", looktype = 2149, addonName = "Golden king addon", fly =  2148, ride = 0, surf = 0},
    },

    [13098] = {
        ["Shiny Metagross"] = {pokemon = "Shiny Metagross", looktype = 2021, addonName = "King's crown addon", fly =  0, ride = 2064, surf = 0},
        ["Metagross"] = {pokemon = "Metagross", looktype = 2018, addonName = "King's crown addon", fly =  0, ride = 2063, surf = 0},
        
        ["Shiny Slaking"] = {pokemon = "Shiny Slaking", looktype = 2303, addonName = "King's crown addon", fly =  0, ride = 0, surf = 0},
    },

    [13103] = {
        ["Shiny Metagross"] = {pokemon = "Shiny Metagross", looktype = 2021, addonName = "King's crown addon", fly =  0, ride = 2064, surf = 0},
        ["Metagross"] = {pokemon = "Metagross", looktype = 2018, addonName = "King's crown addon", fly =  0, ride = 2063, surf = 0},
        
        ["Shiny Slaking"] = {pokemon = "Shiny Slaking", looktype = 2303, addonName = "King's crown addon", fly =  0, ride = 0, surf = 0},
    },

    [13099] = {
        ["Shiny Metagross"] = {pokemon = "Shiny Metagross", looktype = 2020, addonName = "Queen's crown addon", fly =  0, ride = 2067, surf = 0},
        ["Metagross"] = {pokemon = "Metagross", looktype = 2017, addonName = "Queen's crown addon", fly =  0, ride = 2066, surf = 0},
    },

    [13097] = {
        ["Shiny Clefable"] = {pokemon = "Shiny Clefable", looktype = 2068, addonName = "Angel addon", fly =  0, ride = 0, surf = 0},
        ["Clefable"] = {pokemon = "Clefable", looktype = 2025, addonName = "Angel addon", fly =  0, ride = 0, surf = 0},
    },

    [13100] = {
        ["Jynx"] = {pokemon = "Jynx", looktype = 2023, addonName = "Witch addon", fly =  0, ride = 0, surf = 0},
		["Shiny Jynx"] = {pokemon = "Shiny Jynx", looktype = 2023, addonName = "Witch addon", fly =  0, ride = 0, surf = 0},
    },

    [13104] = {
        ["Shiny Metagross"] = {pokemon = "Shiny Metagross", looktype = 2020, addonName = "Queen's crown addon", fly =  0, ride = 2067, surf = 0},
        ["Metagross"] = {pokemon = "Metagross", looktype = 2017, addonName = "Queen's crown addon", fly =  0, ride = 2066, surf = 0},
    },

    [13249] = {
		["Elder Charizard"] = {pokemon = "Elder Charizard", looktype = 2074, addonName = "Halloween addon", fly = 2072, ride = 0, surf = 0},
        ["Charizard"] = {pokemon = "Charizard", looktype = 2073, addonName = "Halloween addon", fly =  2071, ride = 0, surf = 0},
    },

    [13107] = {
		["Elder Charizard"] = {pokemon = "Elder Charizard", looktype = 2074, addonName = "Halloween addon", fly = 2072, ride = 0, surf = 0},
        ["Charizard"] = {pokemon = "Charizard", looktype = 2073, addonName = "Halloween addon", fly =  2071, ride = 0, surf = 0},
        ["Gengar"] = {pokemon = "Gengar", looktype = 2116, addonName = "Halloween addon", fly =  2118, ride = 0, surf = 0},
        ["Shiny Gengar"] = {pokemon = "Shiny Gengar", looktype = 2117, addonName = "Halloween addon", fly =  2119, ride = 0, surf = 0},
    },

    [13251] = {
        ["Gengar"] = {pokemon = "Gengar", looktype = 2116, addonName = "Halloween addon", fly =  2118, ride = 0, surf = 0},
        ["Shiny Gengar"] = {pokemon = "Shiny Gengar", looktype = 2117, addonName = "Halloween addon", fly =  2119, ride = 0, surf = 0},
    },

    [13252] = {
        ["Shiny Blissey"] = {pokemon = "Shiny Blissey", looktype = 2121, addonName = "Witch Addon", fly = 0, ride = 0, surf = 0},
    },

    [13253] = {
        ["Shiny Blissey"] = {pokemon = "Shiny Blissey", looktype = 2120, addonName = "Nurse Addon", fly = 0, ride = 0, surf = 0},
        ["Shiny Blissey"] = {pokemon = "Shiny Blissey", looktype = 2121, addonName = "Witch Addon", fly = 0, ride = 0, surf = 0},
    },

    [13264] = {
        ["Shiny Togekiss"] = {pokemon = "Shiny Togekiss", looktype = 2122, addonName = "Batman Addon", fly = 2123, ride = 0, surf = 0},
    },

    [13301] = {
        ["Shiny Togekiss"] = {pokemon = "Shiny Togekiss", looktype = 2138, addonName = "Silly King", fly = 2137, ride = 0, surf = 0},
        ["Togekiss"] = {pokemon = "Togekiss", looktype = 2143, addonName = "Silly King", fly = 2144, ride = 0, surf = 0},
    },

    [13390] = {
        ["Shiny Togekiss"] = {pokemon = "Shiny Togekiss", looktype = 2157, addonName = "Adventurer Addon", fly = 2158, ride = 0, surf = 0},
        ["Togekiss"] = {pokemon = "Togekiss", looktype = 2155, addonName = "Adventurer Addon", fly = 2156, ride = 0, surf = 0},
    },

    [13392] = {
        ["Togekiss"] = {pokemon = "Togekiss", looktype = 2159, addonName = "Super Man Addon", fly = 2160, ride = 0, surf = 0},
        ["Shiny Togekiss"] = {pokemon = "Shiny Togekiss", looktype = 2161, addonName = "Super Man Addon", fly = 2162, ride = 0, surf = 0},
    },

    [13408] = {
        ["Miltank"] = {pokemon = "Miltank", looktype = 2171, addonName = "Miltank Addon", fly = 0, ride = 0, surf = 0},
    },

    [13410] = {
        ["Miltank"] = {pokemon = "Miltank", looktype = 2173, addonName = "Farmer Costume", fly = 0, ride = 0, surf = 0},
    },

    [13407] = {
        ["Miltank"] = {pokemon = "Miltank", looktype = 2191, addonName = "Thor Costume", fly = 0, ride = 0, surf = 0},
    },

    [13409] = {
        ["Electabuzz"] = {pokemon = "Electabuzz", looktype = 2175, addonName = "Guitar Costume", fly = 0, ride = 0, surf = 0},
    },

    [13426] = {
        ["Shiny Lucario"] = {pokemon = "Shiny Lucario", looktype = 2203, addonName = "Natal Addon", fly = 0, ride = 0, surf = 0},
    },

    [13296] = {
        ["Shiny Dragonite"] = {pokemon = "Shiny Dragonite", looktype = 2127, addonName = "Yellow snow pack addon", fly = 2128, ride = 0, surf = 0},
    },

    [13298] = {
        ["Shiny Dragonite"] = {pokemon = "Shiny Dragonite", looktype = 2130, addonName = "Green snow pack addon", fly = 2129, ride = 0, surf = 0},
    },

    [13297] = {
        ["Shiny Dragonite"] = {pokemon = "Shiny Dragonite", looktype = 2131, addonName = "Red snow pack addon", fly = 2132, ride = 0, surf = 0},
    },

    [13326] = {
        ["Shiny Gardevoir"] = {pokemon = "Shiny Gardevoir", looktype = 2142, addonName = "Caipira addon", fly = 0, ride = 0, surf = 0},
    },

    [13616] = {
        ["Shiny Gardevoir"] = {pokemon = "Shiny Gardevoir", looktype = 118, addonName = "Champions addon", fly = 0, ride = 0, surf = 0},
    },

    [13618] = {
        ["Shiny Gardevoir"] = {pokemon = "Shiny Gardevoir", looktype = 119, addonName = "Purple champions addon", fly = 0, ride = 0, surf = 0},
    },

    [13617] = {
        ["Shiny Gardevoir"] = {pokemon = "Shiny Gardevoir", looktype = 120, addonName = "Red champions addon", fly = 0, ride = 0, surf = 0},
    },

    [13617] = {
        ["Shiny Wigglytuff"] = {pokemon = "Shiny Wigglytuff", looktype = 103, addonName = "Pascoa addon", fly = 0, ride = 0, surf = 0},
    },

    [27995] = {
        ["Shiny Gardevoir"] = {pokemon = "Shiny Gardevoir", looktype = 3022, addonName = "Housekeeper Addon", fly = 0, ride = 0, surf = 0},
    },

    [28003] = {
        ["Shiny Gardevoir"] = {pokemon = "Shiny Gardevoir", looktype = 3023, addonName = "Purple Princess Addon", fly = 0, ride = 0, surf = 0},
    },

    [28001] = {
        ["Shiny Gardevoir"] = {pokemon = "Shiny Gardevoir", looktype = 3028, addonName = "Red Magic Addon", fly = 0, ride = 0, surf = 0},
    },

    [27988] = {
        ["Shiny Gardevoir"] = {pokemon = "Shiny Gardevoir", looktype = 2286, addonName = "Carpted Addon", fly = 0, ride = 0, surf = 0},
    },

    [28004] = {
        ["Shiny Dragonite"] = {pokemon = "Shiny Dragonite", looktype = 3024, addonName = "Dragon Green Addon", fly = 3027, ride = 0, surf = 0},
    },

    [28000] = {
        ["Shiny Dragonite"] = {pokemon = "Shiny Dragonite", looktype = 3026, addonName = "Dragon Purple Addon", fly = 3025, ride = 0, surf = 0},
    },

    [27990] = {
        ["Shiny Mamoswine"] = {pokemon = "Shiny Mamoswine", looktype = 3029, addonName = "Fang Frozen Addon", fly = 0, ride = 0, surf = 0},
    },

    [27993] = {
        ["Mamoswine"] = {pokemon = "Mamoswine", looktype = 3021, addonName = "Gold Helmet Addon", fly = 0, ride = 0, surf = 0},
    },

    [27996] = {
        ["Mamoswine"] = {pokemon = "Mamoswine", looktype = 3019, addonName = "Gold Ties Addon", fly = 0, ride = 0, surf = 0},
        ["Shiny Mamoswine"] = {pokemon = "Shiny Mamoswine", looktype = 3032, addonName = "Gold Ties Addon", fly = 0, ride = 0, surf = 0},
    },

    [13108] = {
        ["Blastoise"] = {pokemon = "Blastoise", looktype = 2082, addonName = "Purple ninja pack addon", fly = 0, ride = 0, surf = 2083},
        ["Shiny Blastoise"] = {pokemon = "Shiny Blastoise", looktype = 2078, addonName = "Purple ninja pack addon", fly = 0, ride = 0, surf = 2084},
    },

    [13109] = {
        ["Blastoise"] = {pokemon = "Blastoise", looktype = 2080, addonName = "Orange ninja pack addon", fly = 0, ride = 0, surf = 2087},
        ["Shiny Blastoise"] = {pokemon = "Shiny Blastoise", looktype = 2076, addonName = "Orange ninja pack addon", fly = 0, ride = 0, surf = 2088},
    },

    [13110] = {
        ["Blastoise"] = {pokemon = "Blastoise", looktype = 2079, addonName = "Red ninja pack addon", fly = 0, ride = 0, surf = 2089},
        ["Shiny Blastoise"] = {pokemon = "Shiny Blastoise", looktype = 2075, addonName = "Red ninja pack addon", fly = 0, ride = 0, surf = 2090},
    },

    [13111] = {
        ["Blastoise"] = {pokemon = "Blastoise", looktype = 2081, addonName = "Blue ninja pack addon", fly = 0, ride = 0, surf = 2085},
        ["Shiny Blastoise"] = {pokemon = "Shiny Blastoise", looktype = 2077, addonName = "Blue ninja pack addon", fly = 0, ride = 0, surf = 2086},
    },

    [13113] = {
        ["Blastoise"] = {pokemon = "Blastoise", looktype = 2080, addonName = "Orange ninja pack addon", fly = 0, ride = 0, surf = 2087},
        ["Shiny Blastoise"] = {pokemon = "Shiny Blastoise", looktype = 2076, addonName = "Orange ninja pack addon", fly = 0, ride = 0, surf = 2088},
    },

    [13114] = {
        ["Blastoise"] = {pokemon = "Blastoise", looktype = 2079, addonName = "Red ninja pack addon", fly = 0, ride = 0, surf = 2089},
        ["Shiny Blastoise"] = {pokemon = "Shiny Blastoise", looktype = 2075, addonName = "Red ninja pack addon", fly = 0, ride = 0, surf = 2090},
    },

    [13115] = {
        ["Blastoise"] = {pokemon = "Blastoise", looktype = 2081, addonName = "Blue ninja pack addon", fly = 0, ride = 0, surf = 2085},
        ["Shiny Blastoise"] = {pokemon = "Shiny Blastoise", looktype = 2077, addonName = "Blue ninja pack addon", fly = 0, ride = 0, surf = 2086},
    },

    [27991] = {
        ["Spiritomb"] = {pokemon = "Spiritomb", looktype = 3016, addonName = "Orange Ballon Addon", fly = 0, ride = 0, surf = 0},
        ["Shiny Spiritomb"] = {pokemon = "Shiny Spiritomb", looktype = 3016, addonName = "Orange Ballon Addon", fly = 0, ride = 0, surf = 0},
    },

    [27997] = {
        ["Spiritomb"] = {pokemon = "Spiritomb", looktype = 3017, addonName = "Blue Ballon Addon", fly = 0, ride = 0, surf = 0},
        ["Shiny Spiritomb"] = {pokemon = "Shiny Spiritomb", looktype = 3017, addonName = "Blue Ballon Addon", fly = 0, ride = 0, surf = 0},
    },

    [27998] = {
        ["Shiny Spiritomb"] = {pokemon = "Shiny Spiritomb", looktype = 3018, addonName = "Clown Addon", fly = 0, ride = 0, surf = 0},
    },
}
    
function onUse(cid, item, fromPosition, itemEx, toPosition)
    local pokebola = getPlayerSlotItem(cid, 8)
    if pokebola.uid <= 0 then
        doPlayerSendTextMessage(cid, 22, "… necess·rio um pokÈmon no slot")
        return true
    end

    if #getCreatureSummons(cid) >= 1 then
        doPlayerSendTextMessage(cid, 22, "O pokÈmon precisa estar dentro da pokebola!")
        return true
    end

    local pokemon = getItemAttribute(pokebola.uid, "poke") or 0
    if not pokemons[item.itemid] then
        print("[ADDON SYSTEM] - O addon: " .. item.itemid .. " n„o est· registrado.")
        return true
    end

	local tabela = pokemons[item.itemid][doCorrectString(pokemon)]
	
    if not tabela then
        doPlayerSendTextMessage(cid, 22, "Este addon nao pode ser usado!")
        return true
    end
	
    if tabela.pokemon == pokemon then
        if getItemAttribute(pokebola.uid, "addonName1") == tabela.addonName or getItemAttribute(pokebola.uid, "addonName2") == tabela.addonName or getItemAttribute(pokebola.uid, "addonName3") == tabela.addonName then
            doPlayerSendTextMessage(cid, 22, "Seu pokÈmon j· possui este addon!")
            return true
        end

        local newAddonCount = tonumber(getItemAttribute(pokebola.uid, "addonCount")) or 0
        newAddonCount = newAddonCount + 1  
        
        doItemSetAttribute(pokebola.uid, "addon"..newAddonCount, tabela.looktype)
        doItemSetAttribute(pokebola.uid, "addonName"..newAddonCount, tabela.addonName)
        doItemSetAttribute(pokebola.uid, "addonSurf"..newAddonCount, tabela.surf)
        doItemSetAttribute(pokebola.uid, "addonRide"..newAddonCount, tabela.ride)
        doItemSetAttribute(pokebola.uid, "addonFly"..newAddonCount, tabela.fly)

        doItemSetAttribute(pokebola.uid, "addonSurf", tabela.surf)
        doItemSetAttribute(pokebola.uid, "addonRide", tabela.ride)
        doItemSetAttribute(pokebola.uid, "addonFly", tabela.fly)

        doItemSetAttribute(pokebola.uid, "lastAddon", tabela.looktype)
        doItemSetAttribute(pokebola.uid, "lastAddonName", tabela.addonName)
        doItemSetAttribute(pokebola.uid, "addonCount", newAddonCount)

        doPlayerSendTextMessage(cid, 25, "ParabÈns! VocÍ adicionou o addon: " .. tabela.addonName .. " no seu pokÈmon: " .. pokemon .. ".")
        doSendMagicEffect(getThingPos(cid), 28)

        doRemoveItem(item.uid, 1)
    else
        doPlayerSendTextMessage(cid, 22, "VocÍ n„o pode usar este addon neste pokÈmon!")
    end
    return true
end