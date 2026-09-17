-- Criado por Thalles Vitor --
-- Online Reward --
local redeem = g_ui.displayUI("redeem")
local reedemEdit = redeem:getChildById("reedemEdit")
local reedemBtn = redeem:getChildById("reedemBtn")
local redeemBtn = nil

function init()
  connect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  redeemBtn = modules.client_topmenu.addLeftGameToggleButton('redeemBtn', tr('Resgatar Códigos'), '/images/topbuttons/redeem_hover', exibir)
  redeemBtn:setOn(false)

  redeem:hide()
end

function terminate()
  disconnect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  redeem:hide()
  redeemBtn:setOn(false)
end

function exibir()
  if redeem:isVisible() then
    redeem:hide()
    redeemBtn:setOn(false)
  else
    redeem:show()
    redeemBtn:setOn(true)
    
    reedemEdit.onTextChange = function(self, text)
      if text == "" then
        reedemBtn:setEnabled(false)
        reedemBtn.onClick = function() end
        return false
      end

      reedemBtn:setEnabled(true)
      reedemBtn.onClick = function()
        resgatar()
      end
    end
  end
end

function naoexibir()
  redeem:hide()
  redeemBtn:setOn(false)
end

function resgatar()
  local texto = reedemEdit:getText()
  if texto == "" then
    return true
  end
  
  g_game.talk("!redeem " ..texto)
end