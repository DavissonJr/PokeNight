-- [
    --~~ Thalles Vitor ~~--
	--~~ Troca ou Revenda ù proibido ~~--
--]

function onExtendedOpcode(cid, opcode, buffer)
    if opcode == 135 then
        local param = buffer:explode("@")
        local count = param[1]
        local movename = param[2]
        local movelevel = param[3]
        local movecooldown = param[4]

        sendTMChanges(cid, count, movename, movelevel, movecooldown)
    end
    return true
end