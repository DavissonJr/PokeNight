-- Criado por Thalles Vitor --
-- Remaked 15/02/2023 --

-- Tm Window
local tm = g_ui.displayUI("tm")
local tmMoves = tm:getChildById("movesWindow")
local tmAvaiables = tm:getChildById("allMovesWindow")
local allMovesAvailables = tm:getChildById("allMovesAvailables")
local movesReady = tm:getChildById("movesReady")
local showAllTMSWidget = tm:getChildById("showAllTMS")
--local tmButton = nil

local confirmar = tm:getChildById("confirm")
local resetar = tm:getChildById("reset")

-- Lista
local list = {}

-- Setas
local left = tm:getChildById("left")
local right = tm:getChildById("right")
local up = tm:getChildById("up")
local rightValue = 1 -- right e left usam essa variavel

-- Total Pokemon Moves Variable Global
local moveTotals = 0

-- Lista
local iconList = {}
local iconLevel = {}
local iconCooldown = {}
local iconTooltip = {}
local iconElement = {}

-- Lista de TMs disponiveis
local tm_avaiable_list = {}
local tm_avaiable_list_element = {}
local tm_avaiable_list_level = {}
local tm_avaiable_list_cooldown = {}
local lista = {}
local alterar = true
local enabled = false
local hided = false
local globalSelectedWidget

function init()
  connect(g_game, {
    onGameEnd = naoexibir,
  })

  --tmButton = modules.client_topmenu.addRightGameToggleButton('tmButton', tr('Tm'), 'images/tmButton', exibir2)
  --tmButton:setOn(false)
  tm:hide()
end

function terminate()
  disconnect(g_game, {
    onGameEnd = naoexibir,
  })

  --tmButton:setOn(false)
  tm:hide()
end

-- Funcao de exibir pelo botao
function exibir2()
  if tm:isVisible() then
    naoexibir()
    modules.game_pokemoves.getPokeMoves():show()
  else
    if g_game.isOnline() and g_game.getProtocolGame() then
      g_game.getProtocolGame():sendExtendedOpcode(130)
    end

    modules.game_pokemoves.getPokeMoves():hide()
  end
end

-- Funcao de exibir
function exibir()
 -- tmButton:setOn(false)
  tm:hide()
end

-- Funcao de nao exibir (logout/terminate)
function naoexibir()
  --tmButton:setOn(false)

  enabled = false
  alterar = true

  tmMoves:show()
  tmAvaiables:show()
  resetar:show()
  movesReady:show()
  showAllTMSWidget:show()

  left:show()
  right:show()
  up:hide()

  allMovesAvailables:destroyChildren()
  allMovesAvailables:hide()

  unloadProperties()
  tm:hide()
  modules.game_pokemoves.getPokeMoves():show()

  hided = true

  for index = 1, #tm_avaiable_list do
    tm_avaiable_list[index] = nil
    tm_avaiable_list_level[index] = nil
    tm_avaiable_list_cooldown[index] = nil
    tm_avaiable_list_element[index] = nil
  end
end

function naoexibir2()
  --tmButton:setOn(false)

  enabled = false
  alterar = true

  tmMoves:show()
  tmAvaiables:show()
  resetar:show()
  movesReady:show()
  showAllTMSWidget:show()

  left:show()
  right:show()
  up:hide()

  allMovesAvailables:destroyChildren()
  allMovesAvailables:hide()

  unloadProperties()
  tm:hide()
  modules.game_pokemoves.getPokeMoves():show()

  hided = false

  for index = 1, #tm_avaiable_list do
    tm_avaiable_list[index] = nil
    tm_avaiable_list_level[index] = nil
    tm_avaiable_list_cooldown[index] = nil
    tm_avaiable_list_element[index] = nil
  end
end

