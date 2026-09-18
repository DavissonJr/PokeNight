local ADDON_SETS = {
    [1] = { 1 },
    [2] = { 2 },
    [3] = { 1, 2 },
    [4] = { 3 },
    [5] = { 1, 3 },
    [6] = { 2, 3 },
    [7] = { 1, 2, 3 }
}

local addons = nil
local outfit = nil
outfits = nil
local outfitWindow = nil
local outfitCreature = nil
local mountCreature = nil
local mounts = nil
local currentColorBox = nil
local currentClotheButtonBox = nil

currentOutfit = 1
currentMount = 1

-- Thalles Vitor
left = 0
right = 0

local colorBoxes = {}

controller = Controller:new()

localPlayerEvent = EventController:new(LocalPlayer, {
    onOutfitChange = function(creature)
        creature = creature or g_game.getLocalPlayer()
        local selectedOutfit = outfits[currentOutfit]

        local selectedAddons
        local availableAddons

        if outfit == nil then
            outfit = creature:getOutfit()
        end

        outfit.mount = nil

        selectedAddons = outfit.addons
        availableAddons = selectedOutfit[3]

        if table.empty(outfits) or not outfit then
            return
        end

        local nameWidget = outfitWindow:getChildById('outfitName')
        nameWidget:setText(selectedOutfit[2])

        for k, addon in pairs(addons) do
            addon.widget:setChecked(false)
            addon.widget:setEnabled(false)
        end

        outfit.addons = 0

        for k, addon in pairs(addons) do
            local isEnabled = availableAddons == 3 or addon.value == availableAddons
            addon.widget:setEnabled(isEnabled)
            addon.widget:setChecked(isEnabled and (selectedAddons == 3 or addon.value == selectedAddons))
        end

        outfit.type = selectedOutfit[1]
        outfitCreature:setOutfit(outfit)

        if table.empty(mounts) or not mount then
            return
        end

        local nameMountWidget = outfitWindow:getChildById('mountName')
        nameMountWidget:setText(mounts[currentMount][2])

        mount.type = mounts[currentMount][1]
        mountCreature:setOutfit(mount)
    end
})

function controller:onGameEnd()
    destroy()
end

