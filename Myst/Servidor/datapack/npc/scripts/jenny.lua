local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local cfg = {
    toPos = {x=1047, y=532, z=7}, -- Posição que o jogador sera teleportado
    level = 1, -- Level necessário para ser teleportado
    price = 0, -- Dinheiro a ser cobrado para ser teleportado
    {x=1063, y=880, z=7},
    {x=1063, y=881, z=7}, 
    {x=1063, y=882, z=7}, 
    {x=1063, y=883, z=7}, 
}
local permissao = 1

function creatureSayCallback(cid, type, msg)

  if(not npcHandler:isFocused(cid)) then
      return false
  end
  local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
  
  if msgcontains(msg, 'sim') then
      selfSay('Você tem certeza que quer ir? Você não pode retornar.', cid)
      talkState[talkUser] = 1
  elseif talkState[talkUser] == 1 then
    if msgcontains(msg, 'yes') then
      permissao = 1
      for i = 1, 4 do
        if not isPlayer(getThingFromPos(cfg[i]).uid) then 
		      permissao = 0
		    end
		    if getPlayerLevel(getThingFromPos(cfg[i]).uid) < cfg.level then 
          selfSay('Você precisa de nível acima de '.. cfg.level ..'.', cid)
          talkState[talkUser] = 0
        end
      end 
      if permissao == 1 then
        if doPlayerRemoveMoney(cid, cfg.price) then
          for p = 1, 4 do 
            doTeleportThing(getThingFromPos(cfg[p]).uid, cfg.toPos)
          end
            talkState[talkUser] = 0
        else
          selfSay('You don\'t have enough money.', cid)
        end
      else 
        selfSay('Você precisa de 4 jogadores nos lugares corretos.', cid)
        talkState[talkUser] = 0
      end
   
    elseif msgcontains(msg, 'no') then
      selfSay('Saia aqui!', cid)
    end
  end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())