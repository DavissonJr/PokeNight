-- Criado por Thalles Vitor --
-- Sistema de Pokedex --
local pokedex = g_ui.displayUI("pokedex")
local pokemon = pokedex:getChildById("pokemon")
local informations = pokedex:getChildById("informations")
local name = pokedex:getChildById("pokemonName")
local pokemonPanel = pokedex:getChildById("pokemonPanel")
local pokemonsPanel = pokedex:getChildById("pokemonsPanel")
local pokemonNumber = pokedex:getChildById("pokemonNumber")
local element1 = pokedex:getChildById("element1")
local element2 = pokedex:getChildById("element2")

local evolve1 = pokedex:getChildById("evolve1")
local evolve2 = pokedex:getChildById("evolve2")
local evolve3 = pokedex:getChildById("evolve3")
local evolve4 = pokedex:getChildById("evolve4")
local evolve5 = pokedex:getChildById("evolve5")
local evolve6 = pokedex:getChildById("evolve6")

local informationsPokemon = pokemonsPanel:getChildById("informationsPokemon")
local habilitiesPokemon = pokemonsPanel:getChildById("habilitiesPokemon")
local typesPokemon = pokemonsPanel:getChildById("typesPokemon")

local habilitiesTab = pokedex:getChildById("habilitiesTab")
local habilitiesTabPanel = pokedex:getChildById("habilitiesTabPanel")
local habilitiesScrollBar = pokedex:getChildById("habilitiesScrollBar")

local weakLabel = pokedex:getChildById("weakLabel")
local weakPanel = pokedex:getChildById("weakPanel")

local superLabel = pokedex:getChildById("superLabel")
local superPanel = pokedex:getChildById("superPanel")

-- Opcodes - Servidor
local pokedex_DESTROYOPCODE = 32 -- receber do servidor que ele tem que destruir os panels
local pokedexOPCODE = 33 -- receber do servidor a opcode do pokemon que recebeu dex
local pokedexEVOLVESOPCODE = 34 -- receber as evolucoes do servidor
local pokedexMOVESOPCODE = 35 -- receber moves dos pokemons
local pokedexTYPESOPCODE = 36 -- receber types dos pokemons

function init()
  connect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  pokedex:hide()
end

function terminate()
  disconnect(g_game, {
    onGameStart = exibir,
    onGameEnd = naoexibir
  })
  
  pokedex:hide()
end

function exibir()
  pokedex:hide()
end

function naoexibir()
  pokedex:hide()
end

ProtocolGame.registerExtendedOpcode(pokedexOPCODE, function(protocol, opcode, buffer)
  local param = buffer:explode("@")
  local pokemonName = tostring(param[1])
  local pokemonOutfit = tonumber(param[2])
  local number = tostring(param[3])
  local desc = tostring(param[4])
  local elementOne = tostring(param[5])
  local elementTwo = tostring(param[6])

  pokedex:show()

  changeCategory("informations")
  name:setText(pokemonName)
  pokemonNumber:setText(number)

  local pokemonDesc = g_ui.createWidget("Label", pokemonPanel)
  pokemonDesc:setColor("white")
  pokemonDesc:setTextAutoResize("true")
  pokemonDesc:addAnchor(AnchorLeft, "parent", AnchorLeft)
  pokemonDesc:addAnchor(AnchorTop, "parent", AnchorTop)
  pokemonDesc:setText(desc)

  element1:setImageSource("")
  element2:setImageSource("")

  if string.lower(elementOne) ~= "none" and string.lower(elementOne) ~= "no type" then
    element1:setImageSource("images/elements/" .. string.lower(elementOne) .. ".png")
    element1:setTooltip(elementOne)
  end
  
  if string.lower(elementTwo) ~= "none" and string.lower(elementTwo) ~= "no type" then
    element2:setImageSource("images/elements/" .. string.lower(elementTwo) .. ".png")
    element2:setTooltip(elementTwo)
  end

  evolve1:setOutfit({type = 0})
  evolve2:setOutfit({type = 0})
  evolve3:setOutfit({type = 0})
  evolve4:setOutfit({type = 0})
  evolve5:setOutfit({type = 0})
  evolve6:setOutfit({type = 0})

  evolve1:setTooltip("")
  evolve2:setTooltip("")
  evolve3:setTooltip("")
  evolve4:setTooltip("")
  evolve5:setTooltip("")
  evolve6:setTooltip("")

  pokemon:setOutfit({type = pokemonOutfit})
end)

