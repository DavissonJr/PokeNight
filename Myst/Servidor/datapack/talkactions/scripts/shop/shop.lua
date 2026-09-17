-- Criado por Thalles Vitor --
-- Sistema de Shop --
function getPlayerPoints(cid)
	if not isPlayer(cid) then
		return 0
	end

	local pontos = 0
	local resultado = db.getResult("SELECT `premium_points` FROM `accounts` WHERE `id` = " .. getPlayerAccountId(cid) .. ";")
	if resultado:getID() ~= -1 then
		pontos = resultado:getDataInt("premium_points")
	end
	return pontos
end

function doPlayerRemovePoints(cid, points)
	if not isPlayer(cid) then
		return true
	end

	local accountId = getPlayerAccountId(cid)
	local points2 = getPlayerPoints(cid)-points
	db.executeQuery("UPDATE `accounts` SET `premium_points` = " .. points2 .. " WHERE `id` = " .. getPlayerAccountId(cid) .. ";")
end

function onSay(cid, words, param)
    if param == "" then
        return true
    end

    for k, v in pairs(SHOP_PRODUCTS) do
        local tabela = SHOP_PRODUCTS[k]
        for i = 1, #tabela do
            if tabela[i] and tabela[i].name == param then
                if tabela[i].price and getPlayerPoints(cid) < tabela[i].price then
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você precisa de: " .. tabela[i].price .. " pontos para comprar " .. param .. ".")
                    return true
                end

                if param == "Troca de Nome" then
                    doPlayerSendTextMessage(cid, 25, "Use o comando !changename com o nome desejado para trocar de nome.")
                    setPlayerStorageValue(cid, 15001, 1)
                    doPlayerRemovePoints(cid, tabela[i].price)
                else
                    doPlayerAddItem(cid, tabela[i].itemId, tabela[i].count)
                    doPlayerRemovePoints(cid, tabela[i].price)
                end

                onSendShopWindow(cid, k)
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "[SHOP] >>>>>> Você recebeu: " .. param .. " <<<<<<")
            end
        end
    end
    return true
end