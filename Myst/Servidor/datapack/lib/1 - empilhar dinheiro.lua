-- Criado por Thalles Vitor --
-- Empilhar $ --

-- Criado por Thalles Vitor --
-- Empilhar Dinheiro --
--[[ local coins = {
[12416] = {to = 2148, effect = TEXTCOLOR_WHITE},
[2148] = {to = 2152, from = 12416, effect = TEXTCOLOR_YELLOW}, 
[2152] = {to = 2160, from = 2148, effect = TEXTCOLOR_YELLOW}, 
[2160] = {from = 2152, effect = TEXTCOLOR_WHITE},
} ]]

local coins = {
   [12416] = {to = 2148, effect = TEXTCOLOR_WHITE},
   [2148] = {to = 2152, from = 12416, effect = TEXTCOLOR_YELLOW}, 
   [2152] = {to = 2160, from = 2148, effect = TEXTCOLOR_YELLOW}, 
   [2160] = {from = 2152, effect = TEXTCOLOR_WHITE},
}

function doTransformInOtherCoin(cid, container)
   if not isPlayer(cid) then
      return true
   end

   --if isContainer(container) then
      for i = 0, getContainerSize(container)-1 do
         local item = getContainerItem(container, i)
         if item and item.uid > 0 and isInArray({2148, 2152, 2160, 12416}, item.itemid) and item.type >= 100 then
            local coin = coins[item.itemid]
            if coin and coin.to ~= nil then
               doTransformItem(item.uid, coin.to, 1)
            end
         end
      end
   --end
end

function doPlayerAddMoneyGame(cid, itemid) -- by mkalo
local item = getItemsInContainerById(getPlayerSlotItem(cid, 3).uid, itemid)
local piles = 0
if #item > 0 then
   for i,x in pairs(item) do
      local it = getThing(x)
      if it.itemid == itemid then
         local items = {}
         items.id = {}
         items.type = {}

         local coin = coins[it.itemid]
         table.insert(items.id, it.itemid)
         table.insert(items.type, it.type)

         doRemoveItem(it.uid, it.type)

         for i = 1, #items.id do
            addEvent(function()
               doAddContainerItem(getPlayerSlotItem(cid, 3).uid, items.id[i], items.type[i])
               doTransformInOtherCoin(cid, getPlayerSlotItem(cid, 3).uid)
            end, i * 150)
         end
      end
   end
end

local item = getItemsInContainerById(getPlayerSlotItem(cid, 10).uid, itemid)
local piles = 0
if #item > 0 then
   for i,x in pairs(item) do
      local it = getThing(x)
      if it.itemid == itemid then
         local items = {}
         items.id = {}
         items.type = {}

         local coin = coins[it.itemid]
         table.insert(items.id, it.itemid)
         table.insert(items.type, it.type)

         doRemoveItem(it.uid, it.type)

         for i = 1, #items.id do
            addEvent(function()
               doAddContainerItem(getPlayerSlotItem(cid, 10).uid, items.id[i], items.type[i])
               doTransformInOtherCoin(cid, getPlayerSlotItem(cid, 10).uid)
            end, i * 150)
         end
      end
   end
end
end

function empilhar(cid)
    if not isPlayer(cid) then
        return true
    end

    for i = 1, 12 do
      if i == 3 or i == 10 then
         local backpack = getPlayerSlotItem(cid, i)
         if backpack.uid <= 0 then return true end

         for i = 0, getContainerSize(backpack.uid)-1 do
            local item = getContainerItem(backpack.uid, i)
            local items = {}
            items.id = {}
            items.type = {}
               
            if item and item.uid > 0 and isInArray({2148, 2152, 2160, 12416}, item.itemid) and item.type >= 1 then
               doPlayerAddMoneyGame(cid, item.itemid)
               -- doAddContainerItem(getPlayerSlotItem(cid, 3).uid, items.id[i], items.type[i])
            end
         end
      end
   end
    
    return true
end