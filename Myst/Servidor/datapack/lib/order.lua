local dirpref = {
[1] =  {[NORTH] = {[1] = {NORTH}, [2] = {EAST, WEST}, [3] = {NORTHEAST, NORTHWEST}},
	[EAST] = {[1] = {EAST}, [2] = {NORTH, SOUTH}, [3] = {NORTHEAST, SOUTHEAST}},
	[SOUTH] = {[1] = {SOUTH}, [2] = {EAST, WEST}, [3] = {SOUTHEAST, SOUTHWEST}},
	[WEST] = {[1] = {WEST}, [2] = {SOUTH, NORTH}, [3] = {NORTHWEST, SOUTHWEST}},
	[NORTHEAST] = {[1] = {NORTH, EAST}, [2] = {NORTHEAST}, [3] = {SOUTH, WEST}},
	[SOUTHEAST] = {[1] = {SOUTH, EAST}, [2] = {SOUTHEAST}, [3] = {NORTH, WEST}},
	[SOUTHWEST] = {[1] = {SOUTH, WEST}, [2] = {SOUTHWEST}, [3] = {NORTH, EAST}},
	[NORTHWEST] = {[1] = {NORTH, WEST}, [2] = {NORTHWEST}, [3] = {EAST, SOUTH}}},
[2] =  {[NORTH] = {[1] = {NORTH}, [2] = {WEST, EAST}, [3] = {NORTHWEST, NORTHEAST}},
	[EAST] = {[1] = {EAST}, [2] = {SOUTH, NORTH}, [3] = {SOUTHEAST, NORTHEAST}},
	[SOUTH] = {[1] = {SOUTH}, [2] = {WEST, EAST}, [3] = {SOUTHWEST, SOUTHEAST}},
	[WEST] = {[1] = {WEST}, [2] = {NORTH, SOUTH}, [3] = {SOUTHWEST, NORTHWEST}},
	[NORTHEAST] = {[1] = {EAST, NORTH}, [2] = {NORTHEAST}, [3] = {WEST, SOUTH}},
	[SOUTHEAST] = {[1] = {EAST, SOUTH}, [2] = {SOUTHEAST}, [3] = {WEST, NORTH}},
	[SOUTHWEST] = {[1] = {WEST, SOUTH}, [2] = {SOUTHWEST}, [3] = {EAST, NORTH}},
	[NORTHWEST] = {[1] = {WEST, NORTH}, [2] = {NORTHWEST}, [3] = {SOUTH, EAST}}},
}

function doPushCreature(uid,direction,distance,time)
   if isCreature(uid) == TRUE then
   local rand = (2*math.random(0,1))-1
   local rand2 = math.random(-1,0)
	  if direction == 0 then
	  signal = {0,rand,-rand,rand,-rand,0,-1,-1,-1,0,0,0}
	  elseif direction == 1 then
	  signal = {1,1,1,0,0,0,0,rand,-rand,rand,-rand,0}
	  elseif direction == 2 then
	  signal = {0,rand,-rand,rand,-rand,0,1,1,1,0,0,0}

	  elseif direction == 3 then

	  signal = {-1,-1,-1,0,0,0,0,rand,-rand,rand,-rand,0}

	  elseif direction == 4 then

	  signal = {-1,rand2,(-rand2)-1,0,1,rand2+1,rand2,0}

	  elseif direction == 5 then

	  signal = {1,-rand2,-((-rand2)-1),0,1,rand2+1,rand2,0}

	  elseif direction == 6 then

	  signal = {-1,rand2,(-rand2)-1,0,-1,(-rand2)-1,rand2,0}

	  else

	  signal = {1,-rand2,-((-rand2)-1),0,-1,(-rand2)-1,rand2,0}

	  end

   local pos = getThingPos(uid)

   nsig = #signal

   nvar = 0

   

   repeat

   nvar = nvar+1

   newpos = {x=pos.x+(signal[nvar]),y=pos.y+(signal[(nsig/2)+nvar]),z=pos.z}

   newtile = {x=newpos.x,y=newpos.y,z=newpos.z,stackpos=0}

   until getTileThingByPos(newtile).uid ~= 0 and canWalkOnPos(newtile, true, false, true, true, false) and queryTileAddThing(uid,newpos) == 1 or nvar == (nsig/2)
                                                                                                                        --alterado v2.5
   

	  if distance == nil or distance == 1 then

	  doTeleportThing(uid,newpos,TRUE)   

	  else

	  distance = distance-1

	  doTeleportThing(uid,newpos,TRUE)

		 if time ~= nil then

		 addEvent(doPushCreature,time,uid,direction,distance,time)

		 else

		 addEvent(doPushCreature,500,uid,direction,distance,500)

		 end	   

	  end

   end  

