local shopWindow = {}
local items_buy = {
 [2394] = {price = 500},
 [2391] = {price = 2000},
 [2393] = {price = 5000},
 [2392] = {price = 12000},
 [12347] = {price = 400},
 [12348] = {price = 1000},
 [12346] = {price = 2200},
 [12345] = {price = 5000},
 [12349] = {price = 800},
 [12330] = {price = 100000},
 [12325] = {price = 1000},
 [12326] = {price = 1000},
 [12327] = {price = 1000},
 [12328] = {price = 1000},
 [12329] = {price = 1000},
}

local items_sell = {
 [11443] = {price = 100000},
 [11451] = {price = 100000},
 [11442] = {price = 100000},
 [11441] = {price = 100000},
 [11453] = {price = 100000},
 [11444] = {price = 100000},
 [11448] = {price = 100000},
 [11445] = {price = 100000},
 [11452] = {price = 100000},
 [11450] = {price = 100000},
 [11449] = {price = 100000},
 [11446] = {price = 100000},
 [11447] = {price = 100000},
 [28195] = {price = 100000},
 [12162] = {price = 200},
 [12337] = {price = 90},
 [12171] = {price = 250},
 [12164] = {price = 85},
 [2694] = {price = 65},
 [12161] = {price = 20},
 [12334] = {price = 100},
 [12175] = {price = 100},
 [12165] = {price = 100},
 [12170] = {price = 800},
 [12200] = {price = 500},
 [12163] = {price = 25},
 [12155] = {price = 500},
 [12173] = {price = 450},
 [12341] = {price = 1000},
 [12153] = {price = 900},
 [12193] = {price = 400},
 [12177] = {price = 350},
 [12176] = {price = 350},
 [12172] = {price = 450},
 [12204] = {price = 250},
 [12194] = {price = 600},
 [12203] = {price = 200},
 [12195] = {price = 300},
 [12181] = {price = 400},
 [12154] = {price = 250},
 [12198] = {price = 250},
 [12159] = {price = 900},
 [12188] = {price = 200},
 [12207] = {price = 250},
 [12148] = {price = 400},
 [12196] = {price = 200},
 [12158] = {price = 200},
 [12174] = {price = 200},
 [12157] = {price = 250},
 [12152] = {price = 350},
 [12232] = {price = 150000},
 [12187] = {price = 220},
 [12169] = {price = 250},
 [12209] = {price = 300},
 [12201] = {price = 200},
 [12202] = {price = 150},
 [12182] = {price = 250},
 [12179] = {price = 150},
 [12192] = {price = 200},
 [12185] = {price = 150},
 [12208] = {price = 200},
 [12167] = {price = 55},
 [12186] = {price = 45},
 [12180] = {price = 50},
 [12205] = {price = 50},
 [12197] = {price = 25},
}

function onThingMove(creature, thing, oldpos, oldstackpos)
end

function onCreatureAppear(creature)
end

function onCreatureDisappear(cid, pos)
if focus == cid then
selfSay('Good bye sir!')
focus = 0
talk_start = 0
end
end

function onCreatureTurn(creature)
end

function onCreatureSay(cid, type, msg)
local msg = string.lower(msg)
local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

if (getDistanceToCreature(cid) <= 3) then
	if msgcontains(msg, 'hi') then
		sendNpcDialog(cid, getNpcCid(), "Ola querido(a) cliente! Aqui em minha loja vendo so \nprodutos de otima qualidade vamos conferir. Deseja ver \nminhas ofertas?", {"Fechar", "Trade"})
	end

	local onBuy = function(cid, item, subType, amount, ignoreCap, inBackpacks)
		if items_buy[item] and getPlayerMoney(cid) < items_buy[item].price * amount then
		  sendNpcDialog(cid, getNpcCid(), "Você não possui dinheiro suficiente.", {"Fechar", "Trade"})
		else
		  doPlayerAddItem(cid, item, amount)
		  doPlayerRemoveMoney(cid, (items_buy[item].price) * amount)
		end
	  end

     local onSell = function(cid, item, subType, amount, ignoreCap, inBackpacks)
		if items_sell[item] then
			local catchBag = getPlayerSlotItem(cid, 13)
			if catchBag.uid > 0 then
				if isContainer(catchBag.uid) then
					for i = 0, getContainerSize(catchBag.uid)-1 do
						local items = getContainerItem(catchBag.uid, i)
						if items and items.uid > 0 and not getItemAttribute(items.uid, "poke") then
							selfSay("Tire os items da catch bag.")
							return false
						end
					end
				end
			end

			if amount >= getPlayerItemCount(cid, item, -1) then
				doPlayerAddMoney2(cid, items_sell[item].price * getPlayerItemCount(cid, item, -1) * 2)
				doPlayerRemoveItem(cid, item, getPlayerItemCount(cid, item, -1))
			else
				doPlayerAddMoney2(cid, items_sell[item].price * amount)
				doPlayerRemoveItem(cid, item, amount)

				--[[ empilhar(cid) ]]
			end
		end
	  end

	  if msgcontains(msg, 'trade') or msgcontains(msg, 'TRADE') then
		for i = 1, #shopWindow do
		  shopWindow[i] = nil
		end

		for var, ret in pairs(items_buy) do
		  table.insert(shopWindow, {id = var, subType = 0, buy = ret.price , sell = 0, name = getItemNameById(var)})
		end

		if isPremium(cid) then
			for var, ret in pairs(items_sell) do
				table.insert(shopWindow, {id = var, subType = 0, buy = 0, sell = ret.price * 2, name = getItemNameById(var)})
			end
		else
			for var, ret in pairs(items_sell) do
				table.insert(shopWindow, {id = var, subType = 0, buy = 0, sell = ret.price, name = getItemNameById(var)})
			end
		end
	  
		openShopWindow(cid, shopWindow, onBuy, onSell)
		sendCloseNpcDialog(cid)
	  end
	  
	  if msgcontains(msg, 'Fechar') or msgcontains(msg, 'fechar') or msgcontains(msg, 'FECHAR') then
		sendCloseNpcDialog(cid)
	  end
   end
end