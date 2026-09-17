local dirs = {
["a1"] = {dir = 1, dire = "leste"},
["a0"] = {dir = 0, dire = "norte"},
["a2"] = {dir = 2, dire = "sul"},
["a3"] = {dir = 3, dire = "oeste"},
}

function onSay(cid, words, param)
if param ~= "" then
return false
end

if #getCreatureSummons(cid) == 0 then
return false
end

local function doTurn(cid, dir)
if not isCreature(cid) then return true end
if #getCreatureSummons(cid) == 0 then
return true
end
if getCreatureSpeed(getCreatureSummons(cid)[1]) == 0 then
doChangeSpeed(getCreatureSummons(cid)[1], 1)
doCreatureSetLookDir(getCreatureSummons(cid)[1], dirs[words].dir)
doChangeSpeed(getCreatureSummons(cid)[1], -1)
else
doCreatureSetLookDir(getCreatureSummons(cid)[1], dirs[words].dir)
end
end

addEvent(doTurn, 200, cid, dir)
doCreatureSay(cid, ""..getPokeName(getCreatureSummons(cid)[1])..", vire para o "..dirs[words].dire.."!", TALKTYPE_ORANGE_1)  --alterado v1.7

return true
end