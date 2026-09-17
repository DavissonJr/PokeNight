function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Psy Impact")

return true
end