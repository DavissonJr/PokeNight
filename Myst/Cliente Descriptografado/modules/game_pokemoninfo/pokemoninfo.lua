-- [
    -- Cosmic Programmer
    --~~ Thalles Vitor ~~--
    --~~ Troca ou Revenda � proibido ~~--
    --~~ https://discord.gg/qtNneAq8 ~~--
--]

local pokemonInfoWindow = nil
local pokemonInfoPokemonName = nil
local pokemonInfoWindowPortrait = nil
local pokemonInfoWindowLevelLabel = nil
local pokemonInfoWindowNatureLabel = nil
local pokemonInfoWindowHealth = nil
local pokemonInfoWindowHealthBar = nil
local pokemonInfoWindowExperience = nil
local pokemonInfoWindowExperienceBar = nil

local pokemonInfoWindowPokemonAddons = nil
local pokemonInfoWindowPokemonOrder = nil

local pokemonInfoWindowHabilitie1 = nil
local pokemonInfoWindowHabilitie2 = nil
local pokemonInfoWindowHabilitie3 = nil
local pokemonInfoWindowHabilitie4 = nil
local pokemonInfoWindowHabilitie5 = nil

local pokeInfoButton = nil

local config = {
	options = {
    [1] = {name = "Celadon", command = "!teleport celadon"},
    [2] = {name = "Cerulean", command = "!teleport cerulean"},
    [3] = {name = "Cinnabar", command = "!teleport cinnabar"},
    [4] = {name = "Fuchsia", command = "!teleport fuchsia"},
    [5] = {name = "Lavender", command = "!teleport lavender"},
    [6] = {name = "Pallet", command = "!teleport pallet"},
    [7] = {name = "Pewter", command = "!teleport pewter"},
    [8] = {name = "Saffron", command = "!teleport saffron"},
    [9] = {name = "Vermilion", command = "!teleport vermilion"},
    [10] = {name = "Viridian", command = "!teleport viridian"},
    [11] = {name = "Azalea", command = "!teleport azalea"},
    [12] = {name = "Blackthorn", command = "!teleport blackthorn"},
    [13] = {name = "Cherrygrove", command = "!teleport cherrygrove"},
    [14] = {name = "Cianwood", command = "!teleport cianwood"},
    [15] = {name = "Ecruteak", command = "!teleport ecruteak"},
    [16] = {name = "Goldenrod", command = "!teleport goldenrod"},
    [17] = {name = "Mahogany", command = "!teleport mahogany"},
    [18] = {name = "New Bark", command = "!teleport new bark"},
    [19] = {name = "Olivine", command = "!teleport olivine"},
    [20] = {name = "Violet", command = "!teleport violet"},
    [21] = {name = "Canavale", command = "!teleport canavale"},
    [22] = {name = "Larosse", command = "!teleport larosse"},
    [23] = {name = "Orre", command = "!teleport orre"},
    [24] = {name = "Battle City", command = "!teleport battle city"},
    [25] = {name = "Hunter Village", command = "!teleport hunter village"},
    [26] = {name = "Singer", command = "!teleport singer"},
    [27] = {name = "Sunshine", command = "!teleport sunshine"},
    [28] = {name = "House", command = "!teleport house"},
	}
}

local pokemoAddonTable = {
  ["Shiny Alakazam"] = {normal = 1259,
  addonLookType = 2014, addonName = "Grey hat addon", addonLookType2 = 2015, addonName2 = "Purple hat addon", addonName3 = "Cowboy hat addon", addonLookType3 = 2013},
}