-- Detectar o tamanho da janela atraves da quantidade de movimentos de um pokemon
function detectTam(tam)
  if tonumber(tam) == 12 then -- 0 movimentos
    tmMoves:setImageSource("images/movesWindow")
    tmMoves:setText("Este pokï¿½mon nï¿½o possui nenhum move!")
    tmMoves:setMarginLeft(5)
  end

  if tonumber(tam) == 11 then -- 1 movimentos
    tmMoves:setText("")
    tmMoves:setWidth(416 - (tam*34))
    tmMoves:setHeight(52)
    tmMoves:setImageSource("images/movesWindow")
    tmMoves:setMarginLeft(5)
  end

  if tonumber(tam) == 10 then -- 2 movimentos
    tmMoves:setText("")
    tmMoves:setWidth(429 - (tam*34))
    tmMoves:setHeight(52)
    tmMoves:setImageSource("images/movesWindow")
    tmMoves:setMarginLeft(-13)
  end

  if tonumber(tam) == 9 then -- 3 movimentos
    tmMoves:setText("")
    tmMoves:setWidth(430 - (tam*34))
    tmMoves:setHeight(52)
    tmMoves:setImageSource("images/movesWindow")
    tmMoves:setMarginLeft(-35)
  end

  if tonumber(tam) == 8 then -- 4 movimentos
    tmMoves:setText("")
    tmMoves:setWidth(432 - (tam*34))
    tmMoves:setHeight(52)
    tmMoves:setImageSource("images/movesWindow")
    tmMoves:setMarginLeft(-56)
  end

  if tonumber(tam) == 7 then -- 5 movimentos
    tmMoves:setText("")
    tmMoves:setWidth(432 - (tam*34))
    tmMoves:setHeight(52)
    tmMoves:setImageSource("images/movesWindow")
    tmMoves:setMarginLeft(-68)
  end

  if tonumber(tam) == 6 then -- 6 movimentos
    tmMoves:setText("")
    tmMoves:setWidth(432 - (tam*34))
    tmMoves:setHeight(52)
    tmMoves:setImageSource("images/movesWindow")
    tmMoves:setMarginLeft(-84)
  end

  if tonumber(tam) == 5 then -- 7 movimentos
    tmMoves:setText("")
    tmMoves:setWidth(432 - (tam*34))
    tmMoves:setHeight(52)
    tmMoves:setImageSource("images/movesWindow")
    tmMoves:setMarginLeft(-98)
  end

  if tonumber(tam) == 4 then -- 8 movimentos
    tmMoves:setText("")
    tmMoves:setWidth(452 - (tam*34))
    tmMoves:setHeight(52)
    tmMoves:setImageSource("images/movesWindow")
    tmMoves:setMarginLeft(-124)
  end

  if tonumber(tam) == 3 then -- 9 movimentos
    tmMoves:setText("")
    tmMoves:setWidth(455 - (tam*34))
    tmMoves:setHeight(52)
    tmMoves:setImageSource("images/movesWindow")
    tmMoves:setMarginLeft(-142)
  end

  if tonumber(tam) == 2 then -- 10 movimentos
    tmMoves:setText("")
    tmMoves:setWidth(434 - (tam*34))
    tmMoves:setHeight(52)
    tmMoves:setImageSource("images/movesWindow")
    tmMoves:setMarginLeft(-151)
  end

  if tonumber(tam) == 1 then -- 11 movimentos
    tmMoves:setText("")
    tmMoves:setWidth(455 - (tam*34))
    tmMoves:setHeight(52)
    tmMoves:setImageSource("images/movesWindow")
    tmMoves:setMarginLeft(-172)
  end

  if tonumber(tam) == 0 then -- 12 movimentos
    tmMoves:setText("")
    tmMoves:setWidth(435 - (tam*34))
    tmMoves:setHeight(52)
    tmMoves:setImageSource("images/movesWindow")
    tmMoves:setMarginLeft(-185)
  end
end

-- Enviar modificacao pro servidor, o player voltar o poke e setar os atributos e usar a opcode do destroyTM
function sendModification()
  for i = 1, #iconList do
    if g_game.isOnline() and g_game.getProtocolGame() then
      g_game.getProtocolGame():sendExtendedOpcode(131, i.."@"..iconList[i].."@"..iconLevel[i].."@"..iconCooldown[i].."@")
    end
  end
end

-- Aqui e pra selecionar pela seta direita
function selectRight(selectedWidget)
  if rightValue > moveTotals then
    return
  end

  rightValue = selectedWidget + 1
  select(rightValue)

  local widgetImage1 = iconList[selectedWidget]
  local widgetImage2 = iconList[selectedWidget + 1]

  local widgetImage3 = iconElement[selectedWidget]
  local widgetImage4 = iconElement[selectedWidget + 1]

  local widgetTooltip1 = iconTooltip[selectedWidget]
  local widgetTooltip2 = iconTooltip[selectedWidget + 1]

  local widgetLevel1 = iconLevel[selectedWidget]
  local widgetLevel2 = iconLevel[selectedWidget + 1]

  local widgetCooldown1 = iconCooldown[selectedWidget]
  local widgetCooldown2 = iconCooldown[selectedWidget + 1]

  if widgetImage1 and widgetImage2 and widgetTooltip1 and widgetTooltip2 and widgetLevel1 and widgetLevel2 and widgetCooldown1 and widgetCooldown2 and selectedWidget < moveTotals and tmMoves:getChildById("moveCount"..selectedWidget + 1) and tmMoves:getChildById("moveCount"..selectedWidget) then
    tmMoves:getChildById("moveCount"..selectedWidget + 1):setIcon("/elements/" ..widgetImage3 .. ".png")
    tmMoves:getChildById("moveCount"..selectedWidget):setIcon("/elements/" ..widgetImage4.. ".png")

    tmMoves:getChildById("moveCount"..selectedWidget + 1):setTooltip(widgetTooltip1)
    tmMoves:getChildById("moveCount"..selectedWidget):setTooltip(widgetTooltip2)

    confirmar:setOn(true)
    confirmar:setOpacity(100)
    confirmar.onClick = function() sendModification() end

    iconList[selectedWidget + 1] = widgetImage1
    iconList[selectedWidget] = widgetImage2

    iconElement[selectedWidget + 1] = widgetImage3
    iconElement[selectedWidget] = widgetImage4

    iconTooltip[selectedWidget + 1] = widgetTooltip1
    iconTooltip[selectedWidget] = widgetTooltip2

    iconLevel[selectedWidget + 1] = widgetLevel1
    iconLevel[selectedWidget] = widgetLevel2

    iconCooldown[selectedWidget + 1] = widgetCooldown1
    iconCooldown[selectedWidget] = widgetCooldown2
  end
end

