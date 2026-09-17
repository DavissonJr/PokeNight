-- Criado por Thalles Vitor --
-- Comando de Auto Spell --

function onSay(cid, words, param)
	if param == "" then
		doPlayerSendTextMessage(cid, 22, "Digite um parametro válido.")
		return true
	end

	if param == "on" then
		doPlayerSendTextMessage(cid, 25, "Você ativou o macro!")
		setPlayerStorageValue(cid, 74652, 1)

		-- Thalles Vitor - Auto Spell --
			addEvent(autospell, 10, cid)
		--
	else if param == "off" then
		doPlayerSendTextMessage(cid, 22, "Você desativou o macro!")
		setPlayerStorageValue(cid, 74652, 0)
	else
		doPlayerSendTextMessage(cid, 22, "Digite on ou off para ativar/desativar o macro, sua ação foi inválida.")
		end
	end
	return true
end