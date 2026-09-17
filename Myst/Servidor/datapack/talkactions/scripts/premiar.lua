-- Sistema de premiação 1.0
-- script criado por Vampira.
-- suporte técnico: mah.uvada@live.com.
local function premiarItem(cid, itemid, amount)
local item = 0
if(isItemStackable(itemid)) then
         item = doCreateItemEx(itemid, amount)
         if(doPlayerAddItemEx(cid, item, true) ~= RETURNVALUE_NOERROR) then
                 return false
         end
else
         for i = 1, amount do
                 item = doCreateItemEx(itemid)
                 if(doPlayerAddItemEx(cid, item, true) ~= RETURNVALUE_NOERROR) then
                         return false
                 end
         end
end
return true
end
function onSay(cid, words, param, channel)
if(param == "") then
         doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Diga um nome, Item, quantidade(opcional) exemplo: !premiar Player, Demon Helmet, 1")
         return TRUE
end
local player = string.explode(param, ",")
local quantidade = 1
local premiar = player[2]
if (player[3]) then
         quantidade = player[3]
end
local id = tonumber(premiar)
if(not id) then
         id = getItemIdByName(premiar, false)
         if(not id) then
                 doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Nome digitado incorretamente ou item não existe.")
                 return true
         else
                 premiar = id
         end
end

if(isItemMovable(premiar) == false) then
         doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Item não pode ser premiado")
         return TRUE
else
    
         if(player[1] == "todos") then
                 if getPlayerGroupId(cid) > 4 then
                         local monos = getPlayersOnline()
                         local ley = {}
                         for i, lol in ipairs(monos) do
                                 ley[i] = lol
                                 local vampira_tk = ley[#ley]
                                 premiarItem(vampira_tk, premiar, quantidade)
                         end
                         doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Premiação entregue")
                    
                 else
                         doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player não encontrado")
                 end
                 return TRUE
         end
    
         if (getPlayerByName(player[1])) then
                 if getPlayerGroupId(cid) > 4 then
                         premiarItem(getPlayerByNameWildcard(player[1]), regalar, quantidade)
                         doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Premiação entregue")
                 else
                         if getPlayerItemCount(cid,premiar) >= quantidade then
                                 doPlayerRemoveItem(cid, regalar, quantidade)
premiarItem(getPlayerByNameWildcard(player[1]), regalar, quantidade)
                                 doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Premiação entregue")
                         else
                                 doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não tem este item")
                         end
                 end
                 return TRUE
         else
                 doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player não encontrado")
         end
end
return TRUE
end