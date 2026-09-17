-- Criado por Thalles Vitor --
-- Auto Catch --
local storage = 9480
local storage2 = 9483
local storage3 = 9481
local pokebolas = {"normal", "great", "super", "ultra", "saffari"}

function onSay(cid, words, param)
	local str = string.explode(param, ",")
	if str[1] == "" then
		doPlayerSendTextMessage(cid, 25, "Digite uma pokebola válida.")
		return true
	end

	if not isInArray(pokebolas, str[1]) then
		doPlayerSendTextMessage(cid, 25, "Essa pokebola não existe.")
		return true
	end

	if str[2] == "" or str[2] == nil then
		doPlayerSendTextMessage(cid, 25, "Digite um pokémon válido.")
		return true
	end

	local value = doCorrectString(str[2])
	if not pokes[value] then
		doPlayerSendTextMessage(cid, 25, "Pokémon não existe.")
		return true
	end

	if getPlayerStorageValue(cid, storage2) <= 0 then
		doPlayerSendTextMessage(cid, 25, "Você não desbloqueou o auto catch ainda.")
		return true
	end

	if getPlayerStorageValue(cid, storage) == "" then
		doPlayerSendTextMessage(cid, 25, "Você ativou o auto catch para o pokémon: " .. value .. ".")
		setPlayerStorageValue(cid, storage, str[1])
		setPlayerStorageValue(cid, storage3, value)
	else
		doPlayerSendTextMessage(cid, 25, "Você desativou o auto catch.")
		setPlayerStorageValue(cid, storage, "")
		setPlayerStorageValue(cid, storage3, "")
	end
	return true
end