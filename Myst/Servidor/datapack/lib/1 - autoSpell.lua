-- Criado por Thalles Vitor --
-- Auto Spell --
local autospell_storage = 74652
local msgs = {"use "}
autospell_array = {}

function autospell(cid)
    if not isPlayer(cid) then
        return true
    end

    --[[ local summon = getCreatureSummons(cid)
    if #summon <= 0 then
        return true
    end

    if getPlayerStorageValue(cid, autospell_storage) >= 1 and not getTileInfo(getCreaturePosition(cid)).protection then
        local move_tabela = movestable[getCreatureName(summon[1])]
        if not move_tabela then
            return true
        end

        if getCreatureName(summon[1]) == "Ditto" then
            if getItemAttribute(getPlayerSlotItem(cid, 8).uid, "transName") ~= "" then
                move_tabela = movestable[getItemAttribute(getPlayerSlotItem(cid, 8).uid, "transName")]
            end
        end

        if not move_tabela then
            print("Pokemon: " .. getCreatureName(summon[1]) .. " not found.")
            return true
        end
                
        local moves = {move_tabela.move1, move_tabela.move2, move_tabela.move3, move_tabela.move4, move_tabela.move5, move_tabela.move6, move_tabela.move7,
        move_tabela.move8, move_tabela.move9, move_tabela.move10, move_tabela.move11, move_tabela.move12}
        for i = 1, #moves do
            if moves[i] ~= nil then
                local cdzin = "move"..tostring(i)..""       --alterado v1.5

                local coold = getCD(getPlayerSlotItem(cid, 8).uid, cdzin)
                if coold > 0 and coold < (moves[i].cd + 2) then
                    doPlayerSendCancel(cid, "You have to wait "..coold.." seconds to use "..moves[i].name.." again.")
                else
                    if moves[i].target == 1 and not isCreature(getCreatureTarget(cid)) then
                        --     
                    else
                        if i == 11 then
                            doCreatureExecuteTalkAction(cid, "correr", true)
                        else
                            doCreatureSay(cid, ""..getPokeName(summon[1])..", "..msgs[math.random(#msgs)]..""..moves[i].name.."!", TALKTYPE_ORANGE_1)
                            docastspell(summon[1], moves[i].name)
                            doCreatureAddCondition(cid, playerexhaust)
                            setCD(getPlayerSlotItem(cid, 8).uid, cdzin, moves[i].cd)

                            local id = getCreatureMaster(summon[1])

                            for i = 1, 2 do
                                if isInArray({"Gengar", "Shiny Gengar", "Virus Gengar", "Lotad", "Milotic", "Shiny Milotic", "Black Milotic"}, getCreatureName(summon[1])) then
                                    addEvent(autospell, i*5500, id)
                                else
                                    addEvent(autospell, i*4500, id)
                                end
                            end

                            for i = 1, moves[i].cd do
                                addEvent(doUpdateCooldowns, i*1000, cid)
                            end

                            if useKpdoDlls then
                                doUpdateCooldowns(cid)
                            end
                        end
                    end
                end
            end
        end
    end ]]
end