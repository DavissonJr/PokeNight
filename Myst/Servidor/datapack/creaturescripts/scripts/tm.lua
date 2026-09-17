-- [
    --~~ Thalles Vitor ~~--
	--~~ Troca ou Revenda é proibido ~~--
--]

function onExtendedOpcode(cid, opcode, buffer)
    if opcode == 130 then
        initTmSystem(cid)
    end
    return true
end