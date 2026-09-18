-- Cofre: depositar e sacar dinheiro sem precisar do NPC do banco.
--
-- Nao cria um saldo paralelo. Opera sobre o mesmo players.balance que o
-- NPC Bank ja usa, pelas mesmas funcoes do datapack -- ter dois lugares
-- para guardar dinheiro so confundiria o jogador.
--
-- Canal: extendedopcode 151, o mesmo mecanismo do autoloot e do loot em
-- area. Protocolo intacto, nada para recompilar.
--
-- Mensagens que chegam do cliente:
--   saldo
--   depositar@<quantia>   ou  depositar@tudo
--   sacar@<quantia>       ou  sacar@tudo
-- A resposta e sempre: <saldo>@<carteira>@<mensagem>

local OPCODE = 151

--- Manda saldo, dinheiro na mao e um aviso para o cliente desenhar.
local function reply(cid, message)
    local payload = table.concat({
        getPlayerBalance(cid),
        getPlayerMoney(cid),
        message or ''
    }, '@')
    doSendPlayerExtendedOpcode(cid, OPCODE, payload)
end

function onExtendedOpcode(cid, opcode, buffer)
    if opcode ~= OPCODE or not isPlayer(cid) then
        return true
    end

    local parts = string.explode(buffer or '', '@')
    local action = parts[1] or ''
    local raw = parts[2] or ''

    if action == 'saldo' then
        reply(cid)
        return true
    end

    local isAll = (raw == 'tudo')
    local amount = tonumber(raw)

    -- Quantia invalida: nao adianta seguir e deixar o servidor decidir.
    if not isAll and (not amount or amount <= 0) then
        reply(cid, 'Informe um valor maior que zero.')
        return true
    end

    if action == 'depositar' then
        local ok
        if isAll then
            ok = doPlayerDepositAllMoney(cid)
        else
            ok = doPlayerDepositMoney(cid, amount)
        end
        if ok then
            reply(cid, 'Deposito feito.')
        else
            reply(cid, 'Voce nao tem esse dinheiro na mao.')
        end

    elseif action == 'sacar' then
        local ok
        if isAll then
            ok = doPlayerWithdrawAllMoney(cid)
        else
            ok = doPlayerWithdrawMoney(cid, amount)
        end
        if ok then
            reply(cid, 'Saque feito.')
        else
            -- Pode faltar saldo ou faltar espaco na mochila; o jogador
            -- precisa saber que as duas coisas sao possiveis.
            reply(cid, 'Saldo insuficiente ou mochila sem espaco.')
        end

    else
        reply(cid, 'Acao desconhecida.')
    end

    return true
end
