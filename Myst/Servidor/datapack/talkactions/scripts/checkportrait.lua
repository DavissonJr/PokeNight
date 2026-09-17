function onSay(cid, words, param)
	if getPlayerSlotItem(cid, CONST_SLOT_FEET).uid == 0 then
		if getPlayerItemCount(cid, 2395) == 0 then
	doPlayerAddItem(cid, 2395, 1)
					doPlayerSendCancel(cid, "Sua portrait foi desbugada!")
	else
				doPlayerSendCancel(cid, "Voce ja tem uma portrait!")
	end
	else
			doPlayerSendCancel(cid, "Retire sua pokeball do Slot de usar o Pokemon e tente novamente!")
	end
	
	return true
end