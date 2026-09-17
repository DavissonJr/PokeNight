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
----------------------------------
local sto = 759848
----------------------------------

local function doSummonGymPokemon(npc)
	local this = npc
	if #getCreatureSummons(this) >= 1 or focus == 0 then return true end
	local it = theNpc.pokemon[1]
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
	addEvent(adjustWildPoke, 15, summon, it.optionalLevel)
	local name = it.nick ~= "" and it.nick or getCreatureName(this).."s "..it.name
	doCreatureSay(this, gobackmsgs[math.random(#gobackmsgs)].go:gsub("doka", getPlayerStorageValue(summon, 1007)), 1)
	fighting = true
	battle_turn = battle_turn+1
end

local function doWinDuel(cid, npc)
	if not isCreature(cid) then return true end
	local this = npc
	if getCreatureName(this) == "Chuck Norris" then
	    doCreatureSay(npc, "Chuck Norris never loses! Just my pokemon fails!", 1)
	else
	    doCreatureSay(npc, "You won the duel! Congratulations, you can challenger the next opponent now.", 1)
    end
	setPlayerStorageValue(cid, sto, getPlayerStorageValue(cid, sto)+1)
end

function onCreatureSay(cid, type, msg)

--------------------------------------
local Npcs = {
["Hang Wufei"] = {
pokemon = {
         {name = "Tyrogue", optionalLevel = 65, sex = SEX_MALE, nick = "", ball = "normal"},
},
storage = 0,
msg = "Hello "..getCreatureName(cid)..", my name is ".. getNpcName().." i'm a member of the fighter tower. How may I help you?"
},
["Chun Li"] = {
pokemon = {
         {name = "Primeape", optionalLevel = 85, sex = SEX_FEMALE, nick = "", ball = "great"},
},
storage = 1,
msg = "Hello "..getCreatureName(cid)..", my name is ".. getNpcName().." i'm a member of the fighter tower. How may I help you?"
},
["Van Damme"] = {
pokemon = {
         {name = "Hitmonchan", optionalLevel = 100, sex = SEX_MALE, nick = "", ball = "super"},
},
storage = 2,
msg = "Hello "..getCreatureName(cid)..", my name is ".. getNpcName().." i'm a member of the fighter tower. How may I help you?"
},
["Mai Shiranui"] = {
pokemon = {
         {name = "Machoke", optionalLevel = 105, sex = SEX_FEMALE, nick = "", ball = "normal"},
},
storage = 3,
msg = "Hello "..getCreatureName(cid)..", my name is ".. getNpcName().." i'm a member of the fighter tower. How may I help you?"
},
["Jet Li"] = {
pokemon = {
         {name = "Hitmontop", optionalLevel = 120, sex = SEX_MALE, nick = "", ball = "great"},
},
storage = 4,
msg = "Hello "..getCreatureName(cid)..", my name is ".. getNpcName().." i'm a member of the fighter tower. How may I help you?"
},
["Jackie Chan"] = {
pokemon = {
         {name = "Hitmonlee", optionalLevel = 130, sex = SEX_MALE, nick = "", ball = "super"},
},
storage = 5,
msg = "Hello "..getCreatureName(cid)..", my name is ".. getNpcName().." i'm a member of the fighter tower. How may I help you?"
},
["Chuck Norris"] = {
pokemon = {
         {name = "Machamp", optionalLevel = 600, sex = SEX_MALE, nick = "", ball = "ultra"},
},
storage = 6,
msg =  "Hello "..getCreatureName(cid)..", my name is ".. getNpcName().." i'm the master of the fighter tower. Nobody can defeat me! How may I help you?"
},
}

theNpc = Npcs[getNpcName()]
local msg = string.lower(msg)
------------------------------------------

	if focus == cid then
		talk_start = os.clock()
	end

	if msgcontains(msg, 'hi') and focus == 0 and getDistanceToCreature(cid) <= 4 then
		if getPlayerStorageValue(cid, sto) == -1 then setPlayerStorageValue(cid, sto, 0) end
        
        if getPlayerStorageValue(cid, sto) ~= theNpc.storage then
           selfSay("What? I don't have nothing to talk with you! Good bye!")
           focus = 0
           return true
        end 
        
        focus = cid
		talk_start = os.clock()
		conv = 1
		selfSay(theNpc.msg)
	return true
	end

	if isDuelMsg(msg) and conv == 1 and focus == cid then

		if not hasPokemon(cid) then
			selfSay("To battle agains't me you need pokemons.")
		return true
		end

		selfSay("You are challenging me to a battle. It will be a "..#theNpc.pokemon.." pokemon limit battle, let's start?")
		conv = 2

	return true
	end

	if isConfirmMsg(msg) and conv == 2 and focus == cid then

		challenger = focus
		setPlayerStorageValue(cid, 990, 1)
		selfSay("Yea, let's fight!")
		talk_start = os.clock()
		addEvent(doSummonGymPokemon, 850, getThis())
		conv = 3

	return true
	end

	if isNegMsg(msg) and conv == 2 and focus == cid then

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

function onThink()

	if focus == 0 then
		selfTurn(2)
		fighting = false
		challenger = 0
		challenger_turn = 0
		battle_turn = 1
		afk_time = 0
		afk_warning = false

		if #getCreatureSummons(getThis()) >= 1 then
			setPlayerStorageValue(getCreatureSummons(getThis())[1], 1006, 0)
			doCreatureAddHealth(getCreatureSummons(getThis())[1], -getCreatureMaxHealth(getCreatureSummons(getThis())[1]))
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
				  challenger_turn = challenger_turn + 1
				  afk_time = 0
	            end
			else
				afk_time = afk_time + 0.5
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
			if battle_turn > #theNpc.pokemon then
				addEvent(doWinDuel, 1000, focus, getThis())
				setPlayerStorageValue(focus, 990, -1)
				focus = 0
			return true
			end
			addEvent(doSummonGymPokemon, 1000, getThis())
		end

		if not hasPokemon(challenger) or challenger_turn >= 7 or challenger_turn > #theNpc.pokemon then
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