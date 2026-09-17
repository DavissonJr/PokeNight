-- Criado por Thalles Vitor --
-- Dar Items --
local pokemon = "Kadabra"
local items = {
    [1] = {itemList = {2392, 12345}, itemCount = {10, 10}}
}

function onSay(cid, words, param)
    if tonumber(getPlayerStorageValue(cid, 6060)) >= 1 then
        doPlayerSendTextMessage(cid, 25, "Você já coletou suas recompensas.")
        return true
    end

    for i = 1, #items do
        for it = 1, #items[i].itemList do
            doPlayerAddItem(cid, items[i].itemList[it], items[i].itemCount[it])
        end
    end

    doPlayerSendTextMessage(cid, 25, "Você ganhou algumas recompensas: 10 Ultra balls, 10 potions, e 1 Kadabra.")
    doPlayerAddPremiumDays(cid, 0)
    addPokeToPlayer(cid, pokemon, 0, nil, "normal", false)   
    setPlayerStorageValue(cid, 6060, 1)
    doSendMagicEffect(getThingPos(cid), 83)
    return true
end