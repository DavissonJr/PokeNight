-- Criado por Thalles Vitor --
local hide = g_ui.displayUI("hide")

function init()
  connect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })
end

function terminate()
  disconnect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })
end

function exibir()
end

function naoexibir()
end

function getHideBtn()
  return hide
end