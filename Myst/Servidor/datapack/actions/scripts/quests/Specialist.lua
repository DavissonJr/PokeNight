function onUse(cid, item, frompos, item2, topos) -- Não mecha.


storage = 224241 -- Storage a cada quest que for criada aumente um numero da storage pra qnd vc pegar o baú de outra quest ñ aparecer que vc já fez.
item = 7958 -- Id do item ira ganhar.
nomeitem = "Jester Staff" -- Nome do item
quantidade = 1 -- Quantidade ira ganhar.
level = 150 -- Level que precisa pra fazer.

	if getPlayerLevel(cid) >= level then
	if getPlayerStorageValue(cid,storage) == -1 then -- Não mecha.
doPlayerSendTextMessage(cid,25,"Você ganhou uma "..nomeitem..".") -- Mensagem que aparecera quando ganhar o item.
doPlayerAddItem(cid, item, quantidade) -- Não mecha.
setPlayerStorageValue(cid,storage,1) -- Não mecha.

else -- Não mecha
doPlayerSendTextMessage(cid,25,"Você ja fez esta quest.") -- Mensagem que ira aparecer se o player tiver menos level que o necessario.
return true
end
else -- Não mecha.
doPlayerSendTextMessage(cid,25,"Você precisa ser level "..level.." ou mais.") -- Quando tentar pegar mais de uma vez o baú.
return true
end
return true
end