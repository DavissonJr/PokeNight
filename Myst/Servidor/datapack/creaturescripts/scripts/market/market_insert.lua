-- Criado por Thalles Vitor --
-- Market insert item in client --
local decorationList = {} -- aqui voce vai colocar o id de todos os items que sao decoracoes
local stonesList = {} -- aqui voce vai colocar o id de todos os items que sao stones

function onMarketInsert(cid, item)
	-- Thalles Vitor - Market (Change Attrs) --
	local slot = getPlayerSlotItem(cid, 3)
	if slot.uid <= 0 then return true end
	for i = 0, getContainerSize(slot.uid)-1 do
		local item3 = getContainerItem(slot.uid, i)
		if item3 then
			if getItemAttribute(item3.uid, "poke") then
				local iname = getItemInfo(item3.itemid)
				local pokename = getItemAttribute(item3.uid, "poke")
				
				local str = {}
				table.insert(str, "You see "..getArticle(pokename).." "..pokename.." "..iname.name..".\n")

				if getItemAttribute(item3.uid, "gender") == SEX_MALE then
					table.insert(str, "[GENDER]: Male.\n ")
				elseif getItemAttribute(item3.uid, "gender") == SEX_FEMALE then
					table.insert(str, "[GENDER]: Female.\n ")
				else
					table.insert(str, "[GENDER]: Indefinido.\n ")
				end
				
				doItemSetAttribute(item3.uid, "description", table.concat(str))
			end
		end
	end

	local slot2 = getPlayerSlotItem(cid, 8)
	if slot2.uid > 0 then
		if getItemAttribute(slot2.uid, "poke") then
				local iname = getItemInfo(slot2.itemid)
				local pokename = getItemAttribute(slot2.uid, "poke")
				
				local str = {}
				table.insert(str, "You see "..getArticle(pokename).." "..pokename.." "..iname.name..".\n")

				if getItemAttribute(slot2.uid, "gender") == SEX_MALE then
					table.insert(str, "[GENDER]: Male.\n ")
				elseif getItemAttribute(slot2.uid, "gender") == SEX_FEMALE then
					table.insert(str, "[GENDER]: Female.\n ")
				else
					table.insert(str, "[GENDER]: Indefinido.\n ")
				end

				doItemSetAttribute(slot2.uid, "description", table.concat(str))
		end
	end
	--

	-- Thalles Vitor - Market (Change Attrs) --
	if item then
		if getItemAttribute(item.uid, "poke") then
			local iname = getItemInfo(item.itemid)
			local pokename = getItemAttribute(item.uid, "poke")
				
			local str = {}
			table.insert(str, "You see "..getArticle(pokename).." "..pokename.." "..iname.name..".\n")

			if getItemAttribute(item.uid, "gender") == SEX_MALE then
				table.insert(str, "[GENDER]: Male.\n ")
			elseif getItemAttribute(item.uid, "gender") == SEX_FEMALE then
				table.insert(str, "[GENDER]: Female.\n ")
			else
				table.insert(str, "[GENDER]: Indefinido.\n ")
			end

			for i = 1, 3 do
				local addon = getItemAttribute(item.uid, "addonName"..i)
				if addon then
					table.insert(str, "[ADDONS]: "..addon..".\n")
				end 
			end
				
			doItemSetAttribute(item.uid, "description", table.concat(str))
		end
	end
	if getItemAttribute(item.uid, "poke") then
		local pokemon_itemid = getItemInfo(item.itemid).clientId
		local pokemon_name = getItemAttribute(item.uid, "poke")
		local pokemon_gender = getItemAttribute(item.uid, "gender") or math.random(2, 3)
		local pokemon_level = getItemAttribute(item.uid, "level") or 1
		local pokemon = "isPokemon"
		local random = math.random(1, 10000 * 2 + 150)

		doSendPlayerExtendedOpcode(cid, 111, pokemon_itemid.."@"..pokemon_name.."@"..pokemon_gender.."@"
		..pokemon_level.."@"..pokemon.."@"..item.type.."@"..random.."@")
		doItemSetAttribute(item.uid, "itemSELECTED", random)
	else
		local itemid = getItemInfo(item.itemid).clientId
		local name = getItemInfo(item.itemid).name
		local var = 0
		local var2 = "notPokemon"
		local random = math.random(1, 10000 * 2 + 150)

		doSendPlayerExtendedOpcode(cid, 111, itemid.."@"..name.."@"..var.."@"..var.."@"..var2.."@"..item.type.."@"..random.."@")
		doItemSetAttribute(item.uid, "itemSELECTED", random)
	end

	if isInArray(decorationList, item.itemid) then
        local itemid = getItemInfo(item.itemid).clientId
		local name = getItemInfo(item.itemid).name
		local var = 0
		local var2 = "Decoracoes"
		local random = math.random(1, 10000 * 2 + 150)

		doSendPlayerExtendedOpcode(cid, 111, itemid.."@"..name.."@"..var.."@"..var.."@"..var2.."@"..item.type.."@"..random.."@")
		doItemSetAttribute(item.uid, "itemSELECTED", random)
    end

    if isInArray(stonesList, item.itemid) then
        local itemid = getItemInfo(item.itemid).clientId
		local name = getItemInfo(item.itemid).name
		local var = 0
		local var2 = "Stones"
		local random = math.random(1, 10000 * 2 + 150)

		doSendPlayerExtendedOpcode(cid, 111, itemid.."@"..name.."@"..var.."@"..var.."@"..var2.."@"..item.type.."@"..random.."@")
		doItemSetAttribute(item.uid, "itemSELECTED", random)
    end
	return true
end