-- Aqui e pra selecionar pela seta esquerda
function selectLeft(selectedWidget)
  if rightValue <= 0 then
    return
  end

  rightValue = selectedWidget - 1
  select(rightValue)

  local widgetImage1 = iconList[selectedWidget]
  local widgetImage2 = iconList[selectedWidget - 1]

  local widgetImage3 = iconElement[selectedWidget]
  local widgetImage4 = iconElement[selectedWidget - 1]

  local widgetTooltip1 = iconTooltip[selectedWidget]
  local widgetTooltip2 = iconTooltip[selectedWidget - 1]

  local widgetLevel1 = iconLevel[selectedWidget]
  local widgetLevel2 = iconLevel[selectedWidget - 1]

  local widgetCooldown1 = iconCooldown[selectedWidget]
  local widgetCooldown2 = iconCooldown[selectedWidget - 1]

  if widgetImage1 and widgetImage2 and widgetTooltip1 and widgetTooltip2 and widgetLevel1 and widgetLevel2 and widgetCooldown1 and widgetCooldown2 and widgetImage3 and widgetImage4 and tmMoves:getChildById("moveCount"..selectedWidget - 1) and tmMoves:getChildById("moveCount"..selectedWidget) then
    tmMoves:getChildById("moveCount"..selectedWidget):setIcon("/elements/" ..widgetImage4 .. ".png")
    tmMoves:getChildById("moveCount"..selectedWidget - 1):setIcon("/elements/" ..widgetImage3.. ".png")

    tmMoves:getChildById("moveCount"..selectedWidget):setTooltip(widgetTooltip2)
    tmMoves:getChildById("moveCount"..selectedWidget - 1):setTooltip(widgetTooltip1)

    confirmar:setOn(true)
    confirmar:setOpacity(100)
    confirmar.onClick = function() sendModification() end

    iconList[selectedWidget] = widgetImage2
    iconList[selectedWidget - 1] = widgetImage1

    iconElement[selectedWidget] = widgetImage4
    iconElement[selectedWidget - 1] = widgetImage3

    iconTooltip[selectedWidget] = widgetTooltip2
    iconTooltip[selectedWidget - 1] = widgetTooltip1

    iconLevel[selectedWidget] = widgetLevel2
    iconLevel[selectedWidget - 1] = widgetLevel1

    iconCooldown[selectedWidget] = widgetCooldown2
    iconCooldown[selectedWidget - 1] = widgetCooldown1
  end
end

-- Aqui e pra selecionar atraves do mouse
function select(move, totalMoves)
  -- Habilitar Setas
  left:setOn(true)
  left:setOpacity(0.60)

  right:setOn(true)
  right:setOpacity(0.60)

  left.onClick = function() selectLeft(move) end
  right.onClick = function() selectRight(move) end

  enabled = true
  globalSelectedWidget = move

  if alterar == false then
  else
    g_game.getProtocolGame():sendExtendedOpcode(134) -- opcode dos tm, para poder clicar la em baixo
  end

  for i = 1, 12 do
    if tmMoves:getChildById("moveCount"..i) then
      if i ~= move then
        tmMoves:getChildById("moveCount"..i):setOpacity(0.90)
      end
      if tmMoves:getChildById("moveCount"..move) then
        tmMoves:getChildById("moveCount"..move):setOpacity(100)
      end
    end
  end
end

