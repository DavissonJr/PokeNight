-- Criado por Thalles Vitor --
-- Sistema de SHOP --

SHOP_CATEGORIES = {"Account", "Itens", "Addons", "Outfits"}
SHOP_PRODUCTS =
{
    ["Account"] =
    {
        [1] =
        {
            name = "30 Dias de VIP",
            price = 10,
            count = 1,
            itemId = 10503,
        },

        [2] =
        {
            name = "Troca de Sexo",
            price = 2,
            count = 1,
            itemId = 12577,
        },

        [3] =
        {
            name = "Troca de Nome",
            price = 4,
            count = 1,
            itemId = 1954,
        },
    },

    ["Itens"] =
    {
        [1] =
        {
            name = "Shiny Stone",
            price = 7,
            count = 1,
            itemId = 13088,
        },

        [2] =
        {
            name = "Boost Stone",
            price = 5,
            count = 1,
            itemId = 12618,
        },

        [3] =
        {
            name = "Velocity Boot",
            price = 30,
            count = 1,
            itemId = 2641,
        },

        [4] =
        {
            name = "Bike Box",
            price = 7,
            count = 1,
            itemId = 12939,
        },

        [5] =
        {
            name = "Addon Box",
            price = 5,
            count = 1,
            itemId = 2183,
        },

        [6] =
        {
            name = "Golden Addon Box",
            price = 7,
            count = 1,
            itemId = 27987,
        },
    },

    ["Addons"] =
    {

    },

    ["Outfits"] =
    {
        [1] =
        {
            name = "Stylish",
            price = 20,
            count = 1,
            itemId = 28221,
        },

        [2] =
        {
            name = "Hot Dog",
            price = 20,
            count = 1,
            itemId = 28222,
        },

        [3] =
        {
            name = "Kaito",
            price = 20,
            count = 1,
            itemId = 28223,
        },

        [4] =
        {
            name = "Huntress",
            price = 20,
            count = 1,
            itemId = 28224,
        },

        [5] =
        {
            name = "Cute",
            price = 20,
            count = 1,
            itemId = 28225,
        },

        [6] =
        {
            name = "Harley Quinn",
            price = 20,
            count = 1,
            itemId = 28226,
        },

        [7] =
        {
            name = "Loba",
            price = 20,
            count = 1,
            itemId = 28229,
        },

        [7] =
        {
            name = "Lobo",
            price = 20,
            count = 1,
            itemId = 28230,
        },
    },
}

SHOPDESTROY_OPCODE = 4
SHOP_CATEGORYOPCODE = 5
SHOP_OPENOPCODE = 6

function getPlayerPoints(cid)
	if not isPlayer(cid) then
		return 0
	end

	local pontos = 0
	local resultado = db.getResult("SELECT `premium_points` FROM `accounts` WHERE `id` = " .. getPlayerAccountId(cid) .. ";")
	if resultado:getID() ~= -1 then
		pontos = resultado:getDataInt("premium_points")
	end
	return pontos
end

function onSendShopWindow(cid, type)
    if not isPlayer(cid) then
        return true
    end
    
    doSendPlayerExtendedOpcode(cid, SHOPDESTROY_OPCODE, "")
    for i = 1, #SHOP_CATEGORIES do
        doSendPlayerExtendedOpcode(cid, SHOP_CATEGORYOPCODE, SHOP_CATEGORIES[i].."@")
    end

    local tabela = SHOP_PRODUCTS[type]
    if not tabela then
        print("Categoria: " .. type .. " nao registrada.")
        return true
    end

    for i = 1, #tabela do
        doSendPlayerExtendedOpcode(cid, SHOP_OPENOPCODE, getItemInfo(tabela[i].itemId).clientId.."@"..tabela[i].name.."@"..tabela[i].price.."@"..getPlayerPoints(cid).."@")
    end
    return true
end