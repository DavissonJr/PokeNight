-- Criado por Thalles Vitor --
-- Sistema de Auto Loot Janela --

optionsAvaiable = {"Items", "Stones", "TMs"} -- opcoes do auto loot disponiveis (adicione la embaixo e aqui)
autoloot_send_options_opcodes = 170 -- opcode que vai enviar de volta apos receber
autoloot_send_items_opcode = 106 -- opcode que vai enviar de volta apos receber (enviar items do aloot)
autoloot_send_destroyCHILD_opcode = 107 -- opcode que vai enviar de volta apos receber (remover os widgets antigos e criar novos)
autoloot_send_items_opcode2 = 108 -- opcode que vai enviar de volta apos receber (enviar items do aloot (troca de categoria))
autoloot_send_items_added_opcode = 109 -- opcode que vai enviar de volta apos receber (enviar items adicionados pelo player)

-- Categorias de Items
local items = {
    ["Items"] =
    {
        item_id = {12142, 12148, 12149, 12150, 12151, 12152, 12153, 12154, 12155, 12157, 12158, 12159, 12161, 12162, 12163, 12165, 12170, 12171, 12173, 12176, 12177, 12337, 12164, 12182, 12193, 12204, 12194, 12334, 12207, 12188, 12181, 12200, 12172, 12195, 12192, 12169, 12186, 12180, 12198, 12647, 12187, 2174, 2159, 2318, 12205, 12341, 12197, 12232, 2183}, -- id dos items
        item_name = {"iron piece", "gyarados tail", "teal feather", "yellow feather", "red feather", "pot of lava", "bag of pollem", "bulb", "pair of leaves",
        "nail", "turtle hull", "dragon tooth", "water gem", "essence of fire", "seed", "bottle of poison", "water pendant", "pot of moss bug", "apple bite", "electric box",
        "sandbag", "small stone", "screw", "bat wing", "twisted spoon", "trace of ghost", "future orb", "remains of magikarp", "crab claw", "ruby", "fur", "feather", "bird beak", "champion belt", "iron bracelet", "buzz tail", "luck medalion", "fox tail", "imam", "rat tail", "wool ball", "strange symbol", "scarab coin", "brooch", "onix tail", "blue vine", "slowpoke tail", "metal coat", "Addon Box"}, -- nome dos items
    },

    ["Stones"] =
    {
        item_id = {11442, 11447, 11443, 11444, 11445, 11446, 11448, 11449, 11450, 11451, 11452, 11453, 11441, 28195}, -- id dos items
        item_name = {"Water Stone", "Fire Stone", "Venom Stone", "Thunder Stone", "Rock Stone", "Punch Stone", "Cocoon Stone", "Crystal Stone",
        "Darkness Stone", "Earth Stone", "Enigma Stone", "Heart Stone", "Leaf Stone", "Ice Stone"}, -- nome dos items
    },

    ["TMs"] =
    {
        item_id = {28232, 28233, 28234, 28235, 28236, 28237, 28238, 28239, 28240, 28241, 28242, 28243}, -- id dos items
        item_name = {"TM01 - Dazzling Gleam", "TM02 - Bulldoze", "TM03 - Roost", "TM04 - Grass Pledge", "TM05 - Rock Slide",
        "TM06 - Incinerate", "TM07 - Magical Leaf", "TM08 - Blizzard", "TM09 - Toxic", "TM10 - Thunder Wave", "TM11 - Punch Flames",
        "TM12 - Flare Blitz"}, -- nome dos items
    }
}

