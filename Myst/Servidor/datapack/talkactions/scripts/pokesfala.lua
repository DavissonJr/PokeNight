local Fpoke = {"Bulbasaur", "Ivysaur", "Venusaur", "Charmander", "Charmeleon", "Charizard", "Squirtle", "Wartortle", "Blastoise",
"Caterpie", "Metapod", "Butterfree", "Weedle", "Kakuna", "Beedrill", "Pidgey", "Pidgeotto", "Pidgeot", "Rattata",
"Raticate", "Spearow", "Fearow", "Ekans", "Arbok", "Pikachu", "Raichu", "Sandshrew", "Sandslash", "Nidoran Female",
"Nidorina", "Nidoqueen", "Nidoran Male", "Nidorino", "Nidoking", "Clefairy", "Clefable", "Vulpix", "Ninetales",
"Jigglytuff", "Wigglytuff", "Zubat", "Golbat", "Odish", "Gloom", "Vileplume", "Paras", "Parasect", "Venonat", "Venomoth",
"Diglett", "Dugtrio", "Mewoth", "Persian", "Psyduck", "Golduck", "Mankey", "Primeape", "Growlithe", "Arcanine",
"Poliwag", "Poliwhirl", "Poliwrath", "Abra", "Kadabra", "Alakazam", "Machop", "Machoke", "Machamp", "Bellsprout",
"Weepinbell", "Victreebel", "Tentacool", "Tentacruel", "Geodude", "Graveler", "Golem", "Ponyta", "Rapidash", "Slowpoke",
"Slowbro", "Magnamite", "Magneton", "Farfetch'd", "Doduo", "Dodrio", "Seel", "Dewgong", "Grimer", "Muk", "Shellder",
"Cloyster", "Gastly", "Haunter", "Gengar", "Onix", "Drowzee", "Hypno", "Krabby", "Kingler", "Voltorb", "Electrode",
"Exeggcute", "Exeggutor", "Cubone", "Marowak", "Hitmonlee", "Hitmonchan", "Lickitung", "Koffing", "Weezing", "Rhyhorn",
"Rhydon", "Chansey", "Tangela", "Kangaskhan", "Horsea", "Seadra", "Goldeen", "Seaking", "Staryu", "Starmie", "Mr. Mime",
"Scyther", "Jynx", "Electabuzz", "Magmar", "Pinsir", "Tauros", "Magikarp", "Gyarados", "Lapras", "Ditto", "Eevee", "Vaporeon",
"Jolteon", "Flareon", "Porygon", "Omanyte", "Omastar", "Kabuto", "Kabutops", "Snorlax", "Porygon Z", "Dragonair", "Dratini", "Absol", "Altaria", "Baltoy", "Claydol", "Buneary", "Beldum", "Metang", "Metagross", "Camerupt", "Carnivine", "Carvanha", "Sharpedo", "Croagunk", "Toxicroak", "Buizel", "Floatzel", "Gabite", "Gible", "Gliscor", "Honchkrow", "Luxray", "Mamoswine", "Pachirisu", "Plusle", "Minun", "Probopass", "Purugly", "Froslass", "Glalie", "Snorunt", "Lunatone", "Solrock", "Staraptor", "Tropius", "Yanmega", "Zangoose", "Rhyperior", "Gastrodon", "Typhlosion", "Quilava", "Cyndaquil", "Chikorita", "Meganium", "Bayleef", "Totodile", "Croconaw", "Feraligatr"
}
function onSay(cid,words,param)
local pokemons = getCreatureSummons(cid)
if #pokemons == 0 then
return doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "your pokemon is not out of the ball")
end
if table.find(Fpoke, getCreatureName(getCreatureSummons(cid)[1])) then
doCreatureSay(getCreatureSummons(cid)[1],param,TALKTYPE_MONSTER)
else
doPlayerSendCancel(cid,"That Pokemon Do not Speak.")
end
return true
end


