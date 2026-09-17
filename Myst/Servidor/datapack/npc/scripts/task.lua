local tasksss = {
   [1] = {name = "Blastoise",  sto = 10212, count = 200, time_sto = 5457, time = 1*24*60*60, sto_count = 14129, money = 2, rewardid = 2145, rewardcount = 5, rewardid2 = 13341, rewardcount2 = 10, rewardexp = 1000000,  text = "Parabéns você terminou essa quest, agora poderá fazer novamente daqui a 24 horas."},
   [2] = {name = "Charizard",  sto = 10213, count = 200, time_sto = 5458, time = 1*24*60*60, sto_count = 14130, money = 1, rewardid = 2145, rewardcount = 5, rewardid2 = 13341, rewardcount2 = 10, rewardexp = 2000000,  text = "Parabéns você terminou essa quest, agora poderá fazer novamente daqui a 24 horas."},
   [3] = {name = "Venusaur",  sto = 10214, count = 200, time_sto = 5459, time = 1*24*60*60, sto_count = 14131, money = 1, rewardid = 2145, rewardcount = 5,  rewardid2 = 13341, rewardcount2 = 10, rewardexp = 2000000,  text = "Parabéns você terminou essa quest, agora poderá fazer novamente daqui a 24 horas."},
   [4] = {name = "Regirock",  sto = 10215, count = 150, time_sto = 5460, time = 1*24*60*60, sto_count = 14132, money = 1, rewardid = 2145, rewardcount = 10,  rewardid2 = 13341, rewardcount2 = 20, rewardexp = 2000000,  text = "Parabéns você terminou essa quest, agora poderá fazer novamente daqui a 24 horas."},
   [5] = {name = "Registeel",  sto = 10216, count = 150, time_sto = 5461, time = 1*24*60*60, sto_count = 14133, money = 1, rewardid = 2145, rewardcount = 10,  rewardid2 = 13341, rewardcount2 = 20, rewardexp = 2000000,  text = "Parabéns você terminou essa quest, agora poderá fazer novamente daqui a 24 horas."},
   [6] = {name = "Alakazam",  sto = 10217, count = 200, time_sto = 5462, time = 1*24*60*60, sto_count = 14134, money = 1, rewardid = 2145, rewardcount = 15, rewardid2 = 13341, rewardcount2 = 15, rewardexp = 2000000,  text = "Parabéns você terminou essa quest, agora poderá fazer novamente daqui a 24 horas."},
   [7] = {name = "Drapion",  sto = 10218, count = 200, time_sto = 5463, time = 1*24*60*60, sto_count = 14135, money = 1, rewardid = 2145, rewardcount = 10, rewardid2 = 13341, rewardcount2 = 20, rewardexp = 2000000,  text = "Parabéns você terminou essa quest, agora poderá fazer novamente daqui a 24 horas."},
   [8] = {name = "Kadabra",  sto = 10219, count = 100, time_sto = 5464, time = 1*24*60*60, sto_count = 14136, money = 1, rewardid = 2145, rewardcount = 25, rewardid2 = 13341, rewardcount2 = 20, rewardexp = 2000000,  text = "Parabéns você terminou essa quest, agora poderá fazer novamente daqui a 24 horas."},
   [9] = {name = "Lapras",  sto = 10220, count = 200, time_sto = 5465, time = 1*24*60*60, sto_count = 14137, money = 1, rewardid = 2145, rewardcount = 20, rewardid2 = 13341, rewardcount2 = 15, rewardexp = 2000000,  text = "Parabéns você terminou essa quest, agora poderá fazer novamente daqui a 24 horas."},
   [10] = {name = "Magmar",  sto = 10221, count = 200, time_sto = 5466, time = 1*24*60*60, sto_count = 14138, money = 1, rewardid = 2145, rewardcount = 10, rewardid2 = 13341, rewardcount2 = 10, rewardexp = 2000000,  text = "Parabéns você terminou essa quest, agora poderá fazer novamente daqui a 24 horas."},
   [11] = {name = "Venusaur",  sto = 10222, count = 200, time_sto = 5467, time = 1*24*60*60, sto_count = 14139, money = 1, rewardid = 2145, rewardcount = 15, rewardid2 = 13341, rewardcount2 = 15, rewardexp = 2000000,  text = "Parabéns você terminou essa quest, agora poderá fazer novamente daqui a 24 horas."},
   [12] = {name = "magikarp",  sto = 10224, count = 200, time_sto = 5469, time = 1*24*60*60, sto_count = 14141, money = 1, rewardid = 2145, rewardcount = 15, rewardid2 = 13341, rewardcount2 = 15, rewardexp = 2000000,  text = "Parabéns você terminou essa quest, agora poderá fazer novamente daqui a 24 horas."},
   [13] = {name = "Gyarados",  sto = 10225, count = 200, time_sto = 5470, time = 1*24*60*60, sto_count = 14142, money = 1, rewardid = 2145, rewardcount = 15, rewardid2 = 13341, rewardcount2 = 15, rewardexp = 2000000,  text = "Parabéns você terminou essa quest, agora poderá fazer novamente daqui a 24 horas."},
  }

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function creatureSayCallback(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end
    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
    value = -1
    for i = 1, #tasksss do
        if msgcontains(msg, tasksss[i].name) and not value ~= -1 then
            value = i
        end
    end
    if value == -1 then
       selfSay('Eu não tenho essa task, lembre-se de falar com a primeira letra em maiusculo.', cid)
        talkState[talkUser] = 0
        return true
    end
    local configss = tasksss[value]
    local name = configss.name
    local m_sto = configss.sto
    local time_sto = configss.time_sto
    local count_sto = configss.sto_count
    local total_count = configss.count
    local rest = total_count - getPlayerStorageValue(cid, count_sto)
        if getPlayerStorageValue(cid, time_sto) < os.time() then -- verifica se o player ainda está no prazo
            if getPlayerStorageValue(cid, m_sto) <= 0 then -- verifica se o player não pegou está task
              selfSay('Pronto! agora você precisa matar '.. total_count .. ' '.. name .. '!', cid)
                setPlayerStorageValue(cid, m_sto, 1)
                setPlayerStorageValue(cid, total_count, 0)
                talkState[talkUser] = 0               
            else
                if rest <= 0 then -- Verifica se o player matou todos os monstros nescessários
                    doPlayerAddItem(cid, configss.rewardid, configss.rewardcount)
					doPlayerAddItem(cid, configss.rewardid2, configss.rewardcount2)
					doPlayerAddItem(cid, 2159, configss.money)
					doPlayerAddExperience(cid, configss.rewardexp)
                    setPlayerStorageValue(cid, count_sto, 0) 
                    setPlayerStorageValue(cid, m_sto, -1) 
                    setPlayerStorageValue(cid, time_sto, os.time() + configss.time)
                    doSendAnimatedText(getCreaturePosition(cid), configss.rewardexp, 215)
                    selfSay(configss.text, cid) 
                    talkState[talkUser] = 0
                else
                    selfSay('Você precisa matar '..rest..' '..name..' para ganhar uma recompensa.', cid)
                    talkState[talkUser] = 0
                end
            end
        else
            selfSay('Você já fez essa quest, jogador. Espere '..math.ceil((getPlayerStorageValue(cid, time_sto) - os.time())/(60*60))..' horas para fazer de novo.', cid)
            talkState[talkUser] = 0
        end
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())