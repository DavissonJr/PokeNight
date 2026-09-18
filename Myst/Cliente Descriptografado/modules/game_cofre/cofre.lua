-- Cofre: guardar e sacar dinheiro sem caminhar ate o NPC do banco.
--
-- Nao ha saldo proprio: tudo opera sobre o mesmo players.balance que o NPC
-- Bank usa. Quem faz a conta e o servidor
-- (creaturescripts/scripts/cofre.lua); aqui so mandamos a intencao e
-- desenhamos a resposta.

local OPCODE = 151

cofreWindow = nil
cofreButton = nil

local function widget(id)
    if not cofreWindow or cofreWindow:isDestroyed() then
        return nil
    end
    return cofreWindow:recursiveGetChildById(id)
end

--- Separador de milhar: saldo de banco fica ilegivel sem isso.
local function formatMoney(value)
    local n = tostring(tonumber(value) or 0)
    local formatted = n
    while true do
        local replaced
        formatted, replaced = formatted:gsub('^(-?%d+)(%d%d%d)', '%1.%2')
        if replaced == 0 then
            break
        end
    end
    return formatted
end

local function send(action, amount)
    if not g_game.isOnline() then
        return
    end
    local protocol = g_game.getProtocolGame()
    if not protocol then
        return
    end
    protocol:sendExtendedOpcode(OPCODE, action .. '@' .. (amount or ''))
end

--- Resposta do servidor: <saldo>@<carteira>@<mensagem>
local function onServerReply(protocol, opcode, buffer)
    if opcode ~= OPCODE then
        return
    end

    local parts = string.split(buffer, '@')
    local balance = tonumber(parts[1]) or 0
    local wallet = tonumber(parts[2]) or 0
    local message = parts[3] or ''

    local b = widget('balanceValue')
    if b then
        b:setText(formatMoney(balance))
    end
    local w = widget('walletValue')
    if w then
        w:setText(formatMoney(wallet))
    end
    local s = widget('statusLabel')
    if s then
        s:setText(message)
    end
end

local function amountFromField()
    local field = widget('amountEdit')
    if not field then
        return nil
    end
    -- Aceita o que o jogador digitar com pontos, como o valor e exibido.
    return tonumber((field:getText():gsub('[%.%s]', '')))
end

function deposit(all)
    if all then
        return send('depositar', 'tudo')
    end
    local amount = amountFromField()
    if not amount or amount <= 0 then
        local s = widget('statusLabel')
        if s then
            s:setText('Digite um valor maior que zero.')
        end
        return
    end
    send('depositar', amount)
end

function withdraw(all)
    if all then
        return send('sacar', 'tudo')
    end
    local amount = amountFromField()
    if not amount or amount <= 0 then
        local s = widget('statusLabel')
        if s then
            s:setText('Digite um valor maior que zero.')
        end
        return
    end
    send('sacar', amount)
end

function toggle()
    if not cofreWindow then
        return
    end
    if cofreWindow:isVisible() then
        cofreWindow:hide()
        if cofreButton then
            cofreButton:setOn(false)
        end
    else
        cofreWindow:show()
        cofreWindow:raise()
        cofreWindow:focus()
        if cofreButton then
            cofreButton:setOn(true)
        end
        -- Sempre pede o saldo ao abrir: ele pode ter mudado no NPC, numa
        -- compra ou noutro personagem da conta.
        send('saldo')
    end
end

function init()
    connect(g_game, { onGameEnd = hide })
    ProtocolGame.registerExtendedOpcode(OPCODE, onServerReply)

    cofreWindow = g_ui.displayUI('cofre')
    cofreWindow:hide()

    cofreButton = modules.client_topmenu.addRightGameToggleButton(
        'cofreButton', tr('Cofre'), '/images/topbuttons/bank', toggle)
end

function terminate()
    disconnect(g_game, { onGameEnd = hide })
    ProtocolGame.unregisterExtendedOpcode(OPCODE)

    if cofreWindow then
        cofreWindow:destroy()
        cofreWindow = nil
    end
    if cofreButton then
        cofreButton:destroy()
        cofreButton = nil
    end
end

function hide()
    if cofreWindow then
        cofreWindow:hide()
    end
    if cofreButton then
        cofreButton:setOn(false)
    end
end
