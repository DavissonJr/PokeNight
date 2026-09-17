local function getTXT(table, number, item)
	local result = ""
	if not table then return "" end
	local cd = "move"..number..""
	if getCD(item, cd) == 0 or getCD(item, cd) > table.cd + 1 then
		result = "ready."
	else
		result = getCD(item, cd).." seconds."
	end
	local txt = "\n-"..table.name.." (m"..number.."): "..result..""
return txt
end

local function writeCD(str, item, mypoke)
	local txt = str
	local name = getCreatureName(mypoke) == "Ditto" and getPlayerStorageValue(mypoke, 1010) or getCreatureName(mypoke)
	local move = movestable[name].move1
	txt = txt..""..getTXT(move, 1, item)..""

move = movestable[name].move2
txt = txt..""..getTXT(move, 2, item)..""

move = movestable[name].move3
txt = txt..""..getTXT(move, 3, item)..""

move = movestable[name].move4
txt = txt..""..getTXT(move, 4, item)..""

move = movestable[name].move5
txt = txt..""..getTXT(move, 5, item)..""

move = movestable[name].move6
txt = txt..""..getTXT(move, 6, item)..""

move = movestable[name].move7
txt = txt..""..getTXT(move, 7, item)..""

move = movestable[name].move8
txt = txt..""..getTXT(move, 8, item)..""

move = movestable[name].move9
txt = txt..""..getTXT(move, 9, item)..""

move = movestable[name].move10
txt = txt..""..getTXT(move, 10, item)..""

move = movestable[name].move11
txt = txt..""..getTXT(move, 11, item)..""

move = movestable[name].move12
txt = txt..""..getTXT(move, 12, item)..""

move = movestable[name].move13
txt = txt..""..getTXT(move, 13, item)..""

move = movestable[name].move14
txt = txt..""..getTXT(move, 14, item)..""

move = movestable[name].move15
txt = txt..""..getTXT(move, 15, item)..""

return txt
end

function onSay(cid, words, param, channel)


	if param ~= "" then return true end
	if string.len(words) > 3 then return true end

	if #getCreatureSummons(cid) == 0 then
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You need a pokemon to check cooldowns.")
	return 0
	end


	local mypoke = getCreatureSummons(cid)[1]

	if getCreatureName(mypoke) == "Ditto" then
		if not isTransformed(mypoke) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Your ditto needs to transform first.")
		return true
		end
	end

	local str = getCreatureName(mypoke).." moves:"
	local item = getPlayerSlotItem(cid, 8).uid
	
	str = writeCD(str, item, mypoke)

	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, str)
return true
end