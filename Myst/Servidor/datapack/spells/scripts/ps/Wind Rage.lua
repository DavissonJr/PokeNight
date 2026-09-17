function onCastSpell(cid, var)

	if isSummon(cid) then return true end
	
	docastspell(cid, "Wind Rage")
	
return true
end