controller:registerEvents(g_game, {
    onOpenOutfitWindow = function(creatureOutfit, outfitList, creatureMount, mountList)
        localPlayerEvent:connect()

        outfitCreature = creatureOutfit
        mountCreature = creatureMount
        outfits = outfitList
        mounts = mountList
        destroy()

        outfitWindow = g_ui.displayUI('outfitwindow')

        local outfitCreatureBox = outfitWindow:getChildById('outfitCreatureBox')

        if outfitCreature then
            outfit = outfitCreature:getOutfit()
            outfitCreatureBox:setCreature(outfitCreature)
        else
            outfitCreatureBox:hide()
            outfitWindow:getChildById('outfitName'):hide()
            outfitWindow:getChildById('outfitNextButton'):hide()
            outfitWindow:getChildById('outfitPrevButton'):hide()
        end

        local mountCreatureBox = outfitWindow:getChildById('mountCreatureBox')
        if mountCreature then
            mount = mountCreature:getOutfit()
            mountCreatureBox:setCreature(mountCreature)
        else
            mountCreatureBox:hide()
            outfitWindow:getChildById('mountName'):hide()
            outfitWindow:getChildById('mountNextButton'):hide()
            outfitWindow:getChildById('mountPrevButton'):hide()
        end

        -- set addons
        addons = {
            [1] = {
                widget = outfitWindow:getChildById('addon1'),
                value = 1
            },
            [2] = {
                widget = outfitWindow:getChildById('addon2'),
                value = 2
            }
        }

        for _, addon in pairs(addons) do
            addon.widget.onCheckChange = function(self)
                onAddonCheckChange(self, addon.value)
            end
        end

        -- hook outfit sections
        currentClotheButtonBox = outfitWindow:getChildById('head')
        currentClotheButtonBox.onCheckChange = onClotheCheckChange
        outfitWindow:getChildById('primary').onCheckChange = onClotheCheckChange
        outfitWindow:getChildById('secondary').onCheckChange = onClotheCheckChange
        outfitWindow:getChildById('detail').onCheckChange = onClotheCheckChange

        -- populate color panel
        local colorBoxPanel = outfitWindow:getChildById('colorBoxPanel')
        for j = 0, 6 do
            for i = 0, 18 do
                local colorId = j * 19 + i

                local colorBox = g_ui.createWidget('ColorBox', colorBoxPanel)
                colorBox:setImageColor(getOutfitColor(colorId))
                colorBox:setId('colorBox' .. colorId)
                colorBox.colorId = colorId

                if colorId == outfit.head then
                    currentColorBox = colorBox
                    colorBox:setChecked(true)
                end

                colorBox.onCheckChange = onColorCheckChange
                colorBoxes[#colorBoxes + 1] = colorBox
            end
        end

        currentOutfit = 1
        currentMount = 1

        if outfit then
            for i = 1, #outfitList do
                if outfitList[i][1] == outfit.type then
                    currentOutfit = i
                    break
                end
            end

            if mount ~= nil then
                for i = 1, #mountList do
                    if mountList[i][1] == mount.type then
                        currentMount = i
                        break
                    end
                end
            end
        end

        localPlayerEvent:execute('onOutfitChange')
        buildOutfitGrid()
    end
})

function destroy()
    if not outfitWindow then
        return
    end

    outfitWindow:destroy()
    localPlayerEvent:disconnect()

    outfitWindow = nil
    outfitCreature = nil
    currentColorBox = nil
    currentClotheButtonBox = nil

    colorBoxes = {}
    addons = {}
end

function randomize()
    local outfitTemplate = { outfitWindow:getChildById('detail'), outfitWindow:getChildById('secondary'),
        outfitWindow:getChildById('primary'), outfitWindow:getChildById('head') }

    for i, template in pairs(outfitTemplate) do
        template:setChecked(true)
        colorBoxes[math.random(1, #colorBoxes)]:setChecked(true)
        template:setChecked(false)
    end
end

function accept()
    if mount then
        outfit.mount = mount.type
    end
    g_game.changeOutfit(outfit)
    destroy()
end

-- ---------------------------------------------------------------------
-- Grade de outfits
--
-- O servidor ja envia a lista completa em onOpenOutfitWindow; a tela
-- antiga so mostrava um por vez com setas. Aqui montamos uma celula por
-- outfit disponivel, como no PXG. As setas continuam funcionando.
-- ---------------------------------------------------------------------

-- Celulas indexadas pela posicao em `outfits`, para marcar a selecionada
-- sem varrer os filhos do painel a cada troca.
local gridCells = {}

--- Marca visualmente qual celula corresponde ao outfit atual.
function updateOutfitGridSelection()
    for i, cell in pairs(gridCells) do
        cell:setChecked(i == currentOutfit)
    end
end

--- Clique numa celula: vira o outfit selecionado.
function selectOutfitIndex(index)
    if not outfits or not outfits[index] then
        return
    end

    currentOutfit = index
    localPlayerEvent:execute('onOutfitChange')
    updateOutfitGridSelection()
end

--- (Re)constroi a grade a partir de `outfits`.
function buildOutfitGrid()
    gridCells = {}

    if not outfitWindow then
        return
    end

    local panel = outfitWindow:recursiveGetChildById('outfitGridPanel')
    if not panel then
        return
    end

    panel:destroyChildren()

    if not outfits then
        return
    end

    -- As cores vem do outfit atual do jogador: a miniatura precisa refletir
    -- a paleta escolhida, senao a grade nao corresponde ao que ele vera.
    local base = outfit or {}

    for i = 1, #outfits do
        local entry = outfits[i]
        local cell = g_ui.createWidget('OutfitGridCell', panel)

        local preview = {
            type = entry[1],
            head = base.head or 0,
            body = base.body or 0,
            legs = base.legs or 0,
            feet = base.feet or 0,
            addons = entry[3] or 0
        }

        local creatureBox = cell:getChildById('cellCreature')
        -- setCenter nao esta exposto ao Lua neste cliente (so setCreature,
        -- setOutfit, setCreatureSize e getCreature). A centralizacao vai
        -- pelo creature-center no .otui.
        creatureBox:setOutfit(preview)

        cell:getChildById('cellName'):setText(entry[2] or '')
        cell:setTooltip(entry[2] or '')
        cell.onClick = function()
            selectOutfitIndex(i)
        end

        gridCells[i] = cell
    end

    updateOutfitGridSelection()
end

function nextOutfitType()
    if not outfits then
        return
    end

    currentOutfit = currentOutfit + 1
    if currentOutfit > #outfits then
        currentOutfit = 1
    end

    localPlayerEvent:execute('onOutfitChange')
    updateOutfitGridSelection()
end

function previousOutfitType()
    if not outfits then
        return
    end

    currentOutfit = currentOutfit - 1
    if currentOutfit <= 0 then
        currentOutfit = #outfits
    end

    localPlayerEvent:execute('onOutfitChange')
    updateOutfitGridSelection()
end

function nextMountType()
    if not mounts then
        return
    end

    currentMount = currentMount + 1
    if currentMount > #mounts then
        currentMount = 1
    end
    localPlayerEvent:execute('onOutfitChange')
end

function previousMountType()
    if not mounts then
        return
    end

    currentMount = currentMount - 1
    if currentMount <= 0 then
        currentMount = #mounts
    end

    localPlayerEvent:execute('onOutfitChange')
end

function onAddonCheckChange(addon, value)
    if addon:isChecked() then
        outfit.addons = outfit.addons + value
    else
        outfit.addons = outfit.addons - value
    end

    outfitCreature:setOutfit(outfit)
end

function onColorCheckChange(colorBox)
    if colorBox == currentColorBox then
        colorBox.onCheckChange = nil
        colorBox:setChecked(true)
        colorBox.onCheckChange = onColorCheckChange
    else
        currentColorBox.onCheckChange = nil
        currentColorBox:setChecked(false)
        currentColorBox.onCheckChange = onColorCheckChange

        currentColorBox = colorBox

        if currentClotheButtonBox:getId() == 'head' then
            outfit.head = currentColorBox.colorId
        elseif currentClotheButtonBox:getId() == 'primary' then
            outfit.body = currentColorBox.colorId
        elseif currentClotheButtonBox:getId() == 'secondary' then
            outfit.legs = currentColorBox.colorId
        elseif currentClotheButtonBox:getId() == 'detail' then
            outfit.feet = currentColorBox.colorId
        end

        outfitCreature:setOutfit(outfit)
    end
end

function onClotheCheckChange(clotheButtonBox)
    if clotheButtonBox == currentClotheButtonBox then
        clotheButtonBox.onCheckChange = nil
        clotheButtonBox:setChecked(true)
        clotheButtonBox.onCheckChange = onClotheCheckChange
    else
        currentClotheButtonBox.onCheckChange = nil
        currentClotheButtonBox:setChecked(false)
        currentClotheButtonBox.onCheckChange = onClotheCheckChange

        currentClotheButtonBox = clotheButtonBox

        local colorId = 0
        if currentClotheButtonBox:getId() == 'head' then
            colorId = outfit.head
        elseif currentClotheButtonBox:getId() == 'primary' then
            colorId = outfit.body
        elseif currentClotheButtonBox:getId() == 'secondary' then
            colorId = outfit.legs
        elseif currentClotheButtonBox:getId() == 'detail' then
            colorId = outfit.feet
        end
        outfitWindow:recursiveGetChildById('colorBox' .. colorId):setChecked(true)
    end
end

function changeDirLeft()
    if left == 0 then
        outfitWindow:getChildById('outfitCreatureBox'):getCreature():setDirection(East)
        left = 1
        right = 3
    elseif left == 1 then
        outfitWindow:getChildById('outfitCreatureBox'):getCreature():setDirection(North)
        left = 2
        right = 2
    elseif left == 2 then
        outfitWindow:getChildById('outfitCreatureBox'):getCreature():setDirection(West)
        left = 3
        right = 1
    elseif left == 3 then
        outfitWindow:getChildById('outfitCreatureBox'):getCreature():setDirection(South)
        left = 0
        right = 0
    end
end

function changeDirRight()
    if right == 0 then
        outfitWindow:getChildById('outfitCreatureBox'):getCreature():setDirection(West)
        right = 1
        left = 3
    elseif right == 1 then
        outfitWindow:getChildById('outfitCreatureBox'):getCreature():setDirection(North)
        right = 2
        left = 2
    elseif right == 2 then
        outfitWindow:getChildById('outfitCreatureBox'):getCreature():setDirection(East)
        right = 3
        left = 1
    elseif right == 3 then
        outfitWindow:getChildById('outfitCreatureBox'):getCreature():setDirection(South)
        right = 0
        left = 0
    end
end