-- Criado por Thalles Vitor --
-- Auto Catch - Corpse --

function onExtendedOpcode(cid, opcode, buffer)
   if not isPlayer(cid) then return true end
   if opcode == 215 then
      local param = buffer:explode("@")
      local x = tonumber(param[1])
      local y = tonumber(param[2])
      local z = tonumber(param[3])
      local pos = {x=x, y=y, z=z}
      local corpse = getTopCorpse(pos)
      if corpse.uid <= 0 then
         return true
      end

      if getItemInfo(corpse.itemid) ~= false then
         local name = getItemInfo(corpse.itemid).name
         if string.find(getItemInfo(corpse.itemid).name, "fainted ") or string.find(getItemInfo(corpse.itemid).name, "defeated ") then
            name = string.gsub(name, "fainted ", "")
            name = string.gsub(name, "defeated " , "")
            name = doCorrectString(name)

            if getPlayerItemCount(cid, 2394) >= 1 then
               doCreatureExecuteTalkAction(cid, "!autocatch normal, " .. name)
            elseif getPlayerItemCount(cid, 2391) >= 1 then
               doCreatureExecuteTalkAction(cid, "!autocatch great, " .. name)
            elseif getPlayerItemCount(cid, 2393) >= 1 then
               doCreatureExecuteTalkAction(cid, "!autocatch super, " .. name)
            elseif getPlayerItemCount(cid, 2394) >= 1 then
               doCreatureExecuteTalkAction(cid, "!autocatch ultra, " .. name)
            end
         end
      end
   end
   return true
end