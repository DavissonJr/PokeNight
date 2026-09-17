function prepararHalloween5(minutes)
        if(minutes <= 0) then
                doBroadcastMessage("A Alavanca do Evento Halloween foi trancada.")
		setGlobalStorageValue(177845, 0)
                return true
        end

		
						
        if(minutes == 1) then
                doBroadcastMessage("A Alavanca do Evento Halloween esta aberta por " .. minutes .. " minuto somente.")
				setGlobalStorageValue(177845, minutes)
        elseif(minutes == 5) then
                doBroadcastMessage("A Alavanca do Evento Halloween esta aberta e ainda restam " .. minutes .. " minutos, corram!")
				setGlobalStorageValue(177845, minutes)
        elseif(minutes == 10) then
                doBroadcastMessage("A Alavanca do Evento Halloween esta aberta e ainda restam " .. minutes .. " minutos, corram!")
				setGlobalStorageValue(177845, minutes)
        elseif(minutes == 15) then
                doBroadcastMessage("A Alavanca do Evento Halloween esta aberta e ainda restam " .. minutes .. " minutos, corram!")
				setGlobalStorageValue(177845, minutes)
        elseif(minutes == 18) then
                doBroadcastMessage("A Alavanca do Evento Halloween foi aberta por " .. minutes .. " minutos, aproveitem!")
				setGlobalStorageValue(177845, minutes)
        end

        shutdownEvent = addEvent(prepararHalloween5, 60000, minutes - 1)
        return true
end

function onTimer()

end
function onSay(cid, words, param)
    return prepararHalloween5(tonumber(param) or 18) -- Quantos minutos pra executar o ServeSave. 
end
