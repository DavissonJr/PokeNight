-- Criado por Thalles Vitor --
-- Sistema de Up e Down --
local fly = g_ui.displayUI("fly")
local flyOpcode = 244 -- opcode do fly

function init()
    connect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd,
    })

    fly:hide()
end

function terminate()
    disconnect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd,
    })

    ProtocolGame.unregisterExtendedOpcode(flyOpcode)
    fly:hide()
end

function onGameStart()
end

function onGameEnd()
    fly:hide()
end

ProtocolGame.registerExtendedOpcode(flyOpcode, function(protocol, opcode, buffer)
    local param = buffer:split("@")
    local typee = tostring(param[1])

    if typee == "open" then
        fly:show()
    else
        fly:hide()
    end
end)