ProtocolGame.registerExtendedOpcode(pokedex_DESTROYOPCODE, function(protocol, opcode, buffer)
  local param = buffer:explode("@")
  pokemonPanel:destroyChildren()
  habilitiesTabPanel:destroyChildren()
  weakPanel:destroyChildren()
  superPanel:destroyChildren()
end)

ProtocolGame.registerExtendedOpcode(pokedexEVOLVESOPCODE, function(protocol, opcode, buffer)
  local param = buffer:explode("@")
  local name = tostring(param[1])
  local outfit = tonumber(param[2])
  local count = tonumber(param[3])
  
  if pokedex:getChildById("evolve" .. count) then
    pokedex:getChildById("evolve" .. count):setOutfit({type = outfit})
    pokedex:getChildById("evolve" .. count):setTooltip(name)
  end
end)

ProtocolGame.registerExtendedOpcode(pokedexMOVESOPCODE, function(protocol, opcode, buffer)
  local param = buffer:explode("@")
  local number = tonumber(param[1])
  local element = tostring(param[2])
  local name = tostring(param[3])
  local power = tonumber(param[4])
  local energy = 0
  local level = tonumber(param[5])
  local cooldown = tonumber(param[6])
  local distance = tonumber(param[7])

  local tab = g_ui.createWidget("UIButton", habilitiesTabPanel)
  tab:setSize("447 44")
  --tab:setBackgroundColor("black")

  local label = g_ui.createWidget("Label", tab)
  label:addAnchor(AnchorTop, "parent", AnchorTop)
  label:addAnchor(AnchorLeft, "parent", AnchorLeft)
  label:setTextAutoResize("true")
  label:setColor("white")
  label:setFont("terminus-10px")
  label:setMarginLeft(12)
  label:setMarginTop(9)
  label:setText(number)

  local photoType = g_ui.createWidget("UIButton", tab)
  photoType:addAnchor(AnchorTop, "parent", AnchorTop)
  photoType:addAnchor(AnchorLeft, "parent", AnchorLeft)
  photoType:setSize("32 32")
  photoType:setTooltip(element)
  photoType:setImageSource("images/elements/" .. string.lower(element) .. ".png")
  photoType:setMarginLeft(31)

  local nameAttack = g_ui.createWidget("Label", tab)
  nameAttack:addAnchor(AnchorTop, "parent", AnchorTop)
  nameAttack:addAnchor(AnchorLeft, "parent", AnchorLeft)
  nameAttack:setTextAutoResize("true")
  nameAttack:setColor("white")
  nameAttack:setFont("terminus-10px")
  nameAttack:setMarginLeft(85)
  nameAttack:setMarginTop(9)
  nameAttack:setText(name)

  local categoryType = g_ui.createWidget("UIButton", tab)
  categoryType:addAnchor(AnchorTop, "parent", AnchorTop)
  categoryType:addAnchor(AnchorLeft, "parent", AnchorLeft)
  categoryType:setSize("32 32")
  categoryType:setTooltip(element)
  categoryType:setImageSource("images/elements/" .. string.lower(element) .. ".png")
  categoryType:setMarginLeft(165)

  local powerLabel = g_ui.createWidget("Label", tab)
  powerLabel:addAnchor(AnchorTop, "parent", AnchorTop)
  powerLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
  powerLabel:setTextAutoResize("true")
  powerLabel:setColor("white")
  powerLabel:setFont("terminus-10px")
  powerLabel:setMarginLeft(229)
  powerLabel:setMarginTop(9)
  powerLabel:setText(power)

  local energyLabel = g_ui.createWidget("Label", tab)
  energyLabel:addAnchor(AnchorTop, "parent", AnchorTop)
  energyLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
  energyLabel:setTextAutoResize("true")
  energyLabel:setColor("white")
  energyLabel:setFont("terminus-10px")
  energyLabel:setMarginLeft(279)
  energyLabel:setMarginTop(9)
  energyLabel:setText(energy)

  local levelLabel = g_ui.createWidget("Label", tab)
  levelLabel:addAnchor(AnchorTop, "parent", AnchorTop)
  levelLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
  levelLabel:setTextAutoResize("true")
  levelLabel:setColor("white")
  levelLabel:setFont("terminus-10px")
  levelLabel:setMarginLeft(322)
  levelLabel:setMarginTop(9)
  levelLabel:setText(level)

  local timeLabel = g_ui.createWidget("Label", tab)
  timeLabel:addAnchor(AnchorTop, "parent", AnchorTop)
  timeLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
  timeLabel:setTextAutoResize("true")
  timeLabel:setColor("white")
  timeLabel:setFont("terminus-10px")
  timeLabel:setMarginLeft(362)
  timeLabel:setMarginTop(9)
  timeLabel:setText(cooldown)

  local distanceLabel = g_ui.createWidget("Label", tab)
  distanceLabel:addAnchor(AnchorTop, "parent", AnchorTop)
  distanceLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
  distanceLabel:setTextAutoResize("true")
  distanceLabel:setColor("white")
  distanceLabel:setFont("terminus-10px")
  distanceLabel:setMarginLeft(403)
  distanceLabel:setMarginTop(9)
  distanceLabel:setText(distance)
end)

