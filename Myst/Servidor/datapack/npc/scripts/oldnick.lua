local focus = 0
local talk_start = 0
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
selfSay('Good bye sir!')
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

if getPlayerStorageValue(cid, ginasios["Brock"].storage) >= 1 then
return true
end

if (msgcontains(msg, 'hi') and (focus == 0) and (focus ~= cid) and (getDistanceToCreature(cid) <= 4)) then
	--if not isPremium(cid) then
	--selfSay("Hello, "..getCreatureName(cid).."! I'm sorry, but I can only give nicknames to pokemons for premium members!")
	--return true
	--end
focus = cid
talkState[talkUser] = 1
selfSay("Hello, "..getCreatureName(cid).."! I can give your pokemon a nickname, would you like it?")
elseif (msgcontains(msg, "no") or msgcontains(msg, "bye")) and focus == cid and talkState[talkUser] ~= 3 then
selfSay("No problem then, sir. Come back when you feel like it!")
focus = 0
elseif msgcontains(msg, "yes") and focus == cid and talkState[talkUser] == 1 then
		if not isInArray({2208, 2209, 2210, 2211, 2212, 2213, 2214, 2215, 2216,
2217, 2218, 2219, 2220, 2221, 2222, 2223, 2224, 2227}, getPlayerSlotItem(cid, 8).itemid) then
		selfSay("Sorry, you don't have a pokemon in the main slot!")
		focus = 0
		return true
		end
selfSay("What nickname would you like me to give to your pokemon?")
talkState[talkUser] = 3
elseif talkState[talkUser] == 3 and focus == cid then

local tablee = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "x", "w", "y", "z", ".", ":", "'", '"', "~", "^", "@", "#", "$", "%", "&", "*", "(", ")", "-", "+", "_", "?", ">", "<", "•", ";", "°", "¹", "²", "³", "£", "¢", "¬", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
local table = {"'", '"', "!", "ã", "õ", "ç", "´", "`", "á", "à", "ó", "ò", "é", "è", "í", "ì", "ú", "ù", "¹", "²", "³", "£", "¢", "¬", "§", "°", "º", "ª", "•", "|"}
	for a = 1, #table do
	if string.find(msg, table[a]) then
	selfSay("Sorry, the nick has invalid symbols.")
	return true
	end
	end
	if string.len(msg) <= 1 or string.len(msg) >= 14 then
	selfSay("Sorry, that nick is too long or too short!")
	return true
	end
local pokename = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke")
selfSay("Are you sure that you want to change your's "..pokename.." to \""..msge.."\"? This is going to cost you 10 hundred dollars.")
talkState[talkUser] = 5
finalname = msge
elseif msgcontains(msg, "yes") and focus == cid and talkState[talkUser] == 5 then
	if doPlayerRemoveMoney(cid, 100000) == false then
	selfSay("You don't have enough money to afford this service, come back later.")
	focus = 0
	talkState[talkUser] = 0
	return true
	end
if getPlayerStorageValue(cid, 9912) == -1 then
setPlayerStorageValue(cid, 9912, 0)
end
local newarch = ""..getCreatureName(cid)..""..getPlayerStorageValue(cid, 9912)..""
doCopyPokemon(getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke"), newarch)
doEditName("C:/Users/WAGNER DOS SANTOS/Desktop/ot/Pokemon Dash/datapackpack/monster/pokes/nicked/"..newarch..".xml", finalname, getItemAttribute(getPlayerSlotItem(cid, 8).uid, "poke"))
local newfile = ""..newarch..".xml"
doAddMonsterInXML(newarch, newfile)
doReloadInfo(RELOAD_MONSTERS)
selfSay("Done! Your pokemon now has a new name, try it!")
doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "nick", newarch)
local newdes = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "fakedesc").."\nIt's nickname is: "..finalname.."."
doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "description", newdes)
doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "nname", finalname)
setPlayerStorageValue(cid, 9912, getPlayerStorageValue(cid, 9912)+1)
focus = 0
talkState[talkUser] = 0
end
end
 
function onThink()
if focus ~= 0 then
a, b, c = selfGetPosition()
if c ~= getThingPos(focus).z then
focus = 0
end
end

if focus ~= 0 then
if getDistanceToCreature(focus) > 6 then
focus = 0
end
end

return true
end