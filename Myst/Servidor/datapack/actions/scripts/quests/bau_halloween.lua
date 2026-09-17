local a = {
[1] = {balltype = "normal", ballid = 11826,
        pokemons = {"Bronzong", "Tropius", "Metagross", "Blissey", "Milotic", "Gardevoir", "Carnivine", "Shiny Roserade", "Shiny Gengar", "Shiny Gengar", "Gengar", "Elder Charizard", "Elder Charizard"}},
}    
local Premio = {x=865, y=435, z=9}

	function onUse(cid, item, frompos, item2, topos) -- Não mecha.

storage = 1147890 -- A CADA BAU AUMENTA 1 NUMERO, 1147852, 1147853, 1147854 ...
item = 1998 -- Id do item ira ganhar.
nomeitem = "Green Backpack with Halloween items" -- Nome do item
quantidade = 1 -- Quantidade ira ganhar.
level = 150 -- Level que precisa pra fazer.

	if getPlayerLevel(cid) >= level then -- Não mecha.
doPlayerSendTextMessage(cid,22,"Você ganhou uma " .. nomeitem .. "!") -- Mensagem que aparecera quando ganhar o item.
local b = a[1]                                    
               if not b then return true end
         local pokemon = b.pokemons[math.random(#b.pokemons)]
         local btype = b.balltype
               if not pokeballs[btype] then return true end    
doPlayerAddItem(cid, item, quantidade) -- Não mecha.
doPlayerAddItem(cid, 2160, 10) -- Não mecha.
doPlayerAddItem(cid, 12618, 1) -- Não mecha.
doPlayerAddItem(cid, 2183, 1) -- Não mecha.
setPlayerStorageValue(cid, 5555413, os.time() + 30*60)
if getPlayerStorageValue(cid, 1147891) == -1 then
addPokeToPlayer(cid, pokemon, 0, nil, btype)     --alterado v1.9      
doPlayerSendTextMessage(cid, 27, "Você recebeu um " .. pokemon .. " de prêmio! (assim que você fizer novamente, não receberá um pokémon.)")    
setPlayerStorageValue(cid,1147891,1) -- Não mecha.
else
doPlayerSendTextMessage(cid, 27, "Você fez a quest pela " .. getPlayerStorageValue(cid, storage) .. "º vez.")    
end
setPlayerStorageValue(cid,storage,getPlayerStorageValue(cid, storage) + 1) -- Não mecha.
doTeleportThing(cid, Premio, true)  
elseif getPlayerLevel(cid) <= level then -- Não mecha
doPlayerSendTextMessage(cid,25,"Você precisa ser level "..level.." ou mais.") -- Mensagem que ira aparecer se o player tiver menos level que o necessario.
end
return true
end