function onSay(cid, words, param)

if exhaustion.check(cid, 2123) then

doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você precisa esperar para enviar outra sugestão.")

return true

end

if #param <= 10 then

doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Sua sugestão precisa pelo menos ter 10 letras.")

return true

end

local file = io.open("./datapack/logs/sug/sugestões.txt", "a")

file:write("\n"..getPlayerName(cid)..": deu uma sugestão ("..param..")")

file:close()

setGlobalStorageValue(28212, getGlobalStorageValue(28212)+1)

exhaustion.set(cid, 2123, 36000)

doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Sua sugestão foi enviada com sucesso, obrigado pela colaboração!")

for _, id in ipairs(getPlayersOnline()) do

if getPlayerGroupId(cid) > 5 then

exhaustion.set(cid, 2123, 36000)

return true

end

return true

end

end
