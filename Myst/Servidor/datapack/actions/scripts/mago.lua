-- Criado por Thalles Vitor --
-- Mago Outfit --
local outfit = 2092

function onUse(cid, item, fromPosition, itemEx, toPosition)
	setPlayerStorageValue(cid, 44230, 2)
	doPlayerSendTextMessage(cid, 25, "Desbloqueou a outfit mago!")
	doPlayerAddOutfit(cid, outfit, 1)
	doPlayerAddOutfit(cid, outfit, 2)

	doRemoveItem(item.uid, 1)
	return true
end