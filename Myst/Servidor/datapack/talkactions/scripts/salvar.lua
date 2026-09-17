function onSay(cid, words, param, channel)
 
local exausted = 3600    --Tempo em segundos.
 
    if exhaustion.check(cid, 928111) then
        return doPlayerSendCancel(cid, "Aguarde "..exhaustion.get(cid, 928111).." segundo(s) para salvar seu personagem novamente.")
    end
    
    doPlayerSave(cid)
    exhaustion.set(cid, 928111, exausted)
    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Seu personagem foi salvo com sucesso.")
    return true
end