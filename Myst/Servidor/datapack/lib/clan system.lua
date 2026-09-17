local clansAtk = {
[1] = 	{
			[FIREDAMAGE] = 	{
								[1] = {atk = 1.17},
								[2] = {atk = 1.22},
								[3] = {atk = 1.27},
								[4] = {atk = 1.32},
								[5] = {atk = 1.37},
							},
			["null"] =  		{
							},
		},
[2] = 	{
			[WATERDAMAGE] = {
								[1] = {atk = 1.05},
								[2] = {atk = 1.10},
								[3] = {atk = 1.15},
								[4] = {atk = 1.20},
								[5] = {atk = 1.25},
							},
			[ICEDAMAGE] =   {
								[1] = {atk = 1.10},
								[2] = {atk = 1.15},
								[3] = {atk = 1.20},
								[4] = {atk = 1.25},
								[5] = {atk = 1.30},
							},
		},
[3] = 	{
			[ROCKDAMAGE] =  {
								[1] = {atk = 1.05},
								[2] = {atk = 1.10},
								[3] = {atk = 1.15},
								[4] = {atk = 1.20},
								[5] = {atk = 1.25},
							},
		   [GROUNDDAMAGE] = {
								[1] = {atk = 1.05},
								[2] = {atk = 1.10},
								[3] = {atk = 1.15},
								[4] = {atk = 1.20},
								[5] = {atk = 1.25},
							},
		},
[4] = 	{
			[FLYDAMAGE] =  	{
								[1] = {atk = 1.15},
								[2] = {atk = 1.20},
								[3] = {atk = 1.25},
								[4] = {atk = 1.30},
								[5] = {atk = 1.35},
							},
		   [DRAGONDAMAGE] = {
								[1] = {atk = 1.10},
								[2] = {atk = 1.15},
								[3] = {atk = 1.20},
								[4] = {atk = 1.25},
								[5] = {atk = 1.30},
							},
		},
[5] = 	{
		   [GHOSTDAMAGE] =  {
								[1] = {atk = 1.05},
								[2] = {atk = 1.10},
								[3] = {atk = 1.15},
								[4] = {atk = 1.20},
								[5] = {atk = 1.25},
							},
		   [POISONDAMAGE] = {
								[1] = {atk = 1.08},
								[2] = {atk = 1.13},
								[3] = {atk = 1.18},
								[4] = {atk = 1.23},
								[5] = {atk = 1.28},
							},
		},
[6] = 	{
			[FIGHTDAMAGE] = {
								[1] = {atk = 1.05},
								[2] = {atk = 1.10},
								[3] = {atk = 1.15},
								[4] = {atk = 1.20},
								[5] = {atk = 1.25},
							},
		   [NORMALDAMAGE] = {
								[1] = {atk = 1.05},
								[2] = {atk = 1.10},
								[3] = {atk = 1.15},
								[4] = {atk = 1.20},
								[5] = {atk = 1.25},
							},
		},
[7] = 	{
		 [PSYCHICDAMAGE] =  {
								[1] = {atk = 1.10},
								[2] = {atk = 1.15},
								[3] = {atk = 1.20},
								[4] = {atk = 1.25},
								[5] = {atk = 1.30},
							},
			["null"] = 		{
							},
		},
[8] = 	{
		   [GRASSDAMAGE] =  {
								[1] = {atk = 1.05},
								[2] = {atk = 1.10},
								[3] = {atk = 1.15},
								[4] = {atk = 1.20},
								[5] = {atk = 1.25},
							},
		   [BUGDAMAGE] = 	{
								[1] = {atk = 1.05},
								[2] = {atk = 1.10},
								[3] = {atk = 1.15},
								[4] = {atk = 1.20},
								[5] = {atk = 1.25},
							},
		},
[9] = 	{
		 [ELECTRICDAMAGE] = {
								[1] = {atk = 1.12},
								[2] = {atk = 1.17},
								[3] = {atk = 1.22},
								[4] = {atk = 1.27},
								[5] = {atk = 1.32},
							},
			["null"] = 		{
							},
		}
}

