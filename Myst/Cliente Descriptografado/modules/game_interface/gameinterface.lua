WALK_STEPS_RETRY = 10

gameRootPanel = nil
gameMapPanel = nil
gameMainRightPanel = nil
gameRightPanel = nil
gameRightExtraPanel = nil
gameLeftPanel = nil
gameLeftExtraPanel = nil
gameSelectedPanel = nil
panelsList = {}
panelsRadioGroup = nil
gameTopPanel = nil
gameBottomPanel = nil
showTopMenuButton = nil
logoutButton = nil
logOutMainButton = nil
mouseGrabberWidget = nil
countWindow = nil
logoutWindow = nil
exitWindow = nil
bottomSplitter = nil
limitedZoom = false
currentViewMode = 0
smartWalkDirs = {}
smartWalkDir = nil
firstStep = false
closeChat = nil
gameActionPanel = nil
leftIncreaseSidePanels = nil
leftDecreaseSidePanels = nil
rightIncreaseSidePanels = nil
rightDecreaseSidePanels = nil
hookedMenuOptions = {}
lastDirTime = g_clock.millis()
lastManualWalk = 0

function init()
    g_ui.importStyle('styles/countwindow')

    connect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd,
        onLoginAdvice = onLoginAdvice
    }, true)

    -- Call load AFTER game window has been created and
    -- resized to a stable state, otherwise the saved
    -- settings can get overridden by false onGeometryChange
    -- events
    if g_app.hasUpdater() then
        connect(g_app, {
            onUpdateFinished = load,
        })
    else
        connect(g_app, {
            onRun = load,
        })
    end

    connect(g_app, {
        onExit = save
    })

    gameRootPanel = g_ui.displayUI('gameinterface')
    gameRootPanel:hide()
    gameRootPanel:lower()
    gameRootPanel.onGeometryChange = updateStretchShrink
    gameRootPanel.onFocusChange = stopSmartWalk

    mouseGrabberWidget = gameRootPanel:getChildById('mouseGrabber')
    mouseGrabberWidget.onMouseRelease = onMouseGrabberRelease

    bottomSplitter = gameRootPanel:getChildById('bottomSplitter')
    gameMapPanel = gameRootPanel:getChildById('gameMapPanel')
    gameMainRightPanel = gameRootPanel:getChildById('gameMainRightPanel')
    gameRightPanel = gameRootPanel:getChildById('gameRightPanel')
    gameRightExtraPanel = gameRootPanel:getChildById('gameRightExtraPanel')
    gameLeftExtraPanel = gameRootPanel:getChildById('gameLeftExtraPanel')
    gameLeftPanel = gameRootPanel:getChildById('gameLeftPanel')
    gameBottomPanel = gameRootPanel:getChildById('gameBottomPanel')
    gameTopPanel = gameRootPanel:getChildById('gameTopPanel')

    closeChat = gameRootPanel:getChildById("closeChat")
    gameActionPanel = gameRootPanel:getChildById("gameActionPanel")

    leftIncreaseSidePanels = gameRootPanel:getChildById('leftIncreaseSidePanels')
    leftDecreaseSidePanels = gameRootPanel:getChildById('leftDecreaseSidePanels')
    rightIncreaseSidePanels = gameRootPanel:getChildById('rightIncreaseSidePanels')
    rightDecreaseSidePanels = gameRootPanel:getChildById('rightDecreaseSidePanels')

    leftIncreaseSidePanels:setEnabled(not modules.client_options.getOption('showLeftExtraPanel'))
    leftDecreaseSidePanels:setEnabled(modules.client_options.getOption('showLeftPanel'))
    rightIncreaseSidePanels:setEnabled(not modules.client_options.getOption('showRightExtraPanel'))
    rightDecreaseSidePanels:setEnabled(modules.client_options.getOption('showRightExtraPanel'))

    panelsList = { {
        panel = gameRightPanel,
        checkbox = gameRootPanel:getChildById('gameSelectRightColumn')
    }, {
        panel = gameRightExtraPanel,
        checkbox = gameRootPanel:getChildById('gameSelectRightExtraColumn')
    }, {
        panel = gameLeftPanel,
        checkbox = gameRootPanel:getChildById('gameSelectLeftColumn')
    },{
        panel = gameLeftExtraPanel,
        checkbox = gameRootPanel:getChildById('gameSelectLeftExtraColumn')
    } }

   panelsRadioGroup = UIRadioGroup.create()
    for k, v in pairs(panelsList) do
        panelsRadioGroup:addWidget(v.checkbox)
        connect(v.checkbox, {
            onCheckChange = onSelectPanel
        })
    end
    panelsRadioGroup:selectWidget(panelsList[1].checkbox)

    logoutButton = modules.client_topmenu.addLeftButton('logoutButton', tr('Sair'), '/images/topbuttons/logout_hover',
        tryLogout, true)

    bindKeys()

    if g_game.isOnline() then
        show()
    end
end

function bindKeys()
    gameRootPanel:setAutoRepeatDelay(200)

    bindWalkKey('Up', North)
    bindWalkKey('Right', East)
    bindWalkKey('Down', South)
    bindWalkKey('Left', West)
    bindWalkKey('Numpad8', North)
    bindWalkKey('Numpad9', NorthEast)
    bindWalkKey('Numpad6', East)
    bindWalkKey('Numpad3', SouthEast)
    bindWalkKey('Numpad2', South)
    bindWalkKey('Numpad1', SouthWest)
    bindWalkKey('Numpad4', West)
    bindWalkKey('Numpad7', NorthWest)

    bindTurnKey('Ctrl+Up', North)
    bindTurnKey('Ctrl+Right', East)
    bindTurnKey('Ctrl+Down', South)
    bindTurnKey('Ctrl+Left', West)
    bindTurnKey('Ctrl+Numpad8', North)
    bindTurnKey('Ctrl+Numpad6', East)
    bindTurnKey('Ctrl+Numpad2', South)
    bindTurnKey('Ctrl+Numpad4', West)

    g_keyboard.bindKeyPress('Escape', function()
        g_game.cancelAttackAndFollow()
    end, gameRootPanel)
    g_keyboard.bindKeyPress('Ctrl+=', function()
        gameMapPanel:zoomIn()
    end, gameRootPanel)
    g_keyboard.bindKeyPress('Ctrl+-', function()
        gameMapPanel:zoomOut()
    end, gameRootPanel)
    g_keyboard.bindKeyDown('E', function() lootAll() end, gameRootPanel)
    g_keyboard.bindKeyDown('Ctrl+Q', function()
        tryLogout(false)
    end, gameRootPanel)
    g_keyboard.bindKeyDown('Ctrl+L', function()
        tryLogout(false)
    end, gameRootPanel)
    g_keyboard.bindKeyDown('Alt+W', function()
        g_map.cleanTexts()
        modules.game_textmessage.clearMessages()
    end, gameRootPanel)

   --[[  if not g_app.isScaled() then
        g_keyboard.bindKeyDown('Ctrl+.', nextViewMode, gameRootPanel)
    end ]]
