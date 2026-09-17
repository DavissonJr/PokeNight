-- Criado por Thalles Vitor --
-- TASK System --
monsters =
{
    [1] =
    {
        pokemon = "Magikarp",
        name = "Derrotar 20 Magikarp",
        count = 20,
        points = 1,
        recompenses = {2391, 2394, 2352, 100}, -- 2352 (hd) e 100 (xp)
        counts = {50, 25, 5, 1000000}, -- 1000000 é a exp
        type = "kill",
        requiredStorage = 3200,
        countStorage = 3401,
    },

    [2] =
    {
        pokemon = "Rattata",
        name = "Derrotar 30 Rattata",
        count = 30,
        points = 1,
        recompenses = {2392, 2393},
        counts = {15, 12},
        type = "kill",
        requiredStorage = 3201,
        countStorage = 3402,
    },

    [3] =
    {
        pokemon = "Caterpie",
        name = "Capturar 10 Caterpie",
        count = 10,
        points = 1,
        recompenses = {2392, 2393},
        counts = {15, 12},
        type = "catch",
        requiredStorage = 3202,
        countStorage = 3403,
    },

    [4] =
    {
        pokemon = "Zubat",
        name = "Capturar 30 Zubat",
        count = 30,
        points = 1,
        recompenses = {2392, 2393, 100},
        counts = {15, 12, 4000},
        type = "catch",
        requiredStorage = 3203,
        countStorage = 3404,
    },

    [5] =
    {
        pokemon = "Geodude",
        name = "Capturar 10 Geodude",
        count = 10,
        points = 1,
        recompenses = {2392, 2393, 100},
        counts = {25, 40, 1000},
        type = "catch",
        requiredStorage = 3205,
        countStorage = 3406,
    },

    [6] =
    {
        pokemon = "Vulpix",
        name = "Derrotar 40 Vulpix",
        count = 40,
        points = 1,
        recompenses = {2392, 2393, 100},
        counts = {15, 12, 12000},
        type = "kill",
        requiredStorage = 3207,
        countStorage = 3408,
    },

    [7] =
    {
        pokemon = "Gloom",
        name = "Capturar 15 Gloom",
        count = 15,
        points = 1,
        recompenses = {11441, 11442},
        counts = {1, 1},
        type = "catch",
        requiredStorage = 3209,
        countStorage = 3410,
    },

    [8] =
    {
        pokemon = "Burmy",
        name = "Derrotar 30 Burmy",
        count = 30,
        points = 1,
        recompenses = {12348},
        counts = {50},
        type = "kill",
        requiredStorage = 3210,
        countStorage = 3411,
    },
}

monsters2 =
{
    [1] =
    {
        pokemon = "Magikarp",
        name = "Derrotar 20 Magikarp",
        count = 20,
        points = 1,
        cost = 5,
        recompenses = {2391, 2394},
        counts = {50, 25},
        type = "kill",
        requiredStorage = 3900,
        countStorage = 3901,
    },
}

-- Opcodes - Servidor
TASKWINDOW_OPCODE = 12
TASKWINDOWRECOMP_OPCODE = 13
TASKWINDOWDEST_OPCODE = 14
TASKWINDOWMISSION_OPCODE = 15
TASKWINDOWMISSIONCOMPLET_OPCODE = 16

-- Storages
TASK_SAVEMONSTERS_INDEX = 29000 -- SALVAR O INDEX DA TABELA MONSTERS
TASK_SAVEMONSTERS2_INDEX = 29002 -- SALVAR O INDEX DA TABELA MONSTERS 2
TASK_SAVECATEGORY = 29003 -- salvar qual a tabela
TASK_SAVECATEGORY2 = 29005 -- salvar qual a tabela
TASK_POINTS = 29004 -- salvar os pontos

