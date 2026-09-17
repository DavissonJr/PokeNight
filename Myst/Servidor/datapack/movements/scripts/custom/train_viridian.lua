-- Train System 1.0 by Dino
local m = {
        storage = 4590, -- Celadon
	place1 = { x = 1259, y = 1249, z = 6}, -- Aqui é a Pos pra onde o trem te leva
        cancel = "You need to buy a ticket for travel on the train.", -- Mensaje para abortar
        success = "Welcome, please stay in place while you reach the desired location.", -- Mensaje para abortar
	place = { x = 1156, y = 1351, z = 8} -- Aqui é a Pos do TREM
}

function tp(cid) 
     doSendMagicEffect(getThingPos(cid),66)
          setPlayerStorageValue(cid, m.storage, -1)       
         return true
    end

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
		if (getCreatureStorage(cid, m.storage) == 1) == TRUE then
			doTeleportThing(cid, m.place)
            addEvent(tp, 15000)
			addEvent(doTeleportThing, 15000, cid, m.place1)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, m.success)
			doPlayerSendTextMessage(cid,25,"You're currently traveling to celadon")
			setPlayerStorageValue(cid, m.storage, -1)
		elseif (getCreatureStorage(cid, m.storage) == 1) == FALSE then
				doTeleportThing(cid, fromPosition)
				doPlayerSendCancel(cid, m.cancel)
		end
	return true
end