-- Criado por Thalles Vitor --
-- Outfits --

local speed = 3000
local outfits =
{
    [28221] = 
    {
        [0] = {outfit = 3225},
        [1] = {outfit = 3225},
    },

    [28222] = 
    {
        [0] = {outfit = 3044},
        [1] = {outfit = 3044},
    },

    [28223] = 
    {
        [0] = {outfit = 56},
        [1] = {outfit = 56},
    },

    [28224] = 
    {
        [0] = {outfit = 3084},
        [1] = {outfit = 3084},
    },

    [28225] = 
    {
        [0] = {outfit = 3096},
        [1] = {outfit = 3096},
    },

    [28226] = 
    {
        [0] = {outfit = 3082},
        [1] = {outfit = 3082},
    },

    [28229] = 
    {
        [0] = {outfit = 3093},
        [1] = {outfit = 3093},
    },

    [28230] = 
    {
        [0] = {outfit = 3092},
        [1] = {outfit = 3092},
    },
}

local outfitStorage = 28787
function onUse(cid, item)
    local tabela = outfits[item.itemid]
    if not tabela then
        print("A outfit: " .. item.itemid .. " não está registrada!")
        return true
    end

    tabela = tabela[getPlayerSex(cid)]
    if not tabela then
        print("O sexo: " .. getPlayerSex(cid) .. " não está registrado na outfit: " .. item.itemid .. ".")
        return true
    end

    if getPlayerSlotItem(cid, CONST_SLOT_RING).uid ~= item.uid then
        doPlayerSendTextMessage(cid, 25, "Coloque a outfit no slot correto.")
        return true
    end

    local stor1 = tonumber(getPlayerStorageValue(cid, 17000)) or 0
    local stor2 = tonumber(getPlayerStorageValue(cid, 17001)) or 0
    local stor3 = tonumber(getPlayerStorageValue(cid, 63215)) or 0
    if stor1 >= 1 or stor2 >= 1 or stor3 >= 1 then
        doPlayerSendTextMessage(cid, 25, "Não pode usar a outfit em situação especial.")
        return true
    end

    local stor = tonumber(getPlayerStorageValue(cid, outfitStorage)) or 0
    if stor > 0 then
        setPlayerStorageValue(cid, outfitStorage, 0)
        doItemEraseAttribute(item.uid, "using")
        doRemoveCondition(cid, CONDITION_OUTFIT)
        
        doRegainSpeedLevel(cid)
    else
        doChangeSpeed(cid, -getCreatureSpeed(cid))
        doChangeSpeed(cid, speed)
        doSetCreatureOutfit(cid, {lookType = tabela.outfit, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}, -1)

        setPlayerStorageValue(cid, outfitStorage, 1)
        doItemSetAttribute(item.uid, "using", 1)
    end
    return true
end