ProtocolGame.registerExtendedOpcode(45, function(protocol, opcode, buffer)
  local param = buffer:explode('@')

  if param[4] == "1" then
    pokemonInfoWindowHealth:setText("0%")
    pokemonInfoWindowExperience:setText("IND.")

    pokemonInfoWindowHealthBar:hide()
    pokemonInfoWindowExperienceBar:hide()

    pokemonInfoWindowLevelLabel:setText("Level: 000")
    pokemonInfoWindowNatureLabel:setText("Nature: ???")
    pokemonInfoWindowPortrait:setItemId(3283)
    pokemonInfoWindowPortrait:setTooltip("")
    pokemonInfoPokemonName:setText("-")

    pokemonInfoWindowHabilitie1:setImageSource("")
    pokemonInfoWindowHabilitie1:setTooltip("")
    pokemonInfoWindowHabilitie1.onClick = function() end

    pokemonInfoWindowHabilitie2:setImageSource("")
    pokemonInfoWindowHabilitie2:setTooltip("")
    pokemonInfoWindowHabilitie2.onClick = function() end

    pokemonInfoWindowHabilitie3:setImageSource("")
    pokemonInfoWindowHabilitie3:setTooltip("")
    pokemonInfoWindowHabilitie3.onClick = function() end

    pokemonInfoWindowHabilitie4:setImageSource("")
    pokemonInfoWindowHabilitie4:setTooltip("")
    pokemonInfoWindowHabilitie4.onClick = function() end

    pokemonInfoWindowHabilitie5:setImageSource("")
    pokemonInfoWindowHabilitie5:setTooltip("")
    pokemonInfoWindowHabilitie5.onClick = function() end
  else

  if param[6] == "0" then
    pokemonInfoWindowPortrait:setItemId(param[2])
    pokemonInfoWindowPortrait:setTooltip("Level: " .. param[3] .. "\nNature: " .. param[8])
    pokemonInfoPokemonName:setText(param[1])
    pokemonInfoWindowLevelLabel:setText("Level: "..param[3])
    pokemonInfoWindowNatureLabel:setText("Nature: "..param[8])
    pokemonInfoWindowHealthBar:show()
    pokemonInfoWindowExperienceBar:show()
    pokemonInfoWindowHealthBar:setPercent((math.floor(param[4] / param[5] * 100)))
    pokemonInfoWindowHealthBar:setTooltip((math.floor(param[4] / param[5] * 100).. "% (") .. (param[4].. "/" ..param[5]).. ")")
    pokemonInfoWindowHealth:setText((math.floor(param[4] / param[5] * 100).. "%"))
    pokemonInfoWindowExperienceBar:setPercent((math.floor(param[6] / param[7] * 100))) 
    pokemonInfoWindowExperience:setText("0%")
  else

    pokemonInfoWindowPortrait:setItemId(param[2])
    pokemonInfoWindowPortrait:setTooltip("Level: " .. param[3] .. "\nNature: " .. param[8])
    pokemonInfoPokemonName:setText(param[1])
    pokemonInfoWindowLevelLabel:setText("Level: "..param[3])
    pokemonInfoWindowNatureLabel:setText("Nature: "..param[8])
    pokemonInfoWindowHealthBar:show()
    pokemonInfoWindowExperienceBar:show()
    pokemonInfoWindowHealthBar:setPercent((math.floor(param[4] / param[5] * 100)))
    pokemonInfoWindowHealthBar:setTooltip((math.floor(param[4] / param[5] * 100).. "% (") .. (param[4].. "/" ..param[5]).. ")")
    pokemonInfoWindowHealth:setText((math.floor(param[4] / param[5] * 100).. "%"))
    pokemonInfoWindowExperienceBar:setPercent((math.floor(param[6] / param[7] * 100)))
    pokemonInfoWindowExperience:setText((math.floor(param[6] / param[7] * 100).. "%"))
	pokemonInfoWindowExperienceBar:setTooltip((math.floor(param[6] / param[7] * 100).. "% (") .. (param[6].. "/" ..param[7]).. ")")
    end
  end
end)

ProtocolGame.registerExtendedOpcode(46, function(protocol, opcode, buffer)
  local param = buffer:explode('@')

  local function fixHabilitieFunction()
    local player = g_game.getLocalPlayer()
    local item = Item.create(3453)
    modules.game_interface.startUseWith(item)
  end

  local function teleport()
    local menu = g_ui.createWidget("PopupMenu")
    menu:setSize("188 411")

    local search = g_ui.createWidget("TextEdit", menu)
    search.onTextChange = function(self, value)
     for i = 1, #config.options do
       menu:removeOption(config.options[i].name)
       if string.find(string.lower(tostring(config.options[i].name)), string.lower(tostring(value))) then
         menu:addOption(config.options[i].name, function() g_game.talk(config.options[i].command) end)
       end
     end
   end

    for i = 1, #config.options do
     menu:addOption(config.options[i].name, function() g_game.talk(config.options[i].command) end)
    end

    menu:display()
 end

  if param[1] == "Teleport" then
    pokemonInfoWindow:getChildById('habilitie'..param[2]):setImageSource("/game_pokemoninfo/images/poke-habilities/"..string.lower(param[1]).."")
    pokemonInfoWindow:getChildById('habilitie'..param[2]):setTooltip(param[1])
    pokemonInfoWindow:getChildById('habilitie'..param[2]).onClick = teleport
  else
    if param[1] == nil then
      return false
    end
    if param[2] == nil then
      return false
    end
    if param[2] == "0" then
      pokemonInfoWindow:getChildById('habilitie1'):setImageSource("/game_pokemoninfo/images/poke-habilities/"..string.lower(param[1]).."")
      pokemonInfoWindow:getChildById('habilitie1'):setTooltip(param[1])
      pokemonInfoWindow:getChildById('habilitie1').onClick = fixHabilitieFunction
    else
      pokemonInfoWindow:getChildById('habilitie'..param[2]):setImageSource("/game_pokemoninfo/images/poke-habilities/"..string.lower(param[1]).."")
      pokemonInfoWindow:getChildById('habilitie'..param[2]):setTooltip(param[1])
      pokemonInfoWindow:getChildById('habilitie'..param[2]).onClick = fixHabilitieFunction
    end
  end
end)

