local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	 npcHandler:onThink()	end
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setMessage(MESSAGE_GREET, 'Bem-vindo à minha loja de pintura |PLAYERNAME| Se quizer pintar sua ball fale paint!')
function creatureSayCallback(cid, type, msg)
if(not npcHandler:isFocused(cid)) then
return false
end
local pokesalive = {'11826', '11832', '11835', '11829', '554', '11452', '12596', '12599', '11826', '11829', '11835', '11832', '12575'}
if(msgcontains(msg, 'paint')) then
selfSay('Você quer pintar a sua ball?', cid)
talkState = 1
elseif(msgcontains(msg, 'yes') and talkState == 1) then
selfSay('Olá, você pode escolher: Pokeball, Greatball, Superball, Ultraball.', cid)
talkState = 2
elseif(msgcontains(msg, 'no') and talkState == 1) then
selfSay('Volte outra vez!', cid)
talkState = 0
npcHandler:releaseFocus(cid)
elseif((msgcontains(msg, 'Pokeball') or msgcontains(msg, 'Poke ball') or msgcontains(msg, 'pokeball') or msgcontains(msg, 'poke ball')) and talkState == 2) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
selfSay('Você realmente quer pintar a sua bola como um Pokeball? Ele vai te custar 800 dólares!', cid)
talkState = 3
else
selfSay('Você deve colocar a bola fechada no slot.', cid)
talkState = 0
end
elseif(msgcontains(msg, 'yes') and talkState == 3) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
if doPlayerRemoveMoney(cid,80000) == true then
selfSay('Boa escolha, a partir de agora um, ele vai olhar como uma Pokeball! Há qualquer outra coisa que eu possa ajudá-lo?', cid)
doTransformItem(getPlayerSlotItem(cid, 8).uid, 11826)
talkState = 0
else
selfSay('Desculpe'.. getCreatureName(cid) ..', mas você não tem dinheiro suficiente.', cid)
talkState = 0
end
else
selfSay('Por favor, mantenha sua bola fechada na slot.', cid)
talkState = 0
end
elseif((msgcontains(msg, 'Greatball') or msgcontains(msg, 'Great ball') or msgcontains(msg, 'greatball') or msgcontains(msg, 'great ball')) and talkState == 2) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
selfSay('Você realmente quer pintar a sua bola como um Greatball? Ele vai te custar 300 dólares!', cid)
talkState = 4
else
selfSay('Você deve colocar a bola fechada no slot.', cid)
talkState = 0
end
elseif(msgcontains(msg, 'yes') and talkState == 4) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
if doPlayerRemoveMoney(cid,30000) == true then
selfSay('Boa escolha, a partir de agora um, ele vai olhar como uma Greatball! Há qualquer outra coisa que eu possa ajudá-lo?', cid)
doTransformItem(getPlayerSlotItem(cid, 8).uid, 11832)
talkState = 0
else
selfSay('Desculpe '.. getCreatureName(cid) ..', mas você não tem dinheiro suficiente.', cid)
talkState = 0
end
else
selfSay('Por favor, mantenha sua bola fechada na slot.', cid)
talkState = 0
end
elseif((msgcontains(msg, 'Superball') or msgcontains(msg, 'Super ball') or msgcontains(msg, 'super ball') or msgcontains(msg, 'superball')) and talkState == 2) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
selfSay('Você realmente quer pintar a sua bola como um Superball? Ele vai te custar 700 dólares!', cid)
talkState = 5
else
selfSay('Você deve colocar a bola fechada no slot.', cid)
talkState = 0
end
elseif(msgcontains(msg, 'yes') and talkState == 5) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
if doPlayerRemoveMoney(cid,70000) == true then
selfSay('Boa escolha, a partir de agora um, ele vai olhar como uma Superball! Há qualquer outra coisa que eu possa ajudá-lo?', cid)
doTransformItem(getPlayerSlotItem(cid, 8).uid, 11835)
talkState = 0
else
selfSay('Desculpe '.. getCreatureName(cid) ..', mas você não tem dinheiro suficiente.', cid)
talkState = 0
end
else
selfSay('Por favor, mantenha sua bola fechada na slot.', cid)
talkState = 0
end
elseif((msgcontains(msg, 'Ultra ball') or msgcontains(msg, 'Ultraball') or msgcontains(msg, 'ultra ball') or msgcontains(msg, 'ultraball')) and talkState == 2) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
selfSay('Você realmente quer pintar a sua bola como um Ultraball? Ele vai te custar 500 dólares!', cid)
talkState = 6
else
selfSay('Você deve colocar a bola fechada no slot.', cid)
talkState = 0
end
elseif(msgcontains(msg, 'yes') and talkState == 6) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
if doPlayerRemoveMoney(cid,50000) == true then
selfSay('Boa escolha, a partir de agora um, ele vai olhar como uma Ultraball! Há qualquer outra coisa que eu possa ajudá-lo?', cid)
doTransformItem(getPlayerSlotItem(cid, 8).uid, 11829)
talkState = 0
else
selfSay('Desculpe '.. getCreatureName(cid) ..', mas você não tem dinheiro suficiente.', cid)
talkState = 0
end
else
selfSay('Por favor, mantenha sua bola fechada na slot.', cid)
talkState = 0
end

