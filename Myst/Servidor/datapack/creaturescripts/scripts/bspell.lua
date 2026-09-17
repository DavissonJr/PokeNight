function onAdvance(cid, skill, oldLevel, newLevel)
if skill ~= 8 then return true end
sendSpellsForBarSpell(cid)                 
return true
end