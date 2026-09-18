event = nil

-- Declarados aqui, no topo: um local so existe para o que vem DEPOIS dele
-- no arquivo. Como clean() aparece antes da tira de bags, deixa-los la
-- embaixo faria clean() enxergar um global nil e nao limpar nada.
local bagBarWindow = nil
local activeContainerId = nil

function init()
    g_ui.importStyle('container')

    connect(Container, {
        onOpen = onContainerOpen,
        onClose = onContainerClose,
        onSizeChange = onContainerChangeSize,
        onUpdateItem = onContainerUpdateItem
    })
    connect(Game, {
        onGameEnd = clean()
    })

    reloadContainers()
end

function terminate()
    disconnect(Container, {
        onOpen = onContainerOpen,
        onClose = onContainerClose,
        onSizeChange = onContainerChangeSize,
        onUpdateItem = onContainerUpdateItem
    })
    disconnect(Game, {
        onGameEnd = clean()
    })
end

function reloadContainers()
    clean()
    for _, container in pairs(g_game.getContainers()) do
        onContainerOpen(container)
    end
end

function clean()
    for containerid, container in pairs(g_game.getContainers()) do
        destroy(container)
    end
    -- A tira acompanha as bags: sem elas, nao sobra na tela.
    if bagBarWindow and not bagBarWindow:isDestroyed() then
        bagBarWindow:destroy()
        bagBarWindow = nil
    end
    activeContainerId = nil
end

function destroy(container)
    if container.window then
        container.window:destroy()
        container.window = nil
        container.itemsPanel = nil
    end
end

function refreshContainerItems(container)
    for slot = 0, container:getCapacity() - 1 do
        local itemWidget = container.itemsPanel:getChildById('item' .. slot)
        itemWidget:setItem(container:getItem(slot))

        itemWidget:setTooltip("")
        modules.game_inventory.onTooltipContainers(itemWidget, container:getItem(slot))
    end

    if container:hasPages() then
        refreshContainerPages(container)
    end

    if container and container:getName() == "Catch Bag" then
        local total = 0
        local max = 30
        for slot = 0, container:getCapacity() - 1 do
            local item = container:getItem(slot)
            if item then
                total = total + 1
            end
        end

        container.window:setText(container:getName() .. " " ..total .. "/" .. max)
    end

    local theContainer = container
    event = scheduleEvent(function()
      refreshContainerItems(theContainer)
      removeEvent(event)
    end, 10)
end

function toggleContainerPages(containerWindow, pages)
    containerWindow:getChildById('miniwindowScrollBar'):setMarginTop(pages and 42 or 22)
    containerWindow:getChildById('contentsPanel'):setMarginTop(pages and 42 or 22)
    containerWindow:getChildById('contentsPanel'):setMarginRight(-15) -- Thalles
    containerWindow:getChildById('pagePanel'):setVisible(pages)
end

function refreshContainerPages(container)
    local currentPage = 1 + math.floor(container:getFirstIndex() / container:getCapacity())
    local pages = 1 + math.floor(math.max(0, (container:getSize()- 1)) / container:getCapacity())
    container.window:recursiveGetChildById('pageLabel'):setText(string.format('Page %i of %i', currentPage, pages))

    local prevPageButton = container.window:recursiveGetChildById('prevPageButton')
    if currentPage == 1 then
        prevPageButton:setEnabled(false)
    else
        prevPageButton:setEnabled(true)
        prevPageButton.onClick = function()
            g_game.seekInContainer(container:getId(), container:getFirstIndex() - container:getCapacity())
        end
    end

    local nextPageButton = container.window:recursiveGetChildById('nextPageButton')
    if currentPage >= pages then
        nextPageButton:setEnabled(false)
    else
        nextPageButton:setEnabled(true)
        nextPageButton.onClick = function()
            g_game.seekInContainer(container:getId(), container:getFirstIndex() + container:getCapacity())
        end
    end
end

-- ---------------------------------------------------------------------
-- Inventario unico
--
-- Cada bag aberta continua sendo uma ContainerWindow propria -- toda a
-- logica de paginacao, arrastar item e entrar em bag aninhada fica
-- intacta. O que muda e que so UMA aparece por vez, e uma tira de icones
-- alterna entre elas, em vez de encher a tela de janelas soltas.
--
-- Trocar a apresentacao em vez do sistema foi deliberado: o servidor
-- depende dos slots em 114 arquivos (182 leituras so do slot 8, onde fica
-- a pokebola ativa). Mexer nisso teria risco alto e ganho invisivel.
-- ---------------------------------------------------------------------

local function bagBar()
    if not bagBarWindow or bagBarWindow:isDestroyed() then
        return nil
    end
    return bagBarWindow:recursiveGetChildById('bagBar')
end

--- Mostra so a bag escolhida; as demais ficam ocultas, nao destruidas.
function setActiveContainer(containerId)
    activeContainerId = containerId

    for _, container in pairs(g_game.getContainers()) do
        local win = container.window
        if win and not win:isDestroyed() then
            win:setVisible(container:getId() == containerId)
        end
    end

    local bar = bagBar()
    if bar then
        for _, btn in ipairs(bar:getChildren()) do
            btn:setChecked(btn.containerId == containerId)
        end
    end
