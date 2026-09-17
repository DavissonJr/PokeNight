-- Craido por Thalles Vitor --
-- Receber Informacoes do Shop --
local SHOP_SENDOPENOPCODE = 5 -- enviar para o servidor que ele deve abrir o shop
local SHOP_SENDCHANGECATEGORYOPCODE = 6 -- enviar para o servidor que ele deve alternar a categoria

function onExtendedOpcode(cid, opcode, buffer)
   if opcode == SHOP_SENDOPENOPCODE then
      local param = buffer:explode("@")
      onSendShopWindow(cid, "Account")
   end

   if opcode == SHOP_SENDCHANGECATEGORYOPCODE then
      local param = buffer:explode("@")
      local category = tostring(param[1])

      onSendShopWindow(cid, category)
   end
   return true
end