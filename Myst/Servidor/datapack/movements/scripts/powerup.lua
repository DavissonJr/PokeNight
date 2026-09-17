-- Criado por Thalles Vitor --
local powerUps =
{
    [20001] = {level = 200, items = {12618, 2183, 2160}, count = {1, 1, 3}, storage = 45000},
    [20002] = {level = 100, items = {12345, 2392, 2160}, count = {100, 100, 1}, storage = 45001},
    [20003] = {level = 150, items = {2160, 11449, 2160}, count = {1, 1, 2}, storage = 45002},
    [20004] = {level = 150, items = {2160, 12242, 2160}, count = {1, 1, 2}, storage = 45003},
    [20005] = {level = 150, items = {2160, 9663, 2160}, count = {1, 1, 2}, storage = 45004},
}

local totalPowerUpStorage = 40000 -- storage dos power up
function onStepIn(cid, item, position, fromPosition)
    if not isPlayer(cid) then
        return true
    end

    local tabela = powerUps[item.actionid]
    if not tabela then
        print("Registre o tile com AID: " .. item.actionid .. ".")
        return true
    end
    
    local totalPower = tonumber(getPlayerStorageValue(cid, totalPowerUpStorage)) or 0
    if totalPower <= 0 then totalPower = 0 end

    if getPlayerLevel(cid) < tabela.level then
        --doTeleportThing(cid, frompos)
        doPlayerSendTextMessage(cid, 25, "[POWER UP] - Você precisa de nível: " .. tabela.level .. " para coletar este power up.")
        return true
    end

    local storage = tonumber(getPlayerStorageValue(cid, tabela.storage)) or 0
    if storage <= 0 then
        if totalPower <= 5 then
            setPlayerStorageValue(cid, totalPowerUpStorage, totalPower+1)
        end

        for i = 1, #tabela.items do
            doPlayerAddItem(cid, tabela.items[i], tabela.count[i])
        end

        doSendMagicEffect(getThingPos(cid), 13)
        doPlayerSendTextMessage(cid, 25, "[POWER UP] - Você coletou: " .. getPlayerStorageValue(cid, totalPowerUpStorage) .. " de 5 power ups.")
        setPlayerStorageValue(cid, tabela.storage, 1)
    else
        doPlayerSendTextMessage(cid, 25, "[POWER UP] - O power up já foi coletado.")
    end
    return true
end