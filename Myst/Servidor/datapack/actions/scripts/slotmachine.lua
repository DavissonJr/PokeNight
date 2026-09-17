local coins = 23254
local cost = 10
local playing = createConditionObject(CONDITION_INFIGHT)
setConditionParam(playing, CONDITION_PARAM_TICKS, 3000)


local function checkPrize(array)
local prize = 0
if array[1] == array[2] and array[2] == array[3] and array[1] == 9 then --3n iguais = 9
return "jackpot"
end
if array[1] == array[2] and array[1] == array[3] then -- 3n iguais
return 20 * array[1]
end
if array[1] == array[2] or array[1] == array[3] then
return 8 * array[1]
end
if array[2] == array[3] then
return 8 * array[2]
end	
if (array[1] == array[2] - 1 and array[1] == array[3] - 2) or (array[1] == array[2] + 1 and array[1] == array[3] + 2) then
return (array[1] + array[2] + array[3]) * 9
end
return 0
end


    function getJackpotEffect()
        local it = math.random(1,5)
        if it == 1 then
        return 27
        elseif it == 2 then
        return 28
        elseif it == 3 then
        return 29
        elseif it == 4 then
        return 84
        else
        return 85
        end
    end

    function sendJackpotEffect(pos)
        local pos1 = {x = pos.x + 2, y = pos.y, z = pos.z}
        local pos2 = {x = pos.x + 1, y = pos.y + 1, z = pos.z}
        local pos3 = {x = pos.x, y = pos.y + 2, z = pos.z}
        local pos4 = {x = pos.x - 1, y = pos.y + 1, z = pos.z}
        local pos5 = {x = pos.x - 2, y = pos.y, z = pos.z}
        local pos6 = {x = pos.x - 1, y = pos.y - 1, z = pos.z}
        local pos7 = {x = pos.x, y = pos.y - 2, z = pos.z}
        local pos8 = {x = pos.x + 1, y = pos.y - 1, z = pos.z}
        doSendDistanceShoot(pos, pos1, 39)
        doSendDistanceShoot(pos, pos2, 39)
        doSendDistanceShoot(pos, pos3, 39)
        doSendDistanceShoot(pos, pos4, 39)
        doSendDistanceShoot(pos, pos5, 39)
        doSendDistanceShoot(pos, pos6, 39)
        doSendDistanceShoot(pos, pos7, 39)
        doSendDistanceShoot(pos, pos8, 39)
        doSendMagicEffect(pos1, getJackpotEffect())
        doSendMagicEffect(pos2, getJackpotEffect())
        doSendMagicEffect(pos3, getJackpotEffect())
        doSendMagicEffect(pos4, getJackpotEffect())
        doSendMagicEffect(pos5, getJackpotEffect())
        doSendMagicEffect(pos6, getJackpotEffect())
        doSendMagicEffect(pos7, getJackpotEffect())
        doSendMagicEffect(pos8, getJackpotEffect())
    end
        

function onUse(cid, item, frompos, item2, topos)

if getPlayerGroupId(cid) == 11 then
return true
end

if topos.y + 1 ~= getThingPos(cid).y or topos.x ~= getThingPos(cid).x then
local poss = {x = topos.x, y = topos.y + 1, z = topos.z}
if isWalkable(poss, cid, 0, 0) then
doPushCreature(cid, getDirectionTo(getThingPos(cid), poss), 1, 0)
if not (getThingPos(cid).x == topos.x and getThingPos(cid).y == topos.y + 1) then
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please, stay in front of the slot machine to play it.")
return true
end
doCreatureSetLookDir(cid, 0)
else
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please, stay in front of the slot machine to play it.")
return true
end
end
doCreatureSetLookDir(cid, 0)
if getPlayerNoMove(cid) == true then
return true
end
if getPlayerStorageValue(cid, coins) < cost then
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You don't have enough cassino coins to play the slot machine.")
return true
end
local mymoney = getPlayerStorageValue(cid, coins)
setPlayerStorageValue(cid, coins, mymoney - cost)
doPlayerSetNoMove(cid, true)
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You pushed the machine lever (-10 coins), now you have "..mymoney - cost.." coins left.")
local a = item.itemid
doTransformItem(item2.uid, a + 1)
    local function doPullBack(pos)
    doTransformItem(getTileItemById(pos, a + 1).uid, a)
    end
