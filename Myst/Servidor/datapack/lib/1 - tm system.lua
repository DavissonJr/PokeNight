-- [
    --~~ Thalles Vitor ~~--
--]

-- Se for adicionar mais um na lista, adicione alem do TmList, adicione 1 no storageList, e no typeList
-- TM List: Lista dos TM, HMS (nome da spell)
-- Type List: Tipo do Move (TM, HM)
-- StorageList: Lista de Storages dos TM,HMS
-- levelList: Nivel necessario de uso de cada TM, HMS (Moveset)
-- cooldownList: Cooldown necessario de uso de cada TM, HMS (Moveset)

-- Se os movimentos do proximo pokemon forem os mesmos, mantenha a mesma storage daquele X movimento

tm_avaiables = {
	["Abomasnow"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

          	["Shiny Tangrowth"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},


	["Metagross"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Metagross"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Alakazam"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Alakazam"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Charizard"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Gardevoir"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Gardevoir"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Slaking"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Drapion"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Dragonite"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Lucario"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Togekiss"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Dusknoir"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Dusknoir"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Electivire"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Magmortar"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Magnezone"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Porygon"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Kingra"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Blastoise"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Blastoise"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Milotic"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Milotic"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Gyarados"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Gyarados"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Blissey"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Vileplume"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Vileplume"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Tropius"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Tropius"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Flygon"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Flygon"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Salamance"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Salamance"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Tyranitar"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Tyranitar"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Venusaur"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Venomoth"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Magmar"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Porygon"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Empoleon"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Zoroark"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Caterpie"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Infernape"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Infernape"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Typhlosion"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Typhlosion"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Starmie"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Starmie"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Staryu"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Staryu"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Gengar"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Gengar"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Steelix"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},
	
	["Shiny Steelix"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Blaziken"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Gallade"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Garchomp"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Tropius"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Tropius"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Lucario"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},

	["Shiny Lucario"] = {
		tmList = {"Dazzling Gleam", "Bulldoze", "Roost", "Grass Pledge", "Rock Slide", "Incinerate", "Magical Leaf", "Blizzard", "Toxic", "Thunder Wave", "Punch Flames", "Flare Blitz"}, 
		storageList = {23021, 23022, 23023, 23024, 23025, 23026, 23027, 23028, 23029, 23030, 23031, 23032}, 
		typeList = {"tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm", "tm"},
		levelList = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}, 
		cooldownList = {7, 7, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7}, 
		elements = {"normal", "ground", "flying", "grass", "rock", "fire", "grass", "ice", "poison", "electric", "fire", "fire"},
	},
}

accountTMS =
{
	["Dazzling Gleam"] = {level = 100, cooldown = 7, storage = 23021},
	["Bulldoze"] = {level = 100, cooldown = 7, storage = 23022},
	["Roost"] = {level = 100, cooldown = 10, storage = 23023},
	["Grass Pledge"] = {level = 100, cooldown = 7, storage = 23024},
	["Rock Slide"] = {level = 100, cooldown = 7, storage = 23025},
	["Incinerate"] = {level = 100, cooldown = 7, storage = 23026},
	["Magical Leaf"] = {level = 100, cooldown = 7, storage = 23027},
	["Blizzard"] = {level = 100, cooldown = 7, storage = 23028},
	["Toxic"] = {level = 100, cooldown = 7, storage = 23029},
	["Thunder Wave"] = {level = 100, cooldown = 7, storage = 23030},
	["Punch Flames"] = {level = 100, cooldown = 7, storage = 23031},
	["Flare Blitz"] = {level = 100, cooldown = 7, storage = 23032},
}

movesTarget = {"Flare Blitz"} -- Coloque os moves acima ali /\ que sao target
totalM = 0

function initTmSystem(cid)
	destroyTM(cid)
	if #getCreatureSummons(cid) >= 1 then
		sendTmInformations(cid)
	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Voc� precisa de um pok�mon para fora para utilizar o TM System.")
	end

	--[[ doPlayerSendTextMessage(cid, 25, "Em breve!") ]]
	return true
end

function destroyTM(cid)
	doSendPlayerExtendedOpcode(cid, 72, "destroyTM".."@")
	return true
end

function hideTM(cid)
	doSendPlayerExtendedOpcode(cid, 72, "hideTM".."@")
	return true
end

function sendModificationPokeTM(cid, index, movename, movelevel, movecooldown)
	local slot = getPlayerSlotItem(cid, 8)
	if slot.uid <= 0 then
		return false
	end

	local poke = getItemAttribute(slot.uid, "poke")
	local btype = getPokeballType(slot.itemid)
	local effect = pokeballs[btype].effect
	if not effect then
		effect = 21
	end

	local tabela = tm_avaiables[poke]
	if not tabela then
		hideTM(cid)
		return true
	end

	doItemSetAttribute(slot.uid, "movename"..index, movename) -- setar o atributo dos movimentos trocados
	doItemSetAttribute(slot.uid, "movelevel"..index, movelevel) -- setar o atributo dos movimentos trocados (level necessario de uso)
	doItemSetAttribute(slot.uid, "movecooldown"..index, movecooldown) -- setar o atributo dos movimentos trocados (cooldown da skill)
end

function detectElement(cid, name)
	for k, v in pairs(movestable) do
		local tabela = movestable[k]
		if tabela then
			local moves = {tabela.move1, tabela.move2, tabela.move3, tabela.move4, tabela.move5, tabela.move6, tabela.move7, tabela.move8, tabela.move9, tabela.move10, tabela.move11, tabela.move12}
			for i = 1, #moves do
				if moves[i] ~= nil and moves[i].name == name then
					--print(name .. " - " .. moves[i].t)
					return moves[i].t
				end
			end
		end
	end
	return "normal"
end

function canUseSpell(cid, name)
	if #getCreatureSummons(cid) <= 0 then
		return false
	end

	local tabela = movestable[getCreatureName(getCreatureSummons(cid)[1])]
	if tabela then
		local moves = {tabela.move1, tabela.move2, tabela.move3, tabela.move4, tabela.move5, tabela.move6, tabela.move7, tabela.move8, tabela.move9, tabela.move10, tabela.move11, tabela.move12}
		for i = 1, #moves do
			if moves[i] ~= nil and moves[i].name == name and moves[i].target == 1 and not isCreature(getCreatureTarget(cid)) then
				return false
			end
		end
	end

	return true
end

local maxTM = 25 -- max tm
function resetAllMovesToOriginals(cid)
	local summon = getCreatureSummons(cid)[1]
	if not summon then
		print("Summon not found, player: " .. getCreatureName(cid) .. ".")
		return false
	end

	local summonName = getCreatureName(summon)
	local x = movestable[summonName]

	if not x then
		print("Pokemon with name: " .. summonName .. " not found in movestable.")
		return false
	end

	local slot = getPlayerSlotItem(cid, 8)
	if slot.uid <= 0 then
		return false
	end

	local moves = {x.move1, x.move2, x.move3, x.move4, x.move5, x.move6, x.move7, x.move8, x.move9,
    x.move10, x.move11, x.move12}

	for i = 1, maxTM do
		--if moves[i] ~= nil then
			hideTM(cid)
			doItemEraseAttribute(slot.uid, "movename"..i) -- remover o atributo dos movimentos trocados
			doItemEraseAttribute(slot.uid, "movelevel"..i) -- remover o atributo dos movimentos trocados (level necessario de uso)
			doItemEraseAttribute(slot.uid, "movecooldown"..i) -- remover o atributo dos movimentos trocados (cooldown da skill)

			doItemEraseAttribute(slot.uid, "moveTMAL"..i) -- remover o atributo da lista de tm alterada
			doItemEraseAttribute(slot.uid, "moveTMALL"..i) -- remover o atributo da lista de tm alterada
			doItemEraseAttribute(slot.uid, "moveTMALC"..i) -- remover o atributo da lista de tm alterada
		--end
	end
	return true
end

function sendMovesSize(cid)
	local summon = getCreatureSummons(cid)[1]
	if not summon then
		print("Summon not found, player: " .. getCreatureName(cid) .. ".")
		return false
	end

	local summonName = getCreatureName(summon)
	local x = movestable[summonName]

	if not x then
		print("Pokemon with name: " .. summonName .. " not found in movestable.")
		return false
	end

	local moves = {x.move1, x.move2, x.move3, x.move4, x.move5, x.move6, x.move7, x.move8, x.move9,
    x.move10, x.move11, x.move12}

	for i = 1, #moves do
		if moves[i] ~= nil then
			local totalMoves = 12 - i
			doSendPlayerExtendedOpcode(cid, 70, "openTm".."@"..totalMoves.."@")
		end
	end
	return true
end

function sendMoves(cid)
	local summon = getCreatureSummons(cid)[1]
	if not summon then
		print("Summon not found, player: " .. getCreatureName(cid) .. ".")
		return false
	end

	local summonName = getCreatureName(summon)
	local x = movestable[summonName]

	if not x then
		--print("Pokemon with name: " .. summonName .. " not found in movestable.")
		return false
	end

	local moves = {x.move1, x.move2, x.move3, x.move4, x.move5, x.move6, x.move7, x.move8, x.move9,
    x.move10, x.move11, x.move12}

	for i = 1, #moves do
		if moves[i] ~= nil then
			local totalMoves = 12 - table.maxn(moves)
			local slot = getPlayerSlotItem(cid, 8)

			if slot.uid <= 0 then
				print("Slot with player: " .. getCreatureName(cid) .. " not found.")
				return false
			end

			local atributo = getItemAttribute(slot.uid, "movename"..i)
			local level = getItemAttribute(slot.uid, "movelevel"..i) or 1
			local cd = getItemAttribute(slot.uid, "movecooldown"..i) or 1
			local element = getItemAttribute(slot.uid, "moveelement"..i) or "normal"

			if atributo ~= nil then
				doSendPlayerExtendedOpcode(cid, 71, i.."@"..atributo.."@"..level.."@"..cd.."@"..totalMoves.."@"..table.maxn(moves).."@"..detectElement(cid, atributo).."@")
			else
				doSendPlayerExtendedOpcode(cid, 71, i.."@"..moves[i].name.."@"..moves[i].level.."@"..moves[i].cd.."@"..totalMoves.."@"..table.maxn(moves).."@"..detectElement(cid, moves[i].name))
			end
		end
	end
	return true
end

function sendTMAvaiables(cid, param)
	local slot = getPlayerSlotItem(cid, 8)
	if slot.uid <= 0 then
		hideTM(cid)
		return false
	end

	local poke = getItemAttribute(slot.uid, "poke")
	if not poke then
		hideTM(cid)
		return false
	end

	local x = tm_avaiables[poke]
	if not x then
		--[[ local quantidade = 0
		doSendPlayerExtendedOpcode(cid, 73, "receiveTMs".."@"..quantidade.."@".."none".."@"..quantidade.."@".."locked".."@".."normal".."@"..quantidade.."@"..quantidade.."@"..param.."@".."".."@") ]]
		--print("Pokemon with name: " .. poke .. " not found in tm_avaiables table.")
		return false
	end

	local summon = getCreatureSummons(cid)
	if #summon <= 0 then
		hideTM(cid)
		return false
	end

	--[[ if #x.tmList <= 0 then
		local quantidade = 0
		doSendPlayerExtendedOpcode(cid, 73, "receiveTMs".."@"..quantidade.."@".."none".."@"..quantidade.."@".."locked".."@".."normal".."@"..quantidade.."@"..quantidade.."@"..param.."@".."".."@")
	end ]]
                        
	for i = 1, #x.tmList do
		local moveTMAL = getItemAttribute(slot.uid, "moveTMAL"..i) or false -- tm alterado
		local moveTMALL = getItemAttribute(slot.uid, "moveTMALL"..i) or false -- tm alterado level
		local moveTMALC = getItemAttribute(slot.uid, "moveTMALC"..i) or false -- tm alterado cooldown

		if getPlayerStorageValue(cid, x.storageList[i]) >= 1 and not moveTMAL then
			doSendPlayerExtendedOpcode(cid, 73, "receiveTMs".."@"..i.."@"..x.tmList[i].."@"..table.maxn(x.tmList).."@".."lockedOpacity".."@"..x.typeList[i].."@"..x.levelList[i].."@"..x.cooldownList[i].."@"..param.."@"..detectElement(cid, x.tmList[i]).."@")
		elseif getPlayerStorageValue(cid, x.storageList[i]) <= 0 and not moveTMAL then
			doSendPlayerExtendedOpcode(cid, 73, "receiveTMs".."@"..i.."@"..x.tmList[i].."@"..table.maxn(x.tmList).."@".."locked".."@".."normal".."@"..x.levelList[i].."@"..x.cooldownList[i].."@"..param.."@"..detectElement(cid, x.tmList[i]).."@")
		elseif getPlayerStorageValue(cid, x.storageList[i]) >= 1 and moveTMAL then
			doSendPlayerExtendedOpcode(cid, 73, "receiveTMs".."@"..i.."@"..moveTMAL.."@"..table.maxn(x.tmList).."@".."lockedOpacity".."@"..x.typeList[i].."@"..moveTMALL.."@"..moveTMALC.."@"..param.."@"..detectElement(cid, moveTMAL).."@")
		elseif getPlayerStorageValue(cid, x.storageList[i]) <= 0 and moveTMAL then
			doSendPlayerExtendedOpcode(cid, 73, "receiveTMs".."@"..i.."@"..moveTMAL.."@"..table.maxn(x.tmList).."@".."locked".."@".."normal".."@"..moveTMALL.."@"..moveTMALC.."@"..param.."@"..detectElement(cid, moveTMAL).."@")
		end

		--if atributo <= 0 then
		--	doSendPlayerExtendedOpcode(cid, 73, "receiveTMs".."@"..i.."@"..x.tmList[i].."@"..table.maxn(x.tmList).."@".."locked".."@".."normal".."@"..x.levelList[i].."@"..x.cooldownList[i].."@"..param.."@")
	--	end
	end
	return true
end

function sendTMChanges(cid, count, movename, movelevel, movecooldown)
	local slot = getPlayerSlotItem(cid, 8)
	if slot.uid <= 0 then
		hideTM(cid)
		return false
	end

	local poke = getItemAttribute(slot.uid, "poke")
	local tabela = tm_avaiables[poke]
	if not tabela then
		hideTM(cid)
		return true
	end

	doItemSetAttribute(slot.uid, "moveTMAL"..count, movename) -- tm movename
	doItemSetAttribute(slot.uid, "moveTMALL"..count, movelevel) -- tm movelevel
	doItemSetAttribute(slot.uid, "moveTMALC"..count, movecooldown) -- tm movecooldown

	-- Setar o novo atributo
	for i = 1, #tabela.tmList do
		local tm = tabela.tmList[i]
		if tm == movename then
			doItemSetAttribute(slot.uid, "TM"..count, tabela.storageList[i])
			doItemSetAttribute(slot.uid, "TMIndex"..count, count)
		end
	end
end

function sendTMAccount(cid)
	if not isPlayer(cid) then
		return true
	end

	for k, v in pairs(accountTMS) do
		if getPlayerStorageValue(cid, v.storage) >= 1 then
			doSendPlayerExtendedOpcode(cid, 79, k.."@"..v.level.."@"..v.cooldown.."@"..detectElement(cid, k).."@")
		end
	end
end

function sendTmInformations(cid)
	sendMovesSize(cid) -- enviar quantos moves o poke tem
	sendMoves(cid) -- enviar moves pro OTC
	sendTMAvaiables(cid, "") -- enviar lista de TM pro OTC
	sendTMAccount(cid)
	return true
end