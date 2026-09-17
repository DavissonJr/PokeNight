local etele = 0
local cdtele = 0

local config = {
premium = true, -- se precisa ser premium account (true or false)
battle = false -- se precisa estar sem battle (true). Se colocar false, poderá usar teleport no meio de batalhas
}

local places = {
-- Kanto --
[1] = {name = "Saffron", id = 1, sto = 897530},
[2] = {name = "Cerulean", id = 2, sto = 897531},
[3] = {name = "Lavender", id = 3, sto = 897532},
[4] = {name = "Fuchsia", id = 4, sto = 897533},
[5] = {name = "Celadon", id = 5, sto = 897534},
[6] = {name = "Pallet", id = 6, sto = 897535},
[7] = {name = "Pewter", id = 8, sto = 897536},
[8] = {name = "Viridian", id = 9, sto = 897537},
[9] = {name = "Vermilion", id = 10, sto = 897538},
[10] = {name = "Cinnabar", id = 11, sto = 897539},
-- Hoeen --
[11] = {name = "Larosse", id = 13, sto = 897540},
[12] = {name = "Orre", id = 7, sto = 897541},
[13] = {name = "Canavale", id = 16, sto = 897542},
-- Vip
[14] = {name = "Singer", id = 12, sto = 897543},
[15] = {name = "Hunter Village", id = 14, sto = 897544},
[16] = {name = "Sunshine", id = 15, sto = 897545},
[17] = {name = "Battle City", id = 31, sto = 897546},
-- Johto --
[18] = {name = "Goldenrod", id = 23, sto = 897547},
[19] = {name = "Azalea", id = 24, sto = 897548},
[20] = {name = "Ecruteak", id = 25, sto = 897549},
[21] = {name = "Olivine", id = 26, sto = 897550},
[22] = {name = "Violet", id = 27, sto = 897551},
[23] = {name = "Cherrygrove", id = 28, sto = 897552},
[24] = {name = "New Bark", id = 29, sto = 897553},
[25] = {name = "Mahogany", id = 30, sto = 897554},
[26] = {name = "Blackthorn", id = 32, sto = 897555},
-- Outro --

--[[ [27] = {name = "Join Avenue", id = 39, sto = 897556}, ]]
[27] = {name = "Cianwood", id = 33, sto = 897557},
-- Novas Citys
}

function onSay(cid, words, param)
if #getCreatureSummons(cid) == 0 then
doPlayerSendCancel(cid, "Você precisa de um pokémon para usar teleport!")
return true
end

if not isInArray(specialabilities["teleport"], getCreatureName(getCreatureSummons(cid)[1])) then
return 0
end

if getPlayerStorageValue(cid, 1338) - os.time() > 0 then
	doBroadcastMessage(getCreatureName(cid) .. " está tentando fugir da prisão.")
	doPlayerSendTextMessage(cid, 25, "Um foragido não pode fugir da prisão.")
	return true
end

if param == "house" then
	if not getHouseByPlayerGUID(getPlayerGUID(cid)) then
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "You don't own a house.")
		return true
	end

	doCreatureSay(cid, "Teleporte-se até minha casa!", TALKTYPE_MONSTER)
	doTeleportThing(cid, getHouseEntry(getHouseByPlayerGUID(getPlayerGUID(cid))))
	return true
end

if exhaustion.get(cid, etele) and exhaustion.get(cid, etele) > 0 then
local tempo = tonumber(exhaustion.get(cid, etele)) or 0
local min = math.floor(tempo)
doPlayerSendCancel(cid, "Your pokemon is tired, wait "..getStringmytempo(tempo).." to teleport again.")
return true
end

if config.premium and not isPremium(cid) then
doPlayerSendCancel(cid, "Apenas membros Premium Account podem teleportar!")
return true
end

if config.battle and getCreatureCondition(cid, CONDITION_INFIGHT) then
doPlayerSendCancel(cid, "Your pokemon can't concentrate during battles.")
return true
end

	if (param == '') then
		local str = ""
		str = str .. "Cidades disponiveis (PokeGold) :\n\nHouse\n"
			for a = 1, #places do
				str = str..""..places[a].name.."\n"
			end
		doShowTextDialog(cid, 7416, str)
	return true
	end

local item = getPlayerSlotItem(cid, 8)
local nome = getPokeballName(item.uid)
local summon = getCreatureSummons(cid)[1]
local lastppos = getThingPos(cid)
local lastspos = getThingPos(summon)
local myplace = ""
local townid = 0
local citySto = 0 --alterado v1.7


for x = 1, #places do
if string.find(string.lower(places[x].name), string.lower(param)) then
townid = places[x].id
myplace = places[x].name
citySto = places[x].sto or -1 --alterado v1.7
end
end

if myplace == "" then
doPlayerSendCancel(cid, "That place doesn't exist.")
return true
end


if myplace ~= "" and townid > 0 then
telepos = getTownTemplePosition(townid)
end

doTeleportThing(cid, telepos, false)
local pos2 = getClosestFreeTile(cid, getPosByDir(getThingPos(cid), SOUTH))

doTeleportThing(summon, pos2, false)
doSendMagicEffect(getThingPos(summon), CONST_ME_TELEPORT)

return true
end