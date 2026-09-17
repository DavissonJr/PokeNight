local function sendBrokesMsg2(cid, name, str)                       --alterado v1.9 \/ TUDO!!
if not isCreature(cid) then return false end
local storage = getPlayerStorageValue(cid, str)
if storage == -1 then
   return sendMsgToPlayer(cid, 27, "You don't have wast any ball in this pokemon yet!")
end

local t = "normal = (.-), great = (.-), super = (.-), ultra = (.-), saffari = (.-);"
local msg = {}
table.insert(msg, "You have wasted: ")

for n, g, s, u in storage:gmatch(t) do
    if tonumber(n) and tonumber(n) > 0 then 
       table.insert(msg, tostring(n).." Poke ball".. (tonumber(n) > 1 and "s" or "")) 
    end
    if tonumber(g) and tonumber(g) > 0 then 
       table.insert(msg, (#msg > 1 and ", " or "").. tostring(g).." Great ball".. (tonumber(g) > 1 and "s" or "")) 
    end
    if tonumber(s) and tonumber(s) > 0 then 
       table.insert(msg, (#msg > 1 and ", " or "").. tostring(s).." Super ball".. (tonumber(s) > 1 and "s" or "")) 
    end
    if tonumber(u) and tonumber(u) > 0 then 
       table.insert(msg, (#msg > 1 and ", " or "").. tostring(u).." Ultra ball".. (tonumber(u) > 1 and "s" or "")) 
    end
    if tonumber(s2) and tonumber(s2) > 0 then 
       table.insert(msg, (#msg > 1 and ", " or "").. tostring(s2).." Saffari ball".. (tonumber(s2) > 1 and "s" or "")) 
    end
end
if #msg == 1 then
   return doPlayerSendTextMessage(cid, 27, "You haven't wasted any ball thying to catch a "..name..".")
end
if string.sub(msg[#msg], 1, 1) == "," then
   msg[#msg] = " and".. string.sub(msg[#msg], 2, #msg[#msg])
end
table.insert(msg, " trying to catch a "..name..".")
return sendMsgToPlayer(cid, 27, table.concat(msg))
end

function onSay(cid, words, param)

if(param == '') then
    doPlayerSendTextMessage(cid, 27, "Enter with a pokemon name...")
    return true
end

if newpokedex[doCorrectPokemonName(param)] then
   local storage = newpokedex[doCorrectPokemonName(param)].stoCatch
   local name = doCorrectPokemonName(param)
   sendBrokesMsg2(cid, name, storage)
else
   doPlayerSendTextMessage(cid, 27, "This isn't a pokemon...")
end
return true
end