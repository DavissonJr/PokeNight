function onSay(cid, words, param)
local onde = {x =1037,y =1036,z =7} --Pra onde o Player vai ao dizer o comando ?.
local exausted = getPlayerStorageValue(cid,985433) -- Storange que o player ganha, sÃ³ mexa se tiver sendo usada por outro .script seu
local agora = os.time()
local tempo = 1 -- Quanta horas ele vai usar o comando novamente ? ali estÃ¡ 2 = 2 horas.
local config = tempo * (15.60)
local somatempo = agora + config

if getPlayerStorageValue(cid, 1339) >= 1 or getPlayerStorageValue(cid, 1338) - os.time() > 0 then
    doBroadcastMessage(getCreatureName(cid) .. " está tentando fugir da prisão.")
    doPlayerSendTextMessage(cid, 25, "Um foragido não pode fugir da prisão.")
    return true
end

if getPlayerStorageValue(cid, 17000) >= 1 then
    setPlayerStorageValue(cid, 17000, 0)
    doRemoveCondition(cid, CONDITION_OUTFIT)
end

if getPlayerStorageValue(cid, 17001) >= 1 then
    setPlayerStorageValue(cid, 17001, 0)
    doRemoveCondition(cid, CONDITION_OUTFIT)
end

if getPlayerStorageValue(cid, 63215) >= 1 then
    setPlayerStorageValue(cid, 63215, 0)
    doRemoveCondition(cid, CONDITION_OUTFIT)
end

-- Thalles Vitor - Fly Module
doSendPlayerExtendedOpcode(cid, 244, "close".."@")

if exausted > agora then  
doPlayerSendTextMessage(cid,25,"Voce precisa esperar 15 minutos para digitar o comando novamente!") -- Mensagem que vai aparecer ao player, quando tenta usar o comando novamente ? 25 Ã© a cor da mensagem.
return true
end
if exausted <= agora then
doPlayerSendTextMessage(cid,25,"Personagem Desbugado!") -- Mensagem que vai aparecer ao player, quando  usar o comando ?.
setPlayerStorageValue(cid,985433,somatempo)
doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
doPlayerSetStamina(cid, 42 * 60 * 1000)
doSendMagicEffect(getCreaturePosition(cid),21) -- 21 Ã© o efeito vocÃª escolhe outro se quiser...

doRegainSpeed(cid)
return true
end
end