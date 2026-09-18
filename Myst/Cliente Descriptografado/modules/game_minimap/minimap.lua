local otmm = true
local oldPos = nil
local minimapButton = nil

-- bot fix
minimapWidget = nil

function updateCameraPosition()
    local player = g_game.getLocalPlayer()
    if not player then
        return
    end

    local pos = player:getPosition()
    if not pos then
        return
    end

    local minimapWidget = controller.ui.contentsPanel.minimap
	if not minimapWidget then
        minimapWidget = modules.game_interface.getRootPanel().minimap
    end

    --[[ if minimapWidget:isDragging() then
        return
    end ]]

	--[[ if not minimapWidget:getChildById("position") then
		poss = g_ui.createWidget("Label", minimapWidget)
        poss:setId("position")
        poss:addAnchor(AnchorTop, "parent", AnchorTop)
        poss:addAnchor(AnchorLeft, "parent", AnchorLeft)
        poss:setMarginTop(3)
        poss:setMarginLeft(3)
		poss:setColor("black")
	end

    if poss then
        poss:setText("X: " .. pos.x .. " Y: " .. pos.y .. " Z: " .. pos.z)
    end ]]
    
    if not minimapWidget.fullMapView then
        minimapWidget:setCameraPosition(pos)
    end

    minimapWidget:setCrossPosition(pos)
    refreshTownLabels()
end

-- Botao X do modo tela cheia, criado sob demanda (ver toggleFullMap).
local fullmapCloseButton = nil

--- O mapa esta ocupando a tela inteira?
local function isFullMap()
    local w = controller.ui.contentsPanel.minimap or
              modules.game_interface.getRootPanel().minimap
    return w ~= nil and w.fullMapView == true
end

local function toggle()
    -- Em tela cheia o widget do minimapa foi reparentado para o rootPanel,
    -- entao esconder controller.ui nao esconde mapa nenhum -- era assim que
    -- o mapa ficava preso na tela sem forma de sair. Aqui Ctrl+M passa a
    -- significar "sair da tela cheia" enquanto ela estiver ativa.
    if isFullMap() then
        toggleFullMap()
        return
    end

    if controller.ui:isVisible() then
        controller.ui:hide()
        minimapButton:setOn(false)
    else
        controller.ui:show()
        minimapButton:setOn(true)
    end
end

function closeWindow()
    controller.ui:hide()
    minimapButton:setOn(false)
end

-- ---------------------------------------------------------------------
-- Rotulos das regioes
--
-- O minimapa do cliente nao tem API de marcacao exposta ao Lua (g_minimap
-- so oferece clean/load/save). Entao os nomes sao Labels comuns criados
-- sobre o widget do mapa, reposicionados com getTilePoint() sempre que a
-- camera, o zoom ou o andar mudam.
--
-- Os nomes saem do proprio OTBM (design/gen_towns.py -> minimap_towns.lua).
-- Rotas e cavernas nao existem no mapa como dado; para essas, acrescente
-- entradas em minimapExtraLabels abaixo.
-- ---------------------------------------------------------------------

-- Pontos que o OTBM nao tem. Mesmo formato: name, x, y, z.
minimapExtraLabels = minimapExtraLabels or {}

local townLabels = {}

--- Quantos tiles cabem por pixel; abaixo de certo zoom os nomes viram
--- poluicao visual, entao somem.
local MIN_SCALE_FOR_LABELS = 0.8

local function clearTownLabels()
    for _, w in pairs(townLabels) do
        if w and not w:isDestroyed() then
            w:destroy()
        end
    end
    townLabels = {}
end

-- O arraste do mapa e tratado em C++ e nao emite evento nenhum ao Lua --
-- nem UIMinimap nem o binding tem onDrag/onMouseMove. Sem um tique
-- periodico os rotulos so se reposicionavam quando o jogador andava ou o
-- zoom mudava: arrastando, o terreno deslizava por baixo e os nomes
-- ficavam parados na tela.
local labelTicker = nil
local LABEL_TICK_MS = 80

