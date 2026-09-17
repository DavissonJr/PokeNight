-- [
    --~~ Thalles Vitor ~~--
	--~~ Troca ou Revenda é proibido ~~--
--]

function onExtendedOpcode(cid, opcode, buffer)
    if opcode == 134 then
        sendTMAvaiables(cid, "specialParam")
    end
    return true
end