focus = 0
talk_start = 0
target = 0
following = false
attacking = false

function onThingMove(creature, thing, oldpos, oldstackpos)
end
function onCreatureAppear(creature)
end
function onCreatureDisappear(cid, pos)
if focus == cid then
   sendDialogNpc(cid, getNpcCid(),'Até mais.')
   focus = 0
   talk_start = 0
end
end
function onCreatureTurn(creature)
end
function msgcontains(txt, str)
return (string.find(txt, str) and not string.find(txt, '(%w+)' .. str) and not string.find(txt, str .. '(%w+)'))
end

function onCreatureSay(cid, type, msg)
msg = string.lower(msg)
if (msgcontains(msg, 'hi') and (focus == 0)) and getDistanceToCreature(cid) < 3 then
   selfSay('Olá, posso deixar você entrar na zona do saffari por 500 dólares, você aceita?')
   focus = cid
   talk_start = os.clock()
elseif (msgcontains(msg, 'yes') ) then
   if getPlayerStorageValue(cid, 98796) >= 1 or getPlayerStorageValue(cid, 98797) >= 1 then
selfSay("Você já está na zona do saffari!")
      focus = 0
      talk_start = 0
   elseif doPlayerRemoveMoney(cid, 50000) then --500dl --alterado v1.9
      setPlayerStorageValue(cid, 98796, 1)
      setPlayerStorageValue(cid, 98797, 1)
      doPlayerAddItem(cid, 12617, 30)  --alterado v1.9
      doTeleportThing(cid, {x=409, y=3402, z=7})
      doSendMagicEffect(getThingPos(cid), 102)
      talk_start = os.clock()
   else
      selfSay("Você não tem tanto dinheiro.")   --alterado v1.9
      focus = 0
      talk_start = 0
   end
elseif (msgcontains(msg, 'hi') and (focus ~= cid) and getDistanceToCreature(cid) < 3) then
selfSay('Desculpe, estou ocupado neste momento.')
elseif (msgcontains(msg, 'bye') and focus == cid and getDistanceToCreature(cid) < 3) then
selfSay('Good bye then.')
   focus = 0
   talk_start = 0
end
end

function onCreatureChangeOutfit(creature)
end
function onThink()
if (os.clock() - talk_start) > 30 then
if focus > 0 then
selfSay('Até mais.')
end
focus = 0
end
end