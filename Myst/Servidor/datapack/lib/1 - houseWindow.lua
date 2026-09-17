-- Criado por Thalles Vitor --
-- House Window --

function getHouseOwnerName(owner)
	if owner == nil or owner <= 0 then
		return "-"
	end

	local result = db.getResult("SELECT `name` FROM `players` WHERE `id` = " .. owner .. ";")
	if result:getID() ~= -1 then
		return result:getDataString("name")
	end

	return "-"
end

HOUSE_WINDOW_OPCODE = 76 -- numero da opcode

function convertValue(value)
	if value < 1000 then
		return tostring(value)
	else
		return tostring(string.format("%1.01f", value/1000))
	end
	return "none"
end

function sendHouseOpcodedWindow(playerId, houseId)
	if not isPlayer(playerId) then
		--print("Player not found")
		return false
	end

	local house = getHouseInfo(houseId)

    local value = convertValue(house.price) * 0.1
	if house.owner > 0 then
		doSendPlayerExtendedOpcode(playerId, HOUSE_WINDOW_OPCODE, "houseWindow".."@"..getHouseOwnerName(house.owner).."@"..convertValue(house.price).."@"..(house.beds/2).."@"..house.name.."@")
	else
		doSendPlayerExtendedOpcode(playerId, HOUSE_WINDOW_OPCODE, "houseWindow".."@".."-".."@"..value.."@"..(house.beds/2).."@"..house.name.."@")
	end
	return true
end