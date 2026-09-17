-- Criado por Thalles Vitor --
-- Online Reard Window --

-- Opcodes - Cliente
local onlineWINDOWSEND_OPCODE = 251
local onlineWINDOWCLAIM_OPCODE = 252

function onExtendedOpcode(cid, opcode, buffer)
   if not isPlayer(cid) then return true end
   if opcode == onlineWINDOWSEND_OPCODE then
      sendOnlineWindow(cid)
   end

   if opcode == onlineWINDOWCLAIM_OPCODE then
      sendReedemOnlineReward(cid)
   end
   return true
end