-- Criado por Thalles Vitor --
-- Nova PokeBar --
-- 01/09/2022 --
-- Ultimo Ajuste: 04/04/2023 --

POKEMON_ATTRIBUTE_NICK = "nick" -- nome do atributo do nick
POKEMON_ATTRIBUTE_NAME = "poke" -- nome do atributo de poke
POKEMON_ATTRIBUTE_GENDER = "gender" -- nome do atributo de gender
POKEMON_ATTRIBUTE_LEVEL = "level" -- nome do atributo de level
POKEMON_ATTRIBUTE_HEALTH = "hpPercent" -- nome do atributo de vida
POKEMON_ATTRIBUTE_PORTRAIT = "portrait" -- nome do atributo de portrait
POKEMON_ATTRIBUTE_NUMBER = "numeration" -- nome do atributo de numeracao da ball

POKEBAR_FEET = 8 -- slot da pokebola
POKEBAR_BP = 3 -- slot da backpack

POKEBAR_OPCODE_SEND = 66 -- opcode da pokebar (mostrar pokes)
POKEBAR_OPCODE_SENDHEALTH = 67 -- opcode da pokebar (atualizar vida)
POKEBAR_OPCODE_SENDLEVEL = 68 -- opcode da pokebar (atualizar level)
POKEBAR_OPCODE_SENDSTATUS = 69 -- mostrar se a bar ta on ou off
POKEBAR_OPCODE_SENDHIDEBARS = 78 -- ocultar todas as bars pra receber outras no lugar

POKEBAR_GENDER = {
    ["male"] = 4,
    ["female"] = 3,
    ["indefinido"] = 1,
    ["genderless"] = 1,
    [1] = 4,
    [0] = 3,
    [4] = 4,
    [3] = 3,
}

-- Verificar se e uma pokebola!
function isPokemonBall(uid)
    if uid <= 0 then return false end

    if getItemAttribute(uid, POKEMON_ATTRIBUTE_NAME) then
        return true
    end
    return false
end

-- Verificar os atributos da ball
function getPokeballAttribute(uid, type)
    if uid <= 0 then return false end
    if not isPokemonBall(uid) then return false end

    if type == "poke" then
        if getItemAttribute(uid, POKEMON_ATTRIBUTE_NICK) then
            return getItemAttribute(uid, POKEMON_ATTRIBUTE_NICK)
        end
        return getItemAttribute(uid, POKEMON_ATTRIBUTE_NAME)
    elseif type == "level" then
        return getItemAttribute(uid, POKEMON_ATTRIBUTE_LEVEL) or 1
    elseif type == "gender" then
        return getItemAttribute(uid, POKEMON_ATTRIBUTE_GENDER) or "female"
    elseif type == "health" then
        return getItemAttribute(uid, POKEMON_ATTRIBUTE_HEALTH) or 100
    elseif type == "portrait" then
        if not getItemAttribute(uid, POKEMON_ATTRIBUTE_PORTRAIT) then
            if fotos[getItemAttribute(uid, POKEMON_ATTRIBUTE_NAME)] then
                doItemSetAttribute(uid, "portrait", fotos[getItemAttribute(uid, POKEMON_ATTRIBUTE_NAME)])
            end
        end

        if fotos[getItemAttribute(uid, POKEMON_ATTRIBUTE_NAME)] then
            if getItemAttribute(uid, POKEMON_ATTRIBUTE_PORTRAIT) ~= getItemInfo(fotos[getItemAttribute(uid, POKEMON_ATTRIBUTE_NAME)]) then
                doItemSetAttribute(uid, "portrait", fotos[getItemAttribute(uid, POKEMON_ATTRIBUTE_NAME)])
            end
        end
        
        return fotos[getItemAttribute(uid, POKEMON_ATTRIBUTE_NAME)] and fotos[getItemAttribute(uid, POKEMON_ATTRIBUTE_NAME)] or 2395
    else if type == "numeration" then
        return getItemAttribute(uid, POKEMON_ATTRIBUTE_NUMBER) or 1
    end
    end
    return nil
end