-- Receber os Movimentos dos Pokemon
function setMoves(moves, movename, movelevel, movecooldown, totalMoves, totalMoves2, element)

  moveTotals = totalMoves2 -- definir o total de moves em variavel global
  resetar.onClick = function() 
    if g_game.isOnline() and g_game.getProtocolGame() then
      g_game.getProtocolGame():sendExtendedOpcode(133)
    end
  end
  
  if not list[moves] then
    g_game.getProtocolGame():sendExtendedOpcode(134)

    local movesImage = g_ui.createWidget("UIButton", tmMoves)
    movesImage:setId("moveCount"..moves)

    local value = g_ui.createWidget("UIButton", movesImage)
    value:setId("value"..moves)
    value:addAnchor(AnchorTop, "parent", AnchorTop)
    value:addAnchor(AnchorLeft, "parent", AnchorLeft)

    value:setMarginTop(20)
    value:setMarginLeft(-4)
    value:setImageSource("images/values/"..tostring(moves))

    local type = g_ui.createWidget("UIButton", movesImage)
    type:setId("type"..moves)
    type:addAnchor(AnchorTop, "parent", AnchorTop)
    type:addAnchor(AnchorLeft, "parent", AnchorLeft)

    type:setMarginTop(20)
    type:setMarginLeft(10)

    type:setImageSource("images/type/normal")

    tmMoves:getChildById("moveCount"..moves):setIcon("/elements/"..element..".png")

    tmMoves:getChildById("moveCount"..moves):setOpacity(0.90)
    tmMoves:getChildById("moveCount"..moves):setTooltip("Nome: "..movename.."\nNível: " .. movelevel .. "\nCooldown: " .. movecooldown)
    tmMoves:getChildById("moveCount"..moves).onClick = function() select(moves, totalMoves2) end
    
    iconList[moves] = movename -- definir a lista de icones (select)
    iconElement[moves] = element
    iconLevel[moves] = movelevel -- definir a lista de level dos icones (select)
    iconCooldown[moves] = movecooldown -- definir a lista de cooldown dos icones (select)
    iconTooltip[moves] = "Nome: "..movename.."\nNível: " .. movelevel .. "\nCooldown: " .. movecooldown -- definir a lista de tooltip dos icones (select)
    list[moves] = movename
  else
    
    if tmMoves:getChildById("moveCount"..moves) then
      g_game.getProtocolGame():sendExtendedOpcode(134)

      tmMoves:getChildById("moveCount"..moves):show()
      tmMoves:getChildById("moveCount"..moves):setIcon("/elements/"..element..".png")

      tmMoves:getChildById("moveCount"..moves):setOpacity(0.90)
      tmMoves:getChildById("moveCount"..moves):setTooltip("Nome: "..movename.."\nNível: " .. movelevel .. "\nCooldown: " .. movecooldown)
      tmMoves:getChildById("moveCount"..moves).onClick = function() select(moves, totalMoves2) end

      iconList[moves] = movename -- definir a lista de icones (select)
      iconElement[moves] = element
      iconLevel[moves] = movelevel -- definir a lista de level dos icones (select)
      iconCooldown[moves] = movecooldown -- definir a lista de cooldown dos icones (select)
      iconTooltip[moves] = "Nome: "..movename.."\nNível: " .. movelevel .. "\nCooldown: " .. movecooldown -- definir a lista de tooltip dos icones (select)
    end
  end

  -- Definir a posicao dos moves no painel
  if list[moves] and totalMoves == 12 then -- 0 movimentos
    local child = tmMoves:getChildById("moveCount"..moves)

    if child then
      tmMoves:getChildById("moveCount"..moves):setMarginLeft(7)
      tmMoves:getChildById("moveCount"..moves):setMarginTop(11)

      -- Sem Movimento, foi simplesmente pegado do de 11
      child:getChildById("value"..moves):setMarginLeft(-8)
      child:getChildById("type"..moves):setMarginLeft(6)
    end
  end

  if list[moves] and totalMoves == 11 then -- 1 movimento
    local child = tmMoves:getChildById("moveCount"..moves)

    if child then
      tmMoves:getChildById("moveCount"..moves):setMarginLeft(9)
      tmMoves:getChildById("moveCount"..moves):setMarginTop(11)

      child:getChildById("value"..moves):setMarginLeft(-4)
      child:getChildById("type"..moves):setMarginLeft(10)
    end
  end

  if list[moves] and totalMoves == 10 then -- 2 movimentos
    local child = tmMoves:getChildById("moveCount"..moves)

    if child then
      tmMoves:getChildById("moveCount"..moves):setMarginLeft(16)
      tmMoves:getChildById("moveCount"..moves):setMarginTop(11)

      child:getChildById("value"..moves):setMarginLeft(-8)
      child:getChildById("type"..moves):setMarginLeft(6)
    end
  end

  if list[moves] and totalMoves == 9 then -- 3 movimentos
    local child = tmMoves:getChildById("moveCount"..moves)

    if child then
      tmMoves:getChildById("moveCount"..moves):setMarginLeft(16)
      tmMoves:getChildById("moveCount"..moves):setMarginTop(11)

      child:getChildById("value"..moves):setMarginLeft(-8)
      child:getChildById("type"..moves):setMarginLeft(6)
    end
  end

  if list[moves] and totalMoves == 8 then -- 4 movimentos
    local child = tmMoves:getChildById("moveCount"..moves)

    if child then
      tmMoves:getChildById("moveCount"..moves):setMarginLeft(16)
      tmMoves:getChildById("moveCount"..moves):setMarginTop(11)

      child:getChildById("value"..moves):setMarginLeft(-8)
      child:getChildById("type"..moves):setMarginLeft(6)
    end
  end

  if list[moves] and totalMoves == 7 then -- 5 movimentos
    local child = tmMoves:getChildById("moveCount"..moves)

    if child then
      tmMoves:getChildById("moveCount"..moves):setMarginLeft(13)
      tmMoves:getChildById("moveCount"..moves):setMarginTop(11)

      child:getChildById("value"..moves):setMarginLeft(-6)
      child:getChildById("type"..moves):setMarginLeft(8)
    end
  end

  if list[moves] and totalMoves == 6 then -- 6 movimentos
    local child = tmMoves:getChildById("moveCount"..moves)

    if child then
      tmMoves:getChildById("moveCount"..moves):setMarginLeft(8)
      tmMoves:getChildById("moveCount"..moves):setMarginTop(11)

      child:getChildById("value"..moves):setMarginLeft(-4)
      child:getChildById("type"..moves):setMarginLeft(10)
    end
  end

  if list[moves] and totalMoves == 5 then -- 7 movimentos
    local child = tmMoves:getChildById("moveCount"..moves)

    if child then
      tmMoves:getChildById("moveCount"..moves):setMarginLeft(8)
      tmMoves:getChildById("moveCount"..moves):setMarginTop(11)

      child:getChildById("value"..moves):setMarginLeft(-4)
      child:getChildById("type"..moves):setMarginLeft(10)
    end
  end

  if list[moves] and totalMoves == 4 then -- 8 movimentos
    local child = tmMoves:getChildById("moveCount"..moves)

    if child then
      tmMoves:getChildById("moveCount"..moves):setMarginLeft(22)
      tmMoves:getChildById("moveCount"..moves):setMarginTop(11)

      child:getChildById("value"..moves):setMarginLeft(-11)
      child:getChildById("type"..moves):setMarginLeft(3)
    end
  end

  if list[moves] and totalMoves == 3 then -- 9 movimentos
    local child = tmMoves:getChildById("moveCount"..moves)

    if child then
      tmMoves:getChildById("moveCount"..moves):setMarginLeft(18)
      tmMoves:getChildById("moveCount"..moves):setMarginTop(11)

      child:getChildById("value"..moves):setMarginLeft(-9)
      child:getChildById("type"..moves):setMarginLeft(5)
    end
  end

  if list[moves] and totalMoves == 2 then -- 10 movimentos
    local child = tmMoves:getChildById("moveCount"..moves)
    
    if child then
      tmMoves:getChildById("moveCount"..moves):setMarginLeft(10)
      tmMoves:getChildById("moveCount"..moves):setMarginTop(11)

      child:getChildById("value"..moves):setMarginLeft(-5)
      child:getChildById("type"..moves):setMarginLeft(9)
    end
  end

  if list[moves] and totalMoves == 1 then -- 11 movimentos
    local child = tmMoves:getChildById("moveCount"..moves)

    if child then
      tmMoves:getChildById("moveCount"..moves):setMarginLeft(19)
      tmMoves:getChildById("moveCount"..moves):setMarginTop(11)

      child:getChildById("value"..moves):setMarginLeft(-9)
      child:getChildById("type"..moves):setMarginLeft(5)
    end
  end

  if list[moves] and totalMoves == 0 then -- 12 movimentos
    local child = tmMoves:getChildById("moveCount"..moves)

    if child then
      tmMoves:getChildById("moveCount"..moves):setMarginLeft(7)
      tmMoves:getChildById("moveCount"..moves):setMarginTop(11)

      child:getChildById("value"..moves):setMarginLeft(-3)
      child:getChildById("type"..moves):setMarginLeft(11)
    end
  end
