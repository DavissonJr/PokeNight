function onCastSpell(cid, var)

	if isSummon(cid) then return true end
	
	docastspell(cid, "Draining Kiss")
	
return true
end