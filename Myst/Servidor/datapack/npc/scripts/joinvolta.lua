local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function onCreatureSay(cid, type, msg)

if getDistanceToCreature(cid) <= 3 then
    local talkUser = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid
    if (msgcontains(msg, 'hi') or msgcontains(msg, 'hi'))then
        sendNpcDialog(cid, getNpcCid(), "Você quer mesmo voltar para a cidade natal?", {"Fechar", "Yes"})
        talkState[talkUser] = 1
    elseif string.lower(msg, 'yes') and talkState[talkUser] == 1 then
        sendNpcDialog(cid, getNpcCid(), "Até breve!", {"Fechar"})
        doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
        doSendMagicEffect(getPlayerPosition(cid),21)
    elseif msg == "no" then 
        sendNpcDialog(cid, getNpcCid(), "Te vejo depois então!", {"Fechar"})
        talkState[talkUser] = 0 
    end
end
return true
end