function onSendRecompense(cid, type)
    if not isPlayer(cid) then
        return true
    end

    if type == "monsters" then
        for it = 1, #monsters do
            local v = monsters[it]
            local k = it
            for i = 1, #v.recompenses do
                doSendPlayerExtendedOpcode(cid, TASKWINDOWRECOMP_OPCODE, v.name.."@"..getItemInfo(v.recompenses[i]).clientId.."@"..v.counts[i].."@"..k.."@")
            end
        end
    elseif type == "monsters2" then
        for it = 1, #monsters2 do
            local v = monsters2[it]
            local k = it
            for i = 1, #v.recompenses do
                doSendPlayerExtendedOpcode(cid, TASKWINDOWRECOMP_OPCODE, v.name.."@"..getItemInfo(v.recompenses[i]).clientId.."@"..v.counts[i].."@"..k.."@")
            end
        end
    end
    return true
end

function onSendTaskWindow(cid, type)
    if not isPlayer(cid) then
        return true
    end

    doSendPlayerExtendedOpcode(cid, TASKWINDOWDEST_OPCODE, "")

    if type == "monsters" then
        for i = 1, #monsters do
            local v = monsters[i]
            local k = i
            local main = tonumber(getPlayerStorageValue(cid, 3200)) or 0
            if main <= 0 then
                setPlayerStorageValue(cid, 3200, 1) -- coloque o valor da primeira missao de storage
            end

            local valor = tonumber(getPlayerStorageValue(cid, v.requiredStorage)) or 0
            if valor <= 0 then valor = 0 end

            local pontos = tonumber(getPlayerStorageValue(cid, TASK_POINTS)) or 0
            if pontos <= 0 then pontos = 0 end

            if valor <= 0 then
                doSendPlayerExtendedOpcode(cid, TASKWINDOW_OPCODE, getMonsterInfo(v.pokemon).lookType.."@"..v.name.."@"..v.points.."@".."no".."@"..k.."@"..type.."@".."noSpecial".."@"..pontos.."@".."0".."@")
            elseif valor == 1 then
                doSendPlayerExtendedOpcode(cid, TASKWINDOW_OPCODE, getMonsterInfo(v.pokemon).lookType.."@"..v.name.."@"..v.points.."@".."yes".."@"..k.."@"..type.."@".."noSpecial".."@"..pontos.."@".."0".."@")
            elseif valor == 2 then
                doSendPlayerExtendedOpcode(cid, TASKWINDOW_OPCODE, getMonsterInfo(v.pokemon).lookType.."@"..v.name.."@"..v.points.."@".."yes".."@"..k.."@"..type.."@".."special".."@"..pontos.."@".."0".."@")
                onSendIsInMission(cid, type)
            elseif valor == 3 then
                doSendPlayerExtendedOpcode(cid, TASKWINDOW_OPCODE, getMonsterInfo(v.pokemon).lookType.."@"..v.name.."@"..v.points.."@".."yes".."@"..k.."@"..type.."@".."special".."@"..pontos.."@".."0".."@")
                isCompletedMission(cid, type)
            end
        end
    elseif type == "monsters2" then
        for i = 1, #monsters2 do
            local v = monsters2[i]
            local k = i
            local main = tonumber(getPlayerStorageValue(cid, 3200)) or 0
            if main <= 0 then
                setPlayerStorageValue(cid, 3200, 1) -- coloque o valor da primeira missao de storage
            end

            local valor = tonumber(getPlayerStorageValue(cid, v.requiredStorage)) or 0
            if valor <= 0 then valor = 0 end

            local pontos = tonumber(getPlayerStorageValue(cid, TASK_POINTS)) or 0
            if pontos <= 0 then pontos = 0 end

            if valor <= 0 then
                doSendPlayerExtendedOpcode(cid, TASKWINDOW_OPCODE, getMonsterInfo(v.pokemon).lookType.."@"..v.name.."@"..v.points.."@".."no".."@"..k.."@"..type.."@".."noSpecial".."@"..pontos.."@"..v.cost.."@")
            elseif valor == 1 then
                doSendPlayerExtendedOpcode(cid, TASKWINDOW_OPCODE, getMonsterInfo(v.pokemon).lookType.."@"..v.name.."@"..v.points.."@".."yes".."@"..k.."@"..type.."@".."noSpecial".."@"..pontos.."@"..v.cost.."@")
            elseif valor == 2 then
                doSendPlayerExtendedOpcode(cid, TASKWINDOW_OPCODE, getMonsterInfo(v.pokemon).lookType.."@"..v.name.."@"..v.points.."@".."yes".."@"..k.."@"..type.."@".."special".."@"..pontos.."@"..v.cost.."@")
                onSendIsInMission(cid, type)
            elseif valor == 3 then
                doSendPlayerExtendedOpcode(cid, TASKWINDOW_OPCODE, getMonsterInfo(v.pokemon).lookType.."@"..v.name.."@"..v.points.."@".."yes".."@"..k.."@"..type.."@".."special".."@"..pontos.."@"..v.cost.."@")
                isCompletedMission(cid, type)
            end
        end
    end

    onSendRecompense(cid, type)
    return true
