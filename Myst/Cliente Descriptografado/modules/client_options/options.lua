local defaultOptions = {
    vsync = false,
    showFps = true,
    fullscreen = true,
    classicControl = true,
    smartWalk = true,
    preciseControl = true,
    autoChaseOverride = true,
    moveStack = true,
    movePokemon = false,
    showStatusMessagesInConsole = true,
    showEventMessagesInConsole = true,
    showInfoMessagesInConsole = true,
    showTimestampsInConsole = true,
    showLevelsInConsole = true,
    showPrivateMessagesInConsole = true,
    showPrivateMessagesOnScreen = true,
    openMaximized = false,
    backgroundFrameRate = 201,
    enableAudio = false,
    enableMusicSound = false,
    musicSoundVolume = 0,
    enableLights = true,
    limitVisibleDimension = true,
    floatingEffect = false,
    ambientLight = 100,
    -- Solta a trava de 250 ms que lockWalk() impoe apos um passo recusado
    -- ou um clique. Ver releaseWalkLock em game_interface.
    smoothWalk = true,
    -- Segura o primeiro passo por um instante para a diagonal sair certa
    -- ao combinar duas teclas. Ver smartWalk em game_interface.
    diagonalGrace = true,
    wasdWalking = false,
    -- gameinterface.lua ja lia estas quatro, mas elas nunca foram
    -- definidas aqui: getOption devolvia nil e setOn(nil) desligava o
    -- painel. Os botoes de aumentar/diminuir tambem estavam sem handler.
    showLeftPanel = true,
    showLeftExtraPanel = false,
    showRightPanel = true,
    showRightExtraPanel = false,
    displayNames = true,
    displayHealth = true,
    displayMana = true,
    displayText = true,
    dontStretchShrink = false,
    turnDelay = 0,
    hotkeyDelay = 0,
    enableHighlightMouseTarget = false,
    --[[ antialiasingMode = 0, ]]
    shadowFloorIntensity = 100,
    optimizeFps = true,
    forceEffectOptimization = false,
    drawEffectOnTop = false,
    floorViewMode = 0,
    floorFading = 500,
    asyncTxtLoading = false,
    showMoveBar = true,
    disableEffects = false,
    disableMissiles = false,
    disableColors = false,
    setEffectAlphaScroll = 100,
    setMissileAlphaScroll = 100,

    showItemMove = true, -- Thalles
    showOrangeMessages = true, -- Thalles
    shopQuestion = false, -- Thalles
    scrollOrder = true, -- Thalles
    hideActionBar = true, -- Thalles
    emblemas = false, -- Thalles
}

local optionsWindow
local optionsButton
local optionsTabBar
local options = {}
local generalPanel
local controlPanel
local consolePanel
local graphicsPanel
local soundPanel
local audioButton

local crosshairCombobox
local antialiasingModeCombobox
local floorViewModeCombobox

function init()
    connect(g_game, {
        onGameStart = onGameStart,
    })

    for k, v in pairs(defaultOptions) do
        g_settings.setDefault(k, v)
        options[k] = v
    end

    optionsWindow = g_ui.displayUI('options')
    optionsWindow:hide()

    optionsTabBar = optionsWindow:getChildById('optionsTabBar')
    optionsTabBar:setContentWidget(optionsWindow:getChildById('optionsTabContent'))

    g_keyboard.bindKeyDown('Ctrl+Shift+F', function()
        toggleOption('fullscreen')
    end)
    g_keyboard.bindKeyDown('Ctrl+N', toggleDisplays)

    generalPanel = g_ui.loadUI('general')
    optionsTabBar:addTab(tr('Jogo'), generalPanel, '/images/optionstab/game')

    --[[ controlPanel = g_ui.loadUI('control')
    optionsTabBar:addTab(tr('Controle'), controlPanel, '/images/optionstab/controls') ]]

    consolePanel = g_ui.loadUI('console')
    optionsTabBar:addTab(tr('Console'), consolePanel, '/images/optionstab/console')

    graphicsPanel = g_ui.loadUI('graphics')
    optionsTabBar:addTab(tr('Gráficos'), graphicsPanel, '/images/optionstab/graphics')

    --[[ soundPanel = g_ui.loadUI('audio')
    optionsTabBar:addTab(tr('Audio'), soundPanel, '/images/optionstab/audio') ]]

    optionsButton = modules.client_topmenu.addLeftButton('optionsButton', tr('Opções'), '/images/topbuttons/options_hover',
        toggle)
    --[[ audioButton = modules.client_topmenu.addLeftButton('audioButton', tr('Audio'), '/images/topbuttons/audio', function() toggleOption('enableAudio') end) ]]

    addEvent(function()
        setup()
    end)