end

function doComparePosition(pos1, pos2)
	if pos1.x == pos2.x and pos1.y == pos2.y and pos1.z == pos2.z then
	return true
	end
return false
end

function getNextStepDelay(cid, dir)
	return 190
end

function walkTo(cid, direction, finalp, useExtraMoveOrder)
	if not isCreature(cid) then return true end

	doChangeSpeed(cid, 5)
	local x = getThingPos(cid)
	local ratedelaywalk = 1
	local finalpos = {x = finalp.x, y = finalp.y, z = finalp.z}

		if not canWalkOnPos(finalpos, false, false, true, true, true) then
			finalpos = getClosestFreeTile(cid, finalpos)
		end

		if not finalpos then
		return false
		end

	local dir = getDirectionTo(getThingPos(cid), finalpos)
	if dir and tonumber(dir) ~= nil and tonumber(dir) >= 0 and tonumber(dir) <= 7 then
		if dir >= 4 then
			ratedelaywalk = 0.4
		end
		doPushCreature(cid, dir, 1, getNextStepDelay(cid, dir) * ratedelaywalk)
		return getNextStepDelay(cid, dir) * ratedelaywalk
	elseif useExtraMoveOrder then

local random = math.random(1, 2)

	for ta = 1, 3 do
		for tb = 1, #dirpref[random][direction][ta] do
			local y = getPosByDir(getThingPos(cid), dirpref[random][direction][ta][tb])
			local w = getCreatureLP(cid)
			local z = getDirectionTo(y, getThingPos(cid)) -- dire��o q vai marcar
			local j = getDirectionTo(getThingPos(cid), y) -- dire��o q ele vai
			if canWalkOnPos(y, true, false, true, true, true) and w ~= j then
				if dirpref[random][direction][ta][tb] >= 4 then
					ratedelaywalk = 0.5
				end
				doPushCreature(cid, dirpref[random][direction][ta][tb], 1, getNextStepDelay(cid, dirpref[random][direction][ta][tb]) * ratedelaywalk)
				markLP(cid, z)
			return getNextStepDelay(cid, dirpref[random][direction][ta][tb]) * ratedelaywalk
			end
		end
	end
	end
return false
end

function getCreatureLP(cid)
return getPlayerStorageValue(cid, 197)
end

function markLP(cid, dir)
setPlayerStorageValue(cid, 197, dir)
end

function markPos(sid, pos)
if not isCreature(sid) then return end
setPlayerStorageValue(sid, 145, pos.x)
setPlayerStorageValue(sid, 146, pos.y)
setPlayerStorageValue(sid, 147, pos.z)
end

function markFlyingPos(sid, pos)
if not isCreature(sid) then return end
setPlayerStorageValue(sid, 33145, pos.x)
setPlayerStorageValue(sid, 33146, pos.y)
setPlayerStorageValue(sid, 33147, pos.z)
end

function getFlyingMarkedPos(sid)
if not isCreature(sid) then return end
local xx = getPlayerStorageValue(sid, 33145)
local yy = getPlayerStorageValue(sid, 33146)
local zz = getPlayerStorageValue(sid, 33147)
return {x = xx, y = yy, z = zz, stackpos = 0}
end

function getMarkedPos(sid)
if not isCreature(sid) then return end
local xx = getPlayerStorageValue(sid, 145)
local yy = getPlayerStorageValue(sid, 146)
local zz = getPlayerStorageValue(sid, 147)
return {x = xx, y = yy, z = zz}
end

function getOwnerPos(sid)
if not isCreature(sid) then return end
local xx = getPlayerStorageValue(sid, 148)
local yy = getPlayerStorageValue(sid, 149)
local zz = getPlayerStorageValue(sid, 150)
return {x = xx, y = yy, z = zz}
end

function markOwnerPos(sid, pos)
if not isCreature(sid) then return end
setPlayerStorageValue(sid, 148, pos.x)
setPlayerStorageValue(sid, 149, pos.y)
setPlayerStorageValue(sid, 150, pos.z)
end

