function onEquip (cid, item, slot)
	if not isPlayer(cid) then return true end
	if not item then return true end
	if item == nil then return true end
	if item.uid <= 0 then return true end

	if not getItemAttribute(item.uid, "poke") then
	return true
	end

	if getPlayerSlotItem(cid, 7).uid <= 0 then
		doPlayerAddItem(cid, 2395)
	end
    
	for i, x in pairs(fotos) do
		if string.lower(getItemAttribute(item.uid, "poke")) == string.lower(i) then
			doTransformItem(getPlayerSlotItem(cid, 7).uid, fotos[i])
		return true
		end
	end
end

function onDeEquip(cid, item, slot)
	if not isPlayer(cid) then return true end
	if not item then return true end
	if item == nil then return true end
	if item.uid ~= nil then
		if item.uid <= 0 then 
			doTransformItem(getPlayerSlotItem(cid, CONST_SLOT_LEGS).uid, 2395)
			return true 
		end

		if not getItemAttribute(item.uid, "poke") then
			return true
		end
	end

	doTransformItem(getPlayerSlotItem(cid, CONST_SLOT_LEGS).uid, 2395)
end