-- Items disponiveis do auto loot que sao os de cima (nome do item e id: id do item)
local items_avaiables = {
    -- Stones
    ["Water Stone"] = {id = 11442},
    ["Fire Stone"] = {id = 11447},
    ["Venom Stone"] = {id = 11443},
    ["Thunder Stone"] = {id = 11444},
    ["Rock Stone"] = {id = 11445},
    ["Punch Stone"] = {id = 11446},
    ["Cocoon Stone"] = {id = 11448},
    ["Crystal Stone"] = {id = 11449},
    ["Darkness Stone"] = {id = 11450},
    ["Earth Stone"] = {id = 11451},
    ["Enigma Stone"] = {id = 11452},
    ["Heart Stone"] = {id = 11453},
    ["Leaf Stone"] = {id = 11441},
    ["Ice Stone"] = {id = 28195},

    -- Items
    ["iron piece"] = {id = 12142},
    ["gyarados tail"] = {id = 12148},
    ["teal feather"] = {id = 12149},
    ["yellow feather"] = {id = 12150},
    ["red feather"] = {id = 12151},
    ["pot of lava"] = {id = 12152},
    ["bag of pollem"] = {id = 12153},
    ["bulb"] = {id = 12154},
    ["pair of leaves"] = {id = 12155},
    ["nail"] = {id = 12157},
    ["turtle hull"] = {id = 12158},
    ["dragon tooth"] = {id = 12159},
    ["water gem"] = {id = 12161},
    ["essence of fire"] = {id = 12162},
    ["seed"] = {id = 12163},
    ["bottle of poison"] = {id = 12165},
    ["water pendant"] = {id = 12170},
    ["pot of moss bug"] = {id = 12171},
    ["apple bite"] = {id = 12173},
    ["electric box"] = {id = 12176},
    ["sandbag"] = {id = 12177},
    ["small stone"] = {id = 12337},
    ["screw"] = {id = 12164},
    ["bat wing"] = {id = 12182},

    ["twisted spoon"] = {id = 12193},
    ["trace of ghost"] = {id = 12204},
    ["future orb"] = {id = 12194},
    ["remains of magikarp"] = {id = 12334},
    ["crab claw"] = {id = 12207},
    ["ruby"] = {id = 12188},
    ["fur"] = {id = 12181},
    ["feather"] = {id = 12200},
    ["bird beak"] = {id = 12172},
    ["champion belt"] = {id = 12195},
    ["iron bracelet"] = {id = 12192},
    ["buzz tail"] = {id = 12169},
    ["luck medalion"] = {id = 12186},
    ["fox tail"] = {id = 12180},
    ["imam"] = {id = 12198},
    ["rat tail"] = {id = 12647},
    ["wool ball"] = {id = 12187},
    ["strange symbol"] = {id = 2174},
    ["scarab coin"] = {id = 2159},
    ["brooch"] = {id = 2318},
    ["onix tail"] = {id = 12205},
    ["blue vine"] = {id = 12341},
    ["slowpoke tail"] = {id = 12197},
    ["metal coat"] = {id = 12232},
    ["Addon Box"] = {id = 2183},

    -- TMs
    ["TM01 - Dazzling Gleam"] = {id = 28232},
    ["TM02 - Bulldoze"] = {id = 28233},
    ["TM03 - Roost"] = {id = 28234},
    ["TM04 - Grass Pledge"] = {id = 28235},
    ["TM05 - Rock Slide"] = {id = 28236},
    ["TM06 - Incinerate"] = {id = 28237},
    ["TM07 - Magical Leaf"] = {id = 28238},
    ["TM08 - Blizzard"] = {id = 28239},
    ["TM09 - Toxic"] = {id = 28240},
    ["TM10 - Thunder Wave"] = {id = 28241},
    ["TM11 - Punch Flames"] = {id = 28242},
    ["TM12 - Flare Blitz"] = {id = 28243},
}

-- Receber o opcode vindo do otclient
function onReceiveFirstOpcode(playerId, param)
    if not isPlayer(playerId) then
        --print("Player nï¿½o encontrado!")
        return false
    end

    if param == "Items" then
        for i = 1, #optionsAvaiable do
            doSendPlayerExtendedOpcode(playerId, autoloot_send_options_opcodes, optionsAvaiable[i])
        end

        sendAutoLootItems(playerId, param)
    end

    if param == "Stones" then
        for i = 1, #optionsAvaiable do
            doSendPlayerExtendedOpcode(playerId, autoloot_send_options_opcodes, optionsAvaiable[i])
        end

        sendAutoLootItems(playerId, param)
        onReceiveItemsAdded(playerId)
    end
    return true
end

-- Enviar a lista de items de autoloot
function sendAutoLootItems(playerId, category)
    if not isPlayer(playerId) then
        --print("Player nï¿½o encontrado!")
        return false
    end

    local item_list = items[category]
    if item_list then
        local itemid = item_list.item_id
        local itemname = item_list.item_name
        if #itemid < #itemname then
            print("[AUTO LOOT ERROR] - The size of the list itemid is different of the size list itemname.")
            return false
        end

        if #itemname < #itemid then
            print("[AUTO LOOT ERROR] - The size of the list itemname is different of the size list itemid.")
            return false
        end

        for i = 1, #itemid do
            doSendPlayerExtendedOpcode(playerId, autoloot_send_items_opcode, getItemInfo(itemid[i]).clientId.."@"..itemname[i].."@"..tostring(getAutoLootEnabled(playerId)).."@")
        end
    end
    return true
end

-- Mudar a categoria do auto loot
function onChangeCategory(playerId, category)
    if not isPlayer(playerId) then
        --print("Player nï¿½o encontrado!")
        return false
    end

    local item_list = items[category]
    if item_list then
        doSendPlayerExtendedOpcode(playerId, autoloot_send_destroyCHILD_opcode, "destroy".."@")
        
        local itemid = item_list.item_id
        local itemname = item_list.item_name
        if #itemid < #itemname then
            print("[AUTO LOOT ERROR] - The size of the list itemid is different of the size list itemname.")
            return false
        end

        if #itemname < #itemid then
            print("[AUTO LOOT ERROR] - The size of the list itemname is different of the size list itemid.")
            return false
        end

        for i = 1, #itemid do
            doSendPlayerExtendedOpcode(playerId, autoloot_send_items_opcode2, getItemInfo(itemid[i]).clientId.."@"..itemname[i].."@"..tostring(getAutoLootEnabled(playerId)).."@")
        end
    end

    --onReceiveItemsAdded(playerId)
    return true