function recheck(sid, skill, pos)
	if not isCreature(sid) then return end
	local cid = getCreatureMaster(sid)

	if skill == "cut" then

		local item = getTileItemById(pos, 2767)
		doCreatureSay(sid, "CUT!", TALKTYPE_MONSTER)
		markPos(sid, {x=1,y=1,z=7})
		doFaceCreature(sid, pos)
		doSendMagicEffect(getThingPos(item.uid), 141)
		doTransformItem(item.uid, 6216)
			local function growBush()
			doTransformItem(getTileItemById(pos, 6216).uid, 2767)
			end
		addEvent(growBush, intervalToRegrowBushAndStones * 1000)

	elseif skill == "rock smash" then

		local item = getTileItemById(pos, 1285)
		doCreatureSay(sid, "ROCK SMASH!", TALKTYPE_MONSTER)
		markPos(sid, {x=1,y=1,z=7})
		doFaceCreature(sid, pos)
		doSendMagicEffect(getThingPos(item.uid), 118)
		doTransformItem(item.uid, 3610)
			local function growRock()
			doTransformItem(getTileItemById(pos, 3610).uid, 1285)
			end
		addEvent(growRock, intervalToRegrowBushAndStones * 1000)
		
    elseif skill == "headbutt" then   --alterado v2.6
    
    local master = getCreatureMaster(sid)
    local array = {}                           
    local lvl = {25, 40, 60, 80, 1000} --lvls

    for i = 1, #lvl do
        if getPlayerLevel(master) <= lvl[i] then
           array = headbutt[lvl[i]]
           break
        end
    end 
    local rand = array[math.random(#array)]
    for j = 1, rand[2] do
        local poke = doCreateMonster(rand[1], getClosestFreeTile(sid, pos))
        doSetMonsterPassive(poke)               
        doWildAttackPlayer(poke, master) 
    end
    local item = getTileItemById(pos, 12591)    --id do item   arvore normal
    doCreatureSay(sid, "HEADBUTT!", TALKTYPE_MONSTER)
    markPos(sid, {x=1,y=1,z=7})
    doFaceCreature(sid, pos)
    doSendMagicEffect(getThingPos(item.uid), 118)
    doTransformItem(item.uid, 12592)  --id do item   arvore quebrada
    local function growHead()
          doTransformItem(getTileItemById(pos, 12592).uid, 12591) --id do item  arvore quebrada, arvore normal
    end
    addEvent(growHead, choose(5, 10, 20, 30) * 60 * 1000)   --o tempo pra arvore voltar ao normal varia de 5~30min

	elseif skill == "dig" then
		if isPlayer(cid) then
			local item = getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0})
			doCreatureSay(sid, "DIG!", TALKTYPE_MONSTER)
			markPos(sid, {x=1,y=1,z=7})
			doFaceCreature(sid, pos)
			doSendMagicEffect(getThingPos(item.uid), 3)
			doTransformItem(item.uid, item.itemid+1)
				local function closeHole()
				doTransformItem(getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).uid, item.itemid)
				end
			addEvent(closeHole, intervalToRegrowBushAndStones * 1000)
		end
	
	elseif skill == "fly" then
		if isPlayer(cid) then
			-- Thalles Vitor - Guardian --
				if getGuardianUserData(cid) ~= nil then
					doRemoveCreature(getGuardianUserData(cid))
				end
			--

			local pokemon = flys[getPokemonName(getCreatureSummons(cid)[1])]
			doPlayerSendTextMessage(cid, 27, "Type \"up\" or \"h1\" to fly higher and \"down\" or \"h2\" to fly lower.")
			doSetCreatureOutfit(cid, {lookType = pokemon[1] + 351}, -1)
			doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "hp", getCreatureHealth(getCreatureSummons(cid)[1]) / getCreatureMaxHealth(getCreatureSummons(cid)[1]))
			doRemoveCreature(getCreatureSummons(cid)[1])
			setPlayerStorageValue(cid, 17000, 1)

			doPlayerSendCancel(cid, '12//,hide') --alterado v1.8
			doUpdateMoves(cid)
			
			-- Thalles Vitor
			local pball = getPlayerSlotItem(cid, 8)
			local flyAddon = getItemAttribute(pball.uid, "addonFly") or 0

			if tonumber(flyAddon) > 0 then
				doSetCreatureOutfit(cid, {lookType = flyAddon}, -1)
			end

			-- Thalles Vitor - Fly Module
			doSendPlayerExtendedOpcode(cid, 244, "open".."@")
		end
	return true

	elseif skill == "ride" then
		if isPlayer(cid) then
			-- Thalles Vitor - Guardian --
				if getGuardianUserData(cid) ~= nil then
					doRemoveCreature(getGuardianUserData(cid))
				end
			--

			local pokemon = rides[getPokemonName(getCreatureSummons(cid)[1])]
			
			if pokemon and pokemon[1] then
				doSetCreatureOutfit(cid, {lookType = pokemon[1] + 351}, -1)
			end
			
			doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "hp", getCreatureHealth(getCreatureSummons(cid)[1]) / getCreatureMaxHealth(getCreatureSummons(cid)[1]))
			doRemoveCreature(getCreatureSummons(cid)[1])
			setPlayerStorageValue(cid, 17001, 1)

			doPlayerSendCancel(cid, '12//,hide') --alterado v1.8
			doUpdateMoves(cid)

			-- Thalles Vitor
			local pball = getPlayerSlotItem(cid, 8)
			local rideAddon = getItemAttribute(pball.uid, "addonRide") or 0
			if tonumber(rideAddon) > 0 then
				doSetCreatureOutfit(cid, {lookType = rideAddon}, -1)
			end
		end

	return true
	end

	if getOwnerPos(sid).x ~= getThingPos(getCreatureMaster(sid)).x or getOwnerPos(sid).y ~= getThingPos(getCreatureMaster(sid)).y or isCreature(getCreatureTarget(getCreatureMaster(sid))) then
		--[[ doRegainSpeed(sid) ]]
		markPos(sid, {x=1,y=1,z=7})
	return true
	end

	addEvent(recheck, 120, sid)
