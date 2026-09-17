function onSay(cid, words, param)
 
local cfg = {
exhausted = 5, -- Time you are exhausted in seconds.
storage = 5858, -- Storage used for "exhaust."
exp = 2.0 -- this means 2x more experence then default
}
 
 
if(getPlayerStorageValue(cid, cfg.storage) > os.time() and getPlayerStorageValue(cid, cfg.storage) < 100+os.time()) then
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "You must wait another " .. getPlayerStorageValue(cid, cfg.storage) - os.time() .. ' second' .. ((getPlayerStorageValue(cid, cfg.storage) - os.time()) == 1 and "" or "s") .. " to use new pokemon.")
else
if doSendPokemon(cid, param) then
sendAllPokemonsBarPoke(cid)
setPlayerStorageValue(cid, cfg.storage, os.time() + cfg.exhausted)
return true
end
doPlayerSendTextMessage(cid, 27, "Sua barra esta desatualizada")
sendAllPokemonsBarPoke(cid)
end
return true
end