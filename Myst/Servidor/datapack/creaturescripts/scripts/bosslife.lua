-- Criado por Thalles Vitor --

function onThink(cid)
    if not isCreature(cid) then
        return true
    end

    if isInArray(BOSSES, getCreatureName(cid)) then
        local spectator = getSpectators(getCreaturePosition(cid), 7, 7, false)
        if spectator and #spectator > 0 then
            for k, v in pairs(spectator) do
                if isPlayer(v) then
                    onSendBossBarLife(v, cid)
                end
            end
        end
    end
    return true
end