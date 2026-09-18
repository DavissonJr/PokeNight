-- Listagem da pokedex: todos os pokemons do jogo, em ordem, marcando o
-- que este personagem ja capturou.
--
-- A lista completa vem de pokedex_list.lua (gerada de newpokedex pelo
-- design/gen_pokedex.py) e os outfits de PokeLooktypes. Do servidor vem
-- so QUAIS storages de captura estao marcados -- assim a resposta
-- acompanha o tamanho da colecao, nao o da pokedex.
--
-- Abre ao usar a pokedex no proprio personagem, ou pelo botao do topo.

local OPCODE = 152

local dexListWindow = nil
local dexButton = nil
local currentSection = 'numbered'
local caught = {}                 -- [storage de captura] = true
local pendingOpen = false

-- Sem captura marcada o sprite fica escurecido; com, fica cheio.
local COLOR_CAUGHT = '#ffffff'
local COLOR_MISSING = '#4a4a50'

local function widget(id)
    if not dexListWindow or dexListWindow:isDestroyed() then
        return nil
    end
    return dexListWindow:recursiveGetChildById(id)
end

local function currentList()
    if currentSection == 'extras' then
        return PokedexExtras or {}
    end
    return PokedexList or {}
end

--- Pede ao servidor quais destes storages estao marcados.
local function requestCaught()
    if not g_game.isOnline() then
        return
    end
    local protocol = g_game.getProtocolGame()
    if not protocol then
        return
    end

    local ids = {}
    for _, entry in ipairs(PokedexList or {}) do
        table.insert(ids, entry.catch)
    end
    for _, entry in ipairs(PokedexExtras or {}) do
        table.insert(ids, entry.catch)
    end

    protocol:sendExtendedOpcode(OPCODE, table.concat(ids, ','))
end

local function updateProgress()
    local list = currentList()
    local have = 0
    for _, entry in ipairs(list) do
        if caught[entry.catch] then
            have = have + 1
        end
    end
    local label = widget('dexProgress')
    if label then
        label:setText(have .. ' / ' .. #list)
    end
end

--- (Re)desenha a grade, aplicando o filtro do campo de busca.
function rebuildDexGrid()
    local grid = widget('dexGrid')
    if not grid then
        return
    end
    grid:destroyChildren()

    local search = ''
    local field = widget('dexSearch')
    if field then
        search = field:getText():lower()
    end

    for _, entry in ipairs(currentList()) do
        local name = entry.name
        local number = entry.number

        local matches = (search == '')
            or name:lower():find(search, 1, true) ~= nil
            or (number and tostring(number):find(search, 1, true) ~= nil)

        if matches then
            local cell = g_ui.createWidget('DexEntry', grid)
            local isCaught = caught[entry.catch] == true

            local creature = cell:getChildById('dexCreature')
            local look = PokeLooktypes and PokeLooktypes[name]
            if look then
                local c = Creature.create()
                c:setOutfit({
                    type = look.type,
                    head = look.head,
                    body = look.body,
                    legs = look.legs,
                    feet = look.feet,
                    addons = 0
                })
                c:setDirection(2)
                creature:setCreature(c)
            end
            -- Escurecer em vez de esconder: a silhueta mostra que existe
            -- algo ali para pegar, que e o que faz querer completar.
            creature:setImageColor(isCaught and COLOR_CAUGHT or COLOR_MISSING)
            creature:setOpacity(isCaught and 1.0 or 0.45)

            cell:getChildById('dexNumber'):setText(number and ('#' .. number) or '')
            local nameLabel = cell:getChildById('dexName')
            nameLabel:setText(name)
            nameLabel:setColor(isCaught and '#f5f5f6' or '#6a6a72')

            cell:setTooltip(isCaught and (name .. ' - capturado')
                                      or (name .. ' - ainda nao capturado'))
        end
    end

    updateProgress()
end

function applyFilter()
    rebuildDexGrid()
end

function showSection(section)
    currentSection = section
    local a, b = widget('tabNumbered'), widget('tabExtras')
    if a then a:setChecked(section == 'numbered') end
    if b then b:setChecked(section == 'extras') end
    rebuildDexGrid()
end

function toggleDexList()
    if not dexListWindow then
        return
    end
    if dexListWindow:isVisible() then
        dexListWindow:hide()
        if dexButton then
            dexButton:setOn(false)
        end
    else
        dexListWindow:show()
        dexListWindow:raise()
        dexListWindow:focus()
        if dexButton then
            dexButton:setOn(true)
        end
        -- Sempre reconsulta: o jogador pode ter capturado algo desde a
        -- ultima vez que abriu.
        requestCaught()
    end
end

local function onServerReply(protocol, opcode, buffer)
    if opcode ~= OPCODE then
        return
    end

    -- "abrir" chega quando o jogador usa a pokedex em si mesmo.
    if buffer == 'abrir' then
        pendingOpen = true
        if dexListWindow and not dexListWindow:isVisible() then
            toggleDexList()
        else
            requestCaught()
        end
        return
    end

    caught = {}
    for _, raw in ipairs(string.split(buffer, ',')) do
        local id = tonumber(raw)
        if id then
            caught[id] = true
        end
    end

    rebuildDexGrid()
end

function initDexList()
    ProtocolGame.registerExtendedOpcode(OPCODE, onServerReply)

    dexListWindow = g_ui.displayUI('dexlist')
    dexListWindow:hide()

    dexButton = modules.client_topmenu.addRightGameToggleButton(
        'dexListButton', tr('Pokedex'), '/images/topbuttons/pokedex', toggleDexList)
end

function terminateDexList()
    ProtocolGame.unregisterExtendedOpcode(OPCODE)

    if dexListWindow then
        dexListWindow:destroy()
        dexListWindow = nil
    end
    if dexButton then
        dexButton:destroy()
        dexButton = nil
    end
end
