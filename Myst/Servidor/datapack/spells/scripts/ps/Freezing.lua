function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Freezing")

return true
end