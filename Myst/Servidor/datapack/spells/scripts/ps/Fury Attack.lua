function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Fury Attack")

return true
end