end

-- Mudar um TM de cima para baixo
function mudarTMMove2(index, movename, lockin, typee)
  local widgetImage1 = tm_avaiable_list[index]
  local widgetImage2 = iconList[globalSelectedWidget]

  local widgetImage3 = tm_avaiable_list_element[index]
  local widgetImage4 = iconElement[globalSelectedWidget]

  local widgetLevel1 = tm_avaiable_list_level[index]
  local widgetLevel2 = iconLevel[globalSelectedWidget]

  local widgetCooldown1 = tm_avaiable_list_cooldown[index]
  local widgetCooldown2 = iconCooldown[globalSelectedWidget]

  temporary_table_tm = {}
  temporary_table_tm_level = {}
  temporary_table_tm_cooldown = {}

  if tmMoves:getChildById("moveCount"..globalSelectedWidget) then

    tmMoves:getChildById("moveCount"..globalSelectedWidget):setIcon("/elements/" ..widgetImage4 .. ".png")
    tmAvaiables:getChildById("TMCount"..index):setImageSource("/elements/" ..widgetImage3.. ".png")

    tmMoves:getChildById("moveCount"..globalSelectedWidget):setTooltip("Nome: "..widgetImage2.."\nNível: " .. widgetLevel2 .. "\nCooldown: " .. widgetCooldown2)
    tmAvaiables:getChildById("TMCount"..index):setTooltip("Nome: "..widgetImage3.."\nNível: " .. widgetLevel1 .. "\nCooldown: " .. widgetCooldown1)

    tm_avaiable_list[index] = widgetImage1
    tm_avaiable_list_element[index] = widgetImage3

    tm_avaiable_list_level[index] = widgetLevel1
    tm_avaiable_list_cooldown[index] = widgetCooldown1

    iconList[globalSelectedWidget] = widgetImage2
    iconElement[globalSelectedWidget] = widgetImage4
    iconLevel[globalSelectedWidget] = widgetLevel2
    iconCooldown[globalSelectedWidget] = widgetCooldown2
    --[[ iconElement[globalSelectedWidget] = widgetElement1 ]]
    
    table.insert(temporary_table_tm, widgetImage1)
    table.insert(temporary_table_tm_level, widgetLevel1)
    table.insert(temporary_table_tm_level, widgetCooldown1)

    for i = 1, #tm_avaiable_list do
      if tm_avaiable_list[i] ~= temporary_table_tm[i] then
        table.insert(temporary_table_tm, tm_avaiable_list[i])
        table.insert(temporary_table_tm_level, tm_avaiable_list_level[i])
        table.insert(temporary_table_tm_cooldown, tm_avaiable_list_cooldown[i])
      end
    end

    local function enviar()
      for i = 1, #temporary_table_tm do
        if temporary_table_tm_level[i] ~= nil and temporary_table_tm_cooldown[i] ~= nil then
          g_game.getProtocolGame():sendExtendedOpcode(135, i.."@"..temporary_table_tm[i].."@"..temporary_table_tm_level[i].."@"..temporary_table_tm_cooldown[i].."@")
          sendModification()
    
          temporary_table_tm[i] = nil
          temporary_table_tm_level[i] = nil
          temporary_table_tm_cooldown[i] = nil
        end
      end
    end

    up.onClick = function() mudarTMMove(index, movename, lockin, typee) end
    confirmar:setOn(true)
    confirmar:setOpacity(100)
    confirmar.onClick = function() enviar() end
  end

  alterar = false
