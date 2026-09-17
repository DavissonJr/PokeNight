function onUse(cid, item, fromPosition, itemEx, toPosition)
if #getPlayersInArea(torneiomary.areamary) > 1 then
doPlayerSendTextMessage(cid, 26 ,"Você precisa derrotar todos os treinadores para vencer o torneio")
return true 
end

if getCreaturePosition(cid).y ~= 1753 then
	return true
end

doTeleportThing(cid, {x=getCreaturePosition(cid).x, y=getCreaturePosition(cid).y-5, z=getCreaturePosition(cid).z})
doBroadcastMessage("Parabéns ao treinador "..getCreatureName(cid).." foi o ganhador do torneio de johto 150- de hoje, verifique o RANK em nosso site: pokesapphire.com!")
local atualPremioo = getGlobalStorageValue(844565)
local efe = getCreaturePosition(cid)
doPlayerAddMoney(cid, 200000)
doSendMagicEffect(efe, 241)
setGlobalStorageValue(844565, -1)

local stor = tonumber(getPlayerStorageValue(cid, 22234)) or 0
setPlayerStorageValue(cid, 22234, stor+1)

local torneio = tonumber(getPlayerStorageValue(cid, 22234)) or 0
if torneio <= 0 then
	torneio = 0
end

doSendPlayerExtendedOpcode(cid, 103, torneio.."@")
return true
end