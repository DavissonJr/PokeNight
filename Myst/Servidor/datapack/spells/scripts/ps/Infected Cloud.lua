function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Infected Cloud")

return true
end