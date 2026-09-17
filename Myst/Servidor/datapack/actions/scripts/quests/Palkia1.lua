local t ={
essence = 2160,
count = 0,
level = 350,

inicio ={
{x = 1807, y = 1100, z = 8}, --singer
{x = 1807, y = 1101, z = 8}, --singer
{x = 1807, y = 1102, z = 8}, --singer
{x = 1807, y = 1103, z = 8}, --singer
},
fim ={
{x = 450, y = 2066, z = 10},
{x = 451, y = 2066, z = 10},
{x = 452, y = 2066, z = 10},
{x = 453, y = 2066, z = 10},
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