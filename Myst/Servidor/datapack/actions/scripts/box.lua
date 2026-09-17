local a = {
[11638] = {balltype = "normal", ballid = 11826,
        pokemons = {"Slowpoke", "Magnemite", "Doduo", "Seel", "Grimer", "Gastly", "Drowzee", "Voltorb", "Cubone", "Koffing",
        "Goldeen", "Vulpix", "Tentacool", "Bulbasaur", "Charmander", "Squirtle", "Butterfree", "Beedrill", "Metapod", "Kakuna", 
        "Raticate", "Spearow", "Ekans", "Abra", "Mankey", "Psyduck", "Pikachu", "Sandshrew", "Nidoran Female", 
        "Nidoran Male", "Zubat", "Diglett", "Venonat", "Meowth", "Poliwag", "Growlithe", "Machop", "Ponyta", "Geodude"}},
[11639] = {balltype = "greath", ballid = 11832,
        pokemons = {"Slowpoke", "Magnemite", "Doduo", "Seel", "Grimer", "Gastly", "Drowzee", "Voltorb", "Cubone", "Koffing",
        "Goldeen", "Vulpix", "Tentacool", "Bulbasaur", "Charmander", "Squirtle", "Butterfree", "Beedrill", "Metapod", "Kakuna", 
        "Raticate", "Spearow", "Ekans", "Abra", "Mankey", "Psyduck", "Pikachu", "Sandshrew", "Nidoran Female", 
        "Nidoran Male", "Zubat", "Diglett", "Venonat", "Meowth", "Poliwag", "Growlithe", "Machop", "Ponyta", "Geodude"}},
[11640] = {balltype = "super", ballid = 11835,
        pokemons = {"Pidgeot", "Fearow", "Sandslash", "Ninetales", "Vileplume", "Primeape", "Golduck", "Kadabra", "Rapidash", 
        "Clefable", "Wigglytuff", "Dewgong", "Onix", "Cloyster", "Hypno", "Exeggutor", "Marowak", "Hitmonchan", "Hitmonlee", 
        "Lickitung", "Chansey", "Tangela", "Mr. Mime", "Pinsir", "Vaporeon", "Jolteon", "Flareon", "Porygon", "Dragonair"}},
[11641] = {balltype = "ultra", ballid = 11829,
        pokemons = {"Slowpoke", "Magnemite", "Doduo", "Seel", "Grimer", "Gastly", "Drowzee", "Voltorb", "Cubone", "Koffing",
        "Goldeen", "Vulpix", "Tentacool", "Bulbasaur", "Charmander", "Squirtle", "Butterfree", "Beedrill", "Metapod", "Kakuna", 
        "Raticate", "Spearow", "Ekans", "Abra", "Mankey", "Psyduck", "Pikachu", "Sandshrew", "Nidoran Female", 
        "Nidoran Male", "Zubat", "Diglett", "Venonat", "Meowth", "Poliwag", "Growlithe", "Machop", "Ponyta", "Geodude"}},
} 

local happy = 220 
         
function onUse(cid, item, frompos, item2, topos)
         local b = a[item.itemid]                                    
               if not b then return true end
         local pokemon = b.pokemons[math.random(#b.pokemons)]
         local btype = b.balltype
               if not pokeballs[btype] then return true end    
         
         doPlayerSendTextMessage(cid, 27, "You opened a pokemon prize box +"..item.itemid - (11637).."!")
	     doPlayerSendTextMessage(cid, 27, "The prize pokemon was a "..pokemon..", congratulations!")
	     doSendMagicEffect(getThingPos(cid), 29)
               
         addPokeToPlayer(cid, pokemon, 0, nil, btype)     --alterado v1.9                                                 
         doRemoveItem(item.uid, 1)
	     
return true
end