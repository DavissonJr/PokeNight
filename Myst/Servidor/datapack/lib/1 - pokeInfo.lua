addons_pokeinfo = {
    ["Shiny Alakazam"] = {addon1 = 2148, addon2 = 0, addon3 = 0, addons = "true"}
}

function sendGoPokemonInfo(cid, item, pk)
    if not isPlayer(cid) then
        return true
    end

    if not isCreature(pk) then
        return true
    end

    local habilitie = "."
    local pokename = getItemAttribute(item.uid, "poke")

    local portrait = fotos[pokename]
    local lvl = getItemAttribute(item.uid, "level") or 1
    local exp = getItemAttribute(item.uid, "exp") or 0
    local gender = getItemAttribute(item.uid, "gender") or math.random(3, 4)
    local maxExp = lvl * 5000

    local health = getCreatureHealth(pk)
    local health2 = getCreatureMaxHealth(pk)

    local boost = tonumber(getItemAttribute(item.uid, "boost")) or 0
    if boost > 0 then
        local baseHp = 1000 * boost

        health = health + baseHp
        health2 = health2 + baseHp
    end

    local nature = getItemAttribute(item.uid, "nature") or "Sem nature"
    doSendPlayerExtendedOpcode(cid, 45, getCreatureName(pk).."@"..getItemInfo(portrait).clientId.."@"..lvl.."@"..health.."@"..health2.."@"..exp.."@"..maxExp.."@"..nature.."@"..gender.."@")
    sendGoPokemonInfoHabilities(cid, pk)
    sendGoPokemonInfoAddons(cid, pk)
    return true
end

function sendGoPokemonInfoNurse(cid, item)
    if not isPlayer(cid) then
        return true
    end

    local habilitie = "."
    local pokename = getItemAttribute(item.uid, "poke")

    local portrait = fotos[pokename]
    local lvl = getItemAttribute(item.uid, "level") or 1
    local exp = getItemAttribute(item.uid, "exp") or 0
    local gender = getItemAttribute(item.uid, "gender") or math.random(3, 4)
    local maxExp = lvl * 5000

    local nature = getItemAttribute(item.uid, "nature") or "Sem nature"
    doSendPlayerExtendedOpcode(cid, 45, pokename.."@"..getItemInfo(portrait).clientId.."@"..lvl.."@"..tonumber("100").."@"..tonumber("100").."@"..exp.."@"..maxExp.."@"..nature.."@"..gender.."@")
    return true
end

function sendBackPokemonInfo(cid)
    if not isPlayer(cid) then
        return true
    end

    local variableFix = 3283
	local level = 0
	local life = 1
	local maxLife = 1
	local name = "-"
    local habilitie = "."
    
    doSendPlayerExtendedOpcode(cid, 45, name.."@"..variableFix.."@"..level.."@"..life.."@"..maxLife.."@")
    sendBackPokemonInfoHabilities(cid)
    sendBackPokemonInfoAddons(cid)
    return true
end

function sendGoPokemonInfoHabilities(cid, pk)
    if not isPlayer(cid) then
        return true
    end

    if not isCreature(pk) then
        return true
    end

    local skills = specialabilities
    local tabela = {}

    if isInArray(skills["fly"], getCreatureName(pk)) then
        table.insert(tabela, "Fly")
    end

    if isInArray(skills["rock smash"], getCreatureName(pk)) then
        table.insert(tabela, "Rock Smash")
    end

    if isInArray(skills["light"], getCreatureName(pk)) then
        table.insert(tabela, "Light")
    end

    if isInArray(skills["dig"], getCreatureName(pk)) then
        table.insert(tabela, "Dig")
    end

    if isInArray(skills["blink"], getCreatureName(pk)) then
        table.insert(tabela, "Blink")
    end

    if isInArray(skills["ride"], getCreatureName(pk)) then
        table.insert(tabela, "Ride")
    end

    if isInArray(skills["surf"], getCreatureName(pk)) then
        table.insert(tabela, "Surf")
    end

    if isInArray(skills["teleport"], getCreatureName(pk)) then
        table.insert(tabela, "Teleport")
    end

    if isInArray(skills["cut"], getCreatureName(pk)) then
        table.insert(tabela, "Cut")
    end

    for a, b in pairs (tabela) do
        doSendPlayerExtendedOpcode(cid, 46, b.."@"..a.."@")
    end
    return true
end

function sendBackPokemonInfoHabilities(cid)
    if not isPlayer(cid) then
        return true
    end

    local variableFix = 3283
	local level = 0
	local life = 1
	local maxLife = 1
	local name = "-"
    local habilitie = "."
    
    doSendPlayerExtendedOpcode(cid, 46, "")
    return true
end

function sendGoPokemonInfoAddons(cid, pk) -- em breve
    if not isPlayer(cid) then
        return true
    end

    if not isCreature(pk) then
        return true
    end

    if not addons_pokeinfo[getCreatureName(pk)] then
        doSendPlayerExtendedOpcode(cid, 48, "".."@".."@".."false".."@")
        return false
    end
    
    doSendPlayerExtendedOpcode(cid, 48, addons_pokeinfo[getCreatureName(pk)].addon1.."@"..addons_pokeinfo[getCreatureName(pk)].addon2.."@"..
    addons_pokeinfo[getCreatureName(pk)].addon3.."@"..addons_pokeinfo[getCreatureName(pk)].addons.."@"..getCreatureName(pk).."@")
end

function sendBackPokemonInfoAddons(cid) -- em breve
    if not isPlayer(cid) then
        return true
    end
    
    doSendPlayerExtendedOpcode(cid, 48, "".."@".."@".."false".."@")
end