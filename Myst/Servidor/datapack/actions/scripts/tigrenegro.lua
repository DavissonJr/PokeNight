local strgs = {17000, 17001} -- Coloque a Storage de Controle dos Sistemas Que Deseja Bloquear.
local config = {
    outfitMale = 2985, -- Outfit male
    outfitFemale = 2986, -- Outfit female
    storageValue = 320021, -- Storage Para a bike
}
 
function onUse(cid, item, itemEx, fromPosition, toPosition)

	 	if getPlayerStorageValue(cid, 63215) >= 1 then
	doPlayerSendCancel(cid, "Voce nao pode usar a bike enquanto surfa.")
		return false
	 end
	 
    ctrl = 0
    for x = 1, #strgs do
        if getPlayerStorageValue(cid, strgs[x]) > 0 then
            ctrl = ctrl + 1
        end
    end
    if ctrl < 1 then
        if isPlayer(cid) and getCreatureOutfit(cid).lookType == 814 then
            return false
        end
		
		if getPlayerStorageValue(cid, 92001) >= 1 then
        doPlayerSendCancel(cid, "Voce nao pode usar bike e robo ao mesmo tempo.")
		return false
end

		if getPlayerStorageValue(cid, 92002) >= 1 then
        doPlayerSendCancel(cid, "Voce nao pode usar bike e robo ao mesmo tempo.")
		return false
end

		if getPlayerStorageValue(cid, 92003) >= 1 then
        doPlayerSendCancel(cid, "Voce nao pode usar bike e robo ao mesmo tempo.")
		return false
end

		if getPlayerStorageValue(cid, 92004) >= 1 then
        doPlayerSendCancel(cid, "Voce nao pode usar bike e robo ao mesmo tempo.")
		return false
end

		if getPlayerStorageValue(cid, 92005) >= 1 then
        doPlayerSendCancel(cid, "Voce nao pode usar bike e robo ao mesmo tempo.")
		return false
end


		
if getPlayerStorageValue(cid, 19000) == 1 then
        doPlayerSendCancel(cid, "Voce nao pode usar bike e correr ao mesmo tempo.")
		return false
end
        if getPlayerStorageValue(cid, config.storageValue) <= 0 then
            local a = {lookType = config.outfitMale, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}
            local b = {lookType = config.outfitFemale, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}
            setPlayerStorageValue(cid, 32001, ""..getPlayerStamina(cid).."")
			doChangeSpeed(cid, 1 * 600)
            setPlayerStorageValue(cid, config.storageValue, 1)        
            if getPlayerSex(cid) == 0 then
                doSetCreatureOutfit(cid, b, -1)
            else
                doSetCreatureOutfit(cid, a, -1)
            end
        else
            setPlayerStorageValue(cid, config.storageValue, 0)
            doRemoveCondition(cid, CONDITION_OUTFIT)
			doRegainSpeed(cid)
        end
    else
        doPlayerSendCancel(cid, "Voce nao pode usar bike enquanto esta no Fly/Hide.")
    end
return true
end