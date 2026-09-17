InventorySlotStyles = {
  [InventorySlotHead] = "HeadSlot",
  [InventorySlotNeck] = "NeckSlot",
  [InventorySlotBack] = "BackSlot",
  [InventorySlotBody] = "BodySlot",
  [InventorySlotRight] = "RightSlot",
  [InventorySlotLeft] = "LeftSlot",
  [InventorySlotLeg] = "LegSlot",
  [InventorySlotFeet] = "FeetSlot",
  [InventorySlotFinger] = "FingerSlot",
  [InventorySlotAmmo] = "AmmoSlot",
  [InventorySlotCatchBag] = "CatchBag",
}

InventorySlotStyles2 = {
  [InventorySlotHead] = "pokebag",
  [InventorySlotNeck] = "rod",
  [InventorySlotBack] = "backpack",
  [InventorySlotBody] = "order",
  [InventorySlotRight] = "badges",
  [InventorySlotLeft] = "pokedex",
  --[[ [InventorySlotLeg] = "item", ]]
  [InventorySlotAmmo] = "coins",
  [InventorySlotCatchBag] = "catchbag",
}

-- Thalles Vitor
genders = {
  [4] = "Male",
  [3] = "Female",
  [1] = "Indefinido",
  [0] = "Indefinido",
  [-1] = "Indefinido",
}

natures = {"Hard", "Lonely", "Brave", "Bold", "Docile", "Relaxed", "Timid", "Hasty", "Serious", "Jolly", "Naive", "Modest", "Mild",
"Quiet", "Bashful", "Rash", "Calm", "Gentle", "Sassy", "Careful", "Quirky", "Adamant"}

inventoryWindow = nil
inventoryPanel = nil
inventoryButton = nil
purseButton = nil
dittoBtn = nil

local function isInArray(table, value)
  for i = 1, #table do
    if table[i] == value then
      return true
    end
  end
  
  return false
end

function init()
  connect(LocalPlayer, {
    onInventoryChange = onInventoryChange,
    onBlessingsChange = onBlessingsChange
  })

  connect(g_game, { 
    onGameStart = online, 
    onGameEnd = offline,
    onTooltip = onTooltip,
  })

  g_keyboard.bindKeyDown('Ctrl+I', toggle)

  inventoryButton = modules.client_topmenu.addRightGameToggleButton('inventoryButton', tr('Invent·rio') .. ' (Ctrl+I)', '/images/topbuttons/inventory_hover', toggle)
  inventoryButton:setOn(false)

  inventoryWindow = g_ui.loadUI('inventory', modules.game_interface.getRightPanel())
  inventoryWindow:disableResize()
  inventoryPanel = inventoryWindow:getChildById('contentsPanel')
  dittoBtn = inventoryPanel:getChildById("dittoBtn")

  refresh()
  inventoryWindow:setup()
  --inventoryWindow:hide()

  mouseGrabberWidget = g_ui.createWidget('UIWidget')
  mouseGrabberWidget:setVisible(false)
  mouseGrabberWidget:setFocusable(false)
  mouseGrabberWidget.onMouseRelease = onChooseItemMouseRelease
end

function terminate()
  disconnect(LocalPlayer, {
    onInventoryChange = onInventoryChange,
    onBlessingsChange = onBlessingsChange
  })

  disconnect(g_game, { 
    onGameStart = online,
    onGameEnd = offline,
    onTooltip = onTooltip, 
  })

  g_keyboard.unbindKeyDown('Ctrl+I')

  inventoryWindow:destroy()
  inventoryButton:destroy()
end

function refresh()
  local player = g_game.getLocalPlayer()
  for i = InventorySlotFirst, InventorySlotLast do
    if g_game.isOnline() then
      onInventoryChange(player, i, player:getInventoryItem(i))
    else
      onInventoryChange(player, i, nil)
    end
  end
end

function toggle()
  if inventoryButton:isOn() then
    inventoryWindow:close()
    inventoryButton:setOn(false)
  else
    inventoryWindow:open()
    inventoryButton:setOn(true)
  end
end

function onMiniWindowClose()
  inventoryButton:setOn(false)
end

function online()
  inventoryWindow:hide()
  inventoryButton:setOn(false)

  refresh()
