local focus = 0
local talk_start = 0
local conv = 0
local target = 0
local following = false
local attacking = false
local talkState = {}
local finalname = ""

function onThingMove(creature, thing, oldpos, oldstackpos)
end

function onCreatureAppear(creature)
end

function onCreatureDisappear(cid, pos)
if focus == cid then
selfSay('Até.')
focus = 0
talk_start = 0
end
end

function onCreatureTurn(creature)
end

function msgcontains(txt, str)
return (string.find(txt, str) and not string.find(txt, '(%w+)' .. str) and not string.find(txt, str .. '(%w+)'))
end

function onCreatureSay(cid, type, msge)
local msg = string.lower(msge)
local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid


	if focus == cid then
		talk_start = os.clock()
	end

local auras = {"red aura", "blue aura", "green aura", "yellow aura", "white aura", "gray aura", "cyan aura", "purple aura", "orange aura"}


if (msgcontains(msg, 'hi') and (focus == 0) and (getDistanceToCreature(cid) <= 4)) then

	focus = cid
	conv = 1
	talk_start = os.clock()
	selfSay("Oi, "..getCreatureName(cid).." Quer {colocar} um apelido do seu pokémon?")

elseif (msgcontains(msg, "no") or msgcontains(msg, "bye")) and focus == cid and conv ~= 3 then

	selfSay("Até.")
	focus = 0

elseif (msgcontains(msg, "colocar") or msgcontains(msg, "yes")) and focus == cid and conv == 1 then

		if getPlayerSlotItem(cid, 8).uid <= 0 then
			selfSay("Você precisa está com o pokémon para fora.")
			focus = 0
		return true
		end

	selfSay("Tire seu pokémon para fora e fale-me o apelido que deseja colocar!")
	conv = 3
	

          
elseif conv == 3 and focus == cid then

	local tablee = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "x", "w", "y", "z", ".", ":", "'", '"', "~", "^", "@", "#", "$", "%", "&", "*", "(", ")", "-", "+", "_", "?", ">", "<", "•", ";", "°", "¹", "²", "³", "£", "¢", "¬", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
	local table = {"'", '"', "!", "ã", "õ", "ç", "´", "`", "á", "à", "ó", "ò", "é", "è", "í", "ì", "ú", "ù", "¹", "²", "³", "£", "¢", "¬", "§", "°", "º", "ª", "•", "|"}

	msg = string.gsub(msg, "[%c%p%s]", "")
	msg = string.gsub(msg, "%s+", "")
	msg = string.gsub(msg, "[^%S\n]+", "")
	msg = string.gsub(msg, " ", "")
	for a = 1, #table do
		if string.find(msg, table[a]) then
			selfSay("O apelido não pode ter mais de 12 letras, espaço, nem caracteres especiais ou números. Tente outro!.")
		return true
		end
	end

	if string.len(msg) <= 1 or string.len(msg) >= 12 or msg == "" then
		selfSay("O apelido não pode ter mais de 12 letras, espaço, nem caracteres especiais ou números. Tente outro!.")
	return true
	end

	local pokename = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke")

	if msg == "" or #msg <= 0 then
		selfSay("O apelido não pode ter mais de 12 letras, espaço, nem caracteres especiais ou números. Tente outro!.")
		return true
	end

	selfSay("Quer mesmo por \""..msg.."\" como o apelido do seu pokémon? Vai custar 5000hds.")
	conv = 5
	finalname = msg

elseif msgcontains(msg, "yes") and focus == cid and conv == 5 then

	if getPlayerSlotItem(cid, 8).uid <= 0 then
		selfSay("Onde está o seu Pokémon ?! Você tem que mantê-lo no slot!")
		focus = 0
	return true
	end

	if doPlayerRemoveMoney(cid, 50000000) == false then
		selfSay("Você não tem dinheiro.")
		focus = 0
		conv = 0
	return true
	end

	local nick = ""..finalname..""
	local description = "Contains a "..getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke").."."
	selfSay("Seu pokémon recebeu um apelido!")
	doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "nick", nick)
	local newdes = description.."\nIt's nickname is: "..finalname.."."
	doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "description", newdes)
	local hp = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "happy")
	doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "happy", hp + 25)
	if #getCreatureSummons(cid) >= 1 then
		adjustStatus(getCreatureSummons(cid)[1], getPlayerSlotItem(cid, 8).uid)
	end
	focus = 0
	conv = 0
	end
end
 
local intervalmin = 38
local intervalmax = 70
local delay = 25
local number = 1
local messages = {"Quer dar alguns apelidos ao seu pokémon? Fale comigo!",
		  "Você sabia que seu Pokémon fica um pouco mais feliz quando você lhe dá um apelido?",
		  "Todo Pokémon quer ter um apelido! Venha falar comigo!",
		  "Pokémons adoram apelidos, você deveria dar um ao seu.",
		 }

function onThink()

	if focus == 0 then
		selfTurn(1)
			delay = delay - 0.5
			if delay <= 0 then
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

		if (os.clock() - talk_start) > 45 then
			focus = 0
			selfSay("Até.")
		end

		if getDistanceToCreature(focus) > 3 then
			selfSay("Até.")
			focus = 0
		return true
		end

		local dir = doDirectPos(npcpos, focpos)	
		selfTurn(dir)
	end


return true
end