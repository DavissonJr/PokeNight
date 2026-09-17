local focus = 0
local max_distance = 8
local talk_start = 0
local conv = 0
local fighting = false
local challenger = 0
local afk_limit_time = 30	-- seconds
local afk_time = 0		-- don't change
local battle_turn = 1		-- don't change
local challenger_turn = 0	-- don't change
local masterpos = {}
local time_to_fight_again = 15	-- seconds, not ms (so 30 * 60 means 30 minutes)

local can_walk = true		-- true to make this npc walks randomly
local max_distance = 5		-- maximum distance this npc can get far (sqms)
local walk_delay = 7		-- every seconds make this npc walk

local cooldown_table = {}

local min_pokemons_to_battle = 1-- change to whatever you want
local number_of_pokemons = 0	-- don't change

local prizes = {
[1] = {{itemid = 2393, count = 30}, {itemid = 2392, count = 20}},
[2] = {{itemid = 2393, count = 40}, {itemid = 2392, count = 30}},
[3] = {{itemid = 2393, count = 50}, {itemid = 2392, count = 40}},
[4] = {{itemid = 2393, count = 60}, {itemid = 2392, count = 50}},
[5] = {{itemid = 2393, count = 70}, {itemid = 2392, count = 60}},
[6] = {{itemid = 2393, count = 80}, {itemid = 2392, count = 70}}}

local pokemons = {
{name = "Cloyster", optionalLevel = 50, sex = SEX_MALE, nick = "Crusher", ball = "super"},
{name = "Lapras", optionalLevel = 50, sex = SEX_FEMALE, nick = "Laura", ball = "normal"},
{name = "Electabuzz", optionalLevel = 50, sex = SEX_MALE, nick = "Eletron", ball = "great"},
{name = "Pinsir", optionalLevel = 50, sex = SEX_MALE, nick = "Headcutter", ball = "normal"},
{name = "Dragonair", optionalLevel = 50, sex = SEX_FEMALE, nick = "Dragonix", ball = "ultra"},
}


