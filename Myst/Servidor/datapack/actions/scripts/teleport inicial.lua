-- [( Script created by Doidin for XTibia.com )] --
function onUse(cid, item, fromPosition, item2, toPosition)

local teleport = {x=748, y=112, z=15} -- Coordenadas para onde o player irá ser teleportado.
local item_id = 11447 -- ID do item que o player precisa para ser teleportado.

if getPlayerItemCount(cid,item_id) >= 1 then
       doTeleportThing(cid, teleport)
       doSendMagicEffect(getPlayerPosition(cid), 10)
       doPlayerRemoveItem(cid, item_id, 11447)
       doPlayerSendTextMessage(cid, 22, "Ok, let's go! You sacrificed your "..getItemNameById(item_id).." for make this quest!")
       else
       doPlayerSendTextMessage(cid, 23, "Sorry, you need a "..getItemNameById(item_id).." to enter.")
       end
end