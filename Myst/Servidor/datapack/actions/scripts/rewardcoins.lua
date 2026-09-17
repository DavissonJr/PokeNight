local cost = 75000
local coins = 23254
local btype = "normal"
function onUse(cid, item, frompos, item2, topos)
local pokemon = ""
if item.uid == nil then return true end
if getPlayerStorageValue(cid, coins) < cost then
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You dont have enough cassino coins, you need "..cost.." coins.")
return true
end
if getPlayerMana(cid) >= 6 then
return doPlayerSendCancel(cid, "You don't have capacity for your prize!")
end
if item.actionid == 22420 then
pokemon = "Porygon"
elseif item.actionid == 22421 then
pokemon = "Chansey"
elseif item.actionid == 22422 then
pokemon = "Ditto"
else
return true
end
if pokemon == "" then return true end
local gender = getRandomGenderByName(pokemon)
if not mypoke then return true end
addPokeToPlayer(cid, pokemon, 0, gender, btype)
doPlayerSendTextMessage(cid, 27, "You choose a "..pokemon..".")
setPlayerStorageValue(cid, 23254, getPlayerStorageValue(cid, 23254) - cost)
doSendMagicEffect(getThingPos(cid), 29)
doSendMagicEffect(getThingPos(cid), 27)
doSendMagicEffect(getThingPos(cid), 29)
return TRUE
end