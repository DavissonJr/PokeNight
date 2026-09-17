function onUse(cid, item, fromPosition, itemEx, toPosition)
if #getPlayersInArea(torneiokanto.areakanto) > 1 then
doPlayerSendTextMessage(cid, 26 ,"Você precisa derrotar todos os treinadores para vencer o torneio.") 
return true 
end

if getPlayerStorageValue(cid, 989) >= 1 then
	return true
end

doTeleportThing(cid, {x=getCreaturePosition(cid).x, y=getCreaturePosition(cid).y-5, z=getCreaturePosition(cid).z})
doBroadcastMessage("Parabéns ao treinador "..getCreatureName(cid).." foi o ganhador do torneio de hoje, verifique o RANK em nosso site: pokedragons.com!")
local atualPremioo = getGlobalStorageValue(5778415)
doPlayerAddMoney(cid, atualPremioo * 200000)
setGlobalStorageValue(5778415, -1)
doPlayerSendTextMessage(cid, 22, "Você avançou em torneios vencidos.")

local stor = tonumber(getPlayerStorageValue(cid, 22234)) or 0
setPlayerStorageValue(cid, 22234, stor+1)

local torneio = tonumber(getPlayerStorageValue(cid, 22234)) or 0
if torneio <= 0 then
	torneio = 0
end

doSendPlayerExtendedOpcode(cid, 103, torneio.."@")
setPlayerStorageValue(cid, 989, 1)
return true
end

