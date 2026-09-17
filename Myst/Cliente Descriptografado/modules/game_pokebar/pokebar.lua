-- [
    -- Cosmic Programmer
    --~~ Thalles Vitor ~~--
    --~~ Troca ou Revenda Ã© proibido ~~--
    --~~ https://discord.gg/NceAyWr ~~--
--]

local pokebar = g_ui.displayUI("pokebar")
local pokebarButton = nil
local minimizar = false
local globalPokeballs = 0

local minimize = pokebar:getChildById('minimize')
local close = pokebar:getChildById('close')

function init()
  connect(g_game, {
    onGameStart = exibir,
    onGameEnd = naoexibir,
  })

  pokeBarButton = modules.client_topmenu.addRightGameToggleButton('pbarButton', tr('Poke Bar'), '/images/topbuttons/dot_hover', toggle)
  pokeBarButton:setOn(true)
  pokebar:hide()
end

function terminate()
  disconnect(g_game, {
    onGameStart = exibir,
    onGameEnd = naoexibir
  })
  
  pokebar:hide()
  hideAllBar()
  hideAllBarColor()
end

function toggle()
  if pokeBarButton:isOn() then
    pokebar:hide()
    pokeBarButton:setOn(false)
  else
    pokebar:show()
    pokeBarButton:setOn(true)
  end
end

ProtocolGame.registerExtendedOpcode(66, function(protocol, opcode, buffer) -- receive bar
  local param = buffer:split("@")
  local name = tostring(param[1])
  local level = tonumber(param[2])
  local gender = tostring(param[3])
  local health = tonumber(param[4])
  local portrait = tonumber(param[5])
  local numeration = tonumber(param[6])

  pokebar:show()
  --[[ pokebar.onHoverChange = function(self, hovered)
    if hovered then
      pokebar:setText("Lista de Pokémons")
      pokebar:setImageSource("images/window.png")
      pokebar:setFocusable(true)

      minimize:setImageSource("images/window_minimize")
      close:setImageSource("images/window_close")
      close.onClick = function()
         pokebar:hide()
         pokeBarButton:setOn(false) 
      end

      minimize:show()
      close:show()
    else
      pokebar:setText("")
      pokebar:setImageSource("")

      minimize:setImageSource("")
      close:setImageSource("")
      close.onClick = function() end

      minimize:hide()
      close:hide()
    end
  end ]]

  showBar(numeration)
  --print(numeration .. " - " .. name)
  if pokebar:getChildById('bar'..numeration) then
    pokebar:getChildById('life'..numeration):setBackgroundColor("#02ec0d")
    if health <= 0 then
      pokebar:getChildById('bar'..numeration):setImageSource("images/pokebar_fainted.png")
      pokebar:getChildById('percent'..numeration):setText("0%")
      pokebar:getChildById('life'..numeration):setPercent(0)
    end

    if health >= 40 and health <= 50 then
      pokebar:getChildById('life'..numeration):setBackgroundColor("#90a500")
    elseif health >= 30 and health <= 60 then
      pokebar:getChildById('life'..numeration):setBackgroundColor("#ac7000")
    elseif health >= 1 and health <= 25 then
      pokebar:getChildById('life'..numeration):setBackgroundColor("#9e0001")
    end

    -- Carregar Propriedades
    pokebar:getChildById('portrait'..numeration):setItemId(portrait)
    pokebar:getChildById('pokeName'..numeration):setText("[" ..level.. "] " ..name)
    pokebar:getChildById('pokemonGender'..numeration):setImageSource("images/" ..string.lower(gender) .. ".png")
    pokebar:getChildById('percent'..numeration):setText(health .. "%")
    pokebar:getChildById('life'..numeration):setPercent(health)

    --pokebar.onHoverChange = onMoveBottomPanelHoverChange

    pokebar:getChildById('bar'..numeration).onMousePress = function() 
      g_game.talk('/bar '..numeration) 
    end

    pokebar:getChildById('portrait'..numeration).onMousePress = function() 
      g_game.talk('/bar '..numeration) 
    end
        
    globalPokeballs = globalPokeballs + 1

    minimize:hide()
    close:hide()
    end
end)

ProtocolGame.registerExtendedOpcode(67, function(protocol, opcode, buffer) -- change health bar
  local param = buffer:split("@")
  local health = tonumber(param[1])
  local numeration = tonumber(param[2])

  if numeration ~= nil and numeration > 0 and pokebar:getChildById('bar'..numeration) then
    if health >= 40 and health <= 50 then
      pokebar:getChildById('life'..numeration):setBackgroundColor("#90a500")
    elseif health >= 30 and health <= 60 then
      pokebar:getChildById('life'..numeration):setBackgroundColor("#ac7000")
    elseif health >= 1 and health <= 25 then
      pokebar:getChildById('life'..numeration):setBackgroundColor("#9e0001")
    end

    if health >= 65 then
      pokebar:getChildById('life'..numeration):setBackgroundColor("#02ec0d")
    end

    pokebar:getChildById('percent'..numeration):setText(health .. "%")
    pokebar:getChildById('life'..numeration):setPercent(health)
  end
end)

