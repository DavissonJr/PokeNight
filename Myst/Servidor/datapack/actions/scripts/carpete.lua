-- Criado por Thalles Vitor --
-- Sistema de Carpetes --

local carpetes = {
    [28046] = {new_id = 28047}, -- new-id: id que ele vai se transformar
    [28047] = {new_id = 28046}, -- new_id: id que ele vai se transformar
    
    [28049] = {new_id = 28050}, -- new_id: id que ele vai se transformar
    [28050] = {new_id = 28049}, -- new_id: id que ele vai se transformar

    [28052] = {new_id = 28053}, -- new_id: id que ele vai se transformar
    [28053] = {new_id = 28052}, -- new_id: id que ele vai se transformar

    [28055] = {new_id = 28056}, -- new_id: id que ele vai se transformar
    [28056] = {new_id = 28055}, -- new_id: id que ele vai se transformar

    [28058] = {new_id = 28059}, -- new_id: id que ele vai se transformar
    [28059] = {new_id = 28058}, -- new_id: id que ele vai se transformar

    [28061] = {new_id = 28062}, -- new_id: id que ele vai se transformar
    [28062] = {new_id = 28061}, -- new_id: id que ele vai se transformar

    [28064] = {new_id = 28065}, -- new_id: id que ele vai se transformar
    [28065] = {new_id = 28064}, -- new_id: id que ele vai se transformar

    [28067] = {new_id = 28068}, -- new_id: id que ele vai se transformar
    [28068] = {new_id = 28067}, -- new_id: id que ele vai se transformar

    [28070] = {new_id = 28071}, -- new_id: id que ele vai se transformar
    [28071] = {new_id = 28070}, -- new_id: id que ele vai se transformar

    [28073] = {new_id = 28074}, -- new_id: id que ele vai se transformar
    [28074] = {new_id = 28073}, -- new_id: id que ele vai se transformar

    [28076] = {new_id = 28077}, -- new_id: id que ele vai se transformar
    [28077] = {new_id = 28076}, -- new_id: id que ele vai se transformar

    [28079] = {new_id = 28080}, -- new_id: id que ele vai se transformar
    [28080] = {new_id = 28079}, -- new_id: id que ele vai se transformar

    [28082] = {new_id = 28083}, -- new_id: id que ele vai se transformar
    [28083] = {new_id = 28082}, -- new_id: id que ele vai se transformar

    [28085] = {new_id = 28086}, -- new_id: id que ele vai se transformar
    [28086] = {new_id = 28085}, -- new_id: id que ele vai se transformar

    [28088] = {new_id = 28089}, -- new_id: id que ele vai se transformar
    [28089] = {new_id = 28088}, -- new_id: id que ele vai se transformar

    [28091] = {new_id = 28092}, -- new_id: id que ele vai se transformar
    [28092] = {new_id = 28091}, -- new_id: id que ele vai se transformar

    [28094] = {new_id = 28095}, -- new_id: id que ele vai se transformar
    [28095] = {new_id = 28094}, -- new_id: id que ele vai se transformar

    [28097] = {new_id = 28098}, -- new_id: id que ele vai se transformar
    [28098] = {new_id = 28097}, -- new_id: id que ele vai se transformar

    [28117] = {new_id = 28118}, -- new_id: id que ele vai se transformar
    [28118] = {new_id = 28117}, -- new_id: id que ele vai se transformar

    [28119] = {new_id = 28120}, -- new_id: id que ele vai se transformar
    [28120] = {new_id = 28119}, -- new_id: id que ele vai se transformar

    [28121] = {new_id = 28122}, -- new_id: id que ele vai se transformar
    [28122] = {new_id = 28121}, -- new_id: id que ele vai se transformar

    [28123] = {new_id = 28124}, -- new_id: id que ele vai se transformar
    [28124] = {new_id = 28123}, -- new_id: id que ele vai se transformar
}

function onUse(cid, item)
    local carpete = carpetes[item.itemid]
    if not carpete then
        print("Carpete com o ID: " .. item.itemid .. " nao esta registrado na tabela: carpetes.")
        return true
    end

    if item.type > 1 then
        doPlayerSendTextMessage(cid, 25, "Separe o item.")
        return true
    end

    doTransformItem(item.uid, carpete.new_id)
    return true
end