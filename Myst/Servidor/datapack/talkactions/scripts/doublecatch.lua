-- Criado por Thalles Vitor --
-- Double Catch --
local doublecatch_stor = 5552 -- storage global do double catch
local doublecatch = 2 -- o quanto vai aumentar

function onSay(cid, words, param)
  local parametro = param:explode(",")
  if parametro[1] == "" then
    doPlayerSendTextMessage(cid, 22, "Digite um parametro válido.")
    return true
  end

  if parametro[1] == "on" then
    if parametro[2] == "" then
      doPlayerSendTextMessage(cid, 25, "Insira um valor.")
      return true
    end

    doBroadcastMessage("[DOUBLE CATCH] - O " .. getCreatureName(cid) .. " ativou o double catch para todos os jogadores online por: "..parametro[2].." horas.")
    doPlayerSendTextMessage(cid, 25, "[DOUBLE CATCH] - Você ativou o double catch para todos os jogadores online.")
    setGlobalStorageValue(doublecatch_stor, doublecatch)

    addEvent(function()
      doBroadcastMessage("[DOUBLE CATCH] - O double catch foi desativado.")
      setGlobalStorageValue(doublecatch_stor, 0)
    end, 3600000 * parametro[2])
  elseif parametro[1] == "off" then
    doBroadcastMessage("[DOUBLE CATCH] - O " .. getCreatureName(cid) .. " desativou o double catch para todos os jogadores online.")
    doPlayerSendTextMessage(cid, 22, "[DOUBLE CATCH] - Você desativou o double catch para todos os jogadores online.")
    setGlobalStorageValue(doublecatch_stor, 0)
  end
  return true
end