-- Setar numeracao na pokebola
function setPokeballNumeration(cid)
    if not isPlayer(cid) then
        return true
    end

    local balls = 0
    local feet = getPlayerSlotItem(cid, POKEBAR_FEET)
    if feet.uid > 0 and isPokemonBall(feet.uid) then
        balls = balls + 1
        doItemSetAttribute(feet.uid, POKEMON_ATTRIBUTE_NUMBER, balls)
    end

    -- Backpack
    if getPlayerSlotItem(cid, POKEBAR_BP).uid <= 0 then return true end
    for i = 0, getContainerSize(getPlayerSlotItem(cid, POKEBAR_BP).uid)-1 do
        local item = getContainerItem(getPlayerSlotItem(cid, POKEBAR_BP).uid, i)
        if isContainer(item.uid) then
            for it = 0, getContainerSize(item.uid)-1 do
                local item2 = getContainerItem(item.uid, it)
                if item2 and item2.uid > 0 and isPokemonBall(item2.uid) then
                    balls = balls + 1
                    doItemSetAttribute(item2.uid, POKEMON_ATTRIBUTE_NUMBER, balls)
                end
            end
        else
            if item and item.uid > 0 and isPokemonBall(item.uid) then
                balls = balls + 1
                doItemSetAttribute(item.uid, POKEMON_ATTRIBUTE_NUMBER, balls)
            end
        end
    end

    -- PokeBag
    if getPlayerSlotItem(cid, CONST_SLOT_HEAD).uid <= 0 then return true end
    for i = 0, getContainerSize(getPlayerSlotItem(cid, CONST_SLOT_HEAD).uid)-1 do
        local item = getContainerItem(getPlayerSlotItem(cid, CONST_SLOT_HEAD).uid, i)
        if item and item.uid > 0 and isPokemonBall(item.uid) then
            balls = balls + 1
            doItemSetAttribute(item.uid, POKEMON_ATTRIBUTE_NUMBER, balls)
        end
    end

    -- Coins
    local coins = getPlayerSlotItem(cid, 10)
    if coins.uid > 0 then
        if isContainer(coins.uid) then
            for i = 0, getContainerSize(coins.uid)-1 do
                local item = getContainerItem(coins.uid, i)
                if isContainer(item.uid) then
                    for it = 0, getContainerSize(item.uid)-1 do
                        local item2 = getContainerItem(item.uid, it)
                        if item2 and item2.uid > 0 and isPokemonBall(item2.uid) then
                            balls = balls + 1
                            doItemSetAttribute(item2.uid, POKEMON_ATTRIBUTE_NUMBER, balls)
                        end
                    end
                else
                    if item and item.uid > 0 and isPokemonBall(item.uid) then
                        balls = balls + 1
                        doItemSetAttribute(item.uid, POKEMON_ATTRIBUTE_NUMBER, balls)
                    end
                end
            end
        end
    end
    return true
end

function getTotalBalls(cid)
    if not isPlayer(cid) then
        return 0
    end

    local balls = 0
    local feet = getPlayerSlotItem(cid, POKEBAR_FEET)
    if feet.uid > 0 and isPokemonBall(feet.uid) then
        balls = balls + 1
    end

    -- Backpack
    if getPlayerSlotItem(cid, POKEBAR_BP).uid <= 0 then return 0 end
    for i = 0, getContainerSize(getPlayerSlotItem(cid, POKEBAR_BP).uid)-1 do
        local item = getContainerItem(getPlayerSlotItem(cid, POKEBAR_BP).uid, i)
        if isContainer(item.uid) then
            for it = 0, getContainerSize(item.uid)-1 do
                local item2 = getContainerItem(item.uid, it)
                if item2 and item2.uid > 0 and isPokemonBall(item2.uid) then
                    balls = balls + 1
                end
            end
        else
            if item and item.uid > 0 and isPokemonBall(item.uid) then
                balls = balls + 1
            end
        end
    end

    -- PokeBag
    if getPlayerSlotItem(cid, CONST_SLOT_HEAD).uid <= 0 then return 0 end
    for i = 0, getContainerSize(getPlayerSlotItem(cid, CONST_SLOT_HEAD).uid)-1 do
        local item = getContainerItem(getPlayerSlotItem(cid, CONST_SLOT_HEAD).uid, i)
        if item and item.uid > 0 and isPokemonBall(item.uid) then
            balls = balls + 1
        end
    end

    -- Coins
    local coins = getPlayerSlotItem(cid, 10)
    if coins.uid > 0 then
        if isContainer(coins.uid) then
            for i = 0, getContainerSize(coins.uid)-1 do
                local item = getContainerItem(coins.uid, i)
                if isContainer(item.uid) then
                    for it = 0, getContainerSize(item.uid)-1 do
                        local item2 = getContainerItem(item.uid, it)
                        if item2 and item2.uid > 0 and isPokemonBall(item2.uid) then
                            balls = balls + 1
                        end
                    end
                else
                    if item and item.uid > 0 and isPokemonBall(item.uid) then
                        balls = balls + 1
                    end
                end
            end
        end
    end
    return balls
end

-- Ocultar as bar's anteriores
function hideBarPokemon(cid)
    if not isPlayer(cid) then
        return true
    end

    doSendPlayerExtendedOpcode(cid, POKEBAR_OPCODE_SENDHIDEBARS, "hide".."@")
    return true
end