ProtocolGame.registerExtendedOpcode(pokedexTYPESOPCODE, function(protocol, opcode, buffer)
  local param = buffer:explode("@")
  local typee = tostring(param[1])
  local element = tostring(param[2])

  if typee == "weak" then
    local elements = g_ui.createWidget("UIButton", weakPanel)
    elements:setSize("35 35")
    elements:setImageSource("images/elements/" .. string.lower(element) .. ".png")
    elements:setTooltip(element)
  end

  if typee == "super" then
    local elements = g_ui.createWidget("UIButton", superPanel)
    elements:setSize("35 35")
    elements:setImageSource("images/elements/" .. string.lower(element) .. ".png")
    elements:setTooltip(element)
  end
end)

function changeCategory(selected)
  if selected == "informations" then
    informationsPokemon:setOpacity(100)
    habilitiesPokemon:setOpacity(0.70)
    typesPokemon:setOpacity(0.70)

    pokemonPanel:show()
    habilitiesTab:hide()
    habilitiesTabPanel:hide()
    habilitiesScrollBar:hide()

    weakLabel:hide()
    weakPanel:hide()

    superLabel:hide()
    superPanel:hide()

    informations:setImageSource("images/info")
  elseif selected == "habilities" then
    informationsPokemon:setOpacity(0.70)
    habilitiesPokemon:setOpacity(100)
    typesPokemon:setOpacity(0.70)

    pokemonPanel:hide()
    habilitiesTab:show()
    habilitiesTabPanel:show()
    habilitiesScrollBar:show()

    weakLabel:hide()
    weakPanel:hide()

    superLabel:hide()
    superPanel:hide()

    informations:setImageSource("images/habilit")
  elseif selected == "types" then
    informationsPokemon:setOpacity(0.70)
    habilitiesPokemon:setOpacity(0.70)
    typesPokemon:setOpacity(100)

    pokemonPanel:hide()
    habilitiesTab:hide()
    habilitiesTabPanel:hide()
    habilitiesScrollBar:hide()

    weakLabel:show()
    weakPanel:show()

    superLabel:show()
    superPanel:show()

    informations:setImageSource("images/tipos")
  end
end