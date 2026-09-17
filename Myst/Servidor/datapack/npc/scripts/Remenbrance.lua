local cfg = {
	item1 = 13397,
	item1qnt = 2,	
	item2 = 13398,
	item2qnt = 2,
    item3 = 13399,
	item3qnt = 2,		
	item4 = 13400,
	item4qnt = 2,	
	item5 = 13401,
	item5qnt = 2,	
	palavra = "portal",
	mensagem = "Você ainda não tem os itens do portal",
	concluir = "Pronto, agora você pode abrir o portal."
}
 
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
 
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
 
function playerHaveItems(cid, itemid)
local items = type(itemid) == "table" and itemid or {itemid}
for i = 1, #items do
if getPlayerItemCount(cid, items) <= 0 then
return false
end
end
return true
end
 
function doPlayerRemoveItems(cid, itemid, count)
local items = type(itemid) == "table" and itemid or {itemid}
for i = 1, #items do
doPlayerRemoveItem(cid, items, count ~= nil and count or 1)
end
return nil
end
 
function creatureSayCallback(cid, type, msg)
 
if(not npcHandler:isFocused(cid)) then
return false
end
 
if msgcontains(msg, cfg.palavra) then
if getPlayerItemCount(cid, cfg.item1) >= 2 and getPlayerItemCount(cid, cfg.item2) >= 2 and getPlayerItemCount(cid, cfg.item3) >= 2  and getPlayerItemCount(cid, cfg.item4) >= 2  and getPlayerItemCount(cid, cfg.item5) >= 2 then
doPlayerRemoveItem(cid, cfg.item1, cfg.item1qnt)
doPlayerRemoveItem(cid, cfg.item2, cfg.item2qnt)
doPlayerRemoveItem(cid, cfg.item3, cfg.item3qnt)
doPlayerRemoveItem(cid, cfg.item4, cfg.item4qnt)
doPlayerRemoveItem(cid, cfg.item5, cfg.item5qnt)
setPlayerStorageValue(cid, 9876545, 1)
selfSay(cfg.concluir)
else
selfSay(cfg.mensagem)
end
end 
return true
 
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())