end

function terminate()
    disconnect(g_game, {
        onGameStart = onGameStart,
    })

    g_keyboard.unbindKeyDown('Ctrl+Shift+F')
    g_keyboard.unbindKeyDown('Ctrl+N')
    optionsWindow:destroy()
    optionsButton:destroy()
    --[[ audioButton:destroy() ]]
end

function setupComboBox()
    antialiasingModeCombobox = graphicsPanel:recursiveGetChildById('antialiasingMode')

    antialiasingModeCombobox:addOption('Nenhum', 0)
    antialiasingModeCombobox:addOption('Normal', 1)
    antialiasingModeCombobox:addOption('Médio', 2)

    antialiasingModeCombobox.onOptionChange = function(comboBox, option)
        setOption('antialiasingMode', comboBox:getCurrentOption().data)
        --g_settings.save()
    end

    floorViewModeCombobox = graphicsPanel:recursiveGetChildById('floorViewMode')

    floorViewModeCombobox:addOption('Normal', 0)
    floorViewModeCombobox:addOption('Fade', 1)
    floorViewModeCombobox:addOption('Locked', 2)
    floorViewModeCombobox:addOption('Always', 3)
    floorViewModeCombobox:addOption('Always with transparency', 4)

    floorViewModeCombobox.onOptionChange = function(comboBox, option)
        setOption('floorViewMode', comboBox:getCurrentOption().data)
    end

    local antialiasingOptions = {
        ["0"] = "Nenhum",
        ["1"] = "Normal",
        ["2"] = "Médio",
    }

    if antialiasingOptions[g_settings.getString('antialiasingMode')] then
        antialiasingModeCombobox:setOption(antialiasingOptions[g_settings.getString('antialiasingMode')])
        setOption('antialiasingMode', tonumber(g_settings.getString('antialiasingMode')))
    end
end

function setup()
    setupComboBox()

    -- load options
    for k, v in pairs(defaultOptions) do
        if type(v) == 'boolean' then
            setOption(k, g_settings.getBoolean(k), true)
        elseif type(v) == 'number' then
            setOption(k, g_settings.getNumber(k), true)
        elseif type(v) == 'string' then
            setOption(k, g_settings.getString(k), true)
        end
    end
end

function toggle()
    if optionsWindow:isVisible() then
        hide()
    else
        show()
    end
end

function show()
    optionsWindow:show()
    optionsWindow:raise()
    optionsWindow:focus()
end

function hide()
    optionsWindow:hide()
end

function toggleDisplays()
    if options['displayNames'] and options['displayHealth'] and options['displayMana'] then
        setOption('displayNames', false)
    elseif options['displayHealth'] then
        setOption('displayHealth', false)
        setOption('displayMana', false)
    else
        if not options['displayNames'] and not options['displayHealth'] then
            setOption('displayNames', true)
        else
            setOption('displayHealth', true)
            setOption('displayMana', true)
        end
    end
end

function toggleOption(key)
    setOption(key, not getOption(key))
end

