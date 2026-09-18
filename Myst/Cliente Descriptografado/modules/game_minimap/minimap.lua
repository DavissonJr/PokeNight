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
    self.ui:hide()

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
    end

    self.ui.contentsPanel.minimap:load()
    minimapButton:setOn(false)
end

function controller:onGameEnd()
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
end

function zoomOutt()
    minimapWidget:zoomOut()
end

function resett()
    minimapWidget:reset()
end

function floorUpp()
    minimapWidget:floorUp(1)
end

function floorDownn()
    minimapWidget:floorDown(1)
end