end

function goThere(sid, thepos, skill, target, rept)
	if not isCreature(sid) then return true end
	if getCreatureNoMove(sid) or isSleeping(sid) or isParalyze(sid) then return true end            --alterado v2.6
	if thepos.x ~= getMarkedPos(sid).x or thepos.y ~= getMarkedPos(sid).y then return true end
	if isCreature(getCreatureTarget(getCreatureMaster(sid))) and target == false or (rept and rept <= 0) then
		--[[ doRegainSpeed(sid) ]]
		markPos(sid, {x=1,y=1,z=7})
	return true
	end	

if (skill == "ride" or skill == "fly") and getDistanceBetween(getThingPos(sid), getMarkedPos(sid)) <= 1 then

	local currentPos = getThingPos(getCreatureMaster(sid))
	local summonPos = getThingPos(sid)
	local masterPos = getCreatureLastPosition(sid)

	if (getThingPos(sid).x == getThingPos(getCreatureMaster(sid)).x and getThingPos(sid).y == getThingPos(getCreatureMaster(sid)).y) or (currentPos.x == masterPos.x and currentPos.y == masterPos.y) then
	recheck(sid, skill, thepos)
	return true
	end

	if currentPos.x == thepos.x and currentPos.y == thepos.y then
		if getDirectionTo(getThingPos(sid), getThingPos(getCreatureMaster(sid))) <= 3 then
			--[[ doRegainSpeed(sid) ]]
			local ndelay = getNextStepDelay(sid, 0)
			doTeleportThing(sid, thepos, true)
			doChangeSpeed(sid, -getCreatureSpeed(sid))
			markPos(sid, getThingPos(getCreatureMaster(sid)))
			addEvent(goThere, ndelay, sid, getMarkedPos(sid), skill, target)
		else
			--[[ doChangeSpeed(sid, - getCreatureSpeed(sid)) ]]
			--[[ doRegainSpeed(sid) ]]
			markPos(sid, getThingPos(getCreatureMaster(sid)))
			local x = walkTo(sid, getDirectionTo(getThingPos(sid), getMarkedPos(sid)), getMarkedPos(sid), skill == "ride" or skill == "fly")
			--[[ doChangeSpeed(sid, - getCreatureSpeed(sid)) ]]
			addEvent(goThere, x, sid, getMarkedPos(sid), skill, target)
			end
	return true
	else
		markPos(sid, getThingPos(getCreatureMaster(sid)))
		--[[ doChangeSpeed(sid, - getCreatureSpeed(sid)) ]]
		--[[ doRegainSpeed(sid) ]]
		local ndelay = getNextStepDelay(sid, 0)
			if getDirectionTo(getThingPos(sid), getMarkedPos(sid)) >= 4 then
				local x = walkTo(sid, getDirectionTo(getThingPos(sid), getMarkedPos(sid)), getMarkedPos(sid), skill == "ride" or skill == "fly")
			else
				doTeleportThing(sid, getPosByDir(getThingPos(sid), getDirectionTo(getThingPos(sid), getMarkedPos(sid))))
			end
		--[[ doChangeSpeed(sid, - getCreatureSpeed(sid)) ]]
		addEvent(goThere, x and x or ndelay, sid, getMarkedPos(sid), skill, target)
	return true
	end

