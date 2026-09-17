-- Criado por Thalles Vitor --
-- Sistema de Pix --

local pix = g_ui.loadUI("pix", modules.game_shop.getShop())

function init()
  connect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  pix:hide()
end

function terminate()
  disconnect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  pix:hide()
end

function exibir()
  if pix:isVisible() then
    pix:hide()
  else
    pix:show()
  end
end

function naoexibir()
  pix:hide()
end