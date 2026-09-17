function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Elecball")

return true
end