end

function bindWalkKey(key, dir)
    g_keyboard.bindKeyDown(key, function()
        onWalkKeyDown(dir)
    end, gameRootPanel, true)
    g_keyboard.bindKeyUp(key, function()
        changeWalkDir(dir, true)
    end, gameRootPanel, true)
    g_keyboard.bindKeyPress(key, function()
        smartWalk(dir)
    end, gameRootPanel)
end

function unbindWalkKey(key)
    g_keyboard.unbindKeyDown(key, gameRootPanel)
    g_keyboard.unbindKeyUp(key, gameRootPanel)
    g_keyboard.unbindKeyPress(key, gameRootPanel)
end

function bindTurnKey(key, dir)
    local function callback(widget, code, repeatTicks)
        if g_clock.millis() - lastDirTime >= modules.client_options.getOption('turnDelay') then
            g_game.turn(dir)
            changeWalkDir(dir)

            lastDirTime = g_clock.millis()
        end
    end

    g_keyboard.bindKeyPress(key, callback, gameRootPanel)
end

function unbindTurnKey(key)
    g_keyboard.unbindKeyPress(key, gameRootPanel)
end

function terminate()
    hide()
    if g_app.hasUpdater() then
        disconnect(g_app, {
            onUpdateFinished = load,
        })
    else
        disconnect(g_app, {
            onRun = load,
        })
    end
    disconnect(g_app, {
        onExit = save,
    })

    hookedMenuOptions = {}

    stopSmartWalk()

    disconnect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd,
        onLoginAdvice = onLoginAdvice
    })

    for k, v in pairs(panelsList) do
        disconnect(v.checkbox, {
            onCheckChange = onSelectPanel
        })
    end
    
    logoutButton:destroy()
    gameRootPanel:destroy()
end

function onGameStart()
    show()

    leftIncreaseSidePanels:setEnabled(not modules.client_options.getOption('showLeftExtraPanel'))
    leftDecreaseSidePanels:setEnabled(modules.client_options.getOption('showLeftPanel'))
    rightIncreaseSidePanels:setEnabled(not modules.client_options.getOption('showRightExtraPanel'))
    rightDecreaseSidePanels:setEnabled(modules.client_options.getOption('showRightExtraPanel'))
end

function onGameEnd()
    hide()
end

function show()
    connect(g_app, {
        onClose = tryExit
    })
    modules.client_background.hide()
    gameRootPanel:show()
    gameRootPanel:focus()
    gameMapPanel:followCreature(g_game.getLocalPlayer())

    updateStretchShrink()
    logoutButton:setTooltip(tr('Logout'))

    gameMapPanel:setMaxZoomOut(14)
    gameMapPanel:setLimitVisibleRange(true)

    setupViewMode(0)
    setupViewMode(1)
    setupViewMode(2)
end

function hide()
    setupViewMode(0)

    disconnect(g_app, {
        onClose = tryExit
    })
    logoutButton:setTooltip(tr('Exit'))

    if logoutWindow then
        logoutWindow:destroy()
        logoutWindow = nil
    end
    if exitWindow then
        exitWindow:destroy()
        exitWindow = nil
    end
    if countWindow then
        countWindow:destroy()
        countWindow = nil
    end
    gameRootPanel:hide()
    modules.client_background.show()
end

function save()
    local settings = {}
    settings.splitterMarginBottom = bottomSplitter:getMarginBottom()
    g_settings.setNode('game_interface', settings)
end

function load()
    local settings = g_settings.getNode('game_interface')
    if settings then
        if settings.splitterMarginBottom then
            bottomSplitter:setMarginBottom(settings.splitterMarginBottom)
        end
    end
end

function onLoginAdvice(message)
    displayInfoBox(tr('For Your Information'), message)
end

function forceExit()
    g_game.cancelLogin()
    scheduleEvent(exit, 10)
    return true
end

function tryExit()
    if exitWindow then
        return true
    end

    local exitFunc = function()
        g_game.safeLogout()
        forceExit()
    end
    local logoutFunc = function()
        g_game.safeLogout()
        exitWindow:destroy()
        exitWindow = nil
    end
    local cancelFunc = function()
        exitWindow:destroy()
        exitWindow = nil
    end

    exitWindow = displayGeneralBox(tr('Sair'), tr(
            'Se você encerrar o programa, seu personagem poderá permanecer no jogo.\nClique em \'Sair\' para garantir que seu personagem saia do jogo corretamente.\nClique em \'Sair\' se quiser sair do programa sem fazer login fora seu personagem.'),
        {
            {
                text = tr('Voltar'),
                callback = cancelFunc
            },
            {
                text = tr('Deslogar'),
                callback = logoutFunc
            },
            {
                text = tr('Forçar'),
                callback = exitFunc
            },
            anchor = AnchorHorizontalCenter
        }, logoutFunc, cancelFunc)

    return true
end

