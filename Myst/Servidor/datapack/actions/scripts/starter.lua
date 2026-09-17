local starterpokes = {
["Chinchar"] = {x = 1341, y = 989, z = 10},
["Torchic"] = {x = 1343, y = 989, z = 10},
["Cyndaquil"] = {x = 1034, y = 1024, z = 5},
["Charmander"] = {x = 1347, y = 989, z = 10},   
["Turtwig"] = {x = 1351, y = 989, z = 10},
["Treecko"] = {x = 1353, y = 989, z = 10},
["Chikorita"] = {x = 1355, y = 989, z = 10},
["Bulbasaur"] = {x = 1357, y = 989, z = 10},
["Piplup"] = {x = 1361, y = 989, z = 10},
["Mudkip"] = {x = 1363, y = 989, z = 10},
["Totodile"] = {x = 1365, y = 989, z = 10},
["Squirtle"] = {x = 1367, y = 989, z = 10},
["Nosepass"] = {x = 231, y = 283, z = 3},
}

local btype = "normal"

function onUse(cid, item, frompos, item2, topos)

	if getPlayerLevel(cid) > 5 then   
	return true
	end

	local pokemon = ""

	for a, b in pairs (starterpokes) do
		if isPosEqualPos(topos, b) then
			pokemon = a
		end
	end
    if pokemon == "" then return true end
	
    if getPlayerStorageValue(cid, 9658754) ~= 1 then              
       sendMsgToPlayer(cid, 27, "Fale com o professor Robert para escolher sua cidade inicial primeiro!")
       return true
    end                                            --alterado v1.9 \/

	doPlayerSendTextMessage(cid, 27, "Voce tem o seu primeiro pokemon! Você tambem recebeu algumas pokeballs para ajuda lo em seu caminho.")
	doPlayerSendTextMessage(cid, 27, "Nao se esqueça de usar a sua pokedex em todos os pokemon desconhecidos!")

    addPokeToPlayer(cid, pokemon, 0, nil, btype, true)
    doPlayerAddItem(cid, 1748, 10)

	doSendMagicEffect(getThingPos(cid), 29)
	doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
	doSendMagicEffect(getThingPos(cid), 27)
	doSendMagicEffect(getThingPos(cid), 29)
	

return TRUE
end