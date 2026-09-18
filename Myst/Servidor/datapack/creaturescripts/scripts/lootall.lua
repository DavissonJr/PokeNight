-- Loot em area, no estilo do PokeAlliance.
--
-- O jogador aperta E, o cliente manda o opcode 150, e aqui varremos os
-- tiles ao redor recolhendo o conteudo de todo corpo alcancavel de uma vez,
-- em vez de abrir um por um.
--
-- Usa o mesmo canal (extendedopcode) que o autoloot deste servidor ja usa,
-- entao nao precisa de nada novo no protocolo.

local config = {
    opcode = 150,

    -- Alcance em tiles a partir do jogador. Segue a proporcao da tela do
    -- cliente (mais largo que alto), para o botao pegar o que esta a vista.
    rangeX = 7,
    rangeY = 5,

    -- Sem isso, um clique repetido varre o mapa inteiro a cada quadro.
    cooldownMs = 400,
    storageCooldown = 48150,
}

--- O item e um corpo de pokemon derrotado?
-- Mesmo criterio de getTopCorpse (lib/some functions.lua): este servidor
-- marca corpos pelo nome, nao por flag.
local function isCorpse(itemid)
    local info = getItemInfo(itemid)
    if not info or not info.name then
        return false
    end
    local name = info.name
    return string.find(name, "fainted ") ~= nil or string.find(name, "defeated ") ~= nil
end

--- Tira tudo de dentro de um corpo e entrega ao jogador.
-- Devolve quantos itens foram movidos e se a mochila encheu.
local function emptyCorpse(cid, corpseUid)
    local moved, full = 0, false

    -- De tras para frente: remover um item reindexa os seguintes, e varrer
    -- para frente faria pular itens.
    for i = getContainerSize(corpseUid) - 1, 0, -1 do
        local item = getContainerItem(corpseUid, i)
        if item and item.uid > 0 then
            -- false = nao deixa cair no chao se nao couber; assim o item
            -- fica no corpo e o jogador pode voltar depois.
            if doPlayerAddItemEx(cid, item.uid, false) == RETURNVALUE_NOERROR then
                moved = moved + 1
            else
                full = true
                break
            end
        end
    end

    return moved, full
end

function onExtendedOpcode(cid, opcode, buffer)
    if opcode ~= config.opcode or not isPlayer(cid) then
        return true
    end

    local now = os.time() * 1000
    local last = getPlayerStorageValue(cid, config.storageCooldown)
    if last and last > 0 and (now - last) < config.cooldownMs then
        return true
    end
    setPlayerStorageValue(cid, config.storageCooldown, now)

    local origin = getCreaturePosition(cid)
    local totalItems, corpses, anyFull = 0, 0, false

    for dx = -config.rangeX, config.rangeX do
        for dy = -config.rangeY, config.rangeY do
            local pos = { x = origin.x + dx, y = origin.y + dy, z = origin.z }

            -- Varremos a pilha inteira do tile em vez de usar getTopCorpse:
            -- aquele devolve so o corpo do topo, e num tile com varios
            -- empilhados os de baixo ficariam para tras.
            for stack = 1, 20 do
                pos.stackpos = stack
                local thing = getTileThingByPos(pos)
                if not thing or thing.uid == 0 then
                    break
                end

                if thing.itemid >= 2 and isCorpse(thing.itemid) and isContainer(thing.uid) then
                    local moved, full = emptyCorpse(cid, thing.uid)
                    if moved > 0 then
                        totalItems = totalItems + moved
                        corpses = corpses + 1
                    end
                    if full then
                        anyFull = true
                    end
                end
            end
        end
    end

    if anyFull then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE,
            "Sua mochila esta cheia. O que sobrou continua nos corpos.")
    elseif totalItems > 0 then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
            "Voce recolheu " .. totalItems .. " " ..
            (totalItems == 1 and "item" or "itens") .. " de " .. corpses .. " " ..
            (corpses == 1 and "corpo" or "corpos") .. ".")
    else
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE,
            "Nao ha nada para recolher por perto.")
    end

    return true
end