ProtocolGame.registerExtendedOpcode(68, function(protocol, opcode, buffer) -- change level bar
  local param = buffer:split("@")
  local name = tostring(param[1])
  local level = tonumber(param[2])
  local numeration = tonumber(param[3])

  if numeration ~= nil and numeration > 0 and pokebar:getChildById('bar'..numeration) then
	pokebar:getChildById('pokeName'..numeration):setText("[" ..level.. "] " ..name)
  end
end)

ProtocolGame.registerExtendedOpcode(69, function(protocol, opcode, buffer) -- change status bar (on/off)
  local param = buffer:split("@")
  local numeration = tonumber(param[1])
  local type = tostring(param[2])

  hideAllBarColor()
  if pokebar:getChildById('bar'..numeration) then
	  if numeration ~= nil and numeration > 0 and type == "on" then
		pokebar:getChildById('bar'..numeration):setImageSource("images/pokebar_use.png")
	  elseif numeration ~= nil and numeration > 0 and type == "off" then
		pokebar:getChildById('bar'..numeration):setImageSource("images/pokebar_default.png")
	  elseif numeration ~= nil and numeration > 0 and type == "nurse" then
		for i = 1, 6 do
			pokebar:getChildById('bar'..i):setImageSource("images/pokebar_default.png")
			pokebar:getChildById('percent'..i):setText("100%")
			pokebar:getChildById('life'..i):setPercent(100)
      pokebar:getChildById('life'..i):setBackgroundColor("#02ec0d")
		end
	  elseif numeration ~= nil and numeration > 0 and type == "death" then
		 pokebar:getChildById('bar'..numeration):setImageSource("images/pokebar_fainted.png")
		 pokebar:getChildById('percent'..numeration):setText("0%")
		 pokebar:getChildById('life'..numeration):setPercent(0)
	  end
  end
end)

ProtocolGame.registerExtendedOpcode(78, function(protocol, opcode, buffer) -- hide all bar
  local param = buffer:split("@")
  local type = tostring(param[1])

  if type == "hide" then
    --pokebar:destroyChildren()
    hideAllBar()
  end
end)

function showAllBar()
  hideAllBar()

  if not globalPokeballs then
    globalPokeballs = 0
    pokebar:setImageSource("images/window.png")
    pokebar:setText("Lista de Pokemon")
  end

  for i = 1, globalPokeballs do
    if pokebar:getChildById('bar'..i) then
      pokebar:getChildById('bar'..i):show()
      pokebar:getChildById('life'..i):show()
      pokebar:getChildById('portrait'..i):show()
      pokebar:getChildById('pokeName'..i):show()
      pokebar:getChildById('percent'..i):show()
      pokebar:getChildById('pokemonGender'..i):show()
    end
  end
end

function hideAllBar()
  for i = 1, 6 do
  if pokebar:getChildById('bar'..i) then
    pokebar:getChildById('bar'..i):hide()
    pokebar:getChildById('life'..i):hide()
    pokebar:getChildById('portrait'..i):hide()
    pokebar:getChildById('pokeName'..i):hide()
    pokebar:getChildById('percent'..i):hide()
    pokebar:getChildById('pokemonGender'..i):hide()
   end
  end
end

function showBar(i)
  if pokebar:getChildById('bar'..i) then
    pokebar:getChildById('bar'..i):show()
    pokebar:getChildById('life'..i):show()
    pokebar:getChildById('portrait'..i):show()
    pokebar:getChildById('pokeName'..i):show()
    pokebar:getChildById('percent'..i):show()
    pokebar:getChildById('pokemonGender'..i):show()

  end
end

function hideAllBarColor()
  for i = 1, 6 do
	if pokebar:getChildById('bar'..i) and pokebar:getChildById('percent'..i):getText() ~= "0%" then
      pokebar:getChildById('bar'..i):setImageSource("images/pokebar_default.png")
	end
  end
end

function onMoveBottomPanelHoverChange(widget)
  if widget and widget:isHovered() == true then
    pokebar:setImageSource("images/window.png")
    pokebar:setText("Lista de Pokemon")

    minimize:show()
    close:show()

    g_effects.fadeIn(minimize, 1000)
    g_effects.fadeIn(close, 1000)
  elseif widget and widget:isHovered() == false then
      pokebar:setText("")
      pokebar:setImageSource("")
      
      g_effects.fadeOut(minimize, 7000)
      g_effects.fadeOut(close, 7000)
  else
    --
  end
end

function exibir()
  addEvent(function()
    pokebar:hide()
    pokeBarButton:setOn(false)
  end)
end

function naoexibir()
  hideAllBar()
  hideAllBarColor()
  pokebar:hide()
  pokeBarButton:setOn(false)
end

function minimizeMain()
  if minimizar == false then
    hideAllBar()
    pokebar:setImageSource("images/window_minimized")
    pokebar:setText("")

    minimize:show()
    close:show()

    minimize:setImageSource("images/window_maximize")

   -- pokebar.onHoverChange = function() end

    minimizar = true
  else
    showAllBar()
    pokebar:setImageSource("images/window")
    pokebar:setText("")

    minimize:setImageSource("images/window_minimize")

   -- pokebar.onHoverChange = onMoveBottomPanelHoverChange

    minimizar = false
  end
end