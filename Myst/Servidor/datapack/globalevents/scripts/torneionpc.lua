function onThink(interval, lastExecution, thinkInterval)
local pos = {x=1027,y=1037,z=8} -- Local onde aparece o npc
local npc = doCreateNpc("Torneioglobal", pos) -- Altere o (Goup) pelo nome do seu npc.
local nMin = 35 -- tempo em minuto para o npc sumir.
addEvent(doRemoveCreature, nMin*60*1000, npc)
return true
end