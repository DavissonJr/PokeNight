-- Criado por Thalles Vitor --
-- Sistema de Janela de Evolucao --

-- Opcodes - Servidor
local evolutionWINDOW_OPCODE = 23

local evolution = g_ui.displayUI("evolution")
local evolveText = evolution:getChildById("evolveText")
local portrait1 = evolution:getChildById("portrait1")
local portrait2 = evolution:getChildById("portrait2")
local needText = evolution:getChildById("needText")
local confirmEvolve = evolution:getChildById("confirmEvolve")

function init()
  connect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  evolution:hide()
end

function terminate()
  disconnect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  evolution:hide()
end

function exibir()
  evolution:show()
end

function naoexibir()
  evolution:hide()
end

ProtocolGame.registerExtendedOpcode(evolutionWINDOW_OPCODE, function(protocol, opcode, buffer) -- receive evolve window
  local param = buffer:explode("@")
  local portraitOne = tonumber(param[1])
  local portraitTwo = tonumber(param[2])
  local name = tostring(param[3])
  local name2 = tostring(param[4])
  local stoneText = tostring(param[5])
  local isTwoStone = tostring(param[6])

  if isTwoStone == "yes" then
    needText:setMarginLeft(110)
  else
    needText:setMarginLeft(145)
  end

  evolution:show()
  evolveText:setText("Você deseja evoluir o " .. name .. " para " .. name2 .. "?")
  portrait1:setItemId(portraitOne)
  portrait2:setItemId(portraitTwo)
  needText:setText(stoneText)

  confirmEvolve.onClick = function()
    if not g_game.isOnline() then
      return true
    end

    evolution:hide()
    g_game.getProtocolGame():sendExtendedOpcode(evolutionWINDOW_OPCODE, name.."@"..name2.."@")
  end
end)