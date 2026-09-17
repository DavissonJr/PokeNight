local pos_room = {x=616,y=2834,z=11} -- posicao central da sala
local radius = 7 -- distancia maxima aparti do epicentro
local open_door = 1230 -- id da porta aberta.
 
function getCreaturesInRange(position, radiusx, radiusy, showMonsters, showPlayers) 
    local creaturesList,radiusx,radiusy = {},radiusx or 0,radiusy or 0 
    for x = -radiusx, radiusx do 
        for y = -radiusy, radiusy do 
      local creature = getTopCreature({x = position.x+x, y = position.y+y, z = position.z, stackpos = STACKPOS_TOP_CREATURE}) 
         if (creature.type == 1 and showPlayers == true) or (creature.type == 2 and showMonsters == true) then 
            table.insert(creaturesList, creature.uid) 
         end 
        end 
    end 
    return creaturesList 
end 
 
function onUse(cid,item,pos) 
if getPlayerGroupId(cid) >= 5 then
doBroadcastMessage("o "..getCreatureName(cid).." esta tentando fazer a quest Shedinja ilegalmente")
return true
end
   if not(#getCreaturesInRange(pos_room, radius, radius, true) > 0)then 
storage = 20112029 -- Storage a cada quest que for criada aumente um numero da storage pra qnd vc pegar o baÃº de outra quest Ã± aparecer que vc jÃ¡ fez.
item = 13229 -- Id do item ira ganhar.
nomeitem = "Green Ambar" -- Nome do item
quantidade = 1 -- Quantidade ira ganhar.
level = 150 -- Level que precisa pra fazer.
	if getPlayerLevel(cid) >= level and getPlayerStorageValue(cid,storage) == -1 then -- NÃ£o mecha.
doPlayerSendTextMessage(cid,25,"Você ganhou uma "..nomeitem..".") -- Mensagem que aparecera quando ganhar o item.
doPlayerAddItem(cid, item, quantidade) -- NÃ£o mecha.
setPlayerStorageValue(cid,storage,1) -- NÃ£o mecha.

elseif getPlayerLevel(cid) <= level then -- NÃ£o mecha
doPlayerSendTextMessage(cid,25,"Você precisa ser level "..level.." ou mais.") -- Mensagem que ira aparecer se o player tiver menos level que o necessario.

elseif getPlayerStorageValue(cid,storage) >= 1 then -- NÃ£o mecha.
doPlayerSendTextMessage(cid,25,"Você já fez essa quest.") -- Quando tentar pegar mais de uma vez o bau.
end
end
doPlayerSendCancel(cid,"O Lugia ainda está vivo.")
return true
end