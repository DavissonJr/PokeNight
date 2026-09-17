local t ={
essence = 2160,
count = 0,
level = 375,

inicio ={
{x = 1179, y = 1439, z = 8}, --fushcia
{x = 693, y = 1336, z = 8}, --cinnabar
{x = 728, y = 756, z = 9}, --pewter
{x = 699, y = 1333, z = 8}, --cinnabar
},

fim ={
{x = 1195, y = 1573, z = 9},
{x = 1196, y = 1573, z = 9},
{x = 1197, y = 1573, z = 9},
{x = 1198, y = 1573, z = 9},
}
}
function onUse(cid, item, fromPosition, itemEx, toPosition)
local test = {}
for _, k in ipairs(t.inicio) do
local x = getTopCreature(k).uid
if(x == 0 or not isPlayer(x) or getPlayerLevel(x) < t.level or getPlayerItemCount(x, t.essence) < t.count) then
doPlayerSendCancel(cid, "Falta Player Ou algum Player nao tem level "..t.level.." para poder passar.")
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