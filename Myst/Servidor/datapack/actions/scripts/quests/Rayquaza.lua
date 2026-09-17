local btype = "normal"
local pokemon = "Beldum"
local pokemon2 = "Absol"
 local storage = 243243
 
 
function onUse(cid, item, frompos, item2, topos)
if tonumber(getPlayerStorageValue(cid, 54893)) >= 1 then
    if tonumber(getPlayerStorageValue(cid, storage)) <= 0 then
        addPokeToPlayer(cid, pokemon, 0, nil, btype)
        addPokeToPlayer(cid, pokemon2, 0, nil, btype)
        doPlayerAddItem(cid, 2365)
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você terminou a Quest Rayquaza!")
        doSendMagicEffect(getThingPos(cid), 29)
        doSendMagicEffect(getThingPos(cid), 27)
        doSendMagicEffect(getThingPos(cid), 29)
        setPlayerStorageValue(cid, storage, 1)
    else
        doPlayerSendTextMessage(cid, 25, "Você já fez está quest.")
    end

    return true
else
    doPlayerSendTextMessage(cid, 25, "Você não clicou na porta ainda.")
end
return true
end