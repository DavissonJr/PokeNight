-- Criado por Thalles Vitor --
-- Sistema de TASK --

-- Opcodes - Cliente
local TASKWINDOW_SENDMISSION = 15 -- enviar que iniciei a missao
local TASKWINDOWCHANGECATEGORY = 16 -- enviar que mudei de categoria
local TASKWINDOWBUY_OPCODE = 17 -- enviar que quero comprar uma missao

function onExtendedOpcode(cid, opcode, buffer)
    if opcode == TASKWINDOW_SENDMISSION then
        local param = buffer:explode("@")
        local index = tonumber(param[1])
        local category = tostring(param[2])
        onStartMission(cid, index, category)
    end

    if opcode == TASKWINDOWCHANGECATEGORY then
        local param = buffer:explode("@")
        local category = tostring(param[1])

        onSendTaskWindow(cid, category)
    end

    if opcode == TASKWINDOWBUY_OPCODE then
        local param = buffer:explode("@")
        local index = tonumber(param[1])
        local category = tostring(param[2])

        onSendBuyTask(cid, index, category)
    end
    return true
end