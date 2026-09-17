-- Include the Advanced NPC System
  dofile(getDataDir() .. 'npc/lib/npcsystem/npcsystem.lua')

function selfIdle()
	following = false
	attacking = false
	focus = 0
	target = 0
end

function isConfirmMsg(str)
	if string.find(str, ",") then
	return false
	end
	local a = {"yes", "ok", "sure", "alright", "right",
		   "correct", "true", "fine", "of course",
		   "nice"}
	for b = 1, #a do
		if msgcontains(str, a[b]) then
			return true
		end
	end
return false
end

function isNegMsg(str)
	if string.find(str, ",") then
	return false
	end
	local a = {"no", "not", "wrong"}
	for b = 1, #a do
		if msgcontains(str, a[b]) then
			return true
		end
	end
return false
end

function isDuelMsg(str)
	if string.find(str, ",") then
	return false
	end
	local a = {"battle", "duel", "fight", "challenge", "combat"}
	for b = 1, #a do
		if msgcontains(str, a[b]) then
			return true
		end
	end
return false
end

function doRedirectDirection(d)
	local dir = d

    if d == 7 then
   	 dir = 0
    elseif d == 6 then
   	 dir = 3
    elseif d == 5 then
    	 dir = 1
    elseif d == 4 then
    	 dir = 3
    end
return dir
end

function doDirectPos(n, p)

	local dir = getDirectionTo(n, p)

	if dir <= 3 then return dir end

	local x = math.abs(n.x - p.x)
	local y = math.abs(n.y - p.y)

	if dir == SOUTHWEST then
		if x > y then return WEST else return SOUTH end
	elseif dir == SOUTHEAST then
		if x > y then return EAST else return SOUTH end
	elseif dir == NORTHWEST then
		if x > y then return WEST else return NORTH end
	elseif dir == NORTHEAST then
		if x > y then return EAST else return NORTH end
	end

return dir
end
		
	

function msgcontains(txt, str)
return (string.find(txt, str) and not string.find(txt, '(%w+)' .. str) and not string.find(txt, str .. '(%w+)'))
end

function selfSayChannel(cid, message)
	return selfSay(message, cid, false)
end

function selfMoveToCreature(id)
	if(not id or id == 0) then
		return
	end

	local t = getCreaturePosition(id)
	if(not t.x or t.x == nil) then
		return
	end

	selfMoveTo(t.x, t.y, t.z)
	return
end

function getNpcDistanceToCreature(id)

	if not isCreature(id) then
	return 0
	end

	local pos = getThingPos(id)
	local mos = getThingPos(getThis())

	return getDistanceBetween(pos, mos)
end

function doMessageCheck(message, keyword)
	if(type(keyword) == "table") then
		return table.isStrIn(keyword, message)
	end

	local a, b = message:lower():find(keyword:lower())
	if(a ~= nil and b ~= nil) then
		return true
	end

	return false
end

function doNpcSellItem(cid, itemid, amount, subType, ignoreCap, inBackpacks, backpack)
	local amount = amount or 1
	local subType = subType or 1
	local ignoreCap = ignoreCap and true or false

	local item = 0
	if(isItemStackable(itemid)) then
		item = doCreateItemEx(itemid, amount)
		if(doPlayerAddItemEx(cid, item, ignoreCap) ~= RETURNVALUE_NOERROR) then
			return 0, 0
		end

		return amount, 0
	end

	local a = 0
	if(inBackpacks) then
		local container = doCreateItemEx(backpack, 1)
		local b = 1
		for i = 1, amount do
			item = doAddContainerItem(container, itemid, subType)
			if(itemid == ITEM_PARCEL) then
				doAddContainerItem(item, ITEM_LABEL)
			end

			if(isInArray({(getContainerCapById(backpack) * b), amount}, i)) then
				if(doPlayerAddItemEx(cid, container, ignoreCap) ~= RETURNVALUE_NOERROR) then
					b = b - 1
					break
				end

				a = i
				if(amount > i) then
					container = doCreateItemEx(backpack, 1)
					b = b + 1
				end
			end
		end

		return a, b
	end

	for i = 1, amount do
		item = doCreateItemEx(itemid, subType)
		if(itemid == ITEM_PARCEL) then
			doAddContainerItem(item, ITEM_LABEL)
		end

		if(doPlayerAddItemEx(cid, item, ignoreCap) ~= RETURNVALUE_NOERROR) then
			break
		end

		a = i
	end

	return a, 0
end

function doRemoveItemIdFromPos (id, n, position)
	local thing = getThingFromPos({x = position.x, y = position.y, z = position.z, stackpos = 1})
	if(thing.itemid == id) then
		doRemoveItem(thing.uid, n)
		return true
	end

	return false
end

function getNpcName()
	return getCreatureName(getNpcId())
end

function getNpcPos()
	return getCreaturePosition(getNpcId())
end

function selfGetPosition()
	local t = getNpcPos()
	return t.x, t.y, t.z
end

function getNpcCid() --alterado v1.6
if not isCreature(getNpcId()) then
return getThingFromPosWithProtect({x=1,y=1,z=10,stackpos=253})
end
return getNpcId()
end

function moveRandom(ox,oy,max)
maxx = ox + max
maxy = oy + max
minx = ox - max
miny = oy - max
cx, cy, cz = selfGetPosition()
randmove = math.random(1,50)
if randmove == 1 then
nx = cx + 1
ny = cy
end
if randmove == 2 then
nx = cx - 1
ny = cy
end
if randmove == 3 then
ny = cy + 1
nx = cx
end
if randmove == 4 then
ny = cy - 1
nx = cx
end
if randmove >= 5 then
nx = cx
ny = cy
end
if((nx < maxx) and (ny < maxy) and (nx > minx) and (ny > miny)) then
moveToPosition(nx, ny, cz)
end
end

msgcontains = doMessageCheck
moveToPosition = selfMoveTo
moveToCreature = selfMoveToCreature
selfMoveToPosition = selfMoveTo
selfGotoIdle = selfIdle
isPlayerPremiumCallback = isPremium
doPosRemoveItem = doRemoveItemIdFromPos
doNpcBuyItem = doPlayerRemoveItem
doNpcSetCreatureFocus = selfFocus
--getNpcCid = getNpcId
getThis = getNpcId
getDistanceTo = getNpcDistanceTo
getDistanceToCreature = getNpcDistanceToCreature