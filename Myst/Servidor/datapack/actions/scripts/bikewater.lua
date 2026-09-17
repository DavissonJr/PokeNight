-- { Autor: Lucas Rafaeel }
-- { Version: 1.0 }

local config =
{
    velocidadeDaSuaBike = 2500, -- Velocidade da bike coloquei igual o do OtPokemon 
    outfitMale = 2032, -- Outfit MALE
    outfitFemale = 2031, -- Outfit FEMALE
    storageValue = 243656, -- Nï¿½o mude
}
 
function onUse(cid, item, itemEx, fromPosition, toPosition)
	if item.uid ~= getPlayerSlotItem(cid, CONST_SLOT_RING).uid then
		doPlayerSendCancel(cid, "Você deve colocar sua bike no local correto.") -- Mensagem que da ao tentar usar a bike fora do slot (by: Lukas)
	    return true
    end

    if getPlayerStorageValue(cid, 17001) > 0 or getPlayerStorageValue(cid, 17000) > 0 or getPlayerStorageValue(cid, 63215) > 0 then
        doPlayerSendCancel(cid, "Você não pode usar bike em situações especiais.")
        return true
    end
 
    if getPlayerStorageValue(cid, config.storageValue) <= 0 then
        local a = {lookType = config.outfitMale, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}
        local b = {lookType = config.outfitFemale, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}
            
        setPlayerStorageValue(cid, 3624, ""..getPlayerStamina(cid).."")
        doChangeSpeed(cid, -getCreatureSpeed(cid))
        doChangeSpeed(cid, config.velocidadeDaSuaBike)
        setPlayerStorageValue(cid, config.storageValue, 1)
        doItemSetAttribute(item.uid, "using", 1)    
        if getPlayerSex(cid) == 0 then
            doSetCreatureOutfit(cid, b, -1)
        else
            doSetCreatureOutfit(cid, a, -1)
        end

        setPlayerStorageValue(cid, 9937, getCreatureOutfit(cid).lookType)
    else
        setPlayerStorageValue(cid, config.storageValue, 0)
        doRemoveCondition(cid, CONDITION_OUTFIT)
        doRegainSpeedLevel(cid)
        doItemEraseAttribute(item.uid, "using")

        setPlayerStorageValue(cid, 9937, 0)
    end
    return true
end