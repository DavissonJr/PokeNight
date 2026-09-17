local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)		npcHandler:onCreatureAppear(cid)	    end
function onCreatureDisappear(cid)	    npcHandler:onCreatureDisappear(cid)	    end
function onCreatureSay(cid, type, msg)	    npcHandler:onCreatureSay(cid, type, msg)	end
function onThink()		    npcHandler:onThink()		    end

function creatureSayCallback(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
	return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
    
    if(msgcontains(msg, 'ticket')) then
	    if getPlayerMoney(cid) >= 500 then
		selfSay('Quer comprar 1 passagem?, custou 5 dollars', cid)
		talkState[talkUser] = 1
	    else
		selfSay('Você não tem dinheiro suficiente, custou 5 dollars.', cid)
	    end
    elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then
	if doPlayerRemoveMoney(cid, 500) == TRUE then
                   setPlayerStorageValue(cid, 4590, 1)
	    selfSay('Aqui está o seu bilhete, ele não pode ser transferido, quando você tiver usado o bilhete no trem, ele não poderá ser usado novamente, vá até o trem para usá-lo.', cid)
	end
    end
return TRUE
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())