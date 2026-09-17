function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Great Love")

return true
end