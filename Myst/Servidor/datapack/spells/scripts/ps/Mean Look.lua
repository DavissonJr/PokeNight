function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Mean Look")

return true
end