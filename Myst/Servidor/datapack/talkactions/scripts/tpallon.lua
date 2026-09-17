function onSay(cid, words, param, channel)


    for _, cid in ipairs(getPlayersOnline()) do
        if(param == '') then
            doPlayerSendTextMessage(cid, 19, "Command requires parameters.")
        return 1
        end

local c = string.explode(param, ",")
        doTeleportThing(cid, { x = c[1], y = c[2], z = c[3] } )
        doSendMagicEffect(getCreaturePosition(cid), 19)
        doPlayerSendTextMessage(cid, 19, "All players were teleported.")
    end
return 1
end