addEvent(doPullBack, 500, topos)

    local function doPlay(cid, pos, first, second, third)

        doAddCondition(cid, playing)

        if first == 0 then
        firstplay = math.random(1, 9)
        doSendAnimatedText(pos, firstplay, 66)
        addEvent(doPlay, 900, cid, pos, firstplay, second, third)
        return true
        end

        if second == 0 then
        secondplay = math.random(1, 9)
        doSendAnimatedText(pos, secondplay, 66)
        addEvent(doPlay, 900, cid, pos, first, secondplay, third)
        return true
        end

        if third == 0 then
        thirdplay = math.random(1, 9)
        doSendAnimatedText(pos, thirdplay, 66)
        addEvent(doPlay, 900, cid, pos, first, second, thirdplay)
        return true
        end

	if checkPrize({first, second, third}) == "jackpot" then

        doSendAnimatedText(pos, "JACKPOT!", 180)
        sendJackpotEffect(getThingPos(cid))
        addEvent(doSendAnimatedText, 600, pos, "JACKPOT!", 66)
        addEvent(sendJackpotEffect, 600, getThingPos(cid))
        addEvent(doSendAnimatedText, 1400, pos, "JACKPOT!", 180)
        addEvent(sendJackpotEffect, 1400, getThingPos(cid))
        addEvent(doSendAnimatedText, 2200, pos, "JACKPOT!", 66)
        addEvent(sendJackpotEffect, 2200, getThingPos(cid))
        local ppos = getThingPos(cid)
        local win = (mymoney - cost) + 1000
        addEvent(doSendAnimatedText, 2500, ppos, "+1000", 35)
        addEvent(setPlayerStorageValue, 2500, cid, coins, win)
        addEvent(doPlayerSendTextMessage, 2500, cid, MESSAGE_STATUS_CONSOLE_BLUE, "You won 1000 cassino coins, now you have "..win.." coins left.")
        addEvent(doPlayerSetNoMove, 2500, cid, false)

	
	elseif checkPrize({first, second, third}) == 0 then

        doSendAnimatedText(pos, "FAIL", 180)
        doPlayerSetNoMove(cid, false)

	elseif checkPrize({first, second, third}) <= 30 then

        doSendAnimatedText(pos, "GOOD", 215)
        local ppos = getThingPos(cid)
	local prize = checkPrize({first, second, third})
        local win = (mymoney - cost) + prize
        addEvent(doSendAnimatedText, 500, ppos, "+"..prize.."", 35)
        addEvent(setPlayerStorageValue, 500, cid, coins, win)
        addEvent(doPlayerSendTextMessage, 500, cid, MESSAGE_STATUS_CONSOLE_BLUE, "You won "..prize.." cassino coins, now you have "..win.." coins left.")
        addEvent(doPlayerSetNoMove, 500, cid, false)

	elseif checkPrize({first, second, third}) <= 65 then

        doSendAnimatedText(pos, "GREAT", 210)
        local ppos = getThingPos(cid)
	local prize = checkPrize({first, second, third})
        local win = (mymoney - cost) + prize
        addEvent(doSendAnimatedText, 500, ppos, "+"..prize.."", 35)
        addEvent(setPlayerStorageValue, 500, cid, coins, win)
        addEvent(doPlayerSendTextMessage, 500, cid, MESSAGE_STATUS_CONSOLE_BLUE, "You won "..prize.." cassino coins, now you have "..win.." coins left.")
        addEvent(doPlayerSetNoMove, 500, cid, false)

	else

        doSendAnimatedText(pos, "EXCELLENT", 35)
        local ppos = getThingPos(cid)
	local prize = checkPrize({first, second, third})
        local win = (mymoney - cost) + prize
        addEvent(doSendAnimatedText, 500, ppos, "+"..prize.."", 35)
        addEvent(setPlayerStorageValue, 500, cid, coins, win)
        addEvent(doPlayerSendTextMessage, 500, cid, MESSAGE_STATUS_CONSOLE_BLUE, "You won "..prize.." cassino coins, now you have "..win.." coins left.")
        addEvent(doPlayerSetNoMove, 500, cid, false)
	end
	return true
	end

doAddCondition(cid, playing)
addEvent(doPlay, 850, cid, topos, 0, 0, 0)
return true
end