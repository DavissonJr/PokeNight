--[[
	Script: Exemplo de Quest
	Autor: MarshMello
	Email: bndgraphics0@gmail.com
]]

	function onUse(cid, item, frompos, item2, topos) -- Não mecha.

if getPlayerGroupId(cid) >= 5 then
doBroadcastMessage("o "..getCreatureName(cid).." esta tentando pegar o baú incial Injustamente")
return true
end
storage = 325423665324322323214 -- Storage a cada quest que for criada aumente um numero da storage pra qnd vc pegar o baú de outra quest ñ aparecer que vc já fez.
level = 40 -- Level que precisa pra fazer.

	if getPlayerLevel(cid) >= level and getPlayerStorageValue(cid,storage) == -1 then -- Não mecha.
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Parabéns! Você competiu no treinamento. Como prêmio você ganhou uma Box 1, 30 Pokébolas, 20 Poções.") -- Mensagem que aparecera quando ganhar o item.
doPlayerAddItem(cid, 2392, 30) -- Não mecha.
doPlayerAddItem(cid, 11638, 1) -- Não mecha.
doPlayerAddItem(cid, 12346, 20) -- Não mecha.
doTeleportThing(cid,{x=1037, y=1036, z=7})
setPlayerStorageValue(cid,storage,1) -- Não mecha.

elseif getPlayerLevel(cid) <= level then -- Não mecha
doPlayerSendTextMessage(cid,25,"Você precisa ser level "..level.." ou mais.") -- Mensagem que ira aparecer se o player tiver menos level que o necessario.

elseif getPlayerStorageValue(cid,storage) >= 1 then -- Não mecha.
doPlayerSendTextMessage(cid,25,"Você já pegou.") -- Quando tentar pegar mais de uma vez o baú.
end
return true
end