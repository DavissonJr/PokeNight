function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Fury Swipes")

return true
end