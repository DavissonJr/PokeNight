function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Crunch")

return true
end