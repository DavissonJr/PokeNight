function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Bonemerang")

return true
end