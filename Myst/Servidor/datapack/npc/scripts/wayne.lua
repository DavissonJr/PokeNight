function onThingMove(creature, thing, oldpos, oldstackpos)
end

function onCreatureAppear(creature)
end

function onCreatureDisappear(cid, pos)
end

function onCreatureTurn(creature)
end

function msgcontains(txt, str)
return (string.find(txt, str) and not string.find(txt, '(%w+)' .. str) and not string.find(txt, str .. '(%w+)'))
end

function onCreatureSay(cid, type, msg)
	if not isPlayer(cid) then return true end

	if getDistanceToCreature(cid) <= 3 then
		msg = string.lower(msg)
		if msgcontains(msg, "hi") then
			onSendTaskWindow(cid, "monsters")
		end
	end
	return true
end