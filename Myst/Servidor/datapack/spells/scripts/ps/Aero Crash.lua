function onCastSpell(cid, var)

	if isSummon(cid) then return true end
	
	docastspell(cid, "Aero Crash")
	
return true
end