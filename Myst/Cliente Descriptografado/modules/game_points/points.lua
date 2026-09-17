-- Criado por Thalles Vitor --
-- Sistema de Transf. de Pontos --
local points = g_ui.displayUI("points")
local pontos = points:getChildById("pontos")
local pointsScrollBar = points:getChildById("pointsScrollBar")
local startTrade = points:getChildById("startTrade")
local nome = points:getChildById("nome")
local pointsLabel = points:getChildById("pointsLabel")

-- Opcodes Cliente
local pointsSendBackInfos = 198 -- enviar para o servidor que ele tem que me enviar de volta a opcode de informacoes

-- Opcodes Servidor
local pointsWindowInfoOPCODE = 198 -- receber as infos da janela de points

function init()
    connect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })

    points:hide()
end

function terminate()
    disconnect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })

    points:hide()
end

function exibir()
    if points:isVisible() then
        points:hide()
    else
        points:show()
        pointsScrollBar:setMinimum(1)

        g_game.getProtocolGame():sendExtendedOpcode(pointsSendBackInfos, "receive".."@")
    end
end

function naoexibir()
    points:hide()
end

ProtocolGame.registerExtendedOpcode(pointsWindowInfoOPCODE, function(protocol, opcode, buffer) -- receive Infos of Points
    local param = buffer:explode("@")
    local points = tonumber(param[1])

    pointsScrollBar:setMaximum(points)
    pontos:setText(points)

    nome.onTextChange = function(self, value)
        if #value <= 0 then
            startTrade:setOpacity(0.60)
            startTrade.onClick = function() end
            return true
        end

        startTrade:setOpacity(100)
        startTrade.onClick = function() 
            g_game.getProtocolGame():sendExtendedOpcode(pointsSendBackInfos, "trade".."@"..nome:getText().."@"..pointsScrollBar:getValue().."@")
            nome:setText("")
        end -- send opcode to start trade
    end

    pointsScrollBar.onValueChange = function(self, value)
        pointsLabel:setText(value)
    end
end)

function addPoint()
    pointsScrollBar:setValue(pointsScrollBar:getValue() + 1)
    pointsLabel:setText(pointsScrollBar:getValue())
end

function removePoint()
    pointsScrollBar:setValue(pointsScrollBar:getValue() - 1)
    pointsLabel:setText(pointsScrollBar:getValue())
end