function onSay(cid, words, param)
local pb = getPlayerSlotItem(cid, 8).uid
local ad = {
[13301] = {pokemon= "Togekiss" , name = "Silly king", looktype = 2138, count = 1},

}
if param == "" then
doPlayerSendTextMessage(cid,27,"Use !addons remove para remover seu addon do pokemon.")
return false
end
if param == "remove" then
local pk = getCreatureSummons(cid)[1]
doSetItemAttribute(pb,"addon",0)
doPlayerSendTextMessage(cid,27,"o Addon foi removido.")

end

if param == "1" then
local pk = getCreatureSummons(cid)[1]
doSetItemAttribute(pb,"addon",1)
doPlayerSendTextMessage(cid,27,"o Addon foi adicionado.")

end
return false 
end