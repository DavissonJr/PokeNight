-- Criado por Thalles Vitor --
-- Sistema de Evolucao --
local evolveOpcode = 23

function onExtendedOpcode(cid, opcode, buffer)
   if not isPlayer(cid) then return true end
   if opcode == evolveOpcode then
      local param = buffer:explode("@")
      local name = tostring(param[1])
      local evoname = tostring(param[2])
      
      doEvolve(cid, name, evoname)
   end
   return true
end