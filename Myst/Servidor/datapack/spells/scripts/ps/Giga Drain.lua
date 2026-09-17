function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Giga Drain")

return true
end