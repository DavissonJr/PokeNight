function onSay(cid, words, param)

local a = io.open("data/creatures.xml", "w")
local ex = io.open("data/extensions.xml", "w")
local final = '<?xml version="1.0" encoding="UTF-8"?>\n  <creatures>'
local efinal = '    	<tileset name="POKEMONS">\n		<creatures>'
local k = io.open("data/monster/monsters.xml", "a+")
local q = k:read("*all")
k:close()

for times = 1, 500 do

local o1, o2 = q:find('<monster name="(.-)"')
	if o1 and o2 then
local pokemon = string.sub(q, o1 + 15, o2 - 1)


local outfit = ""

	for b = 1, #oldpokedex do
		local poke = oldpokedex[b][1]
		if string.find(pokemon, poke..' ') or string.find(pokemon, poke..'"') or poke == pokemon then
		local kk = io.open("data/monster/pokes/"..poke..".xml", "a+")
			if kk then
				local qq = kk:read("*all")
				kk:close()
				local oo1, oo2 = qq:find('look type="(.-)"')
					if oo1 and oo2 then
						outfit = string.sub(qq, oo1 + 11, oo2 - 1)
					end
			end
		end
	end

final = final..'\n     <creature name="'..pokemon..'" type="monster" looktype="'..outfit..'"/>'
efinal = efinal..'\n             <creature name="'..pokemon..'"/>'
q = string.gsub(q, '<monster name="'..pokemon..'"', "<DONE>")
	end
end


efinal = efinal..'\n		</creatures>\n	</tileset>'
final = final..'\n    </creatures>'
a:write(final)
a:close()
ex:write(efinal)
ex:close()

print("creatures.xml (data/creatures.xml) done.")	

return 1
end