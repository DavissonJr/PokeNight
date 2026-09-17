-- Criado por Thalles Vitor --
local onlineRewardStorage = 12302
local rewards = {2148, 2152, 12341, 12342, 12343, 12344}

function onSay(cid, words, param, channel)
	if getPlayerStorageValue(cid, onlineRewardStorage) >= 3600 then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Por ficar 1 hora online você resgatou uma recompensa!")
		doPlayerAddItem(cid, rewards[math.random(1, #rewards)], math.random(1, 25))
		setPlayerStorageValue(cid, onlineRewardStorage, 0)
	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Você ainda não ficou online por 1 hora.")
	end
	return true
end