function startTownLabelTicker()
    if labelTicker then
        return
    end
    local function tick()
        refreshTownLabels()
        labelTicker = scheduleEvent(tick, LABEL_TICK_MS)
    end
    labelTicker = scheduleEvent(tick, LABEL_TICK_MS)
end

function stopTownLabelTicker()
    if labelTicker then
        removeEvent(labelTicker)
        labelTicker = nil
    end
end

function refreshTownLabels()
    local widget = minimapWidget
    if not widget or widget:isDestroyed() then
        return clearTownLabels()
    end

    -- Sem a tabela carregada nao ha o que desenhar.
    if not MinimapTowns then
        return clearTownLabels()
    end

    local scale = widget:getScale()
    if not scale or scale < MIN_SCALE_FOR_LABELS then
        return clearTownLabels()
    end

    local camera = widget:getCameraPosition()
    if not camera then
        return clearTownLabels()
    end

    local size = widget:getSize()
    local shown = {}

    local function place(entry, index)
        if entry.z ~= camera.z then
            return
        end
        local point = widget:getTilePoint({ x = entry.x, y = entry.y, z = entry.z })
        if not point then
            return
        end
        -- Fora da area visivel: nao cria widget para nao gastar a toa.
        if point.x < 0 or point.y < 0 or point.x > size.width or point.y > size.height then
            return
        end

        local label = townLabels[index]
        if not label or label:isDestroyed() then
            label = g_ui.createWidget('MinimapTownLabel', widget)
            townLabels[index] = label
        end
        label:setText(entry.name)
        local w = label:getWidth()
        label:setPosition({ x = point.x - w / 2, y = point.y - 8 })
        label:setVisible(true)
        shown[index] = true
    end

    for i, entry in ipairs(MinimapTowns) do
        place(entry, 'town' .. i)
    end
    for i, entry in ipairs(minimapExtraLabels) do
        place(entry, 'extra' .. i)
    end

    -- Esconde o que saiu de vista sem destruir, para nao recriar a cada
    -- passo do jogador.
    for index, w in pairs(townLabels) do
        if not shown[index] and w and not w:isDestroyed() then
            w:setVisible(false)
        end
    end
end

function toggleFullMap()
    local rootPanel = modules.game_interface.getRootPanel()
    local minimapWidget = controller.ui.contentsPanel.minimap
    if not minimapWidget then
        minimapWidget = rootPanel.minimap
    end
    local zoom;

    if minimapWidget.fullMapView then
        minimapWidget:setParent(controller.ui.contentsPanel)
        minimapWidget:fill('parent')
        controller.ui:show(true)
        zoom = minimapWidget.zoomMinimap

        -- Saindo da tela cheia: remove o X e devolve o Esc ao jogo.
        if fullmapCloseButton then
            fullmapCloseButton:destroy()
            fullmapCloseButton = nil
        end
        g_keyboard.unbindKeyDown('Escape', rootPanel)
    else
        controller.ui:hide(true)
        minimapWidget:setParent(rootPanel)
        minimapWidget:fill('parent')
        zoom = minimapWidget.zoomFullmap

        -- Entrando na tela cheia: sem uma saida visivel o jogador fica
        -- preso, entao criamos o X sobre o mapa e ligamos o Esc.
        fullmapCloseButton = g_ui.createWidget('MinimapCloseButton', minimapWidget)
        fullmapCloseButton.onClick = function()
            toggleFullMap()
        end
        g_keyboard.bindKeyDown('Escape', function()
            if isFullMap() then
                toggleFullMap()
            end
        end, rootPanel)
    end

    minimapWidget.fullMapView = not minimapWidget.fullMapView
    -- minimapWidget:setAlternativeWidgetsVisible(fullmapView)

    local pos = oldPos or minimapWidget:getCameraPosition()
    oldPos = minimapWidget:getCameraPosition()
    minimapWidget:setZoom(zoom)
    minimapWidget:setCameraPosition(pos)
end

controller = Controller:new()
controller:setUI('minimap', modules.game_interface.getRightPanel())
local localPlayerEvent = controller:addEvent(LocalPlayer, {
    onPositionChange = updateCameraPosition
})

