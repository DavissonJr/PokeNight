local focus = 0
local talk_start = 0
local conv = 0
local target = 0
local following = false
local attacking = false
local talkState = {}
local finalname = ""
function msgcontains(txt, str)
return (string.find(txt, str) and not string.find(txt, '(%w+)' .. str) and not string.find(txt, str .. '(%w+)'))
end
function onCreatureSay(cid, type, msge)
local msg = string.lower(msge)
local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

------ CONFIGURE AQUI TUDO DO NPC --------------
local config = {
PrimeiraFala = 'hi',
historiaInicial = "Olá "..getCreatureName(cid).." você quer trocar comigo", -- Mensagem quando o player dizer hi.
wordsToNextHistory = 'yes', -- qual palavra o player tem que falar para ele continuar a história
segundaHistoria = "Bom eu cobro os seguinte itens. Imam, Dragon scale, Hook!", -- História que o npc vai contar após o player dizer as palavras acima
wordsToForge = 'sim', -- palavra que o player tem que dizer para forjar os items
item1 = {12198, 1}, -- id do item 1 que vai precisar, quantidade
item2 = {6097, 1}, -- id do item 1 que vai precisar, quantidade
item3 = {12417, 1}, -- id do item 1 que vai precisar, quantidade
itemFinal = {2086, 1}, -- id do item que vai ganhar, se o player tiver os itens acima
finalHistory = "Obrigado, aqui está sua roupa de esqui. Verifique suas roupas!", -- Oque o npc vai falar depois que trocar
notHave = "Desculpe, você não tem o que eu preciso.", -- Oque o npc vai falar se o player não tiver os itens necessários
talkType = TALKTYPE_ORANGE_1, -- tipo de fala do npc
}

--------------------------------------------------------------

if (msgcontains(msg, config.PrimeiraFala )) then
-- doCreatureSay(getNpcId(), config.historialInicial, config.talkType)
selfSay('Olá '..getCreatureName(cid)..' quer comprar uma roupa de frio?',config.talkType)
end

if (msgcontains(msg, config.wordsToNextHistory )) then
doCreatureSay(getNpcId(), config.segundaHistoria, config.talkType)
end

if (msgcontains(msg, config.wordsToForge)) then
if doPlayerRemoveItem(cid, config.item1[1], config.item1[2]) and doPlayerRemoveItem(cid, config.item2[1], config.item2[2])  and doPlayerRemoveItem(cid, config.item3[1], config.item3[2]) then
selfSay('Obrigado, aqui está sua roupa!')
setPlayerStorageValue(cid,181647,1)
else
doCreatureSay(getNpcId(), config.notHave, config.talkType)
return true
end
return true
end

return true
end