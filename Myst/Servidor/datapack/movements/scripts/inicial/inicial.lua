local starterpokes = {
  ["charmander"] = {x = 1055, y = 1917, z = 6},
  ["squirtle"] = {x = 1055, y = 1919, z = 6},
  ["bulbasaur"] = {x = 1055, y = 1921, z = 6},
  ["torchic"] = {x = 1056, y = 1923, z = 6},
  ["treecko"] = {x = 1060, y = 1923, z = 6},
  ["cyndaquil"] = {x = 1061, y = 1917, z = 6},
  ["totodile"] = {x = 1061, y = 1919, z = 6},
  ["chikorita"] = {x = 1061, y = 1921, z = 6},
  ["mudkip"] = {x = 1058, y = 1923, z = 6},
} 

local btype = "normal" 
local storage = 4812394

function onStepIn(cid, fromPosition, toPos)
local pokemon = "" 

    for a, b in pairs (starterpokes) do
        if isPosEqualPos(toPos, b) then
            pokemon = a
         end
    end
     
	  
    if pokemon == "" then return true end
  if getPlayerStorageValue(cid, storage) <= 0 then

     doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Pronto, agora fale com a Enfermeira Nurse Joy dizendo {oi} para healar seu pokémon, após puxe sua pokeball para o slot, e de Use pra chamar seu pokémon!")
		doPlayerSendTextMessage(cid, 22, pokemon)
     addPokeToPlayer(cid, pokemon, nil, nil, 0, nil, btype, false)
     doPlayerAddItem(cid, 2394, 20) 
     doPlayerAddItem(cid, 2148, 50) 
     doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
	 setPlayerStorageValue(cid, storage, 1)
	 doSendMagicEffect(getThingPos(cid), 21)
	 else
	 doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você já pegou seu Pokémon inicial.")
	 doTeleportThing(cid, fromPosition, TRUE)
   return true
end 
end