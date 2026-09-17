













function onSay(cid, words, param)

local pp = tonumber(param)

if not pp then pp = 75 end

local mxml = io.open("data/monster/monsters.xml", "a+")
local rxml = mxml:read("*all")
mxml:close()

for a = 1, 251 do
	local pokemon = oldpokedex[a][1]
	if string.find(rxml, '<monster name="'..pokemon..' ') then
	for b = 1, pp do
		for c = 1, pp do
			local d, e = rxml:find('<monster name="'..pokemon..' '..b..' '..c..'"')
				if d and e then
					local f = io.open("data/monster/pokes/"..pokemon..".xml", "a+")
					local g = f:read("*all")
					f:close()
					g = string.gsub(g, 'head="(.-)" body="(.-)"', 'head="'..b..'" body="'..c..'"')
					local h = io.open("data/monster/pokes/"..pokemon.." "..b.." "..c..".xml", "w")
					h:write(g)
					h:close()
				end
		end
	end
	end
end

print("Done, now executing ccxml")

doCreatureExecuteTalkAction(cid, "/ccxml", true)

return true
end















