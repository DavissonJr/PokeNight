STORAGE = 100010 -- Não Mecha
ITEM = 6512 -- Item a ser adicionado para completar a quest
QUANT = 1 -- Quantidade de items a ser adicionado


local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function santaNPC(cid, message, keywords, parameters, node)
if(not npcHandler:isFocused(cid)) then
return false
end
if (parameters.present == true) then
if (getPlayerStorageValue(cid, STORAGE) < 1) then
doPlayerAddItem(cid, ITEM, QUANT)
setPlayerStorageValue(cid, STORAGE, 1)
npcHandler:say('Tome o seu presente do papai noel hou hou hou !', cid)
else
npcHandler:say('Já dei o seu presente.', cid)
end
end
npcHandler:resetNpc()
return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hou hou hou tome o seu presente digite {mission}.")

local noNode = KeywordNode:new({'no'}, santaNPC, {present = false})
local yesNode = KeywordNode:new({'yes'}, santaNPC, {present = true})

local node = keywordHandler:addKeyword({'mission'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'para ganhar seu presente digite yes'})
node:addChildKeywordNode(yesNode)
node:addChildKeywordNode(noNode)
npcHandler:addModule(FocusModule:new())