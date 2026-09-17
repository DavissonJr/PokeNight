local s = {
--[action id] = {pos de volta}
[33691] = {x=742,y=1328,z=7}, -- Cinnabar {x = 742, y = 1328, z = 7}
[33692] = {x=702,y=837,z=6}, -- pewter {x = 702, y = 837, z = 6}
[33693] = {x=1044,y=884,z=7}, -- cerulean {x = 1044, y = 884, z = 7}
[33694] = {x=1038,y=1035,z=7}, -- saffron {x = 1038, y = 1035, z = 7}
[33695] = {x=1029,y=1227,z=7}, -- vermillion {x = 1029, y = 1227, z = 7}
[33696] = {x=1196,y=1478,z=7}, -- fuchsia {x = 1196, y = 1478, z = 7}
[33697] = {x=688,y=1068,z=7}, -- viridian {x = 688, y = 1068, z = 7}
[33698] = {x=848,y=1014,z=6}, -- celadon {x = 848, y = 1014, z = 6}
[33699] = {x=1188,y=1024,z=7}, -- Lavender {x = 1188, y = 1024, z = 7}
[33700] = {x=734,y=1171,z=7}, -- Pallet {x = 734, y = 1171, z = 7}
[33702] = {x=2428,y=1510,z=7}, -- Orre {x = 2428, y = 1510, z = 7}
[33703] = {x=2453,y=1645,z=7}, -- Larosse {x = 2453, y = 1645, z = 7}
[33704] = {x=2440,y=1742,z=6}, -- Canavale {x = 2440, y = 1742, z = 6}
[33705] = {x=1596,y=1192,z=7}, -- {x = 1596, y = 1192, z = 7}
[33706] = {x=1630,y=1059,z=6}, -- {x = 1630, y = 1059, z = 6}
[33707] = {x=1514,y=1013,z=7}, -- {x = 1514, y = 1013, z = 7}
[33708] = {x=1492,y=1821,z=7}, -- {x = 1492, y = 1821, z = 7}
[33709] = {x=1632,y=1668,z=7}, -- {x = 1632, y = 1668, z = 7}
[33710] = {x=822,y=2721,z=7}, -- {x = 822, y = 2721, z = 7}
[33711] = {x=816,y=2802,z=7}, -- {x = 816, y = 2802, z = 7}
[33712] = {x=900,y=2560,z=7}, -- {x = 900, y = 2560, z = 7}
[33715] = {x=1035,y=2560,z=7}, -- {x = 900, y = 2560, z = 7}
[33713] = {x=676,y=2605,z=7}, -- {x = 676, y = 2605, z = 7}
[33714] = {x=1043,y=2663,z=7}, -- {x = 1043, y = 2663, z = 7}
[33715] = {x=244,y=2494,z=7},  -- new city  {x = 1043, y = 2663, z = 7}
[33716] = {x=145,y=2333,z=7},  -- Number city  {x = 1043, y = 2663, z = 7}
}

local b = {
--[action id] = {{pos para onde ir}, {pos de volta}},
[45436] = {{x=907,y=1086,z=13}, {x=985,y=1083,z=13}}, -- Clan Psycraft
}

function onStepIn(cid, item, pos)
if isSummon(cid) then
return false
end
--
local posi = {x=1313, y=703, z=9} --posiçao do Trade Center... {x = 1313, y = 703, z = 9}
local pos = s[item.actionid]
local storage = 171877 
--
if b[item.actionid] then
   pos = b[item.actionid][2]
   posi = b[item.actionid][1] 
   storage = 171878
end
setPlayerStorageValue(cid, storage, "/"..pos.x..";"..pos.y..";"..pos.z.."/")
--
if #getCreatureSummons(cid) >= 1 then
   for i = 1, #getCreatureSummons(cid) do
       doTeleportThing(getCreatureSummons(cid)[i], {x=posi.x - 1, y=posi.y, z=posi.z}, false)
   end
end 
doTeleportThing(cid, {x=posi.x, y=posi.y, z=posi.z}, false)  
return true
end