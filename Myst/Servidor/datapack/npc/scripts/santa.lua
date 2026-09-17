santaDoll = 2331 -- aqui voce coloca o itemId RAFA

random_items = {
{5,2112,1}, -- 0.5% to get teddy bear
{20,6512,1}, -- 2% to get santa doll
{40,2114,1}, -- 4% to get piggy bank
{80,2111,5}, -- 8% to get 5 snowballs
{80,2688,8}, -- 8% to get 8 candy canes
{80,2110,1}, -- 8% to get doll
{400,2674,15}, -- 40% to get 15 red apples
{450,2675,10}, -- 45% to get 10 oranges
{1000,2687,8} -- 100% to get 8 cookies
}
PRESENT_STORAGE = 54163 -- storage ID

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
		if getPlayerItemCount(cid, santaDoll) >= 1 then 
			doPlayerRemoveItem(cid, santaDoll, 1)   
			local item = {}
			local reward = 0
			local count = ""
			
			for i = 1, #random_items do
				item = random_items[i]
				if (math.random(0,999) < item[1]) then
					reward = item[2]
					subType = item[3]
					if subType > 1 then
					count = subType .. " "
					end
				  break
				end
			end
			doPlayerAddItem(cid, reward, subType)
			setPlayerStorageValue(cid, PRESENT_STORAGE, 1)
			npcHandler:say('HO HO HO por ter nascido esse ano você, trouxe ' .. count .. getItemNameById(reward) .. ' para você.', cid)
			
		else
			npcHandler:say('Você não tem um presente', cid)
		end
	else
		npcHandler:say('Volte quando estiver bem.', cid)
	end
	
	npcHandler:resetNpc()
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Feliz Natal |PLAYERNAME|. HO HO HO Eu sou o Papai Noel. E eu vou te dar um presente por ser um bom menino.")

local noNode = KeywordNode:new({'no'}, santaNPC, {present = false})
local yesNode = KeywordNode:new({'yes'}, santaNPC, {present = true})

local node = keywordHandler:addKeyword({'pre'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'você foi bem esse ano?'})
node:addChildKeywordNode(yesNode)
node:addChildKeywordNode(noNode)
npcHandler:addModule(FocusModule:new())