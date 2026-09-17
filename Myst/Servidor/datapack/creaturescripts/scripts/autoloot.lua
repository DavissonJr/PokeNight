-- Sistema de auto loot criado por Vitor Bertolucci - Killua

local aloot_boost = {[2406] = 36, [2537] = 4800, [2377] = 480, [2663] = 600, [2472] = 195000, [2398] = 36, [2475] = 7200, [2519] = 6500, [2497] = 10700, [2523] = 180000, [2494] = 325000, [2400] = 144000, [2491] = 6000, [2421] = 325000, [2646] = 260000, [2477] = 7200, [2413] = 84, [2656] = 18000, [2498] = 52000, [2647] = 600, [2534] = 32500, [7402] = 19500, [2466] = 26000, [2465] = 240, [2408] = 120000, [2518] = 1800, [2500] = 3000, [2376] = 30, [2470] = 91000, [2388] = 24, [2645] = 26000, [2434] = 2400, [2463] = 480, [2536] = 11700, [2387] = 240, [2396] = 4800, [2381] = 240, [2528] = 4800, [2409] = 1800, [2414] = 12000, [2427] = 9000, [2407] = 7200, [2458] = 42, [2383] = 960, [2392] = 3600, [2488] = 18000, [2525] = 120, [2423] = 240, [7382] = 13000, [2462] = 1300, [2520] = 39000, [2390] = 180000, [2417] = 72, [2436] = 1200, [5741] = 52000, [2378] = 120, [2487] = 24000, [2476] = 6500, [8891] = 36000, [2459] = 36, [2195] = 52000, [2391] = 7200, [2464] = 120, [8889] = 72000, [2432] = 13000, [2431] = 108000, [2492] = 52000, [2515] = 240, [2430] = 2400, [2393] = 13000, [7419] = 36000, [2522] = 130000, [2514] = 65000}

local function getPlayerStorageZero(cid, storage) -- By Killua
    local sto = getPlayerStorageValue(cid, storage)
    if tonumber(sto) then
        return tonumber(sto) > tonumber(0) and tonumber(sto) or tonumber(0)
    end
    return tonumber(0)
end

local tabela = {}

local function getPlayerList(cid)
    local tab = {}
    if getPlayerStorageValue(cid, 04420021) ~= -1 then
        table.insert(tab, getPlayerStorageValue(cid, 04420021))
    end
    if getPlayerStorageValue(cid, 04420031) ~= -1 then
        table.insert(tab, getPlayerStorageValue(cid, 04420031))
    end
    if getPlayerStorageValue(cid, 04420041) ~= -1 then
        table.insert(tab, getPlayerStorageValue(cid, 04420041))
    end
    if getPlayerStorageValue(cid, 04420051) ~= -1 then
        table.insert(tab, getPlayerStorageValue(cid, 04420051))
    end
    if #tab > 0 then
        return tab
    end
    return {}
end

local function boost(cid)
    return tonumber(getPlayerStorageValue(cid,722381)) >= os.time()
end

local function autoLoot(cid, pos)
    if not isPlayer(cid) then return end
    local check = false
    local str = ""
    local position = {}
    for i = 1, 255 do
        pos.stackpos = i
        if getThingFromPos(pos).uid and getThingFromPos(pos).uid > 0 and isContainer(getThingFromPos(pos).uid) then
            position = pos
            check = true
            break
        end
    end
    if check then
        local corpse = getContainerItemsInfo(getThingFromPos(position).uid)        
        if corpse then
            for index, info in pairs(corpse) do
                if index < countTable(corpse) then
                    if info.uid and info.itemid then
                        if isContainer(info.uid) then
                            local bag = getContainerItemsInfo(info.uid)
                            for i = 1, countTable(bag) do
                                if isInArray(getPlayerList(cid), bag.itemid) then
                                    if bag.quant > 1 then
                                        doRemoveItem(bag.uid, bag.quant)
                                        doPlayerAddItem(cid, bag.itemid, bag.quant)
                                        str = str.." "..bag.quant.." "..getItemNameById(bag.itemid).." +"
                                    else
                                        doRemoveItem(bag.uid)
                                        if boost(cid) then
                                            if aloot_boost[bag.itemid] then
                                                doPlayerSetBalance(cid,getPlayerBalance(cid) + aloot_boost[bag.itemid])
                                                str = str.." 1 "..getItemNameById(bag.itemid).." ("..aloot_boost[bag.itemid].."gp no banco) +"
                                            else
                                                doPlayerAddItem(cid, bag.itemid, 1)
                                                str = str.." 1 "..getItemNameById(bag.itemid).." +"
                                            end
                                        else
                                            doPlayerAddItem(cid, bag.itemid, 1)
                                            str = str.." 1 "..getItemNameById(bag.itemid).." +"
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if isInArray(getPlayerList(cid), info.itemid) then
                    if info.quant > 1 then
                        doRemoveItem(info.uid, info.quant)
                        doPlayerAddItem(cid, info.itemid, info.quant)
                        str = str.." "..info.quant.." "..getItemNameById(info.itemid).." +"
                    else
                        doRemoveItem(info.uid)
                        if boost(cid) then
                            if aloot_boost[info.itemid] then
                                doPlayerSetBalance(cid,getPlayerBalance(cid) + aloot_boost[info.itemid])
                                str = str.." 1 "..getItemNameById(info.itemid).." ("..aloot_boost[info.itemid].."gps no banco) +"
                            else
                                doPlayerAddItem(cid, info.itemid, 1)
                                str = str.." 1 "..getItemNameById(info.itemid).." +"
                            end
                        else
                            doPlayerAddItem(cid, info.itemid, 1)
                            str = str.." 1 "..getItemNameById(info.itemid).." +"
                        end
                    end
                end
            end
        end
    end
    setPlayerTableStorage(cid,822564,{[1] = str, [2] = 0})
