-- Criado por Thalles Vitor --
-- Barra de Boss --
local life = g_ui.displayUI("life")
local lifeWidget = life:getChildById("life")
local bossName = life:getChildById("bossName")
local bossLife = life:getChildById("bossLife")
local boss = life:getChildById("boss")

-- Servidor - Opcodes
local lifeBarOPCODE = 20 -- opcode para receber a lifebar

function init()
  connect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  life:hide()
end

function terminate()
  disconnect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  life:hide()
end

function exibir()
  life:show()
end

function naoexibir()
  life:hide()
end

ProtocolGame.registerExtendedOpcode(lifeBarOPCODE, function(protocol, opcode, buffer) -- receive a life bar
    local param = buffer:explode("@")
    local name = tostring(param[1])
    local percent = tonumber(param[2])
    local typee = tostring(param[3])
    local outfitId = tonumber(param[4])
    local lifeValue = tonumber(param[5])

    life:show()
    if typee == "hide" then
      life:hide()
      return true
    end

    lifeWidget:setPercent(percent)
    lifeWidget:setText(percent .. "%")
    bossName:setText(name)
    bossLife:setText(percent .. "%")
    boss:setOutfit({type = outfitId})
end)