function tryLogout(prompt)
    if type(prompt) ~= 'boolean' then
        prompt = true
    end
    if not g_game.isOnline() then
        exit()
        return
    end

    if logoutWindow then
        return
    end

    local msg, yesCallback
    if not g_game.isConnectionOk() then
        msg =
        'Your connection is failing, if you logout now your character will be still online, do you want to force logout?'

        yesCallback = function()
            g_game.forceLogout()
            if logoutWindow then
                logoutWindow:destroy()
                logoutWindow = nil
            end
        end
    else
        msg = 'Are you sure you want to logout?'

        yesCallback = function()
            g_game.safeLogout()
            if logoutWindow then
                logoutWindow:destroy()
                logoutWindow = nil
            end
        end
    end

    local noCallback = function()
        logoutWindow:destroy()
        logoutWindow = nil
    end

    if prompt then
        logoutWindow = displayGeneralBox(tr('Logout'), tr(msg), {
            {
                text = tr('No'),
                callback = noCallback
            },
            {
                text = tr('Yes'),
                callback = yesCallback
            },
            anchor = AnchorHorizontalCenter
        }, yesCallback, noCallback)
    else
        yesCallback()
    end
end

function stopSmartWalk()
    smartWalkDirs = {}
    smartWalkDir = nil
end

--- Solta a trava artificial de caminhada.
--
-- LocalPlayer::cancelWalk e LocalPlayer::autoWalk chamam lockWalk(), que
-- prende o personagem por 250 ms. E o que faz o boneco "engasgar" quando o
-- servidor recusa um passo (comum na diagonal, que dura mais) e o que
-- atrasa o primeiro passo depois de um clique.
--
-- Soltar e seguro: isWalkLocked() so e consultado por canWalk(), que ALEM
-- disso exige m_walkTimer >= getStepDuration() - 9. O ritmo dos passos
-- continua valendo; some apenas a espera artificial.
function releaseWalkLock()
    if not modules.client_options.getOption('smoothWalk') then
        return
    end
    local player = g_game.getLocalPlayer()
    if player then
        player:unlockWalk()
    end
end

function onWalkKeyDown(dir)
    if modules.client_options.getOption('autoChaseOverride') then
        if g_game.isAttacking() and g_game.getChaseMode() == ChaseOpponent then
            g_game.setChaseMode(DontChase)
        end
    end
    firstStep = true
    releaseWalkLock()
    changeWalkDir(dir)
end

function changeWalkDir(dir, pop)
    while table.removevalue(smartWalkDirs, dir) do
    end
    if pop then
        if #smartWalkDirs == 0 then
            stopSmartWalk()
            return
        end
    else
        table.insert(smartWalkDirs, 1, dir)
    end

    smartWalkDir = smartWalkDirs[1]
    if modules.client_options.getOption('smartWalk') and #smartWalkDirs > 1 then
        for _, d in pairs(smartWalkDirs) do
            if (smartWalkDir == North and d == West) or (smartWalkDir == West and d == North) then
                smartWalkDir = NorthWest
                break
            elseif (smartWalkDir == North and d == East) or (smartWalkDir == East and d == North) then
                smartWalkDir = NorthEast
                break
            elseif (smartWalkDir == South and d == West) or (smartWalkDir == West and d == South) then
                smartWalkDir = SouthWest
                break
            elseif (smartWalkDir == South and d == East) or (smartWalkDir == East and d == South) then
                smartWalkDir = SouthEast
                break
            end
        end
    end
end

function smartWalk(dir)
    if g_keyboard.getModifiers() ~= KeyboardNoModifier then
        return false
    end

    local dire = smartWalkDir or dir
    releaseWalkLock()
    g_game.walk(dire, firstStep)
    firstStep = false
    lastManualWalk = g_clock.millis()
    return true
end

function updateStretchShrink()
    if modules.client_options.getOption('dontStretchShrink') and not alternativeView then
        gameMapPanel:setVisibleDimension({
            width = 15,
            height = 11
        })

        -- Set gameMapPanel size to height = 11 * 32 + 2
        bottomSplitter:setMarginBottom(bottomSplitter:getMarginBottom() + (gameMapPanel:getHeight() - 32 * 11) - 10)
    end
end

function onMouseGrabberRelease(self, mousePosition, mouseButton)
    if selectedThing == nil then
        return false
    end
    if mouseButton == MouseLeftButton then
        local clickedWidget = gameRootPanel:recursiveGetChildByPos(mousePosition, false)
        if clickedWidget then
            if selectedType == 'use' then
                onUseWith(clickedWidget, mousePosition)
            elseif selectedType == 'trade' then
                onTradeWith(clickedWidget, mousePosition)
            end
        end
    end

    selectedThing = nil
    g_mouse.popCursor('target')
    self:ungrabMouse()
    return true
end

function onUseWith(clickedWidget, mousePosition)
    if clickedWidget:getClassName() == 'UIGameMap' then
        local tile = clickedWidget:getTile(mousePosition)
        if tile then
            if selectedThing:isFluidContainer() or selectedThing:isMultiUse() then
                g_game.useWith(selectedThing, tile:getTopMultiUseThing())
            else
                g_game.useWith(selectedThing, tile:getTopUseThing())
            end
        end
    elseif clickedWidget:getClassName() == 'UIItem' and not clickedWidget:isVirtual() then
        g_game.useWith(selectedThing, clickedWidget:getItem())
    elseif clickedWidget:getClassName() == 'UICreatureButton' then
        local creature = clickedWidget:getCreature()
        if creature then
            g_game.useWith(selectedThing, creature)
        end
    end
end

function onTradeWith(clickedWidget, mousePosition)
    if clickedWidget:getClassName() == 'UIGameMap' then
        local tile = clickedWidget:getTile(mousePosition)
        if tile then
            g_game.requestTrade(selectedThing, tile:getTopCreature())
        end
    elseif clickedWidget:getClassName() == 'UICreatureButton' then
        local creature = clickedWidget:getCreature()
        if creature then
            g_game.requestTrade(selectedThing, creature)
        end
    end
end

