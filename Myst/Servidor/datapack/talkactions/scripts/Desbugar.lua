local config = {
    battle = true,
}

function onSay(cid, words, param)
    local storage = 23564
    local tempo = 30
    
    if exhaustion.check(cid, storage) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Aguarde " .. exhaustion.get(cid, storage) .. " 1 hora para usar esse comando novamente.")
        return true
    end
    
    if config.battle and getCreatureCondition(cid, CONDITION_INFIGHT) then
        doPlayerSendCancel(cid, "Desculpe você está em batalha.")
        return true
    end
    
    doSendMagicEffect(getPlayerPosition(cid),21)
    doPlayerSendTextMessage(cid, 25, "Sua conta foi desbugada!")
    doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
    exhaustion.set(cid, storage, tempo*60)
    return true
end