end

function onStartMission(cid, index, type)
    if not isPlayer(cid) then
        return true
    end

    if type == "monsters" then
        for i = 1, #monsters do
            if index == i then
                local v = monsters[i]
                setPlayerStorageValue(cid, v.requiredStorage, 2)
                setPlayerStorageValue(cid, TASK_SAVEMONSTERS_INDEX, index)
                setPlayerStorageValue(cid, TASK_SAVECATEGORY, type)
                setPlayerStorageValue(cid, v.countStorage, 0)

                onSendTaskWindow(cid, type)
            end
        end
    elseif type == "monsters2" then
        for i = 1, #monsters2 do
            if index == i then
                local v = monsters2[i]
                setPlayerStorageValue(cid, v.requiredStorage, 2)
                setPlayerStorageValue(cid, TASK_SAVEMONSTERS2_INDEX, index)
                setPlayerStorageValue(cid, TASK_SAVECATEGORY2, type)
                setPlayerStorageValue(cid, v.countStorage, 0)

                onSendTaskWindow(cid, type)
            end
        end
    end
    return true
end

function onEndMission(cid)
    if not isPlayer(cid) then
        return true
    end

    local category = getPlayerStorageValue(cid, TASK_SAVECATEGORY)
    if category == "monsters" then
        local index = tonumber(getPlayerStorageValue(cid, TASK_SAVEMONSTERS_INDEX)) or 0
        if index <= 0 then index = 1 end

        for it = 1, #monsters do
            if it == index then
                local v = monsters[it]
                local killed = tonumber(getPlayerStorageValue(cid, v.countStorage)) or 0
                if killed <= 0 then killed = 0 end

                if killed >= v.count then
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você completou a task!")
                    setPlayerStorageValue(cid, v.requiredStorage, 3)
                    setPlayerStorageValue(cid, TASK_SAVECATEGORY, "")

                    for i = 1, #v.recompenses do
                        if v.recompenses[i] == 100 then
                            doPlayerAddExperience(cid, v.counts[i])
                        else
                            doPlayerAddItem(cid, v.recompenses[i], v.counts[i])
                        end
                    end

                    local newIndex = index + 1
                    local tabela = monsters[newIndex]
                    if tabela then
                        setPlayerStorageValue(cid, tabela.requiredStorage, 1)
                    end

                    local points = tonumber(getPlayerStorageValue(cid, TASK_POINTS)) or 0
                    if points <= 0 then points = 0 end

                    setPlayerStorageValue(cid, TASK_SAVEMONSTERS_INDEX, 1)
                    setPlayerStorageValue(cid, TASK_POINTS, points+v.points)
                    isCompletedMission(cid, category)
                    return true
                end
            end
        end
    elseif getPlayerStorageValue(cid, TASK_SAVECATEGORY2) == "monsters2" then
        local index = tonumber(getPlayerStorageValue(cid, TASK_SAVEMONSTERS_INDEX)) or 0
        if index <= 0 then index = 1 end

        for it = 1, #monsters2 do
            if it == index then
                local v = monsters2[it]
                local killed = tonumber(getPlayerStorageValue(cid, v.countStorage)) or 0
                if killed <= 0 then killed = 0 end

                if killed >= v.count then
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você completou a task!")
                    setPlayerStorageValue(cid, v.requiredStorage, 3)
                    setPlayerStorageValue(cid, TASK_SAVECATEGORY2, "")

                    for i = 1, #v.recompenses do
                        doPlayerAddItem(cid, v.recompenses[i], v.counts[i])
                    end

                    local newIndex = index + 1
                    local tabela = monsters2[newIndex]
                    if tabela then
                        setPlayerStorageValue(cid, tabela.requiredStorage, 1)
                    end

                    local points = tonumber(getPlayerStorageValue(cid, TASK_POINTS)) or 0
                    if points <= 0 then points = 0 end

                    setPlayerStorageValue(cid, TASK_SAVEMONSTERS2_INDEX, 1)
                    setPlayerStorageValue(cid, TASK_POINTS, points+v.points)
                    isCompletedMission(cid, category)
                    return true
                end
            end
        end
    end
    return true
