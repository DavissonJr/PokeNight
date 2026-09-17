local tab = {
	pos = {x = 1343, y = 744, z = 7}, -- posição x, y, z do local a teleportar o player
	item = {11448, 300}, -- {itemID, count}
	price = 0 -- quantidade em crystal coins
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)  npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                      npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end
	
	local talkUser = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid
	if (msgcontains(msg, 'ritual')) then
		talkState[talkUser] = 1
		selfSay('Tem certeza?', cid)
		selfSay('Você precisa dos '..tab.item[2]..' '..getItemNameById(tab.item[1])..' and '..tab.price..' para iniciar o ritual.', cid)
	elseif (msgcontains(msg, 'yes') and talkState[talkUser] == 1) then
		if (getPlayerItemCount(cid, tab.item[1]) >= tab.item[2] and doPlayerRemoveMoney(cid, tab.price * 10000)) then 
			doTeleportThing(cid, tab.pos)
		 	doPlayerRemoveItem(cid, tab.item[1], tab.item[2])
            doPlayerRemoveMoney(cid, tab.price * 10000)	
			doSendMagicEffect(getThingPos(cid), CONST_ME_TELEPORT)
			selfSay('O ritual está feito.', cid)
		else
			talkState[talkUser] = 0
			selfSay('Eu não posso te teletransportar. Você não possui os itens necessários.', cid)
		end
	elseif (msgcontains(msg, 'no') and talkState[talkUser] == 1) then
		talkState[talkUser] = 0
		selfSay('Ok, talvez outra hora.', cid)
	end
	
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
