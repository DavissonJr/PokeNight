function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Steel Wing")

return true
end