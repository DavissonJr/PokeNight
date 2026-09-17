-- Criado por Thalles Vitor --
-- Empilhar Dinheiro --

function onExtendedOpcode(cid, opcode, buffer)
   if not isPlayer(cid) then return true end
   if opcode == 99 then
      empilhar(cid)
   end
   return true
end