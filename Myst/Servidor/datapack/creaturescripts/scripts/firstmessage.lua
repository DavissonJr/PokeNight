function onLogin(cid)
local storage = 564563453
if getPlayerStorageValue(cid, storage) == -1 then
doPlayerSendOutfitWindow(cid)
doPlayerSendTextMessage(cid, 26, "Sua aventura se inicia aqui, boa sorte treinador!")
setPlayerStorageValue(cid, storage, 1)
end
return true
end