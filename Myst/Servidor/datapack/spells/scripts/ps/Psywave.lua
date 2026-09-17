function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Psywave")

return true
end