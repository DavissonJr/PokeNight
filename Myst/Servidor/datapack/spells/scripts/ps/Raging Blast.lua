function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Raging Blast")

return true
end