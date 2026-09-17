local config = {
       
        doorPosition = {x = 1935, y = 1549, z = 8},  
        doorID = 1355,
        minAccess = 1,
        seconds_time = 10, -- / * New * /
        message = {
                doorOpen = "",
                doorClose = ""
        }
}
 
local function closeDoor(cid)
       
        doCreateItem(config.doorID, 1, config.doorPosition)
        doBroadcastMessage(cid, 180, config.message.doorClose)
        return true
end
 
function onSay(cid, words, param)
        if getPlayerAccess(cid) >= config.minAccess then
               
                local item = getTileItemById(config.doorPosition, config.doorID)
               
                if item.uid > 0 then
                       
                        doRemoveItem(item.uid, 1)
                        doBroadcastMessage(cid, 180, config.message.doorOpen)
                        addEvent(closeDoor, config.seconds_time * 1000, cid)
                end
        end
        return true
end