function onSay(cid, words, param, channel)
divepos = getCreaturePosition(cid)
npos2 = getPlayerMasterPos(cid)
poszao = {x=divepos.x, y=divepos.y, z=7}
pos = getCreaturePosition(cid)

local waters = {11756, 4614, 4615, 4616, 4617, 4618, 4619, 4608, 4609, 4610, 4611, 4612, 4613, 7236, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625, 4665, 4666, 4820, 4821, 4822, 4823, 4824, 4825}

local poke = {'Poliwag', 'Poliwhirl', 'Seaking', 'Dewgong', 'Blastoise', 'Tentacruel', 'Lapras', 'Gyarados', 'Omastar', 'Kabutops',
'Vaporeon', 'Staryu', 'Starmie', 'Goldeen', 'Seadra', 'Golduck', 'Squirtle', 'Wartortle', 'Tentacool', 'Snorlax', 'Poliwrath', 'Shiny Poliwag',
'Shiny Poliwhirl', 'Shiny Seaking', 'Shiny Dewgong', 'Shiny Blastoise', 'Shiny Tentacruel', 'Shiny Lapras', 'Shiny Gyarados', 'Shiny Omastar',
'Shiny Kabutops', 'Shiny Vaporeon', 'Shiny Staryu', 'Shiny Starmie', 'Shiny Goldeen', 'Shiny Seadra', 'Shiny Golduck', 'Shiny Squirtle',
'Shiny Wartortle', 'Shiny Tentacool', 'Shiny Snorlax', 'Shiny Poliwrath', "Mantine", "Totodile", "Croconow", "Feraligatr", "Marill",
"Azumarill", "Quagsire", "Wooper", "Octillery", "Kingdra"}


if getCreatureOutfit(cid).lookType == 316 or getCreatureOutfit(cid).lookType == 648 then
doSendMagicEffect(fromPosition, 136)
end

if (getPlayerStorageValue(cid, 63215) >= 1 or getPlayerStorageValue(cid, 17000) >= 1) then
return true
end

if #getCreatureSummons(cid) == 0 then
doPlayerSendCancel(cid, "You need a pokemon to dive.")
return true
end

if (not isInArray(poke, getPokemonName(getCreatureSummons(cid)[1]))) then
doPlayerSendCancel(cid, "This pokemon cannot dive.")
return true
end

if (not isInArray(waters, getTileThingByPos(poszao).itemid)) then
doPlayerSendCancel(cid, "You cant up here.")
return true
end

if pos.z >= 8 then
if doTeleportThing(cid, poszao) == true then
doSendMagicEffect(poszao, 14)
end
else return print("Erro ao utilizar comando !back")
end
if pos.z <=7 then
doPlayerSendCancel(cid, "Você precisa estar mergulhando para usar este comando.")
return true
end
setPlayerStorageValue(cid, 13008, 0)
end