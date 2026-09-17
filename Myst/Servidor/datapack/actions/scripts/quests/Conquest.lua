function onUse(cid, item, frompos, item2, topos) -- Não mecha.
if getPlayerGroupId(cid) >= 5 then
doBroadcastMessage("o "..getCreatureName(cid).." esta tentando fazer a quest Conquest ilegalmente")
return true
end

storage = 95148455 -- Storage a cada quest que for criada aumente um numero da storage pra qnd vc pegar o baú de outra quest ñ aparecer que vc já fez.
item = 2183 -- Id do item ira ganhar.
item2 = 13381 --- item 2
nomeitem = "Addon Box" -- Nome do item
nomeitem2 = "Cursed Soul" -- Nome do item
quantidade = 1 -- Quantidade ira ganhar.
quantidade2 = 1 -- Quantidade ira ganhar.
level = 150 -- Level que precisa pra fazer.

if getPlayerLevel(cid) >= level and getPlayerStorageValue(cid,storage) == -1 then -- Não mecha.
doPlayerSendTextMessage(cid,25,"Você completou a quest e recebeu uma "..nomeitem.." e uma "..nomeitem2.." !") -- Mensagem que aparecera quando ganhar o item.
doPlayerAddItem(cid, item, quantidade) -- Não mecha.
doPlayerAddItem(cid, item2, quantidade2) -- Não mecha.
setPlayerStorageValue(cid,storage,1) -- Não mecha.

elseif getPlayerLevel(cid) <= level then -- Não mecha
doPlayerSendTextMessage(cid,25,"Você precisa ser level "..level.." ou mais.") -- Mensagem que ira aparecer se o player tiver menos level que o necessario.

elseif getPlayerStorageValue(cid,storage) >= 1 then -- Não mecha.
doPlayerSendTextMessage(cid,22,"Você já pegou o seu prêmio.") -- Quando tentar pegar mais de uma vez o baú.
end
return true
end