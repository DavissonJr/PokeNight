function onLogout(cid)
   if getPlayerStorageValue(cid, 17001) > 0 or getPlayerStorageValue(cid, 17000) > 0 or getPlayerStorageValue(cid, 63215) > 0 then
   if getPlayerLanguage(cid) == 0 then
	doPlayerSendCancel(cid, "Você não pode deslogar em situações especiais.")
	end
	
	if getPlayerLanguage(cid) == 2 then
	doPlayerSendCancel(cid, "You can not logout in special situations.")
	end
	
	if getPlayerLanguage(cid) == 1 then
	doPlayerSendCancel(cid, "No se puede cerrar la sesión en situaciones especiales.")
	end
   return false
   end
  return true
end