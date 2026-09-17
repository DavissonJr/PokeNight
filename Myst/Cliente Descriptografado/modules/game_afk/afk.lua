-- Criado por Thalles Vitor --
-- AFK SYSTEM WINDOW --
local afk = g_ui.displayUI("afk")
local text_numero = afk:getChildById("text_numero")
local numero_text = afk:getChildById("numero_text")
local confirmar_btn = afk:getChildById("confirmar_btn")
globalValue = 0

function init()
  connect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  afk:hide()
end

function terminate()
  disconnect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  afk:hide()
end

function exibir()
  afk:show()
end

function naoexibir()
  afk:hide()
end

function btn()
   if tonumber(numero_text:getText()) ~= globalValue then
    displayErrorBox(tr('Codigo Invalido'), "Digite um codigo valido")
  else
    g_game.getProtocolGame():sendExtendedOpcode(78, 'deslogar'.."@")
    afk:hide()
  end
end

ProtocolGame.registerExtendedOpcode(77, function(protocol, opcode, buffer) -- receive afk window
  local param = buffer:split("@")
  local random_code = tonumber(param[1])

  afk:show()
  text_numero:setText("Digite o numero: "..random_code.." na caixa de texto abaixo para nao ser deslogado")
  
  globalValue = random_code
end)