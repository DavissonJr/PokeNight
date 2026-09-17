function onSay(cid, words, param)

local pokemon = "Gible"
local waittime = 300.0
local storage = 676334

if exhaustion.check(cid, storage) then
doPlayerSendTextMessage(cid, 27, "zzzZZZ")
return true
end

local summon = doCreateMonster(pokemon, {x=877, y=2800, z=7})
exhaustion.set(cid, storage, waittime)
return true
end