function controller:onInit()
    minimapButton = modules.client_topmenu.addRightGameToggleButton('minimapButton', tr('Minimapa') .. ' (Ctrl+M)',
        '/images/topbuttons/minimap_hover', toggle)
    minimapButton:setOn(true)

    minimapWidget = self.ui.contentsPanel.minimap

    local gameRootPanel = modules.game_interface.getRootPanel()
    self:bindKeyPress('Alt+Left', function()
        minimapWidget:move(1, 0)
    end, gameRootPanel)
    self:bindKeyPress('Alt+Right', function()
        minimapWidget:move(-1, 0)
    end, gameRootPanel)
    self:bindKeyPress('Alt+Up', function()
        minimapWidget:move(0, 1)
    end, gameRootPanel)
    self:bindKeyPress('Alt+Down', function()
        minimapWidget:move(0, -1)
    end, gameRootPanel)

    self:bindKeyDown('Ctrl+M', toggle)
    self:bindKeyDown('Ctrl+Shift+M', toggleFullMap)

    self.ui:setContentMinimumHeight(80)
    self.ui:setup()
end

function controller:onGameStart()
    self.ui:setupOnStart() -- load character window configuration
    -- Mesmo caso do game_battle: o hide() daqui anulava o estado que
    -- setupOnStart acabara de restaurar.
    startTownLabelTicker()

    -- Load Map
    local minimapFile = '/minimap'
    local loadFnc = nil

    if otmm then
        minimapFile = minimapFile .. '.otmm'
        loadFnc = g_minimap.loadOtmm
    else
        minimapFile = minimapFile .. '_' .. g_game.getClientVersion() .. '.otcm'
        loadFnc = g_map.loadOtcm
    end

    if g_resources.fileExists(minimapFile) then
        loadFnc(minimapFile)
    elseif otmm and g_resources.fileExists('/minimap_base.otmm') then
        -- Primeira vez deste jogador: semeia com o mapa inteiro em tom
        -- escuro (gerado do OTBM por design/gen_minimap.py). Andar
        -- substitui cada tile pela cor real, entao o explorado "acende".
        --
        -- O arquivo tem nome proprio de proposito: data/ e montado a
        -- frente do diretorio de escrita, entao um "minimap.otmm" ali
        -- venceria o save do jogador e apagaria a exploracao dele a cada
        -- login. Como semente, so entra quando nao ha save nenhum -- e
        -- loadOtmm marca os blocos com justSaw(), entao o proximo save
        -- ja leva a base junto.
        loadFnc('/minimap_base.otmm')
    end

    self.ui.contentsPanel.minimap:load()
    -- O botao segue a janela: cravar false aqui deixava o icone apagado
    -- mesmo com o minimapa aberto.
    minimapButton:setOn(self.ui:isVisible())
end

function controller:onGameEnd()
    -- Sem isso o tique continua rodando com a janela ja destruida.
    stopTownLabelTicker()
    self.ui:setParent(nil, true)

    -- Save Map
    if otmm then
        g_minimap.saveOtmm('/minimap.otmm')
    else
        g_map.saveOtcm('/minimap_' .. g_game.getClientVersion() .. '.otcm')
    end

    self.ui.contentsPanel.minimap:save()

    g_minimap.clean()
    minimapButton:setOn(false)
end

function controller:onTerminate()
    minimapButton:setOn(false)
end

function onMiniWindowOpen()
    minimapButton:setOn(true)
    localPlayerEvent:connect()
    localPlayerEvent:execute('onPositionChange')
end

function onMiniWindowClose()
    minimapButton:setOn(false)
    localPlayerEvent:disconnect()
    --minimapWidget:destroyChildren()
end

function zoomInn()
    minimapWidget:zoomIn()
    refreshTownLabels()
end

function zoomOutt()
    minimapWidget:zoomOut()
    refreshTownLabels()
end

function resett()
    minimapWidget:reset()
    refreshTownLabels()
end

function floorUpp()
    minimapWidget:floorUp(1)
    refreshTownLabels()
end

function floorDownn()
    minimapWidget:floorDown(1)
    refreshTownLabels()
end