local lukasfodao = {
	poke = "Piplup",
	ball = "normal",
	storage = 453454,
	pos = {x = 1037, y = 1036, z = 7}

}

function onStepIn(cid, item, frompos, item2, topos)
	if not isPlayer(cid) then
		return true
	end

	if getPlayerStorageValue(cid, lukasfodao.storage) <= 0 then
		addPokeToPlayer(cid, lukasfodao.poke, 0, gender, lukasfodao.ball)
		doPlayerAddItem(cid, 2392, 20) 
		doPlayerAddItem(cid, 2152, 10) 
		doPlayerAddItem(cid, 12346, 20)
		doPlayerAddLevel(cid,7)
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Pronto, agora você já está pronto para começar sua jornada.")
		doPlayerSendTextMessage(cid, 22, lukasfodao.poke)
		doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
		doSendMagicEffect(getThingPos(cid), 21)
		setPlayerStorageValue(cid, lukasfodao.storage, 1)
	else
		doTeleportThing(cid, frompos)
		doPlayerSendCancel(cid, "Você já pegou seu pokémon inicial :)")
	end
	return true
end