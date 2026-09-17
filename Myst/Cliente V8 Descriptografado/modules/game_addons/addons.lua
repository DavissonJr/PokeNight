-- Criado por Thalles Vitor --
-- Sistema de Janela de Addons --
local addons = g_ui.displayUI("addons")
local pokemonAddon = addons:getChildById("pokemonAddon")
local addonName = addons:getChildById("addonName")

-- Variables --
  local outfitTable = {}
  outfitTable.outfit = {}
  outfitTable.name = {}
  outfitTable.color = {}

  next = 0
  prev = 0
--

-- Opcodes - Servidor
local addonWINDOW_OPCODE = 25
local ADDONWINDOW_OPCODEHIDE = 26

-- Opcodes - Cliente
local addonWINDOWSEND_OPCODE = 26
local addonWINDOWSENDCHANGE_OPCODE = 27

function init()
  connect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  addons:hide()
end

function terminate()
  disconnect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  addons:hide()
end

function exibir()
  if not g_game.isOnline() then
    return true
  end

  for i = 1, #outfitTable.outfit do
    outfitTable.outfit[i] = nil
    outfitTable.name[i] = nil
    outfitTable.color[i] = nil
  end

  g_game.getProtocolGame():sendExtendedOpcode(addonWINDOWSEND_OPCODE)
end

function naoexibir()
  addons:hide()
end

function changeAddon()
  addons:hide()

  if not g_game.isOnline() then
    return true
  end

  g_game.getProtocolGame():sendExtendedOpcode(addonWINDOWSENDCHANGE_OPCODE, addonName:getText().."@")
end

function nextOutfit()
  if next >= #outfitTable.outfit then
    next = 0
  end

  prev = 1
  next = next + 1

  pokemonAddon:setOutfit({type = outfitTable.outfit[next]})
  addonName:setText(outfitTable.name[next])
  addonName:setColor(outfitTable.color[next])
end

function previousOutfit()
  next = 1

  if prev > 1 then
    prev = prev - 1
  else
    prev = #outfitTable.outfit
  end

  pokemonAddon:setOutfit({type = outfitTable.outfit[prev]})
  addonName:setText(outfitTable.name[prev])
  addonName:setColor(outfitTable.color[prev])
end

ProtocolGame.registerExtendedOpcode(addonWINDOW_OPCODE, function(protocol, opcode, buffer) -- receive outfits addon
  local param = buffer:explode("@")
  local name = tostring(param[1])
  local looktype = tonumber(param[2])
  local color = tostring(param[3])

  addons:show()
  table.insert(outfitTable.outfit, looktype)
  table.insert(outfitTable.name, name)
  table.insert(outfitTable.color, color)

  pokemonAddon:setOutfit({type = looktype})
  addonName:setText(name)
  addonName:setColor(color)

  prev = #outfitTable.name
end)

ProtocolGame.registerExtendedOpcode(ADDONWINDOW_OPCODEHIDE, function(protocol, opcode, buffer) -- hide addon window
  local param = buffer:explode("@")
  addons:hide()
end)