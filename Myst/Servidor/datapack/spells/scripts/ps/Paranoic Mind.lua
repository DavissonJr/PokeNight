function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Paranoic Mind")

return true
end