elseif((msgcontains(msg, 'sdfdsfdsfsdf') or msgcontains(msg, 'dfsdfsdf') or msgcontains(msg, 'sdfsdfsdf') or msgcontains(msg, 'sdfsdfsdfsdf')) and talkState == 2) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
selfSay('Você realmente quer pintar a sua bola como um Masterball? Ele vai te custar 700 dólares!', cid)
talkState = 7
else
selfSay('Você deve colocar a bola fechada no slot.', cid)
talkState = 0
end
elseif(msgcontains(msg, 'yes') and talkState == 7) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
if doPlayerRemoveMoney(cid,70000) == true then
selfSay('Boa escolha, a partir de agora um, ele vai olhar como uma Masterball! Há qualquer outra coisa que eu possa ajudá-lo?', cid)
doTransformItem(getPlayerSlotItem(cid, 8).uid, 554)
talkState = 0
else
selfSay('Desculpe '.. getCreatureName(cid) ..', mas você não tem dinheiro suficiente.', cid)
talkState = 0
end
else
selfSay('Por favor, mantenha sua bola fechada na slot.', cid)
talkState = 0
end

elseif((msgcontains(msg, 'sdfsdf') or msgcontains(msg, 'ghfghfgh') or msgcontains(msg, 'fghjkuk') or msgcontains(msg, 'sdfsdfsdf')) and talkState == 2) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
selfSay('Você realmente quer pintar a sua bola como um Loveball? Ele vai te custar 300 dólares!', cid)
talkState = 8
else
selfSay('Você deve colocar a bola fechada no slot.', cid)
talkState = 0
end
elseif(msgcontains(msg, 'yes') and talkState == 8) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
if doPlayerRemoveMoney(cid,30000) == true then
selfSay('Boa escolha, a partir de agora um, ele vai olhar como uma Loveball! Há qualquer outra coisa que eu possa ajudá-lo?', cid)
doTransformItem(getPlayerSlotItem(cid, 8).uid, 12593)
talkState = 0
else
selfSay('Desculpe '.. getCreatureName(cid) ..', mas você não tem dinheiro suficiente.', cid)
talkState = 0
end
else
selfSay('Por favor, mantenha sua bola fechada na slot.', cid)
talkState = 0
end

elseif((msgcontains(msg, 'gfhfghfgh') or msgcontains(msg, 'fghgfhgfh') or msgcontains(msg, 'fghgfhgfh') or msgcontains(msg, 'gfhfghfgh')) and talkState == 2) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
selfSay('Você realmente quer pintar a sua bola como um Luaball? Ele vai te custar 700 dólares!', cid)
talkState = 9
else
selfSay('Você deve colocar a bola fechada no slot.', cid)
talkState = 0
end
elseif(msgcontains(msg, 'yes') and talkState == 9) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
if doPlayerRemoveMoney(cid,70000) == true then
selfSay('Boa escolha, a partir de agora um, ele vai olhar como uma Luaball! Há qualquer outra coisa que eu possa ajudá-lo?', cid)
doTransformItem(getPlayerSlotItem(cid, 8).uid, 12596)
talkState = 0
else
selfSay('Desculpe '.. getCreatureName(cid) ..', mas você não tem dinheiro suficiente.', cid)
talkState = 0
end
else
selfSay('Por favor, mantenha sua bola fechada na slot.', cid)
talkState = 0
end

elseif((msgcontains(msg, 'gfhfghgfh') or msgcontains(msg, 'fghfghfgh') or msgcontains(msg, 'gfhgfhfgh') or msgcontains(msg, 'fghgfhgfh')) and talkState == 2) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
selfSay('Você realmente quer pintar a sua bola como um Duskball? Ele vai te custar 500 dólares!', cid)
talkState = 10
else
selfSay('Você deve colocar a bola fechada no slot.', cid)
talkState = 0
end
elseif(msgcontains(msg, 'yes') and talkState == 10) then
if isInArray(pokesalive, getPlayerSlotItem(cid,8).itemid) then
if doPlayerRemoveMoney(cid,50000) == true then
selfSay('Boa escolha, a partir de agora um, ele vai olhar como uma Duskball! Há qualquer outra coisa que eu possa ajudá-lo?', cid)
doTransformItem(getPlayerSlotItem(cid, 8).uid, 12599)
talkState = 0
else
selfSay('Desculpe '.. getCreatureName(cid) ..', mas você não tem dinheiro suficiente.', cid)
talkState = 0
end
else
selfSay('Por favor, mantenha sua bola fechada na slot.', cid)
talkState = 0
end
end
return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())