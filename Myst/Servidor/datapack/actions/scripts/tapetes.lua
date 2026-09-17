local object_itemid = {

[26578] = {transform_to = 26579, premium = false, useWith=true},
[26579] = {transform_to = 26578, premium = false, useWith=false},
[26580] = {transform_to = 26581, premium = false, useWith=true},
[26581] = {transform_to = 26580, premium = false, useWith=false},
[26630] = {transform_to = 26631, premium = false, useWith=true},
[26631] = {transform_to = 26630, premium = false, useWith=false},
[26601] = {transform_to = 26602, premium = false, useWith=true},
[26602] = {transform_to = 26601, premium = false, useWith=false},
[26603] = {transform_to = 26604, premium = false, useWith=true},
[26604] = {transform_to = 26603, premium = false, useWith=false},
[26605] = {transform_to = 26606, premium = false, useWith=true},
[26606] = {transform_to = 26605, premium = false, useWith=false},
[26607] = {transform_to = 26608, premium = false, useWith=true},
[26608] = {transform_to = 26607, premium = false, useWith=false},
[26632] = {transform_to = 26643, premium = false, useWith=true},
[26643] = {transform_to = 26632, premium = false, useWith=false},
[26644] = {transform_to = 26632, premium = false, useWith=false},
[26645] = {transform_to = 26632, premium = false, useWith=false},
[26646] = {transform_to = 26632, premium = false, useWith=false},
[26635] = {transform_to = 26651, premium = false, useWith=true},
[26651] = {transform_to = 26635, premium = false, useWith=false},
[26642] = {transform_to = 26827, premium = false, useWith=true},
[26827] = {transform_to = 26642, premium = false, useWith=false},
[26829] = {transform_to = 26828, premium = false, useWith=true},
[26828] = {transform_to = 26829, premium = false, useWith=false},
[26641] = {transform_to = 26826, premium = false, useWith=true},
[26826] = {transform_to = 26641, premium = false, useWith=false},
[26640] = {transform_to = 26825, premium = false, useWith=true},
[26825] = {transform_to = 26640, premium = false, useWith=false},
[26639] = {transform_to = 26824, premium = false, useWith=true},
[26824] = {transform_to = 26639, premium = false, useWith=false},

}


function onUse(cid, item, frompos, item2, topos)
	local storage = 789561
	local time = 1
	
	local sendEffect = true -- true or false
	local EffectId = 1
	
	local item_from_table = object_itemid[item.itemid]
	
	if exhaustion.check(cid, storage) then
		return false
	end
	
	if item_from_table then
	
		if item_from_table.premium and not isPremium(cid) then
			return false and doPlayerSendCancel(cid, "You need to be a premium account.")
		end
		doRemoveItem(item.uid,1)
		if item_from_table.useWith then
			doCreateItem(item_from_table.transform_to,1,topos)
		else
			doCreateItem(item_from_table.transform_to,1,frompos)
		end
		if sendEffect then
			doSendMagicEffect(getThingPos(cid), EffectId)
		end
	end
	
	return true and exhaustion.set(cid,storage,time)
end