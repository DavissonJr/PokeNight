-- Criado por Thalles Vitor --
-- Sistema de Task --
local task = g_ui.displayUI("task")
local taskPanel = task:getChildById("taskPanel")
local pointsLabel = task:getChildById("pointsLabel")

local panelList = {}
local buttonsList = {}

-- Opcodes - Servidor
local TASKWINDOW_OPCODE = 12
local TASKWINDOWRECOMP_OPCODE = 13
local TASKWINDODEST_OPCODE = 14
local taskWINDOWMISSION = 15
local TASKWINDOWMISSIONCOMPLET_OPCODE = 16

-- Opcodes - Cliente
local TASKWINDOW_SENDMISSION = 15 -- enviar que iniciei a missao
local TASKWINDOWCHANGECATEGORY = 16 -- enviar que mudei de categoria
local TASKWINDOWBUY_OPCODE = 17 -- enviar que quero comprar uma missao

local buyWindow = nil
function abreviateNumber(n)
  if n >= 10^6 then
      return string.format("%.0fkk", n / 10^6)
  elseif n >= 10^3 then
      return string.format("%.0fk", n / 10^3)
  else
      return tostring(n)
  end
end

function init()
    connect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })

    task:hide()
end

function terminate()
    disconnect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })

    if buyWindow then
        buyWindow:destroy()
        buyWindow = nil
    end

    buttonsList = {}
    panelList = {}

    task:hide()
end

function exibir()
    if task:isVisible() then
        task:hide()
    else
        task:show()
    end
    
    --task:show()
end

function naoexibir()
    if buyWindow then
        buyWindow:destroy()
        buyWindow = nil
    end

    buttonsList = {}
    panelList = {}

    task:hide()
end

ProtocolGame.registerExtendedOpcode(TASKWINDOW_OPCODE, function(protocol, opcode, buffer) -- receive window
    local param = buffer:explode("@")
    local outfit = tonumber(param[1])
    local name = tostring(param[2])
    local points = tonumber(param[3])
    local canMake = tostring(param[4])
    local index = tonumber(param[5])
    local typee = tostring(param[6])
    local special = tostring(param[7])
    local points2 = tonumber(param[8])
    local costMission = tonumber(param[9])

    task:show()
    pointsLabel:setText(points2)

    local button = g_ui.createWidget("UIButton", taskPanel)
    button:setId(name)
    button:setSize("396 69")
    button:setImageSource("images/button.png")
    button:setImageBorder(20)
    button:setMarginLeft(10)
    button:setMarginTop(15)

    local createOut = g_ui.createWidget("UICreature", button)
    createOut:addAnchor(AnchorTop, "parent", AnchorTop)
    createOut:addAnchor(AnchorLeft, "parent", AnchorLeft)
    createOut:setSize("52 52")
    createOut:setImageSource("images/box.png")
    createOut:setImageBorder(10)
    createOut:setOutfit({type = outfit})
    createOut:setMarginTop(10)
    createOut:setMarginLeft(12)

    local nameMission = g_ui.createWidget("Label", button)
    nameMission:addAnchor(AnchorTop, "parent", AnchorTop)
    nameMission:addAnchor(AnchorLeft, "parent", AnchorLeft)
    nameMission:setText(name)
    nameMission:setTextAutoResize("true")
    nameMission:setMarginTop(10)
    nameMission:setMarginLeft(70)
    --[[ nameMission:setFont("lucida-11px-rounded") ]]
    nameMission:setColor("#e0680f")

    local pointsMission = g_ui.createWidget("UIButton", button)
    pointsMission:setSize("25 25")
    pointsMission:setImageSource("images/points.png")
    pointsMission:addAnchor(AnchorTop, "parent", AnchorTop)
    pointsMission:addAnchor(AnchorLeft, "parent", AnchorLeft)
    pointsMission:setMarginTop(25)
    pointsMission:setMarginLeft(75)

    local pointsLabel = g_ui.createWidget("Label", button)
    --[[ pointsLabel:setFont("lucida-11px-rounded") ]]
    pointsLabel:setColor("white")
    pointsLabel:setText("x" .. points)
    pointsLabel:addAnchor(AnchorTop, "parent", AnchorTop)
    pointsLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
    pointsLabel:setMarginTop(49)
    pointsLabel:setMarginLeft(80)

    if special ~= "special" then
        if canMake == "yes" then
            local startButton = g_ui.createWidget("UIButton", button)
            startButton:setSize("100 32")
            startButton:setImageSource("images/button2.png")
            startButton:setImageBorder("19")
            startButton:setText("Iniciar")
            startButton:setColor("#0cff00")
            startButton:addAnchor(AnchorTop, "parent", AnchorTop)
            startButton:addAnchor(AnchorLeft, "parent", AnchorLeft)
            startButton:setMarginTop(20)
            startButton:setMarginLeft(290)

            startButton.onHoverChange = function(self, hovered)
                if hovered then
                    startButton:setImageSource("images/button2_hover.png")
                else
                    startButton:setImageSource("images/button2.png")
                end
            end

            startButton.onClick = function()
                if not g_game.isOnline() then
                    return
                end

                g_game.getProtocolGame():sendExtendedOpcode(TASKWINDOW_SENDMISSION, index.."@"..typee.."@")
            end
        else
            local lockedButton = g_ui.createWidget("UIButton", button)
            lockedButton:setSize("32 38")
            lockedButton:setImageSource("images/locked.png")
            lockedButton:addAnchor(AnchorTop, "parent", AnchorTop)
            lockedButton:addAnchor(AnchorLeft, "parent", AnchorLeft)
            lockedButton:setMarginTop(18)
            lockedButton:setMarginLeft(355)

            if costMission > 0 then
                lockedButton:setTooltip("Clique para desbloquear essa missão, ela vai te custar " .. costMission .. " pontos de missão.")
                lockedButton.onClick = function()
                    local yesCallback = function()
                        buyWindow:destroy()
                        buyWindow = nil

                        if not g_game.isOnline() then
                            return true
                        end

                        g_game.getProtocolGame():sendExtendedOpcode(TASKWINDOWBUY_OPCODE, index.."@"..typee.."@")
                    end

                    local noCallback = function()
                        buyWindow:destroy()
                        buyWindow = nil
                    end

                    buyWindow = displayGeneralBox(tr('Compra de Missão'), tr("Você tem certeza que deseja comprar a missão: " .. name .. " por " .. costMission .. " pontos de missão?"), {
                        {
                            text = tr('Yes'),
                            callback = yesCallback
                        },
                        {
                            text = tr('No'),
                            callback = noCallback
                        },
                        anchor = AnchorHorizontalCenter
                    }, yesCallback, noCallback)
                end
            else
                lockedButton.onClick = function() end
            end
        end
    end

    buttonsList[name .. index] = button
end)