end

-- Mudar um TM de baixo para cima
function mudarTMMove(index, movename, lockin, typee)
  local widgetImage1 = tm_avaiable_list[index]
  local widgetImage2 = iconList[globalSelectedWidget]

  local widgetImage4 = tm_avaiable_list_element[index]
  local widgetImage5 = iconElement[globalSelectedWidget]

  local widgetLevel1 = tm_avaiable_list_level[index]
  local widgetLevel2 = iconLevel[globalSelectedWidget]

  local widgetCooldown1 = tm_avaiable_list_cooldown[index]
  local widgetCooldown2 = iconCooldown[globalSelectedWidget]

  temporary_table_tm = {}
  temporary_table_tm_level = {}
  temporary_table_tm_cooldown = {}

  if tmMoves:getChildById("moveCount"..globalSelectedWidget) then

    tmMoves:getChildById("moveCount"..globalSelectedWidget):setIcon("/elements/" ..widgetImage4 .. ".png")
    tmAvaiables:getChildById("TMCount"..index):setImageSource("/elements/" ..widgetImage5.. ".png")

--[[     print(widgetImage4 .. " - " .. widgetImage5) ]]
    tmMoves:getChildById("moveCount"..globalSelectedWidget):setTooltip("Nome: "..widgetImage1.."\nNível: " .. widgetLevel1 .. "\nCooldown: " .. widgetCooldown1)
    tmAvaiables:getChildById("TMCount"..index):setTooltip("Nome: "..widgetImage2.."\nNível: " .. widgetLevel2 .. "\nCooldown: " .. widgetCooldown2)


    tm_avaiable_list[index] = widgetImage2
    tm_avaiable_list_element[index] = widgetImage5

    tm_avaiable_list_level[index] = widgetLevel2
    tm_avaiable_list_cooldown[index] = widgetCooldown2

    iconList[globalSelectedWidget] = widgetImage1
    iconLevel[globalSelectedWidget] = widgetLevel1
    iconCooldown[globalSelectedWidget] = widgetCooldown1
    iconElement[globalSelectedWidget] = widgetImage4

    table.insert(temporary_table_tm, widgetImage2)
    table.insert(temporary_table_tm_level, widgetLevel2)
    table.insert(temporary_table_tm_level, widgetCooldown2)
  end

  for i = 1, #tm_avaiable_list do
    if tm_avaiable_list[i] ~= temporary_table_tm[i] then
      table.insert(temporary_table_tm, tm_avaiable_list[i])
      table.insert(temporary_table_tm_level, tm_avaiable_list_level[i])
      table.insert(temporary_table_tm_cooldown, tm_avaiable_list_cooldown[i])
    end
  end

  local function enviar()
    for i = 1, #temporary_table_tm do
      if temporary_table_tm_level[i] ~= nil and temporary_table_tm_cooldown[i] ~= nil then
        g_game.getProtocolGame():sendExtendedOpcode(135, i.."@"..temporary_table_tm[i].."@"..temporary_table_tm_level[i].."@"..temporary_table_tm_cooldown[i].."@")
        sendModification()
  
        temporary_table_tm[i] = nil
        temporary_table_tm_level[i] = nil
        temporary_table_tm_cooldown[i] = nil
      end
    end
  end

  up.onClick = function() mudarTMMove2(index, movename, lockin, typee) end
  confirmar:setOn(true)
  confirmar:setOpacity(100)
  confirmar.onClick = function() enviar() end

  alterar = false
end

-- Alternar um TM para cima
function selectUp(index, movename, lockin, typee)
  up:show()
  up.onClick = function() mudarTMMove(index, movename, lockin, typee) end
end

-- Nao alternar nenhum TM
function selectUpFalse()
  up:hide()
  up.onClick = function() end
end

