-- Criado por Thalles Vitor --
-- Sistema de Janela de Addon --

POKEADDONS =
{
    ["Alakazam"] =
    {
        [1] =
        {
            name = "Adventurer addon",
            lookType = 2009,
        },

        [2] =
        {
            name = "Grey hat addon",
            lookType = 2010,
        },

        [3] =
        {
            name = "Red hat addon",
            lookType = 2012,
        },
    }
}

ADDONWINDOW_OPCODE = 25
ADDONWINDOW_OPCODEHIDE = 26

function onSendAddonWindow(cid)
    if not isPlayer(cid) then
        return true
    end

    if #getCreatureSummons(cid) <= 0 then
        return true
    end

    local summon = getCreatureSummons(cid)[1]
    local name = getCreatureName(summon)
    local tabela = POKEADDONS[name]
    if tabela then
        for i = 1, #tabela do
            -- Sistema de Addon - Thalles Vitor
            local slot = getPlayerSlotItem(cid, 8)
            if slot.uid <= 0 then
                return true
            end

            local color = {}
            color[tabela[i].name] = "red"

            local count = getItemAttribute(slot.uid, "addonCount") or 0
            for it = 1, count do
                local addon = tostring(getItemAttribute(slot.uid, "addonName"..it)) or "none"
                if addon == tabela[i].name then
                    color[addon] = "green"
                end
            end

            doSendPlayerExtendedOpcode(cid, ADDONWINDOW_OPCODE, tabela[i].name.."@"..tabela[i].lookType.."@"..color[tabela[i].name].."@")
        end
    end
    return true
end

function onRemoveAddonWindow(cid)
    if not isPlayer(cid) then
        return true
    end

    doSendPlayerExtendedOpcode(cid, ADDONWINDOW_OPCODEHIDE, "")
    return true
end

function onChangeAddon(cid, addon)
    if not isPlayer(cid) then
        return true
    end

    -- Sistema de Addon - Thalles Vitor
    local slot = getPlayerSlotItem(cid, 8)
    if slot.uid <= 0 then
        return true
    end

    local count = getItemAttribute(slot.uid, "addonCount") or 0
    for it = 1, count do
        local addon2 = tostring(getItemAttribute(slot.uid, "addonName"..it)) or "none"
        if addon2 == addon then
            doCreatureExecuteTalkAction(cid, "!addon " .. it, true)
        end
    end
    return true
end