end

function offline()
  inventoryWindow:hide()
end

-- hooked events
function onInventoryChange(player, slot, item, oldItem)
  local itemWidget = inventoryPanel:getChildById('slot' .. slot)
  if itemWidget then
    if item then
      itemWidget:setStyle('InventoryItem')
      itemWidget:setItem(item)

      if InventorySlotStyles2[slot] then
        itemWidget:setIcon("/images/game/slots/" .. InventorySlotStyles2[slot])
      end
    else
      itemWidget:setStyle(InventorySlotStyles[slot])
      itemWidget:setItem(nil)
    end

    -- Thalles Vitor
    if slot == 8 then
      if item then
        --
      else
        itemWidget:setTooltip("")
      end
    end
  end
end

function onBlessingsChange(player, blessings, oldBlessings)
  local hasAdventurerBlessing = Bit.hasBit(blessings, Blessings.Adventurer)
  if hasAdventurerBlessing ~= Bit.hasBit(oldBlessings, Blessings.Adventurer) then
    toggleAdventurerStyle(hasAdventurerBlessing)
  end
end

-- Thalles Vitor
function onTooltip(item)
  --[[ for i = 1, 13 do
    local itemWidget = inventoryPanel:getChildById('slot' .. i)
    if itemWidget then
      if itemWidget:getItem() == item then
        if item:getPokemon() ~= "" and item:getPokemon() ~= "poke" and isInArray(natures, item:getNature()) then
          itemWidget:setTooltip("Nome: " ..item:getPokemon() .. "\nNÌvel: " .. item:getLevel() .. "\nGÍnero: " .. genders[item:getGender()] .. "\nNature: " .. item:getNature())
        end

        if item:getPokemon() ~= "" and not isInArray(natures, item:getNature()) and item:getPokemon() ~= "portrait" then
          local desc = item:getNature()
          if desc == "" then desc = "Sem descriùùo" end
          itemWidget:setTooltip("Nome: " .. item:getPokemon() .. "\nDescriùùo: "..desc.."\n")
        end
      end
    end
  end ]]
end

function onTooltipContainers(itemWidget, item)
  if itemWidget == nil then return true end
  if item == nil then return true end

  if item:getPokemon() ~= "" and item:getPokemon() ~= "poke" and isInArray(natures, item:getNature()) then
    itemWidget:setTooltip("Nome: " ..item:getPokemon() .. "\nNÌvel: " .. item:getLevel() .. "\nGÍnero: " .. genders[item:getGender()] .. "\nNature: " .. item:getNature())
  end

  --[[ if item:getPokemon() ~= "" and not isInArray(natures, item:getNature()) and item:getPokemon() ~= "portrait" then
    local desc = item:getNature()
    if desc == "" then desc = "Sem descriùùo" end
    itemWidget:setTooltip("Nome: " .. item:getPokemon() .. "\nDescriùùo: "..desc.."\n")
  end ]]
end

function onChooseItemMouseRelease(self, mousePosition, mouseButton)
  local item = nil
  if mouseButton == MouseLeftButton then
    local clickedWidget = modules.game_interface.getRootPanel():recursiveGetChildByPos(mousePosition, false)
    if clickedWidget then
      if clickedWidget:getClassName() == 'UIGameMap' then
        local tile = clickedWidget:getTile(mousePosition)
        if tile then
          local thing = tile:getTopMoveThing()
          if thing and thing:isItem() then
            item = thing
          end
        end
      elseif clickedWidget:getClassName() == 'UIItem' and not clickedWidget:isVirtual() then
        item = clickedWidget:getItem()
      end
    end
  end

  g_mouse.popCursor('target')
  self:ungrabMouse()
  
  local player = g_game.getLocalPlayer()
  if not player then
    return true
  end

  if item then
    if not g_game.isOnline() then
      return
    end

    g_game.getProtocolGame():sendExtendedOpcode(8, item:getPosition().x.."@"..item:getPosition().y.."@"..item:getPosition().z.."@")
  end
  return true
end

function useRope()
  if not g_game.isOnline() then
    return
  end

  mouseGrabberWidget:grabMouse()
  g_mouse.pushCursor('target')
end