addEvent(recheck, 350, sid, skill, thepos)
return true
end

if getThingPos(sid).x == getMarkedPos(sid).x and getThingPos(sid).y == getMarkedPos(sid).y then
	if isCreature(getCreatureTarget(sid)) then
	doFaceCreature(sid, getThingPos(getCreatureTarget(sid)))
	end
	if skill == "blink" then
	   doChangeSpeed(sid, - getCreatureSpeed(sid))   --edited blink
	end
addEvent(recheck, 350, sid, skill, thepos)
return true
end

if (getOwnerPos(sid).x ~= getThingPos(getCreatureMaster(sid)).x or getOwnerPos(sid).y ~= getThingPos(getCreatureMaster(sid)).y) and isCreature(getCreatureTarget(getCreatureMaster(sid))) == false and skill == "move" then
--[[ doRegainSpeed(sid) ]]
markPos(sid, {x=1,y=1,z=7})
return true
end
--[[ 
doRegainSpeed(sid) ]]

local holeid = thepos
holeid.stackpos = 0
holeid = getTileThingByPos(holeid).itemid

if getDistanceBetween(getThingPos(sid), getMarkedPos(sid)) <= 1 and (not isWalkable(getPosByDir(getThingPos(sid), getDirectionTo(getThingPos(sid), getMarkedPos(sid))), true, false, false, true) or isInArray(specialabilities["digholes"], holeid)) then
	if isGhostPokemon(sid) and getPlayerStorageValue(getCreatureMaster(sid), 990) <= 0 then
		local todir = getDirectionTo(getThingPos(sid), getMarkedPos(sid))
		if todir <= 3 then
			doTeleportThing(sid, getMarkedPos(sid), true)
		else
			local gotopos = getPosByDir(getThingPos(sid), dirpref[math.random(1, 2)][todir][1][math.random(1, 2)])
			doTeleportThing(sid, gotopos, true)
			addEvent(goThere, getNextStepDelay(sid, 0), sid, getMarkedPos(sid), skill, target)
			return true
		end
	end
doFaceCreature(sid, getMarkedPos(sid))
addEvent(recheck, 180, sid, skill, thepos)
doChangeSpeed(sid, - getCreatureSpeed(sid))
return true
end	

local ret = 0
	if getDistanceBetween(getThingPos(sid), getMarkedPos(sid)) <= 1 then
		ret = walkTo(sid, getDirectionTo(getThingPos(sid), getMarkedPos(sid)), getMarkedPos(sid), skill == "ride" or skill == "fly" or isGhostPokemon(sid))
		if not tonumber(ret) then
			doFaceCreature(sid, getMarkedPos(sid))
			addEvent(recheck, 180, sid, skill, thepos)
			doChangeSpeed(sid, - getCreatureSpeed(sid))
		return true
		end
	else
		ret = walkTo(sid, getDirectionTo(getThingPos(sid), getMarkedPos(sid)), getMarkedPos(sid), skill == "ride" or skill == "fly" or not isGhostPokemon(sid))-- and isSightClear(getThingPos(sid), getMarkedPos(sid), false)))
	end

if not tonumber(ret) then
doPlayerSendCancel(getCreatureMaster(sid), "Destination is not reachable.")
markPos(sid, {x=1,y=1,z=7})
return true
end

doChangeSpeed(sid, - getCreatureSpeed(sid))
addEvent(goThere, tonumber(ret), sid, getMarkedPos(sid), skill, target, rept and rept - 1 or 22)
end