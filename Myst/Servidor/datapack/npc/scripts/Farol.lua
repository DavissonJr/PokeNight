local cfg = {
	watergem = 12161,
	watergemqnt = 500,	
	batwing = 12182,
	batwingqnt = 100,	
	applebite = 12173,
	applebiteqnt = 300,	
	bottle = 12165,
	bottleqnt = 200,
	pot = 12171,
	potqnt = 200,
	palavra = "farol",
	mensagem = "Você precisa ter os items e quantidades corretos.",
	concluir = "Pronto, agora você pode subir e pegar seu prêmio no último andar."
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
if getPlayerItemCount(cid, cfg.watergem) >= 500 and getPlayerItemCount(cid, cfg.batwing) >= 100 and getPlayerItemCount(cid, cfg.applebite) >= 300 and getPlayerItemCount(cid, cfg.bottle) >= 200 and getPlayerItemCount(cid, cfg.pot) >= 200  then
doPlayerRemoveItem(cid, cfg.watergem, cfg.watergemqnt)
doPlayerRemoveItem(cid, cfg.batwing, cfg.batwingqnt)
doPlayerRemoveItem(cid, cfg.applebite, cfg.applebiteqnt)
doPlayerRemoveItem(cid, cfg.bottle, cfg.bottleqnt)
doPlayerRemoveItem(cid, cfg.pot, cfg.potqnt)
setPlayerStorageValue(cid, 9876543, 1)
selfSay(cfg.concluir)
else
selfSay(cfg.mensagem)
end
end 
return true
 
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())