function setAvaiablesTMs(index, movename, total, lockin, typee, movelevel, movecooldown, specialParam, element)
  -- Verificar se o parametro recebido corresponde a specialParam e se o tm esta bloqueado
  if specialParam == "specialParam" and lockin ~= "lockedOpacity"  then
    local child = tmAvaiables:getChildById("TMCount"..index)
    if child then
        tmAvaiables:getChildById("TMCount"..index):setOpacity(100)
        tmAvaiables:getChildById("TMCount"..index):setOpacity(100)
        tmAvaiables:getChildById("TMCount"..index).onClick = function() selectUpFalse() end

        child:getChildById("value"..index):setOpacity(100)
        child:getChildById("value"..index):setOpacity(100)

        child:getChildById("type"..index):setOpacity(100)
        child:getChildById("type"..index):setOpacity(100)
    end
  end

  -- Verificar se o parametro recebido corresponde a specialParam e se o tm esta desbloqueado
  if specialParam == "specialParam" and lockin == "lockedOpacity"  then
    local child = tmAvaiables:getChildById("TMCount"..index)
    if child then
      tmAvaiables:getChildById("TMCount"..index):setOpacity(100)
      tmAvaiables:getChildById("TMCount"..index):setOpacity(100)
      tmAvaiables:getChildById("TMCount"..index).onClick = function() selectUp(index, movename, lockin, typee) end

      child:getChildById("value"..index):setOpacity(0.79)
      child:getChildById("value"..index):setOpacity(0.79)

      child:getChildById("type"..index):setOpacity(100)
      child:getChildById("type"..index):setOpacity(100)
    end
  end

  -- Se caso ele nao estiver na lista do tm_avaiable_list (nao encontrar no index)
  if not tm_avaiable_list[index] then
    local movesImage = g_ui.createWidget("UIButton", tmAvaiables)

    -- Acrescentar os movimentos, leveis deles, cooldown deles, em uma lista
    tm_avaiable_list[index] = movename
    tm_avaiable_list_element[index] = element
    tm_avaiable_list_level[index] = movelevel
    tm_avaiable_list_cooldown[index] = movecooldown

    -- Se caso a janela de TM nao tiver sido ocultada alguma vez
    if hided == false then
      movesImage:setId("TMCount"..index)

      local value = g_ui.createWidget("UIButton", movesImage)
      value:setId("value"..index)
      value:addAnchor(AnchorTop, "parent", AnchorTop)
      value:addAnchor(AnchorLeft, "parent", AnchorLeft)

      value:setMarginTop(20)
      value:setMarginLeft(-4)

      if lockin == "lockedOpacity" then
        value:setImageSource("images/type/locked")
        value:setOpacity(0.79)
      else
        value:setImageSource("images/type/"..lockin)
        tmAvaiables:getChildById("TMCount"..index).onClick = function() selectUpFalse() end
      end

      local type = g_ui.createWidget("UIButton", movesImage)
      type:setId("type"..index)
      type:addAnchor(AnchorTop, "parent", AnchorTop)
      type:addAnchor(AnchorLeft, "parent", AnchorLeft)

      type:setMarginTop(20)
      type:setMarginLeft(10)
      type:setImageSource("images/type/"..typee)
    end

    -- Se caso o child existir
    if tmAvaiables:getChildById("TMCount"..index) then
      tmAvaiables:getChildById("TMCount"..index):show()
      tmAvaiables:getChildById("TMCount"..index):setImageSource("/elements/"..element..".png")
      tmAvaiables:getChildById("TMCount"..index):setTooltip("Nome: "..movename.."\nNível: " .. movelevel .. "\nCooldown: " .. movecooldown)

      local child = tmAvaiables:getChildById("TMCount"..index)

      tmAvaiables:getChildById("TMCount"..index):setOpacity(100)
      tmAvaiables:getChildById("TMCount"..index):setOpacity(100)

      if lockin == "lockedOpacity" then
        child:getChildById("value"..index):setImageSource("images/type/normal")
        child:getChildById("value"..index):setOpacity(0.79)
      else
        child:getChildById("value"..index):setImageSource("images/type/"..lockin)
        tmAvaiables:getChildById("TMCount"..index).onClick = function() selectUpFalse() end
      end

      child:getChildById("type"..index):setImageSource("images/type/"..typee)
    end
  end

  if tmAvaiables:getChildById("TMCount"..index) then
    tmAvaiables:getChildById("TMCount"..index):setImageSource("/elements/"..element..".png")
    tmAvaiables:getChildById("TMCount"..index):setTooltip("Nome: "..movename.."\nNível: " .. movelevel .. "\nCooldown: " .. movecooldown)

    if total > 11 and index > 11 then
      tmAvaiables:getChildById("TMCount"..index):setMarginTop(25)
      tmAvaiables:getChildById("TMCount"..index):setMarginBottom(-20)
      tmAvaiables:getChildById("TMCount"..index):setMarginLeft(14)
      tmAvaiables:getChildById("TMCount"..index):setMarginRight(-9)
    else
      tmAvaiables:getChildById("TMCount"..index):setMarginTop(11)
      tmAvaiables:getChildById("TMCount"..index):setMarginBottom(-8)
      tmAvaiables:getChildById("TMCount"..index):setMarginLeft(14)
      tmAvaiables:getChildById("TMCount"..index):setMarginRight(-9)
    end

    if enabled == false then
      tmAvaiables:getChildById("TMCount"..index):setOpacity(0.25)
      tmAvaiables:getChildById("TMCount"..index):setOpacity(0.25)
      tmAvaiables:getChildById("TMCount"..index).onClick = function() selectUpFalse() end

      if tmAvaiables:getChildById("value"..index) then
        tmAvaiables:getChildById("value"..index):setOpacity(0.80)
        tmAvaiables:getChildById("value"..index):setOpacity(0.80)

        tmAvaiables:getChildById("type"..index):setOpacity(0.80)
        tmAvaiables:getChildById("type"..index):setOpacity(0.80)
      end
    end
  end
end

function unloadProperties()
  for i = 1, 12 do
    if tmMoves:getChildById("moveCount"..i) then
      tmMoves:getChildById("moveCount"..i):setIcon("")
      iconList[i] = nil
      iconLevel[i] = nil
      iconCooldown[i] = nil
      iconTooltip[i] = nil
      iconElement[i] = nil

      left:setOn(false)
      left:setOpacity(0.40)

      right:setOn(false)
      right:setOpacity(0.40)

      up:setOn(false)
      up:setOpacity(0.40)

      selectUpFalse()

      left.onClick = function() end
      right.onClick = function() end

      confirmar:setOn(false)
      confirmar:setOpacity(0.40)
      confirmar.onClick = function() end
    end
  end

  for index = 1, #tm_avaiable_list do
    local child = tmAvaiables:getChildById("TMCount"..index)

    if child then
      tmAvaiables:getChildById("TMCount"..index):setOpacity(0.25)
      tmAvaiables:getChildById("TMCount"..index):setOpacity(0.25)
      tmAvaiables:getChildById("TMCount"..index).onClick = function() end

      tmAvaiables:getChildById("TMCount"..index):setImageSource("")

      child:getChildById("value"..index):setOpacity(0.80)
      child:getChildById("value"..index):setOpacity(0.80)

      child:getChildById("type"..index):setOpacity(0.80)
      child:getChildById("type"..index):setOpacity(0.80)
    end
  end
