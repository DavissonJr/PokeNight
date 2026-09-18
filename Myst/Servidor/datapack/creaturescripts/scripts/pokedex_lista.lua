-- Pokedex: informa ao cliente o que este personagem ja capturou.
--
-- A lista completa de pokemons ja vive no cliente
-- (modules/game_pokedex/pokedex_list.lua, gerada de newpokedex). Aqui so
-- respondemos QUAIS foram pegos, para a tela marcar.
--
-- O cliente manda os storages de captura que quer consultar, separados por
-- virgula, e recebe de volta so os que estao marcados. Assim nao varremos
-- as 731 entradas a cada abertura, e a resposta acompanha o tamanho da
-- colecao, nao o tamanho da pokedex.
--
-- Canal: extendedopcode 152.

local OPCODE = 152

-- Cada storage vira ate 7 caracteres na resposta. O limite evita montar
-- uma string grande demais para o protocolo num pedido malformado.
local MAX_IDS = 900

function onExtendedOpcode(cid, opcode, buffer)
    if opcode ~= OPCODE or not isPlayer(cid) then
        return true
    end

    local caught = {}
    local count = 0

    for _, raw in ipairs(string.explode(buffer or '', ',')) do
        local storage = tonumber(raw)
        if storage then
            count = count + 1
            if count > MAX_IDS then
                break
            end
            -- getPlayerStorageValue devolve -1 quando nunca foi escrito.
            if getPlayerStorageValue(cid, storage) > 0 then
                table.insert(caught, storage)
            end
        end
    end

    doSendPlayerExtendedOpcode(cid, OPCODE, table.concat(caught, ','))
    return true
end
