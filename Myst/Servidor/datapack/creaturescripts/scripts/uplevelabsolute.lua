function onAdvance(cid, skill, oldLevel, newLevel)

local config = {
[50] = {item = 2152, count = 5},
[100] = {item = 2152, count = 10},
[150] = {item = 2152, count = 15},
[500] = {item = 12618, count = 1},
}

if skill == 8 then
    doSendMagicEffect(getThingPos(cid), 370)
    doCreatureAddHealth(cid, getCreatureMaxHealth(cid))
end
return true
end