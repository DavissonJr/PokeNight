-- Criado por Thalles Vitor --
-- Sistema de Janela de Pontos --

function onExtendedOpcode(cid, opcode, buffer)
    if opcode == 198 then
        local param = buffer:explode("@")
        local typee = tostring(param[1])

        if typee == "receive" then
            sendPointsWindow(cid)
        elseif typee == "trade" then
            sendPoints(cid, tostring(param[2]), tonumber(param[3]))
        end
    end
    return true
end