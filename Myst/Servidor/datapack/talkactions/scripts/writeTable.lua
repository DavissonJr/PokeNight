function onSay(cid, words, param, channel)

local str = "pokes = {"
local file = io.open('data/writeTable.txt', 'w')
if (not file) then
   sendMsgToPlayer(cid, 20, "File: data/writeTable.txt, not found...")
   return true
end
for i, table in ipairs(oldpokedex) do
    local t = pokes[table[1]]
    if not t or not t.offense then
       return sendMsgToPlayer(cid, 20, "Error has occored... Poke: "..table[1].." isn't in the table pokes or don't have the 'attribute' offense!")
    end
    str = str.. '\n\n["'..table[1]..'"] = {offense = '..t.offense..', defense = '..t.defense..', specialattack = '..t.specialattack..', vitality = '..t.vitality..', agility = '..t.agility..', exp = '..t.exp..', level = '..t.level..', wildLvl = '..t.level..', type = "'..t.type..'", type2 = "'..t.type2..'"},'
end
str = str.."\n}"
file:write(str)
file:close()
sendMsgToPlayer(cid, 20, "Table added in file 'data/writeTable.txt'...")
return true
end