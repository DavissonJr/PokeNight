--[[
	Script: Exemplo de Quest
	Autor: MarshMello
	Email: bndgraphics0@gmail.com
]]

	function onUse(cid, item, frompos, item2, topos) -- Não mecha.

if getPlayerGroupId(cid) >= 5 then
doBroadcastMessage("o "..getCreatureName(cid).." esta tentando fazer a quest Psy ilegalmente")
return true
end
storage = 32542366532432 -- Storage a cada quest que for criada aumente um numero da storage pra qnd vc pegar o baú de outra quest ñ aparecer que vc já fez.
level = 80 -- Level que precisa pra fazer.

	if getPlayerLevel(cid) >= level and getPlayerStorageValue(cid,storage) == -1 then -- Não mecha.
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Parabéns, você competiu no treinamento. Como prêmio, você ganhou a Enigma Stone.") -- Mensagem que aparecera quando ganhar o item.
doPlayerAddItem(cid, 11452, 1) -- Não mecha.
doPlayerAddItem(cid, 11640, 1) -- Não mecha.
doTeleportThing(cid,{x=698, y=836, z=6})
setPlayerStorageValue(cid,storage,1) -- Não mecha.

elseif getPlayerLevel(cid) <= level then -- Não mecha
doPlayerSendTextMessage(cid,25,"Você precisa ser level "..level.." ou mais.") -- Mensagem que ira aparecer se o player tiver menos level que o necessario.

elseif getPlayerStorageValue(cid,storage) >= 1 then -- Não mecha.
doPlayerSendTextMessage(cid,25,"Você já fez está quest") -- Quando tentar pegar mais de uma vez o baú.
end
return true
end