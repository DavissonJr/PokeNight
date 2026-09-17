local outfits = {
    [6] = {eff = 267},
    [3035] = {eff = 53},
    [10] = {eff = 18},
    [4] = {eff = 270},
}

local botaStorage = 22032
function onWalk(cid, oldPos, newPos)
    if not isPlayer(cid) then
        return true
    end

    local stor = tonumber(getPlayerStorageValue(cid, botaStorage)) or 0
    if stor >= 1 then
        --[[ doSendMagicEffect(oldPos, 12) ]]
        doSendMagicEffect(oldPos, 28)
        addEvent(doSendMagicEffect, 600, newPos, 265)
    end

    local oldPoss = oldPos
    local outfit = outfits[getCreatureOutfit(cid).lookType]
    if outfit then
         addEvent(function()
            doSendMagicEffect(oldPoss, outfit.eff)
        end, 1)
    end
    return true
end