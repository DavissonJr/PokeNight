-- Criado por Thalles Vitor --
-- Sistema de Passivas --

PASSIVES_POKEMONS =
{
    ["Gloom"] =
    {
        ["Spores Reaction"] = {chance = 35, target = 0},
        ["Absorb"] = {chance = 35, target = 1},
    },

    ["Psyduck"] =
    {
        ["Stunning Confusion"] = {chance = 35, target = 0},
    },
}

function docastpassive(cid)
    if not isCreature(cid) then
        return true
    end

    local tabela = PASSIVES_POKEMONS[getCreatureName(cid)]
    if tabela then
        for k, v in pairs(tabela) do
            if v.target == 1 and not isCreature(getCreatureTarget(cid)) then
                return true
            end

            local chance = math.random(1, 100)
            if chance == v.chance then
               -- doCreatureSay(cid, k, TALKTYPE_MONSTER)
                docastspell(cid, k)
            end
        end
    end
    return true
end