local cfg = {
	Strange = 2174,
	Strangeqnt = 1,	
	Scarab = 2159,
	Scarabqnt = 1,	
	Brooch = 2318,
	Broochqnt = 1,	
	palavra = "sim",
	mensagem = "Você precisa de um de cada dos meus tesouros perdido a muito tempo.",
	concluir = "Obrigado por me entregar meus tesouros perdidos, como recompensa você ganhou uma chave para abrir a porta da Quest Rayquaza!"
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
if getPlayerItemCount(cid, cfg.Strange) >= 1 and getPlayerItemCount(cid, cfg.Scarab) >= 1 and getPlayerItemCount(cid, cfg.Brooch) >= 1 then
doPlayerRemoveItem(cid, 2174, 1)
doPlayerRemoveItem(cid, 2159, 1)
doPlayerRemoveItem(cid, 2318, 1)
doPlayerAddItem(cid, 2090, 1)
selfSay(cfg.concluir)
else
selfSay(cfg.mensagem)
end
end 
return true
 
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())