-- Criado por Thalles Vitor --
-- Sistema de Tm - OnUse --

local TMs = {
	[28232] = {name = "Dazzling Gleam", level = 100, cooldown = 7, storage = 23021},
	[28233] = {name = "Bulldoze", level = 100, cooldown = 7, storage = 23022},
	[28234] = {name = "Roost", level = 100, cooldown = 10, storage = 23023},
	[28235] = {name = "Grass Pledge", level = 100, cooldown = 7, storage = 23024},
	[28236] = {name = "Rock Slide", level = 100, cooldown = 7, storage = 23025},
	[28237] = {name = "Incinerate", level = 100, cooldown = 7, storage = 23026},
	[28238] = {name = "Magical Leaf", level = 100, cooldown = 7, storage = 23027},
	[28239] = {name = "Blizzard", level = 100, cooldown = 7, storage = 23028},
	[28240] = {name = "Toxic", level = 100, cooldown = 7, storage = 23029},
	[28241] = {name = "Thunder Wave", level = 100, cooldown = 7, storage = 23030},
	[28242] = {name = "Punch Flames", level = 100, cooldown = 7, storage = 23031},
	[28243] = {name = "Flare Blitz", level = 100, cooldown = 7, storage = 23032},
}

function onUse(cid, item, frompos, item4, topos)
	local tabelaItem = TMs[item.itemid]

	if not tabelaItem then
		doPlayerSendTextMessage(cid, 22, "Esse TM não pode ser utilizado!")
		return true
	end

	if getPlayerLevel(cid) < tabelaItem.level then
		doPlayerSendTextMessage(cid, 25, "Você precisa de nível: " .. tabelaItem.level .. " para usar este TM.")
		return true
	end

	local count = 1
	for i = 1, 40 do
		if getItemAttribute(item4.uid, "TMsCount"..i) then
			count = count + 1
		end
	end

	local poke = getItemAttribute(item4.uid, "poke")
	local tabela = tm_avaiables[poke]
	if not tabela then
		doPlayerSendTextMessage(cid, 22, "Seu pokémon não pode aprender este movimento!")
		return true
	end

	local summon = getCreatureSummons(cid)
	if #summon >= 1 then
		doPlayerSendTextMessage(cid, 22, "Você precisa voltar o pokémon!")
		return true
	end

	local attrs = tonumber(getItemAttribute(item4.uid, "TMsAprendidos")) or 0
	--[[ if attrs >= 4 then
		doPlayerSendTextMessage(cid, 22, "Seu pokémon não pode aprender mais que: 4 movimentos.")
		return true
	end ]]

	if getPlayerStorageValue(cid, tabelaItem.storage) >= 1 then
		doPlayerSendTextMessage(cid, 22, "Seu pokémon já tem esse movimento!")
		return true
	end

	doPlayerSendTextMessage(cid, 25, "Você colocou o TM: " .. tabelaItem.name .. " no seu pokémon!")
	doSendMagicEffect(getThingPos(cid), 72)

    doItemSetAttribute(item4.uid, "TMsCount"..count, 1)
	doItemSetAttribute(item4.uid, "TMsAprendidos", attrs+1)
    setPlayerStorageValue(cid, tabelaItem.storage, 1)
	doRemoveItem(item.uid, 1)
	return true
end