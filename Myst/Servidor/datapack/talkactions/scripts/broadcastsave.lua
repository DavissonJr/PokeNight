function onSay(cid, words, param)

local stor = "pos_broad"

    if tostring(param) == "delete" then
      return doPlayerSendTextMessage(cid, 27, "Mensagem: [ "..getGlobalStorageValue(stor).." ] deletada") and setGlobalStorageValue(stor, -1)
    end
  
setGlobalStorageValue(stor, tostring(param))
doPlayerSendTextMessage(cid, 27, "Voce definiu a broadcast como: [ "..param.." ]")

 return true
end 