-- Criado por Thalles Vitor --
-- Sistema de Banco --

local bank = g_ui.displayUI("playerbank")
local bankBtn = nil

-- Others
local welcomeMessage = bank:getChildById("welcomeMessage")
local categoryBtn = bank:getChildById("categoryBtn")

-- Buttons
local depositBtn = bank:getChildById("depositBtn")
local deposit_text = bank:getChildById("deposit_text")
local withdrawBtn = bank:getChildById("withdrawBtn")
local withdraw_text = bank:getChildById("withdraw_text")
local transferBtn = bank:getChildById("transferBtn")
local transfer_text = bank:getChildById("transfer_text")
local extractBtn =  bank:getChildById("extractBtn")
local extract_text = bank:getChildById("extract_text")
local backBtn = bank:getChildById("backBtn")
local backBtn_text = bank:getChildById("backBtn_text")

-- Deposit
local valueLabel = bank:getChildById("valueLabel")
local value = bank:getChildById("value")
local value_separator = bank:getChildById("value_separator")
local moneyCountLabel = bank:getChildById("moneyCountLabel")
local confirmDepositBtn = bank:getChildById("confirmDepositBtn")

-- Transfer
local valueLabel_Transfer = bank:getChildById("valueLabel_Transfer")
local value_transfer = bank:getChildById("value_transfer")
local value_transfer_separator = bank:getChildById("value_transfer_separator")
local moneyCountLabel_Transfer = bank:getChildById("moneyCountLabel_Transfer")
local toLabel = bank:getChildById("toLabel")
local value_transferTo = bank:getChildById("value_transferTo")
local value_transferTo_separator = bank:getChildById("value_transferTo_separator")
local confirmTransferBtn = bank:getChildById("confirmTransferBtn")
local extractList = bank:getChildById("extractList")
local extractScrollBar = bank:getChildById("extractScrollBar")

-- Opcodes (Cliente para Servidor)
local bankSendReceiveSaldo = 205 -- opcode para enviar para o servidor que ele deve enviar de volta o saldo
local bankSendDepositValue = 206 -- opcode para enviar que o player vai depositar um valor
local bankSendWithdrawValue = 207 -- opcode para enviar que o player deve sacar o valor
local bankSendTransferValue = 208 -- opcode para enviar que o player deve fazer a transferencia

-- Opcodes (Servidor para Cliente)
local bankReceiveSaldo = 245 -- opcode para receber do servidor o saldo
local bankReceiveHistory = 247 -- opcode para receber o historico do player

globalMoney = "0"
confirmWindow = nil
function init()
  connect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  --bankBtn = modules.client_topmenu.addRightGameToggleButton('bankBtn', tr('Bank'), 'images/bank.png', exibir)
  --bankBtn:setOn(false)
  bank:hide()
end

function terminate()
  disconnect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  if confirmWindow then
    confirmWindow:destroy()
    confirmWindow=nil
  end

  -- Opcodes Unregister
  ProtocolGame.unregisterExtendedOpcode(bankReceiveSaldo)
  ProtocolGame.unregisterExtendedOpcode(bankReceiveHistory)

  --bankBtn:setOn(false)
  bank:hide()
end

function exibir()
  if bank:isVisible() then
    --bankBtn:setOn(false)
    bank:hide()

    changeCategory("none")
  else
   -- bankBtn:setOn(true)
    bank:show()

    loadFunc()
    g_game.getProtocolGame():sendExtendedOpcode(bankSendReceiveSaldo, "receiveOpenWindow".."@")
  end
end

function naoexibir()
  changeCategory("none")

 -- bankBtn:setOn(false)
  bank:hide()
end

