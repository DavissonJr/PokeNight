function onUse(cid, item, fromPos, item2, toPos)

if getPlayerStorageValue(cid, 54843) == -1 then
setPlayerStorageValue(cid, 54843, 0)
end

if getPlayerStorageValue(cid, 54844) == -1 then
setPlayerStorageValue(cid, 54844, 0)
end

if getPlayerStorageValue(cid, 54845) == -1 then
setPlayerStorageValue(cid, 54845, 0)
end

if getPlayerStorageValue(cid, 54846) == -1 then
setPlayerStorageValue(cid, 54846, 0)
end

		local stt = {}                                               --alterado v1.9 \/

		table.insert(stt, "• Attempts to catch: "..getPlayerStorageValue(cid, 54843).."\n")
		table.insert(stt, "• Successful catches: "..getPlayerSoul(cid).."\n")
		table.insert(stt, "• Failed catches: "..getPlayerStorageValue(cid, 54843) - getPlayerSoul(cid).."\n\n")
		
		table.insert(stt, "Caught Pokemon Species:\n")

local t = getCatchList(cid)

if #t <= 0 then
	table.insert(stt, "\nNone.")
	doShowTextDialog(cid, 7385, table.concat(stt))
return true
end

for b = 1, #oldpokedex do
	for a = 1, #t do
		if t[a] == oldpokedex[b][1] then
            table.insert(stt, "\n["..threeNumbers(b).."] - "..t[a].."")
		end
	end
end
		
	doShowTextDialog(cid, 7385, table.concat(stt))


return true
end
