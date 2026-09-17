focus = 0
talk_start = 0
target = 0
following = false
attacking = false
local SafariEnter = {x=1168, y=1465, z=7} -- Posição da Entrada Safari
function onThingMove(creature, thing, oldpos, oldstackpos)
end
function onCreatureAppear(creature)
end
function onCreatureDisappear(cid, pos)
if focus == cid then
   selfSay('Até mais.')
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
   selfSay('Olá a entrada no Saffari custará 20HDs você aceita?')
   focus = cid
   talk_start = os.clock()
elseif (msgcontains(msg, 'yes') ) then
   if getPlayerItemCount(cid,2392) >= 1 or getPlayerItemCount(cid,2393) >= 1 or getPlayerItemCount(cid,2391) >= 1 or getPlayerItemCount(cid,14432) >= 1 then
      selfSay("Você não pode entrar no Saffari com nenhuma outra ball exceto a Saffari!")
      focus = 0
      talk_start = 0
   elseif doPlayerRemoveMoney(cid, 20000) then 
      setPlayerStorageValue(cid, 98796, 1)
      setPlayerStorageValue(cid, 98797, 1)
      doPlayerAddItem(cid, 14426, 30)  
      doTeleportThing(cid, SafariEnter)
      doSendMagicEffect(getThingPos(cid), 21)
      talk_start = os.clock()
   else
      selfSay("Você não tem dinheiro suficiente")   
      focus = 0
      talk_start = 0
   end
elseif (msgcontains(msg, 'hi') and (focus ~= cid) and getDistanceToCreature(cid) < 4) then
   selfSay('Desculpe, estou ocupada neste momento.')
elseif (msgcontains(msg, 'bye') and focus == cid and getDistanceToCreature(cid) < 4) then
   selfSay('Adeus.')
   focus = 0
   talk_start = 0
end
end
function onCreatureChangeOutfit(creature)
end
function onThink()
if (os.clock() - talk_start) > 30 then
if focus > 0 then
selfSay('Ate Logo.')
end
focus = 0
end
end