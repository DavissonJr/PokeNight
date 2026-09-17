-- Criado por Thalles Vitor --
-- Sistema de Janela de Addon --

-- Opcodes - Cliente
local addonWINDOWSEND_OPCODE = 26
local addonWINDOWSENDCHANGE_OPCODE = 27

function onExtendedOpcode(cid, opcode, buffer)
    if opcode == addonWINDOWSEND_OPCODE then
        onSendAddonWindow(cid)
    end

    if opcode == addonWINDOWSENDCHANGE_OPCODE then
        local param = buffer:explode("@")
        local addon = tostring(param[1])

        onChangeAddon(cid, addon)
    end
    return true
end