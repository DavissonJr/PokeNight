function onCastSpell(cid, var)

	if isSummon(cid) then return true end
	
	docastspell(cid, "Giant Punch")
	
return true
end