function loadFunc()
  if not g_game.isOnline() then
    return
  end

  local player = g_game.getLocalPlayer()
  welcomeMessage:setText("Olá bem-vindo(a). " .. string.upper(player:getName()) .. ", SEU SALDO É 0 HDS (~0 HD)")

  depositBtn.onHoverChange = function(self, hasHovered)
    if hasHovered then
      depositBtn:setImageSource("images/deposit_hover.png")
      deposit_text:setOpacity(100)
    else
      depositBtn:setImageSource("images/deposit.png")
      deposit_text:setOpacity(0.60)
    end
  end

  withdrawBtn.onHoverChange = function(self, hasHovered)
    if hasHovered then
      withdrawBtn:setImageSource("images/withdraw_hover.png")
      withdraw_text:setOpacity(100)
    else
      withdrawBtn:setImageSource("images/withdraw.png")
      withdraw_text:setOpacity(0.60)
    end
  end

  transferBtn.onHoverChange = function(self, hasHovered)
    if hasHovered then
      transferBtn:setImageSource("images/transfer_hover.png")
      transfer_text:setOpacity(100)
    else
      transferBtn:setImageSource("images/transfer.png")
      transfer_text:setOpacity(0.60)
    end
  end

  extractBtn.onHoverChange = function(self, hasHovered)
    if hasHovered then
      extractBtn:setImageSource("images/extract_hover.png")
      extract_text:setOpacity(100)
    else
      extractBtn:setImageSource("images/extract.png")
      extract_text:setOpacity(0.60)
    end
  end
end

