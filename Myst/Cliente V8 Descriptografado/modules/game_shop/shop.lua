-- Criado por Thalles Vitor --
-- Sistema de Shop --

local shop = g_ui.displayUI("shop")
local categoryPanel = shop:getChildById("categoryPanel")
local itemsPanel = shop:getChildById("itemsPanel")
local pointsLabel = shop:getChildById("pointsLabel")
local shopButton = nil

-- Opcodes - Cliente
local SHOP_SENDOPENOPCODE = 5 -- enviar para o servidor que ele deve abrir o shop
local SHOP_SENDCHANGECATEGORYOPCODE = 6 -- enviar para o servidor que ele deve alternar a categoria

-- Opcodes - Servidor
local SHOPDESTROY_OPCODE = 4
local SHOP_CATEGORYOPCODE = 5
local SHOP_OPENOPCODE = 6

function init()
  connect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  shopButton = modules.client_topmenu.addRightGameToggleButton('shopButton', tr('Shop') .. ' (Ctrl+P)', '/images/topbuttons/shop', exibir)
  shopButton:setOn(false)

  shop:hide()
end

function terminate()
  disconnect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  if buyWindow then
    buyWindow:hide()
    buyWindow=nil
  end

  shop:hide()
  shopButton:setOn(false)
end

function exibir()
  if shopButton:isOn() then
    shop:hide()
    shopButton:setOn(false)
  else
    if not g_game.isOnline() then
      return true
    end

    g_game.getProtocolGame():sendExtendedOpcode(SHOP_SENDOPENOPCODE)
  end
end

function naoexibir()
  if buyWindow then
    buyWindow:hide()
    buyWindow=nil
  end
  
  shop:hide()
end

ProtocolGame.registerExtendedOpcode(SHOPDESTROY_OPCODE, function(protocol, opcode, buffer) -- destroy childrens
  local param = buffer:explode("@")
  itemsPanel:destroyChildren()
  categoryPanel:destroyChildren()
end)

ProtocolGame.registerExtendedOpcode(SHOP_CATEGORYOPCODE, function(protocol, opcode, buffer) -- receive options
  local param = buffer:explode("@")
  local option = tostring(param[1])

  local buttonOption = g_ui.createWidget("UIButton", categoryPanel)
  buttonOption:setSize("101 45")
  buttonOption:setImageSource("images/button.png")
  buttonOption:setText(option)
  buttonOption:setMarginTop(2)
  buttonOption:setFont("sans-bold-16px")
  buttonOption:setColor("#cda953")

  if option ~= "Doar" and option ~= "Promoções" then
    buttonOption.onClick = function() -- change category
      if not g_game.isOnline() then
        return true
      end

      itemsPanel:destroyChildren()
      categoryPanel:destroyChildren()
      g_game.getProtocolGame():sendExtendedOpcode(SHOP_SENDCHANGECATEGORYOPCODE, option.."@")
    end
  end

  buttonOption.onHoverChange = function(self, hovered)
    if hovered then
      buttonOption:setImageSource("images/button_hover.png")
    else
      buttonOption:setImageSource("images/button.png")
    end
  end

  if option == "Doar" then
    buttonOption.onClick = function()
      modules.game_pix.exibir()
    end
  end

  if option == "Promoções" then
    buttonOption.onClick = function()
      g_game.talk("!promo")
    end
  end
end)

ProtocolGame.registerExtendedOpcode(SHOP_OPENOPCODE, function(protocol, opcode, buffer) -- receive options
  local param = buffer:explode("@")
  local itemId = tonumber(param[1])
  local itemName = tostring(param[2])
  local itemPrice = tonumber(param[3])
  local pointsPlayer = tonumber(param[4])
  
  shop:show()
  shopButton:setOn(true)

  local shopButton = g_ui.createWidget("UIButton", itemsPanel)
  shopButton:setSize("102 125")
  shopButton:setMarginTop(25)
  shopButton:setMarginLeft(15)

  local item = g_ui.createWidget("UIItem", shopButton)
  item:addAnchor(AnchorTop, "parent", AnchorTop)
  item:addAnchor(AnchorLeft, "parent", AnchorLeft)
  item:setSize("45 45")
  item:setItemId(itemId)
  item:setMarginTop(15)
  item:setMarginLeft(17)

  local name = g_ui.createWidget("ItemLabel", shopButton)
  name:addAnchor(AnchorTop, "parent", AnchorTop)
  name:addAnchor(AnchorLeft, "parent", AnchorLeft)
  name:setText(itemName)
  name:setColor("white")
  name:setMarginTop(-3)
  name:setMarginLeft(3)

  local points = g_ui.createWidget("ItemLabel", shopButton)
  points:addAnchor(AnchorTop, "parent", AnchorTop)
  points:addAnchor(AnchorLeft, "parent", AnchorLeft)
  points:setText(itemPrice .. " pontos")
  points:setColor("white")
  points:setMarginTop(61)
  points:setMarginLeft(15)

  local button = g_ui.createWidget("UIButton", shopButton)
  button:addAnchor(AnchorTop, "parent", AnchorTop)
  button:addAnchor(AnchorLeft, "parent", AnchorLeft)
  button:setImageSource("images/button.png")
  button:setSize("100 26")
  button:setText("Comprar")
  button:setFont("sans-bold-16px")
  button:setColor("#cda953")
  button:setMarginTop(78)
  button:setMarginLeft(-7)
  button.onClick = function() -- buy product
    if not modules.client_options.getOption('shopQuestion') then
      yesCallback = function()
        g_game.talk("!shop " .. itemName)
        if buyWindow then
          buyWindow:hide()
          buyWindow=nil
        end
      end

      local noCallback = function()
        buyWindow:hide()
        buyWindow=nil
      end
      
      buyWindow = displayGeneralBox(tr('Carrinho'), tr("Finalizar compra?"), {
        { text=tr('Yes'), callback=yesCallback },
        { text=tr('No'), callback=noCallback },
        anchor=AnchorHorizontalCenter}, yesCallback, noCallback)
      else
        g_game.talk("!shop " .. itemName)
      end
  end

  button.onHoverChange = function(self, hovered)
    if hovered then
      button:setImageSource("images/button_hover.png")
    else
      button:setImageSource("images/button.png")
    end
  end

  pointsLabel:setText("Seus Pontos: " .. pointsPlayer)
end)

function getShop()
  return shop
end