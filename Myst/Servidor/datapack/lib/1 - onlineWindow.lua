-- Criado por Thalles Vitor --
-- Sistema de Online Reward --
ONLINE_RECOMPENSES =
{
    [1] =
    {
        items = {2152, 12345, 12346, 12347, 12348, 2148, 13129, 2391, 2392, 2393, 2394, 11441, 11442, 12232, 11459, 11460, 11458, 11456, 11465, 11468,
        11520, 11540, 12777, 12778, 12779, 12780, 9663},

        count = {30, 30, 25, 25, 15, 25, 1, 60, 35, 25, 15, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        storages = {45029, 45030, 45031, 45032, 45033, 45034, 45035, 45009, 45010, 45011, 45012, 45013, 45014, 45015, 45016,
        45017, 45018, 45019, 45020, 45021, 45022, 45023, 45024, 45025, 45026, 45027, 45028},
    },
}

-- Storages
ONLINEREWARD_STORAGE = 45000 -- storage para marcar em qual reward o jogador estÃ¡
ONLINEREWARD_TIME = 45001 -- tempo
ONLINEREWARD_TIMENEXT = 28764 -- tempo da proxima recompensa

-- Opcodes - Servidor
onlineWINDOWDESTROY_OPCODE = 248 -- destruir infos
onlineWINDOW_OPCODE = 249 -- enviar janela

function setOnlineTime(cid)
    if not isPlayer(cid) then
        return true
    end

    local valor = tonmber(getPlayerStorageValue(cid, ONLINEREWARD_TIME)) or 0
    if valor <= 0 then valor = 0 end

    setPlayerStorageValue(cid, ONLINEREWARD_TIME, valor+1)
    addEvent(setOnlineTime, 1000, cid)
    return true
end

function resetOnlineTime(cid)
    if not isPlayer(cid) then
        return true
    end

    local tabela = ONLINE_RECOMPENSES[getPlayerStorageValue(cid, ONLINEREWARD_STORAGE)]
    if not tabela then
        return true
    end

    for i = 1, #tabela.storages do
        setPlayerStorageValue(cid, tabela.storages[i], 0)
    end

    setPlayerStorageValue(cid, ONLINEREWARD_STORAGE, math.random(1, #ONLINE_RECOMPENSES))
    return true
end

function sendOnlineWindow(cid)
    if not isPlayer(cid) then
        return true
    end

    local storage = tonumber(getPlayerStorageValue(cid, ONLINEREWARD_STORAGE)) or 0
    if storage <= 0 then storage = 0 end

    if storage <= 0 then
        setPlayerStorageValue(cid, ONLINEREWARD_STORAGE, math.random(1, #ONLINE_RECOMPENSES))
    end

    doSendPlayerExtendedOpcode(cid, onlineWINDOWDESTROY_OPCODE, "")
    
    local tabela = ONLINE_RECOMPENSES[getPlayerStorageValue(cid, ONLINEREWARD_STORAGE)]
    if not tabela then return true end
    
    for it = 1, #tabela.items do
        local totalStorage = 0
        if getPlayerStorageValue(cid, tabela.storages[i]) >= 1 then
            totalStorage = totalStorage + 1
        end

        if getPlayerStorageValue(cid, ONLINEREWARD_TIMENEXT) - os.time() > 0 then
            doSendPlayerExtendedOpcode(cid, onlineWINDOW_OPCODE, getItemInfo(tabela.items[it]).clientId.."@"..tabela.count[it].."@"..it.."@".."no".."@")
        else
            doSendPlayerExtendedOpcode(cid, onlineWINDOW_OPCODE, getItemInfo(tabela.items[it]).clientId.."@"..tabela.count[it].."@"..it.."@".."yes".."@")
        end
    end
    return true
end

function sendReedemOnlineReward(cid)
    if not isPlayer(cid) then
        return true
    end

    if getPlayerStorageValue(cid, ONLINEREWARD_TIMENEXT) - os.time() > 0 then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "JÃ¡ resgatou a recompensa.")
        return true
    end

    local totalStorage = 0
    local tabela = ONLINE_RECOMPENSES[getPlayerStorageValue(cid, ONLINEREWARD_STORAGE)]
    if not tabela then return true end

    for it = 1, #tabela.items do
        local valor = tonumber(getPlayerStorageValue(cid, tabela.storages[it])) or 0
        if valor >= 1 then
            totalStorage = totalStorage + 1
        end
    end

    if totalStorage >= #tabela.storages then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você já resgatou todas as recompensas.")
        return true
    end 

    for it = 1, #tabela.items do
        local valor = tonumber(getPlayerStorageValue(cid, tabela.storages[it])) or 0
        if valor <= 0 then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você resgatou: " .. getItemInfo(tabela.items[it]).name .. ".")
            doPlayerAddItem(cid, tabela.items[it], tabela.count[it])
            setPlayerStorageValue(cid, ONLINEREWARD_TIMENEXT, os.time()+3600)
            setPlayerStorageValue(cid, tabela.storages[it], 1)

            sendOnlineWindow(cid)
            break
        end
    end
    return true
end