function changeCategory(selfId)
  g_game.getProtocolGame():sendExtendedOpcode(bankSendReceiveSaldo, selfId.."@")
  if selfId == "depositBtn" then
    depositBtn:setVisible(false)
    deposit_text:setVisible(false)
    withdrawBtn:setVisible(false)
    withdraw_text:setVisible(false)
    transferBtn:setVisible(false)
    transfer_text:setVisible(false)
    extractBtn:setVisible(false)
    extract_text:setVisible(false)

    backBtn:setVisible(true)
    backBtn_text:setVisible(true)

    backBtn.onHoverChange = function(self, hasHovered)
      if hasHovered then
        backBtn:setImageSource("images/back_hover.png")
        backBtn_text:setOpacity(100)
      else
        backBtn:setImageSource("images/back.png")
        backBtn_text:setOpacity(0.60)
      end
    end
    
    valueLabel:setVisible(true)
    value:setVisible(true)

    value_separator:setVisible(true)
    moneyCountLabel:setVisible(true)
    confirmDepositBtn:setVisible(true)
    confirmDepositBtn:setText("DEPOSITAR")
    confirmDepositBtn.onClick = function()
      if value:getText() == "" then return end

      yesCallback = function()
        g_game.getProtocolGame():sendExtendedOpcode(bankSendDepositValue, value:getText().."@")
        if confirmWindow then
          confirmWindow:hide()
          confirmWindow=nil
        end
      end

      yesCallback2 = function()
        g_game.getProtocolGame():sendExtendedOpcode(bankSendDepositValue, tostring(globalMoney).."@")
        if confirmWindow then
          confirmWindow:hide()
          confirmWindow=nil
        end
      end
  
      local noCallback = function()
        confirmWindow:hide()
        confirmWindow=nil
      end
      
      confirmWindow = displayGeneralBox(tr('Depositar'), tr("Escolha uma das opções"), {
        { text=tr('Depositar'), callback=yesCallback },
        { text=tr('Tudo'), callback=yesCallback2 },
        { text=tr('Cancelar'), callback=noCallback },
        anchor=AnchorHorizontalCenter}, yesCallback, noCallback)
    end

    categoryBtn:setVisible(true)
    categoryBtn:setImageSource("images/deposit.png")

    valueLabel_Transfer:setVisible(false)
    value_transfer:setVisible(false)
    value_transfer_separator:setVisible(false)

    moneyCountLabel_Transfer:setVisible(false)
    toLabel:setVisible(false)
    value_transferTo:setVisible(false)
    value_transferTo_separator:setVisible(false)
    confirmTransferBtn:setVisible(false)
    extractList:setVisible(false)
    extractScrollBar:setVisible(false)
  elseif selfId == "withdrawBtn" then
    depositBtn:setVisible(false)
    deposit_text:setVisible(false)
    withdrawBtn:setVisible(false)
    withdraw_text:setVisible(false)
    transferBtn:setVisible(false)
    transfer_text:setVisible(false)
    extractBtn:setVisible(false)
    extract_text:setVisible(false)

    backBtn:setVisible(true)
    backBtn_text:setVisible(true)

    backBtn.onHoverChange = function(self, hasHovered)
      if hasHovered then
        backBtn:setImageSource("images/back_hover.png")
        backBtn_text:setOpacity(100)
      else
        backBtn:setImageSource("images/back.png")
        backBtn_text:setOpacity(0.60)
      end
    end
    
    valueLabel:setVisible(true)
    value:setVisible(true)
    value_separator:setVisible(true)
    moneyCountLabel:setVisible(true)
    confirmDepositBtn:setVisible(true)
    confirmDepositBtn:setText("SACAR")
    confirmDepositBtn.onClick = function()
      if value:getText() == "" then return end
      yesCallback = function()
        g_game.getProtocolGame():sendExtendedOpcode(bankSendWithdrawValue, value:getText().."@")
        if confirmWindow then
          confirmWindow:hide()
          confirmWindow=nil
        end
      end

      yesCallback2 = function()
        g_game.getProtocolGame():sendExtendedOpcode(bankSendWithdrawValue, tostring(globalMoney).."@")
        if confirmWindow then
          confirmWindow:hide()
          confirmWindow=nil
        end
      end
  
      local noCallback = function()
        confirmWindow:hide()
        confirmWindow=nil
      end
      
      confirmWindow = displayGeneralBox(tr('Sacar'), tr("Escolha uma das opções"), {
        { text=tr('Sacar'), callback=yesCallback },
        { text=tr('Tudo'), callback=yesCallback2 },
        { text=tr('Cancelar'), callback=noCallback },
        anchor=AnchorHorizontalCenter}, yesCallback, noCallback)
    end

    categoryBtn:setVisible(true)
    categoryBtn:setImageSource("images/withdraw.png")

    valueLabel_Transfer:setVisible(false)
    value_transfer:setVisible(false)
    value_transfer_separator:setVisible(false)

    moneyCountLabel_Transfer:setVisible(false)
    toLabel:setVisible(false)
    value_transferTo:setVisible(false)
    value_transferTo_separator:setVisible(false)
    confirmTransferBtn:setVisible(false)
    extractList:setVisible(false)
    extractScrollBar:setVisible(false)
  elseif selfId == "transferBtn" then
    depositBtn:setVisible(false)
    deposit_text:setVisible(false)
    withdrawBtn:setVisible(false)
    withdraw_text:setVisible(false)
    transferBtn:setVisible(false)
    transfer_text:setVisible(false)
    extractBtn:setVisible(false)
    extract_text:setVisible(false)

    backBtn:setVisible(true)
    backBtn_text:setVisible(true)

    backBtn.onHoverChange = function(self, hasHovered)
      if hasHovered then
        backBtn:setImageSource("images/back_hover.png")
        backBtn_text:setOpacity(100)
      else
        backBtn:setImageSource("images/back.png")
        backBtn_text:setOpacity(0.60)
      end
    end
    
    valueLabel:setVisible(false)
    value:setVisible(false)
    value_separator:setVisible(false)
    moneyCountLabel:setVisible(false)

    confirmDepositBtn:setText("DEPOSITAR")
    confirmDepositBtn:setVisible(false)

    categoryBtn:setVisible(true)
    categoryBtn:setImageSource("images/transfer.png")
    
    valueLabel_Transfer:setVisible(true)
    value_transfer:setVisible(true)
    value_transfer_separator:setVisible(true)

    moneyCountLabel_Transfer:setVisible(true)
    toLabel:setVisible(true)
    value_transferTo:setVisible(true)
    value_transferTo_separator:setVisible(true)

    confirmTransferBtn:setVisible(true)
    confirmTransferBtn.onClick = function()
      if value_transferTo:getText() == "" then return end
      g_game.getProtocolGame():sendExtendedOpcode(bankSendTransferValue, value_transfer:getText().."@"..value_transferTo:getText().."@")
    end

    extractList:setVisible(false)
    extractScrollBar:setVisible(false)
  elseif selfId == "extractBtn" then
    depositBtn:setVisible(false)
    deposit_text:setVisible(false)
    withdrawBtn:setVisible(false)
    withdraw_text:setVisible(false)
    transferBtn:setVisible(false)
    transfer_text:setVisible(false)
    extractBtn:setVisible(false)
    extract_text:setVisible(false)

    backBtn:setVisible(true)
    backBtn_text:setVisible(true)

    backBtn.onHoverChange = function(self, hasHovered)
      if hasHovered then
        backBtn:setImageSource("images/back_hover.png")
        backBtn_text:setOpacity(100)
      else
        backBtn:setImageSource("images/back.png")
        backBtn_text:setOpacity(0.60)
      end
    end
    
    valueLabel:setVisible(false)
    value:setVisible(false)
    value_separator:setVisible(false)
    moneyCountLabel:setVisible(false)

    confirmDepositBtn:setText("DEPOSITAR")
    confirmDepositBtn:setVisible(false)

    categoryBtn:setVisible(true)
    categoryBtn:setImageSource("images/extract.png")
    
    valueLabel_Transfer:setVisible(false)
    value_transfer:setVisible(false)
    value_transfer_separator:setVisible(false)

    moneyCountLabel_Transfer:setVisible(false)
    toLabel:setVisible(false)
    value_transferTo:setVisible(false)
    value_transferTo_separator:setVisible(false)
    confirmTransferBtn:setVisible(false)
    extractList:setVisible(true)
    extractScrollBar:setVisible(true)
  else
    depositBtn:setVisible(true)
    deposit_text:setVisible(true)
    withdrawBtn:setVisible(true)
    withdraw_text:setVisible(true)
    transferBtn:setVisible(true)
    transfer_text:setVisible(true)
    extractBtn:setVisible(true)
    extract_text:setVisible(true)

    backBtn:setVisible(false)
    backBtn_text:setVisible(false)
    
    valueLabel:setVisible(false)
    value:setVisible(false)
    value_separator:setVisible(false)
    moneyCountLabel:setVisible(false)

    confirmDepositBtn:setText("DEPOSITAR")
    confirmDepositBtn:setVisible(false)
    confirmDepositBtn.onClick = function() end

    categoryBtn:setVisible(false)
    categoryBtn:setImageSource("")

    valueLabel_Transfer:setVisible(false)
    value_transfer:setVisible(false)
    value_transfer_separator:setVisible(false)

    moneyCountLabel_Transfer:setVisible(false)
    toLabel:setVisible(false)
    value_transferTo:setVisible(false)
    value_transferTo_separator:setVisible(false)
    confirmTransferBtn:setVisible(false)
    confirmTransferBtn.onClick = function()
    end

    extractList:setVisible(false)
    extractScrollBar:setVisible(false)
  end
