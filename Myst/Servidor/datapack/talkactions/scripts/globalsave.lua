function prepararGlobalSave3(minutes)
	local state = GAMESTATE_CLOSED
        if(minutes <= 0) then
                doSetGameState(GAMESTATE_SHUTDOWN)
                return false
        end

        if(minutes == 1) then
                doBroadcastMessage("Desligando em " .. minutes .. " minuto, desloguem agora!")
		doSaveServer()
        elseif(minutes <= 3) then
			doSetGameState(state)
                doBroadcastMessage("Desligando o servidor em " .. minutes .. " minutos!")
	doBroadcastMessage("Salvando Contas...")
doBroadcastMessage("Salvando Houses...")
doBroadcastMessage("Salvando itens...")
doBroadcastMessage("Preparando para reiniciar...")
        else
                doBroadcastMessage("[+ O Servidor ira reiniciar em " .. (minutes - 3) .. " minutos, voltaremos em 3 a 5 minutos. -]")

        end

        shutdownEvent = addEvent(prepararGlobalSave3, 60000, minutes - 1)
        return true
end


function onSay(cid, words, param)
    return prepararGlobalSave3(tonumber(param) or 5) -- Quantos minutos pra executar o ServeSave. 
	end
