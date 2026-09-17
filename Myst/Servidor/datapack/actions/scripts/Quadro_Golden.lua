function onUse(cid, item, fromPosition, itemEx, toPosition)

if item.actionid == 65535 then                         --alterado v1.9 \/
   local timeDiff = showTimeDiff(nextHorario(cid))
   local str = {}
                                                    
   table.insert(str, "Golden Survival Arena\n")   
   table.insert(str, "Next Event in "..timeDiff..".\n\n")
   
   if getGlobalStorageValue(22549) ~= -1 then
      local s = string.explode(getGlobalStorageValue(22549), ",")
      for i = 1, 15 do
          if s[i] and s[i] ~= "" then
             table.insert(str, "["..i.."] - "..s[i].."\n")
          else                                                  
             table.insert(str, "["..i.."] - Empty\n")
          end
      end
   else
      for a = 1, 15 do
          table.insert(str, "["..a.."] - Empty\n")
      end
   end
   doShowTextDialog(cid, 6527, table.concat(str))
return true
end
end