end

local function autoGold(cid, pos)
    if not isPlayer(cid) then return end
    local check = false
    local total = 0
    local position = {}
    for i = 1, 255 do
        pos.stackpos = i
        if getThingFromPos(pos).uid and getThingFromPos(pos).uid > 0 and isContainer(getThingFromPos(pos).uid) then
            position = pos
            check = true
            break
        end
    end
    if check then
        local corpse = getContainerItemsInfo(getThingFromPos(position).uid)
        if corpse then
            for index, info in pairs(corpse) do
                if info.uid and info.itemid then
                    if index < countTable(corpse) then
                        if isContainer(info.uid) then
                            local bag = getContainerItemsInfo(info.uid)
                            for i = 1, countTable(bag) do
                                if isInArray({2148, 2152, 2160}, bag.itemid) then
                                    local multiplie = 1
                                    if bag.itemid == 2148 then
                                        multiplie = 1
                                    elseif bag.itemid == 2152 then
                                        multiplie = 100
                                    elseif bag.itemid == 2160 then
                                        multiplie = 10000
                                    end
                                    doRemoveItem(bag.uid, bag.quant)
                                    doPlayerSetBalance(cid, getPlayerBalance(cid) + tonumber(bag.quant) * multiplie)
                                    total = total + bag.quant * multiplie
                                    doPlayerSetStorageValue(cid, 04421021, tonumber(getPlayerStorageZero(cid, 04421021)) + tonumber(info.quant) * tonumber(multiplie))
                                end
                            end
                        end
                    end
                    if isInArray({2148, 2152, 2160}, info.itemid) then
                        local multiplie = 1
                        if info.itemid == 2148 then
                            multiplie = 1
                        elseif info.itemid == 2152 then
                            multiplie = 100
                        elseif info.itemid == 2160 then
                            multiplie = 10000
                        end
                        doRemoveItem(info.uid, info.quant)
                        doPlayerSetBalance(cid, getPlayerBalance(cid) + info.quant * multiplie)
                        doPlayerSetStorageValue(cid, 04421021, tonumber(getPlayerStorageZero(cid, 04421021)) + tonumber(info.quant) * tonumber(multiplie))
                        total = total + info.quant * multiplie
                    end
                end
            end
        end
    end
    if total > 0 then
        total = total - (total * 0.2) 
        total = math.ceil(total)
        doPlayerSetBalance(cid,getPlayerBalance(cid) + total)
        local tab = getPlayerTableStorage(cid,822564)
        tab[2] = total
        setPlayerTableStorage(cid,822564,tab)
    end
end

local function sendMsg(cid)
    if not isPlayer(cid) then return end
    local tab = getPlayerTableStorage(cid,822564)
    if countTable(tab) >= 1 then
        if tab[1] then
            if tab[2] and tab[2] > 0 then
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "[Auto Loot System] Coletados: ".. tab[1] .." ".. tab[2] .." gold coins.")
            else
                if type(tab[1]) == "string" and string.len(tab[1]) > 1 then
                    doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "[Auto Loot System] Coletados: "..tab[1])
                end
            end
        elseif not tab[1] then
            if tab[2] then
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "[Auto Loot System] Coletados: "..tab[2].." gold coins.")
            end
        end
    end
    doPlayerSetStorageValue(cid,822564,-1)
end

function onKill(cid, target, lastHit)
    if isPlayer(cid) and isMonster(target) then
        if getPlayerStorageValue(cid, 04421001) == 1 and #getPlayerList(cid) > 0 then
            local pos = getCreaturePosition(target)
            addEvent(autoLoot, 500, cid, pos)
        end
        if getPlayerStorageValue(cid, 04421011) == 1 then
            local pos = getCreaturePosition(target)
            addEvent(autoGold, 540, cid, pos)
        end
        if getPlayerStorageValue(cid, 04421001) == 1 or getPlayerStorageValue(cid, 04421011) == 1 then
            addEvent(sendMsg, 560, cid)
        end
    end
    return true
end