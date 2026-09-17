function onUse(cid, item, frompos, item2, topos)
local cfg = {

   		addon_name = "Obeso", -- NOME DO ADDON 	
   		addon_male = 523, 
   		addon_female = 525,
   		storage = 35423 -- Lembre-se de trocar o numero da storage em cada item
}
		if getPlayerStorageValue(cid, cfg.storage) < 1 then
			doPlayerAddOutfit(cid, cfg.addon_male, 1)
			doPlayerAddOutfit(cid, cfg.addon_female, 1)
			doSendMagicEffect(getThingPos(cid), 29)
			doPlayerSendTextMessage(cid, 19, "Você ganhou um addon Santa Claus, na sua outifit Obeso(a)!")
			doRemoveItem(item.uid, 1)
			setPlayerStorageValue(cid, cfg.storage, 1)
		else
			doPlayerSendTextMessage(cid, 19, "Você já tem esse addon.")
		end
 
   return true
end