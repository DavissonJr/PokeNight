local focus = 0
local talk_start = 0
local price = 0
local conv = 0

function msgcontains(txt, str)
return (string.find(txt, str) and not string.find(txt, '(%w+)' .. str) and not string.find(txt, str .. '(%w+)'))
end

function onCreatureSay(cid, type, msg)
	local msg = string.lower(msg)

	if focus == cid then
		talk_start = os.clock()
	end

	if msgcontains(msg, 'bye') and focus == cid then
		selfSay('Have a nice gambling!')
		focus = 0
	return true
	end

	if msgcontains(msg, 'no') and focus == cid and conv == 0 then
		selfSay('Ok then, feel free to come back whenever you want to.')
		focus = 0
	return true
	end

	if msgcontains(msg, 'hi') and focus == 0 and getDistanceToCreature(cid) <= 3 then
		selfSay("Hello! You are at the Celadon's Gamer Corner. To gamble here, you need cassino coins. Do you want to buy some?")
		focus = cid
		talk_start = os.clock()
		conv = 0
	return true
	end

	if ((msgcontains(msg, 'yes') and conv == 0) or msgcontains(msg, 'coins')) and focus == cid and conv ~= 1 then
		selfSay('Tell me, how many coins do you wish to buy?')
		conv = 1
	return true
	end

	if tonumber(msg) ~= nil and tonumber(msg) >= 1 and tonumber(msg) <= 500 and focus == cid then

		if getPlayerStorageValue(cid, 23254) >= 1000 then
			selfSay("It seems that you already have a lot of coins! You can't buy more coins if you already have more than 1000.")
		return true
		end

		if price / 10 == tonumber(msg) then
		return true
		end

		price = tonumber(msg) * 10
		selfSay(""..msg.." coins are going to cost "..price.." dollars, can you afford it?")
		conv = 3
	return true
	end

	if tonumber(msg) ~= nil and (tonumber(msg) < 1 or tonumber(msg) > 500) and focus == cid then
		selfSay("I can sell only sell amounts between 1 and 500 of coins at once!")
		conv = 2
	return true
	end

	if msgcontains(msg, 'yes') and conv == 3 and focus == cid then

		if getPlayerStorageValue(cid, 23254) == -1 then
			setPlayerStorageValue(cid, 23254, 0)
		end

		if doPlayerRemoveMoney(cid, price * 100) then
                        local amount = price / 10
                        setPlayerStorageValue(cid, 23254, getPlayerStorageValue(cid, 23254) + amount)
                        selfSay("Here you are! You bought "..amount.." cassino coins, have a nice gambling!")
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You bought "..amount.." cassino coins. Now you have a total of "..getPlayerStorageValue(cid, 23254).." cassino coins.")
                else 
                        selfSay("Sorry, buy you don't have enough money to pay for it!")
                end

	conv = 2
	return true
	end

	if msgcontains(msg, 'no') and conv == 3 and focus == cid then

        	selfSay("So, would you like to buy any coins?")

	conv = 0
	return true
	end

end
 
local intervalmin = 38
local intervalmax = 70
local delay = 25
local number = 1
local messages = {"Come here to buy cassino coins! Check our prices!",
		  "Looking for coins? You can buy them here!",
		  "Check out our prices! Start gambling today!",
		  "Did you know you can exchange coins for wonderful prizes?",
		 }

function onThink()

	if focus == 0 then
		selfTurn(1)
			delay = delay - 0.5
			if delay <= 0 then
				selfSay(messages[number])
				number = number + 1
					if number > #messages then
						number = 1
					end
				delay = math.random(intervalmin, intervalmax)
			end
		return true
	else

	if not isCreature(focus) then
		focus = 0
	return true
	end

		local npcpos = getThingPos(getThis())
		local focpos = getThingPos(focus)

		if npcpos.z ~= focpos.z then
			focus = 0
		return true
		end

		if getDistanceToCreature(focus) > 3 then
			selfSay('Come back whenever you want to buy more coins!')
			focus = 0
		return true
		end
		
		local dir = doDirectPos(npcpos, focpos)	
		selfTurn(dir)
	end

	if os.clock() - talk_start > 59 then
		selfSay('We can talk later, when you are decided about what to buy.')
		focus = 0
	end


return true
end