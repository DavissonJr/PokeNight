local t = {
    storage = 43534
}

function onLogout(cid)
    if getPlayerStorageValue(cid, t.storage) > os.time() then
	
	if getPlayerLanguage(cid) == 0 then
	doPlayerSendTextMessage(cid, 18, "Por motivos de segurança você precisa esperar "..getPlayerStorageValue(cid, t.storage) - os.time().. " segundos para poder deslogar.")
	end
	
	if getPlayerLanguage(cid) == 1 then
	doPlayerSendTextMessage(cid, 18, "Por razones de seguridad es necesario esperar "..getPlayerStorageValue(cid, t.storage) - os.time().. " segundos para salir.")
	end
	
	if getPlayerLanguage(cid) == 2 then
	doPlayerSendTextMessage(cid, 18, "For security reasons you need to wait "..getPlayerStorageValue(cid, t.storage) - os.time().. " seconds to logout.")
	end
	
    return false
    end
  return true
end