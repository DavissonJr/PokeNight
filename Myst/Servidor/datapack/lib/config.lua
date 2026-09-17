-- Variaveis
useOTClient = true
useKpdoDlls = true 
intervalToRegrowBushAndStones = 15 
nurseHealsOnlyInPZ = false
accountManagerOutfit = {lookType = 304, lookHead = 1, lookBody = 1, lookLegs = 1, lookFeet = 1}
accountManagerRandomPokemonOutfit = false
reloadHighscoresWhenUsingPc = true
backupPos = {x = 4, y = 3, z = 10}
nurseHealsPokemonOut = false
maximumBoost = 199
boost_rate = 1.8
catchMakesPokemonHappier = true
dittoCopiesStatusToo = true
dittoBonus = 0.85    
wildBeforeNames = true
hideBoost = true                                                          
showBoostSeparated = true
hideSummonsLevel = true
canFishWhileSurfingOrFlying = false
allEvolutionsCanBeInduzedByStone = true
evolutionByStoneRequireLevel = true
PlayerSpeed = 220
playerExperienceRate = 2.0
attackRate = 5.8
specialoffenseRate = 1
levelFactor = 1.5
defenseRate = 0.7
playerDamageReduction = 0.32
summonReduction = 1
generalSpecialAttackReduction = 0.4
summonSpecialDamageReduction = 0.5
vitReductionForWild = 1	
speedRate = 1.85
wildEvolveChance = 850
pokemonExpPerLevelRate = 1
baseExpRate = 15
generalExpRate = 0.7
HPperVITwild = 17
HPperVITsummon = 17
baseNurseryHappiness = 95
baseNurseryHunger = 150
minHappyToEvolve = 190
maxHappyToEvolve = 500
happyLostOnDeath = 35
happyGainedOnEvolution = 20

-- Go/back 
gobackmsgs = {
[1] = {go = "doka, Eu escolho você!", back = "Volte, doka!"},
}

gobackmsgsen = {
[1] = {go = "doka, I choose you!", back = "Come back, doka!"},
}

gobackmsgses = {
[1] = {go = "doka, Yo escojo a ti!", back = "Retorno, doka!"},
}

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

-- Special Evolutions
specialevo = {"Poliwhirl", "Gloom", "Slowpoke", "Tyrogue", "Eevee", "Burmy"}
spcevo = {
["Poliwhirl"] = {[1] = {level = 60, evolution = "Poliwrath", count = 1, stoneid = 11442, stoneid2 = 11446},
		         [2] = {level = 70, evolution = "Politoed", count = 1, stoneid = 11442, stoneid2 = 12244}},
["Gloom"] =     {[1] = {level = 60, evolution = "Vileplume", count = 1, stoneid = 11443, stoneid2 = 0},
		         [2] = {level = 70, evolution = "Bellossom", count = 1, stoneid = 11441, stoneid2 = 12242}},
["Burmy"] =     {[1] = {level = 25, evolution = "Wormadam Grass", count = 1, stoneid = 11441, stoneid2 = 0},
		         [2] = {level = 25, evolution = "Wormadam Ground", count = 1, stoneid = 11441, stoneid2 = 11451},
				 [3] = {level = 25, evolution = "Wormadam Steel", count = 1, stoneid = 11441, stoneid2 = 12232}},				 

["Snorunt"] = {[1] = {level = 45, evolution = "Glalie", count = 1, stoneid = 28195, stoneid2 = 0},
			   [2] = {level = 60, evolution = "Froslass", count = 1, stoneid = 11450, stoneid2 = 0}},

["Kirlia"] = {[1] = {level = 80, evolution = "Gardevoir", count = 1, stoneid = 11452, stoneid2 = 0},
[2] = {level = 80, evolution = "Gallade", count = 1, stoneid = 11446, stoneid2 = 0}},		

["Clamperl"] = {[1] = {level = 42, evolution = "Huntail", count = 1, stoneid = 11442, stoneid2 = 0},
[2] = {level = 42, evolution = "Gorebyss", count = 1, stoneid = 11453, stoneid2 = 0}},

["Eeevee"] = {[1] = {level = 60, evolution = "Vaporeon", count = 1, stoneid = 11442, stoneid2 = 0},
[2] = {level = 60, evolution = "Jolteon", count = 1, stoneid = 11444, stoneid2 = 0},
[3] = {level = 60, evolution = "Flareon", count = 1, stoneid = 11447, stoneid2 = 0},
[4] = {level = 60, evolution = "Espeon", count = 1, stoneid = 11452, stoneid2 = 0},
[5] = {level = 60, evolution = "Umbreon", count = 1, stoneid = 11450, stoneid2 = 0},
[6] = {level = 60, evolution = "Leafeon", count = 1, stoneid = 11441, stoneid2 = 0},
[7] = {level = 60, evolution = "Glaceon", count = 1, stoneid = 28195, stoneid2 = 0},

},
}

