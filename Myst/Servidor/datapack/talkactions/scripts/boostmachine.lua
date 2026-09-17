function onSay(cid, words, param)

	local a = getThingPos(cid)

	doCreateItem(12354, 1, getPosByDir(a, NORTHWEST))
	doCreateItem(12355, 1, getPosByDir(a, NORTHEAST))
	doCreateItem(12356, 1, getPosByDir(a, NORTH))

return true
end