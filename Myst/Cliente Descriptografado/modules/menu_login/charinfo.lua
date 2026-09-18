-- ---------------------------------------------------------------------------
-- Detalhes dos personagens na tela de selecao (PokeOrigin).
--
-- O protocolo 8.54 manda so nome e mundo: level, aparencia e time nao vem.
-- A feature GameEnterGameShowAppearance, que traria o outfit, so liga em
-- cliente >= 1200. Em vez de mexer no protocolo, buscamos esses dados na
-- API (rota characters), que le direto do banco.
--
-- Carregado depois de characterlist.lua (ver login.otmod): usa o
-- characterList que aquele arquivo monta.
-- ---------------------------------------------------------------------------

-- Dados por nome de personagem, preenchidos quando a lista abre.
local details = {}

local function apiUrl()
    -- PKO_API vem de pko_register.lua, carregado antes deste.
    return (PKO_API or 'http://127.0.0.1:8088/')
end

local function window()
    return g_ui.getRootWidget():recursiveGetChildById('charactersWindow')
end

--- Desenha o time do personagem em foco nos seis slots.
function updateTeamRow(characterName)
    local win = window()
    if not win then
        return
    end
    local row = win:recursiveGetChildById('teamRow')
    if not row then
        return
    end

    row:destroyChildren()

    local info = details[characterName]
    local team = info and info.team or {}

    -- Sempre seis slots: os vazios mostram que ha espaco no time, em vez
    -- de a fileira encolher e o layout dancar a cada troca de personagem.
    for i = 1, 6 do
        local slot = g_ui.createWidget('PokeTeamSlot', row)
        local poke = team[i]

        if poke and poke.poke then
            local look = PokeLooktypes and PokeLooktypes[poke.poke]
            if look then
                local creature = Creature.create()
                creature:setOutfit({
                    type = look.type,
                    head = look.head,
                    body = look.body,
                    legs = look.legs,
                    feet = look.feet,
                    addons = 0
                })
                creature:setDirection(2)
                slot:getChildById('pokeCreature'):setCreature(creature)
            end
            slot:setTooltip(poke.poke .. '  Lv ' .. (poke.level or '?') ..
                            (poke.nature ~= '' and ('  (' .. poke.nature .. ')') or ''))
        end
    end
end

--- Aplica level, outfit e estrela de VIP nos cartoes ja criados.
local function applyDetails(premdays)
    local win = window()
    if not win then
        return
    end
    local list = win:recursiveGetChildById('characters')
    if not list then
        return
    end

    for _, card in ipairs(list:getChildren()) do
        local info = details[card.characterName]
        if info then
            local levelLabel = card:getChildById('level')
            if levelLabel then
                levelLabel:setText('Lv ' .. info.level)
            end

            local box = card:getChildById('outfitCreatureBox')
            if box and info.outfit and info.outfit.type and info.outfit.type > 0 then
                local creature = Creature.create()
                creature:setOutfit({
                    type = info.outfit.type,
                    head = info.outfit.head,
                    body = info.outfit.body,
                    legs = info.outfit.legs,
                    feet = info.outfit.feet,
                    addons = info.outfit.addons
                })
                creature:setDirection(2)
                box:setCreature(creature)
            end

            local star = card:getChildById('mainCharacter')
            if star then
                star:setVisible((premdays or 0) > 0)
            end
        end
    end

    local focused = list:getFocusedChild()
    if focused then
        updateTeamRow(focused.characterName)
    end
end

--- Busca os detalhes e preenche a tela. Falha em silencio de proposito:
--- sem a API a lista continua utilizavel, so sem level, retrato e time.
function loadCharacterDetails()
    details = {}

    if not G or not G.account or not G.password then
        return
    end

    HTTP.postJSON(apiUrl() .. '?r=characters',
        { account = G.account, password = G.password },
        function(data, err)
            if (err and err ~= '') or type(data) ~= 'table' or not data.ok then
                return
            end
            for _, c in ipairs(data.characters or {}) do
                details[c.name] = c
            end
            applyDetails(data.premdays)
        end)
end
