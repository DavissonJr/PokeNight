-- [
    --~~ Thalles Vitor ~~--
	--~~ Troca ou Revenda é proibido ~~--
--]

function onExtendedOpcode(cid, opcode, buffer)
    if opcode == 133 then
        -- Se tiver um monstro pra fora ele volta ele
        if isMonster(getCreatureSummons(cid)[1]) then
            -- Um mini goback system pra voltar o poke

            resetAllMovesToOriginals(cid)

            local slot = getPlayerSlotItem(cid, 8)
            if slot.uid <= 0 then
                return false
            end
        
            local btype = getPokeballType(slot.itemid)
            local effect = pokeballs[btype].effect
            if not effect then
                effect = 21
            end

            local pokename = getPokeName(getCreatureSummons(cid)[1])

            local mbk = gobackmsgs[math.random(1, #gobackmsgs)].back:gsub("doka", pokename)
            doCreatureSay(cid, mbk, 19)

            doSendMagicEffect(getCreaturePosition(getCreatureSummons(cid)[1]), effect)
            doTransformItem(slot.uid, slot.itemid-1)
            doRemoveCreature(getCreatureSummons(cid)[1])

            hideTM(cid)
        end
    end
    return true
end