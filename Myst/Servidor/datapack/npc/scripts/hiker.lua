local focus = 0
local talk_start = 0
local conv = 0
local target = 0

function onCreatureSay(cid, type, msg)

	local msg = string.lower(msg)

	if focus == cid then
		talk_start = os.clock()
	end

	if msgcontains(msg, 'hi') and focus == 0 and getDistanceToCreature(cid) <= 4 then
		focus = cid
		talk_start = os.clock()
		conv = 0

		if getPlayerStorageValue(cid, 107) >= 1 then
			selfSay('We meet once more, right ' .. getCreatureName(cid) .. '? You must have been hiking everywhere with your new clothes!')
		else
			conv = 1
			selfSay('Greetings brave adventurer! Do you enjoy hiking in the mountains?')
		end
	return true
	end

	if msgcontains(msg, 'yes') and conv == 1 and focus == cid then

		selfSay('Yea, so do I! I can give you some hiker clothes, would you accept it?')
		conv = 2
	return true
	end

	if msgcontains(msg, 'no') and conv == 1 and focus == cid then

		selfSay('Im so sorry if dont agree with me, hiking is so cool!')
		focus = 0
	return true
	end

	if msgcontains(msg, 'yes') and conv == 2 and focus == cid then

		selfSay('Great! Why dont you try it on? They will look awesome on you!')
		focus = 0
		setPlayerStorageValue(cid, 107, 1)
		doPlayerSendOutfitWindow(cid)
	return true
	end

	if msgcontains(msg, 'no') and conv == 2 and focus == cid then

		selfSay('What?! Nobody has ever declined my clothes! Well, come back when you change your mind.')
		focus = 0
	return true
	end

	if msgcontains(msg, 'bye') and focus == cid then
		selfSay('Go for it adventurer!')
		focus = 0
	return true
	end
end

local delay = 40

function onThink()

	if focus == 0 then
		selfTurn(2)
		delay = delay - 0.5
		if delay <= 0 then
			selfSay("I love hiking in the mountains!")
			delay = math.random(45, 80)
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

		if (os.clock() - talk_start) > 30 then
			focus = 0
			selfSay("I love to stare at mountains too.")
		end

		if getDistanceToCreature(focus) > 4 then
			selfSay("Keep hiking young traveler!")
			focus = 0
		return true
		end

		local dir = doRedirectDirection(getDirectionTo(npcpos, focpos))	
		selfTurn(dir)
	end
return true
end