ProtocolGame.registerExtendedOpcode(TASKWINDOWRECOMP_OPCODE, function(protocol, opcode, buffer) -- receive window recompenses
    local param = buffer:explode("@")
    local name = tostring(param[1])
    local itemId = tonumber(param[2])
    local itemCount = tonumber(param[3])
    local index = tonumber(param[4])

    if buttonsList[name .. index] then
        local panelRecompense = nil
        if not panelList[name .. index] then
            panelRecompense = g_ui.createWidget("ItemsPanelTask", buttonsList[name .. index])
            panelRecompense:setSize("189 25")
            panelRecompense:setId("panel" .. name)
            panelRecompense:addAnchor(AnchorTop, "parent", AnchorTop)
            panelRecompense:addAnchor(AnchorLeft, "parent", AnchorLeft)
            panelRecompense:setMarginTop(26)
            panelRecompense:setMarginLeft(110)

            panelList[name .. index] = panelRecompense
        end

        if panelList[name .. index] then
            if itemId == 3239 then
                local item = g_ui.createWidget("UIItem", panelList[name .. index])
                item:setSize("31 24")
                item:setImageSource("images/hd.png")
                --[[ item:setFont("lucida-11px-rounded") ]]
                item:setText("x" .. itemCount)
                item:setColor("white")
                item:setTextOffset("0 15")
            elseif itemId == 100 then
                local item = g_ui.createWidget("UIItem", panelList[name .. index])
                item:setSize("30 20")
                item:setImageSource("images/xp.png")
               --[[  item:setFont("lucida-11px-rounded") ]]
                item:setText(abreviateNumber(itemCount))
                item:setColor("white")
                item:setTextOffset("0 15")
                item:setMarginLeft(4)
            else
                local item = g_ui.createWidget("UIItem", panelList[name .. index])
                item:setSize("32 32")
                item:setItemId(itemId)
                --[[ item:setFont("lucida-11px-rounded") ]]
                item:setText("x" .. itemCount)
                item:setColor("white")
                item:setTextOffset("0 15")
            end
        end
    end
end)

ProtocolGame.registerExtendedOpcode(TASKWINDODEST_OPCODE, function(protocol, opcode, buffer) -- destroy infos
    local param = buffer:explode("@")
    taskPanel:destroyChildren()
    buttonsList = {}
    panelList = {}
end)

ProtocolGame.registerExtendedOpcode(taskWINDOWMISSION, function(protocol, opcode, buffer) -- receive the mission (counts and set image green)
    local param = buffer:explode("@")
    local name = tostring(param[1])
    local index = tonumber(param[2])
    local playerCount = tonumber(param[3])
    local monsterCount = tonumber(param[4])

    if buttonsList[name .. index] then
        buttonsList[name .. index]:setImageColor("green")

        local countText = g_ui.createWidget("Label", buttonsList[name .. index])
        countText:setText(playerCount .. "/" .. monsterCount)
        countText:addAnchor(AnchorTop, "parent", AnchorTop)
        countText:addAnchor(AnchorLeft, "parent", AnchorLeft)
        countText:setFont("otpfont")
        countText:setColor("white")
        countText:setTextAutoResize("true")
        countText:setMarginTop(28)
        countText:setMarginLeft(328)
    end
end)

ProtocolGame.registerExtendedOpcode(TASKWINDOWMISSIONCOMPLET_OPCODE, function(protocol, opcode, buffer) -- receive which has completed
    local param = buffer:explode("@")
    local name = tostring(param[1])
    local index = tonumber(param[2])

    if buttonsList[name .. index] then
        local verify = g_ui.createWidget("UIButton", buttonsList[name .. index])
        verify:setSize("34 26")
        verify:setImageSource("images/verify.png")
        verify:addAnchor(AnchorTop, "parent", AnchorTop)
        verify:addAnchor(AnchorLeft, "parent", AnchorLeft)
        verify:setMarginTop(21)
        verify:setMarginLeft(355)
    end
end)

function changeCategory(id)
    if id == "tab1" then
        if not g_game.isOnline() then
            return true
        end

        task:getChildById("tab1"):setOpacity(100)
        task:getChildById("tab2"):setOpacity(0.87)

        g_game.getProtocolGame():sendExtendedOpcode(TASKWINDOWCHANGECATEGORY, "monsters".."@")
    else
        task:getChildById("tab2"):setOpacity(100)
        task:getChildById("tab1"):setOpacity(0.87)

        g_game.getProtocolGame():sendExtendedOpcode(TASKWINDOWCHANGECATEGORY, "monsters2".."@")
    end
end