local function getPokemonNameByMove(name, number, move)
	local x = movestable[name]
		if not x then return "" end
	local y = {}

	if number == 1 then
		y = x.move1
	elseif number == 2 and x.move2 then
		y = x.move2
	elseif number == 3 and x.move3 then
		y = x.move3
	elseif number == 4 and x.move4 then
		y = x.move4
	elseif number == 5 and x.move5 then
		y = x.move5
	elseif number == 6 and x.move6 then
		y = x.move6
	elseif number == 7 and x.move7 then
		y = x.move7
	elseif number == 8 and x.move8 then
		y = x.move8
	elseif number == 9 and x.move9 then
		y = x.move9
	elseif number == 10 and x.move10 then
		y = x.move10
	elseif number == 11 and x.move11 then
		y = x.move11
	elseif number == 12 and x.move12 then
		y = x.move12
	elseif number == 13 and x.move13 then
		y = x.move13
	elseif number == 14 and x.move14 then
		y = x.move14
	elseif number == 15 and x.move15 then
		y = x.move15
	end

	if move == y.name then
	return name
	end
return ""
end

function onSay(cid, words, param)

local this = param
local capitalletter = string.sub(this, 1, 1)
	capitalletter = string.upper(capitalletter)
this = capitalletter..""..string.sub(this, 2, string.len(this))..""

	if not movesinfo[this] then
	doPlayerSendCancel(cid, "A move with the name "..this.." doesn't exist.")
	return true end

local str = "Pokemons with the move "..this..": "
local has = 0

for a = 1, #oldpokedex do
	for b = 1, 15 do
	local c = getPokemonNameByMove(oldpokedex[a][1], b, this)
		if c ~= "" then
		str = str..""..c..", "
		has = has + 1
		end
	end
end

if has == 0 then
	doPlayerSendCancel(cid, "No pokemons with the move "..this.." were found.")
return true
end

str = string.sub(str, 1, string.len(str) - 2).."."
doPlayerSendCancel(cid, str)
	
		

return true
end