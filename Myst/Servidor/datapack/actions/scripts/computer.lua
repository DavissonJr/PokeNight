function onUse(cid, item, frompos, item2, topos)

   if getPlayerStorageValue(cid, 17001) > 0 or getPlayerStorageValue(cid, 17000) > 0 or getPlayerStorageValue(cid, 63215) > 0 then
   if getPlayerLanguage(cid) == 0 then
	doPlayerSendCancel(cid, "Voce nao pode se desbugar em fly, ride ou surf.")
	end
	
	if getPlayerLanguage(cid) == 2 then
	doPlayerSendCancel(cid, "You can not logout in special situations.")
	end
	
	if getPlayerLanguage(cid) == 1 then
	doPlayerSendCancel(cid, "No se puede cerrar la sesión en situaciones especiales.")
	end
   return true
   end

	message = "Computador: pronto. Agora você está desbugado"
	doCreatureSay(cid, message, 19)
	doRemoveCondition(cid, CONDITION_OUTFIT) 
	doRegainSpeed(cid)
	setPlayerStorageValue(cid, 243656, 0)

return true
end