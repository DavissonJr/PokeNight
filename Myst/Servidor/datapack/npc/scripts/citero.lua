-- Criado por Thalles Vitor --
-- Citero --
local places =
{
	[1] = {name = "Ice", pos = {x=1045, y=762, z=7}},
	[2] = {name = "Thunder", pos = {x=841, y=1205, z=7}},
	[3] = {name = "Psych", pos = {x=1121, y=1497, z=7}},
	[4] = {name = "Fire", pos = {x=817, y=1478, z=7}},
	[5] = {name = "Exotic", pos = {x=965, y=1343, z=7}},
	[6] = {name = "Haunted", pos = {x=1720, y=1203, z=7}},
	[7] = {name = "Plains", pos = {x=1489, y=1167, z=7}},
	[8] = {name = "Hunter", pos = {x=1596, y=1706, z=7}},
	[9] = {name = "Sunshine", pos = {x=1448, y=1826, z=7}},
}

local santuarys = {"Ice", "Thunder", "Psych", "Fire"}

function onThingMove(creature, thing, oldpos, oldstackpos)
end

function onCreatureAppear(creature)
end

function onCreatureDisappear(cid, pos)
end

function onCreatureTurn(creature)
end

function msgcontains(txt, str)
return (string.find(txt, str) and not string.find(txt, '(%w+)' .. str) and not string.find(txt, str .. '(%w+)'))
end

local talkState = {}
function onCreatureSay(cid, type, msg)
	if not isPlayer(cid) then return true end

	if msgcontains(msg, "hi") then
		sendNpcDialog(cid, getNpcCid(), "Olá " .. getCreatureName(cid) .. " eu te levo para os seguintes \nlugares:", {"Fechar", places[1].name, places[2].name, places[3].name, places[4].name, places[5].name, places[6].name, places[7].name, places[8].name, places[9].name})
	end

	for i = 1, #places do
		if msgcontains(msg, places[i].name) then
			local name = places[i].name

			if isInArray(santuarys, name) then
				sendNpcDialog(cid, getNpcCid(), "Deseja mesmo ir para: Santuary " .. name .. "?", {"Fechar", "Yes"})
				talkState[2] = name
				talkState[3] = "yes"
			else
				if name == "Plains" then
					sendNpcDialog(cid, getNpcCid(), "Deseja mesmo ir para: Singer " .. name .. "?", {"Fechar", "Yes"})
				else
					sendNpcDialog(cid, getNpcCid(), "Deseja mesmo ir para: " .. name .. "?", {"Fechar", "Yes"})
				end

				talkState[2] = name
				talkState[3] = "yes"
			end
		end
	end

	if msgcontains(string.lower(msg), "yes") and talkState[3] == "yes" and talkState[2] ~= "" then
		for i = 1, #places do
			if places[i].name == talkState[2] then
				if not isPremium(cid) then
					sendNpcDialog(cid, getNpcCid(), "Para viajar comigo você precisa ser VIP.", {"Fechar"})

					talkState[1] = nil
					talkState[2] = nil
					talkState[3] = nil
					return true
				end

				doTeleportThing(cid, places[i].pos)
				sendNpcDialog(cid, getNpcCid(), "Até mais!", {"Fechar"})

				talkState[1] = nil
				talkState[2] = nil
				talkState[3] = nil
			end
		end
	end

	if msgcontains(string.lower(msg), "bye") then
		sendNpcDialog(cid, getNpcCid(), "Até mais!", {"Fechar"})
		talkState[1] = nil
		talkState[2] = nil
		talkState[3] = nil
	end
	return true
end