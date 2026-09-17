function onUse(cid, item, fromPosition, itemEx, toPosition)
 
local cfg = {
qnt = 1,      
max = 100,      
}
 
local ball = getPlayerSlotItem(cid, 8).uid
local level = getItemAttribute(ball, "level")
 
if getPlayerSlotItem(cid, 8).uid <= 0 then
doPlayerSendCancel(cid, "Usable in Pokeballs!")
return true
end


if level >= cfg.max then
return doPlayerSendCancel(cid, "Maximum level reached!")
end
doItemSetAttribute(ball, "level", (level + cfg.qnt))
doSendMagicEffect(fromPosition, 178)
doRemoveItem(item.uid, 1)
end