ProtocolGame.registerExtendedOpcode(47, function(protocol, opcode, buffer)
  local param = buffer:explode('@')
    -- atualizar barra de hp/exp do poke

  pokemonInfoWindowExperienceBar:setPercent((math.floor(param[1] / param[2] * 100)))
  pokemonInfoWindowExperience:setText((math.floor(param[1] / param[2] * 100).. "%"))

  pokemonInfoWindowHealthBar:setPercent((math.floor(param[3] / param[4] * 100)))
  pokemonInfoWindowHealth:setText((math.floor(param[3] / param[4] * 100).. "%"))
end)

ProtocolGame.registerExtendedOpcode(48, function(protocol, opcode, buffer)
  local param = buffer:explode('@')

  if param[5] == "0" or param[5] == nil then
    return false
  end

  if param[4] == "false" then
    pokemonInfoWindowPokemonAddons:setOpacity(0.40)
    pokemonInfoWindowPokemonAddons:setTooltip("Sem addons")
    pokemonInfoWindowPokemonAddons.onClick = function() end
  end
end)

function init()
  connect(g_game, {
    onGameStart = exibir2,
    onGameEnd = naoexibir,
  })
  pokeInfoButton = modules.client_topmenu.addRightGameToggleButton('pokeInfoButton', tr('Pokemon Info') .. ' (Ctrl+P)', '/images/topbuttons/pokeinfo_hover', exibir)
  pokeInfoButton:setOn(false)

  pokemonInfoWindow = g_ui.loadUI('pokemoninfo', modules.game_interface.getRightPanel())
  pokemonInfoPokemonName = pokemonInfoWindow:getChildById('nameCamp')
  pokemonInfoWindowPortrait = pokemonInfoWindow:getChildById('portrait')
  pokemonInfoWindowLevelLabel = pokemonInfoWindow:getChildById('pokemonLevel')
  pokemonInfoWindowNatureLabel = pokemonInfoWindow:getChildById('pokemonNature')
  pokemonInfoWindowHealth = pokemonInfoWindow:getChildById('pokemonHealthText')
  pokemonInfoWindowHealthBar = pokemonInfoWindow:getChildById('pokemonlife')
  pokemonInfoWindowExperience = pokemonInfoWindow:getChildById('pokemonExperienceText')
  pokemonInfoWindowExperienceBar = pokemonInfoWindow:getChildById('pokemonexperience')

  pokemonInfoWindowPokemonAddons = pokemonInfoWindow:getChildById('pokemonAddons')
  pokemonInfoWindowPokemonOrder = pokemonInfoWindow:getChildById('pokemonOrder')

  pokemonInfoWindowHabilitie1 = pokemonInfoWindow:getChildById('habilitie1')
  pokemonInfoWindowHabilitie2 = pokemonInfoWindow:getChildById('habilitie2')
  pokemonInfoWindowHabilitie3 = pokemonInfoWindow:getChildById('habilitie3')
  pokemonInfoWindowHabilitie4 = pokemonInfoWindow:getChildById('habilitie4')
  pokemonInfoWindowHabilitie5 = pokemonInfoWindow:getChildById('habilitie5')

  pokemonInfoWindow:disableResize()
  pokemonInfoWindow:setup()
  pokemonInfoWindow:hide()
end

function terminate()
  disconnect(g_game, {
    onGameStart = exibir2,
    onGameEnd = naoexibir,
  })
  pokeInfoButton:hide()
  pokemonInfoWindow:destroy()
end

function exibir()
  if pokeInfoButton:isOn() == false then
    pokemonInfoWindow:show()
    pokeInfoButton:setOn(true)
  else
    pokemonInfoWindow:hide()
    pokeInfoButton:setOn(false)
  end
end

function exibir2()
  pokemonInfoWindow:hide()
  pokeInfoButton:setOn(false)
end

function naoexibir()
  --pokemonInfoWindow:destroy()
end

function useOrder()
	local player = g_game.getLocalPlayer()
	safeUseInventoryItemWith(player:getInventoryItem(4):getId())
end

function safeUseInventoryItemWith(itemId)
    local player = g_game.getLocalPlayer()
	local item = Item.create(itemId)
    modules.game_interface.startUseWith(item)
  return true
end

function callPokemon()
  local player = g_game.getLocalPlayer()
  if not player then
    return
  end

  g_game.use(player:getInventoryItem(8))
end