end

ProtocolGame.registerExtendedOpcode(bankReceiveSaldo, function(protocol, opcode, buffer) -- receive MONEY
  local param = buffer:split("@")
  local cents = tonumber(param[1])
  local hd = tostring(param[2])
  local typee = tostring(param[3])
  globalMoney = hd

  if typee == "receiveOpenWindow" then
    local player = g_game.getLocalPlayer()
    welcomeMessage:setText("BEM VINDO " .. string.upper(player:getName()) .. ", SEU SALDO É "..cents.." HDS (~ "..hd..")")
  end

  if typee == "depositBtn" then
    moneyCountLabel:setText("Você tem "..cents.." hds (~ "..hd..")")
  end

  if typee == "withdrawBtn" then
    moneyCountLabel:setText("Você tem "..cents.." hds (~ "..hd..")")
  end

  if typee == "transferBtn" then
    moneyCountLabel_Transfer:setText("Você tem "..cents.." hds (~ "..hd..")")
  end
end)

ProtocolGame.registerExtendedOpcode(bankReceiveHistory, function(protocol, opcode, buffer) -- receive history of player
  local param = buffer:split("@")
  local history = tostring(param[1])

  extractList:destroyChildren()
  scheduleEvent(function()
    local label = g_ui.createWidget("Label", extractList)
    label:setText(history)
  end, 100)
end)