-- Criado por Thalles Vitor --
-- Auto Target --

local storage = 9293
function onExtendedOpcode(cid, opcode, buffer)
    if not isPlayer(cid) then return true end
    if opcode == 214 then
        monsters = {}
        --if #getCreatureSummons(cid) > 0 then
            local spectator = getSpectators(getCreaturePosition(cid), 14, 14, false)
            if spectator and #spectator > 0 then
                for k, v in pairs(spectator) do
                    if isMonster(v) and not isSummon(v) then
                        table.insert(monsters, v)
                    end
                end
            end

            setPlayerStorageValue(cid, storage, getPlayerStorageValue(cid, storage)+1)
            local monster = monsters[tonumber(getPlayerStorageValue(cid, storage))]
            if isCreature(monster) then
                doSendPlayerExtendedOpcode(cid, 3, monster.."@")
                doMonsterSetTarget2(cid, monster)
            else
                setPlayerStorageValue(cid, storage, 0)
            end
        --end
        for i = 1, 12 do
            doCreatureExecuteTalkAction(cid, "m" .. i)
        end
    end

    return true
end
 