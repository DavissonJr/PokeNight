local config = {
	idleWarning = getConfigValue('idleWarningTime'),
	idleKick = getConfigValue('idleKickTime')
}


local onlineRewardStorage = 12302
function onThink(cid, interval)
if not isCreature(cid) then return true end

if(getTileInfo(getCreaturePosition(cid)).nologout or getCreatureNoMove(cid) or getPlayerCustomFlagValue(cid, PLAYERCUSTOMFLAG_ALLOWIDLE)) then
   return true
end

local idleTime = getPlayerIdleTime(cid) + interval
doPlayerSetIdleTime(cid, idleTime)

local storageS = tonumber(getPlayerStorageValue(cid, onlineRewardStorage)) or 0
if storageS <= 0 then storageS = 0 end
setPlayerStorageValue(cid, onlineRewardStorage, storageS+1)

if(config.idleKick > 0 and idleTime > config.idleKick) then
   doRemoveCreature(cid)
elseif(config.idleWarning > 0 and idleTime == config.idleWarning) then
   local message = "Você tem sido ocioso por " .. math.ceil(config.idleWarning / 60000) .. " minutos"
   if(config.idleKick > 0) then
      message = message .. ", você vai ser desconectado em "
	  doPlayerSave(cid, true)
      local diff = math.ceil((config.idleWarning - config.idleKick) / 60000)
      if(diff > 1) then
         message = message .. diff .. " minutos"
      else
         message = message .. "1 minuto "
      end
      message = message .. ""
   end
   doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, message .. ".")
end
return true
end