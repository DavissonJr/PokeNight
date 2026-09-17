local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
 
function onCreatureAppear(cid)                npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid)            npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)            npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                    npcHandler:onThink() end
 
    --[[Start edit]]--  
 
        local mingroup = 4 --(updated) minimum group to reset the event
        local joined = 10000 ---must be like the storage in mod
        local maxPlayerEachTeam = 20 ---must be like max number in mod
        local team1Name = "Blue" ---must be like team number i mod
        local team2Name = "Red"
        local minlevel = 50 --(added) min lvl for a player to join.
 
                --[[Storage like in the mod file]]--
          local  running1 = 12000 --just add a non ussed storage
          local running2 = 12001 --just add a non ussed storage
          local sto = 12223 --just add a non ussed storage
         --[[Storage end]]--
 
 
 --[[End of edit]]--
local function getBlue()
        return getGlobalStorageValue(9888)
end
 local function removeBlue()
    return setGlobalStorageValue(9888, getGlobalStorageValue(9888) - 1)
end
local function addBlue()
   return setGlobalStorageValue(9888, getGlobalStorageValue(9888) + 1)
end
local function resetBlue()
      return setGlobalStorageValue(9888,0)
end
 
local function getRed()
        return getGlobalStorageValue(9887)
end
 local function removeRed()
    return setGlobalStorageValue(9887, getGlobalStorageValue(9887) - 1)
end
local function addRed()
   return setGlobalStorageValue(9887, getGlobalStorageValue(9887) + 1)
end
local function resetRed()
      return setGlobalStorageValue(9887,0)
end
--[[Script start]]--
 
function creatureSayCallback(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end
    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
if getPlayerGroupId(cid) >= mingroup then
     npcHandler:say("Ola,Sou o Encarregado Pelo torneio diario de Grupos RED contra o BLUE caso queira entrar diga {sim}", cid)
         talkState[talkUser] = 1
      if msgcontains(msg, 'sim') and talkState[talkUser] == 1 then
                     resetBlue()
                 resetRed()
                         setGlobalStorageValue(running1,-1)
                 setGlobalStorageValue(running2,-1)
                 setGlobalStorageValue(sto,-1)
                         npcHandler:say("Evento foi reposto, senhor.", cid)
                         doBroadcastMessage("Eventer: Meu evento foi resetado por ordens do "..getCreatureName(cid)..". Para participar fale comigo outra vez,estou na arena pvp.")
                 for _,cid in ipairs(getPlayersOnline()) do
                    if getPlayerStorageValue(cid, joined) > 0 then
                           setPlayerStorageValue(cid, joined,-1)
                             doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)), FALSE)
                 doSendMagicEffect(getCreaturePosition(cid), 10)
                         end
                 end
          elseif msgcontains(msg, 'sim') and talkState[talkUser] == 1 then
            npcHandler:say("Como quiser, senhor.", cid)
             talkState[talkUser] = 0
         end
else
    if msgcontains(msg, 'battle') then
             if getGlobalStorageValue(running2) == 1 then  
             npcHandler:say("Ja tem batalha em andamento,tente mais tarde.", cid)
         elseif getPlayerLevel(cid) < minlevel then
                 npcHandler:say("Apenas level 130+ pode participar.",cid)
                 else
         npcHandler:say("Voce esta preparado para a abatalha? Por enquanto temos " .. getBlue() .. "/" .. maxPlayerEachTeam .. " players no {" .. team1Name .. "} team e " .. getRed() .. "/" .. maxPlayerEachTeam .. " players no {" .. team2Name .. "} team,vc quer escolher algum?", cid)
         talkState[talkUser] = 1
             end
    elseif msgcontains(msg, 'sim') and talkState[talkUser] == 1 then
        if getPlayerStorageValue(cid, joined) ~= 1 and getPlayerStorageValue(cid, joined) ~= 2 then
            npcHandler:say("Vc quer ser do  {" .. team1Name .. "} team  ou {" .. team2Name .. "} team?", cid)
            talkState[talkUser] = 2
        else
            npcHandler:say("Vc esta cadastrado!", cid)
            talkState[talkUser] = 0
        end
    elseif msgcontains(msg, 'no') and talkState[talkUser] == 1 then
        npcHandler:say("Ok, entao", cid)
        talkState[talkUser] = 0
    elseif msgcontains(msg, team1Name) and talkState[talkUser] == 2 then
        if getBlue() ~= maxPlayerEachTeam then --fixed
            setPlayerStorageValue(cid, joined, 1)
           addBlue()
            npcHandler:say("Vc entrou no " .. team1Name .. " team! Quando ambas equipes tiverem " .. maxPlayerEachTeam .. " os players serao teleportados para arena de batalha.", cid)
 
            talkState[talkUser] = 0
        else
            npcHandler:say("{" .. team1Name .. "} team esta cheio, entre no {" .. team2Name .. "} team ou espere alguem sair do {" .. team1Name .. "} team.", cid) --fixed
            talkState[talkUser] = 1
        end
    elseif msgcontains(msg, team2Name) and talkState[talkUser] == 2 then
        if getRed() ~= maxPlayerEachTeam then --fixed
            setPlayerStorageValue(cid, joined, 2) --fixed
           addRed()
            npcHandler:say("Vc esta no " .. team2Name .. " team! Quando ambas equipes tiverem " .. maxPlayerEachTeam .. " os players serao teleportados para arena de batalha.", cid)
 
            talkState[talkUser] = 0
        else
            npcHandler:say("{" .. team2Name .. "} team esta cheio, entre no {" .. team1Name .. "} team ou espere alguem sair do {" .. team2Name .. "} team.", cid)
            talkState[talkUser] = 1
        end
 elseif msgcontains(msg, 'leave') then
        npcHandler:say("Vc quer sair da lista de espera para batalha?", cid)
        talkState[talkUser] = 3
    elseif msgcontains(msg, 'yes') and talkState[talkUser] == 3 then
        if getPlayerStorageValue(cid,joined) == 1 then
            setPlayerStorageValue(cid, joined, -1) -- fixed
           removeBlue()
            npcHandler:say("Vc saiu da batalha.", cid)
            doBroadcastMessage("Event: " .. getPlayerName(cid) .. " saiu da batalha " .. team1Name .. " e " .. team2Name .. "!")
        elseif getPlayerStorageValue(cid,joined) == 2 then --fixed
                      setPlayerStorageValue(cid,joined,-1)
              removeRed()
              npcHandler:say("Vc saiu da batalha.", cid)
             doBroadcastMessage("Event: " .. getPlayerName(cid) .. " saiu da batalha " .. team1Name .. " e " .. team2Name .. "!")
                else
            npcHandler:say("Vc nao esta cadastrado!", cid)
        end
        talkState[talkUser] = 0 -- moved
    end
end    
    return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())