-- Auras
auraSyst = {  
["red"] = 19,
["blue"] = 40,
["green"] = 164,
["yellow"] = 207,
["white"] = 29,      
["gray"] = 165,
["cyan"] = 177,
["purple"] = 208,
["orange"] = 219, 
}

-- Hitmonchans
hitmonchans = {
["Hitmonchan"] = {
[0] = {out = 559, eff = 112, type = FIGHTINGDAMAGE},  --outfit normal
[1] = {out = 1075, eff = 35, type = FIREDAMAGE},    --outfit fogo
[2] = {out = 1077, eff = 48, type = ELECTRICDAMAGE},    --outfit raio
[3] = {out = 1078, eff = 43, type = ICEDAMAGE},    --outfit gelo
[4] = {out = 1076, eff = 140, type = GHOSTDAMAGE}   --outfit ghost
},
                  
["Shiny Hitmonchan"] = {              
                         
[0] = {out = 837, eff = 112, type = FIGHTINGDAMAGE},  
[1] = {out = 1080, eff = 35, type = FIREDAMAGE},  
[2] = {out = 1081, eff = 48, type = ELECTRICDAMAGE},  
[3] = {out = 1082, eff = 43, type = ICEDAMAGE},   
[4] = {out = 1079, eff = 140, type = GHOSTDAMAGE}   
}
}

-- HeadBuut
headbutt = {
[25] = {{"Metapod", 3}, {"Kakuna", 3}, {"Pidgey", 3}, {"Ekans", 1}, {"Sentret", 1}, {"Pineco", 1}, {"Spinarak", 2}},
[40] = {{"Pineco", 2}, {"Pidgeotto", 1}, {"Hoothoot", 1}, {"Natu", 1}, {"Beedrill", 2}, {"Spearow", 3}},
[60] = {{"Arbok", 1}, {"Beedrill", 4}, {"Furret", 1}, {"Ariados", 2}, {"Pidgeotto", 2}, {"Yanma", 1}, {"Pineco", 4}},
[80] = {{"Beedrill", 5}, {"Forretress", 1}, {"Furret", 3}, {"Ariados", 3}, {"Pidgeotto", 4}, {"Yanma", 3}},
[1000] = {{"Forretress", 3}, {"Noctowl", 2}, {"Xatu", 2}, {"Yanma", 4}, {"Beedrill", 6}, {"Furret", 6}},
}

-- Look
lookClans = {
[1] = {"a Volcanic Spark", "a Volcanic Flame","a Volcanic Firetamer","a Volcanic Pyromancer","a Volcanic Master"},
[2] = {"a Seavell Drop", "a Seavell Icelake","a Seavell Waterfall","a Seavell Frost","a Seavell Master"},
[3] = {"an Orebound Sand", "an Orebound Rock","an Orebound Solid","an Orebound Hardskin","an Orebound Hero"},
[4] = {"a Wingeon Cloud", "a Wingeon Wind","a Wingeon Sky","a Wingeon Falcon","a Wingeon Dragon"},
[5] = {"a Malefic Troublemaker", "a Malefic Venomancer","a Malefic Spectre","a Malefic Nightwalker","a Malefic Master"},
[6] = {"a Gardestrike Fist", "a Gardestrike Tamer","a Gardestrike Fighter","a Gardestrike DeathHand","a Gardestrike Champion"},
[7] = {"a Psycraft Mind", "a Psycraft Brain","a Psycraft Scholar","a Psycraft Telepath","a Psycraft Medium"},
[8] = {"a Naturia Seed", "a Naturia Sprout","a Naturia Webhead","a Naturia Woodtrunk","a Naturia Keeper"},
[9] = {"a Raibolt Shock", "a Raibolt Watt","a Raibolt Electrician","a Raibolt Overcharged","a Raibolt Legend"},
}

youAre = {
[3] = "um(a) Help.",
[4] = "um(a) Tutor.",
[5] = "um(a) Game Master.",
[6] = "um(a) Administrador.",
[20] = "Treinador(a).",
[19] = "um Unlogged GM",
[18] = "um Unlogged Tutor"
}
