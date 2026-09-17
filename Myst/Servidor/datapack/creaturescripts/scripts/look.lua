local NPCBattle = {
["Brock"] = {artig = "He is", cidbat = "Pewter"},
["Misty"] = {artig = "She is", cidbat = "Cerulean"}, 
["Blaine"] = {artig = "He is", cidbat = "Cinnabar"},
["Sabrina"] = {artig = "She is", cidbat = "Saffron"},         --alterado v1.9 \/ peguem tudo!
["Kira"] = {artig = "She is", cidbat = "Viridian"},
["Koga"] = {artig = "He is", cidbat = "Fushcia"},
["Erika"] = {artig = "She is", cidbat = "Celadon"},
["Surge"] = {artig = "He is", cidbat = "Vermilion"},
}

-- Thalles Vitor - House Window --
   local door_list = {6893, 1241, 1242, 1243, 1244, 1245, 1246, 1247, 1248, 1249, 1250, 1251, 1252, 1253, 1254, 1255}
   function getDoor(itemid)
      if isInArray(door_list, itemid) then
         return true
      end

      return false
   end
--

function onLook(cid, thing, position, lookDistance)                                                         
   local str = {}
                  
   -- Thalles Vitor - House Window --
      if getHouseFromPos(position) and getHouseFromPos(position) > 0 and getDoor(thing.itemid) then
         sendHouseOpcodedWindow(cid, getHouseFromPos(position))
         return true
      end
   --
			
   local iname = getItemInfo(thing.itemid)
   if iname == false then
      return false
   end

   if string.find(iname.name, "void") then
      return false
   end
   
   if string.find(iname.name, "portrait") then
      return false
   end

   if not isCreature(thing.uid) and not getItemAttribute(thing.uid, "poke") then
      if priceList[getItemInfo(thing.itemid).name] then
         price = priceList[getItemInfo(thing.itemid).name].price
         if thing.type > 1 then
            str = "Você vê um "..thing.type.." "..getItemInfo(thing.itemid).plural.."."
            price = price * thing.type
         else
            str = "Você vê um "..getItemInfo(thing.itemid).article.." "..getItemInfo(thing.itemid).name.."."
         end
         str = str.."\n Preço: "..price.."$."
         
         if getItemAttribute(thing.uid, "description") then
            str = str.."\n"..getItemAttribute(thing.uid, "description").."."
         end
         
         if getPlayerGroupId(cid) >= 4 and getPlayerGroupId(cid) <= 6 then
            str = str.."\nItemID: ["..thing.itemid.."]."    
            str = str.."\nClientID: ["..getItemInfo(thing.itemid).clientId.."]."                                                     --alterado v1.7
            local pos = getThingPos(thing.uid)
            str = str.."\nPosition: [X: "..pos.x.."][Y: "..pos.y.."][Z: "..pos.z.."]"
         end

         doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, str)
         return false
      end
   end

   if not isCreature(thing.uid) and not isMonster(thing.uid) and not isNpc(thing.uid) and getItemAttribute(thing.uid, "poke") then    
      local pokename = getItemAttribute(thing.uid, "poke")
      local boost = getItemAttribute(thing.uid, "boost") or 0

      local strPokemon = {}
      table.insert(strPokemon, "Você vê uma "..iname.name.." com um " .. pokename .. ".\n")  
      
      if getItemAttribute(thing.uid, "gender") == SEX_MALE then
         table.insert(strPokemon, "Gênero: Male.\n")
      elseif getItemAttribute(thing.uid, "gender") == SEX_FEMALE then
         table.insert(strPokemon, "Gênero: Female.\n")
      else
         table.insert(strPokemon, "Gênero: Indefinido.\n")
      end
      
      if getItemAttribute(thing.uid, "nick") then
         table.insert(strPokemon, "Nickname: "..getItemAttribute(thing.uid, "nick")..".\n")
      end

      if boost > 0 then
         table.insert(strPokemon, "Boost: +"..boost..".\n")
      end
      
      -- Thalles Vitor - Nature System --
         local nature = getItemAttribute(thing.uid, "nature")
         if nature then
            table.insert(strPokemon, "Nature: " ..nature..".\n")
         end
       --

      local level = getItemAttribute(thing.uid, "level")
      if level and level > 0 then
         table.insert(strPokemon, "Level: " .. level .. ".\n")
      end
         
      -- Sistema de Addon - Thalles Vitor
         local count = getItemAttribute(thing.uid, "addonCount") or 0
         for i = 1, count do
            local addon = getItemAttribute(thing.uid, "addonName"..i)
            if addon == getItemAttribute(thing.uid, "lastAddonName") then
               table.insert(strPokemon, "Addon: "..addon..".\n")
            end
         end

         if count > 0 then
            table.insert(strPokemon, "Addons: "..count..".\n")
         end
      --

      doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, table.concat(strPokemon))
      return false
   elseif string.find(iname.name, "fainted") or string.find(iname.name, "defeated") then     
      table.insert(str, ""..string.lower(iname.name)..". ")     
      if isContainer(thing.uid) then
         table.insert(str, "(Vol: "..getContainerCap(thing.uid)..")")
      end

      table.insert(str, "\n")
      if getItemAttribute(thing.uid, "gender") == SEX_MALE then
         table.insert(str, "It is male.\n")
      elseif getItemAttribute(thing.uid, "gender") == SEX_FEMALE then
         table.insert(str, "It is female.\n")
      else
         table.insert(str, "It is genderless.\n")
      end

      if getPlayerGroupId(cid) >= 4 and getPlayerGroupId(cid) <= 6 then
         table.insert(str, "ItemID: ["..thing.itemid.."].\n")                                                     --alterado v1.7
         local pos = getThingPos(thing.uid)
         table.insert(str, "Position: [X: "..pos.x.."][Y: "..pos.y.."][Z: "..pos.z.."]")
      end

      doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, table.concat(str))
      return false
   elseif isContainer(thing.uid) and not getItemAttribute(thing.uid, "poke") then
      if iname.name == "dead human" and getItemAttribute(thing.uid, "pName") then
         table.insert(str, "dead human (Vol:"..getContainerCap(thing.uid).."). ")
         table.insert(str, "You recognize ".. getItemAttribute(thing.uid, "pName")..". ".. getItemAttribute(thing.uid, "article").." was killed by a ")
         table.insert(str, getItemAttribute(thing.uid, "attacker")..".")
      else   
         table.insert(str, ""..iname.article.." "..iname.name..". (Vol:"..getContainerCap(thing.uid)..").")
      end

      if getPlayerGroupId(cid) >= 4 and getPlayerGroupId(cid) <= 6 then
         table.insert(str, "\nItemID: ["..thing.itemid.."]")  
         table.insert(str, "\nClientID: ["..getItemInfo(thing.itemid).clientId.."].")                                                  --alterado v1.7   
         local pos = getThingPos(thing.uid)
         table.insert(str, "\nPosition: [X: "..pos.x.."][Y: "..pos.y.."][Z: "..pos.z.."]")  
      end

      doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, table.concat(str))
      return false
   end

   if isNpc(thing.uid) and NPCBattle[getCreatureName(thing.uid)] then    --npcs duel
      table.insert(str, ""..getCreatureName(thing.uid)..". "..NPCBattle[getCreatureName(thing.uid)].artig.." leader of the gym from "..NPCBattle[npcname].cidbat..".")
      doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, table.concat(str))
      return false
   end

   if not isPlayer(thing.uid) and not isMonster(thing.uid) and isNpc(thing.uid) then    --outros npcs
      table.insert(str, ""..getCreatureName(thing.uid)..".")
      doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, table.concat(str))
      return false
   end

   if isPlayer(thing.uid) then
      doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, getPlayerDesc(cid, thing.uid, false))  
   return false
   end

   if isMonster(thing.uid) and not isSummon(thing.uid) then
      table.insert(str, "Você vê "..getCreatureName(thing.uid)..".\n")
     -- table.insert(str, "Hit Points: "..getCreatureHealth(thing.uid).." / "..getCreatureMaxHealth(thing.uid)..".\n")
      
      if getPokemonGender(thing.uid) == SEX_MALE then
         table.insert(str, "Ele é macho.")
      elseif getPokemonGender(thing.uid) == SEX_FEMALE then
         table.insert(str, "Ela é fêmea.")
      else
         table.insert(str, "Ele é indefinido.")
      end

      doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, table.concat(str))
      return false
   elseif isSummon(thing.uid) and not isPlayer(thing.uid) then  --summons
      local boostlevel = getItemAttribute(getPlayerSlotItem(getCreatureMaster(thing.uid), 8).uid, "boost") or 0
      local myball = getPlayerSlotItem(cid, 8).uid
      
      table.insert(str, "Você vê "..getCreatureName(thing.uid)..".\n")
      table.insert(str, "Ele pertence a " .. getCreatureName(getCreatureMaster(thing.uid)) .. ".\n")
      doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, table.concat(str))
      return false
   end
   return true
end
