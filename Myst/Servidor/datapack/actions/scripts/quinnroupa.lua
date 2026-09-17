local config =
{
    velocidadeDaSuaBike = 3100, -- A volocidade da bike (1-9)
    outfitMale = 2949, -- Outfit male
    outfitFemale = 2950, -- Outfit female
}
 
function onUse(cid, item, itemEx, fromPosition, toPosition)
if item.uid ~= getPlayerSlotItem(cid, CONST_SLOT_RING).uid then   ---Coloquei Slot RING pq nao sabia o nome do correto
doPlayerSendCancel(cid, "Voce deve colocar sua bike no local correto.") 
return TRUE
end
 
    if isPlayer(cid) and getCreatureOutfit(cid).lookType == 814 then return false end
        if getPlayerStorageValue(cid, config.storageValue) <= 0 then
            local a = {lookType = config.outfitMale, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}
            local b = {lookType = config.outfitFemale, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}
            setPlayerStorageValue(cid, 3624, ""..getPlayerStamina(cid).."")
            doSendMagicEffect(getThingPos(cid), 6)
            doChangeSpeed(cid, -getCreatureSpeed(cid))
            doChangeSpeed(cid, config.velocidadeDaSuaBike)
            setPlayerStorageValue(cid, config.storageValue, 1)        
            if getPlayerSex(cid) == 0 then
                doSetCreatureOutfit(cid, b, -1)
            else
                doSetCreatureOutfit(cid, a, -1)
            end
        else
            setPlayerStorageValue(cid, config.storageValue, 0)
            doSendMagicEffect(getThingPos(cid), 52)
            doRemoveCondition(cid, CONDITION_OUTFIT)
            doRegainSpeed(cid)
       end
    return true
end