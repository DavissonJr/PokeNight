-- Criado por Thalles Vitor --
-- Auto Catch --
local storage = 9480
local storage2 = 9481

local ballcatch = {                    --id normal, id da ball shiy
[2394] = {cr = 8, on = 24, off = 23, ball = {11826, 11737}, send = 47, typeee = "normal"},  --alterado v1.9  \/
[2391] = {cr = 10, on = 198, off = 197, ball = {11832, 11740}, send = 48, typeee = "great"},
[2393] = {cr = 12, on = 202, off = 201, ball = {11835, 11743}, send = 46, typeee = "super"},
[2392] = {cr = 14, on = 200, off = 199, ball = {11829, 11746}, send = 49, typeee = "ultra"},
[13248] = {cr = 9999, on = 200, off = 199, ball = {11829, 11746}, send = 49, typeee = "Premium"},
[12617] = {cr = 3, on = 204, off = 203, ball = {10975, 12621}, send = 35, typeee = "saffari"}, 
[28197] = {cr = 100, on = 295, off = 295, ball = {28198, 28199}, send = 1, typeee = "master"},
}

function onWalk(cid, oldPos, newPos)
    if not isPlayer(cid) then
        return true
    end

    if getPlayerStorageValue(cid, storage) ~= "" then
        local item2 = getTopCorpse(newPos)
        if item2.uid <= 0 then
            return true
        end

        for k, v in pairs(ballcatch) do
            if v.typeee == getPlayerStorageValue(cid, storage) then
                if getPlayerItemCount(cid, k, -1) >= 1 then
                    local catchAttr = tonumber(getItemAttribute(item2.uid, "catching"))
                    if catchAttr == 1 then
                        return true
                    end  

                    local name = string.lower(getItemNameById(item2.itemid))  --alterado v1.9 \/
                        name = string.gsub(name, "fainted ", "")
                        name = string.gsub(name, "defeated ", "")
                        name = doCorrectString(name)

                    if getPlayerStorageValue(cid, storage2) ~= name then
                        return true
                    end

                    local x = pokecatches[name]
                    if not x then 
                       -- doPlayerSendTextMessage(cid, 25, "1 - Você não pode capturar o pokémon: " .. name .. " relate ao administrador.")
                        return true
                    end
                        
                    local storage = newpokedex[name]
                    if not storage then
                       -- doPlayerSendTextMessage(cid, 25, "2 - Você não pode capturar o pokémon: " .. name .. " relate ao administrador.")
                        return true
                    end

                    storage = storage.stoCatch

                    local owner = tonumber(getItemAttribute(item2.uid, "corpseowner")) or 0
                    if owner and isCreature(owner) and isPlayer(owner) and cid ~= owner then   
                       -- doPlayerSendCancel(cid, "You are not allowed to catch this pokemon.")
                        return true
                    end

                    local newidd = isShinyName(name) and v.ball[2] or v.ball[1] --alterado v1.9       
                    local typeee = v.typeee
                    local restrictions = {"Moltres", "Articuno", "Zapdos", "Mew", "Mewtwo", "Entei", "Raikou", "Suicune", "Lugia", "Ho-oh", "Darkrai",}
                    if isInArray(restrictions, name) then
                        return true
                    end
                    
                    local catchinfo = {}
                        catchinfo.rate = v.cr
                        catchinfo.catch = v.on
                        catchinfo.fail = v.off
                        catchinfo.newid = newidd                      
                        catchinfo.name = doCorrectPokemonName(name)
                        catchinfo.topos = newPos
                        catchinfo.chance = x.chance

                    doSendDistanceShoot(getThingPos(cid), newPos, v.send)

                    local d = getDistanceBetween(getThingPos(cid), newPos)
                            
                    if getPlayerStorageValue(cid, 98796) >= 1 and getPlayerItemCount(cid, 12617) <= 0 then  --alterado v1.9
                        setPlayerStorageValue(cid, 98796, -1) 
                        setPlayerStorageValue(cid, 98797, -1)                                              
                        doTeleportThing(cid, SafariOut, false)
                        doSendMagicEffect(getThingPos(cid), 21)
                        doPlayerSendTextMessage(cid, 27, "You spend all your saffari balls, good luck in the next time...")
                    end

                    doSendPokeBall(cid, catchinfo, false, false, typeee) 
                    doSendMagicEffect(newPos, 3)
                    doPlayerRemoveItem(cid, k, 1)
                end
            end
        end
    end
    return true
end