end


function unloadPropertiesTMAvaiables()
  for index = 1, 20 do
    local child = tmAvaiables:getChildById("TMCount"..index)

    if child then
      tmAvaiables:getChildById("TMCount"..index):setOpacity(0.25)
      tmAvaiables:getChildById("TMCount"..index):setOpacity(0.25)
      tmAvaiables:getChildById("TMCount"..index).onClick = function() end

      tmAvaiables:getChildById("TMCount"..index):setTooltip("")
      tmAvaiables:getChildById("TMCount"..index):setImageSource("")

      child:getChildById("type"..index):setImageSource("")
      child:getChildById("value"..index):setImageSource("")

      child:getChildById("type"..index):setOpacity(0.80)
      child:getChildById("type"..index):setOpacity(0.80)
    end
  end
end

ProtocolGame.registerExtendedOpcode(70, function(protocol, opcode, buffer) -- receive tm
  local param = buffer:split("@")
  local totalMoves = tonumber(param[2])

  if param[1] == "openTm" then
    --tmButton:setOn(true)
    tm:show()

    detectTam(totalMoves) -- determinar o tamanho da janela de moves
  end
end)

ProtocolGame.registerExtendedOpcode(71, function(protocol, opcode, buffer) -- receive moves
  local param = buffer:split("@")
  local count = tonumber(param[1])
  local movename = param[2]
  local movelevel = tonumber(param[3])
  local movecooldown = tonumber(param[4])
  local totalMoves = tonumber(param[5])
  local totalMoves2 = tonumber(param[6])
  local element = tostring(param[7])

  if count > 0 then
    setMoves(count, movename, movelevel, movecooldown, totalMoves, totalMoves2, element)
  end
end)

ProtocolGame.registerExtendedOpcode(72, function(protocol, opcode, buffer) -- destroy window back pokemon
  local param = buffer:split("@")

  if param[1] == "destroyTM" then
    allMovesAvailables:destroyChildren()
    tmAvaiables:destroyChildren()
    
    for i = 1, #iconList do
      iconList[i] = nil
      iconLevel[i] = nil
      iconCooldown[i] = nil
      iconTooltip[i] = nil
      iconElement[i] = nil
    end
  
    for index = 1, #tm_avaiable_list do
      tm_avaiable_list[index] = nil
      tm_avaiable_list_level[index] = nil
      tm_avaiable_list_cooldown[index] = nil
      tm_avaiable_list_element[index] = nil
    end

    enabled = false
    alterar = true
    hided = false

    left:setOn(false)
    left:setOpacity(0.40)

    right:setOn(false)
    right:setOpacity(0.40)

    up:setOn(false)
    up:setOpacity(0.40)

    selectUpFalse()

    left.onClick = function() end
    right.onClick = function() end
    --naoexibir()
  end

  if param[1] == "hideTM" and tm:isVisible() then
    tm:hide()
  end
end)

ProtocolGame.registerExtendedOpcode(73, function(protocol, opcode, buffer) -- receive pokemon TM avaiables
  local param = buffer:split("@")
  local index = tonumber(param[2])
  local movename = param[3]
  local total = tonumber(param[4])
  local lockin = param[5]
  local typee = param[6]

  local movelevel = tonumber(param[7])
  local movecooldown = tonumber(param[8])

  local specialParam = param[9]
  local element = tostring(param[10])
  if element ~= "" then
    if param[1] == "receiveTMs" and index > 0 then
      setAvaiablesTMs(index, movename, total, lockin, typee, movelevel, movecooldown, specialParam, element)
    end
    
    if param[1] == "receiveTMs" and index <= 0 then
      enabled = false
      alterar = true

      unloadPropertiesTMAvaiables()
    end
  end
end)

ProtocolGame.registerExtendedOpcode(79, function(protocol, opcode, buffer) -- receive account tms
  local param = buffer:explode("@")
  local movename = tostring(param[1])
  local movelevel = tonumber(param[2])
  local movecooldown = tonumber(param[3])
  local element = tostring(param[4])

  local tmsAvailables = g_ui.createWidget("UIButton", allMovesAvailables)
  tmsAvailables:setMarginTop(16)
  tmsAvailables:setMarginLeft(26)
  tmsAvailables:setIcon("/elements/" .. element .. ".png")
  tmsAvailables:setTooltip("Nome: "..movename.."\nNível: " .. movelevel .. "\nCooldown: " .. movecooldown)
end)

function showAllTMS()
  tmMoves:hide()
  tmAvaiables:hide()
  resetar:hide()
  movesReady:hide()
  showAllTMSWidget:hide()

  left:hide()
  right:hide()
  up:hide()

  allMovesAvailables:show()
end