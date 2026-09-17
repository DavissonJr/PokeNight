local ranks = {
['torneio'] = {7},

['level'] = {8},

}

function onSay(cid, words, param)

local msg = string.lower(param)

if ranks[msg] ~= nil then

str = getHighscoreString((ranks[msg][1]))

else

str = getHighscoreString((8))

end

doShowTextDialog(cid,7369, str)

return TRUE

end
