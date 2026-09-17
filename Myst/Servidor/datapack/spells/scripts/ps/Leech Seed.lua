function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Leech Seed")

return true
end