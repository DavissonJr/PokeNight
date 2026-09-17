function onLogin(cid)
        registerCreatureEvent(cid, "DropItemEffect")
return true
end

function onKill(cid, target, lastHit)

        if not isMonster(target) then return true end

        local mInfo = getMonsterInfo(getCreatureName(target))

        if not mInfo then return true end

        local items = {11441, 11442, 11443, 11444, 11445, 11446, 11447, 11448, 11449, 11450, 11451, 11452, 11453, 11454} -- coloque os itens que serão sinalizados caso dropem
        local effect = 196 -- effect que vai aparecer no player se encontar o item

        addEvent(function(player, position, effect, items, corpseId)
                if not isCreature(player) then return end
                local corpse = getTileItemById(position, corpseId).uid
                if corpse <= 1 or not isContainer(corpse) then return end
                for slot = 0, getItemInfo(corpseId).maxItems - 1 do
                        if isInArray(items, getContainerItem(corpse, slot).itemid) then
                                return doSendMagicEffect(getThingPos(player), effect)
                        end
                end
        end, 1, cid, getThingPos(target), effect, items, mInfo.lookCorpse)

return true
end