local function doSummonGymPokemon(npc)
	local this = npc
	if not isCreature(this) then return true end
	if #getCreatureSummons(this) >= 1 or focus == 0 then return true end
	local it = pokemons[battle_turn]
	doSummonMonster(this, it.name)
	local summon = getCreatureSummons(this)[1]
	local balleffect = pokeballs["normal"].effect
		if it.ball and pokeballs[it.ball] then
			balleffect = pokeballs[it.ball].effect
		end
	doSendMagicEffect(getThingPos(summon), balleffect)
	setPlayerStorageValue(summon, 10000, balleffect)
	setPlayerStorageValue(summon, 10001, gobackmsgs[math.random(#gobackmsgs)].back:gsub("doka", it.nick ~= "" and it.nick or it.name))
	setPlayerStorageValue(summon, 1007, it.nick ~= "" and it.nick or it.name)
	doSetMonsterGym(summon, focus)
	local name = it.nick ~= "" and it.nick or getCreatureName(this).."s "..it.name
	addEvent(adjustWildPoke, 15, summon, it.optionalLevel)
	doCreatureSay(this, gobackmsgs[math.random(#gobackmsgs)].go:gsub("doka", getPlayerStorageValue(summon, 1007)), 1)
	fighting = true
	battle_turn = battle_turn + 1
end

local function doWinDuel(cid, npc)
	if not isCreature(cid) then return true end
	local this = npc
	local x = prizes[number_of_pokemons]
	for n = 1, #x do
		doPlayerAddItem(cid, x[n].itemid, x[n].count)
	end
	doCreatureSay(npc, "Congratulations! You won, here is your prize.", 1)
	cooldown_table[getCreatureName(cid)] = os.clock() + time_to_fight_again
return true
end

function onCreatureSay(cid, type, msg)

	local msg = string.lower(msg)

	if focus == cid then
		talk_start = os.clock()
	end

	if msgcontains(msg, 'hi') and focus == 0 and getDistanceToCreature(cid) <= 4 then

		if cooldown_table[getCreatureName(cid)] and cooldown_table[getCreatureName(cid)] - os.clock() > 0 then
			selfSay("Hello "..getCreatureName(cid)..", I really enjoyed our last battle!")
			conv = 10
		else
			selfSay("Hello "..getCreatureName(cid)..", are you up to a duel? I can give prizes if you win!")
			conv = 1
		end

		focus = cid
		talk_start = os.clock()
	return true
	end

	if (isDuelMsg(msg) or isConfirmMsg(msg)) and (conv == 1 or conv == 10) and focus == cid then

		if conv == 10 then
			selfSay("We have just battled! Please wait for me to recover from out last battle!")
			focus = 0
		return true
		end

		if not hasPokemon(cid) then
			selfSay("You need pokemons to battle!")
		return true
		end

		selfSay("Ok, tell me how many pokemons will fight.")
		conv = 2

	return true
	end

	if conv == 2 and focus == cid then

		if not tonumber(msg) then
			selfSay("Tell me the number of pokemons that will battle.")
			return true
		elseif tonumber(msg) > #pokemons then
			selfSay("I have only "..#pokemons..", so the maximum is "..#pokemons.."!")
			return true
		elseif tonumber(msg) < min_pokemons_to_battle or tonumber(msg) < 1 then
			selfSay("It has to be more than "..min_pokemons_to_battle..".")
			return true
		else
			number_of_pokemons = tonumber(msg)
			selfSay("Ok, the first that defeats "..number_of_pokemons.." wins, let's start!")
			challenger = focus
			setPlayerStorageValue(cid, 990, 1)
			addEvent(doSummonGymPokemon, 850, getThis())
			conv = 3
			return true
		end
			

	return true
	end

	if isNegMsg(msg) and conv == 1 and focus == cid then

		focus = 0
		selfSay("It is better for you to refuse a battle against me!")

	return true
	end

	if msgcontains(msg, 'bye') and focus == cid then
		selfSay('Bye and do your best trainer!')
		setPlayerStorageValue(focus, 990, -1)
		focus = 0
	return true
	end
end

local afk_warning = false
local change = false
local walkdelay = 0

function onThink()

	if not masterpos.x then
		masterpos = getThingPos(getThis())
	end

	if focus == 0 then
		selfTurn(2)
		fighting = false
		challenger = 0
		change = false
		challenger_turn = 0
		battle_turn = 1
		afk_time = 0
		afk_warning = false

		if #getCreatureSummons(getThis()) >= 1 then
			setPlayerStorageValue(getCreatureSummons(getThis())[1], 1006, 0)
			doCreatureAddHealth(getCreatureSummons(getThis())[1], -getCreatureMaxHealth(getCreatureSummons(getThis())[1]))
		end

		walkdelay = walkdelay - 0.5

		if walkdelay <= 0 then
			walkdelay = walk_delay
			local pos = getThingPos(getThis())
			local npos = {}
			for a = 0, 3 do
				if getDistanceBetween(getPosByDir(pos, a), masterpos) <= max_distance and canWalkOnPos(getPosByDir(pos, a), true, false, true, true, false) then
				table.insert(npos, getPosByDir(pos, a))
				end
			end

			if npos and #npos > 0 then
				doTeleportThing(getThis(), npos[math.random(#npos)])
			end
		end

	return true
	else

	if not isCreature(focus) then
		focus = 0
	return true
	end                                            

	if fighting then

		talk_start = os.clock()

		if not isCreature(getCreatureTarget(getThis())) then
			if #getCreatureSummons(challenger) >= 1 then
			   if getCreatureOutfit(getCreatureSummons(challenger)[1]).lookType ~= 2 then --alterado v1.6
				  selfAttackCreature(getCreatureSummons(challenger)[1])
				  change = true
				  afk_time = 0
	           end
			else
				afk_time = afk_time + 0.5
				if change then
					change = false
					challenger_turn = challenger_turn + 1
				end
			end
		end

		if afk_time > afk_limit_time then
			setPlayerStorageValue(focus, 990, -1)
			focus = 0
			selfSay("I have waited too long, come back when you are ready!")
		return true
		end

		if not afk_warning and afk_time > afk_limit_time / 2 then
			selfSay("Where's your pokemon? Let's fight!")
			afk_warning = true
		end


		if #getCreatureSummons(getThis()) == 0 then
			if battle_turn > number_of_pokemons then
				addEvent(doWinDuel, 1000, focus, getThis())
				setPlayerStorageValue(focus, 990, -1)
				focus = 0
			return true
			end
			addEvent(doSummonGymPokemon, 1000, getThis())
		end

		if not hasPokemon(challenger) or challenger_turn > 6 or challenger_turn >= number_of_pokemons then
			selfSay("You lost our duel! Maybe some other time you'll defeat me.")
			setPlayerStorageValue(focus, 990, -1)
			focus = 0
		return true
		end

	end

		local npcpos = getThingPos(getThis())
		local focpos = getThingPos(focus)

		if npcpos.z ~= focpos.z then
			setPlayerStorageValue(focus, 990, -1)
			focus = 0
			selfSay("Bye then.")
		return true
		end

		if (os.clock() - talk_start) > 30 then
			selfSay("Good bye and keep training!")
			setPlayerStorageValue(focus, 990, -1)
			focus = 0
		end

		if getDistanceToCreature(focus) > max_distance then
			setPlayerStorageValue(focus, 990, -1)
			focus = 0
		return true
		end

		local dir = doRedirectDirection(getDirectionTo(npcpos, focpos))	
		selfTurn(dir)
	end
return true
end