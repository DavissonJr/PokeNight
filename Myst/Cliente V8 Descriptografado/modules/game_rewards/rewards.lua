-- Criado por Thalles Vitor --
-- Sistema de Recompensa Diaria --
local rewards = g_ui.displayUI("rewards")
local rewardsPanel = rewards:getChildById("rewardsPanel")
local reinvidicar = rewards:getChildById("reinvidicar")

-- Server to Client
local rewardWindowOPCODE = 203 -- opcode da janela de recompensas
local rewardWindowDESTROYOPCODE = 204 -- opcode da janela para destruir widgets dos panels

-- Client to Server
local rewardConfirmOPCODE = 209 -- opcode para enviar para o servidor que confirmou

function init()
  connect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  rewards:hide()
end

function terminate()
  disconnect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  ProtocolGame.unregisterExtendedOpcode(rewardWindowOPCODE)
  rewards:hide()
end

function exibir()
  rewards:hide()
end

function naoexibir()
  rewards:hide()
end

ProtocolGame.registerExtendedOpcode(rewardWindowDESTROYOPCODE, function(protocol, opcode, buffer) -- destroy children
  local param = buffer:explode("@")
  local typee = tostring(param[1])

  if typee == "destroy" then
    rewardsPanel:destroyChildren()
  end
end)

ProtocolGame.registerExtendedOpcode(rewardWindowOPCODE, function(protocol, opcode, buffer) -- receive daily reward
  local param = buffer:explode("@")
  local typee = tostring(param[1])
  local items = tonumber(param[2])
  local count = tonumber(param[3])
  local day = tonumber(param[4])
  local unlocked = tostring(param[5])
  local collected = tostring(param[6])

  if typee == "show" then
    g_effects.fadeIn(rewards, 1000)
    rewards:show()

    local item = g_ui.createWidget("Item", rewardsPanel)
    item:setItemId(items)
    item:setItemCount(count)

    item:setText("Dia " .. day)
    item:setTextOffset("0 -11")
    item:setFont("small-9px")

    if unlocked == "blocked" then
      item:setText("VIP")
      item:setBackgroundColor("black")
      item:setOpacity(0.60)
    end

    if collected == "noCollected" then
      item:setIcon("images/noCollected.png")
    end

    if collected == "Collected" then
      item:setIcon("images/Collected.png")
    end

    item:setMarginLeft(2)
    item:setMarginTop(2)

    reinvidicar.onClick = function()
      g_game.getProtocolGame():sendExtendedOpcode(rewardConfirmOPCODE, "confirm".."@")
      
      g_effects.fadeOut(rewards, 5000)
      rewards:hide()
    end
  end
end)