function startUseWith(thing)
    if not thing then
        return
    end
    if g_ui.isMouseGrabbed() then
        if selectedThing then
            selectedThing = thing
            selectedType = 'use'
        end
        return
    end
    selectedType = 'use'
    selectedThing = thing
    mouseGrabberWidget:grabMouse()
    g_mouse.pushCursor('target')
end

function startTradeWith(thing)
    if not thing then
        return
    end
    if g_ui.isMouseGrabbed() then
        if selectedThing then
            selectedThing = thing
            selectedType = 'trade'
        end
        return
    end
    selectedType = 'trade'
    selectedThing = thing
    mouseGrabberWidget:grabMouse()
    g_mouse.pushCursor('target')
end

function isMenuHookCategoryEmpty(category)
    if category then
        for _, opt in pairs(category) do
            if opt then
                return false
            end
        end
    end
    return true
end

function addMenuHook(category, name, callback, condition, shortcut)
    if not hookedMenuOptions[category] then
        hookedMenuOptions[category] = {}
    end
    hookedMenuOptions[category][name] = {
        callback = callback,
        condition = condition,
        shortcut = shortcut
    }
end

function removeMenuHook(category, name)
    if not name then
        hookedMenuOptions[category] = {}
    else
        hookedMenuOptions[category][name] = nil
    end
end

function createThingMenu(menuPosition, lookThing, useThing, creatureThing)
    if not g_game.isOnline() then
        return
    end

    local menu = g_ui.createWidget('PopupMenu')
    menu:setGameMenu(true)

    local classic = modules.client_options.getOption('classicControl')
    local shortcut = nil

    if not classic then
        shortcut = '(Shift)'
    else
        shortcut = nil
    end
    if lookThing then
        menu:addOption(tr('Ver'), function()
            g_game.look(lookThing)
        end, shortcut)
    end

    if not classic then
        shortcut = '(Ctrl)'
    else
        shortcut = nil
    end
    if useThing then
        if useThing:isContainer() then
            if useThing:getParentContainer() then
                menu:addOption(tr('Abrir'), function()
                    g_game.open(useThing, useThing:getParentContainer())
                end, shortcut)
                menu:addOption(tr('Abrir em uma nova janela'), function()
                    g_game.open(useThing)
                end)
            else
                menu:addOption(tr('Abrir'), function()
                    g_game.open(useThing)
                end, shortcut)
            end
        else
            if useThing:isMultiUse() then
                menu:addOption(tr('Usar em ...'), function()
                    startUseWith(useThing)
                end, shortcut)
            else
                menu:addOption(tr('Usar'), function()
                    g_game.use(useThing)
                end, shortcut)
            end

            -- Thalles Vitor - Empilhar Dinheiro
            if isInArray({3043, 3035, 3031}, useThing:getId()) then
                menu:addOption(tr('Empilhar Dinheiro'), function() g_game.getProtocolGame():sendExtendedOpcode(99) end, shortcut)
            end
        end

        if useThing:isRotateable() then
            menu:addOption(tr('Virar'), function()
                g_game.rotate(useThing)
            end)
        end

        local onWrapItem = function()
            g_game.wrap(useThing)
        end
        if useThing:isWrapable() then
            menu:addOption(tr('Wrap'), onWrapItem)
        end
        if useThing:isUnwrapable() then
            menu:addOption(tr('Unwrap'), onWrapItem)
        end

        if g_game.getFeature(GameBrowseField) and useThing:getPosition().x ~= 0xffff then
            menu:addOption(tr('Browse Field'), function()
                g_game.browseField(useThing:getPosition())
            end)
        end
    end

    if lookThing and not lookThing:isCreature() and not lookThing:isNotMoveable() and lookThing:isPickupable() then
        menu:addSeparator()
        menu:addOption(tr('Trocar com ...'), function()
            startTradeWith(lookThing)
        end)
    end

    if lookThing then
        local parentContainer = lookThing:getParentContainer()
        if parentContainer and parentContainer:hasParent() then
            menu:addOption(tr('Mover para cima'), function()
                g_game.moveToParentContainer(lookThing, lookThing:getCount())
            end)
        end
    end

    if creatureThing then
        local localPlayer = g_game.getLocalPlayer()
        menu:addSeparator()

        if creatureThing:isLocalPlayer() then
            menu:addOption(tr("Mudar Roupa"), function()
                g_game.requestOutfit()
            end)

            menu:addOption(tr('Desbugar'), function()
                g_game.talk("!bug")
            end)

            if creatureThing:isPartyMember() then
                if creatureThing:isPartyLeader() then
                    if creatureThing:isPartySharedExperienceActive() then
                        menu:addOption(tr('Desativar Experiência Compartilhada'), function()
                            g_game.partyShareExperience(false)
                        end)
                    else
                        menu:addOption(tr('Ativar Experiência Compartilhada'), function()
                            g_game.partyShareExperience(true)
                        end)
                    end
                end
                menu:addOption(tr('Sair da Party'), function()
                    g_game.partyLeave()
                end)
            end
        else
            local localPosition = localPlayer:getPosition()
            if not classic then
                shortcut = '(Alt)'
            else
                shortcut = nil
            end
            if creatureThing:getPosition().z == localPosition.z then
                if g_game.getAttackingCreature() ~= creatureThing then
                    menu:addOption(tr('Atacar'), function()
                        g_game.attack(creatureThing)
                    end, shortcut)
                else
                    menu:addOption(tr('Parar de Atacar'), function()
                        g_game.cancelAttack()
                    end, shortcut)
                end

                if g_game.getFollowingCreature() ~= creatureThing then
                    menu:addOption(tr('Seguir'), function()
                        g_game.follow(creatureThing)
                    end)
                else
                    menu:addOption(tr('Parar de Seguir'), function()
                        g_game.cancelFollow()
                    end)
                end
            end

            if creatureThing:isNpc() then
                menu:addOption(tr('Conversar'), function() 
                 local destPos = creatureThing:getPosition()
                 local myPos = g_game.getLocalPlayer():getPosition()                       
                   if ((destPos.x >= myPos.x - 3) and (destPos.x <= myPos.x + 3) and (destPos.y >= myPos.y - 3) and (destPos.y <= myPos.y + 3)) then
                     scheduleEvent(g_game.talkChannel(11,0,"hi"), 500)
                   else
                   --   modules.game_textmessage.displayFailureMessage("Voc no pode conversar com o NPC pois Voc est muito longe. Aproxime-se e tente novamente.")
                   end
               end, shortcut)
              end

            if creatureThing:isPlayer() then
                menu:addSeparator()
                local creatureName = creatureThing:getName()
                menu:addOption(tr('Enviar mensagem para %s', creatureName), function()
                    g_game.openPrivateChannel(creatureName)
                end)
                if modules.game_console.getOwnPrivateTab() then
                    menu:addOption(tr('Convidar para o chat privado'), function()
                        g_game.inviteToOwnChannel(creatureName)
                    end)
                    menu:addOption(tr('Remover do chat privado'), function()
                        g_game.excludeFromOwnChannel(creatureName)
                    end) -- [TODO] must be removed after message's popup labels been implemented
                end
                if not localPlayer:hasVip(creatureName) then
                    menu:addOption(tr('Adicionar a Lista de Amigos'), function()
                        g_game.addVip(creatureName)
                    end)
                end

                if modules.game_console.isIgnored(creatureName) then
                    menu:addOption(tr('Designorar') .. ' ' .. creatureName, function()
                        modules.game_console.removeIgnoredPlayer(creatureName)
                    end)
                else
                    menu:addOption(tr('Ignorar') .. ' ' .. creatureName, function()
                        modules.game_console.addIgnoredPlayer(creatureName)
                    end)
                end

                local localPlayerShield = localPlayer:getShield()
                local creatureShield = creatureThing:getShield()

                if localPlayerShield == ShieldNone or localPlayerShield == ShieldWhiteBlue then
                    if creatureShield == ShieldWhiteYellow then
                        menu:addOption(tr('Entrar na Party %s\'s', creatureThing:getName()), function()
                            g_game.partyJoin(creatureThing:getId())
                        end)
                    else
                        menu:addOption(tr('Convidar para a Party'), function()
                            g_game.partyInvite(creatureThing:getId())
                        end)
                    end
                elseif localPlayerShield == ShieldWhiteYellow then
                    if creatureShield == ShieldWhiteBlue then
                        menu:addOption(tr('Revogar convite da Party %s\'s', creatureThing:getName()), function()
                            g_game.partyRevokeInvitation(creatureThing:getId())
                        end)
                    end
                elseif localPlayerShield == ShieldYellow or localPlayerShield == ShieldYellowSharedExp or
                    localPlayerShield == ShieldYellowNoSharedExpBlink or localPlayerShield == ShieldYellowNoSharedExp then
                    if creatureShield == ShieldWhiteBlue then
                        menu:addOption(tr('Revogar convite da Party %s\'s', creatureThing:getName()), function()
                            g_game.partyRevokeInvitation(creatureThing:getId())
                        end)
                    elseif creatureShield == ShieldBlue or creatureShield == ShieldBlueSharedExp or creatureShield ==
                        ShieldBlueNoSharedExpBlink or creatureShield == ShieldBlueNoSharedExp then
                        menu:addOption(tr('Passar liderança para %s', creatureThing:getName()), function()
                            g_game.partyPassLeadership(creatureThing:getId())
                        end)
                    else
                        menu:addOption(tr('Convidar para a Party'), function()
                            g_game.partyInvite(creatureThing:getId())
                        end)
                    end
                end
            end
        end

        if modules.game_ruleviolation.hasWindowAccess() and creatureThing:isPlayer() then
            menu:addSeparator()
            menu:addOption(tr('Violação de Regras'), function()
                modules.game_ruleviolation.show(creatureThing:getName())
            end)
        end

        menu:addSeparator()
        menu:addOption(tr('Copiar Nome'), function()
            g_window.setClipboardText(creatureThing:getName())
        end)
    end

    -- hooked menu options
    for _, category in pairs(hookedMenuOptions) do
        if not isMenuHookCategoryEmpty(category) then
            menu:addSeparator()
            for name, opt in pairs(category) do
                if opt and opt.condition(menuPosition, lookThing, useThing, creatureThing) then
                    menu:addOption(name, function()
                        opt.callback(menuPosition, lookThing, useThing, creatureThing)
                    end, opt.shortcut)
                end
            end
        end
    end

    menu:display(menuPosition)
