-- Criado por Thalles Vitor --
-- Janela de Pontos --

POINTS_INFOOPCODE = 198 -- enviar para o cliente a informacao

function getPremiumPoints(cid)
    if not isPlayer(cid) then
        return 0
    end

    local points = 0
    local resultado = db.getResult("SELECT * FROM `accounts` WHERE `id` = " .. getPlayerAccountId(cid))
    if resultado:getID() ~= -1 then
        points = resultado:getDataInt("premium_points")
    end
    return points
end

function doPlayerAddPremiumPoints(cid, points)
    if not isPlayer(cid) then
        return true
    end

    local pontos = getPremiumPoints(cid)+points
    db.executeQuery("UPDATE `accounts` SET `premium_points` = " .. pontos .. " WHERE `id` = " ..getPlayerAccountId(cid))
    return true
end

function doPlayerRemovePremiumPoints(cid, points)
    if not isPlayer(cid) then
        return true
    end

    local pontos = getPremiumPoints(cid)-points
    db.executeQuery("UPDATE `accounts` SET `premium_points` = " .. pontos .. " WHERE `id` = " ..getPlayerAccountId(cid))
    return true
end

function sendPointsWindow(cid)
    if not isPlayer(cid) then
        return true
    end

    doSendPlayerExtendedOpcode(cid, POINTS_INFOOPCODE, getPremiumPoints(cid).."@")
    return true
end

function sendPoints(cid, name, points)
    if not isPlayer(cid) then
        return true
    end

    name = string.lower(name)
    if name == string.lower(getCreatureName(cid)) then
        doPlayerPopupFYI(cid, "Você não pode transferir pontos para si mesmo.")
        return true
    end

    local players = {}
    for k, v in pairs(getPlayersOnline()) do
        if name == string.lower(getCreatureName(v)) then
            table.insert(players, v)
        end
    end

    if #players == 0 then
        doPlayerPopupFYI(cid, "O jogador precisa estar online.")
        return true
    end

    if tonumber(getPremiumPoints(cid)) < points then
        doPlayerPopupFYI(cid, "Você não tem pontos suficientes para transferir.")
        return true
    end

    for i = 1, #players do
        doPlayerPopupFYI(cid, "Você transferiu: " .. points .. " pontos para: " .. getCreatureName(players[i]) .. ".")
        doPlayerAddPremiumPoints(players[i], points)
        doPlayerRemovePremiumPoints(cid, points)

        sendPointsWindow(cid)
        sendPointsWindow(players[i])
    end
    return true
end