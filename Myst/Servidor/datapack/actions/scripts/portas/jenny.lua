
local t ={
essence = 2160,
count = 0,
level = 170,

inicio ={
{x = 1063, y = 880, z = 7}, 
{x = 1063, y = 881, z = 7}, 
{x = 1063, y = 882, z = 7}, 
{x = 1063, y = 883, z = 7}, 
},

fim ={
{x = 1033, y = 560, z = 7},
{x = 1034, y = 560, z = 7},
{x = 1030, y = 560, z = 7},
{x = 1029, y = 560, z = 7},
}
}
function onUse(cid, item, fromPosition, itemEx, toPosition)
local test = {}
for _, k in ipairs(t.inicio) do
local x = getTopCreature(k).uid
if(x == 0 or not isPlayer(x) or getPlayerLevel(x) < t.level or getPlayerItemCount(x, t.essence) < t.count) then
doBroadcastMessage("Policial Jenny: Alguns jogadores estão tentando fazer a missão, mas alguém está faltando.", 24)
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