function onUse(cid, item, fromPosition, itemEx, toPosition)

if item.actionid == 55356 then
   local str = getRankGolden()
   if str ~= "" then
      doShowTextDialog(cid, 6527, str)                   --alterado v1.7
   else
      doShowTextDialog(cid, 6527, "A error are occored! Sorry...")
      print("A Error occored with the Rank of the Golden Arena!")
   end
return true
end
end