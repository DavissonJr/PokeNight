function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Fury Cutter")

return true
end