local clansDef = {
[1] = 	{
			["fire"] = 	{
							[1] = {def = 0.17},
							[2] = {def = 0.22},
							[3] = {def = 0.27},
							[4] = {def = 0.32},
							[5] = {def = 0.37},
						},
			["null"] =  {
						},
        },
[2] =   {
			["water"] = {
							[1] = {def = 0.05},
							[2] = {def = 0.10},
							[3] = {def = 0.15},
							[4] = {def = 0.20},
							[5] = {def = 0.25},
						},
			["ice"] = 	{
							[1] = {def = 0.10},
							[2] = {def = 0.15},
							[3] = {def = 0.20},
							[4] = {def = 0.25},
							[5] = {def = 0.30},
						},
		},
[3] =	{
			["rock"] = 	{
							[1] = {def = 0.05},
							[2] = {def = 0.10},
							[3] = {def = 0.15},
							[4] = {def = 0.20},
							[5] = {def = 0.25},
						},
		   ["ground"] = {
							[1] = {def = 0.10},
							[2] = {def = 0.15},
							[3] = {def = 0.20},
							[4] = {def = 0.25},
							[5] = {def = 0.30},
						},
		},
[4] =   {
		  ["flying"] =  {
							[1] = {def = 0.15},
							[2] = {def = 0.20},
							[3] = {def = 0.25},
							[4] = {def = 0.30},
							[5] = {def = 0.35},
						},
		   ["dragon"] = {
							[1] = {def = 0.10},
							[2] = {def = 0.15},
							[3] = {def = 0.20},
							[4] = {def = 0.25},
							[5] = {def = 0.30},
						},
		},
[5] = 	{
			["ghost"] = {
							[1] = {def = 0.05},
							[2] = {def = 0.10},
							[3] = {def = 0.15},
							[4] = {def = 0.20},
							[5] = {def = 0.25},
						},
		   ["poison"] = {
							[1] = {def = 0.08},
							[2] = {def = 0.13},
							[3] = {def = 0.18},
							[4] = {def = 0.23},
							[5] = {def = 0.28},
						},
		},
[6] =   {
		 ["fighting"] = {
							[1] = {def = 0.05},
							[2] = {def = 0.10},
							[3] = {def = 0.15},
							[4] = {def = 0.20},
							[5] = {def = 0.25},
						},
		   ["normal"] = {
							[1] = {def = 0.05},
							[2] = {def = 0.10},
							[3] = {def = 0.15},
							[4] = {def = 0.20},
							[5] = {def = 0.25},
						},
		},
[7] =   {
		  ["psychic"] = {
							[1] = {def = 0.10},
							[2] = {def = 0.15},
							[3] = {def = 0.20},
							[4] = {def = 0.25},
							[5] = {def = 0.30},
						},
			["null"] =  {
						},
		},
[8] =   {
			["grass"] = {
							[1] = {def = 0.05},
							[2] = {def = 0.10},
							[3] = {def = 0.15},
							[4] = {def = 0.20},
							[5] = {def = 0.25},
						},
			["bug"] =   {
							[1] = {def = 0.05},
							[2] = {def = 0.10},
							[3] = {def = 0.15},
							[4] = {def = 0.20},
							[5] = {def = 0.25},
						},
		},
[9] =   {
		["electric"] = {
							[1] = {def = 0.12},
							[2] = {def = 0.17},
							[3] = {def = 0.22},
							[4] = {def = 0.27},
							[5] = {def = 0.32},
						},
		}
}                        

local clansName = {
--[num do clan] = {nome do clan, storage outfit normal, storage outfit rank5},
[1] = {'Volcanic', 181613, 181625},
[2] = {'Seavell', 181619, 181622},
[3] = {'Orebound', 181620, 181627},
[4] = {'Wingeon', 181616, 181626},
[5] = {'Malefic', 181615, 181624},
[6] = {'Gardestrike', 181614, 181628},
[7] = {'Psycraft', 181618, 181629},
[8] = {'Naturia', 181612, 181623},
[9] = {'Raibolt', 181617, 181621},
}


function getClanPorcent(master, combat, option, type, type2)         --alterado v1.9 \/
if getPlayerClanNum(master) >= 1 then        
   local clanAtk = clansAtk[getPlayerClanNum(master)]
   local clanDef = clansDef[getPlayerClanNum(master)]

   if option == "atk" and clanAtk[combat] then
      return clanAtk[combat][getPlayerClanRank(master)].atk
   else
      if option == "def" and clanDef[type] then                                
         return clanDef[type][getPlayerClanRank(master)].def
      elseif option == "def" and clanDef[type2] then
         return clanDef[type2][getPlayerClanRank(master)].def
      end
   end