end

function processMouseAction(menuPosition, mouseButton, autoWalkPos, lookThing, useThing, creatureThing, attackCreature)
    local keyboardModifiers = g_keyboard.getModifiers()

    if not modules.client_options.getOption('classicControl') then
        if keyboardModifiers == KeyboardNoModifier and mouseButton == MouseRightButton then
            createThingMenu(menuPosition, lookThing, useThing, creatureThing)
            return true
        elseif lookThing and keyboardModifiers == KeyboardShiftModifier and
            (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
            g_game.look(lookThing)
            return true
        elseif useThing and keyboardModifiers == KeyboardCtrlModifier and
            (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
            if useThing:isContainer() then
                if useThing:getParentContainer() then
                    g_game.open(useThing, useThing:getParentContainer())
                else
                    g_game.open(useThing)
                end
                return true
            elseif useThing:isMultiUse() then
                startUseWith(useThing)
                return true
            else
                g_game.use(useThing)
                return true
            end
            return true
        elseif useThing and useThing:isContainer() and keyboardModifiers == KeyboardCtrlShiftModifier and
            (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
            g_game.open(useThing)
            return true
        elseif attackCreature and g_keyboard.isAltPressed() and
            (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
            g_game.attack(attackCreature)
            return true
        elseif creatureThing and creatureThing:getPosition().z == autoWalkPos.z and g_keyboard.isAltPressed() and
            (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
            g_game.attack(creatureThing)
            return true
        elseif creatureThing and creatureThing.isNpc() and g_keyboard.isAltPressed() and (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
            local destPos = attackCreature:getPosition()
                 local myPos = g_game.getLocalPlayer():getPosition()                       
                   if ((destPos.x >= myPos.x - 3) and (destPos.x <= myPos.x + 3) and (destPos.y >= myPos.y - 3) and (destPos.y <= myPos.y + 3)) then
                     scheduleEvent(g_game.talkChannel(11,0,"hi"), 500)
                   else
                      --modules.game_textmessage.displayFailureMessage("Voc no pode conversar com o NPC pois Voc est muito longe. Aproxime-se e tente novamente.")
                   end
           return true
        end

        -- classic control
    else
        if useThing and keyboardModifiers == KeyboardNoModifier and mouseButton == MouseRightButton and
            not g_mouse.isPressed(MouseLeftButton) then
            local player = g_game.getLocalPlayer()
            if attackCreature and attackCreature ~= player then
              if not attackCreature:isNpc() then
                 g_game.attack(attackCreature)
              else
                 local destPos = attackCreature:getPosition()
                 local myPos = player:getPosition()                       
                   if ((destPos.x >= myPos.x - 3) and (destPos.x <= myPos.x + 3) and (destPos.y >= myPos.y - 3) and (destPos.y <= myPos.y + 3)) then
                     scheduleEvent(g_game.talkChannel(11,0,"hi"), 500)
                   else
                --      modules.game_textmessage.displayFailureMessage("Voc no pode conversar com o NPC pois Voc est muito longe. Aproxime-se e tente novamente.")
                   end
              end
              return true
            elseif creatureThing and creatureThing ~= player and creatureThing:getPosition().z == autoWalkPos.z then
                g_game.attack(creatureThing)
                return true
            elseif useThing:isContainer() then
                if useThing:getParentContainer() then
                    g_game.open(useThing, useThing:getParentContainer())
                    return true
                else
                    g_game.open(useThing)
                    return true
                end
            elseif useThing:isMultiUse() then
                startUseWith(useThing)
                return true
            else
                g_game.use(useThing)
                return true
            end
            return true
        elseif useThing and useThing:isContainer() and keyboardModifiers == KeyboardCtrlShiftModifier and
            (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
            g_game.open(useThing)
            return true
        elseif lookThing and keyboardModifiers == KeyboardShiftModifier and
            (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
            g_game.look(lookThing)
            return true
        elseif lookThing and ((g_mouse.isPressed(MouseLeftButton) and mouseButton == MouseRightButton) or
                (g_mouse.isPressed(MouseRightButton) and mouseButton == MouseLeftButton)) then
            g_game.look(lookThing)
            return true
        elseif useThing and keyboardModifiers == KeyboardCtrlModifier and
            (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
            createThingMenu(menuPosition, lookThing, useThing, creatureThing)
            return true
        elseif attackCreature and g_keyboard.isAltPressed() and
            (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
            g_game.attack(attackCreature)
            return true
        elseif creatureThing and creatureThing:getPosition().z == autoWalkPos.z and g_keyboard.isAltPressed() and
            (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
            g_game.attack(creatureThing)
            return true
        end
    end

    local player = g_game.getLocalPlayer()
    player:stopAutoWalk()

    if autoWalkPos and keyboardModifiers == KeyboardNoModifier and mouseButton == MouseLeftButton then
        player:autoWalk(autoWalkPos)
        -- autoWalk trava 250 ms logo apos iniciar; sem isso o primeiro
        -- passo do clique sai com atraso visivel.
        releaseWalkLock()
        if g_game.isAttacking() and g_game.getChaseMode() == ChaseOpponent then
            g_game.setChaseMode(DontChase)
            return true
        end
        return true
    end

    return false
end

function moveStackableItem(item, toPos)
    if countWindow then
        return
    end
    if g_keyboard.isShiftPressed() then
        g_game.move(item, toPos, 1)
        return
    elseif g_keyboard.isCtrlPressed() ~= modules.client_options.getOption('moveStack') then
        g_game.move(item, toPos, item:getCount())
        return
    end
    local count = item:getCount()

    countWindow = g_ui.createWidget('CountWindow', rootWidget)
    local itembox = countWindow:getChildById('item')
    local scrollbar = countWindow:getChildById('countScrollBar')
    itembox:setItemId(item:getId())
    itembox:setItemCount(count)
    scrollbar:setMaximum(count)
    scrollbar:setMinimum(1)
    scrollbar:setValue(count)

    local spinbox = countWindow:getChildById('spinBox')
    spinbox:setMaximum(count)
    spinbox:setMinimum(0)
    spinbox:setValue(0)
    spinbox:hideButtons()
    spinbox:focus()
    spinbox.firstEdit = true

    local spinBoxValueChange = function(self, value)
        spinbox.firstEdit = false
        scrollbar:setValue(value)
    end
    spinbox.onValueChange = spinBoxValueChange

    local check = function()
        if spinbox.firstEdit then
            spinbox:setValue(spinbox:getMaximum())
            spinbox.firstEdit = false
        end
    end
    g_keyboard.bindKeyPress('Up', function()
        check()
        spinbox:upSpin()
    end, spinbox)
    g_keyboard.bindKeyPress('Down', function()
        check()
        spinbox:downSpin()
    end, spinbox)
    g_keyboard.bindKeyPress('Right', function()
        check()
        spinbox:upSpin()
    end, spinbox)
    g_keyboard.bindKeyPress('Left', function()
        check()
        spinbox:downSpin()
    end, spinbox)
    g_keyboard.bindKeyPress('PageUp', function()
        check()
        spinbox:setValue(spinbox:getValue() + 10)
    end, spinbox)
    g_keyboard.bindKeyPress('PageDown', function()
        check()
        spinbox:setValue(spinbox:getValue() - 10)
    end, spinbox)

    scrollbar.onValueChange = function(self, value)
        itembox:setItemCount(value)
        spinbox.onValueChange = nil
        spinbox:setValue(value)
        spinbox.onValueChange = spinBoxValueChange
    end

    local okButton = countWindow:getChildById('buttonOk')
    local moveFunc = function()
        g_game.move(item, toPos, itembox:getItemCount())
        okButton:getParent():destroy()
        countWindow = nil
        modules.game_hotkeys.enableHotkeys(true)
    end
    local cancelButton = countWindow:getChildById('buttonCancel')
    local cancelFunc = function()
        cancelButton:getParent():destroy()
        countWindow = nil
        modules.game_hotkeys.enableHotkeys(true)
    end

    countWindow.onEnter = moveFunc
    countWindow.onEscape = cancelFunc

    okButton.onClick = moveFunc
    cancelButton.onClick = cancelFunc

    modules.game_hotkeys.enableHotkeys(false)
end
function onSelectPanel(self, checked)
    if checked then
        for k, v in pairs(panelsList) do
            if v.checkbox == self then
                gameSelectedPanel = v.panel
                break
            end
        end
    end
end
function getRootPanel()
    return gameRootPanel
end

function getMapPanel()
    return gameMapPanel
end

--- Aplica as quatro opcoes de painel lateral e reflete nos botoes.
-- Chamada pelas opcoes e ao entrar no jogo, para o estado sobreviver a
-- reabertura do cliente (g_settings ja persiste as opcoes por si).
--- Loot em area: recolhe de uma vez o que caiu dos pokemons por perto.
-- O trabalho e todo do servidor (creaturescripts/scripts/lootall.lua);
-- aqui so avisamos pelo mesmo canal que o autoloot ja usa.
LOOT_ALL_OPCODE = 150

function lootAll()
    if not g_game.isOnline() then
        return
    end
    local protocol = g_game.getProtocolGame()
    if protocol then
        protocol:sendExtendedOpcode(LOOT_ALL_OPCODE, "")
    end
end

function applySidePanels()
    local opt = modules.client_options.getOption

    local left       = opt('showLeftPanel')
    local leftExtra  = opt('showLeftExtraPanel')
    local right      = opt('showRightPanel')
    local rightExtra = opt('showRightExtraPanel')

    if gameLeftPanel then gameLeftPanel:setOn(left) end
    if gameLeftExtraPanel then gameLeftExtraPanel:setOn(leftExtra) end
    if gameRightPanel then gameRightPanel:setOn(right) end
    if gameRightExtraPanel then gameRightExtraPanel:setOn(rightExtra) end

    -- As setinhas so fazem sentido na direcao que ainda da para mexer.
    if leftIncreaseSidePanels then leftIncreaseSidePanels:setEnabled(not leftExtra) end
    if leftDecreaseSidePanels then leftDecreaseSidePanels:setEnabled(leftExtra or left) end
    if rightIncreaseSidePanels then rightIncreaseSidePanels:setEnabled(not rightExtra) end
    if rightDecreaseSidePanels then rightDecreaseSidePanels:setEnabled(rightExtra or right) end
end

--- Botoes de aumentar/diminuir: existiam no .otui sem nenhum handler.
-- Aumentar abre o painel extra daquele lado; diminuir fecha o extra e,
-- se ele ja estava fechado, fecha o principal.
function increaseSidePanels(side)
    local opt = modules.client_options
    if side == 'left' then
        if not opt.getOption('showLeftPanel') then
            opt.setOption('showLeftPanel', true)
        else
            opt.setOption('showLeftExtraPanel', true)
        end
    else
        if not opt.getOption('showRightPanel') then
            opt.setOption('showRightPanel', true)
        else
            opt.setOption('showRightExtraPanel', true)
        end
    end
end

function decreaseSidePanels(side)
    local opt = modules.client_options
    if side == 'left' then
        if opt.getOption('showLeftExtraPanel') then
            opt.setOption('showLeftExtraPanel', false)
        else
            opt.setOption('showLeftPanel', false)
        end
    else
        if opt.getOption('showRightExtraPanel') then
            opt.setOption('showRightExtraPanel', false)
        else
            opt.setOption('showRightPanel', false)
        end
    end
end

function getRightPanel()
    return gameRightPanel
end

function getMainRightPanel()
    return gameMainRightPanel
end

function getLeftPanel()
    return gameLeftPanel
end

function getRightExtraPanel()
    return gameRightExtraPanel
end

function getLeftExtraPanel()
    return gameLeftExtraPanel
end

function getSelectedPanel()
    return gameSelectedPanel
end

function getBottomPanel()
    return gameBottomPanel
end

function getShowTopMenuButton()
    return showTopMenuButton
end
function getGameTopStatsBar()
    return gameTopPanel
end

function getGameMapPanel()
    return gameMapPanel
end

function findContentPanelAvailable(child, minContentHeight)
    if gameSelectedPanel and gameSelectedPanel:isVisible() and gameSelectedPanel:fits(child, minContentHeight, 0) >= 0 then
        return gameSelectedPanel
    end

    for k, v in pairs(panelsList) do
        if v.panel ~= gameSelectedPanel and v.panel:isVisible() and v.panel:fits(child, minContentHeight, 0) >= 0 then
            return v.panel
        end
    end

    return gameSelectedPanel
end

function nextViewMode()
    setupViewMode((currentViewMode + 1) % 3)
end

function setupViewMode(mode)
    if mode == currentViewMode then
        return
    end

    leftIncreaseSidePanels:setEnabled(not modules.client_options.getOption('showLeftExtraPanel'))
    leftDecreaseSidePanels:setEnabled(modules.client_options.getOption('showLeftPanel'))
    rightIncreaseSidePanels:setEnabled(not modules.client_options.getOption('showRightExtraPanel'))
    rightDecreaseSidePanels:setEnabled(modules.client_options.getOption('showRightExtraPanel'))

    if currentViewMode == 2 then
        gameMapPanel:addAnchor(AnchorLeft, 'gameLeftPanel', AnchorRight)
        gameMapPanel:addAnchor(AnchorRight, 'gameRightPanel', AnchorLeft)
        gameMapPanel:addAnchor(AnchorRight, 'gameRightExtraPanel', AnchorLeft)
        gameMapPanel:addAnchor(AnchorBottom, 'gameBottomPanel', AnchorTop)
        gameRootPanel:setImageColor('white')
        gameRootPanel:setBackgroundColor('alpha')
        applySidePanels()
       --[[  gameRightPanel:setMarginTop(modules.client_topmenu.getTopMenu():getHeight() - gameRightPanel:getPaddingTop() + 25) ]]
        gameLeftPanel:setImageColor('white')
        gameRightPanel:setImageColor('white')
        gameRightExtraPanel:setImageColor('white')
        gameLeftPanel:setMarginTop(0)
        --[[ gameRightPanel:setMarginTop(0) ]]
        gameRightExtraPanel:setMarginTop(0)
        gameBottomPanel:setImageColor('white')
    end
    if mode == 0 then
        gameMapPanel:setKeepAspectRatio(true)
        gameMapPanel:setLimitVisibleRange(false)
        gameMapPanel:setZoom(18)
        gameMapPanel:setVisibleDimension({
            width = 15,
            height = 11
        })
    elseif mode == 1 then
        gameMapPanel:setKeepAspectRatio(false)
        gameMapPanel:setLimitVisibleRange(true)
        gameMapPanel:setZoom(18)
        gameMapPanel:setVisibleDimension({
            width = 15,
            height = 11
        })
    elseif mode == 2 then
        local limit = limitedZoom
        gameMapPanel:setLimitVisibleRange(limit)
        gameMapPanel:setZoom(18)
        gameMapPanel:setVisibleDimension({
            width = 15,
            height = 11
        })
        gameMapPanel:fill('parent')
        gameRootPanel:fill('parent')
        gameLeftPanel:setImageColor('alpha')
        gameRightPanel:setImageColor('alpha')
        gameRightExtraPanel:setImageColor('alpha')
        gameLeftExtraPanel:setImageColor('alpha')
        gameLeftPanel:setMarginTop(modules.client_topmenu.getTopMenu():getHeight() - gameLeftPanel:getPaddingTop())
        gameRightPanel:setMarginTop(modules.client_topmenu.getTopMenu():getHeight() - gameRightPanel:getPaddingTop())
        gameRightExtraPanel:setMarginTop(modules.client_topmenu.getTopMenu():getHeight() -
            gameRightExtraPanel:getPaddingTop())
        gameLeftExtraPanel:setMarginTop(modules.client_topmenu.getTopMenu():getHeight() -
            gameLeftExtraPanel:getPaddingTop())
        gameLeftPanel:setOn(true)
        gameLeftPanel:setVisible(true)
        gameRightPanel:setOn(true)
        gameRightExtraPanel:setOn(false)
        gameRightExtraPanel:setVisible(false)
        gameLeftExtraPanel:setOn(false)
        gameLeftExtraPanel:setVisible(false)
        gameMapPanel:setOn(true)
        gameBottomPanel:setImageColor('#ffffff88')
        modules.client_topmenu.getTopMenu():setImageColor('#ffffff66')
    end

    currentViewMode = mode
end

function limitZoom()
    limitedZoom = true
end


function setStatsBarOption(dimension, placement)
    StatsBar.setStatsBarOption(dimension, placement)
end

function onIncreaseLeftPanels()
    leftDecreaseSidePanels:setEnabled(true)
    if not modules.client_options.getOption('showLeftPanel') then
        modules.client_options.setOption('showLeftPanel', true)
        return
    end

    if not modules.client_options.getOption('showLeftExtraPanel') then
        modules.client_options.setOption('showLeftExtraPanel', true)
        leftIncreaseSidePanels:setEnabled(false)
        return
    end
end

local function movePanel(mainpanel)
    for _, widget in pairs(mainpanel:getChildren()) do
        if widget then
            local panel = modules.game_interface.findContentPanelAvailable(widget, widget:getMinimumHeight())      
            if panel then
                if not panel:hasChild(widget) then
                    widget:close()
                    panel:addChild(widget)
                else
                    print("Error: Attempt to add a widget that already exists in the target panel")
                end
            else
                print("Warning: No suitable panel found for widget, unable to move")
            end
        end
    end
end

function onDecreaseLeftPanels()
    leftIncreaseSidePanels:setEnabled(true)
    if modules.client_options.getOption('showLeftExtraPanel') then
        modules.client_options.setOption('showLeftExtraPanel', false)
        movePanel(gameLeftExtraPanel)
        return
    end

    if modules.client_options.getOption('showLeftPanel') then
        modules.client_options.setOption('showLeftPanel', false)
        movePanel(gameLeftPanel)
        leftDecreaseSidePanels:setEnabled(false)
        return
    end
end

function onIncreaseRightPanels()
    rightIncreaseSidePanels:setEnabled(false)
    rightDecreaseSidePanels:setEnabled(true)
    modules.client_options.setOption('showRightExtraPanel', true)
end

function onDecreaseRightPanels()
    rightIncreaseSidePanels:setEnabled(true)
    rightDecreaseSidePanels:setEnabled(false)
    movePanel(gameRightExtraPanel)
    modules.client_options.setOption('showRightExtraPanel', false)
end

function setupOptionsMainButton()
    if logOutMainButton then
        return
    end

    logOutMainButton = modules.game_mainpanel.addSpecialToggleButton('logoutButton', tr('Sair'), '/images/options/button_logout',
    tryLogout)
end

function checkAndOpenLeftPanel()
    leftDecreaseSidePanels:setEnabled(true)
    if not modules.client_options.getOption('showLeftPanel') then
        modules.client_options.setOption('showLeftPanel', true)
        return
    end
end

function hideChat()
    if not closeChat:isVisible() then
      gameBottomPanel:setVisible(false)
      closeChat:show()

      gameActionPanel:setMarginTop(110)
      modules.game_battle.enableAutoTarget()
      --[[ modules.game_pokemoves.getPokeMoves():setMarginBottom(90) ]]
    else
      gameBottomPanel:setVisible(true) 
      closeChat:hide()   

      gameActionPanel:setMarginTop(-50)
      modules.game_battle.disableAutoTarget()
     --[[  modules.game_pokemoves.getPokeMoves():setMarginBottom(244) ]]
    end
end


function getActionPanel()
    return gameActionPanel
end