-- Enviar pokemons por qualquer metodo: login/mover items/etc
function sendPokemonsBarPokemon(cid)
    if not isPlayer(cid) then
        return true
    end

    setPokeballNumeration(cid) -- setar numeracoes
    hideBarPokemon(cid)

    --addEvent(function()
        local pokes = {}
        local feet = getPlayerSlotItem(cid, POKEBAR_FEET)
        if feet.uid > 0 and isPokemonBall(feet.uid) then
            local name = getPokeballAttribute(feet.uid, "poke")
            local level = getPokeballAttribute(feet.uid, "level")
            local gender = getPokeballAttribute(feet.uid, "gender")
            local health = getPokeballAttribute(feet.uid, "health")
            local portrait = getPokeballAttribute(feet.uid, "portrait") and getItemInfo(getPokeballAttribute(feet.uid, "portrait")) and getItemInfo(getPokeballAttribute(feet.uid, "portrait")).clientId
            local numeration = getPokeballAttribute(feet.uid, "numeration")
            
            doSendPlayerExtendedOpcode(cid, POKEBAR_OPCODE_SEND, name.."@"..level.."@"..gender.."@"..health.."@"..portrait.."@"..numeration.."@")
        end

        -- Backpack
        if getPlayerSlotItem(cid, POKEBAR_BP).uid <= 0 then return true end
        for i = 0, getContainerSize(getPlayerSlotItem(cid, POKEBAR_BP).uid)-1 do
            local item = getContainerItem(getPlayerSlotItem(cid, POKEBAR_BP).uid, i)
            if isContainer(item.uid) then
                for it = 0, getContainerSize(item.uid)-1 do
                    local item2 = getContainerItem(item.uid, it)
                    if item2 and item2.uid > 0 and isPokemonBall(item2.uid) then
                        local name = getPokeballAttribute(item2.uid, "poke")
                        local level = getPokeballAttribute(item2.uid, "level")
                        local gender = getPokeballAttribute(item2.uid, "gender")
                        local health = getPokeballAttribute(item2.uid, "health")
                        local portrait = getPokeballAttribute(item2.uid, "portrait") and getItemInfo(getPokeballAttribute(item2.uid, "portrait")) and getItemInfo(getPokeballAttribute(item2.uid, "portrait")).clientId
                        local numeration = getPokeballAttribute(item2.uid, "numeration")
                        
                        doSendPlayerExtendedOpcode(cid, POKEBAR_OPCODE_SEND, name.."@"..level.."@"..gender.."@"..health.."@"..portrait.."@"..numeration.."@")
                    end
                end
            else
                if item and item.uid > 0 and isPokemonBall(item.uid) then
                    local name = getPokeballAttribute(item.uid, "poke")
                    local level = getPokeballAttribute(item.uid, "level")
                    local gender = getPokeballAttribute(item.uid, "gender")
                    local health = getPokeballAttribute(item.uid, "health")
                    local portrait = getPokeballAttribute(item.uid, "portrait") and getItemInfo(getPokeballAttribute(item.uid, "portrait")) and getItemInfo(getPokeballAttribute(item.uid, "portrait")).clientId
                    local numeration = getPokeballAttribute(item.uid, "numeration")
                    
                    doSendPlayerExtendedOpcode(cid, POKEBAR_OPCODE_SEND, name.."@"..level.."@"..gender.."@"..health.."@"..portrait.."@"..numeration.."@")
                end
            end
        end

        -- PokeBag
        if getPlayerSlotItem(cid, CONST_SLOT_HEAD).uid <= 0 then return true end
        for i = 0, getContainerSize(getPlayerSlotItem(cid, CONST_SLOT_HEAD).uid)-1 do
            local item = getContainerItem(getPlayerSlotItem(cid, CONST_SLOT_HEAD).uid, i)
            if item and item.uid > 0 and isPokemonBall(item.uid) then
                local name = getPokeballAttribute(item.uid, "poke")
                local level = getPokeballAttribute(item.uid, "level")
                local gender = getPokeballAttribute(item.uid, "gender")
                local health = getPokeballAttribute(item.uid, "health")
                local portrait = getPokeballAttribute(item.uid, "portrait") and getItemInfo(getPokeballAttribute(item.uid, "portrait")) and getItemInfo(getPokeballAttribute(item.uid, "portrait")).clientId
                local numeration = getPokeballAttribute(item.uid, "numeration")
                        
                doSendPlayerExtendedOpcode(cid, POKEBAR_OPCODE_SEND, name.."@"..level.."@"..gender.."@"..health.."@"..portrait.."@"..numeration.."@")
            end
        end

        -- Coins
        local coins = getPlayerSlotItem(cid, 10)
        if coins.uid > 0 then
            if isContainer(coins.uid) then
                for i = 0, getContainerSize(coins.uid)-1 do
                    local item = getContainerItem(coins.uid, i)
                    if isContainer(item.uid) then
                        for it = 0, getContainerSize(item.uid)-1 do
                            local item2 = getContainerItem(item.uid, it)
                            if item2 and item2.uid > 0 and isPokemonBall(item2.uid) then
                                local name = getPokeballAttribute(item2.uid, "poke")
                                local level = getPokeballAttribute(item2.uid, "level")
                                local gender = getPokeballAttribute(item2.uid, "gender")
                                local health = getPokeballAttribute(item2.uid, "health")
                                local portrait = getPokeballAttribute(item2.uid, "portrait") and getItemInfo(getPokeballAttribute(item2.uid, "portrait")) and getItemInfo(getPokeballAttribute(item2.uid, "portrait")).clientId
                                local numeration = getPokeballAttribute(item2.uid, "numeration")
                                
                                doSendPlayerExtendedOpcode(cid, POKEBAR_OPCODE_SEND, name.."@"..level.."@"..gender.."@"..health.."@"..portrait.."@"..numeration.."@")
                            end
                        end
                    else
                        if item and item.uid > 0 and isPokemonBall(item.uid) then
                            local name = getPokeballAttribute(item.uid, "poke")
                            local level = getPokeballAttribute(item.uid, "level")
                            local gender = getPokeballAttribute(item.uid, "gender")
                            local health = getPokeballAttribute(item.uid, "health")
                            local portrait = getPokeballAttribute(item.uid, "portrait") and getItemInfo(getPokeballAttribute(item.uid, "portrait")) and getItemInfo(getPokeballAttribute(item.uid, "portrait")).clientId
                            local numeration = getPokeballAttribute(item.uid, "numeration")
                            
                            doSendPlayerExtendedOpcode(cid, POKEBAR_OPCODE_SEND, name.."@"..level.."@"..gender.."@"..health.."@"..portrait.."@"..numeration.."@")
                        end
                    end
                end
            end
        end
   -- end, 500)
    return true