end 
return option == "atk" and 1 or 0
end

function getPlayerClanName(cid)
if not isCreature(cid) then return 'No Clan!' end
return clansName[getPlayerClanNum(cid)] and clansName[getPlayerClanNum(cid)][1] or 'No Clan!'
end

function getPlayerClanNum(cid)
if not isCreature(cid) then return -1 end
return getPlayerStorageValue(cid, 86228)
end

function getPlayerClanRank(cid)
if not isCreature(cid) then return -1 end
return getPlayerStorageValue(cid, 862281)
end

function setPlayerClan(cid, clan)
if not isCreature(cid) or not clan then return false end
if removePlayerClan(cid) then  --para evitar possiveis problemas!
   if type(clan) == "number" and (clan >= 1 and clan <= 9) then
      setPlayerStorageValue(cid, 86228, clan)    --sto clan
      setPlayerClanRank(cid, 1)                  --set rank 1
      setPlayerStorageValue(cid, clansName[clan][2], 1)   --sto roupa
      return true
   elseif type(clan) == "string" then
      clan = string.lower(clan)
      for e, f in pairs(clansName) do
          local clan2 = string.lower(f[1])
          if clan == clan2 then
             setPlayerStorageValue(cid, 86228, e)  --sto clan
             setPlayerClanRank(cid, 1)             --set rank 1
             setPlayerStorageValue(cid, clansName[e][2], 1)   --sto roupa
             return true
          end
      end
   end
end
return false 
end

function setPlayerClanRank(cid, rank)
if not isCreature(cid) or not rank then return false end
if type(rank) == "number" and (rank >= 1 and rank <= 5) then
   setPlayerStorageValue(cid, 862281, rank)
   if rank == 5 then 
      setPlayerStorageValue(cid, clansName[getPlayerClanNum(cid)][3], 1)
   end
   return true
end
return false
end 

function removePlayerClan(cid)
if not isCreature(cid) then return false end
if getPlayerStorageValue(cid, 854789) >= 1 then return false end --nao pode remover o clan se o player tiver fazendo missoes de rank!
   setPlayerStorageValue(cid, 86228, -1) --sto do clan
   setPlayerStorageValue(cid, 862281, -1) --sto do rank
   setPlayerStorageValue(cid, 854789, -1) --sto da quest de rank
   setPlayerStorageValue(cid, 854788, -1) --sto catch, quest de rank
   setPlayerStorageValue(cid, 854787, -1) --sto task, quest de rank
   for i = 181612, 181638 do
       setPlayerStorageValue(cid, i, -1)  --sto das roupas de clan
   end
return true
end    

function checkItensForTask(cid, itens)
local check = 0 
local array = {}
local missing = {}
table.insert(missing, "Are missing: ")
local c = 0
    for i = 1, #itens do
        if getPlayerItemCount(cid, itens[i][1]) >= itens[i][2] then
           check = check + 1
        else
           table.insert(array, {itens[i][1], (itens[i][2]-getPlayerItemCount(cid, itens[i][1]))})
        end       
    end
if check == #itens then
   for b = 1, #itens do
       doPlayerRemoveItem(cid, itens[b][1], itens[b][2])
   end
   return 0 
else
   for a = 1, #array do
       table.insert(missing, ((a == #array and c ~= 0) and " and " or a ~= 1 and ", " or "{")..(array[a][2]).." "..(getItemNameById(array[a][1])))
       c = c+1
   end
   table.insert(missing, "} yet.") 
   return table.concat(missing)
end
end

function checkPokemonForTask(cid, poke)
local pbs = getPokeballsInContainer(getPlayerSlotItem(cid, 3).uid)
local slot = getPlayerSlotItem(cid, 8)
if slot.itemid > 0 and isPokeball(slot.itemid) then
   if getItemAttribute(slot.uid, "poke") == poke and getItemAttribute(slot.uid, "task") and getItemAttribute(slot.uid, "task") >= 1 then
      doRemoveItem(slot.uid, 1)
      doTransformItem(getPlayerSlotItem(cid, CONST_SLOT_LEGS).uid, 2395)
      return true
   end
end
for i = 1, #pbs do
    if getItemAttribute(pbs[i], "poke") == poke and getItemAttribute(pbs[i], "task") and getItemAttribute(pbs[i], "task") >= 1 then
      doRemoveItem(pbs[i], 1)
      return true
   end
end
return false
end      