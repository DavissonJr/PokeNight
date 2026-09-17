function onSay(cid, words, param)
local cfg = {

   		addon_name = "Santa Claus Addon", -- NOME DO ADDON 	
   		addon_male = 523, 
   		addon_female = 525,
   		storage = 9784 -- Lembre-se de trocar o numero da storage em cada item
}
		if getPlayerStorageValue(cid, cfg.storage) < 1 then
			doPlayerAddOutfit(cid, cfg.addon_male, 1)
			doPlayerAddOutfit(cid, cfg.addon_female, 1)
			doSendMagicEffect(getThingPos(cid), 29)
			doPlayerSendTextMessage(cid, 19, "Addon " .. cfg.addon_name .. " adicionado!")
			setPlayerStorageValue(cid, cfg.storage, 1)
		else
			doPlayerSendTextMessage(cid, 19, "you already have this addon.")
		end
 
   return true
end