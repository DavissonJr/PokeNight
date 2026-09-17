local keywordHandler = KeywordHandler:new()

local npcHandler = NpcHandler:new(keywordHandler)

NpcSystem.parseParameters(npcHandler)

local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)

if(not npcHandler:isFocused(cid)) then

return false

end

local talkUser = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid

if(msgcontains(msg, 'bank') or msgcontains(msg, 'help')) then

selfSay('Olá amigo oque deseja fazer? {deposit} ou {depositar} para depositar, {withdraw} ou {sacar} para sacar dinheiro ou {balance} para ver seu saldo!', cid)

talkState[talkUser] = 1

elseif msgcontains(msg, 'balance') or msgcontains(msg, 'BALANCE') and talkState[talkUser] == 1 then

local balance = getPlayerBalance(cid)

selfSay('Você possui ' .. balance .. ' gps no banco', cid)

elseif msgcontains(msg, 'deposit') or msgcontains(msg, 'depositar') and talkState[talkUser] == 1 then

selfSay('Digite o valor que você deseja depositar.', cid)

talkState[talkUser] = 2

elseif talkState[talkUser] == 2 then

n = getNumber(msg)

if(msg == 'all' and doPlayerDepositAllMoney(cid)) then

selfSay('Depositado com sucesso!', cid)

talkState[talkUser] = 1

end

if n <= 0 then

selfSay('Escolha um valor acima de 0!', cid)

talkState[talkUser] = 1

end

if n and doPlayerDepositMoney(cid, n) then

selfSay('Depositado com sucesso!', cid)

talkState[talkUser] = 1

else

selfSay('Você não tem o valor informado', cid)

talkState[talkUser] = 1

end

elseif msgcontains(msg, 'withdraw') or msgcontains(msg, 'sacar') and talkState[talkUser] == 1 then

selfSay('Digite o valor que você deseja retirar.', cid)

talkState[talkUser] = 3

elseif talkState[talkUser] == 3 then

n = getNumber(msg)

local balance = getPlayerBalance(cid)

if(msg == 'all' and doPlayerWithdrawAllMoney(cid)) then

selfSay('Retirado ' .. balance .. ' gps da sua conta!', cid)

talkState[talkUser] = 1

end

if (n ~= 0 and doPlayerWithdrawMoney(cid, n)) then

selfSay('Retirado ' .. n .. ' gps da sua conta!', cid)

talkState[talkUser] = 1

else

selfSay('Voce não pode retirar esse valor!', cid)

talkState[talkUser] = 1

end

elseif msg == "no" and talkState[talkUser] >= 1 then

selfSay("Then not", cid)

talkState[talkUser] = 0

npcHandler:releaseFocus(cid)

end

return TRUE

end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())

function getNumber(txt)

x = string.gsub(txt,"%a","")

x = tonumber(x)

if x ~= nill and x > 0 then

return x

else

return 0

end

end