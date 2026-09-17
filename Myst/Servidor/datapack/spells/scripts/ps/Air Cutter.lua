function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Air Cutter")

return true
end