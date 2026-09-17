local posis = {
[{x = 0, y = 0}] = 6600, --colocar quais sao os actions ids das estantes 
[{x = 1, y = 0}] = 6601,
[{x = 2, y = 0}] = 6602,
[{x = 3, y = 0}] = 6603,

[{x = 0, y = 1}] = 6604,  
[{x = 1, y = 1}] = 6605,
[{x = 2, y = 1}] = 6606,
[{x = 3, y = 1}] = 6607,

[{x = 0, y = 2}] = 6608,  
[{x = 1, y = 2}] = 6609,
[{x = 2, y = 2}] = 6610,
[{x = 3, y = 2}] = 6611,

[{x = 0, y = 3}] = 6612,  
[{x = 1, y = 3}] = 6613,
[{x = 2, y = 3}] = 6614,
[{x = 3, y = 3}] = 6615,
}

local iniDirs = {
["A"] = {x = 3, y = 0},
["Z"] = {x = 0, y = 0},
["F"] = {x = 0, y = 3},
["K"] = {x = 3, y = 3},
}

local dirs = {
["M"] = {x = 0, y = 1},
["Y"] = {x = 0, y = -1},
["G"] = {x = -1, y = 0},
["W"] = {x = 1, y = 0},
}

local pri = {"A", "Z", "F", "K"}
local resto = {"M", "Y", "G", "W", "B", "M", "Y", "G", "W"}

function onUse(cid, item, fromPosition, itemEx, toPosition)

if getPlayerItemCount(cid, Agatha.colar) <= 0 then
   return true
elseif getPlayerStorageValue(cid, Agatha.stoIni) ~= 1 then
   return true
elseif getPlayerStorageValue(cid, Agatha.stoRec) ~= 0 then
   return true
elseif getPlayerStorageValue(cid, Agatha.stoEni) ~= -1 then
   doShowTextDialog(cid, 10308, getPlayerStorageValue(cid, Agatha.stoEni)) 
   sendMsgToPlayer(cid, 27, getPlayerStorageValue(cid, Agatha.stoEni))
   return true
end

local enigma = {}
--------////--------- faz o enigma \/
table.insert(enigma, pri[math.random(#pri)])
for i = 1, 20 do --75          
    local rand = resto[math.random(#resto)]
    if i == 1 and rand == "B" then rand = "M" end
    table.insert(enigma, rand)
end
setPlayerStorageValue(cid, Agatha.stoEni, table.concat(enigma))
--------////---------          resolve o enigma \/
local atual = enigma[1]
local rota = iniDirs[atual]
table.remove(enigma, 1)

for i = 1, #enigma do
    local dir = dirs[enigma[1]]
    if not dir then
       dir = dirs[atual]
    end
    local pos = {}
    pos.x = rota.x + dir.x
    pos.y = rota.y + dir.y
    
    if pos.x > 3 then
       pos.x = 0
    elseif pos.x < 0 then
       pos.x = 3
    elseif pos.y > 3 then
       pos.y = 0
    elseif pos.y < 0 then
       pos.y = 3
    end
    rota.x = pos.x
    rota.y = pos.y
    atual = enigma[1] == "B" and atual or enigma[1]
    table.remove(enigma, 1)
end
local action = ""
for a, b in pairs(posis) do
    if a.x == rota.x and a.y == rota.y then
       action = b
       break
    end
end
setPlayerStorageValue(cid, Agatha.stoRes, action)
sendMsgToPlayer(cid, 27, getPlayerStorageValue(cid, Agatha.stoEni))
doShowTextDialog(cid, 10308, getPlayerStorageValue(cid, Agatha.stoEni))
return true
end    
 
--<action actionid="6655" event="script" value="Agatha_Enigma.lua"/>      