local focus = 0
local talk_start = 0
local conv = 0
local cost = 0
local pname = ""
local baseprice = 0
eventSell = {}

local pokePrice = {
	["Bulbasaur"] = 20, -- Os preÃ§os estÃ£o em dollar.
	["Ivysaur"] = 600,        --alterado v1.6
	["Venusaur"] = 1200,
	["Charmander"] = 20,
	["Charmeleon"] = 600,
	["Charizard"] = 1200,
	["Squirtle"] = 20,
	["Wartortle"] = 600,
	["Blastoise"] = 1200,
	["Caterpie"] = 75,
	["Metapod"] = 150,
	["Butterfree"] = 500,
	["Weedle"] = 50,
	["Kakuna"] = 200,
	["Beedrill"] = 150,
	["Pidgey"] = 50,
	["Pidgeotto"] = 250,
	["Pidgeot"] = 600,
	["Rattata"] = 25,
	["Raticate"] = 200,
	["Spearow"] = 50,
	["Fearow"] = 500,
	["Ekans"] = 75,
	["Arbok"] = 600,
	["Pikachu"] = 150,
	["Raichu"] = 500,
	["Sandshrew"] = 60,
	["Sandslash"] = 500,
	["Nidoran Fe"] = 50,
	["Nidorina"] = 150,
	["Nidoqueen"] = 1000,
	["Nidoran Ma"] = 50,
	["Nidorino"] = 150,
	["Nidoking"] = 1000,
	["Clefairy"] = 200,
	["Clefable"] = 500,
	["Vulpix"] = 75,
	["Ninetales"] = 1000,
	["Jigglypuff"] = 200,
	["Wigglytuff"] = 600,
	["Zubat"] = 100,
	["Golbat"] = 400,
	["Oddish"] = 25,
	["Gloom"] = 75,
	["Vileplume"] = 800,
	["Paras"] = 25,
	["Parasect"] = 500,
	["Venonat"] = 75,
	["Venomoth"] = 400,
	["Diglett"] = 50,
	["Dugtrio"] = 200,
	["Meowth"] = 75,
	["Persian"] = 200,
	["Psyduck"] = 75,
	["Golduck"] = 400,
	["Mankey"] = 75,
	["Primeape"] = 800,
	["Growlithe"] = 75,
	["Arcanine"] = 1200,
	["Poliwag"] = 25,
	["Poliwhirl"] = 100,
	["Poliwrath"] = 400,
	["Abra"] = 250,
	["Kadabra"] = 750,
	["Alakazam"] = 2000,
	["Machop"] = 100,
	["Machoke"] = 500,
	["Machamp"] = 1000,
	["Bellsprout"] = 50,
	["Weepinbell"] = 200,
	["Victreebel"] = 500,
	["Tentacool"] = 100,
	["Tentacruel"] = 1500,
	["Geodude"] = 100,
	["Graveler"] = 500,
	["Golem"] = 1000,
	["Ponyta"] = 150,
	["Rapidash"] = 1000,
	["Slowpoke"] = 50,
	["Slowbro"] = 500,
	["Magnemite"] = 50,
	["Magneton"] = 400,
	["Farfetch'd"] = 300,
	["Doduo"] = 100,
	["Dodrio"] = 700,
	["Seel"] = 100,
	["Dewgong"] = 400,
	["Grimer"] = 50,
	["Muk"] = 600,
	["Shellder"] = 50,
	["Cloyster"] = 700,
	["Gastly"] = 100,
	["Haunter"] = 300,
	["Gengar"] = 2000,
	["Onix"] = 500,
	["Drowzee"] = 150,
	["Hypno"] = 400,
	["Krabby"] = 50,
	["Kingler"] = 200,
	["Voltorb"] = 150,
	["Electrode"] = 300,
	["Exeggcute"] = 50,
	["Exeggutor"] = 600,
	["Cubone"] = 200,
	["Marowak"] = 400,
	["Hitmonlee"] = 500,
	["Hitmonchan"] = 500,
	["Lickitung"] = 400,
	["Koffing"] = 100,
	["Weezing"] = 300,
	["Rhyhorn"] = 100,
	["Rhydon"] = 500,
	["Chansey"] = 800,
	["Tangela"] = 400,
	["Kangaskhan"] = 700,
	["Horsea"] = 50,
	["Seadra"] = 150,
	["Goldeen"] = 50,
	["Seaking"] = 150,
	["Staryu"] = 150,
	["Starmie"] = 300,
	["Mr.Mime"] = 500,
	["Scyther"] = 1000,
	["Jynx"] = 1000,
	["Electabuzz"] = 1000,
	["Magmar"] = 1000,
	["Pinsir"] = 800,
	["Tauros"] = 500,
	["Magikarp"] = 25,
	["Gyarados"] = 1500,
	["Lapras"] = 1000,
	["Eevee"] = 200,
	["Vaporeon"] = 500,
	["Jolteon"] = 500,
	["Flareon"] = 500,
	["Porygon"] = 900,
	["Omanyte"] = 400,
	["Omastar"] = 1000,
	["Kabuto"] = 400,
	["Kabutops"] = 1000,
	["Aerodactyl"] = 2100,
	["Dratini"] = 500,
	["Dragonair"] = 1000,
	["Dragonite"] = 1500,
	
	["Chikorita"] = 20,
	["Bayleef"] = 150,
	["Meganium"] = 2400,
	["Cyndaquil"] = 20,
	["Quilava"] = 1200,
	["Typhlosion"] = 2400,
	["Totodile"] = 20,
	["Croconaw"] = 1500,
	["Feraligatr"] = 2400,
	["Sentret"] = 80,
	["Furret"] = 1200,
	["Hoothoot"] = 90,
	["Noctowl"] = 900,
	["Ledyba"] = 90,
	["Ledian"] = 800,
	["Spinarak"] = 80,
	["Ariados"] = 1004,
	["Crobat"] = 1400,
	["Chinchou"] = 90,
	["Lanturn"] = 1200,
	["Pichu"] = 90,
	["Cleffa"] = 90,
	["Igglybuff"] = 90,
	["Togepi"] = 100,
	["Togetic"] = 2008,
	["Natu"] = 110,
	["Xatu"] = 1200,
	["Mareep"] = 90,
	["Flaaffy"] = 800,
	["Ampharos"] = 2400,
	["Bellossom"] = 2200,
	["Marill"] = 300,
	["Azumarill"] = 1800,
	["Sudowoodo"] = 800,
	["Politoed"] = 900,
	["Hoppip"] = 80,
	["Skiploom"] = 80,
	["Jumpluff"] = 1600,
	["Aipom"] = 400,
	["Sunkern"] = 60,
	["Sunflora"] = 600,
	["Yanma"] = 400,
	["Wooper"] = 90,
	["Quagsire"] = 400,
	["Espeon"] = 2400,
	["Umbreon"] = 2400,
	["Murkrow"] = 900,
	["Slowking"] = 2400,
	["Misdreavus"] = 1900,
	["Unown"] = 250,
	["Wobbuffet"] = 1800,
	["Girafarig"] = 1800,
	["Pineco"] = 190,
	["Forretress"] = 900,
	["Dunsparce"] = 800,
	["Gligar"] = 2400,
	["Steelix"] = 2600,
	["Snubbull"] = 150,
	["Granbull"] = 900,
	["Qwilfish"] = 800,
	["Scizor"] = 1900,
	["Shuckle"] = 900,
	["Heracross"] = 1600,
	["Sneasel"] = 1300,
	["Teddiursa"] = 190,
	["Ursaring"] = 1800,
	["Slugma"] = 250,
	["Magcargo"] = 1900,
	["Swinub"] = 190,
	["Piloswine"] = 1400,
	["Corsola"] = 1500,
	["Remoraid"] = 150,
	["Octillery"] = 1600,
	["Delibird"] = 1600,
	["Mantine"] = 1800,
	["Skarmory"] = 1900,
	["Houndour"] = 220,
	["Houndoom"] = 1900,
	["Kingdra"] = 2400,
	["Phanpy"] = 200,
	["Donphan"] = 900,
	["Porygon2"] = 5000,
	["Stantler"] = 1000,
	["Smeargle"] = 1900,
	["Tyrogue"] = 800,
	["Hitmontop"] = 300,
	["Smoochum"] = 200,
	["Elekid"] = 200,
	["Magby"] = 200,
	["Miltank"] = 1200,
	["Blissey"] = 2400,
	["Larvitar"] = 1000,
	["Pupitar"] = 1800,
	["Tyranitar"] = 2800,
	
	["Treecko"] = 200,
	["Grovyle"] = 1500,
	["Sceptile"] = 2600,
	["Torchic"] = 200,
	["Combusken"] = 1500,
	["Blaziken"] = 2600,
	["Mudkip"] = 200,
	["Marshtomp"] = 1500,
	["Swampert"] = 2600,
	["Poochyena"] = 200,
	["Mightyena"] = 1800,
	["Zigzagoon"] = 200,
	["Linoone"] = 180,
	["Wurmple"] = 100,
	["Silcoon"] = 200,
	["Beautifly"] = 1000,
	["Cascoon"] = 200,
	["Dustox"] = 1000,
	["Lotad"] = 250,
	["Lombre"] = 1000,
	["Ludicolo"] = 2800,
	["Seedot"] = 300,
	["Nuzleaf"] = 1000,
	["Shiftry"] = 2800,
	["Taillow"] = 500,
	["Swellow"] = 2500,
	["Wingull"] = 350,
	["Pelipper"] = 1500,
	["Ralts"] = 800,
	["Kirlia"] = 2000,
	["Gardevoir"] = 3500,
	["Surskit"] = 500,
	["Masquerain"] = 2000,
	["Shroomish"] = 400,
	["Breloom"] = 1500,
	["Slakoth"] = 600,
	["Vigoroth"] = 2200,
	["Slaking"] = 6000,
	["Nincada"] = 150,
	["Ninjask"] = 800,
	["Shedinja"] = 2000,
	["Whismur"] = 400,
	["Loudred"] = 1000,
	["Exploud"] = 2000,
	["Makuhita"] = 500,
	["Hariyama"] = 2100,
	["Azurill"] = 300,
	["Nosepass"] = 1500,
	["Skitty"] = 800,
	["Delcatty"] = 1500,
	["Sableye"] = 1500,
	["Mawile"] = 1500,
	["Aron"] = 400,
	["Lairon"] = 1400,
	["Aggron"] = 2200,
	["Meditite"] = 600,
	["Medicham"] = 1700,
	["Electrike"] = 500,
	["Manectric"] = 1400,
	["Plusle"] = 1200,
	["Minun"] = 1200,
	["Volbeat"] = 1200,
	["Illumise"] = 120,
	["Roselia"] = 900,
	["Gulpin"] = 600,
	["Swalot"] = 1500,
	["Carvanha"] = 700,
	["Sharpedo"] = 1600,
	["Wailmer"] = 2300,
	["Wailord"] = 5000,
	["Numel"] = 700,
	["Camerupt"] = 1600,
	["Torkoal"] = 1700,
	["Spoink"] = 600,
	["Grumpig"] = 1500,
	["Spinda"] = 1000,
	["Trapinch"] = 500,
	["Vibrava"] = 1100,
	["Flygon"] = 2200,
	["Cacnea"] = 400,
	["Cacturne"] = 1200,
	["Swablu"] = 800,
	["Altaria"] = 2500,
	["Zangoose"] = 1800,
	["Seviper"] = 1400,
	["Lunatone"] = 1300,
	["Solrock"] = 1300,
	["Barboach"] = 400,
	["Whiscash"] = 1000,
	["Corphish"] = 400,
	["Crawdaunt"] = 1000,
	["Baltoy"] = 400,
	["Claydol"] = 1000,
	["Lileep"] = 2000,
	["Cradily"] = 4000,
	["Anorith"] = 2000,
	["Armaldo"] = 4000,
	["Feebas"] = 4000,
	["Milotic"] = 5000,
	["Castform"] = 1000,
	["Kecleon"] = 1400,
	["Shuppet"] = 700,
	["Banette"] = 1500,
	["Duskull"] = 800,
	["Dusclops"] = 1800,
	["Tropius"] = 3500,
	["Chimecho"] = 2300,
	["Absol"] = 2000,
	["Wynaut"] = 300,
	["Snorunt"] = 1000,
	["Glalie"] = 2000,
	["Spheal"] = 600,
	["Sealeo"] = 1500,
	["Walrein"] = 2300,
	["Clamperl"] = 1300,
	["Huntail"] = 2000,
	["Gorebyss"] = 2000,
	["Relicanth"] = 1800,
	["Luvdisc"] = 1800,
	["Bagon"] = 1200,
	["Shelgon"] = 2000,
	["Salamence"] = 3500,
	["Beldum"] = 2500,
	["Metang"] = 3500,
	["Metagross"] = 4500,
	
	["Turtwig"] = 50,
	["Grotle"] = 800,
	["Torterra"] = 4000,
	["Chimchar"] = 50,
	["Monferno"] = 800,
	["Infernape"] = 4000,
	["Piplup"] = 50,
	["Prinplup"] = 800,
	["Empoleon"] = 4000,
	["Starly"] = 300,
	["Staravia"] = 800,
	["Staraptor"] = 1800,
	["Bidoof"] = 200,
	["Bibarel"] = 2000,
	["Kricketot"] = 80,
	["Kricketune"] = 800,
	["Shinx"] = 800,
	["Luxio"] = 1000,
	["Luxray"] = 2000,
	["Budew"] = 500,
	["Roserade"] = 4000,
	["Cranidos"] = 1000,
	["Rampardos"] = 4000,
	["Shieldon"] = 2000,
	["Bastiodon"] = 4000,
	["Burmy"] = 80,
	["Wormadam"] = 100,
	["Mothim"] = 1000,
	["Combee"] = 200,
	["Vespiquen"] = 1500,
	["Pachirisu"] = 1200,
	["Buizel"] = 200,
	["Floatzel"] = 2600,
	["Cherubi"] = 1000,
	["Cherrim"] = 3500,
	["Shellos"] = 200,
	["Gastrodon"] = 2000,
	["Ambipom"] = 4000,
	["Drifloon"] = 1000,
	["Drifblim"] = 4500,
	["Buneary"] = 300,
	["Lopunny"] = 1700,
	["Mismagius"] = 5000,
	["Honchkrow"] = 5000,
	["Glameow"] = 300,
	["Purugly"] = 1800,
	["Chingling"] = 300,
	["Stunky"] = 500,
	["Skuntank"] = 1200,
	["Bronzor"] = 300,
	["Bronzong"] = 2000,
	["Bonsly"] = 300,
	["Mime Jr."] = 500,
	["Happiny"] = 500,
	["Chatot"] = 2500,
	["Spiritomb"] = 5000,
	["Gible"] = 2000,
	["Gabite"] = 3500,
	["Garchomp"] = 5000,
	["Munchlax"] = 1000,
	["Riolu"] = 5000,
	["Lucario"] = 5000,
	["Hippopotas"] = 1300,
	["Hippowdon"] = 4000,
	["Skorupi"] = 800,
	["Drapion"] = 4500,
	["Croagunk"] = 4300,
	["Toxicroak"] = 4400,
	["Carnivine"] = 4000,
	["Finneon"] = 100,
	["Lumineon"] = 1000,
	["Mantyke"] = 500,
	["Snover"] = 1500,
	["Abomasnow"] = 5000,
	["Weavile"] = 5000,
	["Magnezone"] = 4000,
	["Lickilicky"] = 5000,
	["Rhyperior"] = 5000,
	["Tangrowth"] = 5000,
	["Electivire"] = 5000,
	["Magmortar"] = 5000,
	["Togekiss"] = 5000,
	["Yanmega"] = 5000,
	["Leafeon"] = 1800,
	["Glaceon"] = 1700,
	["Gliscor"] = 5000,
	["Mamoswine"] = 5000,
	["Porygon-Z"] = 5000,
	["Gallade"] = 5000,
	["Probopass"] = 5000,
	["Dusknoir"] = 5000,
	["Froslass"] = 3000,
	["Rotom"] = 4000,
}

