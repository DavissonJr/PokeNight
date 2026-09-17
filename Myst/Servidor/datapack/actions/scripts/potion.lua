function doHealOverTime(cid, div, turn, effect)                     --alterado v1.6 peguem o script todo!!
if not isCreature(cid) then return true end

if turn <= 0 or (getCreatureHealth(cid) == getCreatureMaxHealth(cid)) or getPlayerStorageValue(cid, 173) <= 0 then 
   setPlayerStorageValue(cid, 173, -1)
   return true 
end

local d = div / 10000
local amount = math.floor(getCreatureMaxHealth(cid) * d)
doCreatureAddHealth(cid, amount)
if math.floor(turn/10) == turn/10 then
   doSendMagicEffect(getThingPos(cid), effect)
end
addEvent(doHealOverTime, 100, cid, div, turn - 1, effect)
end

local potions = {
[12347] = {effect = 13, div = 30}, --super potion
[12348] = {effect = 13, div = 60}, --great potion              
[12346] = {effect = 12, div = 80}, --ultra potion
[12345] = {effect = 14, div = 90}, --hyper potion
}

function onUse(cid, item, frompos, item2, topos)
local pid = getThingFromPosWithProtect(topos)
if pid == nil then
   pid = getCreatureSummons(cid)[1]
end

if not isSummon(pid) or getCreatureMaster(pid) ~= cid then
return doPlayerSendCancel(cid, "You can only use potions on your own Pokemons!")
end

if getCreatureHealth(pid) == getCreatureMaxHealth(pid) then
return doPlayerSendCancel(cid, "This pokemon is already at full health.")
end

if getPlayerStorageValue(pid, 173) >= 1 then
return doPlayerSendCancel(cid, "This pokemon is already under effects of potions.")
end

if getPlayerStorageValue(cid, 52481) >= 1 then
return doPlayerSendCancel(cid, "You can't do that while a duel.")
end
 
doCreatureSay(cid, "".. getCreatureName(pid)..", take this potion!", TALKTYPE_SAY)
doSendMagicEffect(getThingPos(pid), 172)
setPlayerStorageValue(pid, 173, 1)
doRemoveItem(item.uid, 1)

local a = potions[item.itemid]
doHealOverTime(pid, a.div, 100, a.effect)

return true
end