end

-- Atualizar vida do pokemon na pokebar (ao tomar dano)
function updateLifeBarPokemon(cid)
    if not isPlayer(cid) then
        return true
    end

    local slot = getPlayerSlotItem(cid, POKEBAR_FEET)
    if slot.uid <= 0 then return true end

    local summon = getCreatureSummons(cid)[1]
    if not isCreature(summon) then
        return true
    end

    if getCreatureHealth(summon) <= 0 then
		local vida = 0
        doSendPlayerExtendedOpcode(cid, POKEBAR_OPCODE_SENDHEALTH, vida.."@")
        return true
    end
    
	local health = math.floor(getCreatureHealth(summon) / getCreatureMaxHealth(summon) * 100)
    doItemSetAttribute(slot.uid, POKEMON_ATTRIBUTE_HEALTH, health)
    doSendPlayerExtendedOpcode(cid, POKEBAR_OPCODE_SENDHEALTH, getPokeballAttribute(slot.uid, "health").."@"..getPokeballAttribute(slot.uid, "numeration").."@")
    return true
end

-- Atualizar vida do pokemon na pokebar ao falar com nurse
function updateLifeBarPokemonNurseJoy(cid, uid)
    if not isPlayer(cid) then
        return true
    end

    if uid <= 0 then return true end
	if not getItemAttribute(uid, "poke") then return true end
	
    doItemSetAttribute(uid, POKEMON_ATTRIBUTE_HEALTH, 100)
    doSendPlayerExtendedOpcode(cid, POKEBAR_OPCODE_SENDSTATUS, getPokeballAttribute(uid, "numeration").."@".."nurse".."@")
    return true
end

-- Atualizar nivel do pokemon na pokebar
function updateLevelBarPokemon(cid)
    if not isPlayer(cid) then
        return true
    end

    local slot = getPlayerSlotItem(cid, POKEBAR_FEET)
    if slot.uid <= 0 then return true end

    doSendPlayerExtendedOpcode(cid, POKEBAR_OPCODE_SENDLEVEL, getPokeballAttribute(slot.uid, "poke").."@"..getPokeballAttribute(slot.uid, "level").."@"..getPokeballAttribute(slot.uid, "numeration").."@")
    return true
end

-- Atualizar status da bar
function updateBarStatus(cid, status)
    if not isPlayer(cid) then
        return true
    end

    local slot = getPlayerSlotItem(cid, POKEBAR_FEET)
    if slot.uid <= 0 then return true end

    doSendPlayerExtendedOpcode(cid, POKEBAR_OPCODE_SENDSTATUS, getPokeballAttribute(slot.uid, "numeration").."@"..status.."@")
    return true
end