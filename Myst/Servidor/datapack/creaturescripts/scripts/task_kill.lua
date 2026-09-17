-- Criado por Thalles Vitor --
-- Sistema de TASK --

function onKill(cid, target)
    if not isCreature(cid) then
        return true
    end

    if not isCreature(target) then
        return true
    end

    local category = getPlayerStorageValue(cid, TASK_SAVECATEGORY)
    if category == "monsters" then
        local index = tonumber(getPlayerStorageValue(cid, TASK_SAVEMONSTERS_INDEX)) or 0
        if index <= 0 then index = 1 end

        for i = 1, #monsters do
            local v = monsters[i]
            local k = i
            if k == index then
                if v.pokemon == getCreatureName(target) and v.type == "kill" then
                    local valor = tonumber(getPlayerStorageValue(cid, v.countStorage)) or 0
                    setPlayerStorageValue(cid, v.countStorage, valor+1)
                    if tonumber(getPlayerStorageValue(cid, v.countStorage)) >= v.count then
                        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Task completada!")
                        onEndMission(cid)
                        return true
                    end

                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Continue para completar a TASK!")
                end
            end
        end
    elseif getPlayerStorageValue(cid, TASK_SAVECATEGORY2) == "monsters2" then
        local index = tonumber(getPlayerStorageValue(cid, TASK_SAVEMONSTERS2_INDEX)) or 0
        if index <= 0 then index = 1 end

        for i = 1, #monsters2 do
            local v = monsters2[i]
            local k = i
            if k == index then
                if v.pokemon == getCreatureName(target) and v.type == "kill" then
                    local valor = tonumber(getPlayerStorageValue(cid, v.countStorage)) or 0
                    setPlayerStorageValue(cid, v.countStorage, valor+1)
                    if tonumber(getPlayerStorageValue(cid, v.countStorage)) >= v.count then
                        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Task completada!")
                        onEndMission(cid)
                        return true
                    end

                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Continue para completar a TASK!")
                end
            end
        end
    end
    return true
end