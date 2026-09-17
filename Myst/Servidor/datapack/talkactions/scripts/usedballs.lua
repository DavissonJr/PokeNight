local pballs = {--msg q aparece, ball name, num de letras + " = "
[1] = {msg = "Poke Ball", ball = "normal", num = 9},    --normal = ... 9 letras
[2] = {msg = "Great Ball", ball = "great", num = 8},    --great = ... 8 letras
[3] = {msg = "Super Ball", ball = "super", num = 8},
[4] = {msg = "Ultra Ball", ball = "ultra", num = 8},
[5] = {msg = "Saffari Ball", ball = "saffari", num = 10},
}

local function sendBrokesCountMsg(cid, name, str)
if getPlayerStorageValue(cid, str) == -1 then
   doPlayerSendTextMessage(cid, 27, "You haven't wasted any pokeball to try catch a "..name)
   return true
end
local t = string.explode(getPlayerStorageValue(cid, str), ",")
local msg = "You have wasted: "
local n = 0

for a = 1, #t do
    local d, e = t[a]:find(""..pballs[a].ball.." = (.-)")
    local st2 = string.sub(t[a], d + pballs[a].num, e +5)
    if tonumber(st2) ~= 0 then
         if n ~= 0 and a ~= #t then
            msg = msg..", "
         end
         if tonumber(st2) ~= 1 then
            msg = msg..st2.." "..pballs[a].msg.."s"
            n = n +1
         else
            msg = msg..st2.." "..pballs[a].msg
            n = n +1
         end
    end
end
   if name ~= "" then
      msg = msg.." to try catch a "..name..", ultil now."
   else
      msg = msg.." to catch it."
   end
   if n == 0 then
      msg = "You haven't wasted any pokeball to try catch a "..name
   end
   doPlayerSendTextMessage(cid, 27, msg)
end

function onSay(cid, words, param)

if(param == '') then
    doPlayerSendTextMessage(cid, 27, "Enter with a pokemon name...")
    return true
end

if newpokedex[doCorrectPokemonName(param)] then
   local storage = newpokedex[doCorrectPokemonName(param)].stoCatch
   local name = doCorrectPokemonName(param)
   sendBrokesCountMsg(cid, name, storage)
else
   doPlayerSendTextMessage(cid, 27, "This isn't a pokemon...")
   return true
end


return true
end