end

--- Reconstroi a tira a partir das bags abertas.
function refreshBagBar()
    local containers = g_game.getContainers()

    -- Sem bag aberta a tira nao tem razao de existir.
    local count = 0
    for _ in pairs(containers) do
        count = count + 1
    end

    if count == 0 then
        if bagBarWindow and not bagBarWindow:isDestroyed() then
            bagBarWindow:destroy()
            bagBarWindow = nil
        end
        activeContainerId = nil
        return
    end

    if not bagBarWindow or bagBarWindow:isDestroyed() then
        bagBarWindow = g_ui.createWidget('BagBarWindow')
        local panel = modules.game_interface.findContentPanelAvailable(bagBarWindow, 60)
        panel:addChild(bagBarWindow)
        bagBarWindow:setup()
    end

    local bar = bagBar()
    if not bar then
        return
    end
    bar:destroyChildren()

    local stillOpen = false
    for _, container in pairs(containers) do
        local btn = g_ui.createWidget('BagTabButton', bar)
        btn.containerId = container:getId()
        btn:setItem(container:getContainerItem())
        btn:setTooltip(container:getName())
        btn.onClick = function(self)
            setActiveContainer(self.containerId)
        end
        if container:getId() == activeContainerId then
            stillOpen = true
        end
    end

    -- A bag ativa pode ter sido fechada: cai para a primeira disponivel.
    if not stillOpen then
        for _, container in pairs(containers) do
            activeContainerId = container:getId()
            break
        end
    end

    setActiveContainer(activeContainerId)
end

function onContainerOpen(container, previousContainer)
    local containerWindow
    if previousContainer then
        containerWindow = previousContainer.window
        previousContainer.window = nil
        previousContainer.itemsPanel = nil
    else
        containerWindow = g_ui.createWidget('ContainerWindow')
    end
    containerWindow:setId('container' .. container:getId())
    local containerPanel = containerWindow:getChildById('contentsPanel')
    local containerItemWidget = containerWindow:getChildById('containerItemWidget')
    containerWindow.onClose = function()
        g_game.close(container)
        containerWindow:hide()
    end

    -- this disables scrollbar auto hiding
    local scrollbar = containerWindow:getChildById('miniwindowScrollBar')
    scrollbar:mergeStyle({
        ['$!on'] = {}
    })

    local upButton = containerWindow:getChildById('upButton')
    upButton.onClick = function()
        g_game.openParent(container)
    end
    upButton:setVisible(container:hasParent())

    local name = container:getName()
    name = name:sub(1, 1):upper() .. name:sub(2)

    if name:len() > 11 then
        name = string.sub(name, 1, #name - 3)
        name = name .. "..."
    end

    if name == "Catch Bag" then
        local total = 0
        local max = 30
        for slot = 0, container:getCapacity() - 1 do
            local item = container:getItem(slot)
            if item then
                total = total + 1
            end
        end

        containerWindow:setText(name .. " " ..total .. "/" .. max)
    else
        containerWindow:setText(name)
    end

    containerItemWidget:setItem(container:getContainerItem())
    containerItemWidget:setPhantom(true)

    containerPanel:destroyChildren()
    for slot = 0, container:getCapacity() - 1 do
        local itemWidget = g_ui.createWidget('Item', containerPanel)
        itemWidget:setId('item' .. slot)
        itemWidget:setItem(container:getItem(slot))
        itemWidget:setMargin(0)
        itemWidget:setTooltip("")
        itemWidget.position = container:getSlotPosition(slot)

        modules.game_inventory.onTooltipContainers(itemWidget, container:getItem(slot))
        if not container:isUnlocked() then
            itemWidget:setBorderColor('red')
        end
    end

    container.window = containerWindow
    container.itemsPanel = containerPanel

    toggleContainerPages(containerWindow, container:hasPages())
    refreshContainerPages(container)

    local layout = containerPanel:getLayout()
    local cellSize = layout:getCellSize()
    containerWindow:setContentMinimumHeight(cellSize.height)
    containerWindow:setContentMaximumHeight(cellSize.height * layout:getNumLines())

    if not previousContainer then
        local panel = modules.game_interface.findContentPanelAvailable(containerWindow, cellSize.height)
        panel:addChild(containerWindow)

        if modules.client_options.getOption('openMaximized') then
            containerWindow:setContentHeight(cellSize.height * layout:getNumLines())
        else
            local filledLines = math.max(math.ceil(container:getItemsCount() / layout:getNumColumns()), 1)
            containerWindow:setContentHeight(filledLines * cellSize.height)
        end
    end

    containerWindow:setup()

    -- Abriu: essa passa a ser a bag em foco, e a tira se atualiza.
    activeContainerId = container:getId()
    refreshBagBar()
end

function onContainerClose(container)
    destroy(container)
    refreshBagBar()
end

function onContainerChangeSize(container, size)
    if not container.window then
        return
    end
    refreshContainerItems(container)
end

function onContainerUpdateItem(container, slot, item, oldItem)
    if not container.window then
        return
    end
    local itemWidget = container.itemsPanel:getChildById('item' .. slot)
    itemWidget:setItem(item)
end