function sellPokemon(cid, name, price)
	local bp = getPlayerSlotItem(cid, CONST_SLOT_BACKPACK)
	local bp2 = getPlayerSlotItem(cid, 13)

    if #getCreatureSummons(cid) >= 1 then
      	sendNpcDialog(cid, getNpcCid(), "Volte seu pokémon para a pokébola para poder fazer isso.", {"Fechar"})
		focus = 0 
		return true
    end

    local storages = {17000, 63215, 17001} 
    for s = 1, #storages do
        if getPlayerStorageValue(cid, storages[s]) >= 1 then
			sendNpcDialog(cid, getNpcCid(), "Não consigo fazer isso enquanto você estiver usando Fly, Ride, Surf.", {"Fechar"}) 
			focus = 0
           	return true
        end
    end
    
    if getPlayerSlotItem(cid, 8).uid ~= 0 then 
       	if string.lower(getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke")) == string.lower(name) then
			if not getItemAttribute(getPlayerSlotItem(cid, 8).uid, "unique") then  --alterado v1.6
				sendNpcDialog(cid, getNpcCid(), "Ótimo! Obrigado por este maravilhoso "..name.."! Pegue \nseus $ "..price .." dollars. Você gostaria de me vender outro \npokémon?", {"Fechar"})
             	doRemoveItem(getPlayerSlotItem(cid, 8).uid, 1)              --alterado v1.6
             	doPlayerAddMoney(cid, price * 100)
             	doTransformItem(getPlayerSlotItem(cid, CONST_SLOT_LEGS).uid, 2395)
             	sendPokemonsBarPokemon(cid)

				focus = 0

				 addEvent(function()
					empilhar(cid)
				end, 100)
				return true
          	end
       	end
    end
    
	for a, b in pairs(pokeballs) do
		local balls = getItemsInContainerById(bp.uid, b.on)
		for _, ball in pairs (balls) do
			if string.lower(getItemAttribute(ball, "poke")) == string.lower(name) then
				if not getItemAttribute(ball, "unique") then --alterado v1.6
					sendNpcDialog(cid, getNpcCid(), "Ótimo! Obrigado por este maravilhoso "..getItemAttribute(ball, "poke").."! Pegue \nseus $ "..price .." dollars. Você gostaria de me vender outro \npokémon?", {"Fechar"})
					doRemoveItem(ball, 1)
					doPlayerAddMoney(cid, price * 100)
					sendPokemonsBarPokemon(cid)

					focus = 0

					addEvent(function()
						empilhar(cid)
					end, 100)
					return true
                end
			end
		end
	end

	for a, b in pairs(pokeballs) do
		local balls = getItemsInContainerById(bp2.uid, b.on)
		for _, ball in pairs (balls) do
			if string.lower(getItemAttribute(ball, "poke")) == string.lower(name) then
				if not getItemAttribute(ball, "unique") then --alterado v1.6
					sendNpcDialog(cid, getNpcCid(), "Ótimo! Obrigado por este maravilhoso "..getItemAttribute(ball, "poke").."! Pegue \nseus $ "..price .." dollars. Você gostaria de me vender outro \npokémon?", {"Fechar"})
					doRemoveItem(ball, 1)
					doPlayerAddMoney(cid, price * 100)
					sendPokemonsBarPokemon(cid)

					focus = 0

					addEvent(function()
						empilhar(cid)
					end, 100)
					return true
                end
			end
		end
	end

	sendNpcDialog(cid, getNpcCid(), "Ei! Você não tem um "..name..", tenha certeza que ele está na sua bag e que ele não esteja derrotado.", {"Fechar"})  --alterado v1.6
return false
end

function sellPokemonCatch(cid)
	if not isPlayer(cid) then
		return true
	end

	local totallBalls = 0
	local bp = getPlayerSlotItem(cid, 13)

    if #getCreatureSummons(cid) >= 1 then
      	sendNpcDialog(cid, getNpcCid(), "Volte seu pokémon para a pokébola para poder fazer isso.", {"Fechar"})
		focus = 0 
		return true
    end

    local storages = {17000, 63215, 17001} 
    for s = 1, #storages do
        if getPlayerStorageValue(cid, storages[s]) >= 1 then
			sendNpcDialog(cid, getNpcCid(), "Não consigo fazer isso enquanto você estiver usando Fly, Ride, Surf.", {"Fechar"}) 
			focus = 0
           	return true
        end
    end

	for i = 0, getContainerSize(bp.uid)-1 do
		local item = getContainerItem(bp.uid, i)
		if item and item.uid > 0 and getItemAttribute(item.uid, "poke") then
			totallBalls = totallBalls + 1
			
			local name = doCorrectString(getItemAttribute(item.uid, "poke"))
			if pokePrice[name] then
				local price = pokePrice[name]
				sendNpcDialog(cid, getNpcCid(), "Ótimo! Obrigado por me vender todos os seus pokémons.", {"Fechar"})
				doRemoveItem(item.uid, 1)
				doPlayerAddMoney(cid, price * 100)
            end
		end
	end

	if totallBalls <= 0 then
		focus = 0
	end
	return false
end

function onCreatureSay(cid, type, msg)

	local msg = string.lower(msg)

	if string.find(msg, "!") or string.find(msg, ",") then
		return true
	end

	if focus == cid then
		talk_start = os.clock()
	end

	local pokemons = {}
	if getPlayerSlotItem(cid, 8).uid > 0 then
		table.insert(pokemons, getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke"))
	end

	local bp = getPlayerSlotItem(cid, 3)
	if bp.uid > 0 then
		for i = 0, getContainerSize(bp.uid)-1 do
			local item = getContainerItem(bp.uid, i)
			if item and item.uid > 0 and getItemAttribute(item.uid, "poke") then
				table.insert(pokemons, getItemAttribute(item.uid, "poke"))
			end
		end
	end

	if msgcontains(msg, "hi") and focus == 0 and getDistanceToCreature(cid) <= 3 then
		if pokemons[1] ~= nil then
			pokemons[1] = string.gsub(pokemons[1], "Shiny", " ")
			sendNpcDialog(cid, getNpcCid(), "Bem-vindo a minha loja! Eu compro pokémons de todas as \nespécies, apenas me diga o nome do pokémon que \nvocê quer vender.", {"Fechar", pokemons[1], "Tudo"})
		end

		if pokemons[2] ~= nil then
			pokemons[1] = string.gsub(pokemons[1], "Shiny", " ")
			pokemons[2] = string.gsub(pokemons[2], "Shiny", " ")
			sendNpcDialog(cid, getNpcCid(), "Bem-vindo a minha loja! Eu compro pokémons de todas as \nespécies, apenas me diga o nome do pokémon que \nvocê quer vender.", {"Fechar", pokemons[1], pokemons[2], "Tudo"})
		end

		if pokemons[3] ~= nil then
			pokemons[1] = string.gsub(pokemons[1], "Shiny", " ")
			pokemons[2] = string.gsub(pokemons[2], "Shiny", " ")
			pokemons[3] = string.gsub(pokemons[3], "Shiny", " ")
			sendNpcDialog(cid, getNpcCid(), "Bem-vindo a minha loja! Eu compro pokémons de todas as \nespécies, apenas me diga o nome do pokémon que \nvocê quer vender.", {"Fechar", pokemons[1], pokemons[2], pokemons[3], "Tudo"})
		end

		if pokemons[4] ~= nil then
			pokemons[1] = string.gsub(pokemons[1], "Shiny", " ")
			pokemons[2] = string.gsub(pokemons[2], "Shiny", " ")
			pokemons[3] = string.gsub(pokemons[3], "Shiny", " ")
			pokemons[4] = string.gsub(pokemons[4], "Shiny", " ")
			sendNpcDialog(cid, getNpcCid(), "Bem-vindo a minha loja! Eu compro pokémons de todas as \nespécies, apenas me diga o nome do pokémon que \nvocê quer vender.", {"Fechar", pokemons[1], pokemons[2], pokemons[3], pokemons[4], "Tudo"})
		end

		if pokemons[5] ~= nil then
			pokemons[1] = string.gsub(pokemons[1], "Shiny", " ")
			pokemons[2] = string.gsub(pokemons[2], "Shiny", " ")
			pokemons[3] = string.gsub(pokemons[3], "Shiny", " ")
			pokemons[4] = string.gsub(pokemons[4], "Shiny", " ")
			pokemons[5] = string.gsub(pokemons[5], "Shiny", " ")
			sendNpcDialog(cid, getNpcCid(), "Bem-vindo a minha loja! Eu compro pokémons de todas as \nespécies, apenas me diga o nome do pokémon que \nvocê quer vender.", {"Fechar", pokemons[1], pokemons[2], pokemons[3], pokemons[4], pokemons[5], "Tudo"})
		end

		if pokemons[6] ~= nil then
			pokemons[1] = string.gsub(pokemons[1], "Shiny", " ")
			pokemons[2] = string.gsub(pokemons[2], "Shiny", " ")
			pokemons[3] = string.gsub(pokemons[3], "Shiny", " ")
			pokemons[4] = string.gsub(pokemons[4], "Shiny", " ")
			pokemons[5] = string.gsub(pokemons[5], "Shiny", " ")
			pokemons[6] = string.gsub(pokemons[6], "Shiny", " ")
			sendNpcDialog(cid, getNpcCid(), "Bem-vindo a minha loja! Eu compro pokémons de todas as \nespécies, apenas me diga o nome do pokémon que \nvocê quer vender.", {"Fechar", pokemons[1], pokemons[2], pokemons[3], pokemons[4], pokemons[5], pokemons[6], "Tudo"})
		end

		focus = cid
		conv = 1
		talk_start = os.clock()
		cost = 0
		pname = ""
		return true
	end

	if msgcontains(msg, "bye") and focus == cid then
		sendNpcDialog(cid, getNpcCid(),"Te vejo por aí!", {"Fechar"})
		focus = 0
		return true
	end

	if msgcontains(msg, "yes") and focus == cid and conv == 4 then
		sendNpcDialog(cid, getNpcCid(),"Me diga o nome do pokémon que você deseja vender.", {"Fechar"})
		conv = 1
		return true
	end

	if msgcontains(msg, "no") and conv == 4 and focus == cid then
		sendNpcDialog(cid, getNpcCid(),"Ok, tchau então!")
		focus = 0
		return true
	end

	local legendary = {
				"Ditto",
				"Articuno",
				"Zapdos",
				"Moltres",
				"Mew",
				"Mewtwo",
				"Raikou",
				"Entei",
				"Suicune",
				"Lugia",
				"Ho-oh",
				"Celebi",
				"Regirock",
				"Regice",
				"Registeel",
				"Latias",
				"Latios",
				"Kyogre",
				"Groudon",
				"Rayquaza",
				"Jirachi",
				"Deoxys",
				"Uxie",
				"Mesprit",
				"Azelf",
				"Dialga",
				"Palkia",
				"Heatran",
				"Regigigas",
				"Giratina",
				"Cresselia",
				"Phione",
				"Manaphy",
				"Darkrai",
				"Shaymin",
				"Arceus",
			}

	if conv == 1 and focus == cid then
		for a = 1, #legendary do
			if msgcontains(msg, legendary[a]) then
				sendNpcDialog(cid, getNpcCid(),"Eu não posso comprar este pokémon pois ele é especial.", {"Fechar"})
				return true
			end
		end
	end

	if msgcontains(msg, "no") and conv == 3 and focus == cid then
		sendNpcDialog(cid, getNpcCid(), "Bom, então qual pokémon você gostaria de vender?", {"Fechar"})
		conv = 1
		return true
	end

	if (conv == 1 or conv == 4) and focus == cid then
		local name = doCorrectPokemonName(msg)
		local pokemon = pokes[name]

		if string.lower(msg) == "tudo" then
			for i = 1, 25 do
				addEvent(function()
					if i == 25 then
						focus = 0
					end

					sellPokemonCatch(cid)
				end, i * 500)
			end
			return true
		end

		if not pokemon then
			sendNpcDialog(cid, getNpcCid(),"Desculpe, eu não conheço esse pokémon que você disse! \nVocê tem certeza que soletrou ele corretamente?", {"Fechar"})
			focus = 0
			return true
		end

        baseprice = pokePrice[name]
		if not baseprice then
			sendNpcDialog(cid, getNpcCid(),"Desculpe, eu não compro este pokémon.", {"Fechar"})
			focus = 0
			return true
		end

        cost = baseprice
        pname = name
		sendNpcDialog(cid, getNpcCid(), "Você tem certeza que deseja vender um "..name.." por \n$ "..cost .." dollars?", {"Fechar", "Yes"})
        conv = 3       
	end

	if isConfirmMsg(msg) and focus == cid and conv == 3 then
		if sellPokemon(cid, pname, cost) then
			conv = 4
		else
			conv = 1
		end
		return true
	end

end

local intervalmin = 38
local intervalmax = 70
local delay = 25
local number = 1
local messages = {"Compro alguns pokémons bonitos! Venha cá vendê-los!",
		  "Quer vender um pokémon? Veio ao lugar certo!",
		  "Compro pokémons! Ofertas excelentes!",
		  "Cansou de um pokémon? Por que não o vende para mim então?",
		  "Está afim de ganhar uma grana extra? Compro seus pokémons agora mesmo!",
		  "Capturou sem querer querendo algum pokémon e não quer mais ele? Venda-o aqui!",
}

function onThink()

	if focus == 0 then
		selfTurn(1)
		delay = delay - 0.5
		if delay <= 0 then
			selfSay(messages[number])
			number = number + 1
				if number > #messages then
					number = 1
				end
			delay = math.random(intervalmin, intervalmax)
		end
		return true
	else

	if not isCreature(focus) then
		focus = 0
		return true
	end

		local npcpos = getThingPos(getThis())
		local focpos = getThingPos(focus)

		if npcpos.z ~= focpos.z then
			focus = 0
			return true
		end

		if (os.clock() - talk_start) > 70 then
			focus = 0
			selfSay("Você demora demais hein colega, fale comigo quando decidir vender pokémons.")
		end

		if getDistanceToCreature(focus) > 3 then
			selfSay("Até mais e obrigado!")
			focus = 0
			return true
		end

		local dir = doDirectPos(npcpos, focpos)	
		selfTurn(dir)
	end

	return true
end