end

-- Receber os items adicionados pelo jogador
function onReceiveItemsAdded(playerId)
    if not isPlayer(playerId) then
        --print("Player nï¿½o encontrado!")
        return false
    end

    local tabela = getPlayerAutoLootList(playerId)
    for i = 1, #tabela do
        local table_itemname = items_avaiables[tabela[i]]
        if table_itemname then
            local item_id = table_itemname.id -- id do item
            doSendPlayerExtendedOpcode(playerId, autoloot_send_items_added_opcode, getItemInfo(item_id).clientId.."@"..tabela[i].."@")
        end
    end
    return true
end

-- Adicionar o item na lista do auto loot
function onAddItemAutoLootList(playerId, item_name)
    if not isPlayer(playerId) then
        --print("Player nï¿½o encontrado!")
        return false
    end

    local tabela = getPlayerAutoLootList(playerId)
    if isInArray(tabela, item_name) then
        doPlayerSendTextMessage(playerId, 22, "[AUTO LOOT] - Você já tem o item: " .. item_name .. " na sua lista de auto loot.")
    else
        doPlayerSendTextMessage(playerId, 25, "[AUTO LOOT] - Você adicionou o item: " .. item_name .. " na sua lista de auto loot.")
        doPlayerAddAutoLootItem(playerId, item_name) -- Source Function Add in List
        --onReceiveItemsAdded(playerId) -- send to the client items added (removed !!)

        -- Added (V2.0) - not use the default function of the login: onReceiveItemsAdded
        local table_itemname = items_avaiables[item_name]
        if not table_itemname then
            print("[AUTO LOOT ERROR] - The item with name: " .. item_name .. " not found in table.")
            return false
        end

        local item_id = table_itemname.id -- id do item
        doSendPlayerExtendedOpcode(playerId, autoloot_send_items_added_opcode, getItemInfo(item_id).clientId.."@"..item_name.."@")
    end
    return true
end

-- Remover o item da lista do auto loto
function onRemoveItemAutoLootList(playerId, item_name)
    if not isPlayer(playerId) then
        --print("Player nï¿½o encontrado!")
        return false
    end

    local tabela = getPlayerAutoLootList(playerId)
    if isInArray(tabela, item_name) then
        doPlayerSendTextMessage(playerId, 25, "[AUTO LOOT] - Você removeu o item: " .. item_name .. " da sua lista de auto loot.")
        doPlayerRemoveAutoLootItem(playerId, item_name) -- Source Function Remove of List

        doSendPlayerExtendedOpcode(playerId, autoloot_send_destroyCHILD_opcode, "destroyAddedItem".."@")
        onReceiveItemsAdded(playerId) -- send to the client items added (removed !!)
    else
        doPlayerSendTextMessage(playerId, 22, "[AUTO LOOT] - Você não tem o item: " .. item_name .. " na sua lista de auto loot.")
    end
    return true
end

-- Mudar o status do auto loot (ligado ou desligado)
function onAutoLootChangeStatus(playerId, status)
    if not isPlayer(playerId) then
        --print("Player nï¿½o encontrado!")
        return false
    end

    if status == "ligar" then
        doPlayerSendTextMessage(playerId, 25, "[AUTO LOOT] - Você ligou o seu auto loot!")
        doPlayerEnabledAutoLoot(playerId, 1)
    else if status == "desligar" then
        doPlayerSendTextMessage(playerId, 22, "[AUTO LOOT] - Você desligou o seu auto loot!")
        doPlayerEnabledAutoLoot(playerId, 0)
        end
    end
    return true
end

-- Pesquisar item do Auto Loot
function onSearchAutoLootItem(playerId, itemName, category)
    if not isPlayer(playerId) then
        --print("Player nï¿½o encontrado!")
        return true
    end

    if itemName == "none" then
        onChangeCategory(playerId, category)
        return true
    end

    local tabela = items[category]
    if not tabela then return true end

    for i = 1, #tabela.item_name do
        if string.find(string.lower(tabela.item_name[i]), string.lower(itemName)) then
            doSendPlayerExtendedOpcode(playerId, autoloot_send_items_opcode2, getItemInfo(tabela.item_id[i]).clientId.."@"..tabela.item_name[i].."@"..tostring(getAutoLootEnabled(playerId)).."@")
        end
    end
    return true
end
