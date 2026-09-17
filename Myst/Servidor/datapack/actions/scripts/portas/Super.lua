
local t ={
essence = 2160,
count = 0,
level = 250,

inicio ={
{x = 1110, y = 2611, z = 7}, 
{x = 1111, y = 2611, z = 7}, 
{x = 1112, y = 2611, z = 7}, 
{x = 1113, y = 2611, z = 7}, 
},

fim ={
{x = 1112, y = 2646, z = 8},
{x = 1113, y = 2646, z = 8},
{x = 1114, y = 2646, z = 8},
{x = 1115, y = 2646, z = 8},
}
}
function onUse(cid, item, fromPosition, itemEx, toPosition)
local test = {}
for _, k in ipairs(t.inicio) do
local x = getTopCreature(k).uid
if(x == 0 or not isPlayer(x) or getPlayerLevel(x) < t.level or getPlayerItemCount(x, t.essence) < t.count) then
doPlayerSendCancel(cid, "Falta algum jogador level "..t.level.." para poder passar.")
return true
end
table.insert(test, x)
end
for i, pid in ipairs(test) do
doSendMagicEffect(t.inicio[i], 2)
-- doPlayerRemoveItem(pid, t.essence, t.count)
doTeleportThing(pid, t.fim[i], false)
doSendMagicEffect(t.fim[i], 10)
end
doTransformItem(item.uid, item.itemid == 1945 and 1946 or 1945)
return true
end