end

-- Enviara o quadrado verde sinalizando que esta em missao e vai atualizar os monstros
function onSendIsInMission(cid, type)
    if not isPlayer(cid) then
        return true
    end

    if type == "monsters" then
        for i = 1, #monsters do
            local v = monsters[i]
            local k = i
            local valor = tonumber(getPlayerStorageValue(cid, v.requiredStorage)) or 0
            if valor >= 2 and valor < 3 then
                local monstersCount = tonumber(getPlayerStorageValue(cid, v.countStorage)) or 0
                if monstersCount <= 0 then monstersCount = 0 end

                doSendPlayerExtendedOpcode(cid, TASKWINDOWMISSION_OPCODE, v.name.."@"..k.."@"..monstersCount.."@"..v.count.."@")
            end
        end
    elseif type == "monsters2" then
        for i = 1, #monsters2 do
            local v = monsters2[i]
            local k = i
            local valor = tonumber(getPlayerStorageValue(cid, v.requiredStorage)) or 0
            if valor >= 2 and valor < 3 then
                local monstersCount = tonumber(getPlayerStorageValue(cid, v.countStorage)) or 0
                if monstersCount <= 0 then monstersCount = 0 end

                doSendPlayerExtendedOpcode(cid, TASKWINDOWMISSION_OPCODE, v.name.."@"..k.."@"..monstersCount.."@"..v.count.."@")
            end
        end
    end
    return true
end

function isCompletedMission(cid, type)
    if not isPlayer(cid) then
        return true
    end

    if type == "monsters" then
        for i = 1, #monsters do
            local v = monsters[i]
            local k = i
            local valor = tonumber(getPlayerStorageValue(cid, v.requiredStorage)) or 0
            if valor >= 3 then
                doSendPlayerExtendedOpcode(cid, TASKWINDOWMISSIONCOMPLET_OPCODE, v.name.."@"..k.."@")
            end
        end
    elseif type == "monsters2" then
        for i = 1, #monsters2 do
            local v = monsters2[i]
            local k = i
            local valor = tonumber(getPlayerStorageValue(cid, v.requiredStorage)) or 0
            if valor >= 3 then
                doSendPlayerExtendedOpcode(cid, TASKWINDOWMISSIONCOMPLET_OPCODE, v.name.."@"..k.."@")
            end
        end
    end
    return true
end

function onSendBuyTask(cid, index, category)
    if not isPlayer(cid) then
        return true
    end

    if category == "monsters" then
        local tabela = monsters[index]
        if tabela and tabela.cost then
            local pontos = tonumber(getPlayerStorageValue(cid, TASK_POINTS)) or 0
            if pontos < tabela.cost then
                doPlayerPopupFYI(cid, "Você não tem pontos de missão suficiente para comprar esta missão.")
                return true
            end

            setPlayerStorageValue(cid, tabela.requiredStorage, 1)
            setPlayerStorageValue(cid, TASK_POINTS, pontos-tabela.cost)

            onSendTaskWindow(cid, category)
        end
    elseif category == "monsters2" then
        local tabela = monsters2[index]
        if tabela and tabela.cost then
            local pontos = tonumber(getPlayerStorageValue(cid, TASK_POINTS)) or 0
            if pontos < tabela.cost then
                doPlayerPopupFYI(cid, "Você não tem pontos de missão suficiente para comprar esta missão.")
                return true
            end

            setPlayerStorageValue(cid, tabela.requiredStorage, 1)
            setPlayerStorageValue(cid, TASK_POINTS, pontos-tabela.cost)

            onSendTaskWindow(cid, category)
        end
    end
    return true
end