function setOption(key, value, force)
    if not force and options[key] == value then
        return
    end

    local gameMapPanel = modules.game_interface.getMapPanel()

    if key == 'vsync' then
        g_window.setVerticalSync(value)
    elseif key == 'showFps' then
        modules.client_topmenu.setFpsVisible(value)
    elseif key == 'disableEffects' then
        if value then
            g_game.enableFeature(GameDisableEffects)
        else
            g_game.disableFeature(GameDisableEffects)
        end
    elseif key == 'disableMissiles' then
        if value then
            g_game.enableFeature(GameDisableMissiles)
        else
            g_game.disableFeature(GameDisableMissiles)
        end
    elseif key == 'disableColors' then
        if value then
            g_game.enableFeature(GameeDisableColors)
        else
            g_game.disableFeature(GameeDisableColors)
        end
    elseif key == 'emblemas' then
        if value then
            g_game.enableFeature(GameDisableEmblems)
        else
            g_game.disableFeature(GameDisableEmblems)
        end
    elseif key == 'optimizeFps' then
        g_app.optimize(value)
    elseif key == 'forceEffectOptimization' then
        g_app.forceEffectOptimization(value)
    elseif key == 'drawEffectOnTop' then
        g_app.setDrawEffectOnTop(value)
    elseif key == 'showMoveBar' then
        if value then
            if g_game.isOnline() then
                modules.game_pokemoves.getPokeMoves():show()
            end
        else
            modules.game_pokemoves.getPokeMoves():hide()
        end
    --[[ elseif key == 'scrollOrder' then
        if value then
            g_mouse.bindPress(rootWidget, function()
                if not g_game.isOnline() then
                    return
                end

                local item = g_game.getLocalPlayer():getInventoryItem(InventorySlotBody)
                modules.game_interface.startUseWith(item)
            end, MouseMidButton)
        end ]]
    elseif key == 'hideActionBar' then
        if value then
            if g_game.isOnline() then
                modules.game_actionbar.addActionBarPanel()
                modules.game_actionbar.getActionBar():show()
            end
        else
            if g_game.isOnline() then
                modules.game_actionbar.removeActionBarPanel()
                modules.game_actionbar.getActionBar():hide()
            end
        end
    elseif key == 'asyncTxtLoading' then
        if g_game.isUsingProtobuf() then
            value = true
        elseif g_app.isEncrypted() then
            local asyncWidget = graphicsPanel:getChildById('asyncTxtLoading')
            asyncWidget:setEnabled(false)
            asyncWidget:setChecked(false)
            return
        end

        g_app.setLoadingAsyncTexture(value)
    elseif key == 'fullscreen' then
        g_window.setFullscreen(value)
    elseif key == 'enableAudio' then
        if g_sounds then
            g_sounds.setAudioEnabled(value)
        end
        --[[ if value then
            audioButton:setIcon('/images/topbuttons/audio')
        else
            audioButton:setIcon('/images/topbuttons/audio_mute')
        end ]]
    elseif key == 'enableMusicSound' then
        if g_sounds then
            g_sounds.getChannel(SoundChannels.Music):setEnabled(value)
        end
    elseif key == 'musicSoundVolume' then
        if g_sounds then
            g_sounds.getChannel(SoundChannels.Music):setGain(value / 100)
        end
        --[[ soundPanel:getChildById('musicSoundVolumeLabel'):setText(tr('Music volume: %d', value)) ]]
        modules.game_interface.getRightExtraPanel():setOn(value)
    elseif key == 'backgroundFrameRate' then
        local text, v = value, value
        if value <= 0 or value >= 201 then
            text = 'max'
            v = 0
        end
        graphicsPanel:getChildById('backgroundFrameRateLabel'):setText(tr('Limite de taxa de quadros do jogo: %s', text))
        g_app.setMaxFps(v)
    elseif key == 'enableLights' then
        gameMapPanel:setDrawLights(options['ambientLight'])
        graphicsPanel:getChildById('ambientLight'):setEnabled(true)
        graphicsPanel:getChildById('ambientLightLabel'):setEnabled(true)
    elseif key == 'ambientLight' then
        graphicsPanel:getChildById('ambientLightLabel'):setText(tr('Ambient light: %s%%', value))
        gameMapPanel:setMinimumAmbientLight(value / 100)
        gameMapPanel:setDrawLights(true)
    elseif key == 'shadowFloorIntensity' then
        graphicsPanel:getChildById('shadowFloorIntensityLevel'):setText(tr('Shadow floor Intensity: %s%%', value))
        gameMapPanel:setShadowFloorIntensity(1 - (value / 100))
    elseif key == 'floorFading' then
        graphicsPanel:getChildById('floorFadingLabel'):setText(tr('Floor Fading: %s ms', value))
        gameMapPanel:setFloorFading(tonumber(value))
    elseif key == 'limitVisibleDimension' then
        gameMapPanel:setLimitVisibleDimension(value)
    elseif key == 'floatingEffect' then
        g_map.setFloatingEffect(value)
    elseif key == 'showLeftPanel' or key == 'showLeftExtraPanel'
            or key == 'showRightPanel' or key == 'showRightExtraPanel' then
        if g_game.isOnline() and modules.game_interface then
            modules.game_interface.applySidePanels()
        end
    elseif key == 'wasdWalking' then
        -- O cliente ja sabe andar de WASD: bindMovingKeys() e chamado por
        -- switchChat(false) no game_console. O que faltava era uma chave
        -- para o jogador ligar isso pelas opcoes, em vez de descobrir o
        -- botao de modo chat. Marcar = sair do modo chat (WASD anda);
        -- desmarcar = voltar ao modo chat (WASD digita).
        if g_game.isOnline() and modules.game_console then
            local console = modules.game_console
            if console.consoleToggleChat then
                console.consoleToggleChat:setChecked(not value)
            end
            if console.switchChat then
                console.switchChat(not value)
            end
        end
    elseif key == 'displayNames' then
        gameMapPanel:setDrawNames(value)
    elseif key == 'displayHealth' then
        gameMapPanel:setDrawHealthBars(value)
    elseif key == 'displayMana' then
        gameMapPanel:setDrawManaBar(value)
    elseif key == 'displayText' then
        g_app.setDrawTexts(value)
    elseif key == 'dontStretchShrink' then
        addEvent(function()
            modules.game_interface.updateStretchShrink()
        end)
    elseif key == 'preciseControl' then
        g_game.setScheduleLastWalk(not value)
    --[[ elseif key == 'turnDelay' then
        controlPanel:getChildById('turnDelayLabel'):setText(tr('Turn delay: %sms', value))
    elseif key == 'hotkeyDelay' then
        controlPanel:getChildById('hotkeyDelayLabel'):setText(tr('Hotkey delay: %sms', value)) ]]
    --[[ elseif key == 'crosshair' then
        local crossPath = '/images/game/crosshair/'
        local newValue = value
        if newValue == 'disabled' then
            newValue = nil
        end
        gameMapPanel:setCrosshairTexture(newValue and crossPath .. newValue or nil)
        crosshairCombobox:setCurrentOptionByData(newValue, true) ]]
    elseif key == 'enableHighlightMouseTarget' then
        gameMapPanel:setDrawHighlightTarget(value)
    elseif key == 'floorShadowing' then
        gameMapPanel:setFloorShadowingFlag(value)
        floorShadowingComboBox:setCurrentOptionByData(value, true)
    elseif key == 'antialiasingMode' then
        gameMapPanel:setAntiAliasingMode(value)
        antialiasingModeCombobox:setOption(value)
    elseif key == 'floorViewMode' then
        gameMapPanel:setFloorViewMode(value)
        floorViewModeCombobox:setCurrentOptionByData(value, true)

        local fadeMode = value == 1
        graphicsPanel:getChildById('floorFading'):setEnabled(fadeMode)
        graphicsPanel:getChildById('floorFadingLabel'):setEnabled(fadeMode)
        
    --[[ elseif key == 'setEffectAlphaScroll' then
        g_client.setEffectAlpha(value/100)
        generalPanel:getChildById('setEffectAlphaLabel'):setText(tr('Opacity Effect: %s%%', value))
    elseif key == 'setMissileAlphaScroll' then
        g_client.setMissileAlpha(value/100)
        generalPanel:getChildById('setMissileAlphaLabel'):setText(tr('Opacity Missile: %s%%', value)) ]]
    end

    -- change value for keybind updates
    for _, panel in pairs(optionsTabBar:getTabsPanel()) do
        local widget = panel:recursiveGetChildById(key)
        if widget then
            if widget:getStyle().__class == 'UICheckBox' then
                widget:setChecked(value)
            elseif widget:getStyle().__class == 'UIScrollBar' then
                widget:setValue(value)
            end
            break
        end
    end

    g_settings.set(key, value)
    options[key] = value
end

function getOption(key)
    return options[key]
end

function addTab(name, panel, icon)
    optionsTabBar:addTab(name, panel, icon)
end

function removeTab(v)
    if type(v) == 'string' then
        v = optionsTabBar:getTab(v)
    end

    optionsTabBar:removeTab(v)
end

function addButton(name, func, icon)
    optionsTabBar:addButton(name, func, icon)
end

function onGameStart()
    if modules.client_options.getOption('emblemas') == true then
        g_game.enableFeature(GameDisableEmblems)
    end

    if modules.client_options.getOption('disableColors') == true then
        g_game.enableFeature(GameeDisableColors)
    end

    -- setOption roda antes de existir jogo, entao o WASD nao pode ser
    -- aplicado la. Reaplicamos ao entrar, senao a opcao so valeria depois
    -- de o jogador desmarcar e marcar de novo.
    if modules.client_options.getOption('wasdWalking') == true then
        addEvent(function()
            local console = modules.game_console
            if not console then return end
            if console.consoleToggleChat then
                console.consoleToggleChat:setChecked(false)
            end
            if console.switchChat then
                console.switchChat(false)
            end
        end)
    end
end