function onUse(cid, item, frompos, item2, topos)

local cfg = {
awardId = 2148, -- Item ID of winner prize
awardAmount = 100, -- Amount of item ID
}

doPlayerAddItem(cfg.awardId, cfg.awardAmount)
doTeleportThing(getTownTemplePosition(getPlayerTown(cid)))
doPlayerSendTextMessage(cid, 27, "Obrigado pela sua Participacao vejo voce breve!")
return true
end