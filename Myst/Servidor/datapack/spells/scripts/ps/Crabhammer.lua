function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Crabhammer")

return true
end